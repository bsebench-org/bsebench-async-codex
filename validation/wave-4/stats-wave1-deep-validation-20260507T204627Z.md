# GLASSBOX Stats Wave 1 Deep Validation

## Objective

Deep-validate Phase 8 Wave 1 stats outputs S1-S6 from observable evidence:
manual watchdog logs, local and remote branch heads, and focused feasible test
replays. This artifact is a validation and integration hardening record only.

## Scope

- Owned artifact:
  `validation/wave-4/stats-wave1-deep-validation-20260507T204627Z.md`
- Stats worktrees inspected:
  `/mnt/c/doctorat/bsebench-org/bsebench-stats-phase-8-0-g-universal-stats-metric-matrix`
  through
  `/mnt/c/doctorat/bsebench-org/bsebench-stats-phase-8-0-l-universal-stats-transfer-matrix`
- Watchdog logs inspected:
  `/home/oakir/.local/state/bsebench-async-watchdog/manual-phase-8-0-g-*.log`
  through
  `/home/oakir/.local/state/bsebench-async-watchdog/manual-phase-8-0-l-*.log`

## Evidence Inspected

### Watchdog Log Evidence

The six S1-S6 logs are completion-like and each includes changed files, a commit
SHA, push status, and validation commands.

| ID | Log | Reported commit | Reported validation |
| --- | --- | --- | --- |
| S1 | `manual-phase-8-0-g-universal-stats-metric-matrix.log` | `646bf3c084cb14aa3270216c6b64b8c42c02f42e` | focused metric matrix tests `12 passed`; non-slow stats suite `108 passed`; ruff, format, mypy, diff check passed |
| S2 | `manual-phase-8-0-h-universal-stats-convergence-metrics.log` | `eddb3451ef06c2229d8b4370e66ad14a10fb40e6` | focused convergence tests `6 passed`; non-slow stats suite `102 passed`; ruff, format, diff check passed; original worker used isolated temp venv after locked `uv run` bootstrap issue |
| S3 | `manual-phase-8-0-i-universal-stats-robustness-noise-schema.log` | `0d7e275272cc3955e13d98717fea50dd44b90073` | focused robustness schema tests `8 passed`; non-slow stats suite `104 passed`; ruff, format, diff check passed |
| S4 | `manual-phase-8-0-j-universal-stats-compute-cost-aggregator.log` | `f11a151fc7c07d7c0fc5f0900126becb0e16a441` | focused compute cost tests `6 passed`; non-slow stats suite `102 passed`; scoped ruff, format, diff check passed |
| S5 | `manual-phase-8-0-k-universal-stats-multi-axis-ranking.log` | `f42e0a0bcf0203aab36b1dbdc7127c7cd5deddc4` | focused ranking tests `10 passed`; non-slow stats suite `106 passed`; ruff, format, diff check passed; original worker used isolated `uv` replay with `PYTHONPATH=src` |
| S6 | `manual-phase-8-0-l-universal-stats-transfer-matrix.log` | `59dfd52496aec8c946b2d8188774bdb3a6d021e0` | focused transfer matrix tests `10 passed`; non-slow stats suite `106 passed`; ruff, format, diff check passed |

### Phase 8 Log Count Sample

At the sampled time, the watchdog directory was live and had already moved past
the prompt's earlier 48-log state:

- `find ... -name 'manual-phase-8-*.log' | wc -l`: `72`
- Phase 8 Wave 0 logs: `24`
- Phase 8 Wave 1 logs: `12`
- Phase 8 Wave 2 logs: `12`
- Phase 8 Wave 3 logs: `24`

The original three Wave 3 logs with direct usage-limit failures were observed
and accounted for:

- `manual-phase-8-2-j-reproducibility-artifact-manifest-audit-20260507T193528Z.log`
- `manual-phase-8-2-k-merge-queue-runbook-20260507T193528Z.log`
- `manual-phase-8-2-l-worker-triage-and-relaunch-runbook-20260507T193528Z.log`

Retry/accounting logs for those prior failures were also present under
`manual-phase-8-3-a-*`, `manual-phase-8-3-b-*`, and `manual-phase-8-3-c-*`.
Because the log directory is live and later workers quote earlier usage-limit
text, direct text hits alone are not a reliable completion classifier.

## Branch Head Comparison

I fetched each S1-S6 stats worktree before comparing local heads with explicit
`origin/<branch>` refs. The report repository itself does not carry the stats
task branches, so the authoritative branch comparison for S1-S6 is against the
adjacent `bsebench-stats-phase-8-0-*` worktrees.

| ID | Branch | Local HEAD | Explicit remote branch | Match | Upstream note |
| --- | --- | --- | --- | --- | --- |
| S1 | `phase-8-0-g-universal-stats-metric-matrix` | `646bf3c084cb14aa3270216c6b64b8c42c02f42e` | `646bf3c084cb14aa3270216c6b64b8c42c02f42e` | PASS | upstream matches explicit branch |
| S2 | `phase-8-0-h-universal-stats-convergence-metrics` | `eddb3451ef06c2229d8b4370e66ad14a10fb40e6` | `eddb3451ef06c2229d8b4370e66ad14a10fb40e6` | PASS | upstream matches explicit branch |
| S3 | `phase-8-0-i-universal-stats-robustness-noise-schema` | `0d7e275272cc3955e13d98717fea50dd44b90073` | `0d7e275272cc3955e13d98717fea50dd44b90073` | PASS | upstream matches explicit branch |
| S4 | `phase-8-0-j-universal-stats-compute-cost-aggregator` | `f11a151fc7c07d7c0fc5f0900126becb0e16a441` | `f11a151fc7c07d7c0fc5f0900126becb0e16a441` | PASS | upstream matches explicit branch |
| S5 | `phase-8-0-k-universal-stats-multi-axis-ranking` | `f42e0a0bcf0203aab36b1dbdc7127c7cd5deddc4` | `f42e0a0bcf0203aab36b1dbdc7127c7cd5deddc4` | PASS | local upstream is incorrectly `origin/main`; explicit task branch still matches |
| S6 | `phase-8-0-l-universal-stats-transfer-matrix` | `59dfd52496aec8c946b2d8188774bdb3a6d021e0` | `59dfd52496aec8c946b2d8188774bdb3a6d021e0` | PASS | upstream matches explicit branch |

## Commands Run

Repository and log orientation:

```bash
git status -sb
git fetch origin --prune
find /home/oakir/.local/state/bsebench-async-watchdog -maxdepth 1 -type f -name 'manual-phase-8-*.log' | wc -l
for f in /home/oakir/.local/state/bsebench-async-watchdog/manual-phase-8-0-{g,h,i,j,k,l}-*.log; do tail -n 35 "$f"; done
```

Branch comparison:

```bash
for d in /mnt/c/doctorat/bsebench-org/bsebench-stats-phase-8-0-{g,h,i,j,k,l}-*; do
  b=$(git -C "$d" branch --show-current)
  git -C "$d" fetch origin --prune
  git -C "$d" rev-parse HEAD
  git -C "$d" rev-parse --verify --quiet "origin/$b"
  git -C "$d" rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null || true
done
```

Focused stats gates replayed:

```bash
PYTHONPATH=src .venv/bin/python -m pytest -o addopts='' tests/test_metric_matrix.py -q
PYTHONPATH=src uv run --no-project --isolated --with pytest --with numpy --with scipy --with pydantic python -m pytest -o addopts='' tests/test_convergence.py -q
PYTHONPATH=src .venv/bin/python -m pytest -o addopts='' tests/test_robustness_noise_schema.py -q
PYTHONPATH=src .venv/bin/python -m pytest -o addopts='' tests/test_compute_cost.py -q
PYTHONPATH=src uv run --no-project --isolated --with pytest --with numpy --with scipy --with pydantic python -m pytest -o addopts='' tests/test_multi_axis_ranking.py -q
PYTHONPATH=src .venv/bin/python -m pytest -o addopts='' tests/test_transfer_matrix.py -q
for d in /mnt/c/doctorat/bsebench-org/bsebench-stats-phase-8-0-{g,h,i,j,k,l}-*; do git -C "$d" diff --check; done
```

## Focused Replay Results

| ID | Focused replay result | Diff check |
| --- | --- | --- |
| S1 metric matrix | PASS: `12 passed in 14.22s` | PASS |
| S2 convergence metrics | PASS: `6 passed in 3.23s` using isolated `uv` env | PASS |
| S3 robustness noise schema | PASS: `8 passed in 13.01s` | PASS |
| S4 compute cost aggregator | PASS: `6 passed in 12.97s` | PASS |
| S5 multi-axis ranking | PASS: `10 passed in 3.24s` using isolated `uv` env | PASS |
| S6 transfer matrix | PASS: `10 passed in 12.99s` | PASS |

Additional environment findings:

- S2 local `.venv` is not reliable for replay: collection failed with
  `ModuleNotFoundError: No module named 'scipy._lib'`. The isolated `uv` replay
  passed and matches the original worker's note about venv/bootstrap issues.
- S5 local `.venv` is not reliable for replay: `.venv/bin/pytest --version`
  failed with `ModuleNotFoundError: No module named 'pluggy'`. The isolated
  `uv` replay passed.
- No S1-S6 stats worktree had unstaged or untracked changes after replay.

## Findings

1. S1-S6 are evidence-backed enough for integration review: each has a
   completion-like log, a pushed commit, an explicit remote branch at the local
   head, and a focused replayed test file that passes.
2. S5 needs branch hygiene before automation relies on `@{u}`: local HEAD
   matches `origin/phase-8-0-k-universal-stats-multi-axis-ranking`, but its
   upstream is `origin/main`.
3. S2 and S5 should not use their current checked-out `.venv` directories as
   validation evidence. Replays should use isolated `uv` or a freshly rebuilt
   environment.
4. The prompt's 48-log snapshot is stale as of this validation. The watchdog
   directory contained 72 Phase 8 manual logs at sampling, so future ledgers
   should include a sample timestamp or frozen manifest rather than using live
   counts as stable facts.
5. The original three Wave 3 usage-limit failures were observed and have retry
   or accounting logs. They remain an orchestration/accounting concern, not a
   S1-S6 stats implementation failure.

## Pass/Fail Decision

S1-S6 stats Wave 1 deep validation: PASS with two integration recommendations.

Recommendations before merge queue automation:

- Reset S5 local upstream to its explicit task branch or ensure merge tooling
  compares `origin/<branch>` directly instead of `@{u}`.
- Rebuild or ignore stale local `.venv` directories for S2 and S5; use isolated
  `uv` replay commands for reproducible focused validation.

## Residual Risks

- This validation replayed focused unit gates, not every non-slow suite,
  mypy, ruff, or CI job. The original logs reported broader gates, but those
  broader gates were not all rerun here.
- The watchdog directory changed while validation was in progress. Counts and
  completion classifications must be resampled before final merge readiness.
- This artifact did not inspect implementation diffs line by line for every
  S1-S6 branch; it validates observable completion, branch heads, and focused
  behavior gates.
- This artifact does not decide cross-branch integration conflicts with runner,
  datasets, or async outputs.

## Explicit Non-Claims

- No SOTA, novelty, leaderboard, breakthrough, or verified scientific claim is
  made here.
- No claim is made that any ECM, Kalman filter, observer, AI estimator, hybrid
  method, or future filter is better than another.
- No public benchmark score, SOC/SOH result, dataset truth claim, or release
  readiness claim is made here.
- No thesis files, manuscript files, claim registry files,
  `claims/registry.yaml`, `claim_55`, or scientific roadmap files were edited.

## Validation For This Artifact

Repository checks after this file was written:

- `git diff --check`: PASS
- `git status -sb`: owned untracked path only before commit:
  `validation/wave-4/stats-wave1-deep-validation-20260507T204627Z.md`
