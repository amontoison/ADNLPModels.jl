"""
    ADModelBackend(gradient_backend, hprod_backend, jprod_backend, jtprod_backend, jacobian_backend, hessian_backend, ghjvprod_backend)

Structure that define the different backend used to compute automatic differentiation of an `ADNLPModel`/`ADNLSModel` model.
The different backend are all subtype of `ADBackend` and are respectively used for:
  - gradient computation;
  - hessian-vector products;
  - jacobian-vector products;
  - transpose jacobian-vector products;
  - jacobian computation;
  - hessian computation;
  - directional second derivative computation, i.e. gᵀ ∇²cᵢ(x) v.

The default constructor is 
    ADModelBackend(nvar, f, ncon = 0, c::Function = (args...) -> []; kwargs...)

where the `kwargs` are either the different backends as listed below or arguments passed to the backend's constructors:
  - `gradient_backend = ForwardDiffADGradient`;
  - `hprod_backend = ForwardDiffADHvprod`;
  - `jprod_backend = ForwardDiffADJprod`;
  - `jtprod_backend = ForwardDiffADJtprod`;
  - `jacobian_backend = ForwardDiffADJacobian`;
  - `hessian_backend = ForwardDiffADHessian`;
  - `ghjvprod_backend = ForwardDiffADGHjvprod`.
"""
struct ADModelBackend{GB, HvB, JvB, JtvB, JB, HB, GHJ}
  gradient_backend::GB
  hprod_backend::HvB
  jprod_backend::JvB
  jtprod_backend::JtvB
  jacobian_backend::JB
  hessian_backend::HB
  ghjvprod_backend::GHJ
end

function Base.show(
  io::IO,
  backend::ADModelBackend{GB, HvB, JvB, JtvB, JB, HB, GHJ},
) where {GB, HvB, JvB, JtvB, JB, HB, GHJ}
  print(io, replace(
    "ADModelBackend{
  $GB,
  $HvB,
  $JvB,
  $JtvB,
  $JB,
  $HB,
  $GHJ,
}",
    "ADNLPModels." => "",
  ))
end

function ADModelBackend(
  nvar::Integer,
  f,
  ncon::Integer = 0,
  c::Function = (args...) -> [];
  gradient_backend::Type{GB} = ForwardDiffADGradient,
  hprod_backend::Type{HvB} = ForwardDiffADHvprod,
  jprod_backend::Type{JvB} = ForwardDiffADJprod,
  jtprod_backend::Type{JtvB} = ForwardDiffADJtprod,
  jacobian_backend::Type{JB} = ForwardDiffADJacobian,
  hessian_backend::Type{HB} = ForwardDiffADHessian,
  ghjvprod_backend::Type{GHJ} = ForwardDiffADGHjvprod,
  kwargs...,
) where {GB, HvB, JvB, JtvB, JB, HB, GHJ}
  return ADModelBackend(
    GB(nvar, f, ncon; kwargs...),
    HvB(nvar, f, ncon; kwargs...),
    JvB(nvar, f, ncon; kwargs...),
    JtvB(nvar, f, ncon; kwargs...),
    JB(nvar, f, ncon; kwargs...),
    HB(nvar, f, ncon; kwargs...),
    GHJ(nvar, f, ncon; kwargs...),
  )
end

abstract type ADBackend end

"""
    get_nln_nnzj(::ADBackend, nvar, ncon)
    get_nln_nnzj(b::ADModelBackend, nvar, ncon)

For a given `ADBackend` of a problem with `nvar` variables and `ncon` constraints, return the number of nonzeros in the Jacobian of nonlinear constraints.
If `b` is the `ADModelBackend` then `b.jacobian_backend` is used.
"""
function get_nln_nnzj(b::ADModelBackend, nvar, ncon)
  get_nln_nnzj(b.jacobian_backend, nvar, ncon)
end

function get_nln_nnzj(::ADBackend, nvar, ncon)
  nvar * ncon
end

"""
    get_nln_nnzh(::ADBackend, nvar)
    get_nln_nnzh(b::ADModelBackend, nvar)

For a given `ADBackend` of a problem with `nvar` variables, return the number of nonzeros in the lower triangle of the Hessian.
If `b` is the `ADModelBackend` then `b.hessian_backend` is used.
"""
function get_nln_nnzh(b::ADModelBackend, nvar)
  get_nln_nnzh(b.hessian_backend, nvar)
end

function get_nln_nnzh(::ADBackend, nvar)
  nvar * (nvar + 1) / 2
end

throw_error(b) =
  throw(ArgumentError("The AD backend $b is not loaded. Please load the corresponding AD package."))
gradient(b::ADBackend, ::Any, ::Any) = throw_error(b)
gradient!(b::ADBackend, ::Any, ::Any, ::Any) = throw_error(b)
jacobian(b::ADBackend, ::Any, ::Any) = throw_error(b)
hessian(b::ADBackend, ::Any, ::Any) = throw_error(b)
Jprod(b::ADBackend, ::Any, ::Any, ::Any) = throw_error(b)
Jtprod(b::ADBackend, ::Any, ::Any, ::Any) = throw_error(b)
Hvprod(b::ADBackend, ::Any, ::Any, ::Any) = throw_error(b)
directional_second_derivative(::ADBackend, ::Any, ::Any, ::Any, ::Any) = throw_error(b)
function hess_structure!(
  b::ADBackend,
  nlp,
  rows::AbstractVector{<:Integer},
  cols::AbstractVector{<:Integer},
)
  n = nlp.meta.nvar
  I = ((i, j) for i = 1:n, j = 1:n if i ≥ j)
  rows .= getindex.(I, 1)
  cols .= getindex.(I, 2)
  return rows, cols
end
function hess_coord!(b::ADBackend, nlp, x::AbstractVector, ℓ::Function, vals::AbstractVector)
  Hx = hessian(b, ℓ, x)
  k = 1
  for j = 1:(nlp.meta.nvar)
    for i = j:(nlp.meta.nvar)
      vals[k] = Hx[i, j]
      k += 1
    end
  end
  return vals
end
function jac_structure!(
  b::ADBackend,
  nlp,
  rows::AbstractVector{<:Integer},
  cols::AbstractVector{<:Integer},
)
  m, n = nlp.meta.nnln, nlp.meta.nvar
  I = ((i, j) for i = 1:m, j = 1:n)
  rows .= getindex.(I, 1)[:]
  cols .= getindex.(I, 2)[:]
  return rows, cols
end
function jac_coord!(b::ADBackend, nlp, x::AbstractVector, vals::AbstractVector)
  Jx = jacobian(b, nlp.c, x)
  vals .= Jx[:]
  return vals
end
