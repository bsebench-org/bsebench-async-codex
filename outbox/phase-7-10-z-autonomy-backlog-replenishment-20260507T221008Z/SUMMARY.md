# Phase phase-7-10-z-autonomy-backlog-replenishment-20260507T221008Z summary

- Worker : france-personal
- Codex exit : 0
- Wallclock cap : 60 min
- Target repo : /mnt/c/doctorat/bsebench-org/bsebench-async-codex
- Target branch : phase-7-10-z-autonomy-backlog-replenishment-20260507T221008Z
- Branch SHA : e0a2532ababdad5d090912b4928314ec78492dee
- Push result : ok
- Started : (see STATUS.json ts_started)
- Finished : 2026-05-08T00:16:19+02:00

## Push stderr (if push failed)

(push succeeded — no stderr)

## Tail of codex stdout (last 200 lines)

```
index 0000000000000000000000000000000000000000..258e3b6d507c7712762fe9404df32151de7022d3
--- /dev/null
+++ b/cto/AUTONOMY_BACKLOG/phase-7-10-v-async-sota-ledger-url-hygiene-linter/BRIEF.md
@@ -0,0 +1,50 @@
+---
+target_repo: /mnt/c/doctorat/bsebench-org/bsebench-async-codex
+target_branch: phase-7-10-v-async-sota-ledger-url-hygiene-linter
+base_branch: main
+add_dir:
+  - /mnt/c/doctorat/bsebench-org/bsebench-runner
+  - /mnt/c/doctorat/bsebench-org/bsebench-stats
+  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
+hard_wallclock_min: 60
+---
+
+# Phase 7.10.v - async SOTA ledger URL hygiene linter
+
+You are a rigorous anti-hallucination and comparison-protocol engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.
+
+## Goal
+
+Add a source-ledger hygiene linter that makes future SOTA or novelty comparison tasks fail when source identity, retrieval date, metric, dataset, split, frozen BSEBench value, or comparability caveat is missing.
+
+## Roadmap mapping
+
+- Active lane: SOTA comparison validation.
+- Supports Phase 7/8/11 fair-comparison gates before any claim registration.
+- Produces ledger validation tooling and synthetic fixtures only; it does not change the scientific roadmap.
+
+## Required behavior
+
+- Review the research gate protocol and any existing source-ledger schema, examples, or fixtures in async.
+- Add a linter, schema check, or shell/Python probe that accepts explicit ledger files and reports row-level failures.
+- Required row fields must include stable URL or DOI, retrieval date, metric, dataset, split, method, reported value, frozen BSEBench value, comparability status, and comparability caveat.
+- Include synthetic fixtures for comparable, partial, not-comparable, missing URL/DOI, missing retrieval date, missing metric, missing split, missing frozen value, and missing caveat.
+- Do not invent real literature numbers; use synthetic fixtures unless a vetted source ledger with stable URL or DOI and retrieval date already exists.
+- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or the roadmap.
+- Do not target `claim_55`; `claim_55` is protected and unrelated to this source-ledger hygiene linter.
+- Do not make SOTA, novelty, leaderboard, breakthrough, verified-claim, or claim-promotion statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.
+
+## Falsification gate
+
+The task must fail if any SOTA or novelty comparison row can pass with a missing stable URL or DOI, retrieval date, metric, dataset, split, frozen BSEBench value, or comparability caveat.
+
+## Validation
+
+Run and record:
+
+- positive and negative fixture checks for comparable, partial, not-comparable, and each missing-required-field row;
+- `bash -n` for changed shell scripts;
+- `bash scripts/check-research-brief-gates.sh --dry-run cto/AUTONOMY_BACKLOG/phase-7-*/BRIEF.md`;
+- `git diff --check`.
+
+Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.

tokens used
73,956
Implemented and committed the backlog replenishment.

Commit: `e0a2532`  
Subject: `GLASSBOX [role: codex-cto-ops] Replenish autonomy backlog reserve`

Added six new unqueued BRIEFs:

- `phase-7-10-q-runner-hinf-artifact-replay-negative-fixtures`
- `phase-7-10-r-stats-hinf-perturbation-fragility-index`
- `phase-7-10-s-datasets-provenance-hash-replay-fixtures`
- `phase-7-10-t-async-forbidden-scope-diff-gate`
- `phase-7-10-u-runner-phase11-residual-contract-preflight`
- `phase-7-10-v-async-sota-ledger-url-hygiene-linter`

Validation recorded:

- `check-research-brief-gates`: passed, `22 checked, 0 skipped`
- `bash -n scripts/cto-autonomy-pacer.sh scripts/check-research-brief-gates.sh`: passed
- `git diff --check`: passed
- `git diff --cached --check`: passed
- reserve count: `UNQUEUED_BRIEF_COUNT=13`

No thesis files, claim registry files, roadmap file, or `claim_55` target were edited. Branch is clean and ahead by one commit.
```

## Next step for chef

git fetch origin && git checkout phase-7-10-z-autonomy-backlog-replenishment-20260507T221008Z in target_repo. Verify gates. Merge to main if green.
