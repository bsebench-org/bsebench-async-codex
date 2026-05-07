# Phase phase-7-10-n-async-brief-reserve-integrity-gate summary

- Worker : france-personal
- Codex exit : 0
- Wallclock cap : 60 min
- Target repo : /mnt/c/doctorat/bsebench-org/bsebench-async-codex
- Target branch : phase-7-10-n-async-brief-reserve-integrity-gate
- Branch SHA : 9eb191ae0b69f60761c3bd15f9edb0e3c8efa226
- Push result : ok
- Started : (see STATUS.json ts_started)
- Finished : 2026-05-07T20:39:58+02:00

## Push stderr (if push failed)

(push succeeded — no stderr)

## Tail of codex stdout (last 200 lines)

```
+  git -C "$FIX_TARGET" add README.md
+  git -C "$FIX_TARGET" commit -qm "initial target fixture"
+
   git -C "$FIX_ASYNC" init -q
   git -C "$FIX_ASYNC" config user.email "pacer-probe@example.invalid"
   git -C "$FIX_ASYNC" config user.name "Pacer Probe"
@@ -190,6 +204,12 @@
     bash "$FIX_ASYNC/scripts/cto-autonomy-pacer.sh" --dry-run 2>&1
 }
 
+run_reserve_check() {
+  local min_reserve="${1:-3}"
+
+  bash "$FIX_ASYNC/scripts/check-autonomy-brief-reserve.sh" --dry-run --min "$min_reserve" 2>&1
+}
+
 section "reserve keeps one waiting task"
 make_fixture "reserve-waiting"
 write_running_status "phase-7-probe-running-a"
@@ -231,13 +251,37 @@
 write_good_brief "phase-7-probe-good-c"
 write_good_brief "phase-7-probe-good-d"
 commit_fixture "bad brief scenario"
+bad_check="$(run_reserve_check 3)"
+printf '%s\n' "$bad_check"
+assert_contains "$bad_check" "reason=malformed phase_id=phase-7-probe-bad-a research_gate_failed=" "bad brief reserve reason"
+assert_contains "$bad_check" "[SUMMARY] queueable=3 min=3" "bad brief reserve count"
 bad_output="$(run_pacer)"
 printf '%s\n' "$bad_output"
-assert_contains "$bad_output" "SKIP research gate failed: phase-7-probe-bad-a" "bad brief gate"
 assert_not_contains "$bad_output" "QUEUE reserve task: phase-7-probe-bad-a" "bad brief queue"
 assert_not_contains "$bad_output" "phase-6-probe-unsafe" "non-research phase candidate"
 assert_contains "$bad_output" "QUEUE reserve task: phase-7-probe-good-b" "good fallback queue"
 assert_contains "$bad_output" "DRY-RUN would commit queued=phase-7-probe-good-b" "bad brief dry run"
 assert_clean_repo
 
+section "branch-claimed brief is skipped before queueing"
+make_fixture "branch-claimed"
+write_running_status "phase-7-probe-running-a"
+write_running_status "phase-7-probe-running-b"
+write_good_brief "phase-7-probe-claimed-a"
+write_good_brief "phase-7-probe-good-b"
+write_good_brief "phase-7-probe-good-c"
+write_good_brief "phase-7-probe-good-d"
+git -C "$FIX_TARGET" branch "phase-7-probe-claimed-a"
+commit_fixture "branch claimed scenario"
+branch_check="$(run_reserve_check 3)"
+printf '%s\n' "$branch_check"
+assert_contains "$branch_check" "reason=branch-claimed phase_id=phase-7-probe-claimed-a" "branch-claimed reserve reason"
+assert_contains "$branch_check" "[SUMMARY] queueable=3 min=3" "branch-claimed reserve count"
+branch_output="$(run_pacer)"
+printf '%s\n' "$branch_output"
+assert_not_contains "$branch_output" "QUEUE reserve task: phase-7-probe-claimed-a" "branch-claimed queue"
+assert_contains "$branch_output" "QUEUE reserve task: phase-7-probe-good-b" "branch-claimed fallback queue"
+assert_contains "$branch_output" "DRY-RUN would commit queued=phase-7-probe-good-b" "branch-claimed dry run"
+assert_clean_repo
+
 printf '\nPASS: autonomy pacer dry-run safety probes passed.\n'

tokens used
126,200
Implemented and committed the reserve integrity gate.

Commit: `9eb191a chore(async): gate autonomy reserve integrity`

Changed:
- Added [check-autonomy-brief-reserve.sh](/mnt/c/doctorat/bsebench-org/bsebench-async-codex-phase-7-10-n-async-brief-reserve-integrity-gate/scripts/check-autonomy-brief-reserve.sh)
- Wired pacer reserve count/listing through that checker in [cto-autonomy-pacer.sh](/mnt/c/doctorat/bsebench-org/bsebench-async-codex-phase-7-10-n-async-brief-reserve-integrity-gate/scripts/cto-autonomy-pacer.sh)
- Extended malformed and branch-claimed negative probes in [probe-autonomy-pacer-safety.sh](/mnt/c/doctorat/bsebench-org/bsebench-async-codex-phase-7-10-n-async-brief-reserve-integrity-gate/scripts/probe-autonomy-pacer-safety.sh)
- Documented the dry-run reserve probe in [README.md](/mnt/c/doctorat/bsebench-org/bsebench-async-codex-phase-7-10-n-async-brief-reserve-integrity-gate/cto/AUTONOMY_BACKLOG/README.md)

Validation run:
- `bash -n scripts/cto-autonomy-pacer.sh scripts/check-research-brief-gates.sh` passed
- Reserve report: `queueable=1`, `queued=8`, `branch_claimed=7`, `malformed=0`
- Default reserve gate fails as intended: `queueable=1 below minimum=6`
- `bash scripts/probe-autonomy-pacer-safety.sh` passed
- Research BRIEF gates passed: `16 checked, 0 skipped`
- `git diff --check` and staged diff check passed

No protected thesis, claim registry, `claim_55`, or roadmap files were edited. Worktree is clean; branch is ahead by 1 commit and behind `origin/main` by 8.
```

## Next step for chef

git fetch origin && git checkout phase-7-10-n-async-brief-reserve-integrity-gate in target_repo. Verify gates. Merge to main if green.
