# CTO block for phase-6-11-b-chi2-multi-cfg-sweep-fix-1

- Decision: blocked, requeue fix-2
- Decided at: 2026-05-07T00:51:53Z
- Actor: codex-FR [role: cto-codex-FR]
- Branch reviewed: `origin/phase-6-11-b-chi2-multi-cfg-sweep-fix-1`
- Branch SHA: `b776508a47a53ae0af14ce3b0e6facef7d56ab0e`

## What passed

- Worker gates passed: focused tests, full non-slow tests, ruff format, ruff
  check.
- CTO clean worktree gates passed with `uv run --all-extras`: focused tests,
  full non-slow tests, ruff format, ruff check.
- Commit metadata had `[role: worker-codex-FR]` and no
  `Co-Authored-By: Claude` trailer.

## Why block

The branch versions `outputs/chi2_sweep_5x5.json` with:

```json
{"ok": 0, "skipped": 25, "error": 0}
```

All 25 cells were skipped because Hugging Face data access returned
401/repository-not-found responses. This is acceptable as a runtime diagnostic,
but not as versioned scientific evidence for a chi2/RMSE sweep.

Independent validator Chandrasekhar returned BLOCK for this reason.

## Recovery

Queue `phase-6-11-b-chi2-multi-cfg-sweep-fix-2` from the fix-1 branch. The next
branch must either:

- produce a versioned sweep JSON with real `ok` cells from authenticated or
  locally available Tier 2 data; or
- remove the all-skipped JSON from version control and make the branch explicitly
  a reusable sweep tool, not a scientific result.
