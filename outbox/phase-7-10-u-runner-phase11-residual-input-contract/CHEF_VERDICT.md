# Chef verdict for phase-7-10-u-runner-phase11-residual-input-contract

- Decision : approved
- Decided at : 2026-05-08T16:39:59+02:00
- Decided by : chef-daemon (automated, France PC) [role: chef-FR]

## Re-verification on chef PC

merged phase-7-10-u-runner-phase11-residual-input-contract -> main at cf65627e7091fe77d17f5833055f712dd5969138

## Gate evidence

```
DRY-RUN: checking research diff scope; no files will be modified.
[ALLOWED] scripts/phase11_residual_input_contract.py -- ordinary non-protected change
[ALLOWED] src/bsebench_runner/residual_input_contract.py -- ordinary non-protected change
[ALLOWED] tests/test_phase11_residual_input_contract.py -- ordinary non-protected change
Research diff-scope summary: allowed=3 blocked=0 review_required=0 ledger_present=0
Research diff-scope guard passed.

tests/test_run_manifest.py::test_manifest_fails_closed_on_missing_provenance_fields PASSED [ 97%]
tests/test_run_manifest.py::test_manifest_rejects_invalid_split_and_artifact_evidence_hashes PASSED [ 97%]
tests/test_run_manifest.py::test_manifest_rejects_non_json_and_non_finite_payloads PASSED [ 97%]
tests/test_submission_smoke.py::test_submission_smoke_accepts_contract_estimator_and_writes_json PASSED [ 98%]
tests/test_submission_smoke.py::test_submission_smoke_fails_closed_on_missing_provenance PASSED [ 98%]
tests/test_submission_smoke.py::test_submission_smoke_fails_closed_on_missing_evidence PASSED [ 98%]
tests/test_submission_smoke.py::test_submission_smoke_rejects_unsupported_benchmark_claims PASSED [ 98%]
tests/test_submission_smoke.py::test_submission_smoke_rejects_non_keyword_step_contract PASSED [ 99%]
tests/test_submission_smoke.py::test_submission_smoke_requires_voltage_prediction PASSED [ 99%]
tests/test_submission_smoke.py::test_submission_smoke_rejects_non_finite_outputs PASSED [ 99%]
tests/test_submission_smoke.py::test_submission_smoke_accepts_soh_only_state_estimator PASSED [100%]

================================ tests coverage ================================
_______________ coverage: platform linux, python 3.12.3-final-0 ________________

Name                                              Stmts   Miss Branch BrPart  Cover   Missing
---------------------------------------------------------------------------------------------
src/bsebench_runner/__init__.py                      13      1      2      1    87%   77
src/bsebench_runner/aging_budget.py                 169     16     62     10    89%   78, 81-82, 88-91, 97, 122->118, 278, 281->283, 306, 310-311, 313, 317, 319, 323
src/bsebench_runner/aging_soh_predispatch.py        379     57    154     30    80%   150, 175-176, 185-186, 199, 203-204, 206, 213->211, 215-222, 241-245, 260->259, 261->260, 263, 280-285, 431, 490, 492, 515, 539, 563, 565, 567, 569, 571, 581, 583, 647, 651-657, 683-685, 695, 697, 708, 710-712
src/bsebench_runner/artifact_bundle.py              175     31     84     24    77%   38-39, 46-48, 50-52, 56, 59, 73, 80, 85, 95-96, 98, 100, 124, 128, 193, 199, 205, 221, 224, 232, 245, 248, 253, 255, 265, 275->277, 278
src/bsebench_runner/benchmark_matrix.py             150      8     40      8    92%   126, 136, 162, 195, 200, 205, 214, 256
src/bsebench_runner/blind_inputs.py                 134     20     42      5    84%   132-133, 140-141, 174-175, 187-188, 197, 201-202, 205, 211-212, 227, 268-271, 281
src/bsebench_runner/cli.py                          151     48     44     12    63%   249, 265, 270-315, 324-326, 330, 341, 351, 357-359, 362-366, 369->372, 378, 390, 400, 405-406, 410
src/bsebench_runner/compute_profile.py              148     20     34     11    82%   27-28, 42, 44, 70, 72, 74, 76, 78, 80, 105-108, 147-148, 155, 183, 253, 256
src/bsebench_runner/default_adapters.py              85      6     22      4    91%   99, 228, 245-247, 249-251
src/bsebench_runner/default_registries.py            66      3     22      2    94%   86, 132, 138
src/bsebench_runner/degraded_initialization.py       99      5     40      7    91%   53, 55, 127, 131->142, 142->exit, 145, 149
src/bsebench_runner/estimator_contract.py           107      7     42      7    91%   71, 87, 90, 95, 99, 109, 112
src/bsebench_runner/metrics.py                       46      3     22      3    91%   67, 72, 78
src/bsebench_runner/monthly_snapshot.py             184     19     76     16    87%   85, 88, 122, 135, 141, 147, 152, 158, 161, 167, 171, 181, 195, 226, 241, 320, 363-364, 366
src/bsebench_runner/orchestrator.py                 197     24     74      6    86%   105-111, 170, 174, 197, 218-219, 229-231, 298, 332-336, 380-381, 385-387
src/bsebench_runner/profile_axis.py                 228     87     98     17    60%   54-62, 70-71, 78-81, 97-117, 121-130, 143-152, 158-174, 182, 185-191, 205, 207, 209, 211, 213, 227, 247, 249, 251, 253, 284, 286, 372, 432-435, 445-451
src/bsebench_runner/profile_axis_planner.py         589    124    246     64    76%   137, 140, 150, 161, 167, 171-172, 174, 180, 183-184, 213-218, 224, 226, 233, 235->229, 260-271, 323, 327, 346, 358-374, 383-397, 406-424, 433-449, 458-479, 510, 515, 518, 526, 535, 538, 561, 565, 567, 583, 662->664, 703, 707, 711, 713, 715, 785-786, 792-793, 818, 825, 833, 841, 845, 872, 919, 982, 990, 1017, 1065, 1102, 1112, 1130, 1138, 1146, 1165-1166, 1182, 1197, 1258-1261, 1264->1255, 1284, 1289, 1361-1367, 1375, 1380, 1382, 1393->1391
src/bsebench_runner/profile_dispatch_budget.py      220     28     70      7    88%   71, 75-76, 78, 92-93, 124, 141, 145->143, 159-163, 188-189, 195, 248-265, 485-491
src/bsebench_runner/protocol_registry.py            131      5     40      5    94%   40, 90, 150, 154, 188
src/bsebench_runner/provenance_bundle.py            169     12     40      5    92%   157, 159, 173, 182-183, 227-229, 235, 261-262, 310
src/bsebench_runner/registry.py                      46      5     12      5    83%   37, 39, 44, 66, 68
src/bsebench_runner/report_claim_guard.py           128      7     58      9    91%   196->200, 198->196, 206, 209, 215, 217, 232, 234, 277
src/bsebench_runner/residual_dryrun_manifest.py     304     55    150     30    79%   76, 79-80, 85, 90-92, 101-104, 122-123, 133-134, 141-150, 155, 168-169, 180->191, 182->191, 192->201, 196-197, 198->192, 208, 210, 216-217, 222, 237, 239, 265, 278, 289-295, 297, 314, 334, 342, 349, 361, 384, 429-430, 454-456, 460, 533->535, 587
src/bsebench_runner/residual_input_contract.py      410     72    200     33    80%   63, 66-67, 76-79, 85, 88-89, 99, 109-110, 115-124, 147-148, 156, 159->163, 161->159, 177, 179, 183-184, 193, 212, 229, 260-261, 269->271, 296, 303, 308-309, 311, 320, 356-362, 364, 383, 404, 412, 419, 460-469, 488, 512-513, 522-536, 564-565, 641, 660-663, 752
src/bsebench_runner/residual_predispatch.py         235     27     92     24    84%   64, 75, 77, 79, 81, 84, 104-105, 122-124, 145, 146->148, 158, 179, 188, 213, 215, 253, 260, 262, 264, 290, 312-313, 315, 322, 323->318, 326, 416->415
src/bsebench_runner/residuals.py                    110     11     36     10    86%   26-27, 33, 39, 42, 57, 69, 71, 95, 109, 115->114, 151
src/bsebench_runner/run_manifest.py                 120      7     48      7    92%   153, 170, 173, 194, 206, 212, 226
src/bsebench_runner/submission_smoke.py             149     23     60     12    81%   52, 58, 73-74, 86, 96, 105, 135, 160, 168, 170->175, 173, 182, 190-191, 197, 211-214, 220-223
---------------------------------------------------------------------------------------------
TOTAL                                              4942    731   1910    374    82%
====================== 368 passed, 5 deselected in 31.15s ======================
87 files already formatted
All checks passed!
```

## Changed files

```
M	scripts/phase11_residual_input_contract.py
M	src/bsebench_runner/residual_input_contract.py
M	tests/test_phase11_residual_input_contract.py
```

## Cross-references

- inbox/phase-7-10-u-runner-phase11-residual-input-contract/STATUS.json (worker artifact)
- outbox/phase-7-10-u-runner-phase11-residual-input-contract/SUMMARY.md (worker SUMMARY)
- outbox/phase-7-10-u-runner-phase11-residual-input-contract/run.log.tail (worker stdout tail, if non-empty)
