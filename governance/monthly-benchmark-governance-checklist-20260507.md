# Monthly Benchmark Governance Checklist

Saved: 2026-05-07. Scope: public monthly BSEBench benchmark reports.

This checklist governs release readiness for a public monthly benchmark report.
It is a process gate only. It does not approve any scientific claim, change any
claim status, or authorize thesis, manuscript, roadmap, runner, stats, or
dataset edits.

## Source Inspection

Read-only inputs inspected for this checklist:

- `docs/BSEBENCH-UNIVERSAL-BENCHMARK-CHARTER-2026-05-07.md`
  - Monthly snapshots must be multi-axis, caveated, and auditable.
  - Reports must state missing data and invalid comparability cases.
- `docs/RESEARCH-GATE-PROTOCOL-2026-05-07.md`
  - Evidence generation, external comparison, and claim registration are
    separate lanes.
  - Unknown source identity cannot support a scientific claim.
  - Missing comparison fields must be marked as gaps, not inferred.
- `scripts/check-research-brief-gates.sh`
  - Existing guardrails check falsification, validation/replay wording,
    protected-file boundaries, and unsupported claim-promotion wording.
- `outbox/phase-7-10-j-async-claim-language-linter/SUMMARY.md`
  - Prior work added a claim-language guard for async briefs and reports.
- `outbox/phase-7-10-n-async-brief-reserve-integrity-gate/SUMMARY.md`
  - Prior work hardened queue/reserve integrity for guarded research briefs.
- `docs/SOLO_OPERATION_BRIEF_2026-05-06.md`
  - Citations, dataset URLs, and licenses must come from checked sources or
    registry metadata with hashes and license fields.
- `outbox/phase-7-2-zenodo-citation-metadata/PANEL_CHECK.md`
  and `outbox/phase-7-2-zenodo-citation-metadata/ADVISOR_CHECK.md`
  - Release metadata and license authority require explicit source-of-truth
    confirmation before public reuse.

Evidence gaps observed in this branch state:

- No merged monthly report release packet was available.
- No merged automated license red-team artifact was found in this report repo.
- Current W5/W7/W8 integration status was not assumed from this branch.

Fail-closed rule: any missing monthly evidence listed above is `BLOCKED`, not
waived or inferred.

## Required Release Packet

Each monthly report must include or cite a committed release packet with these
fields:

| Field | Required content | Block condition |
|---|---|---|
| `release_id` | Stable monthly identifier, for example `2026-05` | Missing or reused id |
| `report_path` | Exact report artifact path | Report not committed |
| `report_commit` | Commit SHA containing the report | Unknown SHA |
| `runner_commit` | Runner repo commit used for execution | Unknown SHA |
| `stats_commit` | Stats repo commit used for metrics | Unknown SHA |
| `datasets_commit` | Dataset registry/adapter commit used for inputs | Unknown SHA |
| `config_manifest` | Config/profile/split manifest path and hash | Missing hash |
| `method_manifest` | Methods/adapters included and excluded | Missing exclusions |
| `data_manifest` | Dataset ids, profiles, cache ids, hashes when practical | Unknown source identity |
| `license_manifest` | Dataset, code, metadata, and report license basis | Missing or ambiguous license |
| `replay_command` | Exact command or script for independent replay | Missing command |
| `replay_result` | Pass/fail result with values checked and mismatch count | Exit code only |
| `comparison_ledger` | External comparison rows, if any | Missing required fields |
| `claim_gate_result` | Claim-language and lane-separation review result | Not run or failed |
| `license_gate_result` | License review and red-team result | Not run or failed |
| `publication_decision` | Publish, publish with caveats, or block | Missing owner |

## Frozen Inputs Gate

Before review starts, the release manager must freeze:

- report template version;
- runner, stats, datasets, and async/report repo SHAs;
- all config files, protocol ids, split ids, and profile ids;
- method adapter list and exact adapter versions;
- dataset registry rows and local cache identities;
- raw-to-harmonized manifest hashes where practical;
- environment facts that affect replay, including package manager command and
  lockfile policy;
- explicit exclusions, skipped datasets, invalid runs, and missing evidence.

Checklist:

- [ ] Freeze record exists and has a stable id.
- [ ] Every repo SHA is present.
- [ ] Every dataset/profile/split id is present.
- [ ] Every included method has a committed adapter identity.
- [ ] Every excluded method or dataset has a reason.
- [ ] Unknown hashes are marked `unknown` with a blocker or caveat.
- [ ] No reviewer is asked to approve a report generated from moving inputs.

Block if any frozen input can change without changing the release packet id.

## Review Roles

Minimum roles before publication:

| Role | Responsibility | Independence rule |
|---|---|---|
| Release manager | Owns freeze, packet completeness, and final decision record | May not self-approve all gates |
| Evidence reviewer | Checks replay, manifests, and mismatch reporting | Must inspect committed artifacts |
| Claims reviewer | Checks lane separation and claim-promotion language | Must block unsupported claims |
| License reviewer | Checks source licenses, report license, and redistribution basis | Must mark unknown licenses blocked |
| Adversarial reviewer | Provides at least one concrete objection or failure-mode check | Must cite an artifact, field, or missing evidence |
| Publication owner | Makes publish/block decision from gate outputs | Must record caveats and blockers |

Optional but recommended:

- dataset/provenance reviewer for new or recently changed data inputs;
- stats reviewer for metric schema or aggregation changes;
- reproducibility reviewer for first-time monthly report automation.

Block if the adversarial review has no concrete objection, no checked failure
mode, and no cited evidence gap.

## Claims Gate

Monthly reports may present frozen benchmark observations and caveated
comparisons. They must not promote scientific claims unless a separate
claim-registration task explicitly authorizes that work.

Checklist:

- [ ] Report states its active lane: monthly benchmark reporting over frozen
      evidence.
- [ ] Report does not edit thesis, manuscript, roadmap, or claim registry files.
- [ ] Report does not present a claim-status change.
- [ ] Every comparison against external work has a source ledger row.
- [ ] Every source ledger row includes stable URL or DOI, retrieval date,
      metric, dataset, split/protocol, BSEBench frozen value, and caveat.
- [ ] Missing source fields are marked `partial` or `not_comparable`.
- [ ] Report wording distinguishes observed metric values from claim approval.
- [ ] Claim-language guard output is attached or cited.

Block if a report asks the reader to treat monthly results as a claim verdict,
or if a comparison depends on unknown source, split, metric, or preprocessing
metadata.

## License Gate

Public reports must have a redistribution basis for all included material.

Checklist:

- [ ] Report code license is stated.
- [ ] Report text/metadata license is stated.
- [ ] Each dataset row has upstream license or terms recorded.
- [ ] Each figure/table derived from data cites the dataset source id.
- [ ] Cached or transformed data is not published unless allowed by source
      terms.
- [ ] Third-party method names, repository links, and citations are sourced.
- [ ] Screenshots, copied tables, or external images are absent or explicitly
      licensed for the report.
- [ ] License reviewer records `PASS`, `PASS_WITH_CAVEATS`, or `BLOCKED`.
- [ ] License red-team records at least one checked risk or states that no
      redistribution risk was found after checking named artifacts.

Fail-closed conditions:

- unknown dataset license;
- unknown redistribution terms for raw or cached data;
- copied external table/figure without an explicit license basis;
- missing license reviewer signoff;
- missing license red-team artifact.

## Reproducibility Packet

The release packet must let a reviewer replay or audit the monthly result
without guessing.

Required contents:

- exact command line used to generate the report;
- exact independent replay command;
- committed input manifests and hashes where practical;
- output report path and hash;
- metric schema and units;
- aggregation policy and caveat policy;
- invalid-run handling policy;
- replay output containing artifact read, values compared, tolerances, mismatch
  count, and pass/fail status;
- environment facts, including OS, Python/package command, and lockfile status;
- explicit gap list for unavailable metadata.

Checklist:

- [ ] Replay consumes frozen artifacts or frozen cache state.
- [ ] Replay does not silently regenerate different evidence.
- [ ] Replay output names what was checked.
- [ ] Mismatch count is present, even when zero.
- [ ] Tolerances are present for numeric checks.
- [ ] Unknown metadata is recorded as a gap.
- [ ] A second reviewer can locate all cited artifacts from the packet alone.

Block if reproducibility evidence is only "command exited zero" or if a report
cannot identify the exact frozen inputs it summarized.

## Publication Decision

Allowed decisions:

- `PUBLISH`: all gates pass, no blocking gaps, caveats are included.
- `PUBLISH_WITH_CAVEATS`: no blocking gaps, but known limitations must be shown
  in the public report.
- `BLOCK`: any required gate is failed, missing, or unknown.

Decision checklist:

- [ ] Frozen inputs gate complete.
- [ ] Review roles complete.
- [ ] Claims gate complete.
- [ ] License gate complete.
- [ ] Reproducibility packet complete.
- [ ] Adversarial review complete.
- [ ] Public caveats match the release packet gap list.
- [ ] No protected files were edited by the monthly report task.
- [ ] Final decision owner and timestamp are recorded.

Default decision is `BLOCK` until every required gate is explicitly resolved.

## Monthly Signoff Template

```text
release_id:
report_path:
report_commit:
frozen_inputs_gate: PASS | PASS_WITH_CAVEATS | BLOCKED
claims_gate: PASS | BLOCKED
license_gate: PASS | PASS_WITH_CAVEATS | BLOCKED
reproducibility_gate: PASS | BLOCKED
adversarial_review: PASS | BLOCKED
publication_decision: PUBLISH | PUBLISH_WITH_CAVEATS | BLOCK
decision_owner:
decision_timestamp:
caveats:
blockers:
```

## Current Branch Status

For this checklist branch only:

- Artifact created: `governance/monthly-benchmark-governance-checklist-20260507.md`.
- Monthly report packet: unknown.
- License red-team artifact: unknown in this branch state.
- Integration branch merge status: unknown.
- Publication readiness: `BLOCK` until a concrete monthly release packet passes
  the gates above.
