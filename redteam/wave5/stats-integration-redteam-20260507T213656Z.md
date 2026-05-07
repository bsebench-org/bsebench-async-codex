# GLASSBOX Wave 5 Stats Integration Red-Team

- Worker: W6-02
- Branch: `phase-8-5-b-stats-integration-redteam-20260507T213656Z`
- Created: 2026-05-07
- Owned write-set: `redteam/wave5/stats-integration-redteam-20260507T213656Z.md`
- Scope: red-team review of Wave 5 stats integration risk only.
- Source repo inspected: `/mnt/c/doctorat/bsebench-org/bsebench-stats`
- W5 target branch inspected:
  `phase-8-4-b-stats-universal-wave1-integration-20260507T213125Z`

## Objective

Identify merge and publication risks in the Wave 5 stats integration surface:
metric schema collisions, aggregation ambiguity, and missing tests or gates.
This is a sidecar hardening artifact. It does not merge stats code, edit source
repos, edit protected research files, or make benchmark performance claims.

## Evidence Inspected

| Evidence | Observed result |
| --- | --- |
| Wave 1 stats validation artifact | `origin/phase-8-1-l-validator-stats-wave1-20260507T193050Z` at `3494f5b`; reports S1-S6 pushed and validation passed. |
| Wave 4 stats deep validation artifact | `origin/phase-8-3-e-stats-wave1-deep-validation-20260507T204627Z` at `dbe9e57`; focused S1-S6 replays passed and S5 upstream hygiene risk was noted. |
| Wave 5 stats validator artifact | `origin/phase-8-4-f-stats-integration-validator-20260507T213125Z` at `1d905c0`; sampled W5-02 while still local-only and mid-merge, with `src/bsebench_stats/__init__.py` unresolved. |
| Live W5 source branch | `git ls-remote --heads origin phase-8-4-b-stats-universal-wave1-integration-20260507T213125Z` now returns `08d7c2cef00a1830ac908310535e2320c41d2276`. |
| W5 worker log | `manual-phase-8-4-b-stats-universal-wave1-integration-20260507T213125Z.log` reports S1 clean, S2-S6 conflicts only in `src/bsebench_stats/__init__.py`, additive export-union resolution, focused tests `52 passed`, non-slow suite `148 passed`, ruff check/format, and `git diff --check` passed. |
| Live integration worktree | Clean and tracking `origin/phase-8-4-b-stats-universal-wave1-integration-20260507T213125Z` at `08d7c2c`. |
| Integration diff | Adds `compute_cost.py`, `convergence.py`, `metric_matrix.py`, `multi_axis_ranking.py`, `robustness_noise_schema.py`, `transfer_matrix.py`, matching tests, and additive top-level exports in `src/bsebench_stats/__init__.py`. |
| Local red-team whitespace gate | `git -C /mnt/c/doctorat/bsebench-org/bsebench-stats diff --check origin/main..origin/phase-8-4-b-stats-universal-wave1-integration-20260507T213125Z`: PASS with no output. |

## Current Status

W5 stats integration is no longer merely pending: the source branch is pushed at
`08d7c2c`. The earlier W5-06 validator artifact is still useful as a conflict
snapshot, but it is stale as final validation evidence because it sampled before
the push. A fresh independent validator should re-fetch `08d7c2c`, rerun the
focused integration suite and non-slow suite, and record the exact SHA.

Red-team decision: AMBER. The mechanical merge appears clean, but publication
or cross-repo promotion should wait for the falsification gates below.

## Conflict Risks

1. `src/bsebench_stats/__init__.py` was the repeated merge hotspot. W5 resolved
   it by additive union, and the current file exports all six new helper groups:
   compute cost, convergence, metric matrix, multi-axis ranking, robustness
   noise, and transfer matrix. This clears the observed merge conflict, but the
   risk repeats whenever another stats branch adds top-level exports.
2. The W5 log contains conflict-marker context from intermediate merges. The
   current pushed tree should be scanned, not inferred from the log tail. A
   release gate should run `git grep -n '<<<<<<<\\|=======\\|>>>>>>>' -- src tests`
   on the exact source branch head.
3. The W4 dashboard reported `15/15` pairwise stats Wave 1 conflicts around
   exports. Serial merge was the right integration tactic. Future automation
   should keep stats export conflicts serial and reject any non-additive
   resolution that removes an already public export.

## Schema Collision Risks

| Risk | Why it matters | Falsification gate |
| --- | --- | --- |
| Generic `schema_version` dispatch | New W5 modules use unique schema strings, but existing stats runner payloads still use `schema_version = "1.0"` for residual covariance and residual decomposition. A downstream report dispatcher keyed only by `schema_version` can route the wrong parser. | Add a registry test that all public report payloads include either a unique typed schema value or a report-family discriminator. Reject new generic `"1.0"` schemas outside explicitly legacy Hinf residual payloads. |
| Missing common report envelope | `multi_axis_ranking` and `robustness_noise_schema` include `mechanical_evidence_only` and `scientific_verdict: none`; `metric_matrix`, `convergence`, `compute_cost`, and `transfer_matrix` do not all carry the same anti-claim envelope. | Before public report integration, require a wrapper or schema adapter that adds `report_type`, `metric_family`, `unit`, `mechanical_evidence_only`, and `scientific_verdict: none` for every public metric payload. |
| Source-artifact schema gap | Robustness source artifacts require `path`, `sha256`, and `schema_version`, but the public redline gate requires repo, branch, commit, replay command, validation log, and evidence status. | Public report bundles must bind robustness `source_artifacts` to a frozen evidence ledger row. A robustness report without the ledger row is `pending_worker`, not publishable evidence. |

## Aggregation Ambiguity Risks

1. Metric matrix aggregates RMSE and MAE by pooling raw sample sums. That is
   valid as a diagnostic, but the metrics acceptance matrix requires macro
   comparison-unit aggregation as the public primary aggregate, with pooled
   aggregates labeled secondary.
2. Multi-axis ranking uses `weighted_mean_axis_rank`. The report includes
   caveats and `comparison_scope=relative_to_supplied_panel`, but downstream
   public prose could still turn a mechanical within-panel rank into a
   leaderboard or superiority claim.
3. Transfer matrix reports `mean` or `weighted_mean` depending on `weight_key`,
   but the default axes are only `chemistry`, `profile`, and `domain`.
   Temperature, aging/SOH bin, dataset, and equipment family remain report-layer
   obligations before universal monthly reports.
4. Compute cost aggregation averages records without mandatory stratification
   by evidence tier, backend, hardware, software lock, warmup/repeats, or
   measurement scope. This is useful inventory, not comparable compute evidence.
5. Convergence metrics are per trace and do not by themselves carry degraded
   initialization `protocol_id` or low/high wrong-start `case_id`. Public
   convergence summaries must preserve those case rows before aggregation.

Required falsification gate: any public or release-facing metric table must
state `metric_family`, `unit`, `comparison_unit_id`, `aggregation_policy`,
`weight_key` or `unweighted`, missing/failed-row policy, and whether the value
is macro, sample-pooled, weighted, or per-trace. If a table cannot state these
fields, it is blocked from public comparison.

## Missing Test Risks

| Gap | Suggested minimal test |
| --- | --- |
| Cross-module schema registry | Build one payload from each W5 helper and assert unique `(report_type, schema_version)` pairs, with no untyped `"1.0"` additions. |
| Export union regression | Assert all W5 public names are imported from top-level `bsebench_stats` and that every source module's `__all__` public builder is represented or intentionally excluded. |
| Compute alias conflict | Feed one record containing conflicting runtime aliases, such as `runtime_seconds=1` and `wall_time_seconds=2`, and require rejection or explicit conflict metadata instead of silent first-alias selection. |
| Transfer nested/flat conflict | Feed one row with `source.chemistry != source_chemistry` or `target.chemistry != target_chemistry`; require rejection or explicit precedence metadata. |
| Macro versus pooled divergence | Add a fixture where sample-pooled and macro-unit RMSE order disagree. Public report code must show both or block ranking. |
| Runner/stats compute compatibility | Use runner profiling output with nanosecond/byte raw fields and verify stats aggregation converts or rejects units explicitly before MB/seconds summaries. |

## Stop Gates Before Alpha Release

1. Re-run W5 stats validation on a clean validator worktree pinned to
   `08d7c2cef00a1830ac908310535e2320c41d2276`.
2. Run focused W5 tests and the stats non-slow suite from the pushed branch,
   not from a live moving integration worktree.
3. Run `git grep -n '<<<<<<<\\|=======\\|>>>>>>>' -- src tests` on the stats
   integration branch and block if any conflict marker remains.
4. Run a public-claim redline scan on any release note, README, report, table,
   caption, or dashboard that mentions ranking, comparison, robustness,
   transfer, compute, convergence, or external literature.
5. Block any SOTA, novelty, leaderboard, breakthrough, verified-claim, or
   external-comparison wording unless a completed source ledger, frozen evidence
   ledger, and claim-binding ledger are present.
6. Do not use the stale W5-06 `PENDING` artifact as final failure evidence, and
   do not use the W5 worker's own log as the sole pass evidence. Require a
   separate validator record for the pushed head.

## Explicit Non-Claims

- This artifact does not claim BSEBench is state of the art, novel,
  leaderboard-leading, a breakthrough, or scientifically verified.
- This artifact does not validate any SOC/SOH score, estimator ranking, dataset
  ground truth, public benchmark result, or external literature comparison.
- This artifact does not edit thesis files, manuscript files, claim registry
  files, `claims/registry.yaml`, `claim_55`, or the scientific roadmap.
- This artifact does not merge, approve, or reject the stats source branch; it
  records red-team risks and concrete gates.

## Artifact Validation

Commands run for this sidecar:

```bash
git fetch --all --prune
git show origin/phase-8-1-l-validator-stats-wave1-20260507T193050Z:validation/wave-1/stats-20260507T193050Z.md
git show origin/phase-8-3-e-stats-wave1-deep-validation-20260507T204627Z:validation/wave-4/stats-wave1-deep-validation-20260507T204627Z.md
git show origin/phase-8-4-f-stats-integration-validator-20260507T213125Z:validation/wave-5/stats-integration-validator-20260507T213125Z.md
git -C /mnt/c/doctorat/bsebench-org/bsebench-stats fetch origin --prune
git -C /mnt/c/doctorat/bsebench-org/bsebench-stats ls-remote --heads origin phase-8-4-b-stats-universal-wave1-integration-20260507T213125Z
git -C /mnt/c/doctorat/bsebench-org/bsebench-stats-phase-8-4-b-stats-universal-wave1-integration-20260507T213125Z status --short --branch
git -C /mnt/c/doctorat/bsebench-org/bsebench-stats diff --name-status origin/main..origin/phase-8-4-b-stats-universal-wave1-integration-20260507T213125Z
git -C /mnt/c/doctorat/bsebench-org/bsebench-stats diff --check origin/main..origin/phase-8-4-b-stats-universal-wave1-integration-20260507T213125Z
```

Recorded local result for the required branch validation:

- `git diff --check`: PASS with no output after writing this artifact.
