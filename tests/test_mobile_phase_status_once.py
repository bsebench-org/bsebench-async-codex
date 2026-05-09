from __future__ import annotations

import importlib.util
from pathlib import Path


SCRIPT_PATH = (
    Path(__file__).resolve().parents[1] / "scripts" / "mobile_phase_status_once.py"
)
SPEC = importlib.util.spec_from_file_location("mobile_phase_status_once", SCRIPT_PATH)
assert SPEC is not None
mobile_phase_status_once = importlib.util.module_from_spec(SPEC)
assert SPEC.loader is not None
SPEC.loader.exec_module(mobile_phase_status_once)


def test_phase_progress_is_monotone_by_default(monkeypatch):
    monkeypatch.setenv("PHASE9_PROGRESS", "88")
    monkeypatch.setenv("PHASE10_PROGRESS", "62")
    monkeypatch.setenv("PHASE11_PROGRESS", "54")
    monkeypatch.delenv("MOBILE_STATUS_ALLOW_REGRESSION", raising=False)

    text = """
- Phase 9: `93%` (`+4%` depuis 03:07).
- Phase 10: `66%` (`+4%` depuis dernier status).
- Phase 11: `59%` (`+5%` depuis dernier status).
"""

    assert mobile_phase_status_once.phase_progress(text) == {9: 93, 10: 66, 11: 59}


def test_phase_progress_ignores_late_lower_status_blocks(monkeypatch):
    monkeypatch.setenv("PHASE9_PROGRESS", "88")
    monkeypatch.setenv("PHASE10_PROGRESS", "62")
    monkeypatch.setenv("PHASE11_PROGRESS", "54")
    monkeypatch.delenv("MOBILE_STATUS_ALLOW_REGRESSION", raising=False)

    text = """
- Phase 9: `93%` (`+4%` depuis 03:07).
- Phase 10: `66%` (`+4%` depuis dernier status).
- Phase 11: `59%` (`+5%` depuis dernier status).
- Phase 9: `88%` (`-5%` since previous mobile status).
- Phase 10: `62%` (`-4%` since previous mobile status).
- Phase 11: `54%` (`-5%` since previous mobile status).
"""

    assert mobile_phase_status_once.phase_progress(text) == {9: 93, 10: 66, 11: 59}


def test_phase_progress_can_allow_explicit_regression(monkeypatch):
    monkeypatch.setenv("PHASE9_PROGRESS", "88")
    monkeypatch.setenv("PHASE10_PROGRESS", "62")
    monkeypatch.setenv("PHASE11_PROGRESS", "54")
    monkeypatch.setenv("MOBILE_STATUS_ALLOW_REGRESSION", "1")

    text = "- Phase 9: `93%`\n- Phase 10: `66%`\n- Phase 11: `59%`\n"

    assert mobile_phase_status_once.phase_progress(text) == {9: 88, 10: 62, 11: 54}
