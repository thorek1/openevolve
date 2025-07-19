using LinearAlgebra
using Random
using JSON
using BenchmarkTools

include(ARGS[1])

function generate_problem(n::Int = 2, seed::Int = 0)
    Random.seed!(seed)
    A = 0.1 .* randn(n, n)
    B = I + 0.05 .* randn(n, n)
    C = -0.5 .* I + 0.05 .* randn(n, n)
    return A, B, C
end

function run_benchmark()
    A, B, C = generate_problem()
    trial = @benchmark solve_quadratic_matrix_equation($A, $B, $C) samples=1 evals=1
    exec_time = trial.time / 1e9
    alloc = trial.memory
    X, iters = solve_quadratic_matrix_equation(A, B, C)
    residual = norm(A * X * X + B * X + C)

    return Dict(
        "iterations" => iters,
        "time" => exec_time,
        "allocations" => alloc,
        "residual" => residual,
    )
end

if abspath(PROGRAM_FILE) == @__FILE__
    println(JSON.json(run_benchmark()))
end
