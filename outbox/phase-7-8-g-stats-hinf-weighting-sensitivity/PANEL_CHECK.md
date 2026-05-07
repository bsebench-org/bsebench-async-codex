# Panel check for phase-7-8-g-stats-hinf-weighting-sensitivity

[role: panel-FR]
Decision audited : needs_fix
Generated at : 2026-05-07T07:00:52Z

## Panel composition
- Mme Rim Barrak (thesis director, mandatory)
- ML/Stats expert (reasoning : BRIEF requires a stats-owned sensitivity command, synthetic tests, unequal sample-count handling, and real Hinf evidence validation.)
- Adversarial reviewer (reasoning : Complementary red-team stance is needed because this phase stress-tests whether the Hinf interpretation changes under weighting and NASA leave-one-out.)

## Confidence scores (0-100, where 100 = "ship it now, no concerns")
- mme_rim : 82 — Good mechanical-source discipline and claim restraint, but chef found the validation record incomplete/incorrect because formatting enforcement failed.
- expert2 : 86 — The statistical sensitivity design addresses unequal counts and surfaces material risk, but the unformatted runner blocks reproducible gate compliance.
- expert3 : 78 — The work found the right falsification signal, yet a reported-passing gate that fails chef-side undermines forensic confidence.
- **AVERAGE : 82**

## Key concerns (if any)
- Chef-side re-verification found `src/bsebench_stats/runners/hinf_sensitivity.py` would be reformatted, so the submitted branch does not satisfy the enforced hygiene gate.
- Worker summary recorded validation as green while the chef gate later failed; this needs correction with `uv run ruff format --check .` or equivalent recorded before shipping.

## Verdict
NEEDS_REVIEW (avg < 89, escalate to advisor)
