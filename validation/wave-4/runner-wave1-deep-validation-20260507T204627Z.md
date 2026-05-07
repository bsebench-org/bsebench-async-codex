---
GLASSBOX:
  worker: W4-04
  role: codex-cto-validation
  artifact: runner-wave1-deep-validation
  created_utc: 2026-05-07T20:54:58Z
  target_branch: phase-8-3-d-runner-wave1-deep-validation-20260507T204627Z
  write_set: validation/wave-4/runner-wave1-deep-validation-20260507T204627Z.md
---

# Runner Wave 1 Deep Validation

## Objective

Deep-validate Phase 8 runner Wave 1 outputs R1-R6 using manual logs, local/remote branch heads, branch-level replay tests, and a temporary integrated merge replay. The validation goal is to determine whether these runner branches are ready to enter a controlled integration queue for the universal BSEBench runner surface, without making unsupported scientific or benchmark-performance claims.

## Evidence Inspected

- Watchdog logs under `/home/oakir/.local/state/bsebench-async-watchdog`.
- Runner worktrees under `/mnt/c/doctorat/bsebench-org/bsebench-runner-phase-8-0-{a,b,c,d,e,f}-*`.
- Runner remote refs fetched from `origin`.
- Branch commit stats via `git show --stat --oneline --decorate --no-renames HEAD`.
- Focused replay tests on each runner branch.
- Temporary integrated runner worktree made from `origin/main` plus R1-R6 in order.

## Log Accounting

Command:

```bash
find /home/oakir/.local/state/bsebench-async-watchdog -maxdepth 1 -type f \
  \( -name 'manual-phase-8-0-*.log' -o -name 'manual-phase-8-1-*.log' -o -name 'manual-phase-8-2-*.log' \) | wc -l
```

Observed result: `48`.

Command:

```bash
usage=0; complete=0
for f in /home/oakir/.local/state/bsebench-async-watchdog/manual-phase-8-{0,1,2}-*.log; do
  if rg -q "You've hit your usage limit" "$f"; then usage=$((usage+1)); else complete=$((complete+1)); fi
done
printf 'pre-wave4-total=48 complete-like-no-usage-limit=%s usage-limit=%s\n' "$complete" "$usage"
```

Observed result: `pre-wave4-total=48 complete-like-no-usage-limit=45 usage-limit=3`.

The three usage-limit logs are:

- `manual-phase-8-2-j-reproducibility-artifact-manifest-audit-20260507T193528Z.log`
- `manual-phase-8-2-k-merge-queue-runbook-20260507T193528Z.log`
- `manual-phase-8-2-l-worker-triage-and-relaunch-runbook-20260507T193528Z.log`

Each contains only the worker prompt plus repeated `ERROR: You've hit your usage limit...` lines. Wave 4 retry/deep-validation logs now exist in addition to the original 48-log baseline.

## Runner Branch Head Check

Command:

```bash
for d in /mnt/c/doctorat/bsebench-org/bsebench-runner-phase-8-0-{a,b,c,d,e,f}-*; do
  branch=$(git -C "$d" branch --show-current)
  git -C "$d" fetch origin --prune >/dev/null
  head=$(git -C "$d" rev-parse --short HEAD)
  upstream=$(git -C "$d" rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null || true)
  remote=$(if [ -n "$upstream" ]; then git -C "$d" rev-parse --short "$upstream"; else printf 'NO_UPSTREAM'; fi)
  status=$(git -C "$d" status --short)
  if [ -z "$status" ]; then status='clean'; else status='dirty'; fi
  printf '%s %s HEAD=%s UPSTREAM=%s REMOTE=%s STATUS=%s\n' "$(basename "$d")" "$branch" "$head" "${upstream:-NO_UPSTREAM}" "$remote" "$status"
done
```

Observed result:

| Runner output | Branch | Local HEAD | Upstream HEAD | Status |
| --- | --- | --- | --- | --- |
| R1 | `phase-8-0-a-universal-runner-estimator-plugin-contract` | `7f590c2` | `7f590c2` | clean |
| R2 | `phase-8-0-b-universal-runner-protocol-registry` | `acf95fa` | `acf95fa` | clean |
| R3 | `phase-8-0-c-universal-runner-degraded-initialization` | `944a152` | `944a152` | clean |
| R4 | `phase-8-0-d-universal-runner-leakage-split-guard` | `5d8efab` | `5d8efab` | clean |
| R5 | `phase-8-0-e-universal-runner-compute-profiling-hooks` | `2006dff` | `2006dff` | clean |
| R6 | `phase-8-0-f-universal-runner-submission-smoke` | `ce792f3` | `ce792f3` | clean |

Pass: all six runner Wave 1 branch heads match their upstream `origin/*` refs after fetch, and all six worktrees were clean after validation replay.

## Branch Output Summary

| Output | Commit | Main surface added | Log-reported validation |
| --- | --- | --- | --- |
| R1 | `7f590c24085395ea8c9a999e196c50defa00b139` | `src/bsebench_runner/estimator_contract.py`, toy estimator fixture, estimator contract tests | `tests/test_estimator_contract.py` 9 passed; orchestrator/residual subset 14 passed; ruff and diff checks passed |
| R2 | `acf95fa072d3a91e32669b66f7c170012d8289de` | `src/bsebench_runner/protocol_registry.py`, protocol registry tests | focused registry tests 6 passed; non-slow subset 69 passed, 2 deselected; ruff and format checks passed |
| R3 | `944a15213ed40e62788d668c442ff9ffa74393a1` | `src/bsebench_runner/initialization_policy.py`, degraded initialization tests and orchestrator fixture variants | focused fast tests 17 passed; non-slow suite 150 passed, 5 deselected; ruff and diff checks passed |
| R4 | `5d8efab0c9533315ae9b3371ba74d05899ceaffc` | `src/bsebench_runner/split_guard.py`, split leakage guard exports/tests | split guard tests 6 passed; non-slow suite 147 passed, 5 deselected; ruff and diff checks passed |
| R5 | `2006dffa8aba6b6bd500657ee41973c828069d3e` | `src/bsebench_runner/profiling.py`, orchestrator profiling metadata hooks/tests | focused profiling/orchestrator tests 12 passed; non-slow suite 145 passed, 5 deselected; ruff and diff checks passed |
| R6 | `ce792f35b96a3aaa544c8c21b7c859f68f8400cf` | external submission example, toy submission split, submission smoke test | submission smoke 1 passed; non-slow suite 142 passed, 5 deselected; ruff and diff checks passed |

R6's commit subject is plain (`Add toy external submission smoke`), but its commit body contains GLASSBOX metadata with worker, scope, and validation commands.

## Focused Replay Gates Run By W4-04

Environment note: importing `bsebench_filters` requires the legacy Audit J autoresearch path in this checkout. Replay commands that exercised runner imports were corrected to set:

```bash
BSEBENCH_LEGACY_AUTORESEARCH_DIR=/mnt/c/doctorat/these_lfp_2026/ecm_fidelity_lfp/autoresearch
```

Per-branch replay results:

| Output | Command | Result |
| --- | --- | --- |
| R1 | `BSEBENCH_LEGACY_AUTORESEARCH_DIR=... UV_PROJECT_ENVIRONMENT=/tmp/bsebench-runner-validate-8-0-a-venv uv run --with pytest --with pytest-cov pytest tests/test_estimator_contract.py -q` | 9 passed |
| R2 | `BSEBENCH_LEGACY_AUTORESEARCH_DIR=... UV_PROJECT_ENVIRONMENT=/tmp/bsebench-runner-validate-8-0-b-venv uv run --with pytest --with pytest-cov pytest tests/test_protocol_registry.py -q` | 6 passed |
| R3 | `.venv/bin/pytest tests/test_initialization_policy.py tests/test_orchestrator.py -m fast -q` | 17 passed |
| R4 | `BSEBENCH_LEGACY_AUTORESEARCH_DIR=... /tmp/bsebench-runner-r4-venv/bin/pytest tests/test_split_guard.py -q` | 6 passed |
| R5 | `BSEBENCH_LEGACY_AUTORESEARCH_DIR=... UV_PROJECT_ENVIRONMENT=/tmp/bsebench-runner-validate-8-0-e-venv uv run --with pytest --with pytest-cov pytest tests/test_profiling.py tests/test_orchestrator.py -m fast -q` | 12 passed |
| R6 | `.venv/bin/pytest tests/test_submission_smoke.py -q` | 1 passed |

Observed failed setup attempts, accounted for:

- R1/R5 initial `uv run pytest ...` failed because `pytest` was not in the temporary project environment. Corrected by adding `--with pytest --with pytest-cov`.
- R1/R2/R5 initial import attempts failed without `BSEBENCH_LEGACY_AUTORESEARCH_DIR`; corrected by setting the local legacy path above.
- R4 initial path guess `/mnt/c/doctorat/Autoresearch` failed; corrected to `/mnt/c/doctorat/these_lfp_2026/ecm_fidelity_lfp/autoresearch`.

These were environment/setup failures, not assertion failures in the runner changes.

## Temporary Integration Replay

Command pattern:

```bash
tmp=$(mktemp -d /tmp/bsebench-runner-wave1-integrated.XXXXXX)
base=/mnt/c/doctorat/bsebench-org/bsebench-runner-phase-8-0-a-universal-runner-estimator-plugin-contract
git -C "$base" worktree add --detach "$tmp" origin/main >/dev/null
for ref in \
  origin/phase-8-0-a-universal-runner-estimator-plugin-contract \
  origin/phase-8-0-b-universal-runner-protocol-registry \
  origin/phase-8-0-c-universal-runner-degraded-initialization \
  origin/phase-8-0-d-universal-runner-leakage-split-guard \
  origin/phase-8-0-e-universal-runner-compute-profiling-hooks \
  origin/phase-8-0-f-universal-runner-submission-smoke
do
  git -C "$tmp" -c user.name=wave1-validator -c user.email=wave1-validator@example.invalid merge --no-edit --no-ff "$ref" >/dev/null
done
git -C "$tmp" diff --check
cd "$tmp"
BSEBENCH_LEGACY_AUTORESEARCH_DIR=/mnt/c/doctorat/these_lfp_2026/ecm_fidelity_lfp/autoresearch \
  UV_PROJECT_ENVIRONMENT=/tmp/bsebench-runner-wave1-integrated-venv \
  uv run --with pytest --with pytest-cov pytest \
    tests/test_estimator_contract.py \
    tests/test_protocol_registry.py \
    tests/test_initialization_policy.py \
    tests/test_split_guard.py \
    tests/test_profiling.py \
    tests/test_submission_smoke.py \
    tests/test_orchestrator.py \
    -m fast -q
git -C "$base" worktree remove --force "$tmp" >/dev/null
```

Observed result:

- Sequential R1-R6 merge from `origin/main`: pass, no merge conflicts.
- Integrated `git diff --check`: pass.
- Integrated focused test suite: `43 passed in 3.58s`.

## Findings

1. PASS: R1-R6 logs each report implementation, validation, commit, push status, and clean final worktree evidence.
2. PASS: Local runner branch heads match upstream remote heads for all six outputs after fetch.
3. PASS: Focused replay gates pass for all six outputs with the documented legacy path/environment setup.
4. PASS: A temporary integration of R1-R6 over `origin/main` merges without conflicts and passes a focused integrated runner suite.
5. WATCH: The runner test environment is sensitive to `BSEBENCH_LEGACY_AUTORESEARCH_DIR`. Validation docs or CI should set the path explicitly or make pure-contract tests avoid importing legacy filter wrappers through package-level imports.
6. WATCH: R4 and R5 both touch `src/bsebench_runner/__init__.py`, and R3/R5 both extend `tests/test_orchestrator.py`. Git merged them cleanly in the tested order, but these files should be reviewed during final integration because they define shared package/export and orchestrator behavior.

## Recommendation

Runner Wave 1 R1-R6 are ready for controlled integration as a group, subject to the residual gates below. Recommended merge order for replayability is the order validated here:

1. R1 estimator adapter contract.
2. R2 protocol registry.
3. R3 degraded initialization fixtures.
4. R4 split leakage guard.
5. R5 compute profiling hooks.
6. R6 external submission smoke.

Before promoting the integrated runner branch, run the full runner non-slow gate and formatting/linting on the merged tree, not only on isolated branches:

```bash
BSEBENCH_LEGACY_AUTORESEARCH_DIR=/mnt/c/doctorat/these_lfp_2026/ecm_fidelity_lfp/autoresearch .venv/bin/pytest -m "not slow"
.venv/bin/ruff check src tests examples
.venv/bin/ruff format --check src tests examples
git diff --check
```

## Residual Risks

- W4-04 ran focused integrated tests, not the full integrated non-slow or slow runner suite.
- The integrated replay was temporary and was not pushed as an integration branch.
- Branch-level logs are manual session logs, not immutable CI artifacts.
- The validation depends on local availability of `/mnt/c/doctorat/these_lfp_2026/ecm_fidelity_lfp/autoresearch`.
- No source-ledger validation was performed for external benchmark claims because these runner outputs are code/test infrastructure rather than scientific claim artifacts.

## Explicit Non-Claims

- This artifact does not claim BSEBench is state of the art, novel, leaderboard-leading, or scientifically verified.
- This artifact does not claim any SOC/SOH estimator performance result.
- This artifact does not claim full integrated CI passed.
- This artifact does not claim dataset licensing, public availability, or provenance completeness.
- This artifact only validates the observed runner Wave 1 code/test branches and recommends further integration gates.

## W4-04 Local Artifact Validation

Commands run in this CTO-report worktree:

```bash
git diff --check
```

Observed result: pass.

Command run across runner R1-R6 worktrees:

```bash
for d in /mnt/c/doctorat/bsebench-org/bsebench-runner-phase-8-0-{a,b,c,d,e,f}-*; do
  printf '%s ' "$(basename "$d")"
  git -C "$d" diff --check
done
```

Observed result: pass for all six runner worktrees.
