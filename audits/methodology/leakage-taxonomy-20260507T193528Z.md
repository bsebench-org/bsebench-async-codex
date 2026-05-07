# GLASSBOX Leakage Taxonomy Audit - Calibration/Evaluation Separation

- Worker: M-LEAK
- Timestamp: 2026-05-07T19:35:28Z task wave
- Owned artifact: `audits/methodology/leakage-taxonomy-20260507T193528Z.md`
- Scope: methodology audit/spec/runbook only. No runner, dataset, stats, claim,
  thesis, manuscript, or roadmap files were edited.

## Objective

Define a leakage taxonomy and rejection criteria that make BSEBench calibration,
tuning, model-selection, and blind evaluation lanes separable for SOC/SOH,
voltage-prediction, ECM, Kalman-filter, observer, AI-estimator, hybrid, and
future-estimator workflows.

The output is a reviewer-facing standard: if an estimator submission or
benchmark report cannot prove separation at the boundaries below, it is
rejected for benchmark publication until the gap is fixed.

## Evidence Inspected

Current async controls:

- `docs/BSEBENCH-UNIVERSAL-BENCHMARK-CHARTER-2026-05-07.md`: requires
  separation between ECM calibration, algorithm tuning, and blind evaluation.
- `docs/RESEARCH-GATE-PROTOCOL-2026-05-07.md`: separates evidence generation,
  SOTA comparison, and claim registration; requires provenance, replay,
  falsification, and source-ledger gates.
- `scripts/check-research-brief-gates.sh`: wording gate for Phase 7/8/11
  BRIEFs, including falsification, validation/replay, no thesis/registry edits,
  no `claim_55`, and no unsupported SOTA wording.
- `scripts/remote-worker.sh`: async worker records target repo, target branch,
  branch SHA, push result, outbox summary, and run-log tail.
- `scripts/cto-autonomy-pacer.sh`: queues only Phase 7/8/11 backlog tasks,
  skips malformed briefs, runs the research gate before queueing, and skips
  briefs whose target branch is already claimed locally or remotely.

Current runner/dataset mainline:

- `/mnt/c/doctorat/bsebench-org/bsebench-runner/src/bsebench_runner/orchestrator.py`:
  current `run_benchmark` consumes one `Split`, loads each config, truncates to
  `n_max`, runs registered filters, and returns RMSE/Friedman metadata. It does
  not yet enforce a calibration-vs-evaluation split pair.
- `/mnt/c/doctorat/bsebench-org/bsebench-datasets/src/bsebench_datasets/splits.py`:
  current `Split` schema is version `1.0` with config entries and forensic
  provenance only.
- `/mnt/c/doctorat/bsebench-org/bsebench-datasets/splits/audit_j_v1.yaml`:
  current split description says Audit J is a held-out blind matrix disjoint
  from a corresponding tuning fold, but the YAML has no machine-readable split
  role or calibration policy in main.

Wave 1 in-progress evidence, not treated as merged:

- `/mnt/c/doctorat/bsebench-org/bsebench-runner-phase-8-0-d-universal-runner-leakage-split-guard/src/bsebench_runner/split_guard.py`:
  proposed guard canonicalizes `(wrapper, profile, T_C)` and raises
  `SplitLeakageError` when calibration and evaluation splits overlap.
- `/mnt/c/doctorat/bsebench-org/bsebench-runner-phase-8-0-d-universal-runner-leakage-split-guard/tests/test_split_guard.py`:
  proposed tests cover disjoint splits, overlapping configs, normalized
  temperature identity, same profile at different temperature, and duplicate
  overlap reporting.
- `/mnt/c/doctorat/bsebench-org/bsebench-datasets-phase-8-0-o-universal-datasets-split-metadata/src/bsebench_datasets/splits.py`:
  proposed schema version `1.1` adds split role, leakage boundary, calibration
  policy, forbidden uses, evaluation task, target signals, metric, aggregation,
  and `require_same_config_set`.
- `/mnt/c/doctorat/bsebench-org/bsebench-datasets-phase-8-0-o-universal-datasets-split-metadata/splits/audit_j_v1.yaml`:
  proposed Audit J metadata marks the split as `heldout_evaluation`,
  `leakage_boundary: config_tuple`, calibration `policy: forbidden`, and
  forbidden uses including hyperparameter tuning, model selection, feature
  selection, normalization fit, threshold selection, and method development.
- `/mnt/c/doctorat/bsebench-org/bsebench-async-codex-cto-report-phase-8-1-k-validator-runner-wave1-20260507T193050Z/validation/wave-1/runner-20260507T193050Z.md`:
  validator marked R1-R6 as `PENDING`, because no committed/pushed runner branch
  heads existed at the re-check point.
- `/mnt/c/doctorat/bsebench-org/bsebench-async-codex-cto-report-phase-8-1-m-validator-datasets-wave1-20260507T193050Z/validation/wave-1/datasets-20260507T193050Z.md`:
  validator marked D1-D6 as `PENDING`, because no committed/pushed dataset
  branch heads existed at the re-check point.

Prior async gate work:

- `outbox/phase-7-8-d-async-research-gate-protocol/SUMMARY.md` and
  `CHEF_VERDICT.md`: research gate protocol was implemented, but the chef
  verdict escalated that branch because fast-forward merge failed. The current
  repo nevertheless already contains the protocol and checker.
- `outbox/phase-7-10-n-async-brief-reserve-integrity-gate/SUMMARY.md` and
  `CHEF_VERDICT.md`: reserve integrity gate proposed explicit reserve checking,
  but chef escalated due non-linear merge. Do not count that branch as merged
  evidence.

## Taxonomy

### L0 - Process Leakage

Definition: evidence, validation, or claims are drawn from uncommitted,
unpushed, stale, mixed-lane, or branch-colliding work instead of an immutable
branch head and reproducible command.

Reject when:

- A benchmark result cites a dirty worktree or local-only branch without a commit
  SHA.
- A validator reports `PENDING` because a branch head is absent, but downstream
  merge or claim work proceeds anyway.
- Evidence generation, SOTA comparison, and claim registration are performed in
  one task without the handoff artifacts required by the research gate protocol.
- A task edits thesis, manuscript, claim registry, `claims/registry.yaml`,
  `claim_55`, or roadmap files without explicit claim-registration authority.

Testable guards:

- Require `git rev-parse HEAD`, clean `git status --short`, and pushed branch
  evidence before using a result.
- Require `scripts/check-research-brief-gates.sh --dry-run <BRIEF.md>` for
  Phase 7/8/11 research briefs.
- Reject validator outputs whose branch matrix says `PENDING` or whose remote
  branch checks are absent.

### L1 - Split-Identity Leakage

Definition: a calibration/tuning split and an evaluation split share the same
benchmark identity. Minimum current identity is `(wrapper, profile, T_C)`;
future datasets may use stricter boundaries such as cell, cycle, source file,
or dataset.

Reject when:

- Any config tuple appears in both calibration and evaluation splits.
- The split schema lacks a machine-readable leakage boundary for a benchmark
  intended for public comparison.
- A report relies only on prose such as "held out" without a machine-readable
  split role and overlap check.

Testable guards:

- Build canonical key sets from `Split.configs` and reject non-empty
  intersections.
- Require `split_metadata.leakage_boundary` and `config_id_fields` in split
  schemas used for universal benchmark publication.
- Record overlap count and labels in the evaluation artifact even when the
  count is zero.

### L2 - Calibration-Policy Leakage

Definition: held-out evaluation data is used for ECM parameter identification,
OCV/SOC recalibration, estimator initialization tuning, hyperparameter tuning,
threshold selection, normalization fit, feature selection, prompt/model
selection, architecture selection, or method development.

Reject when:

- A held-out split has calibration policy `forbidden` and any forbidden use is
  logged against that split.
- The report cannot name which split or artifact supplied ECM parameters,
  normalizers, thresholds, or hyperparameters.
- AI or hybrid methods fit scalers, embeddings, feature transforms, prompts, or
  checkpoints on evaluation traces.

Testable guards:

- Require each result manifest to record `calibration_split_id`,
  `evaluation_split_id`, calibration policy, forbidden uses checked, and the
  parameter/hyperparameter artifact hashes.
- Require a separate calibration manifest for ECM parameters, OCV tables,
  normalizers, model checkpoints, and threshold sets.
- Add negative fixtures where evaluation config use for normalization or
  hyperparameter selection must fail.

### L3 - Temporal, Cell, Cycle, and Source-File Leakage

Definition: separation by `(wrapper, profile, T_C)` is insufficient when the
same physical cell, aging trajectory, cycle window, source file, or contiguous
time segment appears on both sides of calibration and evaluation.

Reject when:

- SOH tasks train/tune on cycles from the same cell trajectory that appears in
  blind evaluation unless the benchmark explicitly defines a temporal
  forecasting split with no future-to-past leakage.
- SOC tasks calibrate on a prefix and evaluate on a suffix while using future
  information from the suffix for normalization, OCV anchoring, smoothing, or
  state reset.
- Source files are duplicated across split roles through aliases, cache roots,
  symlinks, or regenerated manifests.

Testable guards:

- Extend split metadata with boundary-specific keys when available:
  `cell_id`, `cycle_id`, `source_file`, `source_sha256`, and time-window
  intervals.
- Check disjointness at every declared boundary, not only config tuple.
- Hash source files or manifest rows and reject duplicate source identity across
  forbidden split roles.

### L4 - Ground-Truth and Label Leakage

Definition: target SOC/SOH/voltage/capacity labels, rest-point corrections, or
post-hoc ground-truth revisions from evaluation traces influence calibration,
feature design, filtering, reset logic, or model selection.

Reject when:

- Evaluation labels are used to recalibrate SOC, SOH, OCV curves, capacity, or
  rest-point corrections before scoring.
- A method consumes target labels or any derived residuals at inference time,
  except through explicitly allowed online measurements in the estimator
  contract.
- A report cannot identify whether ground truth is coulomb counting, OCV
  recalibration, laboratory capacity, or another documented method.

Testable guards:

- Dataset cards and split manifests must expose ground-truth method,
  recalibration sources, and label availability by split role.
- Estimator adapters must declare allowed input signals and be smoke-tested
  against a fixture that omits labels during inference.
- Evaluation harnesses should fail when label columns are passed to estimator
  `step` inputs outside an explicit supervised training lane.

### L5 - Metric and Post-Hoc Selection Leakage

Definition: evaluation results are used to choose the primary metric, sample
cap, aggregation rule, subset of cells/profiles, convergence threshold,
robustness setting, or exclusion criteria.

Reject when:

- The primary metric, aggregation, sample limit, or comparison cohort is not
  frozen before evaluation.
- Failed configs are removed after seeing scores without a pre-registered
  invalid-output rule.
- Multiple metrics or subsets are tried and only favorable ones are reported as
  the benchmark result.

Testable guards:

- Require split/evaluation metadata to record task, target signals, primary
  metric, metric unit, direction, aggregation, sample limit, and
  `require_same_config_set`.
- Score all methods on the same config set or mark the comparison
  not-comparable.
- Record invalid-output counts and sentinel usage instead of silently dropping
  failed cells.

### L6 - Cache, Manifest, and ETL Leakage

Definition: calibration and evaluation are nominally split, but loaders,
preprocessed caches, manifests, or ETL transforms are mutable or shared in a
way that lets evaluation information influence calibration artifacts.

Reject when:

- Cache identity is missing, mutable, or differs between calibration and
  evaluation replay.
- ETL transforms fit on all data before splitting.
- Loader manifests cannot trace source file, hash, wrapper, profile, and
  temperature identity.

Testable guards:

- Require source/cache manifest hashes for every split role.
- Fit ETL transforms only on calibration-authorized data and store the fitted
  transform hash separately from evaluation data.
- Replay manifest drift audits before claim-supporting evidence is accepted.

### L7 - Submission and Human-Feedback Leakage

Definition: method authors or autonomous workers see blind evaluation scores,
leaderboard placement, or residual traces and then revise the same submitted
method for the same benchmark snapshot.

Reject when:

- A submitted adapter is modified after seeing blind evaluation scores without
  moving to a new benchmark snapshot or public retune lane.
- Human notes, prompts, or issue comments reveal held-out labels or per-config
  score details to a tuning worker.
- A monthly benchmark snapshot accepts a method whose final code SHA differs
  from the pre-evaluation submission SHA without audit trail.

Testable guards:

- Freeze submission SHA before blind evaluation and record it in the result
  manifest.
- Separate public diagnostics from blind held-out per-config details.
- Require resubmissions to enter a new dated evaluation snapshot.

## Decisions and Recommendations

1. Treat leakage as a merge-blocking defect, not a caveat, whenever it touches a
   held-out evaluation split, public benchmark snapshot, claim-supporting
   evidence, or SOTA/source-ledger comparison.
2. Make split role and leakage boundary mandatory for any Phase 8+ universal
   benchmark publication split. Current `Split` version `1.0` is acceptable for
   legacy replay, but insufficient for new public benchmark claims.
3. Promote config-overlap checking into the runner before any calibration-aware
   protocol is accepted. The Wave 1 split guard design is directionally correct,
   but it must land as a committed, pushed branch and be validated from that
   branch head before it is treated as operational.
4. Require result manifests to carry calibration and evaluation split IDs,
   split-role metadata, parameter artifact hashes, cache/source manifest hashes,
   metric contract, and overlap guard output.
5. Separate "method development" lanes from "blind evaluation" lanes in async
   briefs and monthly benchmark workflows. A worker that can see blind scores
   must not modify the method being scored for the same snapshot.

## Reviewer Rejection Criteria

Reject a benchmark run, comparison row, claim-supporting artifact, or monthly
snapshot entry if any criterion below is true:

- No committed and pushed branch SHA exists for the evaluated method, runner,
  dataset split, and stats code.
- The worktree used for evidence is dirty and the dirty diff is not itself the
  committed artifact under review.
- The calibration split and evaluation split overlap at any declared leakage
  boundary.
- The evaluation split does not declare whether calibration is forbidden,
  allowed on the same split, or allowed only on named splits.
- A held-out evaluation split is used for any forbidden calibration use:
  hyperparameter tuning, model selection, feature selection, normalization fit,
  threshold selection, or method development.
- Ground-truth labels, residuals, or post-hoc corrections from evaluation traces
  enter estimator inference, parameter identification, reset logic, or method
  selection.
- Metric, aggregation, sample cap, excluded configs, or comparison cohort are
  chosen after viewing evaluation scores.
- Loader, cache, or source manifest identity is missing for data used in a
  claim-supporting run.
- A SOTA, novelty, leaderboard, breakthrough, or verified-claim statement is
  made without a completed source ledger and comparability decision.
- A validator records `PENDING`, missing branch heads, missing replay, or
  unresolved branch conflict, but downstream claim or merge work proceeds.

## Validation Commands Run or Required

Inspection commands run for this audit:

```bash
git status --short --branch
rg --files | rg -i '(runner|dataset|datasets|split|gate|async|audit|methodology|benchmark|protocol|manifest)'
sed -n '1,260p' docs/RESEARCH-GATE-PROTOCOL-2026-05-07.md
sed -n '1,260p' docs/BSEBENCH-UNIVERSAL-BENCHMARK-CHARTER-2026-05-07.md
sed -n '1,220p' docs/BSEBENCH-UNIVERSAL-PARALLEL-WAVE-2026-05-07.md
sed -n '1,280p' scripts/check-research-brief-gates.sh
sed -n '1,420p' scripts/remote-worker.sh
sed -n '1,360p' scripts/cto-autonomy-pacer.sh
sed -n '1,260p' /mnt/c/doctorat/bsebench-org/bsebench-runner/src/bsebench_runner/orchestrator.py
sed -n '1,260p' /mnt/c/doctorat/bsebench-org/bsebench-datasets/src/bsebench_datasets/splits.py
sed -n '1,220p' /mnt/c/doctorat/bsebench-org/bsebench-datasets/splits/audit_j_v1.yaml
sed -n '1,260p' /mnt/c/doctorat/bsebench-org/bsebench-runner-phase-8-0-d-universal-runner-leakage-split-guard/src/bsebench_runner/split_guard.py
sed -n '1,280p' /mnt/c/doctorat/bsebench-org/bsebench-runner-phase-8-0-d-universal-runner-leakage-split-guard/tests/test_split_guard.py
sed -n '1,320p' /mnt/c/doctorat/bsebench-org/bsebench-datasets-phase-8-0-o-universal-datasets-split-metadata/src/bsebench_datasets/splits.py
sed -n '1,260p' /mnt/c/doctorat/bsebench-org/bsebench-async-codex-cto-report-phase-8-1-k-validator-runner-wave1-20260507T193050Z/validation/wave-1/runner-20260507T193050Z.md
sed -n '1,260p' /mnt/c/doctorat/bsebench-org/bsebench-async-codex-cto-report-phase-8-1-m-validator-datasets-wave1-20260507T193050Z/validation/wave-1/datasets-20260507T193050Z.md
```

Validation commands required for this artifact before final handoff:

```bash
bash -n scripts/check-research-brief-gates.sh
bash -n scripts/remote-worker.sh
bash -n scripts/cto-autonomy-pacer.sh
git diff --check
```

Recommended future guard checks:

```bash
# Runner, once split guard is committed and pushed:
uv run pytest tests/test_split_guard.py -q

# Datasets, once split metadata is committed and pushed:
uv run pytest tests/test_split_audit_j_v1.py -q

# Publication run manifest, future required shape:
python -m bsebench_runner.validate_leakage_manifest <result-manifest.json>
```

## Residual Risks

- Wave 1 runner and dataset validators observed pending, uncommitted worker
  worktrees. This audit intentionally does not treat those worktrees as merged
  truth.
- Current mainline has a prose held-out description for Audit J, but lacks
  machine-readable split role, calibration policy, and runner-level overlap
  enforcement.
- Config tuple disjointness is necessary but not sufficient for SOH, temporal,
  cell-level, cycle-level, source-file, and cache-level separation.
- Async BRIEF wording gates reduce process leakage but cannot prove scientific
  data separation without runner/dataset result manifests.
- The taxonomy is a rejection standard, not an implementation of every guard.

## Explicit Non-Claims

- This audit does not claim that BSEBench is leakage-free today.
- This audit does not verify any SOTA, novelty, leaderboard, breakthrough, or
  scientific claim.
- This audit does not validate Wave 1 runner or dataset branches as mergeable.
- This audit does not alter thesis files, manuscript files, claim registry
  files, `claims/registry.yaml`, `claim_55`, or the scientific roadmap.
- This audit does not certify any estimator, ECM, Kalman filter, observer,
  AI model, hybrid method, or future filter as benchmark-ready.
