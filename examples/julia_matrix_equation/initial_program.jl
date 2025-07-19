using LinearAlgebra
using Random
using JSON
using BenchmarkTools

# EVOLVE-BLOCK-START
function solve_quadratic_matrix_equation(
    A::AbstractMatrix{T},
    B::AbstractMatrix{T},
    C::AbstractMatrix{T};
    initial_guess=zeros(size(A)),
    tol=1e-14,
    max_iter=50000,
) where {T<:Real}
    F = lu(B)
    A_bar = F \ A
    C_bar = F \ C

    X = copy(initial_guess)
    X_new = similar(X)
    X2 = similar(X)
    diff = similar(X)

    for iter in 1:max_iter
        mul!(X2, X, X)         # X2 = X * X
        mul!(X_new, A_bar, X2) # X_new = A_bar * X2
        axpy!(1, C_bar, X_new) # X_new += C_bar
        lmul!(-1, X_new)       # X_new = -X_new

        copy!(diff, X_new)
        axpy!(-1, X, diff)

        if norm(diff) <= tol
            return X_new, iter
        end

        copy!(X, X_new)
    end

    return X, max_iter
end
# EVOLVE-BLOCK-END

function generate_problem(n::Int = 2, seed::Int = 0)
    Random.seed!(seed)
    A = 0.1 .* randn(n, n)
    B = I + 0.05 .* randn(n, n)
    C = -0.5 .* I + 0.05 .* randn(n, n)
    return A, B, C
end

function main()
    A, B, C = generate_problem()

    trial = @benchmark solve_quadratic_matrix_equation($A, $B, $C) samples=1 evals=1
    exec_time = trial.time / 1e9
    alloc = trial.memory
    X, iters = solve_quadratic_matrix_equation(A, B, C)
    residual = norm(A * X * X + B * X + C)

    result = Dict(
        "iterations" => iters,
        "time" => exec_time,
        "allocations" => alloc,
        "residual" => residual,
    )
    return result
end

if abspath(PROGRAM_FILE) == @__FILE__
    println(JSON.json(main()))
end
