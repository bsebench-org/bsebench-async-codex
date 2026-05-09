# Phase 9/10/11 Merge Matrix - 2026-05-09

Generated at: `2026-05-09T00:10:47+00:00`

Scope: Phase 9/10/11 closure branches only. This is a read-only matrix; no merge is performed here.

Scientific status: NO-GO for Phase 9/10/11 closure until cache/provenance/Tier2/source-ledger/empirical-run evidence exists and replays cleanly.

## Summary

- Latest non-empty candidate rows: `18`
- Superseded non-empty retry refs collapsed out of the table: `123`
- Empty retry refs equal to `origin/main` collapsed out of the table: `0`
- The current in-progress matrix branch is not counted until it is committed and pushed; rerun this script after push for an updated coordination row.
- Final verdict or public-claim language is blocked unless the relevant empirical and source-ledger evidence is present.
- Local repo blockers:
  - `bsebench-specs`: local base worktree has uncommitted changes
  - `bsebench-filters`: local base worktree has uncommitted changes
  - `bsebench-async-codex`: local base worktree has uncommitted changes
  - `bsebench-website`: local base worktree has uncommitted changes

## Merge Matrix

| Order | Repo | Stage | Phase | Task | Branch | SHA | State | Required evidence gate |
| ---: | --- | --- | --- | --- | --- | --- | --- | --- |
| 10 | bsebench-async-codex | guardrails | 9/10/11 | unsupported-claim audit | `origin/phase9-11-refill-p9-11-anti-claim-audit-20260509T014540+0200` | `c240e6645594` | metadata-ok; blocked: dirty local validation worktree | blocks unsupported closure/performance wording |
| 11 | bsebench-async-codex | guardrails | 9/10/11 | acceptance gate | `origin/phase9-11-refill-p9-11-acceptance-gate-20260509T014810+0200` | `f5c69657f218` | metadata-ok; blocked: dirty local validation worktree | separates tooling readiness from scientific closure |
| 20 | bsebench-specs | shared contracts | 9/10/11 | schema/export audit | `origin/phase9-11-refill-p9-11-schema-export-audit-20260509T015402+0200` | `0a5402cd1360` | metadata-ok; blocked: dirty local validation worktree | schema compatibility must validate before downstream branches |
| 21 | bsebench-filters | shared contracts | 9/10/11 | filter contract/export audit | `origin/phase9-11-refill-p9-11-contract-export-audit-20260509T015413+0200` | `31501139f72e` | metadata-ok; blocked: dirty local validation worktree | filter contract compatibility must validate before runner branches |
| 30 | bsebench-datasets | dataset readiness | 9 | profile-axis Tier2/cache audit | `origin/phase9-11-refill-p9-tier2-profile-cache-20260509T014855+0200` | `841b3a5b5791` | metadata-ok; blocked: same-repo file overlap; overlap: p9-11-local-path-discovery: 2 shared files | Phase 9 remains blocked by missing local Tier2/cache/provenance evidence |
| 31 | bsebench-datasets | dataset readiness | 10 | aging/SOH Tier2/cache audit | `origin/phase9-11-refill-p10-tier2-aging-cache-20260509T013206+0200` | `d83782d3903d` | metadata-ok; blocked: same-repo file overlap; overlap: p9-11-local-path-discovery: 2 shared files | Phase 10 remains blocked by missing aging/SOH Tier2/cache/provenance evidence |
| 32 | bsebench-datasets | dataset readiness | 11 | residual Tier2/cache/unit audit | `origin/phase9-11-refill-p11-tier2-residual-cache-20260509T014930+0200` | `e639d965d2b2` | metadata-ok; clean validation pending | Phase 11 remains blocked by missing residual unit/cadence/cache evidence |
| 33 | bsebench-datasets | dataset readiness | 9/10/11 | local Tier2 path discovery | `origin/phase9-11-refill-p9-11-local-path-discovery-20260509T014600+0200` | `21ecae1f314b` | metadata-ok; blocked: same-repo file overlap; overlap: p9-tier2-profile-cache: 2 shared files, p10-tier2-aging-cache: 2 shared files | read-only path discovery is not empirical evidence |
| 40 | bsebench-runner | runner dry-run | 9 | profile empirical scheduler | `origin/phase9-11-refill-p9-profile-empirical-scheduler-20260509T014942+0200` | `fe6e8412af69` | metadata-ok; blocked: same-repo file overlap; overlap: p10-aging-empirical-scheduler: 1 shared files, p11-residual-trace-scheduler: 1 shared files, p9-11-dryrun-cli-smoke: 1 shared files | scheduler output must not be treated as empirical-run evidence |
| 41 | bsebench-runner | runner dry-run | 10 | aging/SOH empirical scheduler | `origin/phase9-11-refill-p10-aging-empirical-scheduler-20260509T014955+0200` | `29774264aede` | metadata-ok; blocked: same-repo file overlap; overlap: p9-profile-empirical-scheduler: 1 shared files | scheduler output must not be treated as empirical-run evidence |
| 42 | bsebench-runner | runner dry-run | 11 | residual trace scheduler | `origin/phase9-11-refill-p11-residual-trace-scheduler-20260509T015008+0200` | `08d9eae0c8c8` | metadata-ok; blocked: same-repo file overlap; overlap: p9-profile-empirical-scheduler: 1 shared files, p9-11-dryrun-cli-smoke: 1 shared files | scheduler output must not be treated as residual trace evidence |
| 43 | bsebench-runner | runner dry-run | 9/10/11 | dry-run CLI smoke | `origin/phase9-11-refill-p9-11-dryrun-cli-smoke-20260509T014630+0200` | `1333a949abd9` | metadata-ok; blocked: same-repo file overlap; overlap: p9-profile-empirical-scheduler: 1 shared files, p11-residual-trace-scheduler: 1 shared files | smoke fixtures do not establish scientific readiness |
| 50 | bsebench-stats | stats validators | 9 | profile verdict-input validator | `origin/phase9-11-refill-p9-profile-verdict-inputs-20260509T015022+0200` | `b4d715577d3c` | metadata-ok; clean validation pending | requires real profile empirical artifacts plus source-ledger evidence |
| 51 | bsebench-stats | stats validators | 10 | aging/SOH verdict-input validator | `origin/phase9-11-refill-p10-aging-verdict-inputs-20260509T015035+0200` | `9ad4fcce2958` | metadata-ok; clean validation pending | requires real aging/SOH empirical artifacts plus source-ledger evidence |
| 52 | bsebench-stats | stats validators | 11 | residual verdict-input validator | `origin/phase9-11-refill-p11-residual-verdict-inputs-20260509T015247+0200` | `b930974451b2` | metadata-ok; blocked: same-repo file overlap; overlap: p9-11-no-claims-linter: 2 shared files | requires residual trace artifacts plus source-ledger evidence |
| 53 | bsebench-stats | stats validators | 9/10/11 | no-claims linter | `origin/phase9-11-refill-p9-11-no-claims-linter-20260509T014751+0200` | `197f71641a16` | metadata-ok; blocked: same-repo file overlap; overlap: p11-residual-verdict-inputs: 2 shared files | claim language remains blocked without empirical/source-ledger evidence |
| 60 | bsebench-async-codex | async rollup | 9/10/11 | checkpoint report | `origin/phase9-11-refill-p9-11-checkpoint-report-20260509T015525+0200` | `a3558b4f75ee` | metadata-ok; blocked: dirty local validation worktree | rollup must stay NO-GO until evidence gates pass |
| 61 | bsebench-async-codex | async rollup | 9/10/11 | merge matrix | `origin/phase9-11-refill-p9-11-merge-matrix-20260509T014505+0200` | `266ba9008398` | metadata-ok; blocked: dirty local validation worktree | coordination artifact only; it must not merge branches |

## Validation Order

1. Fetch/prune each target repo and verify the candidate branch exists on origin.
2. Reject immediately if the head commit subject does not start with `GLASSBOX`, contains a `Co-Authored-By` Claude trailer, edits protected thesis/roadmap/claim paths, or contains unsupported closure/performance claim language.
3. Validate shared contracts first: async guardrails, specs schema/export audit, then filters contract/export audit.
4. Validate dataset readiness branches next, because runner and stats branches must fail closed on missing Tier2/cache/provenance evidence.
5. Validate runner dry-run schedulers only after dataset evidence gates are available; dry-run output is not empirical evidence.
6. Validate stats verdict-input branches only after empirical artifacts, source-ledger rows, and replay commands exist.
7. Merge only one same-repo branch at a time on a clean worktree, rerunning focused tests, full non-slow tests when available, ruff check, ruff format check, and `git diff --check` after each rebase or merge rehearsal.

## Blockers

- Do not merge from this branch.
- Do not mark Phase 9, Phase 10, or Phase 11 complete from these tooling branches alone.
- Dirty local base worktrees must be resolved or replaced with clean validation worktrees before any branch-level gates are trusted.
- Same-repo file overlaps must be handled by selecting one branch or rebasing in order; do not blindly merge retry branches.
