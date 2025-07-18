"""Evaluator for Julia quadratic matrix equation example"""

import json
import subprocess
from pathlib import Path
from typing import Dict


def evaluate(program_path: str) -> Dict:
    """Run the Julia program and return performance metrics."""
    try:
        result = subprocess.run(
            ["julia", program_path], capture_output=True, text=True, timeout=30
        )
        if result.returncode != 0:
            return {
                "combined_score": 0.0,
                "error": "Julia execution failed",
                "stderr": result.stderr,
            }

        # parse last line of stdout as JSON
        last_line = result.stdout.strip().splitlines()[-1]
        metrics = json.loads(last_line)

        error = float(metrics.get("error", 1.0))
        time = float(metrics.get("execution_time", 1.0))
        allocations = float(metrics.get("allocations", 0))

        # basic scoring: only accept solutions that reach desired error
        if error > 1e-14:
            score = 0.0
        else:
            score = 1.0 / (1.0 + time + allocations / 1e6)

        metrics["combined_score"] = score
        return metrics

    except Exception as e:
        return {"combined_score": 0.0, "error": str(e)}


if __name__ == "__main__":
    import sys

    program = Path(sys.argv[1]) if len(sys.argv) > 1 else Path("initial_program.jl")
    print(evaluate(str(program)))
