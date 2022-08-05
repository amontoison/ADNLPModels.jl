export lincon_autodiff

<<<<<<< HEAD
function lincon_autodiff(::Type{T} = Float64; kwargs...) where {T}
  A = T[1 2; 3 4]
  b = T[5; 6]
  B = diagm(T[3 * i for i = 3:5])
  c = T[1; 2; 3]
  C = T[0 -2; 4 0]
  d = T[1; -1]

  x0 = zeros(T, 15)
  f(x) = sum(i + x[i]^4 for i = 1:15)

  lcon = T[22.0; 1.0; -Inf; -11.0; -d; -b; -Inf * ones(3)]
  ucon = T[22.0; Inf; 16.0; 9.0; -d; Inf * ones(2); c]

  clinrows = [1,   2,  2,  2,  3,  3, 4, 4, 5, 6, 7, 8, 7, 8, 9, 10, 11]
  clincols = [15, 10, 11, 12, 13, 14, 8, 9, 7, 6, 1, 1, 2, 2, 3,  4, 5]
  clinvals = vcat(T(15), c, d, b, C[1, 2], C[2, 1], A[:], diag(B))

  return ADNLPModel(f, x0, clinrows, clincols, clinvals, lcon, ucon, name = "lincon_autodiff", lin = collect(1:11); kwargs...)
=======
function lincon_autodiff()

  A = [1 2; 3 4]
  b = [5; 6]
  B = diagm([3 * i for i = 3:5])
  c = [1; 2; 3]
  C = [0 -2; 4 0]
  d = [1; -1]

  x0 = zeros(15)
  f(x) = sum(i + x[i]^4 for i = 1:15)
  con(x) = [15 * x[15];
            c' * x[10:12];
            d' * x[13:14];
            b' * x[8:9];
            C * x[6:7];
            A * x[1:2];
            B * x[3:5]]

  lcon = [22.0; 1.0; -Inf; -11.0; -d;            -b; -Inf * ones(3)]
  ucon = [22.0; Inf; 16.0;   9.0; -d; Inf * ones(2);              c]

  return ADNLPModel(f, x0, con, lcon, ucon, name="lincon_autodiff")
>>>>>>> f36d5df (sparse-dev)
end
