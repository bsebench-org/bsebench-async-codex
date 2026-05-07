# Kaizen retro for phase-7-10-m-datasets-phase11-provenance-inventory

[role: kaizen-FR]
Decision audited : approved
Generated at : 2026-05-07T18:36:14Z

## KEEP
- Worker SUMMARY and chef verdict both preserved full gate evidence plus changed-file scope, making the approval easy to audit.

## FIX
- Local inventory found no loader-facing Tier 2 cache roots, so the run validated missing/not-applicable paths more than ready real-cache paths.

## SHIP-ONE
- `inbox/BRIEF_TEMPLATE.md`: add one checklist bullet requiring workers to paste a compact `phase11_inventory` status-count summary from the read-only command, so chef can audit ready/missing/unreadable coverage without reading a temp JSON.
