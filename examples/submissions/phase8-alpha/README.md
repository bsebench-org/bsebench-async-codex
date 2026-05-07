# Phase 8 Alpha Submission Examples

This directory contains GLASSBOX examples for community estimator submission
intake. The examples are tied to the inspected candidate universal step API:

```python
step(t: float, voltage_V: float, current_A: float, temperature_C: float) -> Mapping[str, float]
```

Files:

- `golden_causal_voltage_adapter.py`: self-contained causal adapter example.
- `golden-submission-packet.md`: filled alpha packet showing acceptable
  metadata, blind evaluation declarations, metric caveats, and reproduction
  commands.
- `rejection-examples.md`: concrete rejection patterns for schema, leakage,
  nondeterminism/state, dependency, protocol, and claim-language failures.

These are intake examples, not benchmark results. They do not make scientific
performance claims and do not approve public monthly snapshot publication for
any real method.
