#------------------------------------------------------------------------------------------
# ConcePTION_Algorithm_Pregnancies v6 - non-interactive runner (UiO patch)
# Same steps as to_run.R; the working directory is this folder and the CDM input folder is
# given as the first argument or in the environment variable CONCEPTION_DIRINPUT.
# Usage:  Rscript to_run_noninteractive.R "<path to the ConcePTION CDM folder>/"
# Changes from the base (commit a1f4ec3): UIO_PATCH.md.
#------------------------------------------------------------------------------------------

rm(list = ls(all.names = TRUE))
.args <- commandArgs(TRUE)
.file_arg <- grep("^--file=", commandArgs(FALSE), value = TRUE)
thisdir <- if (length(.file_arg)) normalizePath(dirname(sub("^--file=", "", .file_arg[1])), winslash = "/") else getwd()
setwd(thisdir)
dirinput <- if (length(.args) >= 1) .args[1] else Sys.getenv("CONCEPTION_DIRINPUT")
if (!nzchar(dirinput)) stop("Give the ConcePTION CDM input folder as first argument or in CONCEPTION_DIRINPUT")
if (!grepl("/$", dirinput)) dirinput <- paste0(dirinput, "/")
rm(.args, .file_arg)

#load parameters
source(paste0(thisdir,"/p_parameters/01_parameters_program.R"))
source(paste0(thisdir,"/p_parameters/02_parameters_CDM.R"))
source(paste0(thisdir,"/p_parameters/03_subpopulations_restricting_meanings.R"))
source(paste0(thisdir,"/p_parameters/04_algorithms.R"))

#load parameters pregnancy
source(paste0(thisdir,"/p_parameters_pregnancy/00_parameters_pregnancy.R"))
source(paste0(thisdir,"/p_parameters_pregnancy/01_prompts.R"))
source(paste0(thisdir,"/p_parameters_pregnancy/02_itemsets.R"))
source(paste0(thisdir,"/p_parameters_pregnancy/03_concept_sets.R"))
source(paste0(thisdir,"/p_parameters_pregnancy/04_algorithms_pregnancy.R"))
source(paste0(thisdir,"/p_parameters_pregnancy/05_check_coding_system.R"))
source(paste0(thisdir,"/p_parameters_pregnancy/06_documentation_all_datasources.R"))
#source(paste0(thisdir,"/p_parameters_pregnancy/step_07_create_documentation.R")) 

#run scripts
# [UiO patch] the steps in their order; CONCEPTION_START_STEP (e.g. "step_05_03") skips the steps before it, so a run that
# stopped can continue from the intermediate files already in g_intermediate (every step from 05_03 on reads its input
# from there). Empty = all steps.
.steps <- c(
  "p_steps/step_01_1_T2.1_create_spells.R",
  "p_steps/step_01_2_T2.1_create_dates_in_PERSONS.R",
  "p_steps/step_01_3_T2.2_population_description.R",
  "p_steps_pregnancy/step_01_01_T2.1_create_prompt_datasets.R",
  "p_steps_pregnancy/step_01_02_T2.1_create_itemsets_datasets.R",
  "p_steps_pregnancy/step_01_03_T2.1_create_descendant_conceptset_datasets.R",
  "p_steps_pregnancy/step_01_04_T2.1_create_conceptset_datasets.R",
  "p_steps_pregnancy/step_02_01_T2.2_create_pregnancies_from_prompts.R",
  "p_steps_pregnancy/step_02_02_T2.2_create_pregnancies_from_conceptsets.R",
  "p_steps_pregnancy/step_02_03_T2.2_create_pregnancies_from_itemsets.R",
  "p_steps_pregnancy/step_02_04_T2.2_create_pregnancies_from_EUROCAT.R",
  "p_steps_pregnancy/step_03_01_T2.2_internal_consistency_for_prompts.R",
  "p_steps_pregnancy/step_03_02_T2.2_internal_consistency_for_conceptsets.R",
  "p_steps_pregnancy/step_03_03_T2.2_internal_consistency_for_itemsets.R",
  "p_steps_pregnancy/step_03_04_T2.2_internal_consistency_for_EUROCAT.R",
  "p_steps_pregnancy/step_04_01_T2.2_process_pregnancies_excluded.R",
  "p_steps_pregnancy/step_04_02_T2.2_create_flowchart.R",
  "p_steps_pregnancy/step_05_01_T2.3_merge_stream_of_same_person.R",
  "p_steps_pregnancy/step_05_02_T2.2_reconciliation.R",
  "p_steps_pregnancy/step_05_03_predictive_model.R",
  "p_steps_pregnancy/step_05_05_adding_PROMPT_with_missing_month.R",
  "p_steps_pregnancy/step_05_04_check_overlap.R",
  "p_steps_pregnancy/step_05_05_create_D3_final.R",
  "p_steps_pregnancy/step_06_01_sample_from_pregnancies.R",
  "p_steps_pregnancy/step_07_01_create_aggregated_tables.R",
  "p_steps_pregnancy/step_07_02_pregnancies_description.R",
  "p_steps_pregnancy/step_07_04_create_aggregated_tables_for_manuscript.R")
.start_step <- Sys.getenv("CONCEPTION_START_STEP")
.first <- if (nzchar(.start_step)) grep(.start_step, .steps, fixed = TRUE)[1] else 1L
if (is.na(.first)) stop("CONCEPTION_START_STEP '", .start_step, "' is not one of the steps")
if (.first > 1) cat("[UiO patch] starting at", .steps[.first], "(earlier steps skipped)
")
# progress written straight to a file (opened and closed on every line), so it survives a crash of R; the console
# log is buffered and loses its last part when R stops abnormally
.progress_file <- Sys.getenv("CONCEPTION_PROGRESS_FILE", paste0(thisdir, "/g_output/round3_progress.log"))
.progress <- function(...) {
  .mb <- sum(gc(verbose = FALSE)[, 2])
  .msg <- paste0(format(Sys.time()), "  ", paste0(...), "  [R memory in use: ", round(.mb / 1024, 1), " GB]")
  cat(.msg, "
", file = .progress_file, append = TRUE); cat(.msg, "
")
}
.progress("ConcePTION run started", if (.first > 1) paste0(" at ", .steps[.first]) else "")
for (.k in seq(.first, length(.steps))) {
  .progress("start  ", .steps[.k])
  .t <- system.time(source(paste0(thisdir, "/", .steps[.k])))
  .progress("finish ", .steps[.k], " (", round(.t[["elapsed"]] / 60, 1), " min)")
}
.progress("ConcePTION run finished")
