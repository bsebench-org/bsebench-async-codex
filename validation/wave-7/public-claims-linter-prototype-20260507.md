# Public Claims Linter Prototype - 2026-05-07

GLASSBOX metadata:

- Worker: W7-b
- Branch: phase-8-6-b-public-claims-linter-prototype-20260507T214305Z
- Owned write-set: `scripts/check-public-claims-language.sh`, `tests/fixtures/public-claims-linter/`, `validation/wave-7/public-claims-linter-prototype-20260507.md`
- Active lane: guardrail prototype
- Purpose: conservative public-report wording gate for unsupported benchmark, leaderboard, SOTA, novelty, superiority, and verification language.

Evidence inspected:

- `docs/RESEARCH-GATE-PROTOCOL-2026-05-07.md` defines the required separation between evidence generation, SOTA comparison, and claim registration.
- The protocol requires a source ledger before SOTA, novelty, leaderboard, or better-than-prior-work language.
- The protocol allows candidate, mechanical-only, replay, provenance, comparability, blocker, and missing-evidence wording before claim registration.

Prototype behavior:

- The checker is line-oriented and reports file, line, label, and text for every finding.
- Unsupported strong wording fails when it appears without same-line guardrail context.
- Guardrail contexts pass when the same line frames the wording as unsupported, prohibited, candidate-only, blocked by missing evidence, or tied to source-ledger, comparability, replay, provenance, or falsification requirements.
- Negative fixtures are excluded from default staged/all scans unless passed explicitly, so the repository can retain failing examples.

Fixture expectations:

- `pass-guardrails.md` should pass because risky terms are framed as guardrails.
- `pass-neutral-report.md` should pass because it uses neutral report wording.
- `fail-unsupported-claims.md` should fail because it asserts unsupported SOTA, leaderboard, superiority, verification, universal benchmark proof, and breakthrough wording.

Validation results:

- `bash -n scripts/check-public-claims-language.sh`: pass.
- `scripts/check-public-claims-language.sh tests/fixtures/public-claims-linter/pass-guardrails.md tests/fixtures/public-claims-linter/pass-neutral-report.md`: pass, two fixtures checked.
- `scripts/check-public-claims-language.sh tests/fixtures/public-claims-linter/fail-unsupported-claims.md`: expected fail, three findings reported.
- `scripts/check-public-claims-language.sh --staged`: pass, negative fixture skipped by default and positive fixtures plus this validation note checked.
- `git diff --check`: pass.
- `git diff --check --cached`: pass.

Blockers:

- This is a wording prototype only. It does not inspect claim registries, thesis files, external papers, or scientific evidence artifacts.
- Same-line guardrail detection is conservative and may require public-report authors to place source-ledger or blocker context on the same line as risky wording.
