export hs11_autodiff

<<<<<<< HEAD
function hs11_autodiff(::Type{T} = Float64; kwargs...) where {T}
  x0 = T[4.9; 0.1]
  f(x) = (x[1] - 5)^2 + x[2]^2 - 25
  c(x) = [-x[1]^2 + x[2]]
  lcon = T[-Inf]
  ucon = T[0.0]

  return ADNLPModel(f, x0, c, lcon, ucon, name = "hs11_autodiff"; kwargs...)
=======
function hs11_autodiff()

  x0 = [4.9; 0.1]
  f(x) = (x[1] - 5)^2 + x[2]^2 - 25
  c(x) = [-x[1]^2 + x[2]]
  lcon = [-Inf]
  ucon = [0.0]

  return ADNLPModel(f, x0, c, lcon, ucon, name="hs11_autodiff")

>>>>>>> f36d5df (sparse-dev)
end
