# Phase 9/10/11 Refill Root Cause - 2026-05-08

Timestamp: 2026-05-08T21:18:00+02:00

## Incident

The Phase 9/10/11 Codex worker count dropped below the requested floor while the
project was locked to Phase 9/10/11 closure work.

Observed state:

- active unique Codex workdirs dropped to `7-8`;
- the persistent Python refill process was no longer running;
- the per-user crontab still contained a username field:
  `* * * * * oakir /usr/bin/env ...`;
- Hugging Face uploads remained stopped.

## Root Cause

The refill cron entry used system-crontab syntax inside a per-user crontab.
Per-user crontabs must not include the username field. The resulting cron job
could not reliably restart the refill loop after the daemon stopped.

The earlier target of `18` was also too close to the unified exec process cap.
Each `codex exec` workdir consumes multiple related processes, so `18` workers
can produce warnings around the `60` process/session limit.

## Corrective Action

The per-user crontab was rewritten to:

```cron
* * * * * /usr/bin/env BSEBENCH_ROOT=/mnt/c/doctorat/bsebench-org STATE_DIR=/home/oakir/.local/state/bsebench-async-watchdog TARGET_CODEX=17 /usr/bin/python3 /mnt/c/doctorat/bsebench-org/bsebench-async-codex/scripts/cto_phase9_11_refill_loop.py --once
```

Then an immediate refill pass was run and the persistent daemon was restarted:

```bash
env BSEBENCH_ROOT=/mnt/c/doctorat/bsebench-org \
  STATE_DIR=/home/oakir/.local/state/bsebench-async-watchdog \
  TARGET_CODEX=17 \
  python3 scripts/cto_phase9_11_refill_loop.py --once

nohup env BSEBENCH_ROOT=/mnt/c/doctorat/bsebench-org \
  STATE_DIR=/home/oakir/.local/state/bsebench-async-watchdog \
  TARGET_CODEX=17 \
  python3 scripts/cto_phase9_11_refill_loop.py \
  >> /home/oakir/.local/state/bsebench-async-watchdog/phase9-11-refill-python.nohup.log 2>&1 &
```

The immediate refill restored the active count to `17`.

## Guardrail

Until the Phase 9/10/11 validation checkpoint closes:

- target workers: `17`;
- minimum acceptable active unique workdirs: `6`;
- scope: Phase 9/10/11 only;
- uploads: paused;
- Phase 12/13+: locked.

If the active count falls below the target, the cron runs the refill once per
minute. The persistent daemon also runs the same refill logic continuously.

## Validation

Post-fix observed state:

- crontab entry no longer includes the username field;
- persistent refill daemon restarted;
- active unique Codex workdirs restored to `17`;
- new tasks launched only for Phase 9/10/11;
- real HF upload processes: `0`.
