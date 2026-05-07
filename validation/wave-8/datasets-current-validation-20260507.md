# Wave 8 datasets current-state validation

- Worker: W8-b
- Timestamp: 2026-05-07T21:49:28Z
- Target repo inspected read-only: `/mnt/c/doctorat/bsebench-org/bsebench-datasets`
- Target remote branch: `origin/phase-8-4-c-datasets-universal-wave1-integration-20260507T213125Z`
- Validation disposition: PASS with explicit dependency-gap notes

## Remote ref evidence

Commands run from `/mnt/c/doctorat/bsebench-org/bsebench-datasets`:

```bash
git fetch origin
git rev-parse origin/phase-8-4-c-datasets-universal-wave1-integration-20260507T213125Z
git rev-parse origin/main
git merge-base --is-ancestor origin/main origin/phase-8-4-c-datasets-universal-wave1-integration-20260507T213125Z
git diff --stat origin/main..origin/phase-8-4-c-datasets-universal-wave1-integration-20260507T213125Z
git diff --name-status origin/main..origin/phase-8-4-c-datasets-universal-wave1-integration-20260507T213125Z
git diff --check origin/main..origin/phase-8-4-c-datasets-universal-wave1-integration-20260507T213125Z
```

Observed:

- Target branch SHA: `6cbdc5477a51d5a65c36a568be6d56eeb6c7ce66`
- `origin/main` SHA at validation time: `2b97c256c86128bc057ec394a40610a086a7d665`
- `git merge-base --is-ancestor origin/main <target>` exit code: `0`
- `git diff --check origin/main..<target>`: PASS, no output
- Datasets checkout remained clean after validation: `## main...origin/main`

Changed-file summary versus `origin/main`:

```text
 splits/audit_j_v1.yaml                             |  27 +-
 src/bsebench_datasets/__init__.py                  |  44 ++
 src/bsebench_datasets/availability.py              | 307 ++++++++++++
 src/bsebench_datasets/dataset_card.py              | 342 +++++++++++++
 src/bsebench_datasets/equipment_registry.py        | 167 +++++++
 src/bsebench_datasets/etl_contract.py              | 305 ++++++++++++
 src/bsebench_datasets/ground_truth_metadata_audit.py | 531 +++++++++++++++++++++
 src/bsebench_datasets/splits.py                    | 223 ++++++++-
 tests/conftest.py                                  |  72 +++
 tests/test_availability_snapshot.py                | 148 ++++++
 tests/test_dataset_card.py                         | 186 ++++++++
 tests/test_equipment_registry.py                   | 157 ++++++
 tests/test_etl_contract.py                         | 135 ++++++
 tests/test_ground_truth_metadata_audit.py          | 203 ++++++++
 tests/test_split_audit_j_v1.py                     | 163 ++++++-
 15 files changed, 3001 insertions(+), 9 deletions(-)
```

## Focused validation

To avoid modifying the datasets checkout, tests were run from a temporary archive of the exact remote ref:

```bash
tmpdir=$(mktemp -d /tmp/bsebench-datasets-wave8-XXXXXX)
git archive origin/phase-8-4-c-datasets-universal-wave1-integration-20260507T213125Z | tar -x -C "$tmpdir"
cd "$tmpdir"
```

Direct project-tool commands first exposed missing executables in the default `uv run` environment:

```bash
uv run ruff format --check ...
uv run ruff check ...
uv run pytest ...
```

Observed gap:

```text
error: Failed to spawn: `ruff`
  Caused by: No such file or directory (os error 2)
error: Failed to spawn: `pytest`
  Caused by: No such file or directory (os error 2)
```

The same focused checks passed when the missing tools/plugins were supplied ephemerally by `uv`:

```bash
uv run --with ruff ruff format --check \
  src/bsebench_datasets/availability.py \
  src/bsebench_datasets/dataset_card.py \
  src/bsebench_datasets/equipment_registry.py \
  src/bsebench_datasets/etl_contract.py \
  src/bsebench_datasets/ground_truth_metadata_audit.py \
  src/bsebench_datasets/splits.py \
  tests/test_availability_snapshot.py \
  tests/test_dataset_card.py \
  tests/test_equipment_registry.py \
  tests/test_etl_contract.py \
  tests/test_ground_truth_metadata_audit.py \
  tests/test_split_audit_j_v1.py

uv run --with ruff ruff check \
  src/bsebench_datasets/availability.py \
  src/bsebench_datasets/dataset_card.py \
  src/bsebench_datasets/equipment_registry.py \
  src/bsebench_datasets/etl_contract.py \
  src/bsebench_datasets/ground_truth_metadata_audit.py \
  src/bsebench_datasets/splits.py \
  tests/test_availability_snapshot.py \
  tests/test_dataset_card.py \
  tests/test_equipment_registry.py \
  tests/test_etl_contract.py \
  tests/test_ground_truth_metadata_audit.py \
  tests/test_split_audit_j_v1.py

uv run --with pytest --with pytest-cov pytest \
  tests/test_availability_snapshot.py \
  tests/test_dataset_card.py \
  tests/test_equipment_registry.py \
  tests/test_etl_contract.py \
  tests/test_ground_truth_metadata_audit.py \
  tests/test_split_audit_j_v1.py
```

Observed pass signals:

- `ruff format --check`: `12 files already formatted`
- `ruff check`: `All checks passed!`
- Focused pytest: `60 passed in 2.53s`

## Blockers and limits

- BLOCKED only for the bare default commands `uv run ruff ...` and `uv run pytest ...` because `ruff`, `pytest`, and then `pytest-cov` were not available until supplied with `uv --with`.
- No full raw-dataset loader sweep was run. The validated branch diff is concentrated in metadata, availability, ETL contract, equipment registry, ground-truth audit, and split-contract code/tests; this report does not claim raw data asset validation.
- No scientific, SOTA, novelty, leaderboard, superiority, or universal-proven claims are made here.

## Verdict

PASS for current pushed branch existence, SHA pinning, fast-forward ancestry relative to current `origin/main`, diff hygiene, and focused integration tests covering the changed dataset metadata/contracts/split surface.
