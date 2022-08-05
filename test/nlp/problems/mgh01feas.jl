export mgh01feas_autodiff

<<<<<<< HEAD
function mgh01feas_autodiff(::Type{T} = Float64; kwargs...) where {T}
  x0 = T[-1.2; 1.0]
  f(x) = zero(eltype(x))
  c(x) = [10 * (x[2] - x[1]^2)]
  lcon = T[1, 0]
  ucon = T[1, 0]

  clinrows = [1]
  clincols = [1]
  clinvals = T[1]

  return ADNLPModel(f, x0, clinrows, clincols, clinvals, c, lcon, ucon, name = "mgh01feas_autodiff"; kwargs...)
=======
function mgh01feas_autodiff()

  x0 = [-1.2; 1.0]
  f(x) = zero(eltype(x))
  c(x) = [1 - x[1]; 10 * (x[2] - x[1]^2)]
  lcon = zeros(2)
  ucon = zeros(2)

  return ADNLPModel(f, x0, c, lcon, ucon, name="mgh01feas_autodiff")
>>>>>>> f36d5df (sparse-dev)
end
