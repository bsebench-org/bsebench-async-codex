from __future__ import annotations

import importlib.util
import sys
from pathlib import Path


MODULE_PATH = (
    Path(__file__).resolve().parents[1] / "scripts" / "phase9_11_merge_matrix.py"
)
SPEC = importlib.util.spec_from_file_location("phase9_11_merge_matrix", MODULE_PATH)
assert SPEC is not None
matrix = importlib.util.module_from_spec(SPEC)
assert SPEC.loader is not None
sys.modules[SPEC.name] = matrix
SPEC.loader.exec_module(matrix)


def test_refill_slug_strips_timestamp() -> None:
    assert (
        matrix.refill_slug(
            "origin/phase9-11-refill-p10-tier2-aging-cache-20260509T013206+0200"
        )
        == "p10-tier2-aging-cache"
    )


def test_selected_latest_keeps_newest_refill_per_repo_slug() -> None:
    older = matrix.RefRecord(
        repo="bsebench-datasets",
        branch="origin/phase9-11-refill-p9-tier2-profile-cache-20260508T220841+0200",
        sha="old",
        date="2026-05-08 22:23:43 +0200",
        subject="GLASSBOX older",
    )
    newer = matrix.RefRecord(
        repo="bsebench-datasets",
        branch="origin/phase9-11-refill-p9-tier2-profile-cache-20260509T013148+0200",
        sha="new",
        date="2026-05-09 01:48:06 +0200",
        subject="GLASSBOX newer",
    )

    selected = matrix.selected_latest([older, newer])

    assert selected == [newer]


def test_assess_record_blocks_missing_glassbox_and_claude_trailer(
    tmp_path: Path,
) -> None:
    record = matrix.RefRecord(
        repo="bsebench-runner",
        branch="origin/phase9-11-refill-p9-profile-empirical-scheduler-20260509T013235+0200",
        sha="abc123",
        date="2026-05-09 01:47:47 +0200",
        subject="add scheduler",
        body="Co-Authored-By: Claude <claude@example.com>",
        changed_paths=("src/bsebench_runner/profile_empirical_scheduler.py",),
        diff_check="passed",
        merge_tree="clean",
    )

    row = matrix.assess_record(record, tmp_path)

    assert row.disposition == "blocked"
    assert "commit subject does not start with GLASSBOX" in row.blockers
    assert "Claude co-author trailer" in row.blockers


def test_validation_order_places_guardrails_before_dataset_runner_stats_records() -> (
    None
):
    records = [
        matrix.RefRecord(
            "bsebench-stats",
            "origin/phase9-11-refill-p10-aging-verdict-inputs-20260509T013634+0200",
            "1",
            "",
            "GLASSBOX",
            diff_check="passed",
            merge_tree="clean",
        ),
        matrix.RefRecord(
            "bsebench-runner",
            "origin/phase9-11-refill-p9-profile-empirical-scheduler-20260509T013235+0200",
            "2",
            "",
            "GLASSBOX",
            diff_check="passed",
            merge_tree="clean",
        ),
        matrix.RefRecord(
            "bsebench-datasets",
            "origin/phase9-11-refill-p9-tier2-profile-cache-20260509T013148+0200",
            "3",
            "",
            "GLASSBOX",
            diff_check="passed",
            merge_tree="clean",
        ),
        matrix.RefRecord(
            "bsebench-async-codex",
            "origin/phase9-11-refill-p9-11-acceptance-gate-20260509T013134+0200",
            "4",
            "",
            "GLASSBOX",
            diff_check="passed",
            merge_tree="clean",
        ),
        matrix.RefRecord(
            "bsebench-async-codex",
            "origin/phase-9-final-verdict-20260508T203558+0200",
            "5",
            "",
            "GLASSBOX",
            diff_check="passed",
            merge_tree="clean",
        ),
    ]

    rows = [matrix.assess_record(record, Path("/missing")) for record in records]
    ordered_lanes = [row.lane for row in sorted(rows, key=matrix.row_sort_key)]

    assert ordered_lanes == ["guardrail", "dataset", "runner", "stats", "record"]


def test_claim_findings_detects_positive_phase_closure_and_benchmark_terms() -> None:
    findings = matrix.claim_findings(
        "Phase 9 is complete and this is a leaderboard winner."
    )

    assert "Phase 9 is complete" in findings
    assert "leaderboard" in findings


def test_known_stale_synthesis_branch_is_blocked(tmp_path: Path) -> None:
    record = matrix.RefRecord(
        repo="bsebench-async-codex",
        branch="origin/phase-9-10-11-final-synthesis-20260508T203723+0200",
        sha="abc123",
        date="2026-05-08 20:41:08 +0200",
        subject="GLASSBOX stale synthesis",
        diff_check="deferred",
        merge_tree="deferred",
    )

    row = matrix.assess_record(record, tmp_path)

    assert row.disposition == "blocked"
    assert any("superseded" in blocker for blocker in row.blockers)
