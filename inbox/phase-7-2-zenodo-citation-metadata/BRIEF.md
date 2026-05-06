---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-datasets
target_branch: phase-7-2-zenodo-citation-metadata
base_branch: main
hard_wallclock_min: 20
---

# Phase 7.2 — Zenodo metadata + CITATION.cff

## Mission

Préparer le repo `bsebench-datasets` pour Zenodo DOI registration. Ajouter `.zenodo.json` (metadata Zenodo) et `CITATION.cff` (GitHub citation widget). Pas de submission, juste les fichiers.

## Pre-flight

1. Check existing CITATION.cff (probably exists per Phase 6.5 init). Update if so.
2. Reference : Zenodo metadata schema https://developers.zenodo.org/#representation
3. NO Co-Authored-By Claude. GLASSBOX.

## Deliverable

### `.zenodo.json`

```json
{
  "title": "BSEBench : reproducible battery state estimation benchmark",
  "description": "Public benchmark for ECM-based battery state estimation filters across 6+ datasets...",
  "creators": [{"name": "Akir, Oussama", "affiliation": "Sup'Com Tunisia / GRESCOM Lab", "orcid": ""}],
  "keywords": ["battery", "state estimation", "ECM", "Joint UKF", "benchmark", "reproducibility"],
  "license": "CC-BY-4.0",
  "upload_type": "software",
  "version": "1.0.0",
  "publication_date": ""
}
```

### `CITATION.cff` (rewrite or update)

CFF v1.2.0 format. Title, authors, year, version, repo URL, license, abstract.

## Acceptance gates

- G1 : pas de tests changés (pure metadata files)
- G2 : (no ruff on JSON)
- G3 : `python -c "import yaml ; yaml.safe_load(open('CITATION.cff'))"` validates
- G4 : git status clean, scope ≤ 2 files
- G5-G6 : GLASSBOX, no Claude trailer

## Cross-refs

- 7.1 README (link to Zenodo DOI placeholder)
