export hs6_autodiff

<<<<<<< HEAD
function hs6_autodiff(::Type{T} = Float64; kwargs...) where {T}
  x0 = T[-1.2; 1.0]
  f(x) = (1 - x[1])^2
  c(x) = [10 * (x[2] - x[1]^2)]
  lcon = T[0.0]
  ucon = T[0.0]

  return ADNLPModel(f, x0, c, lcon, ucon, name = "hs6_autodiff"; kwargs...)
=======
function hs6_autodiff()
  x0 = [-1.2; 1.0]
  f(x) = (1 - x[1])^2
  c(x) = [10 * (x[2] - x[1]^2)]
  lcon = [0.0]
  ucon = [0.0]

  return ADNLPModel(f, x0, c, lcon, ucon, name="hs6_autodiff")
>>>>>>> f36d5df (sparse-dev)
end
