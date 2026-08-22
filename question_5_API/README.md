# Clinical Trial Data API

A RESTful API built with **FastAPI** for querying clinical adverse event data and calculating patient-level safety risk scores.

The Python coding assessment reported to use the `pharmaversesdtm::ae` and in thid case the API uses SDTM **Adverse Events (AE)** and **Demographics (DM)** data from the Pharmaverse project. The AE and DM datasets are merged using `USUBJID` so that treatment-arm information (`ACTARM`) from DM can be used alongside adverse-event information such as `AESEV`.

Another solution is using the `pharmaverseadam:adae` that  contains all the info requiured.

So when you run the `uvicorn` command you will see the following input selection: 

```bash
$ uvicorn main:app --reload

DSX DATA SCIENTIST CODING ASSESSMENT
Clinical Data API
------------------------------------

Input selection:

1) pharmaversesdtm::ae   &   pharmaversesdtm::dm
2) pharmaverseadam::adae

Please choose option 1 or 2: 

```

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

---

# 7. Endpoint 1 - API Status

## GET `/`

Returns a message confirming that the API is running.

### Response

```json
{
    "message": "Clinical Trial Data API is running"
}
```

---

# 8. Endpoint 2 - Dynamic AE Query

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

When both filters are supplied, they are combined using **AND logic**. With just one filter, it returns the selected criteria or all the records when no filters are selected {}. If a field is `null`, that filter is ignored.

## Response

The endpoint returns the number of matching AE records and the unique subjects in the resulting cohort.

Example:

```json
{
    "count": 3,
    "subject_ids": [
        "01-701-1015",
        "01-701-1020",
        "01-701-1032"
    ]
}
```

`count` represents the number of matching **AE records**, while `subject_ids` contains unique `USUBJID` values.

---

# 9. Endpoint 3 - Subject Safety Risk

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

## Risk Categories

The following thresholds are used:

|        Risk Score | Category |
| ----------------: | -------- |
|             `< 5` | Low      |
| `5 <= score < 15` | Medium   |
|           `>= 15` | High     |

Therefore, in the end we have a Risk Score and a Risk Category:

```json
{
    "subject_id": "01-701-1015",
    "risk_score": 8,
    "risk_category": "Medium"
}
```

---


# 10. Error Handling

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


# 11. Technical Summary

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
