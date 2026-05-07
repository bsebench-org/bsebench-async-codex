# Unsupported Claim Language Audit - Phase 8

Generated: 2026-05-07T22:54:39+02:00
Worker: W4-10
Branch: `phase-8-3-j-unsupported-claim-language-audit-20260507T204627Z`
Owned write set: `audits/guardrails/unsupported-claim-language-audit-20260507T204627Z.md`

## Objective

Audit Phase 8 watchdog logs and local Phase 8 worktree diffs for unsupported
SOTA, leaderboard, verified-claim, breakthrough, novelty, or equivalent public
comparison language. The audit is a guardrail artifact: it records evidence and
merge recommendations, not scientific results.

## Evidence Inspected

- Watchdog log root:
  `/home/oakir/.local/state/bsebench-async-watchdog`.
- Verified baseline Wave 1-3 manual Phase 8 logs:
  48 logs under `manual-phase-8-[012]-*.log`.
- Verified original usage-limit logs:
  `manual-phase-8-2-j-reproducibility-artifact-manifest-audit-20260507T193528Z.log`,
  `manual-phase-8-2-k-merge-queue-runbook-20260507T193528Z.log`, and
  `manual-phase-8-2-l-worker-triage-and-relaunch-runbook-20260507T193528Z.log`.
- Local Phase 8 Wave 1-3 worktrees under `/mnt/c/doctorat/bsebench-org`:
  48 worktrees inspected, 45 with committed diffs against `origin/main`, 3 with
  zero changed files matching the usage-limit logs above.
- Current Wave 4 context at this timestamp: 73 total `manual-phase-8-*.log`
  files were present, including 25 Wave 4 logs. Wave 4 was still volatile:
  24 Wave 4 logs already contained usage-limit text, so Wave 4 logs were treated
  as context, not as completed baseline evidence.
- Source-ledger policy source:
  `audits/universal/source-ledger-audit-20260507T193050Z.md` from
  `phase-8-1-q-anti-hallucination-source-ledger-audit-20260507T193050Z`.

## Commands

```bash
date -Iseconds
find /home/oakir/.local/state/bsebench-async-watchdog -maxdepth 1 -type f \
  \( -name 'manual-phase-8-0-*.log' -o -name 'manual-phase-8-1-*.log' -o -name 'manual-phase-8-2-*.log' \) | wc -l
rg -l "You've hit your usage limit" \
  /home/oakir/.local/state/bsebench-async-watchdog/manual-phase-8-[012]-*.log
find /home/oakir/.local/state/bsebench-async-watchdog -maxdepth 1 -type f \
  -name 'manual-phase-8-*.log' | wc -l
find /home/oakir/.local/state/bsebench-async-watchdog -maxdepth 1 -type f \
  -name 'manual-phase-8-3-*.log' | wc -l
rg -l "You've hit your usage limit" \
  /home/oakir/.local/state/bsebench-async-watchdog/manual-phase-8-3-*.log | wc -l
```

```bash
for d in /mnt/c/doctorat/bsebench-org/bsebench-*-phase-8-[012]-*; do
  [ -e "$d/.git" ] || [ -f "$d/.git" ] || continue
  base=$(git -C "$d" merge-base HEAD origin/main 2>/dev/null || git -C "$d" rev-parse HEAD^ 2>/dev/null || true)
  git -C "$d" diff --name-only "$base"..HEAD 2>/dev/null
done
```

```bash
for d in /mnt/c/doctorat/bsebench-org/bsebench-*-phase-8-[012]-*; do
  [ -e "$d/.git" ] || [ -f "$d/.git" ] || continue
  b=$(git -C "$d" branch --show-current 2>/dev/null || true)
  base=$(git -C "$d" merge-base HEAD origin/main 2>/dev/null || git -C "$d" rev-parse HEAD^ 2>/dev/null || true)
  [ -n "$base" ] || continue
  git -C "$d" diff --unified=0 "$base"..HEAD -- . ':(exclude)*.lock' 2>/dev/null |
    awk -v branch="$b" '/^diff --git /{file=$4; sub(/^b\//,"",file)} /^\+/ && !/^\+\+\+/{print branch ":" file ":" $0}'
done | rg -i --pcre2 '\b(SOTA|state[- ]of[- ]the[- ]art|state of the art|leaderboard|verified[- ]claim|verified claim|breakthrough|novelty|novel|outperform(?:s|ed|ing)?|best[- ]in[- ]class)\b|\b(best|first|beats?|surpass(?:es|ed|ing)?|superior|better than prior work|best in the literature|overall winner|leaderboard winner|proven)\b'
```

```bash
git diff --check
```

## Findings

1. **Baseline log inventory passes the known-state check.** The Wave 1-3
   Phase 8 baseline contains 48 manual logs. Exactly 3 of those logs hit the
   original usage limit, leaving 45 completion-like baseline logs to inspect.
2. **Diff inventory matches the log status.** The 48 local Wave 1-3 worktrees
   include 45 worktrees with committed changed files and 3 zero-diff worktrees,
   matching the original `phase-8-2-j/k/l` usage-limit failures.
3. **No completed Wave 1-3 diff was found making an unsupported public SOTA,
   leaderboard, verified-claim, breakthrough, or novelty assertion.** Candidate
   hits in completed diffs were guardrails, stop conditions, source-ledger
   requirements, forbidden phrase examples, neutral metric definitions, or
   explicit non-claim wording.
4. **One negative fixture needs reviewer awareness, not a block.**
   `phase-8-0-p-universal-datasets-card-schema` adds a test string
   `claim = "best universal benchmark"` in `tests/test_dataset_card.py`.
   The surrounding test asserts that a dataset card with an extra `claim` field
   is rejected. This is acceptable as a negative test fixture and must not be
   copied into documentation or public reports.
5. **One scoped release phrase must stay scoped.**
   `phase-8-0-w-universal-async-public-release-checklist` uses
   "best in this release" only to distinguish an internal frozen-release
   ranking from SOTA language. This is acceptable only if future release prose
   keeps the phrase tied to a frozen BSEBench snapshot and does not present it
   as external superiority.
6. **The public-report comparability audit correctly enumerates forbidden
   language.** `phase-8-2-h-public-report-comparability-audit` contains strings
   such as "SOTA", "best in the literature", "novel", "breakthrough",
   "verified claim", "beats prior work", and "leaderboard winner" as examples
   of blocked wording. These are not claims; they are rejection examples.
7. **The source-ledger requirement is not yet evidence of source-ledger
   completion for any public comparison.** The Phase 8 source-ledger audit
   defines required fields and rejection rules, but this audit did not find a
   completed ledger row that would authorize external comparison prose.

## Pass/Fail

PASS for the completed Wave 1-3 Phase 8 baseline, with merge-time cautions.

The pass means the audited completed diffs did not add unsupported public claim
language. It does not mean any method, estimator, dataset, snapshot, or metric
result is verified, novel, SOTA, or leaderboard-ready.

## Recommendations

1. Merge reviewers should keep the negative dataset-card fixture but treat the
   phrase `best universal benchmark` as test-only data.
2. Any release document using "best in this release" must include the frozen
   snapshot identity, aggregation policy, exclusions, failed-run accounting, and
   an explicit caveat that it is not SOTA.
3. Any external comparison phrase must be blocked unless it has a completed
   source-ledger row with stable URL or DOI, retrieval date, exact metric,
   dataset, split, external reported value, frozen BSEBench value, and
   comparability caveat.
4. Retry or account for `phase-8-2-j/k/l` through their Wave 4 retry branches
   before treating the reproducibility manifest, merge-queue runbook, or
   worker-triage runbook as complete Phase 8 evidence.
5. Re-run the same claim-language scan after Wave 4 stabilizes, because the
   current Wave 4 logs were mostly usage-limited at this timestamp.

## Residual Risks

- Watchdog logs combine prompts, shell commands, diffs, test output, and final
  summaries. Automated scans produce false positives unless reviewers inspect
  the surrounding changed file or final summary.
- Local worktree diffs were compared to each worktree's `origin/main`; if a
  branch was rebased after this audit, reviewers must re-run the diff scan on
  the pushed head being merged.
- Existing pre-Phase 8 documents and older Phase 7 outbox material contain
  claim vocabulary in roadmaps, fixtures, and linter examples. This audit
  records them only when they appeared inside Phase 8 logs; it does not approve
  or modify those files.
- The audit is text-level and provenance-level. It does not validate empirical
  numbers, replay benchmark runs, or check statistical correctness.

## Explicit Non-Claims

- This audit does not claim BSEBench is SOTA, novel, a breakthrough, verified,
  or a leaderboard winner.
- This audit does not claim any ECM, Kalman filter, observer, AI estimator,
  hybrid method, or future filter is superior to another method.
- This audit does not register, update, verify, retract, or support any thesis,
  manuscript, claim registry, `claims/registry.yaml`, `claim_55`, or scientific
  roadmap statement.
- This audit does not authorize public comparison wording without a completed
  source ledger and frozen BSEBench evidence.

## Validation

- `git diff --check`: passed with no output after writing this artifact.
- Protected write set: this branch should stage only
  `audits/guardrails/unsupported-claim-language-audit-20260507T204627Z.md`.
