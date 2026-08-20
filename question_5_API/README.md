# Clinical Trial Data API

A RESTful API built with **FastAPI** for querying clinical adverse event data and calculating patient-level safety risk scores.

The API uses SDTM **Adverse Events (AE)** and **Demographics (DM)** data from the Pharmaverse project.

The AE and DM datasets are merged using `USUBJID` so that treatment-arm information (`ACTARM`) from DM can be used alongside adverse-event information such as `AESEV`.

---

## 1. Project Overview

This project implements a clinical data API with three endpoints:

| Method | Endpoint                     | Description                                 |
| ------ | ---------------------------- | ------------------------------------------- |
| GET    | `/`                          | API health/welcome message                  |
| POST   | `/ae-query`                  | Dynamically filter adverse-event records    |
| GET    | `/subject-risk/{subject_id}` | Calculate a subject-level safety risk score |

---

# 2. Requirements

The following are required:

* Python 3.9+
* pandas
* FastAPI
* Uvicorn

The API can be run locally without a database.

---

# 3. Project Structure

A simple project structure is:

```text
question_5_API/
│
├── main.py
├── requirements.txt
└── README.md
```

`main.py` contains the FastAPI application and data-processing logic.

---

# 4. Installation

## Create a virtual environment

It is recommended to create a dedicated Python virtual environment.

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

---

## Install dependencies

Install the required packages:

```bash
pip install pandas fastapi uvicorn
```

Alternatively, if `requirements.txt` is available:

```bash
pip install -r requirements.txt
```

A suitable `requirements.txt` is:

```text
pandas
fastapi
uvicorn
```

---

# 5. Running the API Locally

The FastAPI application is assumed to be stored in:

```text
main.py
```

Start the local development server with:

```bash
uvicorn main:app --reload
```

### Explanation

```text
uvicorn
    -> ASGI web server

main
    -> Python file main.py

app
    -> FastAPI application object

--reload
    -> Automatically reload the server when code changes
```

The API should then be available at:

```text
http://127.0.0.1:8000
```

---

# 6. Interactive API Documentation

FastAPI automatically generates interactive API documentation.

Open:

```text
http://127.0.0.1:8000/docs
```

This provides a Swagger UI where the endpoints can be tested directly from the browser.

FastAPI also provides an alternative documentation interface at:

```text
http://127.0.0.1:8000/redoc
```

---

# 8. Endpoint 1 - API Status

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

# 9. Endpoint 2 - Dynamic AE Query

## POST `/ae-query`

This endpoint dynamically filters the clinical adverse-event dataset.

The API accepts two optional filters:

* `severity`
* `treatment_arm`

### Input

```json
{
    "severity": ["MILD", "MODERATE"],
    "treatment_arm": "Placebo"
}
```

The fields map to:

```text
severity       -> AESEV
treatment_arm  -> ACTARM
```

When both filters are supplied, they are combined using **AND logic**.

Therefore:

```text
AESEV IN ("MILD", "MODERATE")
AND
ACTARM = "Placebo"
```

---

## Severity only

```json
{
    "severity": ["MILD", "MODERATE"]
}
```

Only the `AESEV` filter is applied.

---

## Treatment arm only

```json
{
    "treatment_arm": "Placebo"
}
```

Only the `ACTARM` filter is applied.

---

## No filters

```json
{}
```

All AE records are returned.

---

## Null values

If a field is `null`, that filter is ignored.

For example:

```json
{
    "severity": null,
    "treatment_arm": "Placebo"
}
```

is equivalent to applying only:

```text
ACTARM = "Placebo"
```

---

## Response

The endpoint returns the number of matching AE records and the unique subjects in the resulting cohort.

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

`count` represents the number of matching **AE records**, while `subject_ids` contains unique `USUBJID` values.

---

# 10. Endpoint 3 - Subject Safety Risk

## GET `/subject-risk/{subject_id}`

This endpoint calculates a weighted **Safety Risk Score** for a specific subject.

### Example request

```http
GET /subject-risk/01-701-1015
```

The API first filters the AE dataset for the specified `USUBJID`.

---

## Risk Score Calculation

Each adverse event receives a weight according to `AESEV`:

| AESEV    | Points |
| -------- | -----: |
| MILD     |      1 |
| MODERATE |      3 |
| SEVERE   |      5 |

The points are summed across all AE records for the subject.

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

Therefore:

```json
{
    "subject_id": "01-701-1015",
    "risk_score": 8,
    "risk_category": "Medium"
}
```

---

## Risk Categories

The following thresholds are used:

|        Risk Score | Category |
| ----------------: | -------- |
|             `< 5` | Low      |
| `5 <= score < 15` | Medium   |
|           `>= 15` | High     |

For example:

```text
Score = 3
Category = Low
```

```text
Score = 8
Category = Medium
```

```text
Score = 15
Category = High
```

---

# 11. Error Handling

If the requested subject does not exist, the API returns HTTP status `404`.

Example:

```http
GET /subject-risk/01-999-9999
```

Response:

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

# 12. Testing the API

The easiest way to test the API is through the automatically generated Swagger interface:

```text
http://127.0.0.1:8000/docs
```

Select an endpoint, click **Try it out**, provide the request parameters/body, and click **Execute**.

---

## Example API tests

### Test 1 - API status

```http
GET /
```

Expected:

```json
{
    "message": "Clinical Trial Data API is running"
}
```

---

### Test 2 - Filter by severity

```http
POST /ae-query
```

Request body:

```json
{
    "severity": ["MILD", "MODERATE"]
}
```

---

### Test 3 - Filter by treatment arm

```http
POST /ae-query
```

Request body:

```json
{
    "treatment_arm": "Placebo"
}
```

---

### Test 4 - Filter using both criteria

```http
POST /ae-query
```

Request body:

```json
{
    "severity": ["MILD", "MODERATE"],
    "treatment_arm": "Placebo"
}
```

---

### Test 5 - Calculate subject risk

```http
GET /subject-risk/01-701-1015
```

Expected response structure:

```json
{
    "subject_id": "01-701-1015",
    "risk_score": 8,
    "risk_category": "Medium"
}
```

The actual score depends on the AE records in the dataset.

---

### Test 6 - Unknown subject

```http
GET /subject-risk/01-999-9999
```

Expected:

```text
HTTP 404 Not Found
```

---

# 13. Technical Summary

The application demonstrates:

* RESTful API development with FastAPI
* Pydantic request validation
* Pandas clinical-data processing
* SDTM AE and DM data integration
* Subject-level and event-level data handling
* Dynamic cohort filtering
* JSON API responses
* HTTP error handling
* Weighted clinical risk-score calculation
* Interactive API documentation with Swagger/OpenAPI

---

# 14. Data Model

The API uses `USUBJID` as the common identifier between the SDTM AE and DM datasets.

```text
                SDTM DM
          -------------------
          USUBJID | ACTARM
          -------------------
             01-001 | Placebo
             01-002 | Treatment A
                   |
                   | USUBJID
                   |
                   v
                SDTM AE
       -------------------------
       USUBJID | AESEV | AETERM
       -------------------------
       01-001  | MILD  | Headache
       01-001  | SEVERE| Nausea
       01-002  | MILD  | Headache
                   |
                   v
             API Analysis
```

This allows treatment-arm information from DM to be used when analysing adverse events.

---

# 15. Stopping the API

To stop the local development server, press:

```text
CTRL + C
```

in the terminal running Uvicorn.

---

## License

This project was developed as part of a clinical data/API coding assessment.
