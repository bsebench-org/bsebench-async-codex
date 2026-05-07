# ruff: noqa: N803
"""Template external estimator adapter for BSEBench community packet v0.

Replace the estimator internals and registry names, but keep the public
``build_filter_registry()`` entrypoint. The smoke path imports this file by
path, builds a ``FilterRegistry``, and runs the factories through the runner.
"""

from __future__ import annotations

from bsebench_runner.registry import FilterRegistry


class SubmittedEstimator:
    """Minimal estimator contract example."""

    name = "SubmittedEstimator"

    def step(
        self,
        t: float,
        voltage_V: float,
        current_A: float,
        temperature_C: float,
    ) -> dict[str, float]:
        del t, current_A, temperature_C
        return {
            "voltage_predicted": float(voltage_V),
        }


def build_filter_registry() -> FilterRegistry:
    """Return runner filter factories for this submission."""
    registry = FilterRegistry()
    registry.register("SubmittedEstimator", lambda: SubmittedEstimator())
    return registry
