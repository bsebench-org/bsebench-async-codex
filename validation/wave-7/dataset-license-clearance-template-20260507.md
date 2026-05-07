# Wave 7 Validation: Dataset License Clearance Template

Validated artifact:
`templates/datasets/license-clearance-template-20260507.md`

Worker: W7-f
Date: 2026-05-07
Branch: `phase-8-6-f-dataset-license-clearance-template-20260507T214305Z`

## Scope Check

Owned write-set only:

- `templates/datasets/license-clearance-template-20260507.md`
- `validation/wave-7/dataset-license-clearance-template-20260507.md`

No thesis files, manuscript files, claim registry files, `claims/registry.yaml`,
`claim_55`, runner, stats, datasets, or roadmap files were edited.

## Evidence Inspected

Local evidence inspected from the async report repository:

- `docs/BSEBENCH-UNIVERSAL-BENCHMARK-CHARTER-2026-05-07.md`
  - monthly benchmark snapshots are a planned public workflow.
  - reports must include caveats, missing data, and invalid comparability cases.
- `docs/RESEARCH-GATE-PROTOCOL-2026-05-07.md`
  - missing metadata is a gap, not inferred metadata.
  - unknown source identity cannot support a scientific claim.
- `outbox/phase-7-2-zenodo-citation-metadata/SUMMARY.md`
  - dataset repository citation metadata work exists, but it is repository
    metadata and does not by itself clear upstream dataset redistribution.
- `outbox/phase-7-8-h-datasets-auditj-local-cache-manifest/SUMMARY.md`
  - local cache audit distinguishes missing, unreadable, and loader-readable
    states.
  - example local probe reported `ready=False`, `loader_readable=0`,
    `missing=26`, and `gaps=26`.
- `outbox/phase-7-10-i-datasets-phase8-cache-probe/SUMMARY.md`
  - availability states include ready, missing, unreadable, and
    unknown-metadata buckets.
- `outbox/phase-7-10-m-datasets-phase11-provenance-inventory/SUMMARY.md`
  - Phase 11 inventory records unavailable metadata as explicit gaps.
  - local inventory result reported 58 candidate configs as `missing` and 13
    metadata-only registry entries as `not_applicable`.

Dataset license red-team output:

- Local branch `phase-8-5-h-dataset-license-redteam-20260507T213656Z` is present
  but points at the current `origin/main` commit in this clone.
- `git ls-remote --heads origin '*license*' '*phase-8-5-h*' '*phase-8-6-f*'`
  returned no remote license/red-team branch refs at validation time.
- No committed dataset-license red-team artifact was available to inspect.

## Template Design Validation

The template is suitable for monthly public reports because it requires:

- a complete dataset clearance matrix for every dataset used in figures, tables,
  aggregate metrics, or artifacts;
- explicit separation between benchmark code license and upstream dataset
  license terms;
- public-report caveat text for non-redistributed or aggregate-only datasets;
- reviewer sign-off with evidence paths and dates.

The template is suitable for release gates because it requires:

- evidence for source identity, license/terms, retrieval date or registry commit,
  attribution, and exact redistribution mode;
- separate decisions for raw redistribution and derived/cache redistribution;
- release artifact checks that raw and processed files are absent unless
  redistribution is cleared;
- a blocking gate for unknown, missing, contradictory, expired, or non-public
  redistribution terms.

## Fail-Closed Policy

The template records this policy:

- Unknown dataset license, unknown redistribution permission, missing source
  URL, missing registry entry, or missing permission evidence means
  `redistribution_decision = blocked_unknown_terms`.
- `blocked_unknown_terms` blocks raw data, derived row-level data, local cache
  mirrors, and public download links until a reviewed license or permission
  record is committed.
- Aggregate public reporting may proceed only when source identity is known and
  the report states that the data itself is not redistributed.

This satisfies the task requirement to fail closed for unknown redistribution.

## Blockers

- No dataset-license red-team output was present in this worktree or visible as
  a remote branch at validation time. The template therefore includes a required
  `Dataset license red-team` evidence row and a `path-or-none` field rather than
  inventing red-team findings.
- The async report repository does not contain upstream per-dataset license
  records. The template requires those records as inputs and blocks missing
  values.

## Validation Commands

Commands run:

```sh
git status --short --branch
rg -n "license|licence|redistribution|dataset|red[- ]team|clearance|fail[- ]closed|monthly public|release gate" -S .
rg --files .
sed -n '1,220p' outbox/phase-7-10-m-datasets-phase11-provenance-inventory/SUMMARY.md
sed -n '1,220p' outbox/phase-7-8-h-datasets-auditj-local-cache-manifest/SUMMARY.md
sed -n '1,220p' outbox/phase-7-2-zenodo-citation-metadata/SUMMARY.md
sed -n '1,260p' docs/BSEBENCH-UNIVERSAL-BENCHMARK-CHARTER-2026-05-07.md
sed -n '1,260p' docs/RESEARCH-GATE-PROTOCOL-2026-05-07.md
git ls-tree -r --name-only phase-8-5-h-dataset-license-redteam-20260507T213656Z | rg "license|redteam|validation|template|dataset"
git ls-remote --heads origin '*license*' '*phase-8-5-h*' '*phase-8-6-f*'
```

Final validation command:

```sh
git diff --check
```

Result:

- `git diff --check`: passed.
- Forbidden-claim scan over owned files found only negative guardrail wording:
  the template says it does not certify SOTA, novelty, or leaderboard status,
  and the validation note records that protected files were not edited.
