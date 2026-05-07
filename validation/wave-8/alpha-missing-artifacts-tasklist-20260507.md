# Wave 8 validation: alpha missing artifacts tasklist brief

Worker: W8-f
Branch: `phase-8-7-f-alpha-missing-artifacts-tasklist-20260507T214728Z`
Owned write-set:

- `cto/AUTONOMY_BACKLOG/phase-8-alpha-missing-artifacts-20260507/BRIEF.md`
- `validation/wave-8/alpha-missing-artifacts-tasklist-20260507.md`

## Scope

This validation creates one concrete next queued task brief for missing alpha release artifacts. It does not edit thesis files, manuscript files, claim registry files, `claims/registry.yaml`, `claim_55`, the scientific roadmap, runner, stats, or datasets repos.

## Evidence inspected

Current report-repo branch inventory showed W5/W6/W7 evidence branches on `origin`. The key evidence used for the queued brief was:

| Evidence | Current observed ref | Finding used |
| --- | --- | --- |
| W5-11 RC manifest | `origin/phase-8-4-k-release-candidate-manifest-20260507T213125Z` at `60649e9` | Manifest state is draft, publication blocked, and no assembled pushed alpha RC exists. |
| W5-13 package index | `origin/phase-8-4-m-community-submission-package-index-20260507T213125Z` at `bb1bad5` | Available package assets are indexed, but concrete submission, lifecycle, sandbox, determinism, leakage, evidence, metric, source-ledger, snapshot, and hash-bundle artifacts remain missing. |
| W5-07 datasets validator | `origin/phase-8-4-g-datasets-integration-validator-20260507T213125Z` at `082f4a2` | Original report is stale/blocking: it records `PENDING_REMOTE_PUSH`. Current datasets remote now has a pushed integration head, so a successor pushed-head replay is required rather than reusing W5-07 as a pass. |
| W5-08 async validator | `origin/phase-8-4-h-async-integration-validator-20260507T213125Z` at `cb4d01e` | Original report is blocking: async docs integration exists but failed the research brief gate at sample time. Successor gate replay must be cited before release use. |
| W6-06 alpha red-team | `origin/phase-8-5-f-alpha-release-redteam-20260507T213656Z` at `7d95ca8` | Publication decision is blocked; missing assembled RC, frozen snapshot/report/source-ledger/freeze artifacts, and post-merge validation. |
| W7-g blocker dashboard | `origin/phase-8-6-g-alpha-release-blocker-dashboard-20260507T214305Z` at `d487120` | Aggregates P0 blockers across integration, claim/public report, dataset, reproducibility, metrics/reporting, and compute lanes. |
| Runner integration head | `/mnt/c/doctorat/bsebench-org/bsebench-runner`, `origin/phase-8-4-a...` at `e0664de` | Pushed integration head exists; this worker did not rerun runner gates. |
| Stats integration head | `/mnt/c/doctorat/bsebench-org/bsebench-stats`, `origin/phase-8-4-b...` at `08d7c2c` | Pushed integration head exists; this worker did not rerun stats gates. |
| Datasets integration head | `/mnt/c/doctorat/bsebench-org/bsebench-datasets`, `origin/phase-8-4-c...` at `6cbdc54` | Pushed integration head now exists, superseding W5-07's missing-remote observation but not providing successor validation by itself. |

## Derived task shape

The queued BRIEF asks the next worker to create a report-only `release/alpha/missing-artifacts-tasklist-20260507.md` artifact. It requires exact ref pinning, stale-evidence reconciliation, a P0/P1 close-out table, disjoint write-set discipline, and validation commands. It is scoped to missing release-hardening artifacts only, not scientific-roadmap or claim promotion work.

## Current blockers carried forward

- No assembled, pushed, post-merge validated alpha RC spanning runner, stats, datasets, and async/report refs was verified by this worker.
- No frozen monthly snapshot JSON, public report Markdown, source-ledger bundle, claim-binding matrix, or freeze manifest was verified by this worker.
- W5-07 and W5-08 remain stale/blocking evidence unless a successor validator cites current pushed refs and passing gates.
- Dataset license/access/cache/loader/split/provenance closure remains incomplete for public runnable rows.
- Community submission execution artifacts remain missing unless a future worker points to concrete package evidence.
- Public claims/no-claims gating is partly spec/template evidence; exact public text still needs executable or manually signed preflight.

## Unknowns

- Whether W7 prototype branches after the blocker dashboard have already closed some P0 rows. The queued task is required to re-fetch and classify current refs rather than assume.
- Whether current runner/stats/datasets integration heads pass full clean post-merge gates. This worker only inspected refs read-only.
- Whether any candidate public report text exists outside the refs inspected here. The queued task must mark absent evidence explicitly.

## Validation for this W8-f artifact

Required:

```bash
git diff --check
```

Additional read-only checks run during drafting:

```bash
git status --short --branch
git branch -a --list '*phase-8*'
git for-each-ref --format='%(refname:short) %(objectname:short) %(subject)' refs/heads refs/remotes/origin
git show origin/phase-8-4-k-release-candidate-manifest-20260507T213125Z:release/alpha/universal-rc-manifest-20260507T213125Z.md
git show origin/phase-8-4-m-community-submission-package-index-20260507T213125Z:release/alpha/community-submission-package-index-20260507T213125Z.md
git show origin/phase-8-4-g-datasets-integration-validator-20260507T213125Z:validation/wave-5/datasets-integration-validator-20260507T213125Z.md
git show origin/phase-8-4-h-async-integration-validator-20260507T213125Z:validation/wave-5/async-integration-validator-20260507T213125Z.md
git show origin/phase-8-5-f-alpha-release-redteam-20260507T213656Z:redteam/release/alpha-release-redteam-20260507T213656Z.md
git show origin/phase-8-6-g-alpha-release-blocker-dashboard-20260507T214305Z:dashboards/alpha-release/blocker-dashboard-20260507.md
git -C /mnt/c/doctorat/bsebench-org/bsebench-runner for-each-ref --format='%(refname:short) %(objectname:short) %(subject)' refs/remotes/origin
git -C /mnt/c/doctorat/bsebench-org/bsebench-stats for-each-ref --format='%(refname:short) %(objectname:short) %(subject)' refs/remotes/origin
git -C /mnt/c/doctorat/bsebench-org/bsebench-datasets for-each-ref --format='%(refname:short) %(objectname:short) %(subject)' refs/remotes/origin
```

This validation makes no alpha readiness, public-release, benchmark-result, SOTA, novelty, leaderboard, breakthrough, superiority, or verified scientific claim.
