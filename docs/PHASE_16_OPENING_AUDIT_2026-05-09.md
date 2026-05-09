# Phase 16 Opening Audit - Adversarial Claim-Readiness Validation

Generated: 2026-05-09 20:55 CEST

## Verdict

Phase 16 may open.

Allowed status:

- `GO_AUDIT`
- `GO_SCHEMA`
- `GO_GATES`
- `NO_GO_CLAIM`

Forbidden status:

- no public benchmark claim;
- no SOTA claim;
- no leaderboard claim;
- no universal SOC/SOH claim;
- no transfer-success claim;
- no adaptive-learning gain claim;
- no PCRLB tightness/theorem claim.

## Why Phase 16 Opens Now

Phases 9 to 15 have produced a strong fail-closed engineering stack:

- profile-axis smoke machinery;
- aging/SOH diagnostic smoke machinery;
- residual diagnostics mechanics;
- transfer-readiness gates;
- ensemble-method preflight infrastructure;
- information-bound tooling;
- adaptive-learning preflight infrastructure.

The remaining bottleneck is not another method implementation. The bottleneck
is claim-readiness discipline: every near-claim must be challenged as if by a
hostile reviewer before any public or thesis-facing scientific statement is
allowed.

## Starting Point

Current production heads:

| Repo | Head |
| --- | ---: |
| `bsebench-async-codex` | `a60ebd1` before this opening audit commit |
| `bsebench-specs` | `6f1070b` |
| `bsebench-filters` | `cc75d9c` |
| `bsebench-stats` | `a51b23d` |
| `bsebench-runner` | `04f6a48` |
| `bsebench-datasets` | `443d836` |
| `bsebench-website` | `0906629` |

Cleanup gate before opening:

- local workspace reduced to the seven canonical repos;
- all current local repos aligned with `origin/main`;
- `66` merged remote branches deleted;
- `0` merged remote branches remain;
- `460` non-merged remote branches remain documented as branch debt, not used
  as current evidence.

Reference cleanup report:

```text
docs/ORG_CLEANUP_PRODUCTION_READINESS_REPORT_2026-05-09.md
```

## Phase 16 Research Question

Which BSEBench claims or near-claims survive an adversarial review process, and
which must stay blocked, scoped, retracted, or converted into purely mechanical
engineering milestones?

## Claim Families To Challenge

| Family | Current status | Challenge question |
| --- | --- | --- |
| Hinf outlier / claim_55 | proposed or historically investigated | Is there current-head replay evidence, or only historical/partial evidence? |
| BMA/PCRLB ceiling / claim_59 | proposed | Is the ceiling replayable across current datasets and configs? |
| Profile-axis stress / claim_60 | internal smoke only | Does evidence support broad profile invariance, or only bounded smoke? |
| Aging/SOH behavior | internal smoke only | Does NASA B0005 diagnostic smoke generalize? |
| Residual decomposition | mechanical evidence only | Can residual fractions be interpreted scientifically? |
| Cross-chemistry transfer | execution blocked | Are SOC truth, split, parameter-freeze, and transfer matrices complete? |
| Ensemble methods | infrastructure only | Is any ensemble ranking backed by audited empirical runs? |
| Information bounds | tooling only | Is any PCRLB/tightness/theorem statement actually proven? |
| Adaptive learning | preflight only | Is any RMSE gain measured under frozen protocol? |

## Required Phase 16 Artifacts

Minimum product artifacts:

1. `bsebench-specs`
   - claim-readiness schema;
   - source-ledger schema if missing;
   - admissible verdict enum.
2. `bsebench-datasets`
   - dataset/source/license/provenance completeness gate;
   - registry consolidation status gate.
3. `bsebench-runner`
   - replay-manifest validator;
   - current-head artifact replay contract.
4. `bsebench-stats`
   - adversarial claim-readiness gate;
   - claim wording blocker;
   - near-claim classification report helper.
5. `bsebench-async-codex`
   - Phase 16 task graph;
   - final adversarial review report;
   - branch cleanup debt ledger if cleanup continues.
6. `bsebench-website`
   - optional conservative Phase 16 status page after gates exist.

## Phase 16 Classification

Every claim family must end in exactly one of:

- `CLAIM_READY`
- `MECHANICAL_ONLY`
- `EVIDENCE_GAP`
- `AUTH_OR_DATA_BLOCKED`
- `RETRACT_OR_SCOPE`

Default is `EVIDENCE_GAP`.

`CLAIM_READY` is forbidden unless all of the following exist:

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

## First Wave Tasks

Recommended first wave:

| Task | Repo | Output | Dependency |
| --- | --- | --- | --- |
| P16-01 | `bsebench-specs` | claim-readiness schema | none |
| P16-02 | `bsebench-stats` | adversarial claim gate | P16-01 preferred, can draft independently |
| P16-03 | `bsebench-datasets` | source-ledger completeness gate | none |
| P16-04 | `bsebench-runner` | replay-manifest validator | P16-01 preferred |
| P16-05 | `bsebench-async-codex` | claim-family review matrix | none |
| P16-06 | `bsebench-website` | conservative status page | after P16-01/P16-02 |

## Merge Rules

Phase 16 branches are mergeable only if:

- focused tests pass;
- `git diff --check` passes;
- no public claim wording is introduced;
- no thesis or claim registry is edited;
- no Hugging Face upload is performed;
- no non-merged historical branch is treated as evidence without replay or
  explicit archival review.

## Stop Conditions

Stop and report instead of coding if:

- a task needs private Hugging Face auth;
- a branch contains unique historical evidence that may need preservation;
- a proposed claim lacks source ledger or replay command;
- a test only passes by relying on stale installed sibling packages;
- a website/doc page starts sounding like a result announcement.

## Opening Decision

Phase 16 is open as adversarial validation and claim-readiness infrastructure.

It is not open as a publication, leaderboard, or claim-confirmation phase.

