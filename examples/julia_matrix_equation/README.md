# Julia Quadratic Matrix Equation Example

This example shows how OpenEvolve can evolve a Julia implementation for solving the quadratic matrix equation

\[ A \* X^2 + B \* X + C = 0 \]

The solver contained in `initial_program.jl` implements a simple **quadratic iteration** method.  All benchmarking code has been moved to a separate `benchmark.jl` script so that only the function inside the EVOLVE-BLOCK is evolved.  Random matrices are generated with `Random.seed!`, and runtime/allocation metrics are gathered using a single `@benchmark` call from **BenchmarkTools.jl**.

## Files
- `initial_program.jl` – starting Julia implementation containing the EVOLVE-BLOCK.
- `benchmark.jl` – runs the solver, measures performance, and prints JSON metrics.
- `evaluator.py` – Python evaluator that calls `benchmark.jl`.
- `config.yaml` – minimal configuration tuned for this example.
- `requirements.txt` – Python dependencies (none). Julia must be installed separately.

The benchmark suite expects a function named `solve_quadratic_matrix_equation(A, B, C; initial_guess=zeros(size(A)), tol=1e-14, max_iter=50000)` in `initial_program.jl`. If you prefer another name, provide a thin wrapper with this signature so `benchmark.jl` can call it.

## Usage
```bash
cd examples/julia_matrix_equation
python ../../openevolve-run.py initial_program.jl evaluator.py --config config.yaml --iterations 50
```

Ensure that `julia` is available on your PATH (version 1.9 or higher).  Install the benchmarking dependency once with:

```julia
using Pkg; Pkg.add("BenchmarkTools")
```

