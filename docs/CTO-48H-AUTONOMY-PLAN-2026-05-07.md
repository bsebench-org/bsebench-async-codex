# CTO 48h autonomy plan — rigorous non-stop mode

Saved: 2026-05-07 06:05 UTC. Role: codex-cto-FR.

## Direction

The next 48 hours must advance BSEBench research infrastructure toward the active roadmap, not produce filler. Work is allowed only when it maps to one of:

- Phase 7: strict Hinf candidate evidence, without touching `claim_55`.
- Phase 8/11 preparation: sensor floor, PCRLB/MAD, residual decomposition, cross-dataset comparison machinery.
- Validation infrastructure that blocks false scientific claims: manifest replay, provenance, anti-hallucination, SOTA comparison protocol, CI gates.
- Async reliability needed to keep the above running and auditable.

## Non-negotiable gates

- No thesis claim, roadmap, manuscript, or registry edit unless a separate explicit gate authorizes it.
- No SOTA or novelty statement without source ledger entries: DOI or stable URL, retrieval date, exact metric, dataset, split, and comparability caveat.
- No Hinf scientific verdict until evidence, manifest, stats replay, independent validation, and falsification checklist all pass.
- No task without a falsifiable failure condition.
- No commit without GLASSBOX metadata and a clean validation log.
- No `Co-Authored-By Claude`.

## Hourly checkpoint

Every hour, the watchdog records a direction checkpoint. The CTO must use it to ask:

- Are active tasks still mapped to the roadmap or a direct validation gate?
- What could prove the current result wrong?
- Are independent validators checking output, not just style?
- Are we comparing against literature fairly, or inventing a SOTA frame?
- Is any branch drifting into prose, roadmap edits, or claim registry edits?

If a task cannot answer those questions, stop merging it and replace it with a sharper validation task.

## Active lanes

1. Evidence lane: make Hinf candidate artifacts self-reporting, replayable, and CI-gated.
2. Statistics lane: expose machine-readable replay summaries and stability diagnostics.
3. Dataset provenance lane: verify loader/cache provenance for every strict evidence dataset.
4. Research-gate lane: formalize anti-hallucination and SOTA comparison requirements before claims.
5. Ops lane: watchdog every 10 minutes, hourly checkpoint, backlog guard, daemon health.

## Queued work

- `phase-7-8-a-runner-claim63-report-generator`: neutral Hinf candidate report generator, no scientific claim.
- `phase-7-8-b-stats-hinf-replay-summary`: JSON replay summary for automation and independent validators.
- `phase-7-8-c-datasets-hinf-loader-provenance-audit`: loader/cache provenance audit for strict evidence configs.
- `phase-7-8-d-async-research-gate-protocol`: anti-hallucination, SOTA comparison, and claim gating protocol.
- `phase-7-8-e-runner-ci-hinf-audit-step`: explicit CI gate for strict Hinf evidence audits.
- `phase-7-8-f-stats-lock-policy`: decide and enforce stats lockfile/CI reproducibility policy.
- `phase-7-8-g-stats-hinf-weighting-sensitivity`: stress Hinf conclusions against config weighting and NASA sample-count imbalance.
- `phase-7-8-h-datasets-auditj-local-cache-manifest`: read-only local cache manifest for maximum Audit J coverage.

## Red lines

- Do not modify `claim_55`.
- Do not assert Hinf is verified.
- Do not modify `docs/RESEARCH-ROADMAP-2026-05-06.md`.
- Do not edit `/mnt/c/doctorat/these_lfp_2026/claims/registry.yaml` from autonomous tasks.
- Do not use automated work merely to consume tokens.
