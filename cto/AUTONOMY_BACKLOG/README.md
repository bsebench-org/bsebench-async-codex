# CTO autonomy backlog

This directory stores curated, not-yet-queued BRIEFs for the autonomy pacer.

Rules:

- keep at least six unqueued `phase-7-*`, `phase-8-*`, or `phase-11-*` BRIEFs here;
- every BRIEF must pass `scripts/check-research-brief-gates.sh`;
- verify the pacer-visible reserve with `bash scripts/check-autonomy-brief-reserve.sh --dry-run`;
- tasks must be useful validation, evidence, provenance, SOTA-safety, or async reliability work;
- no thesis, claim registry, roadmap, `claims/registry.yaml`, or `claim_55` edits are authorized here;
- no SOTA or novelty claims without a source ledger, stable URL or DOI, retrieval date, metric, dataset, split, and comparability caveat.
