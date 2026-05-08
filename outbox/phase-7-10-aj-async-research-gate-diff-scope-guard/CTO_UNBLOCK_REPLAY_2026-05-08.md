# CTO unblock: phase-7-10-aj research diff-scope guard

- Phase : `phase-7-10-aj-async-research-gate-diff-scope-guard`
- Unblocked at : 2026-05-08T13:20:00Z
- Decision : replay the useful guard commit on current `origin/main`, then
  clear the stale non-fast-forward block.

## Root Cause

The worker branch was valid when pushed, but `origin/main` moved while chef was
processing prior orchestration fixes. Chef correctly refused a non-fast-forward
merge and advisor correctly blocked the stale branch. That block should not
remain after the guard commit is replayed on top of current `main`.

## Replay Evidence

- Replayed worker commit `f55ab55` as `2dd636a` on current `origin/main`.
- `bash -n scripts/check-research-diff-scope.sh scripts/probe-research-diff-scope-guard.sh scripts/chef-daemon.sh scripts/worker-daemon.sh scripts/remote-worker.sh`
- `bash scripts/probe-research-diff-scope-guard.sh` : 8 fixture checks passed.
- `bash scripts/check-research-diff-scope.sh --dry-run --base origin/main --head HEAD` : allowed=3, blocked=0, review_required=0.
- `bash scripts/check-research-brief-gates.sh --dry-run cto/AUTONOMY_BACKLOG/phase-7-*/BRIEF.md` : 28 checked, 0 skipped.
- `git diff --check origin/main...HEAD && git diff --check`

## Guardrail

This unblock does not weaken product-code review. It lands the research
diff-scope guard that blocks protected thesis, roadmap, claim registry,
`claim_55`, and unsupported comparison/SOTA wording unless source-ledger
evidence is present.

No thesis, claim registry, roadmap, scientific verdict, or leaderboard claim was
modified.
