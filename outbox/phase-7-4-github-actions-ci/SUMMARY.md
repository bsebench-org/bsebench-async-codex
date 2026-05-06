# Phase phase-7-4-github-actions-ci summary (CTO validation block)

- Worker : france-personal-2
- Original status : running
- CTO final status : error
- Exit code : 1
- Reconciled at : 2026-05-06T22:36:00Z
- Branch SHA : b5571d70d6485da2dc1a36f2f3ad75e70fd4964b

## Evidence

- The worker pushed `origin/phase-7-4-github-actions-ci`, but the async final
  status push lost a race and left `STATUS.json` at `running`.
- Independent validation blocked the branch: the workflow replaced
  `uv sync --all-extras` with `uv sync --extra dev`.
- `pytest -m "not slow"` still collects tests before marker filtering, and
  tests/imports require `scipy` and `h5py` from the `adapters-mat` extra.

## Decision

Mark original phase as `error` and requeue as
`phase-7-4-github-actions-ci-fix-1` with acceptance requiring dependencies that
cover non-slow test collection.
