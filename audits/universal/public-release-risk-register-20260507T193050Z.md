# Universal Public Release Risk Register

Saved: 2026-05-07T21:37:41+02:00. Worker: RISK.

## Scope

This audit defines release risks for publishing BSEBench as a universal SOC/SOH
benchmark workflow for ECMs, Kalman filters, observers, AI estimators, and
hybrid methods.

Owned artifact: `audits/universal/public-release-risk-register-20260507T193050Z.md`.
No code, thesis, manuscript, claim registry, `claims/registry.yaml`,
`claim_55`, or scientific roadmap files were edited.

## Non-Claims

- This document is not a release approval.
- This document does not claim that BSEBench is already a public standard.
- This document does not make SOTA, novelty, leaderboard, breakthrough, or
  verified-claim statements.
- Any future external comparison must have a completed source ledger: stable
  URL or DOI, retrieval date, exact metric, dataset, split, frozen BSEBench
  value, and comparability caveat.

## Evidence Inspected

Commands and sources inspected before drafting:

| Evidence | Command or path | Result used |
|---|---|---|
| Universal wave charter | `sed -n '1,180p' docs/BSEBENCH-UNIVERSAL-PARALLEL-WAVE-2026-05-07.md` | Wave 1 task map and global guardrails. |
| Universal benchmark charter | `sed -n '1,160p' docs/BSEBENCH-UNIVERSAL-BENCHMARK-CHARTER-2026-05-07.md` | Required benchmark pillars: evaluation matrix, integrity guards, plug-and-play API, community workflow. |
| AI research risk baseline | `sed -n '1,180p' docs/AI-RISKS-2026-05-06.md` | Known risks: hallucinated sources, reward hacking, compound autonomous errors, disclosure and reproducibility issues. |
| GLASSBOX format | `sed -n '220,280p' docs/PROTOCOL.md` | Commit body requirements and no opaque commits. |
| Wave 1 logs | `find /home/oakir/.local/state/bsebench-async-watchdog -maxdepth 3 -type f` and targeted `rg` over `manual-phase-8-0-*.log` | Logs exist for all Wave 1 branches; several branches were still in progress at the sampling time. |
| Worktree state | `git -C <phase-8 worktree> status --short --branch` and `git log -1` sampling | Runner, stats, and datasets Wave 1 worktrees were observed tracking `origin/main` while workers were still running; async `s`, `t`, `v`, and `x` had pushed branch evidence. |
| Active workers | `ps -eo pid,etime,cmd | rg 'phase-8-[01]-|codex exec|bsebench'` | Phase 8 workers and validators were active during this audit. Absence of a pushed commit at this time is not failure evidence. |
| Related Wave 2 audits | sibling worktrees `phase-8-1-o` through `phase-8-1-t` | Integration map had a commit in logs; source-ledger draft file existed locally; other audit branches were still in progress or not yet committed at sampling time. |

## Snapshot Finding

Release posture at 2026-05-07T21:37:41+02:00: **not ready for public
publication**.

Reason: the universal release surface depends on Wave 1 runner, stats,
datasets, and async artifacts plus Wave 2 validation/audit reports. At sampling
time, multiple Wave 1 technical branches and Wave 2 validators were still
active. The correct release action is to wait for committed artifacts, validate
from fetched branches or read-only worktrees, and then decide. Do not mark
in-flight branches as failed solely because they have not pushed yet.

## Risk Register

| ID | Category | Severity | Risk | Trigger | Mitigation | Owner Artifact | Acceptance Gate |
|---|---|---:|---|---|---|---|---|
| PRR-001 | Technical | P0 | Premature release before Wave 1 artifacts are committed and validated. | Any public tag, README, website, snapshot, or package is produced while a Wave 1 branch lacks a fetched commit SHA and validator decision. | Release manager must consume Wave 1 validator reports only after branches have commits or are explicitly marked still-running. | `validation/wave-1/{runner,stats,datasets,async}-20260507T193050Z.md` from Wave 2 validators. | All 24 Wave 1 branches have: branch name, commit SHA or still-running status, changed files, validation commands, pass/fail decision, residual risks. |
| PRR-002 | Methodological | P0 | Calibration/evaluation leakage makes public results non-comparable. | A submission or benchmark report can train, tune, identify ECM parameters, or choose hyperparameters on evaluation data. | Enforce split metadata and leakage guard before any result table is published. | Runner leakage guard `phase-8-0-d`, dataset split metadata `phase-8-0-o`, public checklist `phase-8-0-w`. | A release candidate fails if any result lacks explicit calibration, tuning, and blind evaluation data partitions. |
| PRR-003 | Methodological | P0 | SOC/SOH ground truth is not auditable enough for community trust. | Dataset card or result includes SOC/SOH labels without source method, recalibration evidence, uncertainty/caveat, and cache identity. | Require ground-truth audit fields in dataset cards and result snapshots; mark missing evidence as non-comparable. | Dataset ground truth audit `phase-8-0-n`, dataset card schema `phase-8-0-p`, ETL contract `phase-8-0-m`. | Every published dataset cell has ground-truth method, source artifact identity, preprocessing policy, and caveat. Missing fields block publication or force "not comparable". |
| PRR-004 | Reputational | P0 | Unsupported public comparison language overstates evidence. | A public artifact uses SOTA, novelty, leaderboard, breakthrough, or verified-claim wording without a complete source ledger and comparability caveat. | Gate release prose through source-ledger audit and public release checklist; allow only neutral descriptive wording unless the ledger is complete. | Source-ledger audit `phase-8-1-q`, public release checklist `phase-8-0-w`, claim language linter history from Phase 7.10.j. | Every comparative sentence links to ledger rows with stable URL/DOI, retrieval date, exact metric, dataset, split, BSEBench frozen value, and caveat. |
| PRR-005 | Technical | P1 | Plug-and-play estimator API is unstable or too narrow for ECMs, filters, observers, AI estimators, and hybrids. | A contributor must modify dataset loading, metrics, or split logic to run a method. | Stabilize adapter contract, protocol registry, and external submission smoke path before public onboarding. | Runner adapter contract `phase-8-0-a`, protocol registry `phase-8-0-b`, submission smoke `phase-8-0-f`, API gap audit `phase-8-1-p`. | A toy external estimator and at least one wrapped internal estimator can run through the same public protocol without editing loaders or metrics. |
| PRR-006 | Methodological | P1 | Metric definitions or aggregation are ambiguous across cells, profiles, chemistry, temperature, SOH, and compute cost. | A report cannot reproduce RMSE, MAE, MAXE, convergence, robustness, transfer, or compute-cost values from the snapshot artifact. | Freeze metric schema and aggregation rules before monthly reports. | Stats metric matrix `phase-8-0-g`, convergence `phase-8-0-h`, robustness `phase-8-0-i`, compute `phase-8-0-j`, multi-axis ranking `phase-8-0-k`, transfer matrix `phase-8-0-l`, test budget matrix `phase-8-1-t`. | Each published metric has unit, aggregation axis, missing-run policy, invalid-output policy, and exact command/artifact reference. |
| PRR-007 | Technical | P1 | Reproducibility manifest is incomplete. | A third party cannot reconstruct runner, stats, datasets, submission code, environment, commands, and artifact hashes for a monthly snapshot. | Require a frozen manifest per snapshot, including commits and hashes for all repositories and inputs. | Monthly snapshot schema `phase-8-0-t`, monthly workflow design `phase-8-1-r`, future reproducibility manifest audit. | Snapshot release fails unless manifest has repo SHAs, dataset/cache hashes, submission artifact identity, commands, environment, and validation log. |
| PRR-008 | Reputational | P1 | Dataset licensing or availability blocks public redistribution or recurring runs. | A public dataset cell depends on private, unavailable, rate-limited, license-unclear, or manually acquired data. | Publish availability state and license caveat per dataset; separate benchmark code release from restricted data release. | Dataset monthly availability `phase-8-0-r`, equipment registry `phase-8-0-q`, future licensing audit. | Every dataset row has license/availability state, access instructions, mirroring permission, and fallback behavior for unavailable data. |
| PRR-009 | Technical | P1 | External estimator submissions create execution, dependency, or safety risk. | Public workflow accepts arbitrary contributor code without deterministic execution, dependency isolation, resource limits, or artifact pinning. | Start with template-only intake and smoke fixtures; require sandbox and dependency policy before running untrusted code in benchmark infrastructure. | Submission template `phase-8-0-s`, submission smoke `phase-8-0-f`, future submission sandbox security audit. | Public submission gate requires immutable code identity, dependency lock, entry point, timeout/resource limits, and review state before execution. |
| PRR-010 | Technical | P1 | Parallel branch integration loses evidence or creates conflicts across repos. | Wave 1/Wave 2 branches are merged out of order, rebased without replay, or integrated without preserving GLASSBOX evidence. | Use integration map and merge queue discipline; re-run `git diff --check` and focused tests after merge order is chosen. | Integration conflict map `phase-8-1-o`, disjoint wave planner `phase-8-0-v`, no-idle capacity policy `phase-8-0-x`. | Merge queue records dependency order, branch SHAs, conflict decisions, validation replay, and no protected-file edits. |
| PRR-011 | Community Adoption | P2 | Contributor onboarding is unclear, causing low-quality or incomparable submissions. | A contributor cannot identify required adapter methods, metadata, split restrictions, source code identity, or result caveats from public docs. | Publish a single contributor intake template and a monthly workflow state machine. | Submission template `phase-8-0-s`, monthly workflow design `phase-8-1-r`, API gap audit `phase-8-1-p`. | A new contributor can complete a dry-run submission checklist without editing internal BSEBench code or inventing metadata fields. |
| PRR-012 | Reputational | P2 | Failed, timeout, unsupported, or invalid runs are hidden in public summaries. | A report ranks or compares methods while omitting failure states that affect interpretation. | Require every snapshot to expose missing, skipped, failed, timeout, unsupported, and non-finite outcomes. | Monthly snapshot schema `phase-8-0-t`, public release checklist `phase-8-0-w`, stats invalid-output policy. | Public tables include status counts and caveats; invalid/missing runs cannot be silently dropped from denominators. |

## Release Gates

The public release candidate should be blocked until all gates below pass:

| Gate | Required Evidence | Blocking Condition |
|---|---|---|
| G0 Wave validation | Four Wave 2 validator reports for runner, stats, datasets, and async Wave 1 branches. | Any Wave 1 branch has no commit/still-running decision, no changed-file list, or no validation result. |
| G1 Source ledger | Ledger or audit proving every external comparison sentence is backed by exact source metadata. | Any public prose contains unsupported comparison wording. |
| G2 Methodology integrity | Split metadata, leakage guard, ground-truth audit, dataset card, and metric schema are committed and replayable. | Any published result lacks split, ground-truth, metric, or caveat fields. |
| G3 Reproducibility | Snapshot manifest with repository SHAs, artifact hashes, commands, environment, and validation logs. | A third party cannot replay or inspect the frozen result path. |
| G4 Submission safety | Contributor code identity, dependency, execution, and resource policy are written and enforced. | Public workflow invites arbitrary code execution without a sandbox policy. |
| G5 Public report hygiene | Monthly snapshot/report template includes missing-run status, caveats, and no unsupported claims. | Report hides invalid runs or uses comparative wording outside the ledger. |
| G6 Merge hygiene | Integration map and merge queue capture branch order, conflicts, SHAs, replayed validations, and GLASSBOX metadata. | A release branch is assembled without replaying post-merge validation. |

## Owner Actions

1. Validators: finish Wave 1 validator reports from read-only worktrees or
   fetched branches, waiting on active workers instead of failing them early.
2. Release owner: merge only artifacts that have GLASSBOX metadata, scoped
   diffs, and recorded validation.
3. Methodology owner: reject any result without split, ground-truth, metric,
   and caveat fields.
4. Source-ledger owner: remove or neutralize all comparison wording until the
   ledger is complete.
5. Operations owner: preserve active branch logs and commit SHAs in the release
   evidence bundle.
6. Community owner: publish contributor and monthly workflow docs only after
   they reference the same adapter, snapshot, and validation artifacts.

## Residual Risks

- This audit sampled active logs and sibling worktrees at one time. Branch
  status can change after 2026-05-07T21:37:41+02:00.
- Wave 1 technical branches were still active during sampling; this document
  records release risk, not implementation quality.
- Related Wave 2 audit branches were also in progress; final release gates
  must consume their committed reports, not this draft observation alone.
- The report is intentionally conservative: it blocks public claims until
  committed evidence and source ledgers exist.

## Validation

| Check | Status | Evidence |
|---|---|---|
| Technical/methodological/reputational risks identified | Pass | Risk table includes all three categories with severity and release trigger. |
| Mitigation and owner artifact present | Pass | Each risk row has mitigation, owner artifact, and acceptance gate. |
| Unsupported claims avoided | Pass | Comparison and claim terms appear only as prohibited wording or release gates requiring source ledgers. |
| Scoped write-set | Pass | `git status --short --branch` showed only untracked `audits/` before staging. |
| `git diff --check` | Pass | Command completed with no output. |
