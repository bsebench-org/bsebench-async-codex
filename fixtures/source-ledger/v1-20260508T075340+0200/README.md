# Source Ledger Fixture Set v1

## Objective

Draft minimal source-ledger fixture examples and validation expectations for
future literature/comparability rows. These fixtures are synthetic and are only
intended to make source-ledger completeness and comparability decisions
falsifiable before any downstream comparison or claim-registration work.

This fixture set does not assert SOTA, novelty, leaderboard status,
breakthroughs, or verified scientific claims.

## Inputs Inspected

- Current branch: `phase-8-11-d-source-ledger-fixtures-20260508T075340+0200`.
- `docs/RESEARCH-GATE-PROTOCOL-2026-05-07.md`, especially G4 source-ledger
  minimum fields and the separation between evidence generation, comparison,
  and claim registration.
- `inbox/phase-7-10-p-async-source-ledger-comparability-fixtures/BRIEF.md`,
  which required synthetic comparable, partial, not-comparable, and
  missing-required-field source-ledger cases.
- `outbox/phase-7-10-p-async-source-ledger-comparability-fixtures/SUMMARY.md`,
  which showed a prior async-side source-ledger fixture/checker shape.

## Files

- `literature-comparability-fixtures.json` contains synthetic example rows.
- `validation-expectations.json` contains the expected validator decisions.

## Decisions

- Use synthetic rows only. No real literature values were invented or copied.
- Keep the fixture field names explicit and close to the worker brief:
  `stable_url_or_doi`, `retrieval_date`, `metric`, `dataset`, `split`,
  `method`, `reported_value`, `bsebench_frozen_value`, `comparability`, and
  `comparability_caveat`.
- Treat `comparable`, `partial`, and `not_comparable` as valid completed row
  states when all required fields are present and the caveat is non-empty.
- Treat missing required fields as incomplete. A row marked `comparable` with a
  missing caveat is also incomplete, because future reviewers need an explicit
  basis for the comparison decision.
- Keep examples small enough to be reviewed by eye and parsed by lightweight
  JSON tooling.

## Validation Checklist

A future checker consuming these fixtures should pass rows that:

- include a stable URL or DOI;
- include an ISO retrieval date;
- include exact metric, dataset, split, and method identifiers;
- include a reported source value and frozen BSEBench value;
- include one of `comparable`, `partial`, or `not_comparable`;
- include a comparability caveat that is not blank.

A future checker should fail rows that:

- omit any required field;
- use an unsupported comparability value;
- mark a row `comparable` while leaving the caveat blank;
- make comparison-promoting language without a complete source ledger row.

## Residual Risks

- These fixtures do not validate real DOI or URL reachability.
- These fixtures do not prove that metric, dataset, split, or preprocessing
  semantics match real external sources.
- These fixtures do not bind to a frozen BSEBench evidence artifact hash.
- These fixtures are examples and expectations, not a repository-wide gate.

## Next Concrete Task

Add or wire a scoped checker that reads this fixture shape and reports pass/fail
for comparable, partial, not-comparable, missing-field, and blank-caveat cases
without editing protected thesis, claim registry, manuscript, roadmap, or
`claim_55` files.
