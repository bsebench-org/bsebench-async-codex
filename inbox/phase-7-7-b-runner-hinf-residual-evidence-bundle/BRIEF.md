---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-runner
target_branch: phase-7-7-b-runner-hinf-residual-evidence-bundle
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-filters
  - /mnt/c/doctorat/these_lfp_2026
hard_wallclock_min: 90
---

# Phase 7.7.b - Hinf residual evidence bundle, no claim verdict

## Mission

Add and run a fail-loud real-data evidence bundle that combines:

- the Phase 7.6 runner residual trace 5x5 producer;
- the Phase 7.6 stats residual covariance panel;
- the Phase 7.7.a stats residual variance decomposition runner.

This is mechanical evidence only. Do not verify, retract, or update any thesis
claim. Do not target thesis `claim_55`: read-only CTO preflight found that
`claim_55` is already the verified EnsembleMeta/MAD floor claim in the thesis
registry, while the roadmap reused that id for Hinf by collision.

## Source references

Read first:

- `scripts/residual_trace_5x5.py`
- `tests/test_residual_trace_5x5.py`
- `scripts/chi2_sweep_5x5.py`
- `src/bsebench_runner/residuals.py`
- `/mnt/c/doctorat/bsebench-org/bsebench-stats/src/bsebench_stats/runners/residual_cov.py`
- `/mnt/c/doctorat/bsebench-org/bsebench-stats/src/bsebench_stats/runners/residual_decomp.py`
- `/mnt/c/doctorat/bsebench-org/bsebench-async-codex/outbox/preflight-claim-identity-hinf/CTO_BLOCK.md`

## Deliverable

Add a narrow script, preferably `scripts/hinf_residual_evidence_5x5.py`, with
fast synthetic tests. The script should:

- run `run_residual_trace_5x5(output_path=None, ...)`;
- require exactly the real 5 configs x 5 filters to pass before writing:
  `require_ok_configs=5` and `require_ok_filter_runs=25`;
- require filter labels exactly:
  `["EnsembleMeta", "EKF", "UKFDef", "JUKFV6B", "Hinf"]`;
- require trace summary exactly:
  `{"ok_configs": 5, "error_configs": 0, "ok_filter_runs": 25, "error_filter_runs": 0}`;
- require every config `status == "ok"` and every filter under every config
  `status == "ok"`;
- include finite `Hinf` residual traces length-matched to `retained_samples`
  for every retained config or fail before writing;
- bootstrap stats imports from the sibling repo
  `/mnt/c/doctorat/bsebench-org/bsebench-stats/src` if present, or provide a
  `--stats-src` option, because runner `uv.lock` may pin `bsebench-stats`
  before Phase 7.7.a;
- call stats-side `build_residual_covariance_panel(..., require_ok_configs=5, min_ok_filters=5)`;
- call stats-side `build_residual_variance_decomposition(..., require_ok_configs=5, min_ok_filters=5)`;
- write one JSON bundle only after all requirements pass, defaulting to
  `outputs/hinf_residual_evidence_5x5.json`;
- use `json.dumps(..., allow_nan=False)` / equivalent fail-loud JSON writing;
- return a compact stdout table with ok config/run counts and Hinf status;
- include a neutral top-level note such as `scientific_verdict: "none"` and
  `claim_target: "new_hinf_candidate_not_claim_55"`.

The output may include the real trace payload, covariance panel, and variance
decomposition in one JSON object. Keep it deterministic and audit-friendly.

## Evidence policy

- If the real run succeeds and the JSON is reasonably sized (< 20 MB), commit
  the real `outputs/hinf_residual_evidence_5x5.json`.
- If the real run fails requirements, do not commit a partial/all-error/all-skipped
  output. Commit only code/tests and record the exact failure in SUMMARY/stdout.
- Never fabricate residual arrays for failed filters.
- Do not suppress Hinf failures: Hinf must either be an ok retained filter in
  all retained configs or the script must fail before writing.
- Do not add plots, prose claims, claim registry rows, or thesis edits.

## Tests

Add fast synthetic tests:

- synthetic balanced 5x5 run writes one bundle with trace, covariance, and
  decomposition sections;
- missing Hinf fails before output writing;
- insufficient ok configs or ok filter runs fails before output writing;
- covariance/decomposition exceptions prevent output writing;
- JSON output is `allow_nan=False` safe;
- script import is side-effect free.

## Acceptance gates

- G1: focused tests for the new script pass.
- G2: `uv run --locked --all-extras pytest -m "not slow" --tb=short` passes.
- G3: `uv run --locked --all-extras ruff format --check .` passes.
- G4: `uv run --locked --all-extras ruff check .` passes.
- G5: real run command is attempted:
  `uv run --locked --all-extras python scripts/hinf_residual_evidence_5x5.py --require-ok-configs 5 --require-ok-filter-runs 25 --stats-src /mnt/c/doctorat/bsebench-org/bsebench-stats/src`
- G6: if G5 succeeds, the committed JSON has `ok_configs=5`, `ok_filter_runs=25`,
  includes `Hinf`, and is not a claim verdict.
- G7: no roadmap, README, claim registry, or thesis prose edits.
- G8: commit uses GLASSBOX with `[role: worker-codex-FR]`.
- G9: no `Co-Authored-By: Claude` trailer.

## Out of scope

- No claim_55 update.
- No thesis edit.
- No plot.
- No statistical conclusion beyond mechanical metrics already present in the
  JSON bundle.

## If blocked

Write `outbox/phase-7-7-b-runner-hinf-residual-evidence-bundle/BLOCKED.md`
with the smallest concrete blocker and the next narrower step.
