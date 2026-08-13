# ==============================================================================
# DSX Data Scientist Coding Assessment
# ==============================================================================
#
# Question 3: ADaM ADSL Dataset Creation
#
# Objective:
#   Create an ADaM ADSL (Subject-Level Analysis Dataset) from SDTM domains
#   using {admiral} and related pharmaverse packages.
#
# Source SDTM domains:
#   - DM: Demographics
#   - DS: Disposition
#   - EX: Exposure
#   - AE: Adverse Events
#   - VS: Vital Signs
#
# Key ADSL derivations:
#   - Age group variables (AGEGR9, AGEGR9N)
#   - Treatment start/end dates and times (TRTSDTM, TRTEDTM)
#   - Treatment start/end time imputation flags (TRTSTMF, TRTETMF)
#   - Intent-to-Treat flag (ITTFL)
#   - Abnormal systolic blood pressure flag (ABNSBPFL)
#   - Cardiac disorder flag (CARPOPFL)
#   - Last available alive date (LSTALVDT)
#
# ==============================================================================


# Install packages if they are not already installed.
# install.packages(c(
#   "admiral",
#   "dplyr",
#   "lubridate",
#   "stringr",
#   "metacore",
#   "metatools",
#   "xportr"
# ))

# libraries
library(admiral)
library(pharmaversesdtm)
library(dplyr)
library(lubridate)
library(stringr)
library(metacore)
library(metatools)
#library(xportr)

# Load the SDTM domains required to derive the ADSL dataset.
dm <- pharmaversesdtm::dm
ds <- pharmaversesdtm::ds
ex <- pharmaversesdtm::ex
ae <- pharmaversesdtm::ae
vs <- pharmaversesdtm::vs

# Optional SDTM supplemental DM domain.
# suppdm <- pharmaversesdtm::suppdm

# When a SAS dataset is imported into R using haven::read_sas(), 
# missing character values are represented as empty strings ("") rather than NA.
dm <- convert_blanks_to_na(dm)
ds <- convert_blanks_to_na(ds)
ex <- convert_blanks_to_na(ex)
ae <- convert_blanks_to_na(ae)
vs <- convert_blanks_to_na(vs)
#suppdm <- convert_blanks_to_na(suppdm)


# Optional Metadata / Specification Setup
# -------------------------------------------
# Combine dm and suppdm
# dm_suppdm <- combine_supp(dm, suppdm)
# Load ADaM specifications using {metacore}.
#
# The following section is retained as an example of how the ADSL
# specification could be loaded from an Excel metadata specification.
#
# metacore <- spec_to_metacore(
#   path = "./metadata/rpharma_specs.xlsx",
#   where_sep_sheet = FALSE,
#   quiet = TRUE
# ) %>%
#   select_dataset("ADSL")
# Load user-defined helper functions if required.
# source("exercises/adams_little_helpers.R")



# Definition of Initial ADSL dataset 
# -------------------------------------------

# Start the ADSL dataset from the SDTM DM domain.
# DM provides the subject-level foundation for ADSL, including variables such as STUDYID, USUBJID, AGE, ARM and ACTARM.
adsl <- dm %>%
  select(-DOMAIN)
# Derive planned and actual treatment variables.
adsl <- dm %>%
  mutate(TRT01P = ARM, TRT01A = ACTARM)

# Derive Age Group Variables: Map AGEGR9 and AGRGR9N
# Define the categorization used to derive AGEGR9 and AGEGR9N.
#
# AGEGR9:
#   <18   -> <18
#   18-50 -> 18-50
#   >50   -> >50
#
# AGEGR9N provides the corresponding numeric category.
agegr9_lookup <- exprs(
  ~condition,            ~AGEGR9, ~AGEGR9N,
  AGE < 18,                "<18",        1,
  between(AGE, 18, 50),  "18-50",        2,
  !is.na(AGE),             ">50",        3
)
# Apply the age-group derivation to ADSL.
adsl <- adsl %>%
  derive_vars_cat(
    definition = agegr9_lookup
  ) 

# Derivations TRTSDTM/TRTSTMF
# Convert EXSTDTC and EXENDTC from ISO 8601 character variables
# to date/time variables required for treatment derivations.
#
# Treatment start:
#   - Missing time is imputed to 00:00:00.
#   - TRTSTMF records whether time was imputed.
#
# Treatment end (this is useful for later derivation)
#   - Missing time is imputed to the end of the day.
#   - TRTETMF records whether time was imputed.
ex_ext <- ex %>%
  derive_vars_dtm(
    dtc = EXSTDTC,
    new_vars_prefix = "EXST",
    time_imputation = "00:00:00",
    flag_imputation = "time",
    ignore_seconds_flag = TRUE
  ) %>%
  derive_vars_dtm(
    dtc = EXENDTC,
    new_vars_prefix = "EXEN",
    time_imputation = "last",
    flag_imputation = "time"
  ) 

# A treatment record qualifies when:
#   - EXDOSE > 0, OR
#   - EXDOSE = 0 and the treatment is placebo and a valid exposure start date/time is available.
# Derive treatment start date
adsl <- adsl %>%
  derive_vars_merged(
    dataset_add = ex_ext,
    by_vars = exprs(STUDYID, USUBJID),
    order = exprs(EXSTDTM, EXSEQ),
    new_vars = exprs(TRTSDTM = EXSTDTM, TRTSTMF = EXSTTMF),
    filter_add = (EXDOSE > 0 | 
                 (EXDOSE == 0 &
                  str_detect(EXTRT, "PLACEBO"))) & 
                 !is.na(EXSTDTM),
    mode = "first",
  )

# Derive treatment end date (TRTEDTM) 
adsl <- adsl %>%
  derive_vars_merged(
    dataset_add = ex_ext,
    by_vars = exprs(STUDYID, USUBJID),
    order = exprs(EXENDTM, EXSEQ),
    new_vars = exprs(TRTEDTM = EXENDTM, TRTETMF = EXENTMF),
    filter_add = (EXDOSE > 0 |
                 (EXDOSE == 0 &
                 str_detect(EXTRT, "PLACEBO"))) & 
                 !is.na(EXENDTM),
    mode = "last",
  )

# Map ITTFL
# Set ITTFL to "Y" when a planned treatment assignment is available. Otherwise set ITTFL to "N".
adsl <- adsl %>%
  mutate(
    ITTFL = if_else(!is.na(ARM) & ARM != "",
      "Y",
      "N"
    )
  )

# Map ABNSBPFL
# Flag subjects with at least one systolic blood pressure measurement meeting the predefined abnormality criteria:
#   VSSTRESN >= 140 mmHg OR VSSTRESN < 100 mmHg
# The flag is derived at subject level using {admiral}.
adsl <- adsl %>%
  derive_var_merged_exist_flag(
    dataset_add = vs,
    by_vars = exprs(STUDYID, USUBJID),
    new_var = ABNSBPFL,
    condition =
      VSTESTCD == "SYSBP" &
      VSSTRESU == "mmHg" &
      (VSSTRESN >= 140 | VSSTRESN < 100),
    true_value = "Y",
    false_value = "N"
  )

# Map CARPOPFL
# Flag subjects who have at least one adverse event belonging to the "CARDIAC DISORDERS" system organ class.
adsl <- adsl %>%
  derive_var_merged_exist_flag(
    dataset_add = ae,
    by_vars = exprs(STUDYID, USUBJID),
    new_var = CARPOPFL,
    condition = toupper(AESOC) == "CARDIAC DISORDERS",
    true_value = "Y",
    false_value = NA_character_
  )

# Map LSTALVDT
# LSTALVDT is derived as the latest qualifying date across:
#   - VS: Last valid vital-sign assessment date
#   - AE: Last adverse-event start date
#   - DS: Last disposition date
#   - EX/ADSL: Treatment end date
# The process has been divided for each domain and then left-join to ADSL data set. 
# Date are compared and the max across these sources is used as LSTALVDT.

# VS: Map vs_alive date
# Convert to date 
vs_ext <- vs %>%
  derive_vars_dt(
    dtc = VSDTC,
    new_vars_prefix = "VS",
    highest_imputation = "n"
  )
# Max date for each subject
vs_alive <- vs_ext %>%
  filter(
    !is.na(VSDT),
    !(is.na(VSSTRESN) & is.na(VSSTRESC))
  ) %>%
  group_by(STUDYID, USUBJID) %>%
  summarise(
    VSLALVDT = max(VSDT),
    .groups = "drop"
  )
# AE: Map ae_alive date
# Convert to date
ae_ext <- ae %>%
  derive_vars_dt(
    dtc = AESTDTC,
    new_vars_prefix = "AEST",
    highest_imputation = "n"
  )
# Max date for each subject
ae_alive <- ae_ext %>%
  filter(!is.na(AESTDT)) %>%
  group_by(STUDYID, USUBJID) %>%
  summarise(
    AELALVDT = max(AESTDT),
    .groups = "drop"
  )
# DS: Map ds_alive date
# Convert to date
ds_ext <- ds %>%
  derive_vars_dt(
    dtc = DSSTDTC,
    new_vars_prefix = "DSST",
    highest_imputation = "n"
  )
# Max date for each subject
ds_alive <- ds_ext %>%
  filter(!is.na(DSSTDT)) %>%
  group_by(STUDYID, USUBJID) %>%
  summarise(
    DSLALVDT = max(DSSTDT),
    .groups = "drop"
  )
# Map ADSL.TRTEDTM
# new variable ADSL.TRTEDT created from ADSL.TRTEDTM (from DTM to DT conversion) 
adsl <- adsl %>%
  derive_vars_dtm_to_dt(
    source_vars = exprs(TRTEDTM)  
  )

# Alternative Left-Join data sources 
# adsl <- adsl %>%
#  left_join(vs_alive, by = c("STUDYID", "USUBJID")) %>%
#  left_join(ae_alive, by = c("STUDYID", "USUBJID")) %>%
#  left_join(ds_alive, by = c("STUDYID", "USUBJID"))

# Left-Join from {admiral}
# Merge the latest dates from VS, AE and DS into the subject-level ADSL.
adsl <- adsl %>%
  derive_vars_merged(
    dataset_add = vs_alive,
    by_vars = exprs(STUDYID, USUBJID),
    new_vars = exprs(
      VSLALVDT = VSLALVDT
    )
  ) %>%
  derive_vars_merged(
    dataset_add = ae_alive,
    by_vars = exprs(STUDYID, USUBJID),
    new_vars = exprs(
      AELALVDT = AELALVDT
    )
  ) %>%
  derive_vars_merged(
    dataset_add = ds_alive,
    by_vars = exprs(STUDYID, USUBJID),
    new_vars = exprs(
      DSLALVDT = DSLALVDT
    )
  )

# Derive LSTALVDT
# Select the latest available date across:
#   - Last valid vital-sign date
#   - Last AE start date
#   - Last disposition date
#   - Treatment end date
# If no valid date is available, LSTALVDT is set to missing.
adsl <- adsl %>%
  mutate(
    LSTALVDT = pmax(
      VSLALVDT,
      AELALVDT,
      DSLALVDT,
      TRTEDT,
      na.rm = TRUE
    ),
    LSTALVDT = if_else(
      is.infinite(as.numeric(LSTALVDT)),
      as.Date(NA),
      LSTALVDT
    )
  )

# Final ADSL Variables
# ------------------------------------------------------------------------------
# Variables required for the final ADSL dataset.
adsl <- adsl %>%
  dplyr::select("STUDYID", "USUBJID", "AGEGR9", "AGEGR9N", "TRTSDTM", "TRTSTMF",
                "ITTFL", "ABNSBPFL", "LSTALVDT", "CARPOPFL")









  
  
  
  
