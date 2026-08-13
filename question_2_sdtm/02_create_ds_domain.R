# ============================================================
# DSX Data Scientist Coding Assessment
# Question 2: SDTM DS Domain Creation using {sdtm.oak}
# ============================================================
#
#
# Purpose:
#   Create the SDTM Disposition (DS) domain from the raw DS
#   dataset using the {sdtm.oak} package and CDISC SDTMIG v3.4
#   mapping conventions.
#
# Reference:
#   CDISC SDTM Implementation Guide (SDTMIG) v3.4
#
# Input datasets:
#   - pharmaverseraw::ds_raw
#   - pharmaversesdtm::dm
#   - CDISC controlled terminology specification
#
# Output:
#   - SDTM DS domain dataset
#
# ============================================================


# Required R packages
# install.packages(c("sdtm.oak", "dplyr", "admiral"))
# install.packages("pharmaverseraw")
# install.packages("pharmaversesdtm")

# Loading libraries
library(sdtm.oak)
library(dplyr)
library(admiral)

# Read CDISC Controlled Terminology (CT) Specification from GitHub
study_ct <- read.csv("https://raw.githubusercontent.com/pharmaverse/examples/refs/heads/main/metadata/sdtm_ct.csv")

# Read DS raw data from {pharmaverseraw}
# Convert blank character values to NA (useful especially if you're using SAS)
ds_raw <- pharmaverseraw::ds_raw
ds_raw <- admiral::convert_blanks_to_na(ds_raw)

# Read DM domain from {pharmaversesdtm} and convert blank to NA
dm <- pharmaversesdtm::dm
dm <- admiral::convert_blanks_to_na(dm)

# Generate the subject-level identifiers required by {sdtm.oak} for subsequent domain derivations.
# PATNUM is used as the subject identifier in the raw dataset.
ds_raw <- ds_raw %>%
  generate_oak_id_vars(
    pat_var = "PATNUM",
    raw_src = "ds_raw"
  )

# Create SDTM DS domain
# SDTMIG V3.4: Topic value:  DSTERM
# The first step in to derive the topic variable.

ds <-
  # Derive topic variable
  # Map DSTERM using assign_no_ct, raw_var=IT.DSTERM,tgt_var=DSTERM
  assign_no_ct(
    raw_dat = ds_raw,
    raw_var = "IT.DSTERM",
    tgt_var = "DSTERM",
    id_vars = oak_id_vars()
  ) %>%
  # Map DSSTDTC in ISO8601, raw_var=IT.DSSTDAT,tgt_var=DSSTDTC
  # "UN" and "UNK" are treated as unknown date components.
  assign_datetime(
    raw_dat = ds_raw,
    raw_var = "IT.DSSTDAT",
    tgt_var = "DSSTDTC",
    raw_fmt = c("m-d-y"),
    raw_unk = c("UN", "UNK"),
    id_vars = oak_id_vars()
  ) %>%
  # Map DSDECOD no_ct,  raw_var=IT.DSDECOD,  tgt_var=DSDECOD
  # Conditional statement where OTHERSP is missing, map IT.DSDECOD
  # directly to the standardized disposition term.
  assign_no_ct(
    raw_dat = condition_add(ds_raw, is.na(OTHERSP)),
    raw_var = "IT.DSDECOD",
    tgt_var = "DSDECOD",
    id_vars = oak_id_vars()
  ) %>%
  # Map DSCAT ct
  # If IT.DSDECOD = "Randomized", derive DSCAT as "PROTOCOL MILESTONE" using CDISC controlled terminology.
  hardcode_ct(
    raw_dat =  condition_add(ds_raw, IT.DSDECOD  == "Randomized"),
    raw_var = "IT.DSDECOD",
    tgt_var = "DSCAT",
    tgt_val = "PROTOCOL MILESTONE",
    ct_spec = study_ct,
    ct_clst = "C74558",
    id_vars = oak_id_vars()
  ) %>%
  # Map DSCAT ct
  # If IT.DSDECOD is not "Randomized" (or is missing), derive DSCAT as "DISPOSITION EVENT".
  hardcode_ct(
    raw_dat = condition_add(ds_raw, IT.DSDECOD != "Randomized" | is.na(IT.DSDECOD)),
    raw_var = "IT.DSDECOD",
    tgt_var = "DSCAT",
    tgt_val = "DISPOSITION EVENT",
    ct_spec = study_ct,
    ct_clst = "C74558",
    id_vars = oak_id_vars()
  ) %>%
  # Map OTHERSP no_ct 
  # When OTHERSP is populated, use it to derive DSDECOD
  assign_no_ct(
    raw_dat = condition_add(ds_raw, !is.na(OTHERSP)),
    raw_var = "OTHERSP",
    tgt_var = "DSDECOD",
    id_vars = oak_id_vars()
  ) %>%
  # When OTHERSP is populated, use it to derive DSTERM
  assign_no_ct(
    raw_dat = condition_add(ds_raw, !is.na(OTHERSP)),
    raw_var = "OTHERSP",
    tgt_var = "DSTERM",
    id_vars = oak_id_vars()
  ) %>%
  # When OTHERSP is populated, assign DSCAT as "OTHER EVENT"
  hardcode_no_ct(
    raw_dat = condition_add(ds_raw, !is.na(OTHERSP)),
    raw_var = "OTHERSP",
    tgt_var = "DSCAT",
    tgt_val = "OTHER EVENT",
    id_vars = oak_id_vars()
  ) %>%
  # For records where OTHERSP is missing, ensure DSTERM is
  # derived from the original IT.DSTERM source variable.
  assign_no_ct(
    raw_dat = condition_add(ds_raw, is.na(OTHERSP)),
    raw_var = "IT.DSTERM",
    tgt_var = "DSTERM",
    id_vars = oak_id_vars()
  ) %>%
  # Map DSDTC: Disposition Date/Time
  # Combine the date (DSDTCOL) and time (DSTMCOL) components
  # and convert them to the SDTM DSDTC variable in ISO 8601 format.
  assign_datetime(
    raw_dat = ds_raw,
    raw_var = c("DSDTCOL", "DSTMCOL"),
    tgt_var = "DSDTC",
    raw_fmt = c("m-d-y", "H:M"),
    raw_unk = c("UN", "UNK"),
    id_vars = oak_id_vars()
  ) %>%
  # Map VISIT 
  # Map INSTANCE to VISIT using the study-specific controlled terminology specification.
  assign_ct(
    raw_dat = ds_raw,
    raw_var = "INSTANCE",
    tgt_var = "VISIT",
    ct_spec = study_ct,
    ct_clst = "VISIT"
  ) %>%
  # Map VISITNUM
  # Map INSTANCE to VISITNUM using the study-specific controlled terminology specification.
  assign_ct(
    raw_dat = ds_raw,
    raw_var = "INSTANCE",
    tgt_var = "VISITNUM",
    ct_spec = study_ct,
    ct_clst = "VISITNUM"
  ) %>%
  # Map VISIT no_ct change Ecg to ECG
  # Apply a study-specific correction for the raw visit value "Ambul Ecg Removal" and standardize it to "AMBUL ECG REMOVAL".
  # UNSCHEDULED visit values should remain as they appear in the source data because they cannot be mapped through the CT
  hardcode_no_ct(
    raw_dat = condition_add(ds_raw, INSTANCE == "Ambul Ecg Removal"),
    raw_var = "INSTANCE",
    tgt_var = "VISIT",
    tgt_val = "AMBUL ECG REMOVAL",
    id_vars = oak_id_vars()
  ) %>%
  # Add the required SDTM identifiers and domain variables.
  #   STUDYID: Study identifier
  #   DOMAIN:   Domain identifier
  #   USUBJID:  Unique subject identifier
  dplyr::mutate(
    STUDYID = "CDISCPILOT01",
    DOMAIN = "DS",
    USUBJID = paste0("01", "-", ds_raw$PATNUM)
  ) %>%
  # Derive a unique sequence number within each subject using
  # USUBJID, DSDTC and DSDECOD as record variables.
  derive_seq(tgt_var = "DSSEQ",
               rec_vars= c("USUBJID", "DSDTC", "DSDECOD")) %>%
  # Derive the study day using DSSTDTC as the target date and
  # RFSTDTC from the DM domain as the reference date.
  derive_study_day(
      sdtm_in = .,
      dm_domain = dm,
      tgdt = "DSSTDTC",
      refdt = "RFSTDTC",
      study_day_var = "DSSTDY"
  )  %>%
  # ----------------------------------------------------------
  # Final DS Domain Structure
  # ----------------------------------------------------------
  # Final SDTM DS variables in the required order.
  # Please note: UNSCHEDULED visit values remain as they appear in the source data because they cannot be mapped through the CT
  dplyr::select("STUDYID", "DOMAIN", "USUBJID", "DSSEQ", "DSTERM", "DSDECOD", "DSCAT", 
                "VISITNUM", "VISIT", "DSDTC", "DSSTDTC", "DSSTDY")
  
    
    
  

