# Kaizen retro for phase-7-8-h-datasets-auditj-local-cache-manifest

[role: kaizen-FR]
Decision audited : needs_fix
Generated at : 2026-05-07T07:04:34Z

## KEEP
- Local-only probe behavior was clear: missing cache roots became explicit gaps and no thesis/claim files were touched.

## FIX
- Worker validation missed formatter drift; chef rejected the branch only because `src/bsebench_datasets/auditj_local_cache_manifest.py` would be reformatted.

## SHIP-ONE
- `inbox/phase-7-8-h-datasets-auditj-local-cache-manifest/BRIEF.md`: add validation bullet `uv run ruff format --check .` before `uv run ruff check .`, so worker gates match chef’s formatting gate.
