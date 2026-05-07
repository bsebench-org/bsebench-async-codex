# Data Licensing and Availability Audit for Monthly Public Benchmark Snapshots

## GLASSBOX Metadata

- Worker: M-DATA-LICENSE.
- Date: 2026-05-07.
- Branch: `phase-8-2-i-data-licensing-availability-audit-20260507T193528Z`.
- Owned artifact: `audits/methodology/data-licensing-availability-20260507T193528Z.md`.
- Scope: audit, spec, and runbook only. No dataset, runner, stats, thesis,
  manuscript, claim registry, `claim_55`, or scientific roadmap edits.
- Active lane: public benchmark data-rights and availability gate.
- Claim posture: this is not legal advice and makes no SOTA, novelty,
  leaderboard, breakthrough, or verified-claim statement.

## Objective

Define the dataset licensing, availability, and mirroring gate that must pass
before a BSEBench monthly public benchmark snapshot can list a dataset as
publicly runnable, mirrored, or comparable.

The audit separates four states that must not be conflated:

1. A dataset prospect is discoverable and useful for planning.
2. A source can legally be mirrored by BSEBench.
3. A strict manifest and Hugging Face mirror exist with content hashes.
4. A benchmark runner can load the exact Tier 2 files needed by the snapshot.

A monthly public report may include all four states, but only state 4 can be
used as a runnable benchmark row. Missing licensing, access, checksum, cache, or
loader evidence must appear as an explicit publication blocker or caveat.

## Evidence Inspected

Local evidence inspected, read-only:

- `docs/BSEBENCH-UNIVERSAL-BENCHMARK-CHARTER-2026-05-07.md`: requires recurring
  public benchmark workflow, caveats, missing data, and provenance.
- `docs/BSEBENCH-UNIVERSAL-PARALLEL-WAVE-2026-05-07.md`: bans unsupported
  public claims and maps dataset Wave 1 work to ETL, ground truth, split
  metadata, dataset cards, equipment registry, and monthly availability.
- `/mnt/c/doctorat/bsebench-org/bsebench-datasets/README.md`: documents Tier 1
  raw mirrors, Tier 2 canonical Parquet, loader-facing arrays, and source data
  licenses retained from upstream records.
- `/mnt/c/doctorat/bsebench-org/bsebench-datasets/catalog/dataset_prospects.yaml`
  and `catalog/README.md`: broad discovery catalog, not official mirror proof.
- `/mnt/c/doctorat/bsebench-org/bsebench-datasets/src/bsebench_datasets/prospect.py`:
  prospect schema with `license`, `redistribution`, `access_friction`,
  `ingestion_status`, Hugging Face repo fields, and blockers.
- `/mnt/c/doctorat/bsebench-org/bsebench-datasets/src/bsebench_datasets/manifest.py`
  and `manifests/README.md`: strict manifest intent, source provenance,
  checksummed files, and `redistribution_allowed`.
- Manifest field scan over 13 current manifests: 12 have Tier 1 repos and 5 have
  Tier 2 repos recorded by the monthly availability projection.
- `/mnt/c/doctorat/bsebench-org/bsebench-datasets-phase-8-0-r-universal-datasets-monthly-availability/src/bsebench_datasets/availability.py`:
  unmerged read-only monthly availability snapshot model.
- `/mnt/c/doctorat/bsebench-org/bsebench-datasets-phase-8-0-p-universal-datasets-card-schema/src/bsebench_datasets/dataset_card.py`:
  unmerged dataset-card schema requiring sources, retrieval dates, license,
  redistribution status, content digests for complete ledgers, and benchmark
  coverage fields.
- Prior worker summaries:
  - `outbox/phase-7-8-c-datasets-hinf-loader-provenance-audit/SUMMARY.md`.
  - `outbox/phase-7-8-h-datasets-auditj-local-cache-manifest/SUMMARY.md`.
  - `outbox/phase-7-9-e-datasets-local-cache-root-resolution/SUMMARY.md`.
  - `outbox/phase-7-10-m-datasets-phase11-provenance-inventory/SUMMARY.md`.
- `docs/RESEARCH-GATE-PROTOCOL-2026-05-07.md` and
  `outbox/phase-7-10-p-async-source-ledger-comparability-fixtures/SUMMARY.md`:
  source-ledger and comparability fields for any external comparison.

External official references inspected for platform semantics only:

- Hugging Face dataset-card docs state that dataset repos render `README.md` as
  cards and that metadata includes license and size information:
  https://huggingface.co/docs/hub/main/datasets-cards
- Hugging Face gated-dataset docs state that gated access can require user
  requests, tokens for downloads, and can be revoked by dataset authors:
  https://huggingface.co/docs/hub/main/datasets-gated
- Zenodo FAQ states that permissions depend on the license on the record and
  that Zenodo does not own uploaded content:
  https://support.zenodo.org/help/en-gb/2-content/21-can-i-get-permission-to-use-a-specific-record
- Mendeley Data describes open and restricted-access datasets, DOI metadata,
  checksums, and permanent archiving of published versions:
  https://data.mendeley.com/about

## Inspection Results

Observed prospect catalog state from local structured parsing:

| Item | Value |
|---|---:|
| Prospect records | 33 |
| Named source plus variant items | 222 |
| `ingestion_status=mirrored_tier2` | 2 |
| `ingestion_status=mirrored_tier1` | 10 |
| `ingestion_status=ready_for_tier1` | 1 |
| `ingestion_status=license_review` | 10 |
| `ingestion_status=source_verification` | 10 |
| `redistribution=allowed` | 14 |
| `redistribution=unknown` | 19 |
| `access_friction=open` | 27 |
| `access_friction=registration_required` | 2 |
| `access_friction=unknown` | 4 |
| Prospect rows with missing `license` | 14 |
| Prospect rows with missing `canonical_doi` | 23 |
| Prospect rows with non-empty `blockers` | 6 |

Observed monthly availability prototype state:

| Item | Value |
|---|---:|
| Total availability records | 34 |
| Manifest-backed records | 13 |
| Prospect-only records | 21 |
| Manifest records with Tier 1 repo | 12 |
| Manifest records with Tier 2 repo | 5 |
| `tier2_available` rows | 5 |
| `tier1_available` rows | 8 |
| `prospect_tracked` rows | 21 |

Publication-relevant blockers observed in the catalog or prior evidence:

| Blocker | Affected rows or evidence | Publication decision |
|---|---|---|
| Unknown redistribution rights | 19 prospect rows have `redistribution=unknown`. | Catalog-only rows may be shown as prospects but must not be mirrored or benchmark-ranked. |
| Missing explicit license | 14 prospect rows lack a `license` value. | Block mirroring and public runnable status until license source and reviewer decision are recorded. |
| Mixed-source aggregate rights | `battery_life_aggregate` notes mixed upstream licenses. | Mirror source-by-source only; do not mirror or rank the aggregate as one rights unit. |
| NASA aging license ambiguity | `nasa_pcoe_liion_aging` blocker says current open-data page has no specified license. | Treat as license-review only until public-domain or license terms are verified from source. |
| CALCE portal redistribution ambiguity | `calce_battery_portal` says citation requested but no standard redistribution license found. | Use only when access and redistribution terms are documented; do not mirror based on citation request alone. |
| Battery Archive permission ambiguity | `sandia_battery_archive` notes dataset-specific mirror rights need verification. | Require per-record permission evidence before mirroring. |
| Registration-required source access | `severson_2019_lfp` and `mit_stanford_toyota_fast_charge` carry registration friction. | Public snapshot must disclose access friction and rely on BSEBench mirror hashes where mirroring is allowed. |
| Tier 2 incompleteness | Availability prototype sees only 5 manifest-backed Tier 2 rows. | Non-Tier-2 rows are not runnable public benchmark rows. |
| Local cache unavailability | Prior Audit J cache manifest found `ready=False`, `loader_readable=0`, `missing=26`; Phase 11 inventory found 58 missing candidate configs. | Monthly run must record cache/readiness status and cannot infer availability from catalog metadata. |
| Strict manifest/schema drift | `list_datasets(manifests)` on current main failed on extra manifest fields such as `cell_count_by_chemistry` and Tier 2 audit fields. | Publication tooling should use a versioned availability projection or update strict schema before treating manifest validation as green. |

## Decisions and Recommendations

### Decision 1 - Public Snapshot Dataset States

Every monthly snapshot row must use one of these states:

| State | Meaning | Allowed public use |
|---|---|---|
| `benchmark_ready` | Manifest-backed, redistribution allowed, Tier 2 repo recorded, exact files hashed, loader probe passes, split/protocol frozen. | Runnable benchmark row and same-snapshot comparison, subject to metric and split gates. |
| `tier2_metadata_ready` | Manifest and Tier 2 repo exist, but the monthly runner did not prove loader/cache readiness. | Availability table only; not scored. |
| `tier1_only` | Strict manifest and raw mirror exist, but no benchmark-facing Tier 2 loader/files for this snapshot. | Data inventory or future-work row only. |
| `prospect_allowed_not_mirrored` | Catalog row says redistribution allowed but no strict manifest or mirror proof exists. | Discovery table only. |
| `prospect_license_review` | License, redistribution, or source identity is missing or ambiguous. | Discovery table with blocker; no mirroring, ranking, or public runnable status. |
| `restricted_or_manual_access` | Source requires registration, request form, institutional access, or gated workflow. | Disclose access friction; do not promise public reproducibility unless BSEBench mirror is rights-cleared and hash-pinned. |
| `blocked` | Redistribution is blocked, noncommercial-only for incompatible public use, takedown pending, or source terms conflict with mirroring. | Exclude from mirrors and benchmark rows; retain only blocker note if useful. |

### Decision 2 - Manifest Is Necessary But Not Sufficient

A manifest proves that BSEBench has structured metadata and file hashes. It does
not alone prove that a monthly benchmark can run. Publication readiness also
requires:

- Hugging Face Tier 2 repo or equivalent immutable benchmark-facing artifact.
- Exact file inventory and SHA256 for every file consumed by the loader.
- Loader read probe for every snapshot config.
- Split/protocol identity and metric compatibility.
- Dataset card or equivalent source ledger with retrieval date and license
  evidence.

### Decision 3 - Prospect Catalog Is Not a Mirror Permission Ledger

`dataset_prospects.yaml` is useful for planning breadth. It must not be used as
the sole evidence for mirroring or monthly benchmark inclusion. Any prospect
with `redistribution=unknown`, missing `license`, missing canonical source, or
non-empty blockers remains non-runnable until promoted through a strict rights
and manifest workflow.

### Decision 4 - Mirroring Must Be Rights-Scoped Per Source

Do not mirror aggregate portals or multi-source benchmarks as a single rights
unit. Mirror only the specific source files whose license, access terms,
checksum, source URL, and attribution requirements have been verified. Mixed
catalog families must be split into source-level rows before Tier 1 upload.

### Decision 5 - Gated or Revocable Access Needs Runtime Caveats

If an upstream or mirror access path is gated, token-required, request-based, or
revocable, the monthly snapshot must record that state. A public report can say
the row is traceable, but it must not imply frictionless third-party replay
unless a rights-cleared BSEBench mirror is available without hidden manual
steps.

## Required Publication Fields

Every dataset row in a monthly public snapshot must include these fields or be
reported as blocked/partial.

Dataset identity:

- `dataset_id`, `display_name`, `record_source`, `manifest_version`.
- `cell_id` or variant identifiers when the row is cell/profile specific.
- `chemistry`, `profile`, `temperature_basis`, `tasks`.
- `snapshot_month`, `generated_on`, `snapshot_commit`.

Source and license evidence:

- `canonical_url` and `canonical_doi` when one exists.
- `retrieval_date` for the license/source record used by the snapshot.
- `source_title`, `source_authors`, `source_publication_year`.
- `license_id`, `license_url_or_record_location`, `license_retrieved_at`.
- `redistribution_status`: `allowed`, `blocked`, `noncommercial_only`,
  `unknown`, or `not_applicable`.
- `redistribution_reviewer` and `redistribution_decision_date`.
- `attribution_required`, `share_alike_required`, `noncommercial_restriction`,
  `gated_access`, `request_form_required`, `registration_required`.
- `access_friction` and public access instructions.

Mirroring and content identity:

- `huggingface_tier1_repo`, `huggingface_tier1_revision`.
- `huggingface_tier2_repo`, `huggingface_tier2_revision`.
- `upstream_file_inventory` with `path`, `size_bytes`, and `sha256`.
- `tier1_file_inventory` with `path`, `size_bytes`, and `sha256`.
- `tier2_file_inventory` with `path`, `size_bytes`, and `sha256`.
- `transform_script`, `transform_commit`, and transformation caveats.
- `takedown_contact`, `takedown_policy`, and last mirror audit date.

Availability and benchmark readiness:

- `availability_status` from the state table above.
- `availability_checked_at`, `availability_check_method`.
- `loader_id`, `loader_version_or_commit`, `loader_probe_status`.
- `required_files`, `missing_files`, `unreadable_files`.
- `cache_root_source`: CLI override, env var, discovered Tier 2 root, or remote.
- `split_id`, `protocol_id`, `metric_set_id`, and `benchmark_ready` boolean.
- `blockers` list and `caveat` string for every non-ready row.

Report-safety fields:

- `public_report_scope`: `runnable`, `inventory_only`, `discovery_only`, or
  `excluded`.
- `comparison_allowed`: true only for `benchmark_ready` rows with matching
  metric, split, protocol, and source-ledger evidence.
- `non_claim_statement`: confirms the row is not a SOTA, novelty, leaderboard,
  breakthrough, or verified-claim assertion.

## Monthly Snapshot Runbook

1. Freeze repository SHAs for `bsebench-datasets`, `bsebench-runner`,
   `bsebench-stats`, and the async report repo.
2. Validate `catalog/dataset_prospects.yaml`; record counts by redistribution,
   ingestion status, access friction, missing license, and blockers.
3. Validate strict manifests. If strict manifest parsing fails, either update
   the schema or route the monthly report through a documented availability
   projection that explicitly ignores non-publication fields.
4. Build the monthly availability snapshot from manifests plus prospects.
5. For each manifest-backed row, verify license fields, redistribution decision,
   source URL/DOI, retrieval date, and file SHA256 inventory.
6. For each Tier 2 candidate, run a loader/cache probe against the exact split
   and profile/temperature configs used by the snapshot.
7. Downgrade every row without a passing loader probe to `tier2_metadata_ready`,
   `tier1_only`, or `prospect_*` as appropriate. Do not silently omit it.
8. Review every `redistribution=unknown`, missing-license, non-empty-blocker,
   gated, or request-form row. These rows cannot be mirrored or ranked until
   resolved.
9. Generate the public report tables from the availability states. Keep
   discovery/prospect rows separate from runnable benchmark rows.
10. Run the source-ledger comparability gate before any external comparison text
    appears in release notes, README snippets, tables, captions, or website
    copy.
11. Archive the final availability JSON/CSV, validation logs, repo SHAs, and
    generated report artifact hashes with the monthly snapshot.

## Validation Commands

Commands run or used as exact local checks during this audit:

```bash
# Inspect prospect catalog counts and blockers.
uv run python - <<'PY'
from pathlib import Path
from collections import Counter
from bsebench_datasets.prospect import load_prospect_catalog
cat = load_prospect_catalog(Path("catalog/dataset_prospects.yaml"))
print("prospects", len(cat.prospects))
print("named_items", cat.named_item_count())
print("ingestion_status", dict(sorted(Counter(p.ingestion_status for p in cat.prospects).items())))
print("redistribution", dict(sorted(Counter(p.redistribution for p in cat.prospects).items())))
print("access_friction", dict(sorted(Counter(p.access_friction for p in cat.prospects).items())))
print("license_missing", sum(1 for p in cat.prospects if not p.license))
print("canonical_doi_missing", sum(1 for p in cat.prospects if not p.canonical_doi))
print("blockers_nonempty", sum(1 for p in cat.prospects if p.blockers))
PY

# Validate the prospect catalog test and export path.
uv run pytest tests/test_prospect_catalog.py -q
uv run python scripts/export_dataset_catalog.py \
  --catalog catalog/dataset_prospects.yaml \
  --out /tmp/bsebench-dataset-catalog-audit

# Build the unmerged monthly availability snapshot prototype.
uv run pytest tests/test_availability_snapshot.py -q
uv run python - <<'PY'
from pathlib import Path
from collections import Counter
from bsebench_datasets.availability import build_availability_snapshot
root = Path(".")
s = build_availability_snapshot(
    root / "manifests",
    root / "catalog" / "dataset_prospects.yaml",
    snapshot_month="2026-05",
    generated_on="2026-05-07",
)
print("summary", s.summary.model_dump())
print("status_counts", dict(sorted(Counter(r.availability_status for r in s.records).items())))
PY

# Expose current strict-manifest drift.
uv run python - <<'PY'
from pathlib import Path
from bsebench_datasets.manifest import list_datasets
print(len(list_datasets(Path("manifests"))))
PY

# Repository hygiene for this scoped artifact.
git diff --check
git diff --cached --check
```

Observed validation results:

- Prospect summary command: parsed 33 prospects and 222 named items; counts are
  recorded in the inspection table above.
- `uv run pytest tests/test_prospect_catalog.py -q`: passed.
- `uv run python scripts/export_dataset_catalog.py --catalog catalog/dataset_prospects.yaml --out /tmp/bsebench-dataset-catalog-audit`: passed and exported 33 prospect records.
- Monthly availability summary command on the Phase 8 availability worktree:
  `total_records=34`, `manifest_records=13`, `prospect_only_records=21`,
  `manifest_tier1_records=12`, `manifest_tier2_records=5`.
- `uv run pytest tests/test_availability_snapshot.py -q`: passed on the
  unmerged availability worktree.
- Strict manifest parse command on current `bsebench-datasets/main`: failed on
  schema drift caused by extra manifest fields. This is recorded as a
  publication blocker, not as a failure of this audit artifact.
- `git diff --check`: passed after this report was written.
- `git diff --cached --check`: passed after staging this scoped artifact.

## Residual Risks

- This audit sampled local repositories and selected official platform docs on
  2026-05-07. Upstream dataset licenses, access controls, and mirror state can
  change; monthly snapshots need fresh retrieval dates.
- The availability snapshot and dataset-card schemas inspected here are active
  Phase 8 worktrees, not merged release APIs. Field names may change before
  public release.
- This report does not independently re-download upstream datasets, contact
  authors, or perform a legal review. It specifies the fields and gates needed
  before such a review can support publication.
- Some current manifests contain useful audit extensions that the strict
  manifest model rejects. The release owner must decide whether to version the
  manifest schema, move audit fields elsewhere, or keep using a projection for
  availability reports.
- Hugging Face availability, gated status, and repository revisions were not
  exhaustively probed for every repo in this audit. The monthly workflow must
  perform exact repo/revision checks.
- Public readers can misread prospect counts as benchmark coverage. The report
  UI should visually separate runnable rows from discovery-only rows.

## Explicit Non-Claims

- This audit does not approve any dataset license or grant redistribution
  permission.
- This audit does not assert that all current manifests are publication-ready.
- This audit does not assert that BSEBench monthly snapshots are ready for
  public release.
- This audit does not rank methods, compare external results, or make any SOTA,
  novelty, leaderboard, breakthrough, or verified-claim statement.
- This audit does not update thesis files, manuscript files, claim registries,
  `claims/registry.yaml`, `claim_55`, or the scientific roadmap.
