# Clinical Trial Data API

## Question 5 — Clinical Data API (FastAPI)

This project implements a RESTful API using **FastAPI** to serve and analyse clinical trial adverse event data.

The API provides:

* A health-check endpoint
* Dynamic adverse-event cohort filtering
* Subject-level Safety Risk Score calculation

The project uses SDTM **AE (Adverse Events)** and **DM (Demographics)** data from the `pharmaverse` examples.

---

## 1. Project Overview

The API is designed around clinical trial adverse-event data.

The SDTM AE dataset contains event-level information such as:

* `USUBJID` — Unique Subject Identifier
* `AESEV` — Severity/Intensity
* `AETERM` — Reported Term for the Adverse Event
* `AEDECOD` — Dictionary-Derived Term
* Other AE-related variables

The treatment-arm variable `ACTARM` is not part of the SDTM AE domain. It is available in the SDTM DM dataset.

Therefore, the application merges the two datasets using `USUBJID`:

```text
SDTM AE
   |
   | USUBJID
   |
   +----------> SDTM DM
                    |
                    +-- ACTARM
                         |
                         v
                  AE + ACTARM
```

This allows the API to filter adverse events by both:

* AE severity (`AESEV`)
* Actual treatment arm (`ACTARM`)

---

## 2. Data Preparation

The application loads the AE and DM datasets from the `pharmaversesdtm` GitHub repository.

### AE dataset

```text
https://raw.githubusercontent.com/pharmaverse/pharmaversesdtm/refs/heads/main/inst/extdata/ae.csv
```

### DM dataset

```text
https://raw.githubusercontent.com/pharmaverse/pharmaversesdtm/refs/heads/main/inst/extdata/dm.csv
```

The datasets are loaded using pandas:

```python
ae = pd.read_csv(url_ae)
dm = pd.read_csv(url_dm)
```

`ACTARM` is then added to the AE records using `USUBJID`:

```python
adae = ae.merge(
    dm[["USUBJID", "ACTARM"]],
    on="USUBJID",
    how="left"
)
```

A left join is used so that all AE records are retained.

> Note: The resulting `adae` object is an analysis dataset created for this API. It should not be interpreted as a formally derived CDISC ADaM ADAE dataset.

---

# 3. Requirements

The following software is required:

* Python 3.9+
* pip

The following Python packages are used:

* `pandas`
* `fastapi`
* `uvicorn`
* `pydantic`

---

# 4. Installation

## Step 1 — Clone or download the repository

Clone the repository and navigate to the Question 5 directory.

For example:

```bash
git clone <repository-url>
cd question5
```

---

## Step 2 — Create a virtual environment

Creating a virtual environment is recommended so that the project dependencies are isolated from other Python projects.

### Linux / macOS

```bash
python3 -m venv .venv
source .venv/bin/activate
```

### Windows

```bash
python -m venv .venv
.venv\Scripts\activate
```

After activation, the terminal should indicate that the `.venv` environment is active.

---

# 5. Install Dependencies

Install the required Python packages:

```bash
pip install pandas fastapi uvicorn
```

Alternatively, if a `requirements.txt` file is provided:

```bash
pip install -r requirements.txt
```

A minimal `requirements.txt` is:

```text
pandas
fastapi
uvicorn
```

---

# 6. Project Structure

The project can be organised as follows:

```text
question5/
│
├── main.py
├── requirements.txt
└── README.md
```

The main application is contained in:

```text
main.py
```

The application downloads the AE and DM datasets when the API starts.

---

# 7. Running the API Locally

From the directory containing `main.py`, run:

```bash
uvicorn main:app --reload
```

### Explanation

The command:

```bash
uvicorn main:app --reload
```

means:

* `uvicorn` — ASGI web server used to run the FastAPI application
* `main` — Python module containing the application (`main.py`)
* `app` — FastAPI application object defined as `app = FastAPI(...)`
* `--reload` — automatically reloads the application when the source code changes

The API should start at:

```text
http://127.0.0.1:8000
```

---

# 8. Test the API

FastAPI automatically generates interactive API documentation.

Open the following address in a browser:

```text
http://127.0.0.1:8000/docs
```

The Swagger UI provides an interactive interface for testing all endpoints.

---

# 9. Endpoint 1 — API Health Check

## GET `/`

Returns a message confirming that the API is running.

### Request

```http
GET /
```

### Response

```json
{
    "message": "Clinical Trial Data API is running"
}
```

---

# 10. Endpoint 2 — Dynamic AE Query

## POST `/ae-query`

This endpoint dynamically filters adverse-event records.

The API supports two optional filters:

* `severity`
* `treatment_arm`

### Input

```json
{
    "severity": ["MILD", "MODERATE"],
    "treatment_arm": "Placebo"
}
```

### Mapping to clinical variables

| API field       | Clinical variable | Dataset |
| --------------- | ----------------- | ------- |
| `severity`      | `AESEV`           | AE      |
| `treatment_arm` | `ACTARM`          | DM      |

`ACTARM` is merged into the AE dataset using `USUBJID` before the API filtering is performed.

---

## Dynamic Filtering Logic

Both filters are optional.

### Severity only

```json
{
    "severity": ["MILD", "MODERATE"]
}
```

The API applies:

```text
AESEV IN ("MILD", "MODERATE")
```

### Treatment arm only

```json
{
    "treatment_arm": "Placebo"
}
```

The API applies:

```text
ACTARM = "Placebo"
```

### Both filters

```json
{
    "severity": ["MILD", "MODERATE"],
    "treatment_arm": "Placebo"
}
```

Both criteria must be satisfied:

```text
AESEV IN ("MILD", "MODERATE")
AND
ACTARM = "Placebo"
```

### No filters

```json
{}
```

All AE records are returned.

### Null values

If a filter is `null`, it is ignored.

For example:

```json
{
    "severity": null,
    "treatment_arm": "Placebo"
}
```

Only the treatment-arm filter is applied.

---

## Response

The endpoint returns:

* The number of matching AE records
* The unique `USUBJID` values in the resulting cohort

Example:

```json
{
    "count": 12,
    "subject_ids": [
        "01-701-1015",
        "01-701-1020",
        "01-701-1032"
    ]
}
```

The `count` represents the number of matching **AE records**, while `subject_ids` contains unique subjects.

---

# 11. Endpoint 3 — Subject Safety Risk

## GET `/subject-risk/{subject_id}`

This endpoint calculates a Safety Risk Score for a specific subject.

### Example request

```http
GET /subject-risk/01-701-1015
```

The endpoint first identifies all AE records for the requested subject.

---

## Risk Score Calculation

Each AE contributes points according to its severity:

| AESEV    | Points |
| -------- | -----: |
| MILD     |      1 |
| MODERATE |      3 |
| SEVERE   |      5 |

The total risk score is the sum of all applicable AE points.

### Example

If a subject has:

```text
MILD
MODERATE
MILD
MODERATE
```

the score is:

```text
1 + 3 + 1 + 3 = 8
```

---

## Risk Categories

|        Risk Score | Risk Category |
| ----------------: | ------------- |
|             `< 5` | Low           |
| `5 <= score < 15` | Medium        |
|           `>= 15` | High          |

Therefore, a score of `8` is classified as `Medium`.

### Example response

```json
{
    "subject_id": "01-701-1015",
    "risk_score": 8,
    "risk_category": "Medium"
}
```

---

# 12. Error Handling

If the requested subject does not exist, the API returns HTTP status code `404`.

### Example

```http
GET /subject-risk/01-999-9999
```

### Response

```json
{
    "detail": "Subject '01-999-9999' not found"
}
```

HTTP status:

```text
404 Not Found
```

---

# 13. API Workflow

The overall application workflow is:

```text
             SDTM AE
                |
                |
             USUBJID
                |
                v
             SDTM DM
                |
              ACTARM
                |
                v
        AE + ACTARM dataset
                |
                v
            FastAPI
                |
       +--------+---------+
       |        |         |
       v        v         v
      GET    POST       GET
       /    /ae-query   /subject-risk/{id}
       |        |         |
       v        v         v
   Health    Dynamic    Risk Score
    Check    Cohort     Calculation
             Analysis
```

---

# 14. Example API Tests

The following requests can be tested through:

```text
http://127.0.0.1:8000/docs
```

### Test 1 — API status

```http
GET /
```

Expected:

```json
{
    "message": "Clinical Trial Data API is running"
}
```

### Test 2 — Severity filter

```json
{
    "severity": ["MILD", "MODERATE"]
}
```

### Test 3 — Treatment filter

```json
{
    "treatment_arm": "Placebo"
}
```

### Test 4 — Combined filters

```json
{
    "severity": ["MILD", "MODERATE"],
    "treatment_arm": "Placebo"
}
```

### Test 5 — Subject risk

```http
GET /subject-risk/01-701-1015
```

### Test 6 — Unknown subject

```http
GET /subject-risk/01-999-9999
```

Expected HTTP status:

```text
404
```

---

# 15. Technical Summary

This implementation demonstrates:

* REST API development with FastAPI
* Pydantic request validation
* Pandas clinical-data manipulation
* SDTM AE and DM data integration
* Subject-level data linkage using `USUBJID`
* Dynamic filtering using optional parameters
* Cohort identification
* Clinical-event severity weighting
* Risk-score calculation
* Risk categorisation
* HTTP error handling
* Interactive API documentation with Swagger/OpenAPI

The implementation intentionally keeps the API focused on the requirements of the assessment while maintaining a clear separation between clinical data preparation, filtering logic, and risk-score calculation.

