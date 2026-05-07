# ruff: noqa: N803
"""Phase 8 alpha golden estimator adapter example.

This module is intentionally self-contained so it can be inspected without
importing runner internals. The callable surface mirrors the inspected Phase 8
candidate runner contract:

    step(t, voltage_V, current_A, temperature_C) -> Mapping[str, float]

The estimator is causal. It does not read labels, metrics, split assignments,
future samples, network resources, or benchmark output artifacts.
"""

from __future__ import annotations

from dataclasses import dataclass


SUBMISSION_ID = "phase8_alpha_golden_causal_voltage_v1"
CONTRACT_VERSION = "bsebench.estimator.v1"


@dataclass
class GoldenCausalVoltageAdapter:
    """Small deterministic estimator that uses only the current observation."""

    soc_init: float = 0.5
    voltage_bias_V: float = 0.0

    def __post_init__(self) -> None:
        self._soc = min(1.0, max(0.0, float(self.soc_init)))
        self._last_t = float("-inf")

    def reset(self, *, soc_init: float | None = None) -> None:
        if soc_init is not None:
            self._soc = min(1.0, max(0.0, float(soc_init)))
        self._last_t = float("-inf")

    def step(
        self,
        t: float,
        voltage_V: float,
        current_A: float,
        temperature_C: float,
    ) -> dict[str, float]:
        t_s = float(t)
        voltage = float(voltage_V)
        current = float(current_A)
        temperature = float(temperature_C)

        if self._last_t != float("-inf"):
            dt_s = max(0.0, t_s - self._last_t)
            self._soc = min(1.0, max(0.0, self._soc - 0.00002 * current * dt_s))
        self._last_t = t_s

        thermal_offset = 0.0001 * (temperature - 25.0)
        voltage_predicted = voltage + float(self.voltage_bias_V) + thermal_offset
        return {
            "voltage_predicted": voltage_predicted,
            "soc_estimated": self._soc,
        }


def build_estimator() -> GoldenCausalVoltageAdapter:
    """Return a fresh estimator instance for each benchmark episode/config."""
    return GoldenCausalVoltageAdapter()


def build_submission_manifest() -> dict[str, object]:
    """Return the minimal manifest fields expected by the alpha examples."""
    return {
        "submission_id": SUBMISSION_ID,
        "contract_version": CONTRACT_VERSION,
        "entrypoint": "golden_causal_voltage_adapter:build_estimator",
        "output_schema": {
            "required": {"voltage_predicted": "finite float, volts"},
            "optional": {"soc_estimated": "finite float, unit interval"},
        },
        "blind_evaluation": {
            "uses_labels": False,
            "uses_metrics": False,
            "uses_future_samples": False,
            "uses_network": False,
        },
    }


if __name__ == "__main__":
    estimator = build_estimator()
    print(estimator.step(t=0.0, voltage_V=3.7, current_A=-1.0, temperature_C=25.0))
