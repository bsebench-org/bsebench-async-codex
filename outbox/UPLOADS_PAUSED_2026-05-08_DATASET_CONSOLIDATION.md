# GLASSBOX Dataset Upload Pause

Timestamp: 2026-05-08 Europe/Paris
Owner: CTO orchestration

## Decision

All Hugging Face dataset uploads are paused immediately.

No new upload worker should be launched until the dataset registry is consolidated and reviewed line by line.

## Required Consolidation Inputs

- `DatasetNameID-ProvidingInstitutionAuthors-Chemistr.csv`
- `DatasetNameID-ProvidingInstitutionAuthors-Chemistr_part2.csv`
- `DatasetNameID-ProvidingInstitutionAuthors-Chemistr_part3.csv`
- `DatasetNameID-ProvidingInstitutionAuthors-Chemistr_part4.csv`
- `DatasetNameID-ProvidingInstitutionAuthors-Chemistr_part5.csv`
- `DatasetNameID-ProvidingInstitutionAuthors-Chemistr_part6.csv`
- `DatasetNameID-ProvidingInstitutionAuthors-Chemistr_part7.csv`
- `DatasetNameID-ProvidingInstitutionAuthors-Chemistr_part8.csv`
- `DatasetNameID-ProvidingInstitutionAuthors-Chemistr_part9.csv`
- `The Definitive Registry and Meta-Analysis of Open-Source Battery Cycling and Degradation Datasets.docx`

## Required Output Before Upload Resume

Create one consolidated dataset registry with one row per candidate dataset and explicit status:

- `uploaded`
- `duplicate`
- `download_ready`
- `needs_source_verification`
- `license_problem`
- `not_found`
- `blocked_access`
- `not_a_dataset`
- `out_of_scope`

Each row must include source evidence, current Hugging Face status, local staging status when available, and the next action.

## Guardrail

Uploads may resume only from the consolidated registry, not from ad hoc lists or informal prompts.
