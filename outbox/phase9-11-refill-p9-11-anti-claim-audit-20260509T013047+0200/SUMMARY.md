# P9/P10/P11 anti-claim audit

- Worker: Codex
- Generated: 2026-05-09T01:30:47+02:00
- Branch: phase9-11-refill-p9-11-anti-claim-audit-20260509T013047+0200
- Scope: async repository only

## Decision

NO-GO for claim support. This artifact does not mark any P9, P10, or P11 work
as done.

## Audit Inputs

- `docs/POST_PHASE_11_GENERAL_AUDIT_PLAN_2026-05-08.md`
- `docs/PHASE-9-10-11-DAG-2026-05-08.md`
- `.codex-direct-prompts/P9_*`
- `.codex-direct-prompts/P10_*`
- `.codex-direct-prompts/P11_*`
- Existing `cto/AUTONOMY_BACKLOG`, `inbox`, and `outbox` text searched with
  local `rg` patterns for completion, verdict, public-result, and comparison
  wording.

## Findings

| Lane | Positive claim state | Evidence state | Required unblock |
| --- | --- | --- | --- |
| P9 profile axis | No supported positive result statement found | Verdict and empirical nodes are still waiting in the DAG | local cache, provenance, Tier2 readiness, runnable empirical profile artifact, source-ledger IDs, stats comparability |
| P10 aging/SOH | No supported positive result statement found | Empirical and verdict nodes are still waiting in the DAG | aging/SOH metadata, split integrity, ground-truth evidence, provenance/cache readiness, source-ledger IDs |
| P11 residual decomposition | No supported positive result statement found | Empirical trace and verdict nodes are still waiting in the DAG | unit/cadence evidence, residual component evidence, empirical trace artifacts, provenance/cache readiness, source-ledger IDs |

Existing text mostly contains guardrail prohibitions, task prompts, historical
logs, or synthetic fixture examples. Those are not evidence of a public result.
Any future positive result wording must remain blocked unless the evidence
markers above are present and validated.

## Guardrail Change

`scripts/check-research-diff-scope.sh` now review-requires added P9/P10/P11
completion or benchmark-performance wording unless the same diff includes all
required evidence markers: cache, provenance, Tier2, source-ledger,
empirical-run, and validation. The same guard also now expands comparison-label
coverage for ordinal and field-leading wording.

## Blockers

- No local empirical-run artifact was identified in this async-only audit.
- No completed source-ledger evidence was identified for P9/P10/P11 result
  wording.
- No Tier2/cache/provenance evidence bundle was identified here.
- Product-repo validation remains outside this branch and must be checked before
  any scientific or public-result statement is allowed.
