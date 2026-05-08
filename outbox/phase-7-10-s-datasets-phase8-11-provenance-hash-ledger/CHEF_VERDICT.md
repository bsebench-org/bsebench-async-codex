# Chef verdict for phase-7-10-s-datasets-phase8-11-provenance-hash-ledger

- Decision : approved
- Decided at : 2026-05-08T16:08:23+02:00
- Decided by : chef-daemon (automated, France PC) [role: chef-FR]

## Re-verification on chef PC

merged phase-7-10-s-datasets-phase8-11-provenance-hash-ledger -> main at f74d3267e7aadc47f6b2f8c22608decd325a0d05

## Gate evidence

```
DRY-RUN: checking research diff scope; no files will be modified.
[ALLOWED] scripts/phase8_11_provenance_hash_ledger.py -- ordinary non-protected change
[ALLOWED] src/bsebench_datasets/auditj_local_cache_manifest.py -- ordinary non-protected change
[ALLOWED] tests/test_phase8_11_provenance_hash_ledger.py -- ordinary non-protected change
Research diff-scope summary: allowed=3 blocked=0 review_required=0 ledger_present=0
Research diff-scope guard passed.

================================ tests coverage ================================
_______________ coverage: platform linux, python 3.12.3-final-0 ________________

Name                                                          Stmts   Miss Branch BrPart  Cover   Missing
---------------------------------------------------------------------------------------------------------
src/bsebench_datasets/__init__.py                                 9      0      0      0   100%
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
src/bsebench_datasets/admission.py                              124      6     24      6    92%   60, 65, 103, 105, 171, 311
src/bsebench_datasets/aging_soh_fixture_audit.py                415    134    142     34    64%   94, 109-110, 151, 153, 157, 174, 181, 204-205, 221-223, 238, 245-246, 249-251, 255, 263->266, 293->295, 301-303, 309-311, 317-319, 326-328, 341-343, 350-352, 359-361, 413, 415, 417-419, 448-463, 482-490, 520, 526, 540-572, 582, 585, 591-592, 602-626, 654-657, 669, 763-830, 848-856, 861, 877, 913-914, 969-975
src/bsebench_datasets/aging_soh_readiness.py                    765    282    240     55    60%   149, 165, 171-172, 178-179, 185-186, 193-197, 202-209, 220-230, 236-248, 252-269, 286-290, 296-299, 309-316, 345, 369, 373, 377-380, 384-505, 589-613, 619, 661-663, 669, 671, 687, 693-694, 701, 717, 724, 738-739, 749-750, 760, 764, 813, 820-821, 824-826, 830, 831->811, 840->843, 854, 883-885, 887-889, 891-893, 904-906, 919-921, 928-930, 952-954, 976, 1020-1023, 1041, 1107-1109, 1137-1179, 1198-1200, 1209-1213, 1224->1226, 1258, 1308, 1313, 1326->1328, 1489-1492, 1494-1498, 1505-1514, 1515->1518, 1521-1535, 1537-1560, 1571-1574, 1578-1604, 1647, 1649, 1661-1664, 1759, 1767, 1819-1820, 1909, 1927, 1939, 1969->1966, 2045-2051, 2057-2082
src/bsebench_datasets/auditj_local_cache_manifest.py           1073    228    368     65    76%   190, 198-201, 214, 223-224, 230-231, 237-238, 253-260, 277-287, 304, 310, 313-314, 327, 387-388, 406-452, 472-476, 495-496, 508-510, 523, 537-541, 604->602, 616-617, 619, 735-739, 745-747, 753-756, 763-766, 775, 777-778, 782, 900, 904-921, 956, 977-982, 992, 1004-1008, 1010-1020, 1022, 1029-1030, 1042, 1065, 1072, 1082-1083, 1098, 1107-1108, 1177->1187, 1184->1177, 1188, 1195, 1203, 1243, 1272-1276, 1359, 1486-1487, 1490-1491, 1501-1523, 1761-1763, 1770-1772, 1858-1860, 1894, 1912-1914, 1918-1919, 1941-1942, 2150, 2169, 2180-2182, 2200-2214, 2294, 2322, 2339, 2342, 2369-2372, 2392-2397, 2401, 2418, 2426, 2470-2482, 2496, 2504-2515, 2586->2597, 2597->2606, 2666-2681, 2880-2886, 2928-2953, 2959-2965, 2994->2996, 2999->2989, 3016-3020
src/bsebench_datasets/equipment_etl.py                          151     25     70     21    79%   87, 89, 101, 123, 139, 144, 146, 187, 191, 233, 254-255, 257, 259, 275, 282, 289, 292-293, 295, 302, 306, 309, 321, 325
src/bsebench_datasets/ground_truth.py                           170     24     56     16    81%   81, 87, 103, 148, 202-203, 211, 242, 245-246, 248, 255, 274-275, 290-291, 293, 295, 302, 312->322, 315, 319, 323-325
src/bsebench_datasets/hinf_loader_provenance.py                 240     30     88     26    82%   130-131, 140-142, 148-149, 154, 157, 163, 169, 178, 197, 214, 218, 227, 232, 248, 252, 264, 359, 365, 372, 380, 385-389, 410, 424, 442, 460, 565->572
src/bsebench_datasets/leakage_guard.py                          142      4     44      4    96%   219, 253, 257, 265
src/bsebench_datasets/loaders/__init__.py                        37     16     12      0    47%   125-155
src/bsebench_datasets/loaders/calce_a123_dyn_loader.py           70      8     16      2    88%   35-37, 61-62, 129-130, 137, 150
src/bsebench_datasets/loaders/calce_a123_legacy_loader.py        60      7     14      3    86%   36-38, 80, 106-107, 113, 125
src/bsebench_datasets/loaders/calce_inr_20r_loader.py            74     10     16      2    87%   35-37, 60-61, 74-75, 130-131, 138, 151
src/bsebench_datasets/loaders/lg_hg2_stroebl_2024_loader.py      97     13     36      8    84%   38-40, 62-63, 78, 96, 107, 112, 120, 135, 152-153, 159
src/bsebench_datasets/loaders/nasa_pcoe_loader.py                67      8     14      3    86%   66-68, 101, 104-105, 114->119, 120, 178-179
src/bsebench_datasets/loaders/nasa_rw_loader.py                  73      2     18      1    97%   75-77, 119->114
src/bsebench_datasets/loaders/panasonic_kollmeyer_loader.py      61     10     16      4    82%   35-37, 47-48, 51, 82, 95, 118-119, 125
src/bsebench_datasets/loaders/yao_tu_berlin_2024_loader.py       76     10     24      4    86%   37-39, 70-71, 86, 104, 125-126, 132, 144
src/bsebench_datasets/manifest.py                                52      0      4      0   100%
src/bsebench_datasets/monthly_catalog.py                        193     24     72     17    82%   56, 64, 125, 127, 142, 240, 247, 255-257, 269-272, 276-277, 293, 312-314, 319, 340, 346, 352, 357
src/bsebench_datasets/ocv_recalibration.py                      125     10     42      9    89%   35, 60, 137->146, 147, 189-190, 195, 238, 244, 273, 281
src/bsebench_datasets/profile_axis_readiness.py                 519    161    156     21    64%   169-170, 176-177, 183-184, 191-195, 200-207, 218-228, 234-250, 254-255, 301-304, 325, 341, 350, 361-362, 484-485, 492-494, 505-507, 518, 524-525, 532-560, 721-760, 764-781, 800-803, 808-817, 826-833, 862, 888, 911, 918, 928-929, 982-983, 1037, 1039, 1057, 1104-1106, 1108-1110, 1112-1114, 1129, 1170, 1258, 1278, 1352-1354, 1363-1382
src/bsebench_datasets/prospect.py                                61      3      0      0    95%   162-164
src/bsebench_datasets/residual_source_readiness.py              372    119    114     32    66%   76, 93-94, 100, 110-115, 119-120, 222, 229-230, 233-235, 239, 247->250, 264, 279-281, 287-289, 300-302, 310-312, 320-322, 340-342, 349-351, 361-366, 389-397, 404->424, 413, 440, 452-478, 494-496, 500-502, 505->508, 511-514, 516-518, 521-523, 536-546, 598-607, 612-615, 641-645, 658-666, 683, 780, 793, 795, 798, 869, 878-887
src/bsebench_datasets/splits.py                                  36      0      2      0   100%
src/bsebench_datasets/timeseries_harmonization.py               133     15     58     12    86%   123, 125->128, 129, 141, 168, 220, 240, 252, 261, 273, 276-277, 281, 294-295, 303
src/bsebench_datasets/timeseries_quality.py                     152     14     64     11    88%   47, 123-132, 165, 183, 216, 267, 284, 314, 320-328, 340, 346
src/bsebench_datasets/truth_inventory.py                        132     13     28      8    87%   244-245, 251, 268-269, 276, 281-282, 310, 314, 317->exit, 322, 331, 337
---------------------------------------------------------------------------------------------------------
TOTAL                                                          7065   1882   2310    456    70%
===================== 377 passed, 29 deselected in 22.50s ======================
94 files already formatted
All checks passed!
```

## Changed files

```
A	scripts/phase8_11_provenance_hash_ledger.py
M	src/bsebench_datasets/auditj_local_cache_manifest.py
A	tests/test_phase8_11_provenance_hash_ledger.py
```

## Cross-references

- inbox/phase-7-10-s-datasets-phase8-11-provenance-hash-ledger/STATUS.json (worker artifact)
- outbox/phase-7-10-s-datasets-phase8-11-provenance-hash-ledger/SUMMARY.md (worker SUMMARY)
- outbox/phase-7-10-s-datasets-phase8-11-provenance-hash-ledger/run.log.tail (worker stdout tail, if non-empty)
