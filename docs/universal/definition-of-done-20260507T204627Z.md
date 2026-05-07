# Universal BSEBench Definition Of Done - 2026-05-07T204627Z

## GLASSBOX Metadata

- Worker: W4-24
- Wave: Wave 4 validation, integration, and anti-hallucination hardening
- Branch: `phase-8-3-x-universal-bsebench-definition-of-done-20260507T204627Z`
- Owned write-set: `docs/universal/definition-of-done-20260507T204627Z.md`
- Evidence posture: validation and specification artifact only
- Decision posture: no scientific claim registration, no public release approval

## Objective

Define the universal BSEBench definition of done for code, data, metrics,
reports, and public claims. The definition must keep BSEBench aligned with the
universal benchmark charter: a reusable SOC/SOH evaluation standard for ECMs,
Kalman filters, observers, AI estimators, hybrid methods, and future filters.

Success for this artifact is a gate set that future validators can apply before
merging Phase 8 work or publishing any benchmark report. It must also account
for live Wave evidence and usage-limit failures without converting incomplete
worker output into public claims.

## Evidence Inspected

Commands were run from
`/mnt/c/doctorat/bsebench-org/bsebench-async-codex-cto-report-phase-8-3-x-universal-bsebench-definition-of-done-20260507T204627Z`
unless another path is listed.

| Evidence | Command Or Path | Result Used |
|---|---|---|
| Target branch state | `pwd && git status --short --branch` | Confirmed scoped worktree and branch; later fast-forwarded cleanly to current `origin/main`. |
| Repository inventory | `rg --files` and `find docs -maxdepth 3 -type f` | Confirmed this repo is a CTO report/control-plane repo and `docs/universal/` did not exist before this artifact. |
| Universal charter | `sed -n '1,220p' docs/BSEBENCH-UNIVERSAL-BENCHMARK-CHARTER-2026-05-07.md` | Source of benchmark pillars: evaluation matrix, integrity guards, plug-and-play algorithm contract, community workflow. |
| Universal parallel wave | `sed -n '1,220p' docs/BSEBENCH-UNIVERSAL-PARALLEL-WAVE-2026-05-07.md` | Source of Phase 8 task map and global guardrails. |
| GLASSBOX protocol | `sed -n '220,320p' docs/PROTOCOL.md` | Source of commit metadata and anti-pattern rules. |
| Prior Phase 8 log count | `ls /home/oakir/.local/state/bsebench-async-watchdog/manual-phase-8-[012]-*.log \| wc -l` | Confirmed the fixed pre-retry Phase 8 denominator: 48 logs. |
| Prior Phase 8 log classification | `for f in ...manual-phase-8-[012]-*.log; do ... rg -qi 'usage limit' ...; done` | Confirmed 45 completion-like logs and 3 usage-limit logs. |
| Usage-limit identities | `for f in ...manual-phase-8-[012]-*.log; do if rg -qi 'usage limit' "$f"; then basename "$f"; fi; done` | Identified `phase-8-2-j`, `phase-8-2-k`, and `phase-8-2-l` as the original gap. |
| Current Phase 8 logs | `ls /home/oakir/.local/state/bsebench-async-watchdog/manual-phase-8-*.log \| wc -l` | Confirmed the live log directory had moved beyond the fixed 48-log baseline to 72 Phase 8 logs during Wave 4. |
| Remote Wave 1 runner heads | `git -C /mnt/c/doctorat/bsebench-org/bsebench-runner ls-remote --heads origin 'phase-8-0-*'` | Confirmed remote heads for `phase-8-0-a` through `phase-8-0-f`. |
| Remote Wave 1 stats heads | `git -C /mnt/c/doctorat/bsebench-org/bsebench-stats ls-remote --heads origin 'phase-8-0-*'` | Confirmed remote heads for `phase-8-0-g` through `phase-8-0-l`. |
| Remote Wave 1 dataset heads | `git -C /mnt/c/doctorat/bsebench-org/bsebench-datasets ls-remote --heads origin 'phase-8-0-*'` | Confirmed remote heads for `phase-8-0-m` through `phase-8-0-r`. |
| Remote async/report heads | `git ls-remote --heads origin 'phase-8-*'` | Confirmed async/report heads for Wave 1 `s-x`, Wave 2 `k-v`, Wave 3 `a-i`, and pushed retry `phase-8-3-c`; did not show retry heads `phase-8-3-a` or `phase-8-3-b` at sampling. |
| Worktree inventory | `git worktree list --porcelain` and `find /mnt/c/doctorat/bsebench-org -maxdepth 1 -type d -name 'bsebench-*-phase-8-*'` | Confirmed sibling worktrees across runner, stats, datasets, and CTO report repos. |
| Wave 1 code outputs | `git -C <runner/stats/datasets phase-8-0 worktree> log -1 --oneline` and file inventories | Confirmed scoped commits exist for adapter contract, protocol registry, degraded initialization, leakage guard, profiling, submission smoke, metrics, convergence, robustness, compute, ranking, transfer, ETL, ground truth, splits, cards, equipment, and availability. |
| Wave 2/3 report outputs | Read-only inspection of committed sibling artifacts under `audits/universal/`, `audits/methodology/`, and `docs/universal/` | Confirmed source-ledger, public-release, comparability, ground-truth, leakage, metrics, compute, split, ETL, sandbox, and licensing audit patterns. |
| Retry evidence | `tail -n 80` on `manual-phase-8-3-a/b/c-*.log` plus `git ls-remote --heads origin 'phase-8-3-*'` | Confirmed `phase-8-3-c` was pushed; `phase-8-3-a` and `phase-8-3-b` had log evidence but no remote branch visible at sampling. |
| Mainline update | `git merge --ff-only origin/main` | Fast-forwarded this branch from `60fe4a7` to `69761bf` before writing. |

## Current Evidence Findings

| Finding | Status | Evidence |
|---|---|---|
| The fixed pre-retry Phase 8 baseline is verified. | PASS | 48 `manual-phase-8-[012]-*.log` files, 45 completion-like, 3 usage-limit. |
| The original usage-limit gap is identified. | PASS | The gap is `manual-phase-8-2-j-reproducibility-artifact-manifest-audit`, `manual-phase-8-2-k-merge-queue-runbook`, and `manual-phase-8-2-l-worker-triage-and-relaunch-runbook`. |
| Wave 1 technical branch heads are present remotely across runner, stats, datasets, and async/report repos. | PASS | Remote branch counts: runner 6, stats 6, datasets 6, async/report Wave 1 `s-x` 6. |
| Wave 2 async/report validation and audit heads are present remotely. | PASS | Remote heads `phase-8-1-k` through `phase-8-1-v` are visible. |
| Wave 3 methodology heads are present through `phase-8-2-i`. | PASS WITH GAP | Remote heads exist for `phase-8-2-a` through `phase-8-2-i`; `phase-8-2-j/k/l` are the original usage-limit gap. |
| Retry coverage for the original gap is incomplete as pushed remote evidence. | PARTIAL | `phase-8-3-c` is pushed; `phase-8-3-a` and `phase-8-3-b` were not visible in `git ls-remote --heads origin 'phase-8-3-*'` at sampling. |
| Wave 4 logs are live and should not be treated as final evidence by tail text alone. | PASS | `manual-phase-8-*.log` count had grown to 72; most `phase-8-3-*` report worktrees were still at the common base commit during sampling. |
| Public claims are not ready from this evidence set. | BLOCK | Source-ledger and report-comparability gates exist as specifications/audits, but no completed public source ledger for external benchmark claims was inspected. |

## Universal Definition Of Done

The project is not done because a worker reports "passed" in a log. It is done
only when every applicable gate below has committed evidence, reviewer-readable
provenance, and explicit residual-risk disposition.

### Gate 0 - Scope, Provenance, And Guardrails

Required to mark any Phase 8 artifact done:

- The branch has a single owned write-set or a documented, non-overlapping
  write-set expansion.
- Protected files are not edited: thesis files, manuscript files, claim
  registry files, `claims/registry.yaml`, `claim_55`, and the scientific
  roadmap remain untouched unless a separate authorized claim-registration task
  exists.
- The commit uses GLASSBOX metadata with `[role: ...]`, context, objective,
  problem, result, references, and `Verified-By` evidence where applicable.
- The commit has no `Co-Authored-By: Claude` trailer.
- `git diff --check` passes on the working diff and on the final committed diff.
- Any usage-limit, timeout, stale-running, or missing-push event is recorded as
  a residual risk or retried under a new branch with its own evidence.

Blocking conditions:

- Hidden protected-file edits.
- Generic commit body with no GLASSBOX evidence.
- Treating stdout log text as equivalent to a fetched branch and committed
  artifact.
- Any unaccounted usage-limit branch in a release or merge-readiness claim.

### Gate 1 - Code And Runner Done

Runner work is done only when the universal evaluation machinery is independent
from any one method or paper.

Required evidence:

- Estimator adapter contract supports at least `step(...)` semantics plus reset,
  initialization, metadata, and failure/invalid-output reporting where needed.
- Protocol registry decouples estimator implementation, dataset loading,
  initialization policy, split policy, metric selection, and report generation.
- Degraded-initialization protocols exist and record wrong-initial-state policy
  instead of silently using favorable initial SOC/SOH.
- Leakage split guard separates calibration, training/tuning, and blind
  evaluation stages.
- Profiling hooks record runtime and memory or explicitly mark unavailable
  fields without fabricating values.
- External submission smoke path proves a toy contributor adapter can run
  without modifying dataset loaders, split logic, metric computation, or report
  formatting.
- Focused tests and non-slow runner tests pass on the fetched branch or a
  read-only worktree, with exact commands and pass counts recorded.

Blocking conditions:

- Method code must import private dataset internals or rewrite benchmark logic.
- Evaluation data can affect ECM identification, hyperparameter tuning, early
  stopping, or estimator selection without a leakage violation.
- Invalid outputs, timeouts, NaNs, or exceptions are silently dropped from
  denominators.

### Gate 2 - Data And Dataset Done

Dataset work is done only when raw-to-benchmark transformation is auditable and
portable across equipment, chemistry, profile, temperature, and aging axes.

Required evidence:

- Harmonized time-series fields are defined for voltage, current, temperature,
  time delta, SOC truth, SOH truth when available, and validity masks.
- Ground-truth method is documented per dataset or marked unavailable with a
  caveat. Coulomb counting, OCV recalibration, rest-point use, capacity basis,
  and uncertainty limitations are not inferred from memory.
- Split metadata records calibration, training/tuning, validation, and blind
  evaluation partitions with dataset/profile/cell/chemistry/SOH/temperature
  identities as applicable.
- Dataset cards include chemistry, profile class, temperature, aging/SOH range,
  equipment provenance, license/access status, cache identity, and
  preprocessing/resampling policy.
- Equipment registry records known Arbin, Maccor, and other vendor formats
  where supported, while unknown formats remain explicit unknowns.
- Monthly availability snapshot records available, restricted, prospect-only,
  unavailable, and license-unclear states without treating availability as
  benchmark performance evidence.
- Focused dataset tests and non-slow dataset tests pass, or missing optional
  dependencies/data are reported as limitations.

Blocking conditions:

- SOC/SOH labels have no stated provenance or source method.
- Local cache paths are treated as permanent evidence without hashes or
  manifest identity.
- Split metadata allows leakage across calibration/training/evaluation stages.
- Dataset licensing or availability is omitted from public-facing artifacts.

### Gate 3 - Metrics And Statistics Done

Metric work is done only when every reported value has a canonical definition,
unit, aggregation policy, and invalid-run policy.

Required evidence:

- Accuracy metrics include at least RMSE, MAE, and MAXE, with SOC/SOH units and
  directionality fixed.
- Per-cell and per-profile distributions are preserved; aggregate means cannot
  be the only published evidence.
- Reliability metrics cover convergence or recovery after degraded
  initialization, robustness to Gaussian and non-Gaussian noise where relevant,
  and failure/invalid-output rates.
- Compute metrics distinguish wall time, per-step time, memory, hardware,
  operation-count/FLOP estimates where available, and unavailable fields.
- Generalization metrics support chemistry, profile, temperature, SOH/aging,
  and transfer matrices without collapsing all axes into one global score.
- Ranking/report helpers are multi-axis and caveated; they do not create a
  single global winner unless a separately frozen snapshot defines exact scope,
  exclusions, and comparability.
- Stats replay can recompute reported values from frozen artifacts or marks the
  result non-replayable.

Blocking conditions:

- Metric formula, unit, split, protocol, or denominator is missing.
- Failed, skipped, timeout, unsupported, or non-finite runs disappear from
  denominators.
- A table mixes SOC and SOH, chemistries, temperatures, horizons, or splits
  without separate rows and caveats.

### Gate 4 - Reproducibility And Integration Done

Integration is done only when the merged state can be reconstructed from
committed artifacts, branch heads, commands, and hashes.

Required evidence:

- Branch ledger lists every included branch, repository, commit SHA, changed
  files, validation commands, and pass/fail decision.
- Merge queue runbook records merge order, conflict decisions, retries,
  post-merge validation, and rollback criteria.
- Reproducibility manifest records repository SHAs, dataset/cache hashes,
  submission artifact identity, commands, environment, lockfiles, and artifact
  hashes.
- Validators fetch branches or inspect read-only worktrees after commit/push;
  watchdog logs are status signals, not final evidence.
- `git diff --check` passes after conflict resolution and again on the final
  commit range.
- Protected-file and unsupported-claim scans pass on the assembled release
  branch.

Blocking conditions:

- A branch is included without a fetched SHA or explicit unresolved status.
- A prior usage-limit branch is silently skipped instead of retried or recorded
  as a blocker.
- Merge simulation passes but post-merge focused tests are not run for touched
  code paths.

### Gate 5 - Reports And Monthly Snapshots Done

Reports and monthly snapshots are done only when every table, caption, and
summary line is tied to frozen evidence and caveats.

Required evidence:

- Snapshot manifest precedes report prose and includes branch SHAs, command
  lines, environment, dataset/cache hashes, artifact hashes, and replay status.
- Public tables state metric, unit, dataset, split/protocol, method identity,
  evidence quality, comparability status, and missing/failed-run policy.
- External comparisons cite source-ledger row IDs and inherit exact source,
  metric, dataset, split, preprocessing, and caveat fields.
- Rows marked `partial`, `not_comparable`, `not_assessed`, unavailable, failed,
  timeout, or unsupported are visually and semantically separated from fully
  comparable rows.
- Public prose is scanned for comparison or promotion language before release.
- Limitations are not an appendix-only afterthought; they appear adjacent to the
  affected tables or claims.

Blocking conditions:

- A report compares external values without a complete source ledger.
- A partial or not-comparable row is ranked as if it were comparable.
- Captions omit the frozen artifact or protocol identity needed to interpret a
  table outside the full report.

### Gate 6 - Public Claims Done

Public claims are done only through a separate source-ledger and
claim-registration lane. Benchmark evidence alone is not claim approval.

Required evidence before any public claim wording:

- Complete source ledger with stable URL or DOI, retrieval date, exact source
  location, method, metric, dataset, split/protocol, external value, frozen
  BSEBench value, BSEBench artifact path, command, comparability decision, and
  caveat.
- Claim-to-ledger matrix mapping every public sentence, table row, title,
  abstract line, release note, README excerpt, or figure caption to ledger rows.
- Separate decision record for claim registration, with explicit evidence
  status and no protected-file edits unless authorized.
- External comparison wording is downgraded to neutral evidence or omitted
  whenever ledger fields are missing or comparability is partial.

Blocking conditions:

- SOTA, novelty, leaderboard, breakthrough, or verified-claim wording appears
  without completed source-ledger and claim-registration evidence.
- A benchmark report changes thesis/manuscript/claim registry status.
- A missing source field is inferred from memory, nearby prose, or filenames.

### Gate 7 - Residual-Risk Disclosure Done

Residual-risk disclosure is done only when every known gap has an owner,
severity, state, and release effect.

Every final Phase 8 validation, release, or public-report artifact must include:

- unresolved branch or retry gaps;
- stale-running, timeout, usage-limit, push-failure, or live-log caveats;
- missing dataset, license, raw cache, ground-truth, split, or equipment fields;
- missing metric, compute, robustness, transfer, or invalid-run fields;
- missing source-ledger, comparability, or public-claim fields;
- test limits, skipped tests, unavailable optional dependencies, and local-only
  validation assumptions;
- explicit statement of what the artifact does not claim.

Blocking conditions:

- "No known risks" is written while logs, validator reports, or branch ledgers
  show active gaps.
- A residual risk has no owner, next gate, or release consequence.
- Live Wave 4 output is treated as stable without resampling.

## Pass/Fail Decision For This Snapshot

| Area | Decision | Reason |
|---|---|---|
| This definition-of-done artifact | PASS | It defines concrete gates for code, data, metrics, reports, claims, integration, and residual-risk disclosure using inspected charter and Wave evidence. |
| Universal BSEBench public release readiness | FAIL / BLOCK | A public release requires all gates above, integrated branch evidence, source-ledger completion, and disposition of retry gaps. That evidence was not complete at sampling. |
| Public comparison or claim readiness | FAIL / BLOCK | No completed source ledger for external public comparison claims was inspected in this task. |
| Phase 8 first-cohort accounting | PASS WITH GAP | The 48-log baseline and 45/3 split are verified; the original three usage-limit failures are identified and must remain blockers until retried or explicitly waived with risk. |
| Retry accounting | PARTIAL | `phase-8-3-c` is pushed; `phase-8-3-a` and `phase-8-3-b` were not visible as remote heads at sampling and must be resampled before merge/readiness claims. |

## Recommendations

1. Promote these gates into the Phase 8 merge-readiness dashboard before any
   public benchmark report is drafted.
2. Treat `phase-8-2-j/k/l` as unresolved until each has a pushed retry branch,
   a superseding committed artifact, or an explicit blocker/waiver entry.
3. Require validators to fetch remote branches and inspect committed artifacts;
   watchdog logs should only seed the validator queue.
4. Add a machine-readable checklist for Gates 0-7 so future monthly snapshot
   candidates can fail fast before prose is written.
5. Keep public reports neutral until the source-ledger matrix is complete.
6. Re-run `git diff --check`, protected-file scans, unsupported-claim scans,
   and focused tests after the actual integration branch is assembled.

## Residual Risks

- The watchdog directory is live. Counts and tail classifications can change
  after this artifact's sampling window on 2026-05-07.
- Some Wave 4 workers had logs but no pushed artifact visible in this target
  repo at sampling; this artifact does not certify their output.
- This CTO report repo does not contain all runner, stats, and datasets code.
  Code gates must be revalidated in the target repos after integration.
- Remote branch presence proves a branch was pushed, not that it is safe to
  merge. Each branch still needs fetched-branch validation and post-merge
  validation.
- Source-ledger and comparability audits define guardrails but do not by
  themselves complete an external comparison ledger.
- Fast-forwarding this branch to `origin/main` brought in unrelated upstream
  async changes before this file was added; this artifact's owned diff remains
  limited to the file named in the owned write-set.

## Explicit Non-Claims

- This artifact does not claim BSEBench is already a universal public benchmark
  standard.
- This artifact does not claim any ECM, Kalman filter, observer, AI estimator,
  hybrid method, or future filter is superior to another.
- This artifact does not make SOTA, novelty, leaderboard, breakthrough, or
  verified scientific claim statements.
- This artifact does not register, validate, or update a thesis claim.
- This artifact does not edit thesis files, manuscript files, claim registry
  files, `claims/registry.yaml`, `claim_55`, or the scientific roadmap.
- This artifact does not certify Phase 8 merge readiness or public release
  readiness; it defines the gates required before those statements can be made.

## Validation To Run For This Artifact

Required before final handoff:

```bash
git diff --check
git diff --check HEAD~1 HEAD
git status --short --branch
```

Expected result: all whitespace checks pass; final worktree is clean after the
commit; branch is pushed to
`origin/phase-8-3-x-universal-bsebench-definition-of-done-20260507T204627Z`.
