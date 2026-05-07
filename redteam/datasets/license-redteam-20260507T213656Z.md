# Dataset License Red-Team - Monthly Public Snapshots

GLASSBOX metadata:
- role: W6-08 red-team worker
- created_at: 2026-05-07T21:36:56Z
- branch: phase-8-5-h-dataset-license-redteam-20260507T213656Z
- owned_path: redteam/datasets/license-redteam-20260507T213656Z.md
- report_repo_head_observed: 357e990ffd23c3d41581117bb02bf7368816ddcd
- datasets_repo_head_observed: 2b97c256c86128bc057ec394a40610a086a7d665
- scope: dataset licensing, redistribution, and public-availability risks for monthly public snapshots
- non_scope: no legal conclusion, no claim-registry edits, no thesis/manuscript edits, no benchmark/SOTA claims

## Executive Decision

Monthly public snapshots should be blocked unless the release candidate can prove
all included data files are both redistributable and anonymously retrievable.
The current repo state is not ready for a blanket "public dataset snapshot"
statement.

The safe release stance is:

1. Publish code and metadata only when the data payload is not license-cleared.
2. Include data files only when a strict manifest, source license, attribution,
   SHA-256 inventory, and anonymous download check all pass.
3. Treat loader-facing Hugging Face mirrors that return HTTP 401 to anonymous
   users as non-public, even if the source license would otherwise allow reuse.

## Evidence Inspected

Local artifacts:
- `bsebench-datasets/README.md`
- `bsebench-datasets/CITATION.cff`
- `bsebench-datasets/manifests/*.yaml`
- `bsebench-datasets/catalog/dataset_prospects.yaml`
- `bsebench-datasets/src/bsebench_datasets/manifest.py`
- `bsebench-datasets/src/bsebench_datasets/auditj_local_cache_manifest.py`
- `bsebench-datasets/src/bsebench_datasets/hinf_loader_provenance.py`
- `outbox/phase-7-8-c-datasets-hinf-loader-provenance-audit/SUMMARY.md`
- `outbox/phase-7-10-i-datasets-phase8-cache-probe/SUMMARY.md`
- `outbox/phase-7-10-m-datasets-phase11-provenance-inventory/SUMMARY.md`

External source checks, retrieved 2026-05-07:
- CALCE Battery Data: https://calce.umd.edu/battery-data
- NASA PCoE repository: https://www.nasa.gov/intelligent-systems-division/discovery-and-systems-health/pcoe/pcoe-data-set-repository/
- NASA Open Data Portal: https://data.nasa.gov/
- Panasonic Kollmeyer Mendeley record: https://data.mendeley.com/datasets/wykht8y7tg/1
- Empa Aurora Zenodo record: https://zenodo.org/records/15481956
- Oxford ORA record: https://ora.ox.ac.uk/objects/uuid:03ba4b01-cfed-46d3-9b1a-7d4a7bdf6fac

## Positive Controls

The current manifest model has useful controls:
- `DatasetManifest` requires `license`, `redistribution_allowed`, source
  provenance, at least one file, and SHA-256 per file.
- `manifests/README.md` says manifests are strict live-data records only after
  raw mirrors exist and checksums are known.
- The broad `catalog/dataset_prospects.yaml` explicitly says records with
  `redistribution=unknown` or blocked status must not be mirrored.
- Phase 7.10.i separated local-cache availability into ready, missing,
  unreadable, and unknown-metadata buckets.
- Phase 7.10.m added a Phase 11 provenance inventory and reported 58 candidate
  configs missing when no loader-facing Tier 2 cache roots were available.
- Phase 7.8.c records NASA PCoE missing runtime `dataset`, `chemistry`, and
  `source_url` as machine-readable gaps rather than fabricated metadata.

These controls are a good base, but they are not sufficient for public monthly
snapshots until the blockers below are closed.

## Publication Blockers

### B1 - CALCE Redistribution Is Not Release-Cleared

Severity: blocking

Observed:
- CALCE pages provide open access and ask users to cite CALCE articles, but the
  pages inspected do not expose a standard redistribution license for BSEBench
  mirrors.
- `catalog/dataset_prospects.yaml` marks `calce_battery_portal` as
  `redistribution: unknown` with a blocker stating that CALCE asks for citation
  but does not expose a standard redistribution license.
- CALCE A123 legacy, CALCE A123 dynamic, and CALCE INR-20R loaders point to
  BSEBench Hugging Face dataset repos, but no CALCE manifest exists under
  `bsebench-datasets/manifests/`.

Risk:
- A public snapshot that includes CALCE-derived Tier 1 or Tier 2 files could
  redistribute data without explicit permission or a standard public license.
- The README currently lists CALCE loaders as shipped and says source data
  retains upstream license recorded in each manifest, but CALCE has no strict
  manifest in the observed `manifests/` directory.

Mitigation:
- Do not include CALCE raw or harmonized files in public snapshots until one of
  these is true:
  - CALCE publishes an explicit redistribution license compatible with public
    mirroring, or
  - BSEBench obtains written redistribution permission and stores it in a source
    ledger, or
  - the snapshot ships only loader code plus instructions that make users fetch
    CALCE files from CALCE directly.
- Add strict CALCE manifests only after license resolution, source SHA-256s, and
  public mirror policy are complete.

### B2 - Hugging Face Mirror Availability Is Not Public

Severity: blocking

Observed anonymous HTTP status checks:

| Hugging Face repo | HTTP |
| --- | ---: |
| bsebench-org/calce-a123-2014 | 401 |
| bsebench-org/calce-a123-2014-dynamic | 401 |
| bsebench-org/calce-inr-20r-2014 | 401 |
| bsebench-org/nasa-pcoe-saha-goebel-2007 | 401 |
| bsebench-org/yao-tu-berlin-2024 | 401 |
| bsebench-org/panasonic-kollmeyer-2018 | 401 |
| bsebench-org/lg-hg2-stroebl-2024 | 401 |
| bsebench-org/batterylife-calb-raw | 401 |
| bsebench-org/batterylife-naion-raw | 401 |
| bsebench-org/bit-aesa-77-cell-degradation-2022-raw | 200 |
| bsebench-org/cnr-eis-degradation-modes-2026-raw | 200 |
| bsebench-org/empa-aurora-2025-raw | 401 |
| bsebench-org/energy-storage-power-station-2026-raw | 200 |
| bsebench-org/lg-hg2-stroebl-2024-raw | 401 |
| bsebench-org/nasa-rw-2014-raw | 401 |
| bsebench-org/oxford-birkl-2017-raw | 401 |
| bsebench-org/seoul-knee-point-2025-raw | 200 |
| bsebench-org/severson-2019-raw | 401 |
| bsebench-org/yao-tu-berlin-2024-raw | 401 |

Risk:
- A monthly public snapshot cannot be reproducible from URLs that require
  credentials or return 401 to anonymous users.
- The current loader defaults call `hf_hub_download`, so anonymous users will
  hit availability failures even when source licenses are permissive.

Mitigation:
- Add a release gate that runs anonymous `curl -I` or HF API checks for every
  `huggingface_tier1_repo`, `huggingface_tier2_repo`, and loader `*_HF_REPO`.
- Either make included repos public before snapshot publication or exclude the
  corresponding data files from the public snapshot manifest.
- Record the exact HTTP status and retrieval timestamp in the monthly release
  ledger.

### B3 - License Metadata Is Split and Internally Ambiguous

Severity: blocking for dataset-inclusive snapshots; non-blocking for code-only snapshots

Observed:
- `README.md` states BSEBench-authored metadata and harmonized packaging are
  CC-BY-4.0, source data retains upstream licenses, and code is BSD-3-Clause.
- `CITATION.cff` records only `license: BSD-3-Clause`.
- The Phase 7.2 Zenodo metadata summary shows earlier churn between BSD-3-Clause
  and CC-BY-4.0 release metadata.

Risk:
- Downstream users could infer one license for all snapshot contents, including
  upstream source data, BSEBench metadata, generated Parquet, and code.
- This is especially risky for ODbL Oxford data and CALCE data without an
  explicit redistribution license.

Mitigation:
- Before any monthly public snapshot, publish a machine-readable release ledger
  with per-file fields:
  - file path
  - sha256
  - artifact class: code, BSEBench metadata, Tier 1 source mirror, Tier 2
    harmonized data, report, or citation-only pointer
  - upstream dataset id
  - upstream license SPDX or exact terms URL
  - BSEBench packaging license
  - redistribution decision
  - attribution text
  - source retrieval date
  - public download URL and anonymous HTTP status
- Keep repo-level `CITATION.cff` as software metadata, and add dataset snapshot
  citation/notice files for data payloads.

### B4 - NASA PCoE 2007 Has Runtime Provenance Gaps

Severity: blocking for claim-bearing public evidence bundles

Observed:
- The NASA PCoE manifest records CC0-style redistribution rationale and
  `huggingface_tier1_repo: null`.
- The strict Hinf provenance audit records NASA runtime gaps for `dataset`,
  `chemistry`, and `source_url`.
- The NASA PCoE loader returns `cell_id` and `test_id`, but not the full runtime
  source identity returned by the other strict loaders.
- The NASA PCoE Hugging Face Tier 2 repo returned HTTP 401 anonymously.

Risk:
- A public monthly snapshot that includes NASA-derived evidence could be hard to
  audit back to the exact source row and license posture.
- Using a Kaggle-cleaned mirror adds a second provenance layer that should be
  separated from NASA's original PCoE publication.

Mitigation:
- Add NASA runtime `dataset`, `chemistry`, `source_url`, and mirror provenance
  fields, or keep NASA evidence marked as incomplete.
- Keep original NASA source, Kaggle-cleaned source, and BSEBench Tier 2 mirror
  as separate ledger rows.
- Require anonymous availability before publishing NASA-derived data files.

### B5 - ODbL Share-Alike/Attribution Must Be Carried Through

Severity: blocking if attribution/notice is absent

Observed:
- `oxford_birkl_2017.yaml` records `license: ODbL-1.0`.
- The Oxford ORA page links the files to Open Data Commons terms.
- ODbL is compatible with public reuse only if notice and share-alike
  obligations are preserved.

Risk:
- A snapshot with Oxford-derived Tier 2 files but no ODbL notice/attribution
  bundle could create avoidable downstream compliance risk.

Mitigation:
- Include an ODbL notice in every dataset-inclusive snapshot that contains
  Oxford-derived files.
- Record whether BSEBench Tier 2 Parquet is treated as a derivative database,
  produced work, or citation-only transformation, and apply the conservative
  attribution/share-alike path unless counsel decides otherwise.

### B6 - Prospect Catalog Contains Many Unknown Redistribution Entries

Severity: blocking for new-data expansion

Observed:
- The prospect catalog has multiple `redistribution: unknown` records, including
  aggregate, Battery Archive, CALCE, additional NASA, institutional pools, and
  validation-dataset watchlists.

Risk:
- A monthly snapshot process that automatically sweeps prospects into public
  mirrors could publish unlicensed or mixed-license data.

Mitigation:
- Keep prospects out of public snapshots unless promoted to strict manifests.
- Enforce CI that refuses any data file whose dataset id appears only in
  `catalog/dataset_prospects.yaml`.

## Snapshot Release Gate

A monthly public snapshot should pass all gates below:

1. `manifest_gate`: every included data file maps to exactly one strict
   `manifests/*.yaml` entry with valid SHA-256 and `redistribution_allowed:
   true`.
2. `license_gate`: every included data file has a source license URL or stored
   permission artifact, a BSEBench packaging license, and attribution text.
3. `calce_gate`: no CALCE data files are included until the CALCE redistribution
   blocker is resolved.
4. `availability_gate`: every public URL in the release ledger returns HTTP 200
   to an anonymous request.
5. `notice_gate`: CC-BY and ODbL attribution/notice text is bundled with the
   snapshot.
6. `runtime_provenance_gate`: every evidence-bearing loader returns dataset,
   chemistry, source URL, and concrete file/cell/test identity.
7. `no_auto_prospect_gate`: catalog prospects with unknown or blocked
   redistribution cannot enter the snapshot.
8. `claim_gate`: snapshot release notes must not make SOTA, novelty,
   leaderboard, breakthrough, or verified-claim statements without a completed
   source ledger and comparability table.

## Validation Performed

Commands and inspections performed:
- `git status -sb` in the owned report worktree: branch observed against
  `origin/main`; no pre-existing local edits in this worktree.
- `sed`/`rg` inspection of local dataset availability and provenance reports.
- `python3` manifest summaries over `bsebench-datasets/manifests/*.yaml`.
- `python3` prospect-catalog scan for `redistribution != allowed`.
- Anonymous `curl` status checks for loader-facing and manifest-declared
  Hugging Face repos.
- Official-source browser checks for CALCE, NASA PCoE/NASA Open Data,
  Panasonic/Mendeley, Empa/Zenodo, and Oxford/ORA.
- `git diff --check`: passed after adding this artifact to the diff.

## Release Recommendation

Do not publish a dataset-inclusive monthly public snapshot from the observed
state. Publish a code/metadata-only alpha snapshot, or a data snapshot limited
to entries that pass strict manifest, license, attribution, and anonymous
availability gates.

The highest-priority fixes are:

1. Resolve or exclude CALCE redistribution.
2. Make the intended public Hugging Face repos anonymously accessible, or remove
   them from the public snapshot ledger.
3. Split code, BSEBench metadata, Tier 1 source, and Tier 2 generated-data
   licenses in the release ledger.
4. Close NASA runtime provenance gaps before claim-bearing public evidence.
