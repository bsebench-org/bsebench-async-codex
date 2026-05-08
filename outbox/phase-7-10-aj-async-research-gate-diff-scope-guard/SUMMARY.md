# Phase phase-7-10-aj-async-research-gate-diff-scope-guard summary

- Worker : france-personal-2
- Codex exit : 0
- Wallclock cap : 75 min
- Target repo : /mnt/c/doctorat/bsebench-org/bsebench-async-codex
- Target branch : phase-7-10-aj-async-research-gate-diff-scope-guard
- Branch SHA : f55ab55cebfbbbd976839713df9505ba2e27969d
- Push result : ok
- Merge readiness : ok
- Merge readiness detail : origin/main is an ancestor of HEAD
- Started : (see STATUS.json ts_started)
- Finished : 2026-05-08T15:02:15+02:00

## Push stderr (if push failed)

(push succeeded — no stderr)

## Tail of codex stdout (last 200 lines)

```
+
+  mkdir -p "$repo/reports"
+  cat > "$repo/reports/comparison.md" <<'COMPARISON'
+SOTA comparison draft: the row below is only comparable under the source ledger.
+COMPARISON
+  cat > "$repo/reports/source-ledger.md" <<'LEDGER'
+| source_id | doi_or_url | retrieved_at | metric | dataset | split | reported_value | bsebench_value | comparability | caveat |
+|---|---|---|---|---|---|---|---|---|---|
+| fixture-paper | https://doi.org/10.1234/example | 2026-05-08 | MAE SOC percent | CALCE A123 | fixed test profile | 1.20 | 1.30 | partial | synthetic fixture, not a real claim |
+LEDGER
+  git -C "$repo" add reports/comparison.md reports/source-ledger.md
+  git -C "$repo" commit -q -m "comparison with ledger"
+  run_git_guard "$repo"
+}
+
+changed_file_list_comparison() {
+  local paths="$tmp_root/paths.txt"
+  printf '%s\n' "reports/sota-comparison.md" > "$paths"
+  bash "$GUARD" --dry-run --paths "$paths" 2>&1
+}
+
+require_success_contains \
+  "allowed validation-only change" \
+  "[ALLOWED] scripts/check-research-diff-scope.sh -- validation-only guardrail tooling or fixture" \
+  allowed_validation_only
+
+require_failure_contains \
+  "protected claims registry path" \
+  "[BLOCKED] claims/registry.yaml -- protected claims/registry.yaml" \
+  protected_registry
+
+require_failure_contains \
+  "protected thesis path" \
+  "[BLOCKED] thesis/chapter1.md -- protected thesis or manuscript prose" \
+  protected_thesis
+
+require_failure_contains \
+  "protected roadmap path" \
+  "[BLOCKED] docs/RESEARCH-ROADMAP-2026-05-06.md -- protected roadmap file" \
+  protected_roadmap
+
+require_failure_contains \
+  "claim_55 targeting" \
+  "[BLOCKED] reports/candidate.md -- added direct claim_55 targeting" \
+  claim55_targeting
+
+require_failure_contains \
+  "unsupported SOTA novelty language" \
+  "[REVIEW_REQUIRED] reports/comparison.md -- comparison language lacks completed source ledger and comparability table" \
+  unsupported_comparison_language
+
+require_success_contains \
+  "source-ledger-present comparison" \
+  "[ALLOWED] reports/comparison.md -- comparison language with completed source ledger in diff" \
+  source_ledger_present_comparison
+
+require_failure_contains \
+  "changed-file list comparison without diff" \
+  "[REVIEW_REQUIRED] reports/sota-comparison.md -- comparison-like path supplied without diff or source ledger evidence" \
+  changed_file_list_comparison
+
+echo "PASS: research diff-scope guard fixtures passed ($passes checks)."

tokens used
159,003
Implemented and pushed `phase-7-10-aj-async-research-gate-diff-scope-guard` at commit `f55ab55`.

Changes:
- Added [scripts/check-research-diff-scope.sh](/mnt/c/doctorat/bsebench-org/bsebench-async-codex-phase-7-10-aj-async-research-gate-diff-scope-guard/scripts/check-research-diff-scope.sh:1), a dry-run guard for git diffs, staged diffs, or changed-file lists.
- Added [scripts/probe-research-diff-scope-guard.sh](/mnt/c/doctorat/bsebench-org/bsebench-async-codex-phase-7-10-aj-async-research-gate-diff-scope-guard/scripts/probe-research-diff-scope-guard.sh:1) with positive and negative fixtures.
- Wired chef validation in [scripts/chef-daemon.sh](/mnt/c/doctorat/bsebench-org/bsebench-async-codex-phase-7-10-aj-async-research-gate-diff-scope-guard/scripts/chef-daemon.sh:201) so protected/review-required diffs become `needs_fix` before merge.

Validation passed:
- `bash scripts/probe-research-diff-scope-guard.sh`: 8 fixture checks passed.
- `bash -n scripts/check-research-diff-scope.sh scripts/probe-research-diff-scope-guard.sh scripts/chef-daemon.sh`
- `bash scripts/check-research-diff-scope.sh --dry-run --base origin/main --head HEAD`: `allowed=3 blocked=0 review_required=0`
- `bash scripts/check-research-brief-gates.sh --dry-run cto/AUTONOMY_BACKLOG/phase-7-*/BRIEF.md`: `28 checked, 0 skipped`
- `git diff --check origin/main...HEAD && git diff --check`

No thesis, claim registry, `claims/registry.yaml`, roadmap, or real `claim_55` files were edited. Commit includes GLASSBOX metadata and no `Co-Authored-By Claude` trailer. Final branch check reported `merge_ready=ok`.
```

## Next step for chef

git fetch origin && git checkout phase-7-10-aj-async-research-gate-diff-scope-guard in target_repo. Verify gates. Merge to main if green.
