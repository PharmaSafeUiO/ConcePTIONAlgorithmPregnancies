# ConcePTION pregnancy algorithm 6.1-a1f4ec3-uiopatched

Base: ARS-toscana/ConcePTIONAlgorithmPregnancies, branch `version_6` at commit a1f4ec3 (14 July 2025), seven
commits after release 6.1 (release `v6.1-a1f4ec3` of this repository). Changes used for the Norwegian linked
health registries in the ConcePTION CDM (data source UOSL), marked "[UiO patch]" in the code. Changes by Saeed
Hayati and Hedvig M.E. Nordeng.

| File | Change |
|---|---|
| `p_parameters_pregnancy/03_concept_sets.R`, `p_steps_pregnancy/step_01_04_T2.1_create_conceptset_datasets.R` | Primary-care records coded in ICPC-2 are labelled `ICPC2`/`ICPC2B` in the Norwegian ConcePTION CDM and were not retrieved; they are now matched on the 3-character ICPC-2 code, ignoring case, dots and spaces |
| `p_steps_pregnancy/step_02_01_T2.2_create_pregnancies_from_prompts.R` | UOSL: birth-registry fetal deaths are stillbirths from 154 days (22+0 weeks, the gestational-age criterion of the Medical Birth Registry of Norway; birth weight is not used); base: gestational age / 7 > 22, i.e. from 155 days |
| `to_run_noninteractive.R` (new) | Runs all steps without RStudio; the CDM folder is the first argument (or `CONCEPTION_DIRINPUT`); `CONCEPTION_START_STEP` continues a stopped run from a step; `CONCEPTION_PROGRESS_FILE` names the progress log (default `g_output/round3_progress.log`) |

Run: `Rscript to_run_noninteractive.R "<path to the ConcePTION CDM folder>/"`.

## Use in the comparison of pregnancy algorithms

This release (`v6.1-a1f4ec3-uiopatched`) is the version used in the comparison of four pregnancy algorithms in
Norwegian registry data (Nordeng, Hayati, van Gelder; manuscript in preparation). It was run on the UOSL ConcePTION
CDM (version 2.2) with `to_run_noninteractive.R` and the parameters of this repository unchanged; a run that stopped
was continued from step 05_03 with its intermediate files (`CONCEPTION_START_STEP`). The comparison used
`D3_pregnancy_final` (the same pregnancies as `D3_pregnancy_reconciled`) from all data streams (the stream of each
pregnancy is given by the columns `PROMPT`, `CONCEPTSETS`, `ITEMSETS` and `EUROCAT`); pregnancies ending as
ONGOING, LOSTFU or UNF have no category in the comparison and were not compared.

## Types of pregnancy end

`type_of_pregnancy_end` in `D3_pregnancy_reconciled` (legend of `p_macro/pregnancies_description_HTML.Rmd`):

| Code | Meaning |
|---|---|
| LB | live birth |
| SB | stillbirth |
| SA | spontaneous abortion |
| T | termination (induced abortion) |
| ECT-MOL | ectopic pregnancy (the concept set includes ICD-10 O00 ectopic and O01 molar pregnancy) |
| ONGOING | ongoing pregnancy |
| UNK | unknown end |
| UNF | other non-live birth |
| LOSTFU | lost to follow-up (the end date lies outside the woman's observation periods, the spells of the CDM) |

## Credits

The ConcePTION pregnancy algorithm was developed by Claudia Bartolini, Rosa Gini, Giorgio Limoncella, Olga
Paoletti and Davide Messina, within the IMI ConcePTION project (Thurin et al. 2022; Limoncella et al.
2025). License: GNU Affero General Public License v3.0 (`LICENSE`), which also applies to the changes of this
release.
