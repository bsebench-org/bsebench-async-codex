# Phase 16 Task Graph - Adversarial Claim-Readiness

Generated: 2026-05-09 21:27 CEST

## Operating Mode

Phase 16 is a claim-readiness and adversarial validation phase.

It is not a publication, leaderboard, or performance-claim phase.

Global invariant:

```text
NO_GO_CLAIM
```

## Wave 1 Launched

| Task | Repo | Owner scope | Output | Status |
| --- | --- | --- | --- | --- |
| P16-01 | `bsebench-specs` | schemas/helper/tests only | claim-readiness contract | running |
| P16-02 | `bsebench-stats` | stats helper/tests only | adversarial claim gate | running |
| P16-03 | `bsebench-datasets` | datasets helper/tests only | source-ledger completeness gate | running |

Parallelism rule: these tasks are intentionally split across separate repos to
avoid write conflicts and to keep review scope small.

## Acceptance Criteria

Each Wave 1 task must satisfy:

- focused tests pass;
- `git diff --check` passes;
- default state is fail-closed;
- no public claim wording is introduced;
- no thesis or claim registry edit;
- no Hugging Face upload;
- no private dataset fetch;
- no use of stale non-merged remote branches as evidence.

## Phase 16 Verdict Vocabulary

Every claim family must classify into exactly one of:

- `CLAIM_READY`
- `MECHANICAL_ONLY`
- `EVIDENCE_GAP`
- `AUTH_OR_DATA_BLOCKED`
- `RETRACT_OR_SCOPE`

Default: `EVIDENCE_GAP`.

`CLAIM_READY` requires complete evidence:

- source ledger;
- dataset provenance;
- license/access status;
- local cache or fetch path;
- split integrity;
- frozen parameter or protocol record;
- runner artifact;
- stats artifact;
- report artifact;
- artifact hashes;
- exact replay command;
- independent claim wording gate.

## Wave 2 Candidates

Wave 2 should start only after Wave 1 is reviewed:

| Candidate | Repo | Purpose |
| --- | --- | --- |
| P16-04 | `bsebench-runner` | replay-manifest validator |
| P16-05 | `bsebench-async-codex` | claim-family adversarial review matrix |
| P16-06 | `bsebench-website` | conservative Phase 16 status page |

## Closure Target

Phase 16 can close in this cycle if it delivers:

1. claim-readiness schema;
2. source-ledger completeness gate;
3. adversarial claim gate;
4. replay-manifest gate or explicit Wave 2 blocker;
5. final report that classifies all major near-claim families without upgrading
   any claim prematurely.

