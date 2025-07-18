using LinearAlgebra
using Random
using JSON

# EVOLVE-BLOCK-START
"""
    solve_quadratic_matrix_equation(A, B, C; initial_guess=zeros(size(A)), tol=1e-14, max_iter=50000)

Solve the matrix equation `A*X^2 + B*X + C = 0` using a fixed-point quadratic iteration.
Returns `(X, iterations, residual)` where `residual` is `norm(A*X^2 + B*X + C)`.
"""
function solve_quadratic_matrix_equation(A::AbstractMatrix{T},
                                          B::AbstractMatrix{T},
                                          C::AbstractMatrix{T};
                                          initial_guess=zeros(T, size(A)),
                                          tol::Float64=1e-14,
                                          max_iter::Int=50000) where {T<:Real}
    Bfac = lu(B)
    A_bar = Bfac \ A
    C_bar = Bfac \ C
    X = copy(initial_guess)
    X_next = similar(X)
    for iter in 1:max_iter
        mul!(X_next, X, X)                # X_next = X*X
        mul!(X_next, A_bar, X_next, -1, 0) # X_next = -A_bar*(X*X)
        X_next .-= C_bar                   # subtract C_bar
        if norm(X_next - X) < tol
            residual = norm(A * X_next * X_next + B * X_next + C)
            return X_next, iter, residual
        end
        copy!(X, X_next)
    end
    residual = norm(A * X * X + B * X + C)
    return X, max_iter, residual
end
# EVOLVE-BLOCK-END

function run_example()
    Random.seed!(0)
    n = 2
    A = randn(n, n)
    B = randn(n, n)
    C = randn(n, n)

    result, elapsed, allocated, gctime, memallocs = @timed solve_quadratic_matrix_equation(A, B, C)
    X, iters, residual = result
    metrics = Dict(
        "iterations" => iters,
        "error" => residual,
        "execution_time" => elapsed,
        "allocations" => allocated
    )
    println(JSON.json(metrics))
end

if abspath(PROGRAM_FILE) == @__FILE__
    run_example()
end
