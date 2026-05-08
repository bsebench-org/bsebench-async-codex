# Chef verdict for phase-7-10-r-stats-hinf-leave-source-fragility

- Decision : needs_fix
- Decided at : 2026-05-08T16:01:44+02:00
- Decided by : chef-daemon (automated, France PC) [role: chef-FR]

## Re-verification on chef PC

research diff-scope guard failed

## Gate evidence

```
DRY-RUN: checking research diff scope; no files will be modified.
[ALLOWED] scripts/hinf_leave_source_fragility.py -- ordinary non-protected change
[ALLOWED] src/bsebench_stats/__init__.py -- ordinary non-protected change
[ALLOWED] src/bsebench_stats/runners/__init__.py -- ordinary non-protected change
[BLOCKED] src/bsebench_stats/runners/hinf_leave_source_fragility.py -- added direct claim_55 targeting
[BLOCKED] tests/test_hinf_leave_source_fragility.py -- added direct claim_55 targeting
Research diff-scope summary: allowed=3 blocked=2 review_required=0 ledger_present=0
Research diff-scope guard failed: blocked or review-required edits are present.
```

## Changed files

```
A	scripts/hinf_leave_source_fragility.py
M	src/bsebench_stats/__init__.py
M	src/bsebench_stats/runners/__init__.py
A	src/bsebench_stats/runners/hinf_leave_source_fragility.py
A	tests/test_hinf_leave_source_fragility.py
```

## Cross-references

- inbox/phase-7-10-r-stats-hinf-leave-source-fragility/STATUS.json (worker artifact)
- outbox/phase-7-10-r-stats-hinf-leave-source-fragility/SUMMARY.md (worker SUMMARY)
- outbox/phase-7-10-r-stats-hinf-leave-source-fragility/run.log.tail (worker stdout tail, if non-empty)
