# bsebench-org async-codex onboarding (FIRST RUN — France personal PC, Windows)

> **Run this once.** It establishes context, persists memory, and downloads CALCE datasets in one dispatch. After this completes successfully, the cron worker takes over and dispatches future BRIEFs from `inbox/<phase-id>/`.

> **How to invoke** (on the France PC, Git Bash) :
> ```bash
> cd ~/bsebench-async-codex
> codex exec --dangerously-bypass-approvals-and-sandbox \
>   -C C:/doctorat/bsebench-org \
>   --add-dir C:/doctorat/bsebench-org/bsebench-datasets \
>   --add-dir C:/doctorat/bsebench-org/bsebench-async-codex \
>   < /path/to/this/BRIEF.md
> ```
> The user will save this file under `~/onboarding-codex.md` (or scp from the chef).

---

## Hello, codex.

You are now the **remote worker** in an asynchronous git-as-message-queue workflow with a **chef** running on a separate Windows PC. The chef and you communicate via the public protocol in repo `bsebench-org/bsebench-async-codex`.

This dispatch is **special** : it onboards you, persists context to your memory store, and performs your **first task** (downloading raw CALCE datasets). After this completes, the cron worker `~/bsebench-async-codex/scripts/remote-worker.sh` will dispatch you automatically every 60 s when new BRIEFs land in `inbox/`.

---

## 1. Repo layout on this PC

The user has cloned all `bsebench-org` repositories under `C:\doctorat\bsebench-org\`. Treat this directory as your work root. Posix paths (Git Bash) for the same locations :

```
C:\doctorat\bsebench-org\                   →   /c/doctorat/bsebench-org/
├── bsebench-datasets\          (public dataset adapters + Tier 2 loaders)
├── bsebench-runner\            (filter benchmark orchestrator)
├── bsebench-filters\           (10 ECM-state filters)
├── bsebench-async-codex\       (this orchestration repo)
├── bsebench-specs\             (claim registry, ADRs, schemas)
├── bsebench-stats\             (Friedman+Nemenyi, BMA, ensembling)
└── _datasets\                  (NEW — you will create this — large raw datasets that don't fit on chef PC)
```

The chef PC keeps `_datasets/` empty ; this PC hosts the bulk data.

---

## 2. The async-codex protocol (your day-to-day flow)

The cron job runs `~/bsebench-async-codex/scripts/remote-worker.sh` every 60 seconds. Each tick :

1. `git pull` on `bsebench-async-codex`.
2. Find the first `inbox/<phase-id>/STATUS.json` with `status == "queued"`.
3. Parse YAML frontmatter from `inbox/<phase-id>/BRIEF.md` :
   - `target_repo` : absolute path on this PC (e.g., `C:/doctorat/bsebench-org/bsebench-datasets`)
   - `target_branch` : new feature branch name (e.g., `phase-6-10-calce-a123-dyn`)
   - `base_branch` : usually `main`
   - `add_dir` : list of additional dirs you can read
   - `hard_wallclock_min` : timeout cap (default 90 min)
4. Worker creates a worktree at `<target_repo>-<target_branch>` from `origin/<base_branch>`.
5. Worker runs YOU :
   ```
   codex exec --dangerously-bypass-approvals-and-sandbox \
     -C <worktree_path> --add-dir <each add_dir> \
     < inbox/<phase-id>/BRIEF.md
   ```
6. You read BRIEF.md (the body after frontmatter is the actual prompt), do the work, commit on the new branch, **stop without pushing** (the worker pushes for you).
7. Worker pushes the branch + writes `outbox/<phase-id>/SUMMARY.md` and `outbox/<phase-id>/run.log.tail` back to `origin/main` of bsebench-async-codex.
8. Chef polls `bsebench-async-codex` every 25 min, reads SUMMARY.md, fetches your branch from the target repo, verifies gates, and merges to main.

---

## 3. Conventions you must follow on EVERY dispatch (no exceptions)

These are non-negotiable. They apply to all current and future BRIEFs you receive.

**Sign convention**
- Tier 1 adapters (`harmonize()`) write Parquet in **BPX 1.1** : charge-positive, discharge-negative.
- Tier 2 loaders flip to **paper2b convention** : `I > 0 = discharge`. The flip is unconditional : `i = -current_a` after reading Parquet.
- Always **empirically verify** the raw sign by reading 200 active samples (filter `abs(I) > 0.1` to skip rest segments) before committing to a flip-or-not decision in the adapter. Document the empirical finding in the module docstring.

**Forensic cell_id**
- Every Tier 2 `load(profile, T_C, **kwargs)` return dict MUST include `cell_id` as a string. Format follows paper2b's canonical wrapper (e.g., `pan_US06_T25`, `lg_P065_rep1_S01`, `Yao-BCDC-T25`, `B0005_T24_disc0`). Without `cell_id`, paper2b-compat claims are unverifiable at runtime.

**Schema keys (Tier 2 loader return dict)**
```python
{
    "t": np.ndarray,           # zero-based, seconds, float64
    "V": np.ndarray,           # voltage, float64
    "I": np.ndarray,           # current, paper2b discharge-positive, float64
    "T_meas": np.ndarray,      # measured temperature °C, float64
    "N": int,                  # len(t)
    "T_amb": float,            # ambient/chamber temperature °C
    "cell_id": str,            # forensic field, see above
    "dataset": str,            # snake_case dataset name
    "chemistry": str,          # e.g. "NMC_LG_INR21700_M50LT"
    "source_url": str,         # DOI or canonical URL
}
```

**Commit discipline**
- Conventional commits format : `feat(scope): subject` (≤ 50 chars subject).
- Author and committer : `Oussama Akir <claude@cosmocomply.com>`.
- **NO `Co-Authored-By: Claude` trailer** on any commit. This is a project mandate from the user.
- Body explains WHY, not WHAT. Cite empirical findings (smoking-gun commands), gate evidence (test counts, ruff results), and references to ADR / claim_NN if applicable.

**Pre-flight checklist (ADR 0014 §"Pre-flight checklist") — confirm before writing**
1. API signatures verified — including internal helper output formats when tests assert against them.
2. Reference implementation read — read the latest similar adapter+loader+test triple in full.
3. Source-of-truth pinned — paper2b's canonical wrapper at `<file>:<line>`.
4. Wheel-safety + caller-supplied paths — no `Path(__file__).parents[N]` for repo data discovery.
5. No `Co-Authored-By: Claude` trailer.
6. Codex sandbox canary — already verified Phase 6.6.b ; this dispatch uses `--dangerously-bypass-approvals-and-sandbox`.

**The bypass flag is not optional on Windows**
- Codex 0.129.0-alpha.7 has a regressed `sandbox_mode` config key (upstream issue #6667). The session header reports `sandbox: read-only` even with `sandbox_mode = "workspace-write"` set. The only working override is `--dangerously-bypass-approvals-and-sandbox`. The worker passes this flag for you ; do not be surprised if the session header says read-only — apply_patch still works through the bypass.

**Wallclock awareness**
- Default hard cap is 90 min via `timeout 5400s` wrapper. Plan accordingly.
- If a dispatch needs longer (e.g., a multi-GB download or a 30-cfg test sweep), the BRIEF will set `hard_wallclock_min` higher in the frontmatter.

---

## 4. Save this context to your memory store

Codex memory at `~/.codex/memories/` persists across sessions when `[memories] use_memories = true` is configured (which it is on this PC).

**Action** : use `apply_patch` to create the file `~/.codex/memories/bsebench-async-codex-context.md` with the exact content of section "1. Repo layout on this PC", section "2. The async-codex protocol (your day-to-day flow)", and section "3. Conventions you must follow on EVERY dispatch" of this brief — copy them verbatim into that memory file.

Header for the memory file :

```markdown
---
name: bsebench-async-codex context (remote worker)
description: Async git-as-message-queue with the chef PC. Repo layout, protocol, sign conventions, commit discipline, no Co-Authored-By Claude trailer. Saved 2026-05-06.
type: project
---
```

Then the three sections verbatim.

This way, every future async dispatch can rely on this memory rather than re-receiving the full context — making future BRIEFs short and focused on the specific work.

---

## 5. Your first task : download the 20 CALCE zip files

After saving memory, perform this task in the **same session** (you have until the wallclock cap expires).

### Target directories (create if missing)

```
C:/doctorat/bsebench-org/_datasets/calce_a123_lfp_dynamic/
C:/doctorat/bsebench-org/_datasets/calce_inr18650_20R_dynamic/
```

### Files to download (20 zips total, ~5-10 GB combined)

**A123 dynamic** (8 zips → `_datasets/calce_a123_lfp_dynamic/`) :

```
A123_DST-US06-FUDS-N10.zip      (T = -10 °C)
A123_DST-US06-FUDS-0.zip        (T =   0 °C)
A123_DST-US06-FUDS-10.zip       (T =  10 °C)
A123_DST-US06-FUDS-20.zip       (T =  20 °C)
A123_DST-US06-FUDS-25.zip       (T =  25 °C)
A123_DST-US06-FUDS-30.zip       (T =  30 °C)
A123_DST-US06-FUDS-40.zip       (T =  40 °C)
A123_DST-US06-FUDS-50.zip       (T =  50 °C)
```

**INR 18650-20R dynamic** (12 zips → `_datasets/calce_inr18650_20R_dynamic/`) :

```
SP2_0C_DST.zip    SP2_0C_FUDS.zip    SP2_0C_US06.zip    SP2_0C_BJDST.zip
SP2_25C_DST.zip   SP2_25C_FUDS.zip   SP2_25C_US06.zip   SP2_25C_BJDST.zip
SP2_45C_DST.zip   SP2_45C_FUDS.zip   SP2_45C_US06.zip   SP2_45C_BJDST.zip
```

### Discovery + download protocol

CALCE Maryland publishes the zips at `https://calce.umd.edu/battery-data` but the actual URLs are not stable across redesigns. Follow this order :

1. **Try the canonical URL pattern first** (likely paths under `https://web.calce.umd.edu/batteries/data/` or similar). For each filename, attempt :
   - `https://web.calce.umd.edu/batteries/data/<filename>`
   - `https://calce.umd.edu/sites/default/files/data/<subdir>/<filename>`
   - if 404, fall through.

2. **If canonical URLs fail**, fetch the index page `https://calce.umd.edu/battery-data` and parse it for direct `.zip` links matching the filenames above. Use `curl -sL <url> | grep -oE 'href="[^"]+\.zip"'` or equivalent.

3. **For each successful URL**, download with `curl -L --fail --output <target_dir>/<filename> <url>` and verify : file exists, size > 1 MB, and the first bytes are `PK\x03\x04` (zip magic). Log each download outcome.

4. **For any failure** (404, network, magic mismatch), skip that file but continue with the others. Record in `_datasets/.calce-download-log.txt` :
   ```
   <filename>  status=ok|failed-404|failed-magic|failed-network  size=<bytes>  url=<url>  ts=<iso>
   ```

5. **Do not unzip yet** — leave the .zip files as-is. Phase 6.10's adapter will handle unzip-on-the-fly per the existing paper2b pattern (see `benchmark_grid_multi.py:684-707` for the `tempfile.TemporaryDirectory + zipfile.ZipFile.extractall` reference).

### Acceptance for the download task

- ≥ 16 / 20 zips successfully downloaded (some may be 404 due to CALCE site renames — that's tolerable).
- `_datasets/.calce-download-log.txt` exists and lists outcome per filename.
- No partial downloads (any file < 1 MB or with bad magic is deleted).

### Do not commit anything yet

The CALCE zips are not version-controlled. They live on disk only. Do not add them to any git repo. Do not push.

---

## 6. Final report

After saving memory + the download task, end the session by printing :

```
ASYNC-CODEX ONBOARDING COMPLETE
- memory saved : ~/.codex/memories/bsebench-async-codex-context.md (size: <bytes>)
- CALCE A123 dynamic : <N>/8 zips downloaded
- CALCE INR-20R dynamic : <N>/12 zips downloaded
- log : C:/doctorat/bsebench-org/_datasets/.calce-download-log.txt
- next step : user installs the cron worker per scripts/setup-remote.md, then chef queues phase-async-canary
```

That's it. After this dispatch ends, the user will register you as a worker (per `scripts/setup-remote.md`), set up cron, and the chef will queue real phases via `inbox/<phase-id>/BRIEF.md` going forward.

Welcome to the team.
