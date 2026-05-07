# BSEBench Monthly Benchmark Snapshot Schema

Saved: 2026-05-07. Scope: async/public benchmark operations fixtures only.

This document defines the first monthly snapshot contract for public BSEBench
benchmark reports. It is a schema and fixture contract only: it does not publish
results, assert SOTA status, register claims, or update thesis/manuscript text.

The machine-readable schema lives at:

- `docs/schemas/bsebench-monthly-benchmark-snapshot-v1.schema.json`

Synthetic fixtures live at:

- `docs/fixtures/monthly-benchmark-snapshot/valid-minimal.json`
- `docs/fixtures/monthly-benchmark-snapshot/invalid-missing-row-caveat.json`

## Contract

A monthly snapshot is a frozen, provenance-aware report bundle for one calendar
month. It groups BSEBench results across SOC/SOH task families, method families,
datasets, splits, metrics, and ranking groups without requiring downstream
consumers to infer missing caveats from prose.

The schema version is:

```json
"bsebench.monthly_benchmark_snapshot.v1"
```

Every snapshot must include:

- snapshot identity: month, creation timestamp, release status, and schema
  version;
- benchmark identity: async, runner, stats, and dataset commit identifiers;
- release caveats: explicit coverage, comparability, leakage, provenance,
  source-ledger, and ranking caveats;
- evidence artifacts: file paths, SHA-256 hashes, generation commands, frozen
  timestamps, and artifact caveats;
- source-ledger status: ledger paths and hashes when external comparison rows
  are used, or an explicit caveat when no external comparison is included;
- method registry rows spanning ECMs, Kalman filters, observers, AI estimators,
  hybrid methods, baselines, and other future families;
- dataset registry rows with chemistry, profile, temperature, aging, split, and
  provenance caveats;
- protocol rows with task family, split policy, leakage guard, initialization
  policy, and metric set;
- result rows with per-row provenance, metric status, comparability status, and
  required caveat fields.

## Required Caveat Fields

Release-level caveats:

- `coverage_caveat`
- `comparability_caveat`
- `leakage_caveat`
- `provenance_caveat`
- `source_ledger_caveat`
- `ranking_caveat`

Result-row caveats:

- `comparability_caveat`
- `dataset_caveat`
- `split_caveat`
- `metric_caveat`
- `leakage_caveat`
- `provenance_caveat`
- `compute_caveat`
- `exclusion_caveat`

The strings may say `none; ...` only when the absence of a limitation is itself
explicit and auditable. Empty strings are invalid.

## Validation

The schema is JSON Schema draft-07. A local validation probe can be run with:

```bash
python3 - <<'PY'
import json
from pathlib import Path

from jsonschema import Draft7Validator

schema = json.loads(Path("docs/schemas/bsebench-monthly-benchmark-snapshot-v1.schema.json").read_text())
validator = Draft7Validator(schema)

valid = json.loads(Path("docs/fixtures/monthly-benchmark-snapshot/valid-minimal.json").read_text())
validator.validate(valid)

invalid = json.loads(Path("docs/fixtures/monthly-benchmark-snapshot/invalid-missing-row-caveat.json").read_text())
errors = sorted(validator.iter_errors(invalid), key=lambda error: list(error.path))
assert errors, "invalid fixture unexpectedly passed"
assert any("leakage_caveat" in str(error.message) for error in errors), errors
print("monthly snapshot schema fixtures validated")
PY
```

## Guardrail

A monthly snapshot is incomplete when it reports a result, ranking group, source
comparison, or exclusion without the required caveat fields. Public prose may
cite a snapshot only as a frozen benchmark artifact; SOTA, novelty,
breakthrough, verified-claim, or claim-registration language still requires the
separate research-gate source ledger and claim workflow.
