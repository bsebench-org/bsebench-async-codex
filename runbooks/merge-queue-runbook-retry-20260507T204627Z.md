# GLASSBOX Merge Queue Runbook Retry

- Worker: W4-02
- Generated: 2026-05-07
- Owned path: `runbooks/merge-queue-runbook-retry-20260507T204627Z.md`
- Scope: Phase 8 merge queue validation and replay policy after the first Wave 1-3 task set
- Status: PASS for runbook completion; BLOCK merge of failed placeholder branches

## Objective

Create the replacement merge queue runbook for the Wave 3 merge-queue task that stopped at the Codex usage limit. This artifact defines how to integrate the Phase 8 branches without losing GLASSBOX evidence, without merging placeholder branches, and without turning report-only artifacts into scientific claims.

Success for this retry is a concrete operator runbook that:

- Accounts for the prior `phase-8-2-k` failed log.
- Separates source-repo branch lanes from async/report validation lanes.
- Defines merge order, conflict policy, validation replay, and branch deletion policy.
- Records the commands and evidence inspected.
- States explicit non-claims and residual risks.

## Evidence Inspected

- Watchdog logs under `/home/oakir/.local/state/bsebench-async-watchdog`.
- Branch heads in:
  - `/mnt/c/doctorat/bsebench-org/bsebench-runner`
  - `/mnt/c/doctorat/bsebench-org/bsebench-stats`
  - `/mnt/c/doctorat/bsebench-org/bsebench-datasets`
  - `/mnt/c/doctorat/bsebench-org/bsebench-async-codex-cto-report`
- Protocol docs:
  - `docs/PROTOCOL.md`
  - `templates/merge-validate-template.md`
  - `docs/BSEBENCH-UNIVERSAL-PARALLEL-WAVE-2026-05-07.md`
- Existing Wave 1 integration map from `origin/phase-8-1-o-integration-conflict-map-20260507T193050Z`.
- Current branch and worktree state for this W4-02 retry branch.

## Commands Run

Log and branch inspection:

```bash
find /home/oakir/.local/state/bsebench-async-watchdog -maxdepth 1 -type f \
  \( -name 'manual-phase-8-0-*.log' -o -name 'manual-phase-8-1-*.log' -o -name 'manual-phase-8-2-*.log' \) \
  -printf '%f\n' | sort | wc -l

rg -l "ERROR: You've hit your usage limit" \
  /home/oakir/.local/state/bsebench-async-watchdog/manual-phase-8-{0,1,2}-*.log | sort

find /home/oakir/.local/state/bsebench-async-watchdog -maxdepth 1 -type f \
  -name 'manual-phase-8-3-*.log' -printf '%f\n' | sort | wc -l

git ls-remote --heads origin 'phase-8-0-*' 'phase-8-1-*' 'phase-8-2-*' 'phase-8-3-*'
```

Repository refresh and branch inventory:

```bash
for d in \
  /mnt/c/doctorat/bsebench-org/bsebench-runner \
  /mnt/c/doctorat/bsebench-org/bsebench-stats \
  /mnt/c/doctorat/bsebench-org/bsebench-datasets \
  /mnt/c/doctorat/bsebench-org/bsebench-async-codex-cto-report
do
  git -C "$d" fetch origin --prune
  git -C "$d" for-each-ref --format='%(refname:short) %(objectname:short) %(subject)' refs/remotes/origin
done
```

Changed-file and mergeability checks:

```bash
git -C <repo> diff --name-status origin/main...origin/<phase-branch>
git -C <repo> merge-tree --write-tree origin/main origin/<phase-branch>
```

Temporary merge simulations:

```bash
git -C <repo> worktree add --detach /tmp/<repo>-merge-sim origin/main
git -C /tmp/<repo>-merge-sim -c user.name=merge-sim -c user.email=merge-sim@example.invalid \
  merge --no-ff --no-edit origin/<phase-branch>
git -C <repo> worktree remove --force /tmp/<repo>-merge-sim
```

Final artifact validation:

```bash
git diff --check
```

## Log Accounting

Historical Wave 1-3 Phase 8 logs:

- `manual-phase-8-0-*.log`, `manual-phase-8-1-*.log`, and `manual-phase-8-2-*.log` count: `48`.
- Exact usage-limit failures among those 48: `3`.
- Failed logs:
  - `manual-phase-8-2-j-reproducibility-artifact-manifest-audit-20260507T193528Z.log`
  - `manual-phase-8-2-k-merge-queue-runbook-20260507T193528Z.log`
  - `manual-phase-8-2-l-worker-triage-and-relaunch-runbook-20260507T193528Z.log`
- Non-usage-limit logs in the historical 48: `45`.

Wave 4 retry/hardening logs had already started at inspection time:

- `manual-phase-8-3-*.log` count observed: `24`.
- The presence of a Wave 4 log is not merge-readiness evidence by itself.
- A Wave 4 branch is merge-ready only after its remote head exists, differs from `origin/main`, contains the owned artifact, and passes replay validation.

Prior failed task accounting:

- `phase-8-2-k-merge-queue-runbook-20260507T193528Z` failed before producing its owned artifact.
- Its log contains only the task prompt and two exact usage-limit errors.
- Do not merge `phase-8-2-k` as a valid runbook branch.
- This W4-02 artifact is the replacement for the failed Wave 3 merge-queue runbook.

## Branch Findings

Source repo Wave 1 branch heads observed on origin:

| Repo | Branches | Finding |
| --- | --- | --- |
| `bsebench-runner` | `phase-8-0-a` to `phase-8-0-f` | All six remote heads exist. Each was individually mergeable against `origin/main` by `merge-tree`. Temporary cumulative merge simulation passed in the proposed order. |
| `bsebench-stats` | `phase-8-0-g` to `phase-8-0-l` | All six remote heads exist. Each was individually mergeable against `origin/main`. Temporary cumulative merge simulation conflicted on `src/bsebench_stats/__init__.py` at the second stats branch, so export-union resolution is required. |
| `bsebench-datasets` | `phase-8-0-m` to `phase-8-0-r` | All six remote heads exist. Each was individually mergeable against `origin/main`. Temporary cumulative merge simulation conflicted on `src/bsebench_datasets/__init__.py` when adding dataset-card exports, so export-union resolution is required. |
| `bsebench-async-codex-cto-report` | `phase-8-0-s` to `phase-8-0-x`, `phase-8-1-k` to `phase-8-1-v`, `phase-8-2-a` to `phase-8-2-i` | Remote heads exist for all listed branches. Each was individually mergeable, and a temporary cumulative simulation across these 27 branches passed. |

Failed Wave 3 branch heads:

- `phase-8-2-j`, `phase-8-2-k`, and `phase-8-2-l` are not valid merge inputs.
- They correspond to usage-limit logs and must be replaced by successful retry branches.
- At inspection time, no remote `phase-8-3-*` retry heads were advertised by `git ls-remote`; local Wave 4 placeholders at the inherited base commit are not queue entries.

## Merge Queue Order

Use independent queues per repository. Do not try to make Phase 8 cross-repo merges atomic. A source repo can advance only after its own branch replay gates pass and its async/report evidence is recorded.

### Runner Lane

Merge order:

1. `origin/phase-8-0-a-universal-runner-estimator-plugin-contract`
2. `origin/phase-8-0-b-universal-runner-protocol-registry`
3. `origin/phase-8-0-c-universal-runner-degraded-initialization`
4. `origin/phase-8-0-d-universal-runner-leakage-split-guard`
5. `origin/phase-8-0-e-universal-runner-compute-profiling-hooks`
6. `origin/phase-8-0-f-universal-runner-submission-smoke`

Rationale:

- The adapter contract and protocol registry should land before policy, split guard, and profiling features that may refer to benchmark structure.
- Degraded initialization and split guard should land before profiling hooks because `tests/test_orchestrator.py` and public exports are the highest runner overlap points.
- Temporary cumulative merge simulation passed in this order.

Replay gates:

```bash
uv run pytest tests/test_estimator_contract.py
uv run pytest tests/test_protocol_registry.py
uv run pytest tests/test_initialization_policy.py tests/test_orchestrator.py
uv run pytest tests/test_split_guard.py
uv run pytest tests/test_profiling.py tests/test_orchestrator.py
uv run pytest tests/test_submission_smoke.py
uv run pytest -m "not slow" --tb=short
uv run ruff format --check .
uv run ruff check .
git diff --check
```

### Stats Lane

Merge order:

1. `origin/phase-8-0-g-universal-stats-metric-matrix`
2. `origin/phase-8-0-h-universal-stats-convergence-metrics`
3. `origin/phase-8-0-i-universal-stats-robustness-noise-schema`
4. `origin/phase-8-0-j-universal-stats-compute-cost-aggregator`
5. `origin/phase-8-0-k-universal-stats-multi-axis-ranking`
6. `origin/phase-8-0-l-universal-stats-transfer-matrix`

Conflict policy:

- Expect `src/bsebench_stats/__init__.py` conflicts.
- Resolve by preserving every public export added by already-merged branches and the branch being merged.
- Do not remove existing Hinf or residual-analysis exports while adding Phase 8 exports.
- After each export resolution, run import-focused tests before continuing.

Replay gates:

```bash
uv run pytest tests/test_metric_matrix.py
uv run pytest tests/test_convergence.py
uv run pytest tests/test_robustness_noise_schema.py
uv run pytest tests/test_compute_cost.py
uv run pytest tests/test_multi_axis_ranking.py
uv run pytest tests/test_transfer_matrix.py
uv run pytest -m "not slow" --tb=short
uv run ruff format --check .
uv run ruff check .
git diff --check
```

### Datasets Lane

Merge order:

1. `origin/phase-8-0-m-universal-datasets-etl-contract`
2. `origin/phase-8-0-q-universal-datasets-equipment-registry`
3. `origin/phase-8-0-o-universal-datasets-split-metadata`
4. `origin/phase-8-0-n-universal-datasets-ground-truth-audit`
5. `origin/phase-8-0-p-universal-datasets-card-schema`
6. `origin/phase-8-0-r-universal-datasets-monthly-availability`

Conflict policy:

- Expect `src/bsebench_datasets/__init__.py` conflicts when adding multiple metadata/schema exports.
- Resolve by union, preserving all previously merged exports.
- Keep split metadata changes separate from dataset-card and availability exports.
- If `splits/audit_j_v1.yaml` conflicts, block and replay split-schema tests before any source push.

Replay gates:

```bash
uv run pytest tests/test_etl_contract.py
uv run pytest tests/test_equipment_registry.py
uv run pytest tests/test_split_audit_j_v1.py
uv run pytest tests/test_ground_truth_metadata_audit.py
uv run pytest tests/test_dataset_card.py
uv run pytest tests/test_availability_snapshot.py
uv run pytest -m "not slow" --tb=short
uv run ruff format --check .
uv run ruff check .
git diff --check
```

### Async Operations Lane

Merge order:

1. `origin/phase-8-0-s-universal-async-submission-template`
2. `origin/phase-8-0-t-universal-async-monthly-snapshot-schema`
3. `origin/phase-8-0-u-universal-async-charter-gate`
4. `origin/phase-8-0-v-universal-async-disjoint-wave-planner`
5. `origin/phase-8-0-w-universal-async-public-release-checklist`
6. `origin/phase-8-0-x-universal-async-no-idle-capacity-policy`

Replay gates:

```bash
bash -n scripts/*.sh
bash tests/check-research-brief-gates.sh
bash tests/test-disjoint-wave-planner.sh
bash scripts/check-no-idle-capacity-policy.sh
git diff --check
```

Additional async audit gate:

```bash
rg -n -i 'state-of-the-art|SOTA|leaderboard|breakthrough|novel|verified claim' \
  docs audits templates backlog runbooks
```

Any positive hit must be manually classified. Non-claim guardrail text is allowed; unsupported benchmark or research-performance claims are not.

### CTO Validation And Methodology Lane

After the relevant source lanes have replayed, merge report-only branches in this order:

1. Wave 1 validation reports: `phase-8-1-k`, `phase-8-1-l`, `phase-8-1-m`, `phase-8-1-n`
2. Wave 1 integration and public-readiness reports: `phase-8-1-o` through `phase-8-1-v`
3. Wave 3 methodology audits that completed: `phase-8-2-a` through `phase-8-2-i`
4. Successful Wave 4 retry replacements for the failed Wave 3 tasks:
   - `phase-8-3-a-retry-repro-artifact-manifest-20260507T204627Z`, only after it has a non-base remote head and owned artifact.
   - `phase-8-3-b-retry-merge-queue-runbook-20260507T204627Z`, this artifact after push.
   - `phase-8-3-c-retry-worker-triage-runbook-20260507T204627Z`, only after it has a non-base remote head and owned artifact.

Do not merge `phase-8-2-j`, `phase-8-2-k`, or `phase-8-2-l`.

## General Merge Procedure

For every queued branch:

1. Fetch:

   ```bash
   git fetch origin --prune
   git ls-remote --heads origin <branch>
   ```

2. Verify the branch is not a placeholder:

   ```bash
   git rev-parse origin/main
   git rev-parse origin/<branch>
   git diff --name-status origin/main...origin/<branch>
   ```

   A branch with no owned-path diff is not merge-ready.

3. Verify metadata:

   ```bash
   git log -1 --format='%H%n%B' origin/<branch>
   git log -1 --format='%B' origin/<branch> | rg -i 'Co-Authored-By:.*Claude' && exit 1
   ```

4. Merge in a clean temporary worktree or dedicated merge-validation worktree, never in a dirty developer worktree.

5. Replay focused tests for the branch and the repo-level fast suite.

6. Run `git diff --check` before and after conflict resolution.

7. Push `main` only after replay gates pass.

8. Write or update the corresponding GLASSBOX `CHEF_VERDICT.md` or validation record with:

   - Branch name and pre-merge SHA.
   - Merge strategy and post-merge `main` SHA.
   - Commands run and pass/fail status.
   - Conflict files and manual resolutions, if any.
   - Explicit statement that no protected files were edited.

9. Delete the feature branch only after:

   - `origin/main` contains the merged SHA.
   - The verdict/evidence record has been committed and pushed.
   - The operator confirms the branch was not a failed placeholder.

## Conflict Policy

Block and escalate immediately if a conflict touches any protected target:

- Thesis files.
- Manuscript files.
- Claim registry files.
- `claims/registry.yaml`.
- `claim_55`.
- Scientific roadmap files.

For allowed conflicts:

- Prefer additive union for package exports and documentation lists.
- Preserve all branch-specific tests.
- Do not delete a validation artifact to resolve a path conflict.
- Do not hand-resolve schema changes without rerunning schema fixture tests.
- If two branches define incompatible behavior, stop after the first failed replay gate and create a follow-up fix branch instead of forcing a merge.

Known allowed conflict clusters:

- `bsebench-stats`: `src/bsebench_stats/__init__.py`.
- `bsebench-datasets`: `src/bsebench_datasets/__init__.py`.
- `bsebench-runner`: watch `src/bsebench_runner/__init__.py` and `tests/test_orchestrator.py`, although the proposed source order simulated cleanly.

## Validation Replay Policy

Logs are evidence, not authority. A branch may enter the merge queue only if replay validation succeeds on the exact commit being merged.

Minimum replay per source repo:

- Branch-focused tests for changed functionality.
- Full fast or non-slow test suite where practical.
- Ruff format and lint checks where configured.
- `git diff --check`.
- Import/export smoke checks after any `__init__.py` conflict resolution.

Minimum replay per report-only async branch:

- `git diff --check`.
- Path ownership check against the worker brief.
- Unsupported-claim language scan.
- Protected-file scan.
- Manual check that every finding is framed as audit, recommendation, or risk unless backed by a complete source ledger.

## Recommendations

- Start with source-repo lanes, because later reports depend on source branch reality.
- Use temporary merge-validation worktrees and never operate in the dirty `/mnt/c/doctorat/bsebench-org/bsebench-async-codex` checkout, which had untracked outbox files during inspection.
- Treat `bsebench-stats` and `bsebench-datasets` as manual export-union merge batches.
- Merge report-only CTO artifacts after source branches and validation reports are stable.
- Keep failed Wave 3 placeholders out of the queue and explicitly replace them with successful Wave 4 retry branches.
- Re-run `git ls-remote` immediately before merging because Wave 4 retry branches may appear after this runbook was written.

## Residual Risks

- Branch heads can move after this inspection.
- Some Wave 4 logs were in progress, and local placeholder branches existed at the inherited base commit.
- Temporary merge simulations do not replace test replay.
- The unsupported-claim scan can produce false positives from guardrail text; manual classification is still required.
- The report does not prove benchmark correctness, scientific novelty, or public-release readiness.

## Explicit Non-Claims

- This runbook does not claim BSEBench is state of the art.
- This runbook does not claim benchmark rankings, leaderboard status, or empirical superiority.
- This runbook does not verify any scientific claim or source ledger.
- This runbook does not merge any source branch by itself.
- This runbook does not validate protected thesis, manuscript, claim registry, `claim_55`, or roadmap content.
- This runbook does not certify that future Wave 4 branches are merge-ready before they have remote heads, owned artifacts, and replay validation.

## Pass/Fail Summary

- Historical Wave 1-3 log accounting: PASS, `48` logs found.
- Prior failed-log accounting: PASS, exact usage-limit failures are `phase-8-2-j`, `phase-8-2-k`, and `phase-8-2-l`.
- `phase-8-2-k` replacement requirement: PASS, this artifact replaces the failed runbook.
- Individual `merge-tree` checks for non-failed Wave 1-3 remote heads: PASS.
- Runner cumulative merge simulation: PASS.
- Async/report cumulative merge simulation: PASS.
- Stats cumulative merge simulation: BLOCKED on expected `src/bsebench_stats/__init__.py` export conflict; manual union policy defined.
- Datasets cumulative merge simulation: BLOCKED on expected `src/bsebench_datasets/__init__.py` export conflict; manual union policy defined.
- Failed placeholder branches: FAIL for merge readiness; do not merge.
- Final `git diff --check`: PASS.
