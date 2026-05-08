# Chef verdict for phase-7-10-v-async-source-ledger-freshness-gate

- Decision : escalated
- Decided at : 2026-05-08T16:33:48+02:00
- Decided by : chef-daemon (automated, France PC) [role: chef-FR]

## Re-verification on chef PC

Worker reported status=error. Manual investigation needed (see SUMMARY + run.log.tail above for context). V1 chef-daemon does not auto-fix errors.

## Gate evidence

```
+        "comparability": "partial",
+        "caveat": "synthetic caveat: source row shares metric and dataset but leaves preprocessing unreported and uses a different validation horizon"
+      }
+    ]
+  }
+}

tokens used
150,360
Implemented and committed `befd8974fd11ed90a06e9e0d3572b0d32bf61b0b`:

`GLASSBOX [role: worker-FR] Add source-ledger freshness gate`

Added [check-source-ledger-freshness.sh](/mnt/c/doctorat/bsebench-org/bsebench-async-codex-phase-7-10-v-async-source-ledger-freshness-gate/scripts/check-source-ledger-freshness.sh) plus fixture coverage in [test-source-ledger-freshness.sh](/mnt/c/doctorat/bsebench-org/bsebench-async-codex-phase-7-10-v-async-source-ledger-freshness-gate/scripts/test-source-ledger-freshness.sh). The checker classifies rows as `comparable`, `partial`, `not_comparable`, `stale`, or `invalid`, and fails closed on future/malformed dates, stale retrievals, missing stable URL/DOI, missing metric/dataset/split, missing frozen BSEBench value, missing caveat, and `comparable` rows with unknown required conditions.

Validation passed:
- `bash scripts/test-source-ledger-freshness.sh`
- `bash -n scripts/check-source-ledger-freshness.sh scripts/test-source-ledger-freshness.sh scripts/check-research-diff-scope.sh scripts/probe-research-diff-scope-guard.sh`
- `bash scripts/probe-research-diff-scope-guard.sh`
- `bash scripts/check-research-brief-gates.sh --dry-run cto/AUTONOMY_BACKLOG/phase-7-*/BRIEF.md` (`28 checked`)
- `git diff --check`
- `git diff --cached --check`
- Extra staged guard: `bash scripts/check-research-diff-scope.sh --dry-run --staged`

No thesis files, claim registries, `claims/registry.yaml`, `claim_55`, or roadmap files were edited. No real literature numbers were added. No `Co-Authored-By Claude` trailer is present.
```

## Next step for chef

git fetch origin && git checkout phase-7-10-v-async-source-ledger-freshness-gate in target_repo. Verify gates. Merge to main if green.

--- run.log.tail ---
+        "split": "synthetic alternate validation horizon B",
+        "preprocessing": "not_reported",
+        "method": "SyntheticComparableMethod",
+        "reported_value": "2.340 synthetic units (fixture only, not literature evidence)",
+        "bsebench_value": "2.100 synthetic units from frozen fixture artifact",
+        "comparability": "partial",
+        "caveat": "synthetic caveat: source row shares metric and dataset but leaves preprocessing unreported and uses a different validation horizon"
+      }
+    ]
+  }
+}

tokens used
150,360
Implemented and committed `befd8974fd11ed90a06e9e0d3572b0d32bf61b0b`:

`GLASSBOX [role: worker-FR] Add source-ledger freshness gate`

Added [check-source-ledger-freshness.sh](/mnt/c/doctorat/bsebench-org/bsebench-async-codex-phase-7-10-v-async-source-ledger-freshness-gate/scripts/check-source-ledger-freshness.sh) plus fixture coverage in [test-source-ledger-freshness.sh](/mnt/c/doctorat/bsebench-org/bsebench-async-codex-phase-7-10-v-async-source-ledger-freshness-gate/scripts/test-source-ledger-freshness.sh). The checker classifies rows as `comparable`, `partial`, `not_comparable`, `stale`, or `invalid`, and fails closed on future/malformed dates, stale retrievals, missing stable URL/DOI, missing metric/dataset/split, missing frozen BSEBench value, missing caveat, and `comparable` rows with unknown required conditions.

Validation passed:
- `bash scripts/test-source-ledger-freshness.sh`
- `bash -n scripts/check-source-ledger-freshness.sh scripts/test-source-ledger-freshness.sh scripts/check-research-diff-scope.sh scripts/probe-research-diff-scope-guard.sh`
- `bash scripts/probe-research-diff-scope-guard.sh`
- `bash scripts/check-research-brief-gates.sh --dry-run cto/AUTONOMY_BACKLOG/phase-7-*/BRIEF.md` (`28 checked`)
- `git diff --check`
- `git diff --cached --check`
- Extra staged guard: `bash scripts/check-research-diff-scope.sh --dry-run --staged`

No thesis files, claim registries, `claims/registry.yaml`, `claim_55`, or roadmap files were edited. No real literature numbers were added. No `Co-Authored-By Claude` trailer is present.
```

## Changed files

```
unavailable: worker status=error; chef did not check out target branch
```

## Cross-references

- inbox/phase-7-10-v-async-source-ledger-freshness-gate/STATUS.json (worker artifact)
- outbox/phase-7-10-v-async-source-ledger-freshness-gate/SUMMARY.md (worker SUMMARY)
- outbox/phase-7-10-v-async-source-ledger-freshness-gate/run.log.tail (worker stdout tail, if non-empty)
