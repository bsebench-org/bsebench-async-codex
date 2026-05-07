---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-async-codex
target_branch: diag/hf-cache-auth-20260507T032519Z
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
hard_wallclock_min: 5
---

# Diagnostic HF cache/auth for Hinf residual evidence

Read-only investigation. Do not edit files, do not commit, and do not print any
secret token value.

## Mission

Explain why Phase 7.7.b strict real 5x5 Hinf evidence could not load any of the
five configs. The prior run failed before output with Hugging Face
`RepositoryNotFoundError` / `401` / `Invalid username or password` on all five
configs.

## Commands / observations to print

Run read-only shell/Python checks and print concise results:

1. `git -C /mnt/c/doctorat/bsebench-org/bsebench-runner rev-parse HEAD`
2. `git -C /mnt/c/doctorat/bsebench-org/bsebench-datasets rev-parse HEAD`
3. Whether HF auth appears configured, without printing token:
   - `HF_TOKEN` set? yes/no only.
   - `HUGGINGFACE_HUB_TOKEN` set? yes/no only.
   - `~/.cache/huggingface/token` exists? yes/no only.
   - If `huggingface-cli whoami` is available, print only success/failure and
     username if the CLI itself prints one without token material.
4. List local cache candidate directories and sizes if present:
   - `/mnt/c/doctorat/bsebench-org/_datasets`
   - `/tmp/bsebench_yao_tier2_cache`
   - `/tmp/bsebench_panasonic_tier2_cache`
   - `/tmp/bsebench_nasa_tier2_cache`
   - `/tmp/bsebench_calce_legacy_tier2_cache`
   - Hugging Face cache roots under `~/.cache/huggingface/hub`
5. From Python, import the five relevant loader classes and print their HF repo
   constants plus whether `available_configs()` can run from local cache without
   network for each wrapper:
   - Yao BCDC/US06 T25
   - Panasonic US06 T25
   - NASA B0005 T24 / CC-discharge
   - CALCE A123 DST T25 legacy
6. Print a final diagnosis with one of:
   - `hf_token_missing_or_invalid`
   - `hf_repos_private_or_missing`
   - `local_cache_missing`
   - `mixed`
   - `unknown`

Do not attempt to download large datasets. One metadata call such as
`whoami` is acceptable. Do not print stack traces longer than 20 lines.
