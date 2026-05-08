# Phase 9 universal benchmark queue pack

Pack branch: `phase-8-11-b-phase9-queue-pack-20260508T075340+0200`

## Objective

Create an implementation-ready Phase 9 queue pack for BSEBench's universal
SOC/SOH benchmark direction. The pack contains six independent worker briefs
with falsification gates, validation checklists, and disjoint write scopes.

The briefs are implementation work, not claim work. They must not make SOTA,
novelty, leaderboard, breakthrough, or verified-claim statements.

## Inputs Inspected

- `cto/AUTONOMY_BACKLOG/README.md`
- `cto/AUTONOMY_BACKLOG/phase-7-10-n-async-brief-reserve-integrity-gate/BRIEF.md`
- `cto/AUTONOMY_BACKLOG/phase-7-10-p-async-source-ledger-comparability-fixtures/BRIEF.md`
- `docs/BSEBENCH-UNIVERSAL-BENCHMARK-CHARTER-2026-05-07.md`
- `docs/BSEBENCH-UNIVERSAL-PARALLEL-WAVE-2026-05-07.md`
- `docs/RESEARCH-GATE-PROTOCOL-2026-05-07.md`
- `scripts/check-research-brief-gates.sh`
- Current local branch: `phase-8-11-b-phase9-queue-pack-20260508T075340+0200`

## Decisions

- Keep this deliverable entirely under
  `cto/AUTONOMY_BACKLOG/phase-9-universal-benchmark-queue-20260508T075340+0200/`.
- Use six briefs instead of a larger speculative wave, so each item has a clear
  falsification gate and a worker-sized implementation surface.
- Separate runner, datasets, stats, and async/public-benchmark operations so
  workers can run in parallel without editing the same files.
- Phrase all outputs as mechanical benchmark infrastructure and validation
  artifacts, not scientific conclusions.
- Require workers to record actual inspected target files before editing because
  this pack did not inspect external target repositories.

## Queue

| Brief | Active lane | Primary repo | Disjoint write scope |
|---|---|---|---|
| `phase-9-a-runner-estimator-io-contract/BRIEF.md` | Evidence generation | `bsebench-runner` | Estimator I/O contract and contract tests only |
| `phase-9-b-runner-profile-stress-protocol/BRIEF.md` | Evidence generation | `bsebench-runner` | Profile-stress protocol registry and tests only |
| `phase-9-c-datasets-profile-axis-manifest/BRIEF.md` | Evidence generation | `bsebench-datasets` | Profile-axis manifest/schema and tests only |
| `phase-9-d-stats-soc-soh-metric-envelope/BRIEF.md` | Evidence generation | `bsebench-stats` | SOC/SOH metric-envelope schema and tests only |
| `phase-9-e-async-submission-validation-template/BRIEF.md` | Evidence generation | `bsebench-async-codex` | Submission template/checklist under async docs/templates only |
| `phase-9-f-runner-split-leakage-smoke-gate/BRIEF.md` | Evidence generation | `bsebench-runner` | Split/leakage smoke gate and tests only |

## Validation Checklist

- Run `git diff --check`.
- Run `bash scripts/check-research-brief-gates.sh --dry-run` against this pack's
  BRIEF paths and record that the current checker skips nested Phase 9 briefs if
  that is the observed result.
- Run a lightweight section-presence check over this pack's `BRIEF.md` files
  for objective, inputs inspected, decisions, validation checklist, residual
  risks, next concrete task, falsification gate, and protected-file guardrails.
- Confirm changed paths are only under the owned pack directory before commit.
- Confirm `git status --short` is clean after commit.

## Residual Risks

- The existing research brief checker only targets Phase 7, Phase 8, and Phase
  11 top-level BRIEFs. It may skip these nested Phase 9 briefs until the async
  checker is extended.
- Target repository module paths are deliberately described as write scopes, not
  inspected facts. Each worker must inspect the target repo before editing and
  record the actual files changed.
- Several briefs depend on future target-repo layout choices. A worker should
  fail early rather than widening scope if the declared write set cannot fit the
  repository structure.

## Next Concrete Task

Queue one Phase 9 brief at a time, starting with
`phase-9-a-runner-estimator-io-contract/BRIEF.md`, because the plug-and-play
estimator contract reduces ambiguity for later profile, metric, and submission
work.
