# Chef verdict for phase-7-8-h-datasets-auditj-local-cache-manifest

- Decision : needs_fix
- Decided at : 2026-05-07T09:03:28+02:00
- Decided by : chef-daemon (automated, France PC) [role: chef-FR]

## Re-verification on chef PC

chef-side gate failure

## Gate evidence

```
tests/test_prospect_catalog.py::test_minimal_prospect_valid PASSED       [ 94%]
tests/test_prospect_catalog.py::test_prospect_rejects_bad_name PASSED    [ 95%]
tests/test_prospect_catalog.py::test_catalog_named_item_count PASSED     [ 95%]
tests/test_prospect_catalog.py::test_repository_catalog_validates PASSED [ 96%]
tests/test_split_audit_j_v1.py::test_schema_version_and_split_id PASSED  [ 96%]
tests/test_split_audit_j_v1.py::test_exactly_26_configs PASSED           [ 96%]
tests/test_split_audit_j_v1.py::test_no_duplicate_tuples PASSED          [ 97%]
tests/test_split_audit_j_v1.py::test_all_wrappers_in_audit_j_set PASSED  [ 97%]
tests/test_split_audit_j_v1.py::test_chemistry_breakdown_matches_inventory PASSED [ 98%]
tests/test_split_audit_j_v1.py::test_first_and_last_tuples_pinned PASSED [ 98%]
tests/test_split_audit_j_v1.py::test_forensic_block_complete PASSED      [ 99%]
tests/test_split_audit_j_v1.py::test_temperatures_are_within_battery_envelope PASSED [ 99%]
tests/test_split_audit_j_v1.py::test_load_split_raises_on_missing_path PASSED [100%]

================================ tests coverage ================================
_______________ coverage: platform linux, python 3.12.3-final-0 ________________

Name                                                          Stmts   Miss Branch BrPart  Cover   Missing
---------------------------------------------------------------------------------------------------------
src/bsebench_datasets/__init__.py                                 5      0      0      0   100%
src/bsebench_datasets/adapters/__init__.py                        0      0      0      0   100%
src/bsebench_datasets/adapters/calce_a123_2014.py                96      3     24      3    95%   170, 209->212, 223-224
src/bsebench_datasets/adapters/calce_inr_20r_2014.py             78      4     20      3    93%   117, 135, 148, 167
src/bsebench_datasets/adapters/empa_aurora_2025.py              213     43     84     31    72%   84, 97-111, 121, 129-130, 137, 141, 150-151, 154, 158->160, 166, 168, 173-174, 182->178, 184, 189, 193, 205, 209, 218, 235-243, 246-247, 255, 267, 288-298, 325, 342, 344, 401->404, 420, 424
src/bsebench_datasets/adapters/lg_hg2_stroebl_2024.py           168    123     50      1    21%   106, 115-118, 127-129, 133-149, 160-190, 194-196, 200, 208-272, 282-290, 310-313, 317-365, 370
src/bsebench_datasets/adapters/nasa_pcoe_2007.py                137    117     42      0    11%   85-91, 96-103, 115-126, 136-174, 190-203, 225-289
src/bsebench_datasets/adapters/nasa_rw_2014.py                  325    107    158     39    60%   70, 78, 82, 86, 103, 128-149, 164-166, 170, 173, 185-198, 202-218, 223, 230, 232-235, 246, 252, 256, 263, 281, 285, 287, 292, 297-301, 305, 307, 309, 311, 314-329, 338, 343, 347, 359-368, 387, 402, 435, 463, 475->467, 479, 524, 527-530, 548
src/bsebench_datasets/adapters/oxford_birkl_2017.py             132     15     56     10    85%   203-208, 212, 240, 251, 264, 295, 381, 391-392, 419->417, 424
src/bsebench_datasets/adapters/panasonic_kollmeyer_2018.py      109     76     34      0    23%   138-153, 157-160, 165-184, 188-218, 229, 244-272, 277
src/bsebench_datasets/adapters/sandia_preger_2020.py              3      3      0      0     0%   107-129
src/bsebench_datasets/adapters/severson_2019.py                 202    136     70      3    33%   313, 375-493, 509-524, 582-685
src/bsebench_datasets/adapters/yao_tu_berlin_2024.py            123     79     34      2    29%   80, 84, 90-92, 96-105, 109-113, 117-121, 131-139, 143-145, 149, 155-185, 201-209, 228-229, 233-266, 271
src/bsebench_datasets/auditj_local_cache_manifest.py            299     98     74     18    63%   75, 85-88, 95, 114-118, 142, 154-155, 173-219, 239-243, 262-263, 275-277, 290, 294-308, 355, 390-394, 400-402, 408-411, 418-421, 430, 432, 434, 496-498, 500-503, 518-520, 523-525, 569, 628-634, 640-658
src/bsebench_datasets/loaders/__init__.py                        37     16     12      0    47%   125-155
src/bsebench_datasets/loaders/calce_a123_dyn_loader.py           70      8     16      2    88%   35-37, 61-62, 129-130, 137, 150
src/bsebench_datasets/loaders/calce_a123_legacy_loader.py        60      7     14      3    86%   36-38, 80, 106-107, 113, 125
src/bsebench_datasets/loaders/calce_inr_20r_loader.py            74     10     16      2    87%   35-37, 60-61, 74-75, 130-131, 138, 151
src/bsebench_datasets/loaders/lg_hg2_stroebl_2024_loader.py      97     15     36     10    81%   38-40, 59, 62-63, 78, 96, 107, 112, 120, 135, 152-153, 159, 174
src/bsebench_datasets/loaders/nasa_pcoe_loader.py                67      8     14      3    86%   66-68, 101, 104-105, 114->119, 120, 178-179
src/bsebench_datasets/loaders/nasa_rw_loader.py                  73      2     18      1    97%   75-77, 119->114
src/bsebench_datasets/loaders/panasonic_kollmeyer_loader.py      61     10     16      4    82%   35-37, 47-48, 51, 82, 95, 118-119, 125
src/bsebench_datasets/loaders/yao_tu_berlin_2024_loader.py       76     12     24      6    82%   37-39, 67, 70-71, 86, 104, 125-126, 132, 144, 150
src/bsebench_datasets/manifest.py                                51      0      4      0   100%
src/bsebench_datasets/prospect.py                                61      3      0      0    95%   162-164
src/bsebench_datasets/splits.py                                  36      0      2      0   100%
---------------------------------------------------------------------------------------------------------
TOTAL                                                          2653    895    818    141    62%
===================== 227 passed, 29 deselected in 16.94s ======================
Would reformat: src/bsebench_datasets/auditj_local_cache_manifest.py
1 file would be reformatted, 58 files already formatted
```

## Changed files

```
A	scripts/auditj_local_cache_manifest.py
A	src/bsebench_datasets/auditj_local_cache_manifest.py
A	tests/test_auditj_local_cache_manifest.py
```

## Cross-references

- inbox/phase-7-8-h-datasets-auditj-local-cache-manifest/STATUS.json (worker artifact)
- outbox/phase-7-8-h-datasets-auditj-local-cache-manifest/SUMMARY.md (worker SUMMARY)
- outbox/phase-7-8-h-datasets-auditj-local-cache-manifest/run.log.tail (worker stdout tail, if non-empty)
