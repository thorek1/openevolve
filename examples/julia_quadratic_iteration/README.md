# Julia Quadratic Matrix Equation Evolution

This example demonstrates how to use OpenEvolve with the Julia programming language to solve the quadratic matrix equation

\[A \* X^2 + B \* X + C = 0\]

where `A`, `B`, `C`, and the solution `X` are square matrices. The initial implementation uses a simple quadratic iteration scheme.

## Files

- `initial_program.jl` – Julia program containing the algorithm inside the **EVOLVE-BLOCK**.
- `evaluator.py` – Python evaluator that runs the Julia code and measures runtime and allocations.
- `config.yaml` – Configuration optimized for algorithm evolution.
- `requirements.txt` – Python dependencies for the evaluator.

## Prerequisites

### Julia
Install Julia (version 1.9 or later) and the JSON package:

```julia
using Pkg
Pkg.add("JSON")
```

### Python
```bash
pip install -r requirements.txt
```

## Usage

Run the evolution process:

```bash
cd examples/julia_quadratic_iteration
python ../../openevolve-run.py initial_program.jl evaluator.py --config config.yaml
```

The evaluator optimizes for minimal execution time and memory allocations while achieving a residual error below `1e-14`.
