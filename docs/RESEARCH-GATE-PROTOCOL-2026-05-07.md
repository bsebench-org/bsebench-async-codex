# Research Gate Protocol - 2026-05-07

This protocol is the anti-hallucination and fair-comparison gate for BSEBench
autonomous research tasks. It applies to every Phase 7, Phase 8, or Phase 11
BRIEF, and to any other task that mentions scientific claims, novelty, SOTA,
thesis text, claim registry updates, or manuscript-ready conclusions.

The core rule is separation of duties:

1. Evidence generation creates or audits empirical artifacts.
2. SOTA comparison interprets frozen evidence against cited external sources.
3. Claim registration edits thesis/manuscript/registry prose only after the
   evidence and comparison gates have both passed.

If a task cannot keep those three lanes distinct, it is not mergeable. A BRIEF
that asks one worker to generate evidence, compare against SOTA, and register a
claim must be split into separate tasks before execution.

## Lane Handoff Contract

Each BRIEF must declare exactly one active lane. A task may cite artifacts from
earlier lanes, but it must not perform the next lane's write action.

| Active lane | Allowed writes | Required handoff artifact | Forbidden writes |
|---|---|---|---|
| Evidence generation | Evidence scripts, manifests, neutral reports, replay outputs | Provenance record plus independent replay result | SOTA/novelty statements, claim registry, thesis/manuscript prose |
| SOTA comparison | Source ledger and comparison report over frozen evidence | Source ledger with comparability decisions | New empirical evidence, claim registry, thesis/manuscript prose |
| Claim registration | Explicit claim/prose/registry update authorized by BRIEF | Claim decision citing validated evidence and SOTA ledger | New evidence generation or uncited SOTA comparison |

This handoff is the falsification boundary: if a worker cannot identify which
handoff artifact it is producing, the task is underspecified and should fail
before making scientific statements.

## Lane Definitions

### Evidence Generation

Evidence generation may create scripts, manifests, numeric outputs, validation
logs, and neutral candidate reports. It must not assert novelty, SOTA status,
claim verification, claim rejection, or thesis-ready interpretation.

Required output posture:

- "mechanical evidence only" or equivalent neutral wording.
- Explicit artifact paths and commit SHAs.
- Explicit failure/mismatch fields, not just successful command completion.
- No edits to thesis prose, claim registries, roadmap claim status, or README
  scientific conclusions.

### SOTA Comparison

SOTA comparison consumes frozen evidence and a source ledger. It may state that
an external result is comparable, partially comparable, or not comparable. It
must not create new empirical evidence in the same task unless that evidence is
strictly read-only replay/audit of the frozen artifacts.

Required output posture:

- Every external number has a source ledger row.
- Missing split/metric/preprocessing details are treated as comparability gaps,
  not as permission to compare anyway.
- "Best observed in this artifact" is not the same as "SOTA".

### Claim Registration

Claim registration is the only lane allowed to edit thesis claim registries,
manuscript prose, or final claim status. It is allowed only when a separate
BRIEF explicitly authorizes it and points to validated evidence artifacts plus a
completed SOTA source ledger.

Required output posture:

- Cite evidence bundle path, replay command, validation log, and source ledger.
- State the exact claim status being changed.
- Include the falsification condition that would require rollback.

## Mandatory Gates

### G1 - Evidence Provenance

Every evidence-producing BRIEF must require a provenance record. The record can
be JSON, Markdown, or both, but it must include:

- Target repo, branch, and commit SHA.
- Command line used to generate the artifact.
- Input dataset/config identifiers and local paths when applicable.
- Input artifact hashes when practical.
- Output artifact paths and hashes when practical.
- Environment facts that affect replay, such as lockfile status or package
  manager command.
- A statement that unavailable metadata is a gap, not inferred metadata.

An artifact with unknown source identity cannot support a scientific claim.

### G2 - Independent Replay

Every evidence-producing or claim-supporting task must define an independent
replay path. Replay must consume committed artifacts or frozen local cache state;
it must not silently regenerate different evidence.

Replay output must distinguish at least:

- Command executed.
- Artifact read.
- Values compared.
- Mismatch count.
- Tolerances.
- Pass/fail status.

"Script exited zero" is insufficient if the output does not say what was
checked.

### G3 - Falsification Condition

Every applicable BRIEF must include a "Falsification gate" or equivalent section.
It must name a concrete condition that would make the task fail, weaken the
candidate result, or block downstream claim work.

Acceptable examples:

- Replay mismatch count is non-zero.
- A strict-evidence loader cannot be mapped to deterministic local provenance.
- A conclusion changes under leave-one-dataset-out or weighting sensitivity.
- A SOTA source lacks the same dataset, split, metric, or preprocessing.
- A report cannot prove it is mechanical-only and not a claim verdict.

Vague wording such as "be careful not to overclaim" is not enough.

### G4 - SOTA Comparison Source Ledger

No SOTA, novelty, leaderboard, or "better than prior work" statement is allowed
without a source ledger. The ledger must be committed with the comparison task
or cited as an existing artifact.

Minimum ledger fields:

| Field | Required content |
|---|---|
| `source_id` | Stable local identifier. |
| `title` | Paper, benchmark, repository, or report title. |
| `stable_url_or_doi` | DOI, arXiv URL, official repo URL, or other stable URL. |
| `retrieval_date` | Retrieval date in `YYYY-MM-DD` format. |
| `metric` | Exact metric name and units. |
| `dataset` | Dataset and variant/profile. |
| `split` | Train/test split, validation protocol, horizon, or run condition. |
| `preprocessing_or_run_condition` | Preprocessing, leakage-relevant transformation, profile, horizon, or explicit `not_reported` limitation. |
| `method` | Method/model/baseline name exactly as the source reports it. |
| `reported_value` | Exact external value, table/figure/page if available. |
| `bsebench_frozen_value` | Frozen BSEBench value being compared. |
| `comparability` | `comparable`, `partial`, or `not_comparable`. |
| `comparability_caveat` | Reason for any limitation or missing field. |

If any required field is unknown, the ledger row must mark the comparison
`partial` or `not_comparable`. It must not silently fill gaps from memory.
Rows with future retrieval dates, stale retrieval dates, malformed dates,
missing stable URL/DOI, missing frozen BSEBench values, or `comparable` labels
over unknown required conditions are invalid for downstream comparison wording.
The executable row-level guard is `scripts/check-source-ledger-freshness.sh`;
it classifies rows as `comparable`, `partial`, `not_comparable`, `stale`, or
`invalid`.

### G5 - No Claim Until Validated

Autonomous tasks may not edit thesis files, claim registries, roadmap claim
status, manuscript prose, or README scientific conclusions unless the BRIEF is a
claim-registration task and explicitly says so.

Before claim registration, the only allowed language is candidate language:

- "mechanical evidence"
- "candidate"
- "replay passed"
- "comparison ledger indicates comparable/partial/not comparable"
- "blocked by missing evidence/source/provenance"

Disallowed before validation:

- "verified"
- "proven"
- "SOTA"
- "novel"
- "thesis claim accepted"
- "claim registry updated"

### G6 - Hourly Direction Checkpoint

Long-running autonomous work must re-check direction at least hourly. The worker
or watchdog should ask:

- Is the task still mapped to a roadmap lane or direct validation gate?
- What could prove the current result wrong?
- Is an independent replay or validator checking artifacts, not just style?
- Are SOTA comparisons backed by a source ledger?
- Is the branch drifting into thesis prose, roadmap edits, or claim registry
  edits?

If any answer is missing, pause claim-related interpretation and sharpen the
validation task before continuing.

## BRIEF Checklist

New Phase 7, Phase 8, and Phase 11 BRIEFs should contain these sections or
equivalent explicit wording:

- A falsification condition.
- A validation/replay command list.
- A prohibition on thesis and claim registry edits unless the task is explicit
  claim registration.
- A prohibition on unsupported SOTA, novelty, or claim language.
- For SOTA work, a source ledger requirement with DOI or stable URL, retrieval
  date, metric, dataset, split, and comparability caveat.
- For evidence work, a provenance artifact requirement.

The lightweight checker in `scripts/check-research-brief-gates.sh` enforces the
minimum wording gate for new Phase 7/8/11 BRIEFs. It is intentionally not a
substitute for reviewer judgment; it blocks missing guardrails early.

## Merge Rule

A research task is incomplete when it conflates evidence generation, SOTA
comparison, and claim registration. The merge decision should be:

- `approved` only when the active lane is explicit and its gates pass.
- `needs_fix` when guardrail wording, provenance, replay, or source ledger
  requirements are missing.
- `escalated` when the BRIEF requests a scientific claim but lacks validated
  evidence or fair comparison sources.

No exception may be justified by "the result looks obvious" or by memory of a
paper. Evidence and comparisons must be inspectable from committed artifacts.
