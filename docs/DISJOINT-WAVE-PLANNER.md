# Disjoint Wave Planner

`scripts/plan-disjoint-wave.sh` is a dry-run helper for planning high-parallel
worker waves before phases are queued. It checks that each proposed worker has
a declared target repo, branch, validation command, and repo-relative write-set,
then rejects same-repo write-set overlaps and protected research surfaces.

## Manifest Contract

Use a tab-separated manifest with this header:

```text
worker_id	phase_id	target_repo	target_branch	write_set	validation
```

`write_set` is a semicolon- or comma-separated list of paths relative to
`target_repo`:

```text
A4	universal-async-disjoint-wave-planner	bsebench-async-codex	phase-8-0-v-universal-async-disjoint-wave-planner	scripts/plan-disjoint-wave.sh;docs/DISJOINT-WAVE-PLANNER.md;tests/test-disjoint-wave-planner.sh	bash tests/test-disjoint-wave-planner.sh
```

The planner is conservative. For entries that target the same repo, exact path
matches, parent/child paths, and compatible glob-style patterns are treated as
conflicts. Entries targeting different repos are independent.

## Protected Surfaces

The helper rejects write-set items that target protected paths called out in the
universal benchmark guardrails:

- thesis or manuscript paths;
- claim registry paths such as `claims/registry.yaml`;
- `claim_55` paths;
- research or scientific roadmap paths.

This is a planning guard only. It does not replace code review, validation, or
the source-ledger requirements for scientific claims.

## Dry Run

Run:

```bash
scripts/plan-disjoint-wave.sh --dry-run --manifest tests/fixtures/disjoint-wave/clean.tsv
```

Expected success output ends with:

```text
[OK] disjoint wave plan accepted
```

Rejected plans exit non-zero and print `[FAIL]` lines with the conflicting
phase ids and paths.
