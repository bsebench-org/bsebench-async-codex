# Phase phase-7-9-d-async-worker-format-gate summary

- Worker : france-personal
- Codex exit : 0
- Wallclock cap : 60 min
- Target repo : /mnt/c/doctorat/bsebench-org/bsebench-async-codex
- Target branch : phase-7-9-d-async-worker-format-gate
- Branch SHA : 8574b3eb50db9164442409533d81ecba82c3c7df
- Push result : ok
- Started : (see STATUS.json ts_started)
- Finished : 2026-05-07T11:04:47+02:00

## Push stderr (if push failed)

(push succeeded — no stderr)

## Tail of codex stdout (last 200 lines)

```
+
+  jq --arg w "$WORKER_ID" \
+     '.status="error"|.ts_done=(now|todate)|.exit_code=-4|.worker_id=$w|.error_at_line="static BRIEF gate check failed"' \
+     "$status_file" > "$status_file.tmp"
+  mv "$status_file.tmp" "$status_file"
+  git add "$status_file" "outbox/$queued_phase/"
+  git commit -m "chore(async): reject invalid BRIEF $queued_phase
+
+[role: worker-FR]
+
+## Context
+Worker picked up a queued Phase 7/8/11 BRIEF before launching codex exec.
+
+## Objective
+Reject BRIEFs whose validation wording would let formatter drift reach chef.
+
+## Problem
+The static BRIEF checker failed before codex exec. No target repo worktree was mutated.
+
+## Result
+- exit_code=-4 records a pre-dispatch BRIEF gate failure.
+- SUMMARY.md records the checker output and ruff format-gate audit.
+
+Verified-By: scripts/check-research-brief-gates.sh --dry-run inbox/$queued_phase/BRIEF.md" --quiet
+  push_async_main_with_rebase "BRIEF gate failure for $queued_phase" || true
+  exit 0
+fi
+
 # ------------------------------------------------------------------ mark running
 jq --arg w "$WORKER_ID" --arg tr "$target_repo" --arg tb "$target_branch" --arg bb "$base_branch" \
    '.status="running"|.ts_started=(now|todate)|.worker_id=$w|.target_repo=$tr|.target_branch=$tb|.base_branch=$bb' \
@@ -295,6 +386,16 @@
 
 $([ "$push_result" = "push-failed" ] && echo -e "\`\`\`\n${push_stderr:-(no stderr captured)}\n\`\`\`" || echo "(push succeeded — no stderr)")
 
+## BRIEF gate audit
+
+- Static checker : passed (exit $brief_gate_check_exit)
+- Ruff check requested : $brief_ruff_check_gate
+- Ruff format --check requested : $brief_ruff_format_check_gate
+
+\`\`\`
+$brief_gate_check_output
+\`\`\`
+
 ## Tail of codex stdout (last $LOG_TAIL_LINES lines)
 
 \`\`\`
diff --git a/templates/freelance-dev-template.md b/templates/freelance-dev-template.md
index f9551b2f25ac2f1a816166108a51aa33afbba1e7..dced5c1511354f1385e705ba7b2ad7e47f06d938
--- a/templates/freelance-dev-template.md
+++ b/templates/freelance-dev-template.md
@@ -60,6 +60,9 @@
 ## Verification commands
 ```bash
 # what the dev should run before declaring done
+# Python repos using ruff must include both formatter and lint gates:
+# uv run ruff format --check .
+# uv run ruff check .
 <command 1>
 <command 2>
 ```

tokens used
203,168
Implemented and committed `8574b3e fix(async): enforce ruff format BRIEF gate`.

Changed:
- `scripts/check-research-brief-gates.sh` now flags Phase 7/8/11 BRIEFs that include `ruff check` but omit `ruff format --check`.
- `scripts/remote-worker.sh` runs the static checker before `codex exec`, rejects invalid BRIEFs without mutating target repos, and records ruff gate parity in `SUMMARY.md`.
- Updated README/protocol/chef/template docs to make the formatter gate part of the worker contract.

Validation run:
- `bash -n scripts/check-research-brief-gates.sh scripts/remote-worker.sh`
- checker dry-run on current BRIEF passed
- temporary Phase 7.8 positive probe with formatter gate passed
- temporary Phase 7.8 negative probe failed on the new ruff format parity rule
- `git diff --check`

No roadmap, thesis, or claim registry files were edited. Branch is rebased on current `origin/main` and clean, ahead by this commit.
```

## Next step for chef

git fetch origin && git checkout phase-7-9-d-async-worker-format-gate in target_repo. Verify gates. Merge to main if green.
