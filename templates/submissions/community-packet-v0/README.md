# BSEBench Community Packet v0 Templates

Use this directory as the required file set for a v0 external estimator intake.
The packet is an intake aid only; it is not benchmark evidence and does not
rank submitted methods.

Required files:

- `submission_metadata.json`
- `estimator_adapter.py`
- `dependency_risk_form.md`
- `smoke_test.md`
- `replay_evidence.md`
- `fail_closed_checklist.md`

Keep generated artifacts outside this template directory unless the maintainer
explicitly asks for a tiny smoke output. Do not include secrets, private cache
contents, large datasets, or credentials.

Minimum runner contract:

- expose `build_filter_registry()`;
- each estimator has `step(t, voltage_V, current_A, temperature_C)`;
- `step` returns finite numeric values;
- `voltage_predicted` is required.
