"""Evaluator for Julia quadratic matrix equation example"""

import json
import subprocess


def evaluate(program_path: str):
    """Run the Julia solver and compute metrics"""
    try:
        result = subprocess.run([
            "julia",
            "benchmark.jl",
            program_path,
        ], capture_output=True, text=True, timeout=30)
        if result.returncode != 0:
            return {"combined_score": 0.0, "error": result.stderr}

        metrics = json.loads(result.stdout.strip().splitlines()[-1])

        if metrics.get("residual", 1.0) > 1e-14:
            metrics["combined_score"] = 0.0
        else:
            time_val = metrics.get("time", 1.0)
            alloc = metrics.get("allocations", 0.0)
            memory = metrics.get("memory", 0.0)
            metrics["combined_score"] = 1e6 / (time_val + alloc * 100 + memory)

        return metrics
    except Exception as e:
        return {"combined_score": 0.0, "error": str(e)}
