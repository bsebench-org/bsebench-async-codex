# Phase 17 Opening Audit - Profile-Axis Claim 60 Evidence Bundle

Generated: 2026-05-09 21:41 CEST

## Opening Verdict

Phase 17 is open.

Allowed status:

```text
GO_EVIDENCE_BUNDLE
GO_REPLAY_CONTRACT
GO_SOURCE_LEDGER
GO_ADVERSARIAL_GATE
NO_GO_CLAIM
```

Forbidden status:

```text
GO_PUBLIC_CLAIM
GO_SOTA
GO_LEADERBOARD
GO_PROFILE_INVARIANCE_CLAIM
```

## Scope

Phase 17 focuses on one claim family only:

```text
Profile-axis stress / claim_60
```

The purpose is not to prove a broad profile-invariance or benchmark-superiority
claim. The purpose is to assemble the first current-head evidence bundle that
can be challenged by the Phase 16 claim-readiness gates.

## Starting Point

Phase 16 closed with `claim_60` classified as:

```text
MECHANICAL_ONLY
```

Reason:

- Phase 9 produced bounded profile-axis smoke tooling and evidence;
- no complete current-head evidence bundle exists yet;
- no broad scientific wording is authorized.

Relevant heads at Phase 17 opening:

| Repo | Head |
| --- | --- |
| `bsebench-async-codex` | `04312ab` |
| `bsebench-specs` | `eaae7b5` |
| `bsebench-datasets` | `9a6e24b` |
| `bsebench-runner` | `3a2b2bf` |
| `bsebench-stats` | `98cbbf4` |
| `bsebench-website` | `c2ffdbb` |
| `bsebench-filters` | `cc75d9c` |

## Research Question

Can BSEBench produce a current-head, replayable, source-ledger-backed,
adversarially gated evidence bundle for the narrow profile-axis mechanical
stress workflow behind `claim_60`?

## Required Phase 17 Evidence

The minimum acceptable Phase 17 bundle must name and validate:

1. source ledger and dataset provenance;
2. license/access status;
3. local cache or fetch path;
4. split integrity;
5. frozen protocol/parameter record;
6. profile-axis plan or readiness artifact;
7. replay manifest and exact replay command;
8. stats/readiness artifact;
9. artifact hashes;
10. adversarial claim wording gate.

Any missing item keeps the family out of `CLAIM_READY`.

## Work Packages

| Task | Repo | Output | Initial owner |
| --- | --- | --- | --- |
| P17-01 | `bsebench-datasets` | profile-axis source/provenance bundle gate | worker |
| P17-02 | `bsebench-runner` | profile-axis replay evidence-bundle validator | worker |
| P17-03 | `bsebench-stats` | claim_60 adversarial readiness classifier | worker |
| P17-04 | `bsebench-async-codex` | task graph and final closure report | local |

## Scientific Guardrails

Phase 17 may say:

- a mechanical profile-axis evidence bundle is complete or incomplete;
- a source/provenance/cache/replay field is present or missing;
- a near-claim is blocked, mechanical-only, or evidence-gap;
- a future claim needs more evidence.

Phase 17 may not say:

- BSEBench proves profile invariance;
- a method is robust across profiles;
- any method is SOTA or leaderboard-ready;
- any broad battery degradation conclusion is established;
- claim_60 is verified unless the strict gates return `CLAIM_READY`.

## Closure Criteria

Phase 17 may close only if:

- each touched repo has focused tests passing;
- `ruff` passes for touched Python files;
- `git diff --check` passes;
- all repos are clean or every intentional local change is committed and pushed;
- the final report records whether `claim_60` remains `MECHANICAL_ONLY`,
  moves to `EVIDENCE_GAP` or `AUTH_OR_DATA_BLOCKED`, or becomes
  `CLAIM_READY`;
- no unsupported public scientific claim is introduced.

Expected conservative closure:

```text
claim_60 = MECHANICAL_ONLY or EVIDENCE_GAP
```

`CLAIM_READY` is allowed only if all evidence requirements are complete and the
adversarial wording gate explicitly authorizes the narrow claim.

