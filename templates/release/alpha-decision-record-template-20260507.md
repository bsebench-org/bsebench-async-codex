# Alpha Release Decision Record Template

Use this template for the final alpha release decision record. It is a
process artifact only: it records release readiness, required evidence,
reviewer signoff, caveats, blockers, and rollback criteria. It does not publish
results, approve scientific claims, rank methods, or change protected research
files.

## Decision Header

```text
release_id:
candidate_record_id:
decision_state: GO | GO-with-caveats | BLOCKED
decision_timestamp_utc:
decision_owner:
rollback_owner:
release_branch_or_tag:
async_report_commit:
runner_commit:
stats_commit:
datasets_commit:
snapshot_artifact:
public_report_artifact:
decision_record_commit:
```

## Source Evidence Inspected

Record every input reviewed before deciding. Missing evidence is a blocker
unless the decision is explicitly `GO-with-caveats` and the gap cannot affect
published artifacts, replay, licensing, protected paths, or unsupported claim
language.

| Evidence class | Required artifact or log | Status | Reviewer notes |
| --- | --- | --- | --- |
| W5 RC manifest | `release/alpha/universal-rc-manifest-*.md` | PASS | |
| W6 alpha red-team | `redteam/release/alpha-release-redteam-*.md` | PASS | |
| W9 risk log | risk register, blocker dashboard, or alignment checkpoint | PASS | |
| W9 governance log | governance checklist, release checklist, or signoff log | PASS | |
| Freeze record | pinned repo SHAs, artifact paths, hashes, commands | PASS | |
| Integrated gate logs | post-merge gates for each involved repo/ref | PASS | |
| Source ledger | public comparison and citation source rows, if used | PASS | |
| License/access evidence | dataset, code, report, and redistribution basis | PASS | |
| Protected-path scan | thesis/manuscript/claim registry/roadmap guardrail result | PASS | |
| Claim-language review | exact public text, table, caption, and release-note review | PASS | |
| Rollback plan | owner, trigger, commands, and communication path | PASS | |

Observed pre-template context to carry into the decision record:

- W5 RC manifest sampled `alpha-rc-manifest-draft` with publication `blocked`
  until assembled RC refs, post-merge gates, source-ledger closure, and release
  artifact hashes exist.
- W6 alpha red-team recorded publication `blocked` until exact public bytes,
  frozen inputs, source-ledger and claim-binding closure, dataset/license
  evidence, and integrated validation are available.
- W9-style governance/risk artifacts require fail-closed handling for missing
  evidence, visible caveats for partial rows, reviewer independence, and no
  protected-file edits.

## Decision State Rules

### GO

Allowed only when all of these are true:

- Every required source evidence row is `PASS`.
- The alpha release branch or tag pins full SHAs for async/report, runner,
  stats, datasets, and every public artifact.
- Integrated post-merge gates pass on the exact release refs, not only on
  individual feature branches.
- Snapshot, public report, release notes, source ledgers, caveat tables, and
  freeze records are committed and hashable.
- Dataset license/access/provenance/split/cache status is recorded for every
  public row.
- Public text is limited to frozen benchmark observations, operational status,
  limitations, and replay instructions.
- No protected thesis, manuscript, claim registry, `claims/registry.yaml`,
  `claim_55`, or roadmap path changed in the release lane.
- Rollback criteria and owner are recorded.

### GO-with-caveats

Allowed only when all hard gates pass and every remaining gap is visible,
non-blocking, and bounded. Use this state for an alpha that can ship with
explicit limitations, not for missing evidence that affects replay,
comparability, licensing, protected paths, or public text review.

Required caveat fields:

```text
caveat_id:
affected_artifact:
scope:
public_wording_required:
risk_owner:
follow_up_issue_or_branch:
expiration_or_recheck_trigger:
why_not_blocking:
```

`GO-with-caveats` is not allowed if any of these remain unknown:

- exact repo SHA for an involved release input;
- exact public artifact bytes or hash;
- integrated gate result for a release ref;
- dataset redistribution basis for a public row;
- source-ledger basis for external comparison wording;
- protected-path scan result;
- exact public text review result;
- rollback owner or rollback trigger.

### BLOCKED

Required when any hard gate is failed, missing, stale, or unknown. The default
decision is `BLOCKED` until evidence proves otherwise.

Block immediately for any of these:

- no assembled release candidate ref or dossier spanning all involved repos;
- missing freeze record, snapshot artifact, public report artifact, source
  ledger, caveat table, or release checklist;
- public values without full commit SHA, artifact path, command, validation log,
  and hash or explicit hash-gap blocker;
- external comparison wording without complete source-ledger and value binding;
- dataset row presented as runnable without license/access/provenance/split and
  loader evidence or a blocking caveat;
- integrated post-merge gates not run on the exact candidate refs;
- protected research files changed in the release lane;
- public text changed after redline review without re-review;
- failed, invalid, excluded, timeout, partial, or missing rows hidden from the
  public caveat surface;
- no rollback owner, trigger, or executable rollback path.

## Reviewer Roles

Minimum reviewers. One person may hold multiple roles only when independence is
not required by the gate being reviewed. The decision owner must not be the sole
reviewer for all gates.

| Role | Required responsibility | Signoff |
| --- | --- | --- |
| Decision owner | Chooses `GO`, `GO-with-caveats`, or `BLOCKED` from the record | |
| Release manager | Verifies freeze record, release branch/tag, artifact inventory, and timeline | |
| Integration reviewer | Checks post-merge runner/stats/datasets/async gates on exact refs | |
| Evidence reviewer | Checks hashes, commands, replay logs, source ledgers, and mismatch counts | |
| Data/license reviewer | Checks dataset access, license, redistribution, cache, and provenance status | |
| Public text reviewer | Checks release notes, report text, tables, captions, and caveat visibility | |
| Governance/risk reviewer | Checks blocker dashboard, governance checklist, residual risks, and owners | |
| Red-team reviewer | Records at least one concrete failure-mode check or evidence gap review | |
| Rollback owner | Confirms rollback criteria, commands, access, and notification path | |

Reviewer signoff format:

```text
role:
reviewer:
artifact_refs:
decision: PASS | PASS_WITH_CAVEATS | BLOCKED
blocking_findings:
caveats:
timestamp_utc:
```

## Required Validation Results

Attach exact commands, refs, exit status, and artifact paths. A zero exit code
alone is not enough; the record must state what was checked.

```text
async_report_ref:
async_report_gates:
runner_ref:
runner_gates:
stats_ref:
stats_gates:
datasets_ref:
datasets_gates:
snapshot_validation:
source_ledger_validation:
license_access_validation:
public_text_validation:
protected_path_scan:
coauthored_by_claude_scan:
diff_check:
```

Minimum validation commands to record where applicable:

```bash
git diff --check
rg -n "Co-Authored-By: Claude" .
git diff --name-only origin/main...HEAD | rg '(^|/)(thesis|manuscript|claims/registry\.yaml|claim_55|RESEARCH-ROADMAP)' || true
```

## Caveats And Blockers

### Caveats

Use only for non-blocking limitations that are public, bounded, and assigned.

| ID | Artifact | Caveat | Public wording | Owner | Recheck trigger |
| --- | --- | --- | --- | --- | --- |
| | | | | | |

### Blockers

Every blocker must identify the artifact, exact missing or failed evidence, the
owner, and the next action.

| ID | Severity | Artifact | Blocker | Required close-out | Owner |
| --- | --- | --- | --- | --- | --- |
| | | | | | |

## Rollback Criteria

Rollback is mandatory when any criterion fires after `GO` or
`GO-with-caveats`.

| Criterion | Trigger | Required action | Owner |
| --- | --- | --- | --- |
| Artifact integrity failure | Released bytes or hashes differ from decision record | Remove or supersede release artifact; publish correction record | |
| Replay failure | Independent replay cannot locate frozen inputs or reports mismatches outside tolerance | Move release to blocked/withdrawn state; open replay fix task | |
| Protected-path breach | Release lane changed thesis, manuscript, claim registry, `claim_55`, or roadmap paths | Revert release commit/tag; file incident record | |
| Unsupported public wording | Public text implies unsupported claim, comparison, or ranking | Remove or replace public artifact; rerun public text review | |
| License/access breach | Dataset, code, report, or redistribution basis is missing or contradicted | Withdraw affected artifact rows; publish caveat or block record | |
| Source-ledger breach | Public comparison lacks complete source or frozen value binding | Remove comparison wording; rerun source-ledger review | |
| Gate drift | Candidate ref differs from signed-off ref without re-review | Freeze new ref or roll back to signed-off ref | |
| Co-author metadata breach | `Co-Authored-By: Claude` appears in release commits | Rewrite/supersede offending release commit before publication | |

Rollback execution record:

```text
rollback_triggered: yes | no
trigger_id:
trigger_timestamp_utc:
rollback_owner:
rollback_commit_or_tag_action:
public_notice_path:
follow_up_task:
closure_timestamp_utc:
```

## Final Decision

```text
decision_state: GO | GO-with-caveats | BLOCKED
decision_owner:
decision_timestamp_utc:
evidence_summary:
caveats_summary:
blockers_summary:
rollback_summary:
```

Final statement template:

```text
Based on the evidence and reviewer signoffs above, the alpha release decision is
<GO | GO-with-caveats | BLOCKED>. This decision covers only the frozen artifacts
and refs listed in this record. Any changed public text, input ref, artifact
hash, validation result, source-ledger row, license/access status, or protected
path scan invalidates this decision until re-reviewed.
```
