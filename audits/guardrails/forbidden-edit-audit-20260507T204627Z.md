# GLASSBOX Forbidden Edit Audit: Phase 8 Wave 1-3

Timestamp: 2026-05-07T20:46:27Z task window
Worker: W4-09
Owned artifact: `audits/guardrails/forbidden-edit-audit-20260507T204627Z.md`

## Objective

Audit the first 48 Phase 8 manual logs and corresponding local worktrees for forbidden edits to thesis files, manuscript files, claim registry files, `claims/registry.yaml`, `claim_55`, or the scientific roadmap. Also scan diffs and logs for unsupported claim-language risk signals: SOTA, novelty, leaderboard, breakthrough, verified-claim language, and `Co-Authored-By Claude`.

This is a validation and containment artifact only. It does not edit protected scientific files and does not validate any benchmark result, paper claim, leaderboard, or novelty statement.

## Evidence Inspected

- Watchdog logs: `/home/oakir/.local/state/bsebench-async-watchdog/manual-phase-8-[012]-*.log`
- Local Phase 8 Wave 1-3 worktrees: `/mnt/c/doctorat/bsebench-org/*phase-8-[012]-*`
- Repositories covered by those worktrees: runner, stats, datasets, and async/CTO report.
- Local branch diffs against each repository `main` branch, including committed diffs, unstaged diffs, staged diffs, and untracked files.
- Local remote-ref mirrors under `origin/<branch>` where present.
- Retry accounting check for Wave 4 retry worktrees `phase-8-3-a`, `phase-8-3-b`, and `phase-8-3-c`.

## Commands Run

```bash
find /home/oakir/.local/state/bsebench-async-watchdog -maxdepth 1 -type f -name 'manual-phase-8-[012]-*.log' | wc -l
rg -l 'ERROR: You.*usage limit' /home/oakir/.local/state/bsebench-async-watchdog/manual-phase-8-[012]-*.log | wc -l
comm -23 <(find /home/oakir/.local/state/bsebench-async-watchdog -maxdepth 1 -type f -name 'manual-phase-8-[012]-*.log' -printf '%f\n' | sort) <(rg -l 'ERROR: You.*usage limit' /home/oakir/.local/state/bsebench-async-watchdog/manual-phase-8-[012]-*.log | xargs -r -n1 basename | sort) | wc -l
find /mnt/c/doctorat/bsebench-org -maxdepth 1 -type d -name '*phase-8-[012]-*' | wc -l
```

Observed: 48 Wave 1-3 logs, 3 usage-limit logs, 45 completion-like logs, and 48 local Phase 8 Wave 1-3 worktrees.

```bash
for d in /mnt/c/doctorat/bsebench-org/*phase-8-[012]-*; do
  if git -C "$d" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    b=${d##*/}
    branch=$(git -C "$d" branch --show-current)
    head=$(git -C "$d" rev-parse --short=12 HEAD)
    dirty=$(git -C "$d" status --short | wc -l)
    printf '%s\t%s\t%s\tdirty=%s\n' "$b" "$branch" "$head" "$dirty"
  fi
done
```

Observed: all 48 inspected worktrees had `dirty=0`.

```bash
for d in /mnt/c/doctorat/bsebench-org/*phase-8-[012]-*; do
  if git -C "$d" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    {
      git -C "$d" diff --name-only main...HEAD 2>/dev/null
      git -C "$d" diff --name-only 2>/dev/null
      git -C "$d" diff --name-only --cached 2>/dev/null
      git -C "$d" ls-files --others --exclude-standard 2>/dev/null
    } | sort -u
  fi
done | rg -i '(^|/)(thesis|manuscript|claims/registry|registry\.ya?ml|claim_55|.*roadmap.*)' | wc -l
```

Observed: `0` forbidden changed-path hits.

```bash
for d in /mnt/c/doctorat/bsebench-org/*phase-8-[012]-*; do
  if git -C "$d" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    git -C "$d" diff main...HEAD 2>/dev/null |
      rg -n -i 'SOTA|novelty|leaderboard|breakthrough|verified-claim|Co-Authored-By Claude|claim_55|claims/registry|registry\.ya?ml|thesis|manuscript|roadmap' || true
  fi
done
```

Observed: phrase hits exist, but the inspected hits are guardrail text, validation gates, non-claim disclaimers, protected-path tests, or legacy stats guard fields such as `claim_55_targeted`. No hit was classified as a protected file edit or as an unsupported result/leaderboard assertion in a Phase 8 audit artifact.

```bash
for d in /mnt/c/doctorat/bsebench-org/*phase-8-[012]-*; do
  if git -C "$d" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    git -C "$d" log --format=%B main..HEAD 2>/dev/null |
      rg -n -i 'Co-Authored-By Claude|Co-authored-by:.*Claude' || true
  fi
done
```

Observed: no `Co-Authored-By Claude` commit-message hits.

```bash
for d in /mnt/c/doctorat/bsebench-org/*phase-8-[012]-*; do
  if git -C "$d" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    branch=$(git -C "$d" branch --show-current)
    head=$(git -C "$d" rev-parse HEAD)
    upstream=$(git -C "$d" rev-parse --verify -q "origin/$branch" || true)
    if [ -n "$upstream" ] && [ "$head" = "$upstream" ]; then
      status=remote_match
    elif [ -n "$upstream" ]; then
      status=remote_diff
    else
      status=no_remote_ref
    fi
    printf '%s\t%s\t%s\n' "${d##*/}" "$branch" "$status"
  fi
done
```

Observed: 45 worktrees had matching local `origin/<branch>` refs. The three usage-limit branches had no matching remote ref and no branch diff.

```bash
git diff --check
```

Observed before this artifact was added: no output, exit 0.

## Findings

| Check | Result | Evidence |
| --- | --- | --- |
| Phase 8 Wave 1-3 log count | PASS | 48 logs found under watchdog state. |
| Completion-like accounting | PASS | 45 logs lack the exact usage-limit error; 3 logs contain it. |
| Usage-limit branch containment | PASS WITH RETRY ACCOUNTING | `phase-8-2-j`, `phase-8-2-k`, and `phase-8-2-l` stayed clean, had no branch diff, and had no `origin/<branch>` ref. |
| Worktree cleanliness | PASS | All 48 inspected Wave 1-3 worktrees reported `dirty=0`. |
| Forbidden changed paths | PASS | Combined committed, unstaged, staged, and untracked path scan returned 0 matches. |
| Protected scientific roadmap edit | PASS | No changed path matched roadmap patterns; the existing roadmap document was not modified by inspected diffs. |
| Claim-language phrase scan | PASS WITH CLASSIFICATION | Phrase hits were guardrails, tests, non-claim statements, or risk-register language, not unsupported benchmark-result claims. |
| `Co-Authored-By Claude` commit trailer | PASS | Commit-message scan across inspected branch diffs returned no hits. |

The three usage-limit logs are:

- `manual-phase-8-2-j-reproducibility-artifact-manifest-audit-20260507T193528Z.log`
- `manual-phase-8-2-k-merge-queue-runbook-20260507T193528Z.log`
- `manual-phase-8-2-l-worker-triage-and-relaunch-runbook-20260507T193528Z.log`

## Phrase-Hit Classification

Phrase hits were expected because Phase 8 prompts and many Wave 2-3 audit artifacts explicitly repeat the guardrails. The meaningful categories observed were:

- Guardrail text: explicit instructions forbidding thesis, manuscript, registry, `claim_55`, roadmap, SOTA, novelty, leaderboard, breakthrough, and verified-claim edits.
- Protective tests: scripts and fixtures intentionally checking that protected paths are rejected.
- Non-claim disclaimers: audit documents saying they do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements.
- Legacy stats guard fields: `claim_55_targeted` and `new_hinf_candidate_not_claim_55` fields used to block accidental promotion into protected claim scope.

No containment action was required for these phrase hits because they are defensive controls or disclaimers, not unsupported claims.

## Containment Actions

- No protected-path rollback or quarantine was needed because no forbidden changed paths were found.
- The three failed Wave 3 branches were treated as non-artifacts: clean worktrees, no changed paths, no remote branch refs, and exact usage-limit errors in logs.
- Wave 4 retry accounting was checked. At inspection time, `phase-8-3-a` and `phase-8-3-c` had clean retry artifact diffs with no forbidden-path hits; `phase-8-3-b` was still active and had no committed diff yet. This audit does not approve those Wave 4 retry outputs; it records them only as accounting evidence.

## Recommendations

1. Keep `phase-8-2-j`, `phase-8-2-k`, and `phase-8-2-l` out of any merge queue unless replaced by completed retry branches with GLASSBOX commits and validation records.
2. Preserve the zero-match changed-path scan as a pre-merge gate for Phase 8 integration batches.
3. Treat phrase-scan hits as requiring classification, not automatic failure, because many valid guardrail artifacts intentionally contain forbidden wording as negative controls.
4. Before merging stats branches, review their shared legacy H-infinity claim-guard files separately from the Phase 8 universal metrics additions, because those diffs include claim-guard vocabulary even though the current scan found no forbidden path edits.

## Residual Risks

- This audit used local refs and worktrees available on this machine. It did not fetch every remote during every command after the initial remote checks, so a later push after inspection could change the integration picture.
- Phrase classification was manual over scan output and final logs; it can miss subtle unsupported claims that avoid the searched vocabulary.
- Some Wave 4 retry and validation workers were still active during this audit. Their later outputs require their own guardrail scan before merge.
- The audit does not prove scientific correctness, dataset licensing sufficiency, metric validity, or reproducibility; it only checks forbidden edit containment and claim-language risk surfaces.

## Explicit Non-Claims

- This artifact does not claim BSEBench is SOTA, novel, leaderboard-leading, breakthrough, publication-ready, or externally verified.
- This artifact does not update, validate, or register `claim_55` or any other scientific claim.
- This artifact does not edit thesis files, manuscript files, claim registries, `claims/registry.yaml`, `claim_55`, or the scientific roadmap.
- This artifact does not approve merges; it provides guardrail evidence and recommendations for later integration review.
