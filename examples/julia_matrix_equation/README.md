# Julia Quadratic Matrix Equation Example

This example shows how OpenEvolve can evolve a Julia implementation for solving the quadratic matrix equation

\[ A \* X^2 + B \* X + C = 0 \]

The provided initial program implements a simple **quadratic iteration** method. Random matrices are created directly inside the script using `Random.seed!` for reproducibility, with eigenvalues near the unit circle to emulate stable economic problems. Runtime and allocation metrics are captured using a single `@benchmark` call from **BenchmarkTools.jl**, and the evaluator reports them once a residual below `1e-14` is reached.

## Files
- `initial_program.jl` – starting Julia implementation containing the EVOLVE-BLOCK.
- `evaluator.py` – Python evaluator that runs the Julia program and calculates metrics.
- `config.yaml` – minimal configuration tuned for this example.
- `requirements.txt` – Python dependencies (none). Julia must be installed separately.

## Usage
```bash
cd examples/julia_matrix_equation
python ../../openevolve-run.py initial_program.jl evaluator.py --config config.yaml --iterations 50
```

Ensure that `julia` is available on your PATH (version 1.9 or higher).
Before running, install the benchmarking dependency once with:

```julia
using Pkg; Pkg.add("BenchmarkTools")
```

