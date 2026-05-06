---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-datasets
target_branch: phase-7-1-bsebench-readme-examples
base_branch: main
hard_wallclock_min: 30
---

# Phase 7.1 — BSEBench README + 3 working examples

## Mission

Préparer le repo `bsebench-datasets` pour public release. Ajouter README user-facing + 3 examples scripts qui montrent comment loader des données via les Tier 2 loaders existants (NASA-2007, Panasonic, LG HG2, Yao, CalceLegacy, CalceA123Dyn).

## Pre-flight

1. Read existing `README.md` at root (probably minimal). Replace with comprehensive user-facing version.
2. Reference style : check existing OSS battery datasets repos (PyBaMM, batteryml) for tone + structure.
3. NO Co-Authored-By Claude. GLASSBOX format.

## Deliverable

### `README.md` (rewrite at repo root)

Sections :
- Title + 1-line tagline
- Why (problem this solves)
- Quick start (3 lines pip install + 5 lines load 1 dataset)
- Supported datasets table (NASA-2007, Panasonic, LG HG2, Yao, CALCE A123 legacy, CALCE A123 dyn, CALCE INR-20R when 6.10.g lands)
- Tier 1 vs Tier 2 architecture (1 paragraph + tiny diagram)
- Conventions (BPX 1.1 sign, schema, cell_id format)
- License (CC-BY-4.0)
- Citation (DOI placeholder for Zenodo when shipped)
- Roadmap (link to bsebench-async-codex docs/RESEARCH-ROADMAP-2026-05-06.md)

### `examples/01_load_nasa_pcoe_2007.py`

Standalone Python script. ~30 LOC. Loads NASA B0005 via Tier 2 loader, prints t/V/I shape + stats.

### `examples/02_load_panasonic_us06.py`

Same pattern, Panasonic US06 T25.

### `examples/03_load_yao_bcdc.py`

Same pattern, Yao BCDC T25.

## Acceptance gates

- G1 : pas de tests changés (pure docs + examples). Existing test suite still passes.
- G2-G3 : ruff format + check on the 3 example files (nicht sur README.md).
- G4 : git status clean, scope = 4 files (README + 3 examples).
- G5 : 1-2 commits, GLASSBOX format.
- G6 : NO Co-Authored-By Claude.

## Cross-refs

- bsebench-async-codex docs/RESEARCH-ROADMAP-2026-05-06.md (link from README)
- All Tier 2 loaders shipped on main
