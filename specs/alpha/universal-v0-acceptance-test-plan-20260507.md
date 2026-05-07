# GLASSBOX Universal Benchmark v0 Acceptance Test Plan

- Worker: W7-m
- Wave: Wave 7 alpha-readiness, gate implementation, and independent integration audit
- Branch: `phase-8-6-m-universal-v0-acceptance-test-plan-20260507T214305Z`
- Owned write-set: `specs/alpha/universal-v0-acceptance-test-plan-20260507.md`
- Created: 2026-05-07
- Artifact type: acceptance test plan and gate matrix
- Release posture: alpha-readiness planning only
- Claim posture: no thesis, manuscript, claim registry, public comparison, or scientific claim registration

## Purpose

This plan defines the v0 acceptance gates for the universal BSEBench SOC/SOH
benchmark before any alpha release candidate is described as ready for public
use. It converts the universal benchmark charter into testable gates for the
estimator API, split guard, degraded initialization, metrics, compute evidence,
datasets, claim-language control, and monthly snapshot workflow.

The plan is deliberately fail-closed. A requirement is marked `TESTABLE` only
when a validator can run or inspect a concrete artifact. It is marked
`BLOCKED` when the current evidence is specification-only, branch-only,
not merged, lacks a frozen artifact, or depends on missing source-ledger or
release-dossier inputs.

## Evidence Inspected

The following read-only evidence was used to shape the gates. No runner,
stats, datasets, thesis, manuscript, roadmap, or claim-registry files were
edited.

| Evidence | Source | Acceptance-plan use |
| --- | --- | --- |
| Universal benchmark charter | `docs/BSEBENCH-UNIVERSAL-BENCHMARK-CHARTER-2026-05-07.md` | Defines the required pillars: exhaustive evaluation matrix, integrity guards, plug-and-play estimator contract, and monthly community workflow. |
| Research gate protocol | `docs/RESEARCH-GATE-PROTOCOL-2026-05-07.md` | Defines separation of evidence generation, source comparison, and claim registration. |
| Universal parallel wave plan | `docs/BSEBENCH-UNIVERSAL-PARALLEL-WAVE-2026-05-07.md` | Enumerates Phase 8 runner, stats, datasets, and async/control-plane workstreams. |
| Definition of done | `phase-8-3-x-universal-bsebench-definition-of-done-20260507T204627Z:docs/universal/definition-of-done-20260507T204627Z.md` | Provides release gates for code, data, metrics, reproducibility, monthly snapshots, and public claims. |
| Alpha RC manifest draft | `phase-8-4-k-release-candidate-manifest-20260507T213125Z:release/alpha/universal-rc-manifest-20260507T213125Z.md` | Pins known Phase 8 input branches, validation summaries, and open blockers. |
| Alpha release red-team report | `phase-8-5-f-alpha-release-redteam-20260507T213656Z:redteam/release/alpha-release-redteam-20260507T213656Z.md` | Provides stop/go criteria and release risks. |
| Monthly snapshot schema | `phase-8-0-t-universal-async-monthly-snapshot-schema:docs/BSEBENCH-MONTHLY-SNAPSHOT-SCHEMA-2026-05-07.md` | Defines required snapshot identity, caveat, source-ledger, method, dataset, protocol, and result-row fields. |
| Runner Wave 1 integration worktree | `/mnt/c/doctorat/bsebench-org/bsebench-runner-phase-8-4-a-runner-universal-wave1-integration-20260507T213125Z` | Read-only inspection of estimator contract, protocol registry, split guard, degraded initialization, profiling, and tests. |
| Stats Wave 1 integration worktree | `/mnt/c/doctorat/bsebench-org/bsebench-stats-phase-8-4-b-stats-universal-wave1-integration-20260507T213125Z` | Read-only inspection of metric matrix, compute aggregation, convergence, robustness, ranking, and transfer helpers. |
| Datasets Wave 1 integration worktree | `/mnt/c/doctorat/bsebench-org/bsebench-datasets-phase-8-4-c-datasets-universal-wave1-integration-20260507T213125Z` | Read-only inspection of ETL contract, ground-truth audit, split metadata, dataset card, equipment registry, and availability snapshot. |
| Remote branch inventory | `git ls-remote --heads origin` with Phase 8 filters | Confirms the relevant async/report branches exist and that this W7 branch is separate. |

## Acceptance States

| State | Meaning |
| --- | --- |
| `TESTABLE` | Concrete artifact or branch evidence exists, but the gate still needs replay on the assembled target ref before it can become `PASS`. |
| `PASS` | Concrete artifact exists and the listed validation passes on the assembled target ref. |
| `FAIL` | Concrete artifact exists and validation fails. |
| `BLOCKED` | Required artifact, assembled ref, source ledger, frozen snapshot, or validation output is missing. |
| `NOT APPLICABLE` | The requirement is outside the specific release scope and is explicitly excluded in the release dossier. |

No gate may be inferred from memory, branch names alone, or worker stdout. A
gate requires committed files, exact refs, validation commands, and reviewer
readable output.

## Universal v0 Acceptance Matrix

| Gate | Requirement | Current status | Why |
| --- | --- | --- | --- |
| A0 | Assembled alpha refs exist for runner, stats, datasets, and async/report lanes. | `BLOCKED` | Evidence shows independent branches and manifests, but no pushed assembled v0 release refs across all repos. |
| A1 | Estimator API accepts external methods without loader, split, metric, or report edits. | `TESTABLE` after runner integration | Runner worktree exposes `EstimatorAdapter`, `EstimatorProtocol`, and external toy submission tests. Requires assembled-runner replay. |
| A2 | Split guard blocks calibration/evaluation leakage. | `TESTABLE` after runner and datasets integration | Runner has config-tuple split guard; datasets split metadata declares calibration/evaluation roles. Needs combined replay. |
| A3 | Degraded initialization protocol is explicit and reproducible. | `TESTABLE` after runner and stats integration | Runner has forced wrong initial SOC fixture; stats has convergence metrics. Needs linked protocol result fixture. |
| A4 | Metrics cover accuracy, reliability, robustness, generalization, and invalid-output policy. | `TESTABLE` in parts; `BLOCKED` for full v0 | Stats branches cover many helpers, but no frozen v0 result artifact demonstrates all required axes together. |
| A5 | Compute evidence records runtime, memory, and unavailable fields without fabrication. | `TESTABLE` after runner/stats integration | Runner has step profiling metadata; stats has compute-cost aggregation. Needs final report wiring and validation. |
| A6 | Dataset layer is auditable for ETL, ground truth, splits, cards, equipment, licenses, and availability. | `TESTABLE` in parts; `BLOCKED` for public v0 | Datasets branches expose contracts and schemas. Public readiness requires assembled dataset ref plus license/cache/status rows. |
| A7 | Public claims gate blocks unsupported comparison, promotional, and claim-registration language. | `TESTABLE` for text; `BLOCKED` for positive comparisons | Research protocol and redline gates exist. External comparison remains blocked until source-ledger and claim-binding bundles exist. |
| A8 | Monthly snapshot is frozen, caveated, and replayable. | `BLOCKED` | Snapshot schema exists, but no frozen monthly snapshot JSON, report Markdown, hash manifest, source-ledger bundle, and release checklist are present. |
| A9 | Release dossier includes branch SHAs, commands, hashes, blockers, and residual risk. | `BLOCKED` | RC manifest draft exists, but it explicitly marks publication blocked and requires assembled post-merge validation. |

## A0 - Release Ref And Evidence Dossier

Acceptance requirements:

- A release dossier names exact refs for `bsebench-runner`, `bsebench-stats`,
  `bsebench-datasets`, and this async/report repo.
- Each ref is pushed, fetchable, and recorded with full commit SHA.
- The dossier lists changed files, validation commands, pass/fail status,
  skipped tests, environment variables, lockfile status, and artifact hashes.
- The dossier marks every missing input as a blocker, not an implicit pass.

Validation:

```bash
git -C /mnt/c/doctorat/bsebench-org/bsebench-runner fetch origin --prune
git -C /mnt/c/doctorat/bsebench-org/bsebench-stats fetch origin --prune
git -C /mnt/c/doctorat/bsebench-org/bsebench-datasets fetch origin --prune
git fetch origin --prune
git ls-remote --heads origin '<release-or-alpha-ref-pattern>'
```

Fail conditions:

- Any participating repo lacks a pushed ref.
- The dossier cites a local worktree, watchdog log, or branch label without a
  full commit SHA.
- A required artifact hash is absent and no hash-gap blocker is recorded.

Current disposition: `BLOCKED`; no assembled pushed alpha release ref was
observed in the inspected evidence.

## A1 - Estimator API

v0 contract under test:

- A contributor provides an adapter factory that returns a fresh estimator
  instance per run/configuration.
- The estimator exposes a `step(...)` method compatible with runner inputs:
  time, measured voltage, current, and temperature. If cadence `dt_s` is part
  of the final v0 protocol, it must be passed through a documented adapter hook
  rather than inferred from private loader state.
- Step output is a mapping of finite numeric values.
- `voltage_predicted` is required for legacy voltage-error protocols.
- SOC/SOH outputs, when provided, use stable names such as `soc_estimated` and
  `soh_estimated`; they are optional unless the selected protocol declares
  them as target outputs.
- Adapter metadata records method family, version, contract version, and
  training-data policy.
- Invalid output, non-finite values, missing required keys, and exceptions are
  recorded as failed cells, not silently removed from denominators.

Acceptance tests:

```bash
cd /mnt/c/doctorat/bsebench-org/bsebench-runner
uv run pytest tests/test_estimator_contract.py tests/test_submission_smoke.py -q
uv run pytest tests/test_protocol_registry.py -q
uv run pytest -m "not slow" --tb=short
uv run ruff check .
uv run ruff format --check .
git diff --check
```

Required evidence in the release dossier:

- Exact runner ref and commit SHA.
- Adapter contract version string.
- Passing test output for contract and submission smoke tests.
- A toy external adapter path that runs without editing dataset loaders, split
  logic, metrics, or report code.
- A negative test showing missing or non-finite output fails.

Blockers:

- The current inspected runner contract requires `voltage_predicted`; the
  charter's target contributor experience centers SOC/SOH state estimation.
  v0 must explicitly define which protocols require voltage prediction and
  which require SOC/SOH outputs before public intake.
- Reset/initialization hooks are not yet proven as part of the minimal
  inspected adapter contract; they must be either added, documented as protocol
  metadata, or marked deferred.

## A2 - Split Guard And Anti-Leakage

v0 contract under test:

- Calibration, training/tuning, validation, and blind evaluation stages are
  named in split metadata.
- The smallest identity protected from leakage is explicit. For Audit J style
  runs this is the `(wrapper, profile, T_C)` config tuple; future SOH or
  transfer protocols may need `cell_id`, `cycle_id`, dataset, chemistry, or
  source-file boundaries.
- Evaluation splits with `calibration.policy: forbidden` cannot be used for
  hyperparameter tuning, model selection, feature selection, normalization fit,
  threshold selection, or method development.
- The runner fails before execution when calibration and evaluation identities
  overlap.
- Reports state which split IDs were used for each stage.

Acceptance tests:

```bash
cd /mnt/c/doctorat/bsebench-org/bsebench-runner
uv run pytest tests/test_split_guard.py -q
git diff --check

cd /mnt/c/doctorat/bsebench-org/bsebench-datasets
uv run pytest tests/test_split_audit_j_v1.py -q
git diff --check
```

Required evidence in the release dossier:

- Split YAML or JSON path and SHA-256 hash.
- Split schema version.
- Calibration policy and forbidden-use list.
- A passing no-overlap report and a failing overlap fixture.
- Report row fields for split ID, split role, leakage boundary, and
  calibration policy.

Fail conditions:

- Any evaluation data can influence ECM identification, estimator training,
  hyperparameter tuning, early stopping, normalization fit, threshold choice,
  or method selection without a leakage violation.
- Any report table omits split ID or calibration policy.

Current disposition: `TESTABLE` after runner and datasets integration; full v0
is `BLOCKED` until the assembled refs and split hashes are recorded.

## A3 - Degraded Initialization And Recovery

v0 contract under test:

- At least one forced wrong-initial-SOC fixture is part of the benchmark
  protocol, not a hidden estimator-specific setting.
- Forced initial states are deterministic, versioned, and recorded in the run
  artifact.
- Degraded initialization uses only allowed initialization sources and never
  ground-truth SOC/SOH, future samples, or evaluation labels.
- Metrics report recovery behavior separately from steady-state tracking.
- Runs that fail to recover, diverge, emit invalid values, or timeout are
  visible as failed or invalid cells.

Acceptance tests:

```bash
cd /mnt/c/doctorat/bsebench-org/bsebench-runner
uv run pytest tests/test_initialization_policy.py tests/test_orchestrator.py -q
git diff --check

cd /mnt/c/doctorat/bsebench-org/bsebench-stats
uv run pytest tests/test_convergence.py -q
git diff --check
```

Required evidence in the release dossier:

- Initialization fixture ID, schema version, and case IDs.
- Exact `soc_init` values and allowed initialization state sources.
- Per-method, per-config convergence or recovery metrics.
- Failure/timeout/invalid-output counts.

Blockers:

- The inspected runner fixture forces `soc_init` values, but a frozen v0
  protocol bundle linking that fixture to metrics and report rows has not been
  observed.
- SOH degraded-initialization policy is not proven in current evidence and
  must be marked out of scope or added as a separate fixture.

## A4 - Metrics And Statistics

v0 metric families:

- Accuracy: RMSE, MAE, and MAXE with explicit units and direction.
- Distribution: per-cell and per-profile rows retained before aggregation.
- Reliability: convergence/recovery after degraded initialization.
- Robustness: Gaussian and non-Gaussian noise reports when the selected
  protocol includes perturbation tests.
- Generalization: chemistry, profile, temperature, aging/SOH, and transfer
  matrices where data coverage permits.
- Invalid-run policy: non-finite, failed, timeout, skipped, unsupported, and
  not-comparable cells remain visible.

Acceptance tests:

```bash
cd /mnt/c/doctorat/bsebench-org/bsebench-stats
uv run pytest tests/test_metric_matrix.py tests/test_convergence.py tests/test_robustness_noise_schema.py tests/test_compute_cost.py tests/test_multi_axis_ranking.py tests/test_transfer_matrix.py -q
uv run pytest -m "not slow" --tb=short
uv run ruff check .
uv run ruff format --check .
git diff --check
```

Required evidence in the release dossier:

- Metric schema version.
- Formula, units, direction, denominator, aggregation policy, and invalid-run
  policy for every metric.
- Per-cell/profile metric matrix before any aggregate ranking.
- Robustness, convergence, compute, and transfer rows either populated or
  explicitly marked out of scope with caveats.

Fail conditions:

- A single aggregate score is published without per-cell/profile distributions.
- Failed or invalid cells disappear from denominators.
- SOC and SOH metrics are mixed in one ranking group without separate task,
  unit, and target-signal fields.

Current disposition: `TESTABLE` for helper suites; `BLOCKED` for v0 release
until a frozen result artifact demonstrates the combined schema.

## A5 - Compute Evidence

v0 contract under test:

- Runner records per-step or per-cell runtime metadata around estimator calls.
- Memory evidence is recorded when practical, and the memory backend is named.
- Stats aggregate runtime, memory, cost, FLOP, and unavailable-field coverage
  without fabricating absent values.
- Hardware, Python/runtime environment, repeat count, and measurement method
  are part of the release dossier.
- Compute fields are evidence for deployability constraints, not performance
  claims by themselves.

Acceptance tests:

```bash
cd /mnt/c/doctorat/bsebench-org/bsebench-runner
uv run pytest tests/test_profiling.py tests/test_orchestrator.py -q
git diff --check

cd /mnt/c/doctorat/bsebench-org/bsebench-stats
uv run pytest tests/test_compute_cost.py -q
git diff --check
```

Required evidence in the release dossier:

- Profiling schema version.
- Runtime unit and clock source.
- Memory backend and scope.
- Per-record compute-cost coverage fields.
- Explicit unavailable-field caveats for memory, cost, or FLOP gaps.

Fail conditions:

- Missing memory, cost, or FLOP values are rendered as zero.
- Compute records lack runtime.
- Public prose treats environment-specific timing as portable without hardware
  and measurement caveats.

## A6 - Dataset Acceptance

v0 dataset contract under test:

- ETL field contract defines Tier 2 and loader-facing time, voltage, current,
  temperature, `dt_s`, SOC truth, and SOH truth fields.
- Current sign convention is explicit at both Tier 2 and runner-loader layers.
- Ground-truth SOC/SOH methods are documented per dataset or marked missing.
- Split metadata records role, leakage boundary, config identity fields,
  calibration policy, and evaluation task.
- Dataset cards include chemistry, profiles, temperature, aging/SOH coverage,
  equipment provenance, source ledger status, license, and transformation
  caveats.
- Equipment registry records known vendor/format metadata and leaves unknowns
  explicit.
- Availability snapshots distinguish Tier 2 available, Tier 1 available,
  manifest-registered, and prospect-only states.

Acceptance tests:

```bash
cd /mnt/c/doctorat/bsebench-org/bsebench-datasets
uv run pytest tests/test_etl_contract.py tests/test_ground_truth_metadata_audit.py tests/test_split_audit_j_v1.py tests/test_dataset_card.py tests/test_equipment_registry.py tests/test_availability_snapshot.py -q
uv run pytest -m "not slow" --tb=short
uv run ruff check .
uv run ruff format --check .
git diff --check
```

Required evidence in the release dossier:

- Dataset manifest paths and hashes.
- Split paths and hashes.
- Dataset card paths and schema versions.
- Ground-truth audit status per dataset and target signal.
- License and redistribution status per dataset row.
- Local cache or public mirror status and caveats.

Fail conditions:

- SOC/SOH truth fields are used as estimator inputs.
- Ground-truth method is inferred without source evidence.
- A prospect-only or license-unclear dataset appears as benchmark-ready.
- Cache availability is treated as public availability without caveats.

Current disposition: `TESTABLE` for branch suites; `BLOCKED` for public v0
until dataset status, license, split, and cache evidence are frozen in the
release dossier.

## A7 - Claims Gate And Public Text Control

v0 claim-control contract:

- Evidence generation, source comparison, and claim registration remain
  separate lanes.
- This alpha plan and any alpha release dossier do not edit thesis files,
  manuscript files, claim registry files, `claims/registry.yaml`, `claim_55`,
  or the scientific roadmap.
- Public comparison wording requires a source ledger and claim-binding ledger.
- Snapshot/report prose must use scoped, artifact-bound language only.
- Guardrail scans are reviewed in context so blocked-word examples in policy
  files do not become false positives.

Acceptance tests:

```bash
cd /mnt/c/doctorat/bsebench-org/bsebench-async-codex-cto-report
bash scripts/check-research-brief-gates.sh --dry-run
git diff --name-only origin/main...HEAD | rg '(^|/)(thesis|manuscript|claims/registry\.yaml|claim_55|RESEARCH-ROADMAP)' || true
rg -n "(SOTA|state[- ]of[- ]the[- ]art|leaderboard|breakthrough|verified claim|novelty|novel|outperform|best in the literature|winner)" release docs audits specs templates README.md || true
git diff --check
```

Required evidence in the release dossier:

- Protected-path scan output.
- Claim-language scan output with contextual disposition.
- Source-ledger bundle path and hash, or explicit statement that external
  comparisons are not included.
- Claim-binding ledger path and hash for every public comparison or claim-like
  sentence, or a blocker.

Fail conditions:

- Any public comparison sentence lacks source-ledger and claim-binding support.
- Any protected file is changed in the alpha release lane.
- A partial or not-comparable row is used for positive comparison language.

Current disposition: `TESTABLE` for blocking scans; `BLOCKED` for positive
external comparisons because no completed alpha source-ledger bundle was
inspected.

## A8 - Monthly Snapshot

v0 snapshot contract:

- Snapshot identity includes month, creation timestamp, release status, and
  schema version.
- Benchmark identity includes async/report, runner, stats, and datasets commit
  identifiers.
- Evidence artifacts include paths, SHA-256 hashes, generation commands,
  frozen timestamps, and caveats.
- Method registry spans estimator families without requiring private loader or
  benchmark logic changes.
- Dataset registry rows include chemistry, profile, temperature, aging, split,
  provenance, and availability caveats.
- Protocol rows include task family, split policy, leakage guard,
  initialization policy, and metric set.
- Result rows include metric status, comparability status, and required
  caveat fields.

Acceptance tests:

```bash
cd /mnt/c/doctorat/bsebench-org/bsebench-async-codex-cto-report
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
PY
git diff --check
```

Required evidence in the release dossier:

- Snapshot JSON path and SHA-256 hash.
- Public report Markdown path and SHA-256 hash, if report prose is included.
- Source-ledger bundle path and hash, or explicit no-external-comparison caveat.
- Release checklist path and hash.
- Freeze record with exact repo refs and validation status.

Fail conditions:

- Snapshot rows omit any required caveat field.
- A report cites a snapshot that has no frozen JSON bytes.
- A ranking group lacks method, dataset, split, protocol, metric, evidence, and
  comparability scoping.

Current disposition: `BLOCKED`; schema and fixtures exist, but no frozen alpha
snapshot artifact was inspected.

## A9 - Independent Integration Audit

Before v0 alpha readiness can be accepted, an independent validator must run
these checks on the assembled refs, not on isolated feature branches only.

Runner:

```bash
BSEBENCH_LEGACY_AUTORESEARCH_DIR=/mnt/c/doctorat/these_lfp_2026/ecm_fidelity_lfp/autoresearch \
  uv run pytest -m "not slow" --tb=short
uv run ruff check .
uv run ruff format --check .
git diff --check
```

Stats:

```bash
uv run pytest -m "not slow" --tb=short
uv run ruff check .
uv run ruff format --check .
git diff --check
```

Datasets:

```bash
uv run pytest -m "not slow" --tb=short
uv run ruff check .
uv run ruff format --check .
git diff --check
```

Async/report:

```bash
bash -n scripts/*.sh
bash scripts/check-research-brief-gates.sh --dry-run
git diff --check
```

Fail conditions:

- Any integrated repo fails non-slow tests, lint, format, or diff check without
  a documented release blocker.
- Any expected export conflict is resolved by dropping additive exports.
- Any usage-limit, local-only, stale, or missing-push branch is included without
  explicit blocker status.
- Any public artifact lacks a replay path from committed bytes.

## Minimum v0 Alpha Exit Criteria

The v0 alpha may move from planning to release-candidate review only when all
of the following are true:

1. A0 is `PASS` for all participating repos.
2. A1 through A6 are `PASS` or explicitly `NOT APPLICABLE` with release-scope
   caveats.
3. A7 blocking scans pass, and external comparison is either absent or backed
   by complete source-ledger and claim-binding artifacts.
4. A8 has a frozen snapshot artifact or the release explicitly states that no
   monthly snapshot is included.
5. A9 integrated validation passes on assembled refs.
6. All blockers from the RC manifest and alpha red-team report are closed or
   carried as visible P0/P1 blockers.

## Blockers To Carry Forward

| Blocker | Severity | Close-out required |
| --- | --- | --- |
| No assembled pushed alpha refs across runner, stats, datasets, and async/report repos. | P0 | Create and validate assembled refs; record full SHAs. |
| No frozen monthly snapshot artifact. | P0 if release includes snapshot | Commit JSON/report/freeze bytes and hashes, or exclude snapshot explicitly. |
| No completed public source-ledger and claim-binding bundle. | P0 for public comparisons | Add complete ledgers or omit external comparisons. |
| Runner API voltage-vs-SOC/SOH task boundary is not fully frozen. | P0 for public contributor intake | Define protocol-specific required outputs and adapter hooks. |
| Integrated post-merge gates have not been rerun on final assembled trees. | P0 | Run A9 commands on assembled refs. |
| Dataset license, availability, and cache evidence are not frozen into a release dossier. | P1 | Add per-dataset rows with license/access/cache/split caveats. |
| Stats and datasets export conflicts require serial integration. | P1 | Preserve additive export union and replay import/focused tests after each merge. |
| Untrusted public submission sandbox enforcement is not proven. | P1 | Keep alpha intake template-only or add enforced sandbox validation before running arbitrary external code. |

## W7-m Validation Plan

This W7-m artifact has no executable script. The validation for this branch is:

```bash
git diff --check
```

Additional validation is the read-only cross-check recorded above: charter,
research-gate protocol, Wave 1/4/5/6 artifacts, and runner/stats/datasets
integration worktrees were inspected and each requirement in this plan is
marked testable or blocked.
