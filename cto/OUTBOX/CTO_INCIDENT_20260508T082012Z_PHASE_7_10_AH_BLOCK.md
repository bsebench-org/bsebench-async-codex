# CTO Incident - phase-7-10-ah null-control block

Saved: 2026-05-08T08:28:57Z. Role: codex-cto-block-remediation-FR.

## Classification

Stale-after-fix infra/provenance block. The null-control audit itself replays as
mechanical evidence only and does not issue a scientific claim verdict.

## Root Cause

The chef blocked `phase-7-10-ah-stats-hinf-null-control-audit` because the async
handoff state was internally inconsistent and not durable enough for automatic
merge:

- `inbox/phase-7-10-ah-stats-hinf-null-control-audit/STATUS.json` recorded
  `status=error` with `exit_code=0`.
- `outbox/phase-7-10-ah-stats-hinf-null-control-audit/SUMMARY.md` reported a
  successful push and green worker-side validation for commit `6918416`.
- Chef V1 treats `status=error` as authoritative and therefore did not check out
  or re-verify the target stats branch.
- The branch was stale relative to `bsebench-stats/origin/main`.
- The real audit JSON was first reported only as
  `/tmp/hinf_null_control_audit_5x5.json`, so the advisor correctly identified a
  durable handoff gap.

This was an orchestration and provenance failure, not evidence that the
null-control statistic was scientifically invalid.

## Blast Radius

- `chef-daemon.sh` paused while `outbox/_blocks/phase-7-10-ah-stats-hinf-null-control-audit.block`
  existed.
- Normal scientific queueing was paused by the pacer while blocks were present.
- The blocked worker branch remained stale even after equivalent content was
  integrated to stats main.
- No thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or
  roadmap files were edited by this remediation.

## Current Evidence

- Block file read:
  `outbox/_blocks/phase-7-10-ah-stats-hinf-null-control-audit.block`.
- Chef verdict read:
  `outbox/phase-7-10-ah-stats-hinf-null-control-audit/CHEF_VERDICT.md`.
- Panel and advisor checks read:
  `outbox/phase-7-10-ah-stats-hinf-null-control-audit/PANEL_CHECK.md` and
  `outbox/phase-7-10-ah-stats-hinf-null-control-audit/ADVISOR_CHECK.md`.
- Latest daemon evidence read:
  `/home/oakir/.async-worker.log`, `/home/oakir/.async-worker-2.log`,
  `/home/oakir/.async-chef.log`, and
  `/home/oakir/.local/state/bsebench-async-watchdog/pacer.log`.
- `bsebench-stats/origin/main` now contains
  `f6d383ec33c62239fc25a7ba4cc22d883ee4139c`
  (`GLASSBOX [role: codex-stats-engineer] Add Hinf null-control audit`).
- The original blocked stats branch is still non-linear relative to current
  `origin/main`, but its null-control code is present on `origin/main`.
- Focused replay from
  `/mnt/c/doctorat/bsebench-org/bsebench-stats-integrate-phase7-ah-null-control-20260508T1030`
  passed: `uv run --locked --all-extras pytest tests/test_hinf_null_control.py -q`
  -> `4 passed`.
- The CLI replay wrote
  `/tmp/hinf_null_control_audit_5x5_rerun_20260508T082012Z.json`, byte-identical
  to the original `/tmp/hinf_null_control_audit_5x5.json`.
- The durable async handoff artifact is now
  `outbox/phase-7-10-ah-stats-hinf-null-control-audit/hinf_null_control_audit_5x5.json`
  with SHA256
  `3a189a936c29451bb086046c31e326990fa892b92c5f3361abe7c3f0150b7c01`.
- The source runner evidence hash recorded by the report is
  `35c255c696fd9b63552c2206d08009aea834c17f3f09e2bd49b7ac5666917f78`.

## Recovery Gate

The block may be cleared only when all of the following hold:

1. The null-control code is present on `bsebench-stats/origin/main` at or after
   commit `f6d383ec33c62239fc25a7ba4cc22d883ee4139c`.
2. The focused null-control test passes from that integrated stats worktree.
3. A rerun of `scripts/hinf_null_control_audit.py` produces a deterministic JSON
   artifact whose SHA256 is
   `3a189a936c29451bb086046c31e326990fa892b92c5f3361abe7c3f0150b7c01`.
4. The durable report is committed under the blocked phase outbox.
5. `outbox/phase-7-10-ah-stats-hinf-null-control-audit/CTO_UNBLOCK.md` records
   the stale-after-fix rationale before deleting the block file.

Those gates are satisfied in this remediation branch. The unblock does not
assert SOTA, novelty, breakthrough, verified-claim status, or claim registry
readiness.

## Validation

- `find outbox/_blocks -maxdepth 1 -type f -name '*.block' -print` exited 0
  with no output after this branch removed the resolved AH block.
- `pgrep -af 'worker-daemon|chef-daemon|cto-daemon|codex exec|/usr/bin/codex|@openai/codex'`
  exited 0 and showed live async capacity: two worker daemons
  (`1260092`, `1260093`), one CTO daemon (`1260094`), one chef daemon
  (`1260095`), this remediation Codex exec (`1313276`, `1313277`, `1313284`),
  and other active Codex exec workers in runner/specs/datasets worktrees.
- `bash scripts/check-research-brief-gates.sh --dry-run inbox/phase-7-10-y-block-remediation-20260508T082012Z/BRIEF.md`
  exited 0: `Research BRIEF gate checks passed: 1 checked, 0 skipped.`
- `bash -n scripts/cto-autonomy-pacer.sh scripts/remote-worker.sh scripts/chef-daemon.sh scripts/cto-watchdog-10min.sh`
  exited 0 with no output.
- `git diff --check` exited 0 with no output.
