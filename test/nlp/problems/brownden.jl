export brownden_autodiff

<<<<<<< HEAD
function brownden_autodiff(::Type{T} = Float64; kwargs...) where {T}
  x0 = T[25.0; 5.0; -5.0; -1.0]
  f(x) = begin
    s = zero(T)
    for i = 1:20
      s +=
        (
          (x[1] + x[2] * T(i) / 5 - exp(T(i) / 5))^2 +
          (x[3] + x[4] * sin(T(i) / 5) - cos(T(i) / 5))^2
        )^2
=======
function brownden_autodiff()

  x0 = [25.0; 5.0; -5.0; -1.0]
  f(x) = begin
    T = eltype(x)
    s = zero(T)
    for i = 1:20
      s += ((x[1] + x[2] * T(i)/5 - exp(T(i)/5))^2 + (x[3] + x[4] * sin(T(i)/5) - cos(T(i)/5))^2)^2
>>>>>>> f36d5df (sparse-dev)
    end
    return s
  end

<<<<<<< HEAD
  return ADNLPModel(f, x0, name = "brownden_autodiff"; kwargs...)
=======
  return ADNLPModel(f, x0, name="brownden_autodiff")
>>>>>>> f36d5df (sparse-dev)
end
