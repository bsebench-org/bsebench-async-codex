# Phase 9-11 Transverse Internal Audit - 2026-05-09

## Verdict

Transverse checkpoint status:

- `GO_TOOLING`
- `GO_EMPIRICAL`
- `NO_GO_CLAIM`

The Phase 9, Phase 10, and Phase 11 evidence chain is internally consistent
for operational/mechanical work after the Phase 10 strict smoke artifacts were
refreshed against the intended NASA B0005 `test_id=2` cache trace. All three
phases remain intentionally claim-blocked for external results, public
comparison, ranking, or scientific interpretation.

## Scope

This audit covers only Phases 9, 10, and 11. It checks:

- product commits and worktree hygiene;
- artifact presence and provenance pointers;
- mechanical run evidence;
- stats preflight/readiness artifacts;
- no-claim guardrails;
- async reporting and mobile status history.

No dataset upload, thesis prose edit, roadmap edit, or claim-registry edit was
performed in this audit.

## Product Heads

Product worktree:

- `/mnt/c/doctorat/bsebench-org/.phase9-integration-20260509T024454+0200`

Current heads observed:

- `bsebench-datasets`: branch `glassbox-phase9-integration-20260509T024454+0200`, commit `e128cb3`
- `bsebench-runner`: branch `glassbox-phase9-integration-20260509T024454+0200`, commit `cc9e89b`
- `bsebench-filters`: branch `glassbox-phase9-integration-20260509T024454+0200`, commit `bb72d59`
- `bsebench-stats`: branch `glassbox-phase9-integration-20260509T024454+0200`, commit `ff68465`
- `bsebench-specs`: branch `glassbox-phase9-integration-20260509T024454+0200`, commit `2964ed7`
- `bsebench-async-codex`: branch `main`, observed head `fc46181`

Product worktree status:

- datasets: clean
- runner: clean
- filters: clean
- stats: clean
- specs: clean
- async: one unrelated untracked outbox file remains:
  `outbox/phase-7-10-z-autonomy-backlog-replenishment-20260508T135020Z/CHEF_VERDICT.md`

## Phase 9

Tooling status: `GO_TOOLING`

- Branch evidence: product branches listed above and async reporting on `main`.
- Commit/SHA evidence: datasets `e128cb3`, runner `c062da5` at the Phase 9
  report point, stats `3c3a6b5`, specs `2964ed7`, filters `bb72d59`, async
  report commit `5495444`.
- Validation evidence: JSON guardrails, acceptance checklist, merge-matrix
  test, and targeted datasets/runner/stats/specs/filters tests are recorded in
  `docs/PHASE_9_FINAL_AUDIT_VALIDATION_REPORT_2026-05-09.md`.
- Blocker status: no blockers for the internal operational smoke checkpoint;
  broader cross-profile interpretation remains claim-blocked.

Empirical status: `GO_EMPIRICAL`

- Cache evidence: CALCE A123/INR Tier 2 cache evidence present.
- Provenance evidence: source identity/provenance present for the Phase 9
  readiness and smoke artifacts.
- Tier2 evidence: `phase9_profile_axis_readiness_20260509_calce_a123_inr_ready.json`
  reports `36` ready configs out of `155`, with `119` not ready.
- Empirical-run artifact evidence: runner plan reports `16` ready rows out of
  `26`; loader smoke and bounded EKF smoke artifacts are present.

Scientific status: `NO_GO_CLAIM`

- No Phase 9 public comparison or external-result claim is supported. The
  Phase 9 evidence is a real infrastructure smoke, not a scientific ranking.

## Phase 10

Tooling status: `GO_TOOLING`

- Branch evidence: product branches listed above and async report on `main`.
- Commit/SHA evidence: datasets `e128cb3`, runner `c062da5`, filters `bb72d59`,
  stats `99d3e60`, specs `2964ed7`, async report commit `2ac76e2`; current
  runner artifact refresh commit `cc9e89b`.
- Validation evidence: targeted datasets, runner, filters, stats, and specs
  tests are recorded in
  `docs/PHASE_10_FINAL_AUDIT_VALIDATION_REPORT_2026-05-09.md`.
- Blocker status: no blockers for the internal NASA B0005 operational
  diagnostic checkpoint; stratified aging/SOH analysis remains blocked.

Empirical status: `GO_EMPIRICAL`

- Cache evidence: NASA B0005 Tier 2 cache present for `nasa:CC-discharge:T24`.
- Provenance evidence: NASA archive and B0005 MAT SHA256 evidence recorded in
  the Phase 10 report.
- Tier2 evidence: selected trace `B0005_test2.parquet` is readable and has
  explicit aging/SOH metadata.
- Empirical-run artifact evidence: predispatch has `1` ready row and `0`
  blocked rows; strict Hinf/EKF smoke artifacts were refreshed against
  `/mnt/c/doctorat/bsebench-org/.phase10-local-cache/nasa_pcoe_b0005_20260509`
  and loaded B0005 `test_id=2`; bounded-projection diagnostic artifact is
  present.

Scientific status: `NO_GO_CLAIM`

- No Phase 10 aging-invariance, robustness, or external-result claim is
  supported. Stats preflight returns a block status because there is only one
  SOH/aging group.

## Phase 11

Tooling status: `GO_TOOLING`

- Branch evidence: product branches listed above and async report on `main`.
- Commit/SHA evidence: runner `cc9e89b`, stats `ff68465`, filters `bb72d59`,
  specs `2964ed7`, datasets `e128cb3`, async report commit `d5dc1ef`.
- Validation evidence: runner residual audits, stats readiness tests, filters
  residual contract/export tests, specs residual schema tests, and async gate
  checks are recorded in
  `docs/PHASE_11_FINAL_AUDIT_VALIDATION_REPORT_2026-05-09.md`.
- Blocker status: no blockers for the internal mechanical residual diagnostics
  checkpoint; scientific interpretation remains blocked by sensitivity and
  sample-support risks.

Empirical status: `GO_EMPIRICAL`

- Cache evidence: residual preflight has `5/5` required configs checked.
- Provenance evidence: artifact manifest hashes match preflight, chi2,
  evidence, and `uv.lock`.
- Tier2 evidence: Yao BCDC T25, Yao US06 T25, Panasonic US06 T25, NASA B0005
  T24, and CALCE A123 DST T25 load through the residual evidence path.
- Empirical-run artifact evidence: strict residual evidence has `5` configs and
  `25` filter runs; stats readiness reports `preflight_ready` with
  `mechanical_validation_only=true` over `2900` samples.

Scientific status: `NO_GO_CLAIM`

- No Phase 11 sensor-noise/model-mismatch conclusion is supported. The
  sensitivity sidecar reports material sensitivity and sample-count imbalance.

## Cross-Phase Findings

Finding 1: the operational chain is now coherent.

- Phase 9 proves profile-axis smoke machinery on real Tier 2 evidence.
- Phase 10 proves aging/SOH readiness plumbing, strict blocking smoke, and
  blocking stats preflight after the artifact refresh.
- Phase 11 proves residual diagnostics mechanics and manifest drift checks.

Finding 2: claim discipline improved.

- All three phases use `NO_GO_CLAIM`.
- Artifacts carry `scientific_verdict=none`, `mechanical_evidence_only`, or
  explicit diagnostic flags where relevant.
- The research diff-scope guard blocks unsafe public-comparison wording.

Finding 3: Phase 11 had a real provenance drift and it was corrected.

- The runner residual manifest pinned a stale `uv.lock` hash.
- Commit `7891d96` corrected the manifest and regenerated candidate report
  pointers.
- `scripts/audit_hinf_residual_manifest.py` and
  `scripts/audit_hinf_residual_manifest_drift.py` now report `status=ok`.

Finding 4: the triphasic acceptance gate must be applied to triphasic reports.

- Applying `check-phase9-11-acceptance-gate.sh` to the single-phase Phase 9
  report fails because that file does not contain Phase 10 and Phase 11 blocks.
- This transverse report contains all three blocks and is the correct target for
  the triphasic gate.

Finding 5: there is still no scientific result.

- Phase 9 has one-filter smoke and blocked rows.
- Phase 10 has one SOH/aging group.
- Phase 11 has material sensitivity and sample imbalance.
- These are useful engineering milestones, not public scientific conclusions.

Finding 6: Phase 10 evidence repair was performed during this audit.

- Current runner schema adds `output_adaptation`, `claim_eligible`, and
  diagnostic summary counters.
- The checked-in strict Hinf/EKF smoke JSON files were produced before those
  fields existed.
- A dry regeneration without explicit cache root attempted Hugging Face and
  failed with authentication.
- A dry regeneration with `/tmp/bsebench_nasa_tier2_cache` loaded
  `B0005_test1.parquet`, while the predispatch rows point to
  `B0005_test2.parquet`.
- The final regeneration used
  `/mnt/c/doctorat/bsebench-org/.phase10-local-cache/nasa_pcoe_b0005_20260509`,
  loaded B0005 `test_id=2`, kept claim-ineligible Hinf/EKF outcomes, and was pushed
  in runner commit `cc9e89b`.

Finding 7: older reports need snapshot labels.

- Several Phase 9 reports list historical component SHAs. They are useful
  history, but they are not current-head summaries.
- One older Phase 9 integration audit says the empirical path still needed an
  end-to-end run; later reports narrow the accepted evidence to a bounded
  smoke slice. The older report should be treated as superseded by the final
  Phase 9 audit report.
- Phase 9 artifact references do not embed artifact SHA256 digests. Future
  evidence reports should include digests for every JSON artifact, not only
  paths.

## Verification Commands

Commands executed during this transverse audit:

```bash
PYTHONPATH=. UV_LINK_MODE=copy uv run --with pytest pytest -q tests/test_phase9_11_merge_matrix.py tests/test_mobile_phase_status_once.py

PYTHONPATH=src python scripts/audit_hinf_residual_manifest.py

PYTHONPATH=src python scripts/audit_hinf_residual_manifest_drift.py
```

Results:

- Async merge/mobile tests: `8 passed`.
- Runner residual artifact manifest audit: `ok`, four hashes checked.
- Runner residual manifest drift audit: `status=ok`, strict artifacts not drifted.
- Product worktrees: clean for datasets, runner, filters, stats, and specs.
- Runner Phase 10 targeted tests after schema inspection: `33 passed`.
- Runner Phase 10 strict smoke artifact refresh: pushed in commit `cc9e89b`.

## Lessons

- A report must match the gate shape. Single-phase reports are useful for
  history, but the triphasic gate needs a triphasic checklist.
- Hashes and lockfiles are evidence, not metadata decoration. A stale lock hash
  correctly blocked Phase 11 until fixed.
- Diagnostic projection is useful for debugging but must never be promoted into
  a score.
- Readiness preflights should keep blocking scientific interpretation when the
  axis coverage is insufficient.
- Future dispatch should preserve a strict split between mechanical evidence,
  empirical evidence, and claim eligibility.
- Current-head audits must check not only that an artifact exists, but that it
  was produced by the current schema and the intended cache trace.

## Next Audit

The next step is a full Phases 1-11 retrospective: trajectory, errors, lessons,
remaining risks, and whether the project direction is still aligned with the
universal SOC/SOH benchmark objective.
