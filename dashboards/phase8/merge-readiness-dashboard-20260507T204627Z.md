# GLASSBOX Phase 8 Merge Readiness Dashboard

- Worker: W4-20
- Branch: `phase-8-3-t-phase8-merge-readiness-dashboard-20260507T204627Z`
- Sample time: 2026-05-07T20:55:59Z / 2026-05-07T22:55:59+0200
- Owned write-set: `dashboards/phase8/merge-readiness-dashboard-20260507T204627Z.md`
- Scope: Phase 8 branch readiness based on watchdog logs, fetched remote heads, guardrail evidence, whitespace checks, and merge conflict checks.

## Objective

Create a practical merge readiness view for Phase 8 so source branches, validation artifacts, retry artifacts, and failed placeholders are not conflated. This dashboard supports BSEBench's universal benchmark objective by keeping integration gated on reproducible evidence, explicit branch SHAs, conflict handling, and anti-hallucination guardrails.

This is a merge-readiness artifact, not a merge commit, public release approval, or scientific claim.

## Evidence Inspected

- Watchdog logs under `/home/oakir/.local/state/bsebench-async-watchdog/manual-phase-8-*.log`.
- Phase 8 source repos and CTO report repo:
  - `/mnt/c/doctorat/bsebench-org/bsebench-runner`
  - `/mnt/c/doctorat/bsebench-org/bsebench-stats`
  - `/mnt/c/doctorat/bsebench-org/bsebench-datasets`
  - `/mnt/c/doctorat/bsebench-org/bsebench-async-codex-cto-report`
- Wave 1 worker final summaries for `phase-8-0-a` through `phase-8-0-x`.
- Wave 2 validator/audit artifacts, especially:
  - `validation/wave-1/stats-20260507T193050Z.md`
  - `validation/wave-1/async-20260507T193050Z.md`
  - `audits/wave-1/integration-conflict-map-20260507T193050Z.md`
- Wave 4 validation/retry logs and pushed heads available at sampling, especially:
  - `phase-8-3-a` retry for the reproducibility artifact manifest
  - `phase-8-3-b` retry for the merge queue runbook
  - `phase-8-3-c` retry for the worker triage/relaunch runbook
  - `phase-8-3-e` stats deep validation
  - `phase-8-3-f` datasets deep validation
  - `phase-8-3-g` async/Wave 2 deep validation

## Commands Run

Representative commands used for the dashboard:

```bash
find /home/oakir/.local/state/bsebench-async-watchdog -maxdepth 1 -type f -name 'manual-phase-8-*.log' | sort | wc -l
find /home/oakir/.local/state/bsebench-async-watchdog -maxdepth 1 -type f -name 'manual-phase-8-3-*.log' | sort | wc -l

for f in /home/oakir/.local/state/bsebench-async-watchdog/manual-phase-8-[012]-*.log; do
  if sed -n '1,80p' "$f" | rg -q "You've hit your usage limit|usage limit"; then
    printf 'usage-limit-failed\t%s\n' "$(basename "$f")"
  elif tail -n 120 "$f" | rg -qi 'implemented and pushed|pushed to|push status|validation'; then
    printf 'completion-like\t%s\n' "$(basename "$f")"
  else
    printf 'needs-review\t%s\n' "$(basename "$f")"
  fi
done

git -C /mnt/c/doctorat/bsebench-org/bsebench-runner fetch origin --prune
git -C /mnt/c/doctorat/bsebench-org/bsebench-stats fetch origin --prune
git -C /mnt/c/doctorat/bsebench-org/bsebench-datasets fetch origin --prune
git -C /mnt/c/doctorat/bsebench-org/bsebench-async-codex-cto-report fetch origin --prune

git merge-tree --write-tree origin/main origin/<branch>
git merge-tree --write-tree origin/<branch-a> origin/<branch-b>

git diff --check origin/main...origin/phase-8-1-o-integration-conflict-map-20260507T193050Z
```

Observed evidence:

- Baseline Wave 1-3 logs: `48`
- Baseline completion-like logs: `45`
- Baseline usage-limit failures: `3`
- Live Wave 4 logs at sampling: `25`
- Total Phase 8 logs at sampling: `73`
- Individual branch merge-tree checks against each repo's `origin/main`: clean for pushed Wave 1 source branches and pushed non-failed Wave 2/Wave 3 CTO report branches.
- Pairwise conflict summary:
  - Runner Wave 1: `pairs=15`, `conflicts=0`
  - Stats Wave 1: `pairs=15`, `conflicts=15`
  - Datasets Wave 1: `pairs=15`, `conflicts=3`
  - CTO report Wave 1-3 non-failed pushed refs: `pairs=351`, `conflicts=0`
- `phase-8-1-o` whitespace check failed at `audits/wave-1/integration-conflict-map-20260507T193050Z.md:3` and `:4`.

## Classification Rules

- `READY`: branch may enter a clean merge-queue replay after final fetch, exact SHA pinning, protected-path scan, unsupported-claim scan, and focused validation replay.
- `NEEDS-FIX`: branch has useful evidence but needs manual conflict resolution, whitespace cleanup, stale-report replacement, or branch hygiene before it can be treated as merge-ready.
- `BLOCKED`: branch had no completed remote head or no durable artifact at the sample time.
- `USAGE-LIMIT-FAILED`: original log stopped with the explicit usage-limit error before producing the assigned artifact. The failed placeholder must not be merged; use a successful retry branch instead.

## Dashboard

| Lane | Branches | Classification | Evidence | Required next action |
| --- | --- | --- | --- | --- |
| Runner Wave 1 | `phase-8-0-a` through `phase-8-0-f` | READY | Pushed heads present: `7f590c240853`, `acf95fa072d3`, `944a15213ed4`, `5d8efab0c953`, `2006dffa8aba`, `ce792f35b96a`. Individual and pairwise merge-tree checks were clean. Wave 4 runner log recorded a temporary sequential merge and `43 passed`. | Merge via clean temp worktree and rerun runner focused tests plus fast/non-slow suite. Preserve `__init__.py` exports and `tests/test_orchestrator.py` coverage. |
| Stats Wave 1 | `phase-8-0-g` through `phase-8-0-l` | NEEDS-FIX | All six heads are pushed and focused replays pass: `646bf3c084cb`, `eddb3451ef06`, `0d7e275272cc`, `f11a151fc7c0`, `f42e0a0bcf02`, `59dfd52496ae`. Pairwise merge-tree reports `15/15` conflicts, centered on additive top-level exports in `src/bsebench_stats/__init__.py`. | Merge one branch at a time, resolve `__init__.py` by additive union, then rerun focused tests and import/export checks after each branch. Reset S5 local upstream or use explicit remote refs. |
| Datasets Wave 1, low-conflict | `phase-8-0-m`, `phase-8-0-o`, `phase-8-0-q` | READY | Pushed heads present: `6b6bab2df83b`, `2f0caba08b02`, `96566f9bdd17`. Wave 4 datasets validation reports focused gates passed; D3 needs isolated/fresh environment replay. | Merge after final fetch; rerun ETL, split metadata, and equipment focused gates in a clean environment. |
| Datasets Wave 1, export-conflict | `phase-8-0-n`, `phase-8-0-p`, `phase-8-0-r` | NEEDS-FIX | Pushed heads present: `a52c81dd80b8`, `e5f2305dfc20`, `c1af5d0b4c7f`. Pairwise conflicts are `n/p`, `n/r`, and `p/r`, centered on `src/bsebench_datasets/__init__.py`. | Merge serially with additive export union. Rerun ground-truth, dataset-card, availability, and package import checks. |
| Async Wave 1 | `phase-8-0-s` through `phase-8-0-x` | READY | Pushed heads present: `8b8110b56102`, `669a4eac635f`, `9ee3b5591a1d`, `cbd60b3f8f93`, `1a337a630ede`, `ce6082422e6f`. Wave 2 async validator passed branch diff, protected-path, trailer, and focused shell/doc checks. | Merge with script syntax checks and scoped research-brief gate replay. Fix local upstream hygiene for `phase-8-0-u` and `phase-8-0-w` before automation relies on `@{u}`. |
| Wave 2 validator and audit branches | `phase-8-1-l`, `n`, `p`, `q`, `r`, `s`, `t`, `u`, `v` | READY | Remote heads present and pairwise CTO report merge checks were clean. They are report-only artifacts and did not edit protected research files in inspected evidence. | Merge after final `git diff --check`, protected-path scan, and unsupported-claim scan. |
| Wave 2 stale checkpoints | `phase-8-1-k`, `phase-8-1-m` | NEEDS-FIX | These reports were valid snapshots when runner/dataset heads were absent. Later evidence shows those heads now exist, so the reports are stale as final validation gates. | Supersede or annotate as historical. Use Wave 4/source replay evidence for current runner and dataset readiness. |
| Wave 2 integration map | `phase-8-1-o` | NEEDS-FIX | Remote head `308ba3853a89` exists, but `git diff --check origin/main...origin/phase-8-1-o-*` fails on trailing whitespace at lines 3 and 4 of the audit artifact. | Remove trailing whitespace and rerun `git diff --check` before merge. |
| Wave 3 audit branches | `phase-8-2-a` through `phase-8-2-i` | READY | Remote heads present and pairwise CTO report merge checks were clean. | Merge as report-only artifacts after final guardrail and whitespace checks. |
| Wave 3 failed placeholders | `phase-8-2-j`, `phase-8-2-k`, `phase-8-2-l` | USAGE-LIMIT-FAILED | Original logs stopped in the first 80 lines with explicit `ERROR: You've hit your usage limit`. No completed remote heads existed for the original branches. | Do not merge these placeholders. Use retry branches below. |
| Wave 4 retries for failed Wave 3 tasks | `phase-8-3-a`, `phase-8-3-b`, `phase-8-3-c` | READY | Retry heads present: `4185c09053d3`, `10415cd57641`, `1bb6ad493ab7`. Logs record scoped artifacts, `git diff --check`, and push verification. | Treat as replacements/accounting for `8-2-j/k/l`; still run final report-only guardrail checks before merge. |
| Wave 4 validation/supporting artifacts | `phase-8-3-e`, `f`, `g`, `h`, `i`, `k`, `l`, `m`, `n`, `o`, `p`, `q`, `r`, `s`, `u`, `v`, `w`, `x` | READY AS SUPPORTING EVIDENCE | Remote heads present at sampling after fetch. Not all were line-reviewed by W4-20; they are available as supporting artifacts, not automatic merge approvals. | Re-fetch and run final artifact-local checks before queueing. |
| Wave 4 still missing or in progress at sampling | `phase-8-3-d`, `phase-8-3-j`, `phase-8-3-t`, `phase-8-3-y` | BLOCKED | No fetched remote head at sampling. `phase-8-3-d` has useful runner merge/test log evidence but no durable pushed artifact. `phase-8-3-t` is this dashboard branch before its own commit/push. | Do not use as completed merge evidence until a pushed branch head and final GLASSBOX artifact exist. |

## Findings

1. The earlier 48-log state is verified only for Wave 1-3. The live watchdog directory had already moved to 73 Phase 8 logs at sampling, so future dashboards must record sample time and not treat live counts as stable facts.
2. All Wave 1 source branch heads are now present. The earlier Wave 2 runner/dataset pending reports are stale checkpoints, not current final validation failures.
3. The highest mechanical integration risk is additive package export reconciliation:
   - `bsebench-stats`: all six Wave 1 branches conflict pairwise in `src/bsebench_stats/__init__.py`.
   - `bsebench-datasets`: conflicts among `phase-8-0-n`, `phase-8-0-p`, and `phase-8-0-r` in `src/bsebench_datasets/__init__.py`.
4. Runner Wave 1 is mechanically cleaner than earlier provisional reports suggested. Individual and pairwise merge-tree checks are clean, and the runner deep-validation log recorded a clean temporary sequential merge with 43 focused fast tests passing.
5. `phase-8-1-o` is the only concrete whitespace blocker found in this dashboard's explicit `git diff --check` replay.
6. The three original Wave 3 usage-limit failures are accounted for by pushed retry branches `phase-8-3-a`, `phase-8-3-b`, and `phase-8-3-c`. The original failed placeholders remain non-mergeable.
7. The Wave 4 async validation log reports `bash scripts/check-research-brief-gates.sh --dry-run --all` failing on legacy inbox Phase 7 BRIEFs. That is existing repo debt; use scoped gate invocations until the legacy backlog is remediated.
8. No evidence inspected here supports public performance, SOTA, novelty, leaderboard, breakthrough, or verified-claim language.

## Merge Queue Recommendations

1. Exclude original `phase-8-2-j/k/l` from the merge queue. Queue `phase-8-3-a/b/c` instead.
2. Fix `phase-8-1-o` whitespace before merging any Wave 2 integration-map artifact.
3. Merge runner Wave 1 as a clean temp-worktree batch or serial queue, then run focused runner tests and the practical fast/non-slow suite.
4. Merge stats Wave 1 serially. After each branch, explicitly verify top-level exports and run that branch's focused tests. Do not batch-resolve `src/bsebench_stats/__init__.py`.
5. Merge datasets Wave 1 serially, with D1/D3/D5 first and D2/D4/D6 after explicit export-union handling.
6. Merge async/report-only branches after scoped `git diff --check`, protected-path, unsupported-claim, and Co-Authored-By scans.
7. Pin exact remote SHAs immediately before merge. Branches moved while this dashboard was being prepared.

## Residual Risks

- This dashboard did not run full CI across merged source repos. It uses focused replay evidence, branch logs, remote refs, and merge-tree conflict checks.
- `merge-tree` is a conflict detector, not a semantic validator. Additive export unions still need import and focused behavior tests.
- Several Wave 4 branches were live or moving during sampling. Re-fetch before acting on any Wave 4 status.
- Local virtual environments were unreliable in some stats/datasets validations; replay in isolated or freshly rebuilt environments.
- Legacy research-brief gate failures under broad `--all` scope can obscure new failures if operators use that command without scoping.
- A report-only artifact can be mechanically mergeable while still stale as a final validator. The dashboard classifies those separately.

## Explicit Non-Claims

- This dashboard does not claim BSEBench is SOTA, novel, leaderboard-leading, a breakthrough, or scientifically verified.
- This dashboard does not validate any SOC/SOH numerical benchmark result.
- This dashboard does not rank ECMs, Kalman filters, observers, AI estimators, hybrid methods, or future filters.
- This dashboard does not certify any dataset source ledger, redistribution license, public availability, or ground-truth correctness.
- This dashboard does not edit thesis files, manuscript files, claim registry files, `claims/registry.yaml`, `claim_55`, or the scientific roadmap.
- This dashboard does not merge branches or approve publication. It identifies merge-queue readiness, blockers, and replay requirements.

## Artifact Validation

Completed by W4-20 before commit:

```bash
git diff --check
git diff --cached --check
```

Results:

- `git diff --check`: PASS with no output after writing this artifact.
- `git diff --cached --check`: PASS with no output after staging this artifact.
