# GLASSBOX audit: test budget and CI matrix

- Worker: CI-MATRIX
- Branch: `phase-8-1-t-test-budget-ci-matrix-20260507T193050Z`
- Worktree: `/mnt/c/doctorat/bsebench-org/bsebench-async-codex-cto-report-phase-8-1-t-test-budget-ci-matrix-20260507T193050Z`
- Generated: 2026-05-07T21:37:44+02:00
- Owned write-set: `audits/universal/test-budget-ci-matrix-20260507T193050Z.md`
- Scope: audit only. No thesis, manuscript, claim registry, protected claim, or roadmap files were edited.

## Executive findings

1. The report repo itself has no package test configuration. A search for
   `pyproject.toml`, `.github/workflows/*`, `tox.ini`, `noxfile.py`,
   `pytest.ini`, `setup.cfg`, `Makefile`, and `requirements*.txt` under this
   worktree returned no CI/test config files. The actionable CI surface is in
   the sibling package repos: `bsebench-runner`, `bsebench-stats`, and
   `bsebench-datasets`.
2. As of 2026-05-07T21:35:58+02:00, Wave 1 package branches
   `phase-8-0-a` through `phase-8-0-r` had active watchdog log updates within
   seconds and no remote branch heads in their package remotes. They must be
   treated as pending, not failed. Only the async/report Wave 1 branches
   `phase-8-0-s` through `phase-8-0-x` had remote heads in the report repo at
   that checkpoint.
3. The current package CI gates are not equivalent. `runner` and `stats` use
   Python 3.11/3.12 test matrices and locked installs; `datasets` currently
   uses only Python 3.12 and does not run `uv lock --check` or `uv sync
   --locked --all-extras` in CI.
4. `runner` currently enables pytest `--strict-markers` but only declares the
   `slow` marker in `pyproject.toml`. Multiple Wave 1 runner logs show new
   tests using `@pytest.mark.fast`. Unless those branches also add the `fast`
   marker, focused and non-slow gates will fail with an unknown marker before
   validating behavior.
5. Prior chef/validator evidence shows why bare green summaries are
   insufficient: formatter drift and mismatched `uv run pytest` environments
   produced false confidence in earlier phases. Every branch report must record
   the exact command, exit code, pass count, deselection count, and the commit
   SHA tested.

## Evidence inspected

Commands run from this audit branch:

```bash
find . -maxdepth 4 -type f \( -name 'pyproject.toml' -o -name 'tox.ini' -o -name 'noxfile.py' -o -name 'pytest.ini' -o -name 'setup.cfg' -o -name 'Makefile' -o -name '*.yml' -o -name '*.yaml' -o -name 'requirements*.txt' \) | sort
find /mnt/c/doctorat/bsebench-org/bsebench-runner /mnt/c/doctorat/bsebench-org/bsebench-stats /mnt/c/doctorat/bsebench-org/bsebench-datasets /mnt/c/doctorat/bsebench-org/bsebench-async-codex -maxdepth 4 -type f \( -name 'pyproject.toml' -o -path '*/.github/workflows/*' -o -name 'tox.ini' -o -name 'noxfile.py' -o -name 'pytest.ini' -o -name 'setup.cfg' -o -name 'Makefile' -o -name 'requirements*.txt' \) | sort
sed -n '1,260p' /mnt/c/doctorat/bsebench-org/bsebench-runner/pyproject.toml
sed -n '1,220p' /mnt/c/doctorat/bsebench-org/bsebench-runner/.github/workflows/ci.yml
sed -n '1,260p' /mnt/c/doctorat/bsebench-org/bsebench-stats/pyproject.toml
sed -n '1,220p' /mnt/c/doctorat/bsebench-org/bsebench-stats/.github/workflows/ci.yml
sed -n '1,280p' /mnt/c/doctorat/bsebench-org/bsebench-datasets/pyproject.toml
sed -n '1,220p' /mnt/c/doctorat/bsebench-org/bsebench-datasets/.github/workflows/ci.yml
git ls-remote --heads origin 'phase-8-0-*' 'phase-8-1-*'
ps -ef | rg 'bsebench-(runner|stats|datasets|async-codex).*phase-8-0|phase-8-1-[klmnopqrstuv]' | rg -v 'rg ' | wc -l
for f in /home/oakir/.local/state/bsebench-async-watchdog/manual-phase-8-0-*.log; do stat -c '%y %n' "$f"; done
```

Observed config files:

| Repo | Config files found |
| --- | --- |
| `bsebench-runner` | `pyproject.toml`, `.github/workflows/ci.yml` |
| `bsebench-stats` | `pyproject.toml`, `.github/workflows/ci.yml` |
| `bsebench-datasets` | `pyproject.toml`, `.github/workflows/ci.yml` |
| `bsebench-async-codex` | none found by the config search above |
| `bsebench-async-codex-cto-report` | none found in this audit worktree |

Wave state evidence:

| Checkpoint | Evidence | Interpretation |
| --- | --- | --- |
| 2026-05-07T21:35:58+02:00 | `git ls-remote` found report repo heads for `phase-8-0-s`, `t`, `u`, `v`, `w`, `x`, and validator `phase-8-1-k` only. | Package Wave 1 branches had no stable remote heads yet. |
| 2026-05-07T21:35:58+02:00 | Wave 1 package watchdog logs were modified between 21:34:16 and 21:35:58. | Workers were still active; validators should wait and re-check. |
| 2026-05-07T21:35:58+02:00 | Process query returned 102 matching process rows. | Evidence of active phase execution. This is not a worker count because each worker has timeout/node/codex/test children. |

## Current package gates

| Repo | Current CI commands | Current pytest config | Audit classification |
| --- | --- | --- | --- |
| `bsebench-runner` | `uv sync --locked --all-extras`; `uv run --locked --all-extras pytest tests/ -v -m "not slow" --cov=bsebench_runner --cov-report=term-missing` on Python 3.11 and 3.12; strict Hinf audit scripts on Python 3.12; `ruff check`; `ruff format --check`. | `--strict-markers --strict-config`, coverage enabled, `testpaths = ["tests"]`, marker declared: `slow` only. | Strongest current CI, but at risk from Wave 1 `@pytest.mark.fast` additions unless `fast` is declared. |
| `bsebench-stats` | `uv lock --check`; `uv sync --locked --all-extras`; `uv run --locked --all-extras pytest tests/ -m "not slow" -q` on Python 3.11 and 3.12; `ruff check`; `ruff format --check`. | `--strict-markers --strict-config`, coverage enabled, markers declared: `fast`, `slow`. | Good PR gate for synthetic stats work. Slow empirical or replay jobs still need a separate tier. |
| `bsebench-datasets` | `uv sync --all-extras`; `uv run ruff format --check .`; `uv run ruff check .`; `uv run pytest -m "not slow" --tb=short` on Python 3.12 only. | `--strict-markers --strict-config`, coverage enabled, marker declared: `slow` only. | Adequate smoke gate, but weaker than runner/stats for lock discipline and Python 3.11 coverage. |
| `bsebench-async-codex` and report repo | No package CI config found. Existing templates expect `uv run pytest -m "not slow" --tb=short`, `ruff format --check`, and `ruff check` when a package repo is being validated. | Not applicable in the report repo. | Audit/docs/report branches need at minimum `git diff --check` plus forbidden-claim and scope checks. |

Recent known non-slow test budgets from existing summaries and chef verdicts:

| Repo | Recent evidence | Budget implication |
| --- | --- | --- |
| `bsebench-runner` | 108-141 passed, 5 deselected, roughly 15-27 s in prior chef verdicts. | Non-slow runner tests are suitable for every PR, but strict Hinf audit scripts should stay conditional to runner evidence/output paths. |
| `bsebench-stats` | 72-81 passed, roughly 10-11 s in prior chef verdicts after the dev-tooling gate was fixed. | Non-slow stats tests are suitable for every PR. |
| `bsebench-datasets` | 240-241 passed, 29 deselected, roughly 18-19 s in prior chef verdicts. | Non-slow dataset tests are suitable for every PR; real local `.mat` or Hugging Face data checks are not. |

These budgets are evidence from existing reports, not a fresh package test run
from this audit branch. This audit did not run package tests because the owned
write-set is a report file and Wave 1 workers were actively using separate
worktrees.

## Gate taxonomy

| Tier | Purpose | Required commands | Hard failure condition | Budget |
| --- | --- | --- | --- | --- |
| T0: scope and diff | Prevent accidental cross-worktree or forbidden-file edits. | `git status --short --branch`; `git diff --name-only`; `git diff --check`. | Any touched file outside the assigned write-set, whitespace error, claim/thesis/roadmap edit, or forbidden co-author trailer. | Under 1 min. |
| T1: focused worker gate | Validate the exact changed behavior before commit. | Focused pytest file(s), for example `uv run --locked --all-extras pytest tests/test_new_feature.py -q --tb=short`; targeted or repo-level `ruff format --check`; `ruff check`. | Focused test failure, unknown pytest marker, skipped required fixture without explicit skip reason, or missing command output in the worker report. | Target under 5 min, synthetic fixtures only. |
| T2: package fast PR gate | Catch regressions from parallel branches without real-data cost. | Repo CI non-slow pytest on the configured Python matrix plus formatter and lint. Use locked installs where the repo has a lockfile. | Any non-slow failure, formatter/lint failure, lock drift, or pass count materially below the previous baseline without explanation. | Target under 15 min per repo; investigate if over 30 min without fresh logs. |
| T3: full merge validation | Validate the pushed commit, not an active worktree. | Fresh checkout or read-only validation worktree at the remote branch SHA; repeat T2; run conditional audit scripts for touched evidence/output paths. | Remote branch SHA differs from the reported SHA, commands were run against an uncommitted worktree, or CI status is missing for required checks. | Target under 45 min for all package repos in a merge batch. |
| T4: slow/nightly/release | Real data, cache, credential, and monthly benchmark checks. | `pytest -m slow` and dataset/evidence scripts with explicit cache root, credentials status, source ledger, frozen dataset split, and output path. | Missing cache/source ledger, all-error output written as success, unsupported claim language, or inability to reproduce the frozen value. | Nightly/off-peak only; not a default PR blocker. |

## Proposed CI matrix

| Repo or branch type | Required PR checks | Conditional checks | Not allowed as PR-only evidence |
| --- | --- | --- | --- |
| `bsebench-runner` | Python 3.11 and 3.12 non-slow pytest; `uv lock --check`; `uv sync --locked --all-extras`; `ruff format --check`; `ruff check`; `git diff --check` in worker report. | Strict Hinf audit scripts when touching Hinf residual outputs, manifests, CI summaries, replay, or evidence scripts. | Real Hinf evidence claims without successful data/cache run and source ledger. |
| `bsebench-stats` | Python 3.11 and 3.12 non-slow pytest; `uv lock --check`; locked install; formatter; lint. | Numeric regression/replay fixtures when changing ranking, metric matrix, robustness, transfer, or uncertainty APIs. | Claims about superiority, ranked public standing, or statistical significance without frozen dataset/split/value evidence. |
| `bsebench-datasets` | Upgrade CI to Python 3.11 and 3.12; add `uv lock --check`; use `uv sync --locked --all-extras`; non-slow pytest; formatter; lint. | Loader smoke with synthetic/minimal local fixtures when touching adapters, split metadata, card schemas, equipment registry, or availability manifests. | Real dataset availability claims based only on synthetic fixture tests. |
| `bsebench-async-codex` and report-only branches | `git diff --check`; scoped file list check; no forbidden-file check; no unsupported claim-language check. | Shell syntax checks for edited scripts; dry-run probes for daemon/pacer changes. | Package test pass claims when no package repo was checked out at a committed SHA. |
| Cross-repo integration batch | Re-run T2 for each package after a merge batch, in dependency order: specs if changed, datasets, stats, runner, async/report. | Import smoke for runner direct dependencies pinned in the lockfile. | Validation from stale local worktrees whose branch heads do not match remote refs. |

## Validator protocol for parallel branches

1. Read the assigned watchdog log under
   `/home/oakir/.local/state/bsebench-async-watchdog`.
2. Query the target repo remote for the assigned branch head.
3. If the worker log is fresh or a matching worker process exists and no remote
   branch head exists, record `pending_worker_still_running` and re-check later.
   Do not mark failure.
4. If a remote head exists, fetch it into a fresh/read-only validation checkout
   and record the exact SHA before running gates.
5. Re-run the tier appropriate to the branch:
   - report-only branch: T0 plus scope/claim-language checks;
   - package code branch: T1 plus T2;
   - evidence/output branch: T1 plus T2 plus conditional T3 audit scripts;
   - empirical/real-data branch: T4, not just non-slow pytest.
6. A validation report is rejectable if it says "tests passed" without command
   text, exit status, pass/deselect counts, and the tested commit SHA.

## Immediate next actions

| Priority | Action | Owner artifact | Falsifiable acceptance |
| --- | --- | --- | --- |
| P0 | Add or confirm `fast` pytest marker support in `bsebench-runner` before merging Wave 1 runner branches that use `@pytest.mark.fast`. | `bsebench-runner/pyproject.toml` or branch-specific test config. | `uv run --locked --all-extras pytest tests/<wave1-focused-test>.py -q --tb=short` does not fail with an unknown marker. |
| P0 | Harden `bsebench-datasets` CI to match runner/stats lock discipline. | `.github/workflows/ci.yml` in `bsebench-datasets`. | CI includes `uv lock --check`, `uv sync --locked --all-extras`, and Python 3.11/3.12 non-slow pytest. |
| P1 | Define required status check names for package PRs. | Branch protection or documented merge checklist. | A package branch cannot merge unless non-slow pytest, formatter, lint, lock check, and diff check are green at the branch SHA. |
| P1 | Add a validator preflight that distinguishes `no remote head yet` from `failed branch`. | Validator script or template. | Given a fresh active watchdog log and no `git ls-remote` head, the validator emits `pending_worker_still_running`, not `failed`. |
| P1 | Standardize worker final reports. | Worker template. | Every final report includes changed files, commit SHA, push status, commands, exit status, pass/deselect counts, and residual risks. |
| P2 | Add a rolling cross-repo integration job after merge batches. | CI workflow or scheduler. | After N package merges or hourly during active waves, a fresh checkout runs non-slow gates for datasets, stats, and runner and posts a single integration result. |
| P2 | Keep slow empirical gates out of default PR CI but make them mandatory for release/evidence claims. | Nightly/release workflow. | Any public metric or empirical claim links to a slow-gate artifact with dataset, split, cache/source status, command, SHA, and retrieval date. |

## Residual risks

- This audit was produced while package Wave 1 workers were still running. Any
  branch that pushes after the checkpoint may alter the CI/test surface and
  should be re-inspected by its validator.
- The package repos use direct Git dependencies for sibling BSEBench packages.
  A lockfile check reduces but does not remove cross-repo moving-target risk if
  workers validate against different refs than CI.
- Existing historical pass counts are useful for budgeting but are not proof
  that the current Wave 1 branch set passes. Only fetched branch SHAs and fresh
  validation should be treated as merge evidence.
- Report-only branches can pass `git diff --check` while still containing vague
  or unsupported claims. Scope and claim-language checks remain necessary.

## Report validation

- `git diff --check`: passed at 2026-05-07T21:38+02:00.
