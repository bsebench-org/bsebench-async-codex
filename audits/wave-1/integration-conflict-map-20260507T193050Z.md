# GLASSBOX Integration Conflict Map - Wave 1

Generated: 2026-05-07T21:43:09+02:00  
Worker: I-MAP  
Scope: Wave 1 `phase-8-0-a` through `phase-8-0-x` plus prior `phase-7-10-q` through `phase-7-10-v` branches across runner, stats, datasets, and async coordination repos.

## Evidence Commands

- `git worktree list --porcelain`
- `git fetch --all --prune` in `bsebench-runner`, `bsebench-stats`, `bsebench-datasets`, and `bsebench-async-codex-cto-report`
- `git for-each-ref --format='%(refname:short) %(objectname:short) %(upstream:short) %(committerdate:iso8601) %(subject)' refs/heads refs/remotes`
- `git ls-remote --heads origin 'phase-8-0-*' 'phase-7-10-q*' 'phase-7-10-r*' 'phase-7-10-s*' 'phase-7-10-t*' 'phase-7-10-u*' 'phase-7-10-v*' 'phase-8-1-*'`
- For each local Wave/prior worktree: `git status --short --branch`, `git diff --name-status origin/main...HEAD`, `git diff --name-status`, and `git diff --cached --name-status`
- Watchdog evidence: `stat -c '%y %n' /home/oakir/.local/state/bsebench-async-watchdog/manual-phase-8-0-*.log ...`
- Activity evidence: `ps -eo pid,stat,etime,cmd | rg 'phase-8-0-|phase-7-10-[qrstuv]|uv run|pytest|ruff'`
- Timed re-check: `sleep 30; ... git log -1 ...; git status --short | wc -l`

## Current Branch State

Do not hard-fail the active Wave 1 branches yet. At 2026-05-07T21:40-21:43+02:00, runner/stats/datasets worker processes and pytest/uv processes were still active, and watchdog logs for `phase-8-0-a` through `phase-8-0-r` were still updating. The timed re-check observed one new completed branch, `phase-8-0-j`, and left the rest of runner/stats/datasets Wave 1 as live dirty worktrees.

| Area | Branches | Observed state |
| --- | --- | --- |
| runner Wave 1 | `phase-8-0-a` to `phase-8-0-f` | Live worktrees on stale HEAD `66bd827`; dirty local files; worker processes still running. Treat file sets below as provisional until commits appear. |
| stats Wave 1 | `phase-8-0-g`, `h`, `i`, `k`, `l` | Live worktrees on stale HEAD `d7bb8bc`; dirty local files; worker processes still running. |
| stats Wave 1 | `phase-8-0-j` | Completed and pushed as `f11a151fc7c07d7c0fc5f0900126becb0e16a441`. |
| datasets Wave 1 | `phase-8-0-m` to `phase-8-0-r` | Live worktrees on stale HEAD `2b97c25`; dirty local files; worker processes still running. |
| async Wave 1 | `phase-8-0-s`, `t`, `u`, `v`, `w`, `x` | Completed local branches. Remote refs observed for `s`, `t`, `u`, `v`, `w`, `x` after fetch/ls-remote. |
| prior runner | `phase-7-10-q`, `phase-7-10-u` | Completed and pushed: `51822a3`, `5652a75`. |
| prior stats | `phase-7-10-r`, `phase-7-10-v` | Completed and pushed: `0e3b577`, `eecfc88`. |
| prior datasets | `phase-7-10-s` | Completed and pushed: `fab7172`. |
| prior async | `phase-7-10-t` | Completed and pushed: `5662c5e`. |
| prior async | `phase-7-10-q` | Completed local commit `6d7031f`; no remote branch was listed by `git ls-remote`; branch is ahead 1 and behind current `origin/main`. Integrate by local cherry-pick/rebase or push before queueing. |

## Exact Conflict Hotspots

### Runner

Highest-risk exact-file conflicts:

- `tests/test_orchestrator.py`: `phase-8-0-c` and `phase-8-0-e`.
- `src/bsebench_runner/__init__.py`: `phase-8-0-d` and `phase-8-0-e`.

Lower-risk runner changes:

- `phase-8-0-a`: adds `src/bsebench_runner/estimator_contract.py`, `tests/test_estimator_contract.py`, and `tests/fixtures/`.
- `phase-8-0-b`: adds `src/bsebench_runner/protocol_registry.py` and `tests/test_protocol_registry.py`.
- `phase-8-0-f`: modifies `README.md`; adds `examples/` and `tests/test_submission_smoke.py`.
- Prior `phase-7-10-q`: modifies Hinf residual manifest audit scripts/tests only.
- Prior `phase-7-10-u`: adds Phase 11 residual artifact contract script/test only.

Recommended runner merge order:

1. Merge prior `phase-7-10-q` and `phase-7-10-u`; they do not overlap Wave 1 runner files.
2. After Wave 1 commits appear, merge `phase-8-0-a`, then `phase-8-0-b`, then `phase-8-0-f`.
3. Merge `phase-8-0-c` before `phase-8-0-e` so degraded-initialization expectations are visible when profiling/orchestrator changes are reconciled.
4. Merge `phase-8-0-d` before `phase-8-0-e`; resolve `src/bsebench_runner/__init__.py` by preserving both split-guard and profiling exports.
5. Merge `phase-8-0-e` last in the runner batch and rerun runner fast/non-slow tests.

Rollback criteria:

- Any merge drops existing Hinf manifest replay checks or Phase 11 residual artifact contract tests.
- `tests/test_orchestrator.py` loses either degraded-initialization coverage or profiling metadata assertions.
- `src/bsebench_runner/__init__.py` no longer exports all merged public helpers.
- Focused runner tests or `git diff --check` fail after conflict resolution.

### Stats

Highest-risk exact-file conflict:

- `src/bsebench_stats/__init__.py`: `phase-8-0-g`, `h`, `i`, `j`, `k`, and `l` all add top-level exports. `phase-8-0-j` is already committed and pushed at `f11a151fc7c07d7c0fc5f0900126becb0e16a441`.

Lower-risk stats changes:

- `phase-8-0-g`: adds `metric_matrix.py` and `tests/test_metric_matrix.py`.
- `phase-8-0-h`: adds `convergence.py` and `tests/test_convergence.py`.
- `phase-8-0-i`: adds `robustness_noise_schema.py` and `tests/test_robustness_noise_schema.py`.
- `phase-8-0-j`: adds `compute_cost.py` and `tests/test_compute_cost.py`.
- `phase-8-0-k`: adds `multi_axis_ranking.py` and `tests/test_multi_axis_ranking.py`.
- `phase-8-0-l`: adds `transfer_matrix.py` and `tests/test_transfer_matrix.py`.
- Prior `phase-7-10-r`: adds Hinf LOO threshold runner and exports through `src/bsebench_stats/runners/__init__.py`.
- Prior `phase-7-10-v`: modifies PCRLB MAD preflight runner/test only.

Recommended stats merge order:

1. Merge prior `phase-7-10-r` and `phase-7-10-v`.
2. Merge completed `phase-8-0-j` first among Wave 1 stats so compute-cost exports become the first new top-level export set.
3. As each active branch commits, merge `phase-8-0-g`, `h`, `i`, `k`, and `l` one at a time. Do not batch-resolve `src/bsebench_stats/__init__.py`; verify exports after each merge.

Rollback criteria:

- `src/bsebench_stats/__init__.py` loses any export from already-merged branches.
- Any added module cannot be imported from the package top level where the branch tests require it.
- Focused stats test for the branch just merged fails.
- Non-slow stats suite or `git diff --check` fails after export reconciliation.

### Datasets

Highest-risk exact-file conflict:

- `src/bsebench_datasets/__init__.py`: `phase-8-0-n`, `phase-8-0-p`, and `phase-8-0-r`.

Medium-risk semantic conflicts:

- `phase-8-0-o` modifies `splits/audit_j_v1.yaml`, `src/bsebench_datasets/splits.py`, and `tests/test_split_audit_j_v1.py`; keep this separate from metadata/card/equipment changes and rerun split schema tests after merge.
- Prior `phase-7-10-s` modifies `src/bsebench_datasets/hinf_loader_provenance.py` and adds strict provenance audit support. It does not exact-overlap Wave 1 files but is semantically adjacent to ground-truth and ETL provenance work.

Lower-risk datasets changes:

- `phase-8-0-m`: adds `src/bsebench_datasets/etl_contract.py` and `tests/test_etl_contract.py`.
- `phase-8-0-q`: adds `src/bsebench_datasets/equipment_registry.py` and `tests/test_equipment_registry.py`.
- `phase-8-0-p`: also modifies `tests/conftest.py`; no other observed Wave/prior branch touched that file.

Recommended datasets merge order:

1. Merge prior `phase-7-10-s` first to preserve strict evidence provenance behavior before new dataset schemas land.
2. Merge `phase-8-0-m`, `phase-8-0-q`, and `phase-8-0-o` after their commits appear; each has low exact-file overlap.
3. Merge `phase-8-0-n`, `phase-8-0-p`, and `phase-8-0-r` serially, resolving `src/bsebench_datasets/__init__.py` after each branch by preserving all exports.

Rollback criteria:

- `src/bsebench_datasets/__init__.py` loses exports from a previously merged dataset helper.
- `splits/audit_j_v1.yaml` no longer validates against the split schema.
- Strict evidence provenance audit behavior from prior `phase-7-10-s` regresses.
- Focused dataset tests or `git diff --check` fail after merge.

### Async Coordination

Highest-risk exact-file conflicts:

- `scripts/cto-autonomy-pacer.sh`: prior `phase-7-10-q`, prior `phase-7-10-t`, and Wave 1 `phase-8-0-u`.
- `scripts/check-research-brief-gates.sh`: prior `phase-7-10-t` and Wave 1 `phase-8-0-u`.
- `scripts/probe-autonomy-pacer-safety.sh`: prior `phase-7-10-t` and Wave 1 `phase-8-0-u`.

Lower-risk async changes:

- `phase-8-0-s`: adds contributor submission template and validation checklist.
- `phase-8-0-t`: adds monthly snapshot schema docs, JSON schema, and fixtures.
- `phase-8-0-v`: adds disjoint-wave planner docs, script, fixtures, and tests.
- `phase-8-0-w`: adds public release checklist and updates universal benchmark charter.
- `phase-8-0-x`: adds no-idle capacity policy and checker script.
- Prior `phase-7-10-q`: also adds `scripts/async-git-state.sh`, `scripts/probe-async-git-push-race.sh`, and modifies worker/chef publication scripts.

Recommended async merge order:

1. Integrate prior `phase-7-10-q` by rebasing/cherry-picking local commit `6d7031f` onto current `origin/main` or pushing its branch first. It is the only inspected prior async branch not visible as a remote branch.
2. Merge prior `phase-7-10-t` next, then Wave 1 `phase-8-0-u`, because both extend research-brief/pacer gates and must preserve earlier reserve, claim, and push-race protections.
3. Merge low-overlap Wave 1 branches `phase-8-0-s`, `phase-8-0-t`, `phase-8-0-v`, `phase-8-0-w`, and `phase-8-0-x` in any order, with `phase-8-0-v` useful before future planners consume disjoint write-set checks.

Rollback criteria:

- `check-research-brief-gates.sh` loses any of: protected `claim_55` guard, unsupported SOTA/novelty guard, falsification/validation requirements, or universal benchmark value requirement.
- `cto-autonomy-pacer.sh` stops excluding unsafe/non-queueable BRIEFs from reserve counts or stops preserving async git state publication behavior.
- `probe-autonomy-pacer-safety.sh`, `check-research-brief-gates.sh`, or `plan-disjoint-wave.sh` focused shell tests fail.
- `bash -n scripts/*.sh` or `git diff --check` fails after merge.

## Cross-Repo Integration Plan

1. Do not integrate uncommitted runner/stats/datasets Wave 1 work from local dirty worktrees. Wait for commits, fetch, and re-check the exact file map.
2. Merge completed prior `q-v` branches first per repo, except async prior `phase-7-10-q`, which needs explicit local-commit handling because no remote branch was advertised.
3. Merge async Wave 1 completed branches now if desired, but treat the `phase-7-10-q`/`phase-7-10-t`/`phase-8-0-u` script cluster as a manual conflict-resolution batch.
4. Merge completed stats `phase-8-0-j` now or first in the stats Wave 1 batch.
5. For active runner/stats/datasets branches, re-run the file-map scan after each branch reports a commit/push in its watchdog log. Do not infer failure from stale branch heads while worker processes remain active.
6. Use package `__init__.py` reconciliation checklists for stats and datasets; these are mostly additive export conflicts and should be resolved by union, followed by focused import tests.

## Residual Risks

- Several active Wave 1 worktrees had uncommitted files and live processes at the re-check. Their final commits may add or remove conflict files from this map.
- Some local Wave 1 branches track `origin/main` even while their target remote branches exist; integration scripts should fetch and address explicit branch names rather than relying on upstream metadata.
- The async prior `phase-7-10-q` branch is ahead of local `origin/main` by one commit and behind by many commits, and no remote branch was listed. A blind merge from branch name on another machine may miss it.
- This report did not run project test suites; it is an integration planning audit. Validation after actual merges remains required.

## Audit Result

Report-only audit. No thesis files, manuscript files, claim registry files, `claims/registry.yaml`, `claim_55`, scientific roadmap files, or code files were edited by I-MAP.
