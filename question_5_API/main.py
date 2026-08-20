# ==============================================================================
# DSX Data Scientist Coding Assessment
# ==============================================================================
#
# Question 5 - Clinical Trial Data API
#
# Purpose:
#   Create a RESTful API using FastAPI to query clinical adverse event data.
#
# Main endpoint:
#   GET /  
#   POST /ae-query
#   GET /subject-risk/{subject_id}
#
#
# The treatment arm is obtained from DM and merged with AE using USUBJID because 
# ACTARM is subject-level information.
# ==============================================================================


# Import required libraries
import pandas as pd

from typing import List, Optional

from fastapi import FastAPI, HTTPException
from pydantic import BaseModel


# IMPORT CLINICAL DATA AND METADATA
# ---------------------------------
# GitHub raw URL containing STDM AE dataset
url1 = "https://raw.githubusercontent.com/pharmaverse/pharmaversesdtm/refs/heads/main/inst/extdata/ae.csv"
# GitHub raw URL containing STDM DM dataset (ACTARM needed)
url2 = "https://raw.githubusercontent.com/pharmaverse/pharmaversesdtm/refs/heads/main/inst/extdata/dm.csv"

# load AE & DM datasets
ae = pd.read_csv(url1)
dm = pd.read_csv(url2)

# Merge the dm [ACTARM] into the AE  (LEFT JOIN SQL)
# AE is an event-level dataset: One subject can have multiple adverse events.
# DM is a subject-level dataset: Normally one record per subject.
# USUBJID is used as the common key. Only ACTARM from DM is merged as required by the API.

adae = ae.merge(
    dm[["USUBJID", "ACTARM"]],
    on="USUBJID",
    how="left"
)

# DEFINE THE REQUEST BODY
# -----------------------
# Request model for the /ae-query endpoint.
# Both filters are optional:  {severity}, {treatment_arm}

class AEQuery(BaseModel):

    severity: Optional[List[str]] = None
    treatment_arm: Optional[str] = None


# FASTAPI APPLICATION
# ===================

app = FastAPI(
    title="Clinical Trial Data API",
    description="REST API for querying clinical adverse event data",
    version="1.0.0"
)

# GET /
# ------
# Root
# Returns the welcome message

@app.get("/")
def root():

    return {
        "message": "Clinical Trial Data API is running"
    }

# POST /ae-query
# --------------
# Dynamic filtering
# API accepts the JSON format. These are optional filters. 

@app.post("/ae-query")
def query_adverse_events(query: AEQuery):

    # Start with the complete ADAE dataset
    filtered_data = adae.copy()

    # Apply severity filter
    # If severity is provided, keep records where AESEV matches
    # one of the requested severity values.
    
    if query.severity:

        filtered_data = filtered_data[
            filtered_data["AESEV"].isin(query.severity)
        ]
    
    # Apply treatment-arm filter
    # If treatment_arm is provided, keep records where ACTARM
    # matches the requested treatment arm.
        
    if query.treatment_arm:

        filtered_data = filtered_data[
            filtered_data["ACTARM"] == query.treatment_arm
        ]
    
    # Create Response
    # "count" represents the number of matching AE records.
    # "subject_ids" contains the unique subjects in the cohort.
    
    record_count = len(filtered_data)

    subject_ids = (
        filtered_data["USUBJID"]
        .dropna()
        .unique()
        .tolist()
    )


    # Return JSON response
    return {
        "count": record_count,
        "subject_ids": subject_ids
    }
    

# GET /subject-risk/{subject_id}
# ------------------------------
# Calculate a Safety Risk Score for a specific subject.

@app.get("/subject-risk/{subject_id}")
def subject_risk(subject_id: str):
    
    # Check the subject is exists
    subj_exists = (adae['USUBJID'] == subject_id).any()
    
    # Not found -> Raise a HTTP 404 exception
    if not subj_exists:
        raise HTTPException(
            status_code=404, 
            detail=f"Subject '{subject_id}' not found"
        )
    
    # Filtering ADAE for the reqeusted subject
    subj_ae = adae[
        adae['USUBJID'] == subject_id
    ]
    
    # Define severity weights score
    severity_weights = {
        "MILD": 1,
        "MODERATE": 3,
        "SEVERE": 5
    }
    
    # AESEV Map Risk Total Points
    # Transformation function applied
    severity_points = (
        subj_ae["AESEV"]
        .map(severity_weights)
        .fillna(0)
    )
    
    # Calculate the total Risk Score
    risk_score = int(severity_points.sum())
    
    # Assign to Risk Category
    if risk_score < 5:
        risk_category = "Low"
    elif risk_score >= 15:
        risk_category = "High"
    else:
        risk_category = "Medium"
    
    # Return JSON response
    return {
        "subject_id": subject_id,
        "risk_score": risk_score,
        "risk_category": risk_category
    }
    
    