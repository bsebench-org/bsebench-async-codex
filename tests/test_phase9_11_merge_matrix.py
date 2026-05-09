import datetime as dt
import unittest

from scripts.phase9_11_merge_matrix import (
    BranchRef,
    TASKS,
    overlap_notes,
    parse_refill_branch,
    select_latest_candidates,
    validation_state,
)


def branch(
    *,
    slug: str,
    timestamp: str,
    sha: str,
    main_sha: str = "main",
    repo: str = "bsebench-runner",
    subject: str = "GLASSBOX: test",
    body: str = "GLASSBOX body",
    changed_files: tuple[str, ...] = ("src/file.py",),
) -> BranchRef:
    parsed = parse_refill_branch(f"origin/phase9-11-refill-{slug}-{timestamp}")
    assert parsed is not None
    _, parsed_ts = parsed
    return BranchRef(
        repo=repo,
        branch=f"origin/phase9-11-refill-{slug}-{timestamp}",
        slug=slug,
        timestamp=parsed_ts,
        sha=sha,
        short_sha=sha[:12],
        subject=subject,
        author="Oussama Akir",
        author_email="dev@example.test",
        committed_at=timestamp,
        changed_files=changed_files,
        body=body,
        main_sha=main_sha,
        repo_dirty=False,
        already_in_main=False,
    )


class Phase911MergeMatrixTests(unittest.TestCase):
    def test_parse_refill_branch(self) -> None:
        parsed = parse_refill_branch(
            "origin/phase9-11-refill-p11-residual-trace-scheduler-20260509T013310+0200"
        )
        self.assertIsNotNone(parsed)
        slug, timestamp = parsed
        self.assertEqual(slug, "p11-residual-trace-scheduler")
        self.assertEqual(timestamp.tzinfo, dt.timezone(dt.timedelta(hours=2)))

    def test_latest_candidate_excludes_empty_retry(self) -> None:
        empty = branch(
            slug="p9-profile-empirical-scheduler",
            timestamp="20260509T013235+0200",
            sha="main",
        )
        older = branch(
            slug="p9-profile-empirical-scheduler",
            timestamp="20260509T010000+0200",
            sha="abc",
        )
        newer = branch(
            slug="p9-profile-empirical-scheduler",
            timestamp="20260509T011000+0200",
            sha="def",
        )

        candidates, superseded, empty_count = select_latest_candidates([empty, older, newer])

        self.assertEqual([candidate.sha for candidate in candidates], ["def"])
        self.assertEqual(superseded, 1)
        self.assertEqual(empty_count, 1)

    def test_validation_state_fails_closed_on_metadata(self) -> None:
        bad_subject = branch(
            slug="p9-11-anti-claim-audit",
            timestamp="20260509T010000+0200",
            sha="abc",
            subject="chore: missing prefix",
        )
        bad_trailer = branch(
            slug="p9-11-anti-claim-audit",
            timestamp="20260509T010001+0200",
            sha="def",
            body="Co-Authored-By: Claude <claude@example.test>",
        )
        protected = branch(
            slug="p9-11-anti-claim-audit",
            timestamp="20260509T010002+0200",
            sha="ghi",
            changed_files=("docs/RESEARCH-ROADMAP-2026-05-06.md",),
        )

        self.assertIn("missing GLASSBOX", validation_state(bad_subject, ()))
        self.assertIn("Claude co-author", validation_state(bad_trailer, ()))
        self.assertIn("protected-path", validation_state(protected, ()))

    def test_overlap_notes_are_same_repo_only(self) -> None:
        left = branch(
            slug="p9-a",
            timestamp="20260509T010000+0200",
            sha="abc",
            changed_files=("src/shared.py",),
        )
        right = branch(
            slug="p9-b",
            timestamp="20260509T010001+0200",
            sha="def",
            changed_files=("src/shared.py",),
        )
        other_repo = branch(
            slug="p9-c",
            timestamp="20260509T010002+0200",
            sha="ghi",
            repo="bsebench-stats",
            changed_files=("src/shared.py",),
        )

        notes = overlap_notes((left, right, other_repo))

        self.assertIn(("bsebench-runner", "p9-a"), notes)
        self.assertIn(("bsebench-runner", "p9-b"), notes)
        self.assertNotIn(("bsebench-stats", "p9-c"), notes)

    def test_task_order_keeps_guardrails_before_verdict_inputs(self) -> None:
        self.assertLess(
            TASKS["p9-11-anti-claim-audit"].order,
            TASKS["p9-profile-verdict-inputs"].order,
        )
        self.assertLess(
            TASKS["p9-tier2-profile-cache"].order,
            TASKS["p9-profile-empirical-scheduler"].order,
        )


if __name__ == "__main__":
    unittest.main()
