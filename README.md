# DSX Data Scientist Coding Assessment

This repository contains my submission for the **Data Scientist Coding Assessment**, demonstrating practical experience across clinical data standards, statistical programming, data engineering, and Generative AI.

The repository is organised into three main projects:

1. **Question 2 - SDTM DS Domain Creation using `{sdtm.oak}`**
2. **Question 3 - ADaM ADSL Dataset Creation using `{admiral}`**
3. **Question 6 - GenAI Clinical Data Assistant**

Together, these projects demonstrate the ability to work across the clinical data lifecycle, from raw clinical data transformation and CDISC standards implementation to advanced analytics and AI-powered clinical data querying.

## Repository Structure
```
DSX-Data-Scientist-Coding-Assessment/
│
├── question_2_sdtm/
|   |
│   └── 02_create_DS_domain.R
│
├── question_3_adam/
|   |
│   └── 03_create_adsl.R
│
└── question_6_genAI/
    |
    ├── question_06_GenAI.py
    ├── question_06_test_script.ipynb
    ├── Metadate_06_question.py
    └── requirements.txt
```

## Content of each folder

### Question 2 - SDTM DS Domain Creation using {sdtm.oak}
### Folder: question_2_sdtm/

This folder contains the implementation of an SDTM DS (Disposition) domain using R. The objective is to demonstrate how clinical trial raw data can be transformed into a CDISC-compliant SDTM domain using a metadata-driven and reusable approach. In the folder, there is just one scritp file as requested. Please make sure you have all the libraries needed. 

The script demonstrates:
```
Loading raw clinical trial data
Loading CDISC Controlled Terminology
Creation of OAK identifier variables
Mapping raw variables to SDTM variables
Controlled terminology mapping
Hard-coded controlled terminology values
ISO 8601 date/time derivation
Visit and visit number derivation
Derivation of DSSEQ
Derivation of study day
Creation of the final SDTM DS dataset
```

### Question 3 – ADaM ADSL Dataset Creation
### Folder: question_3_adam/

This folder contains the R script used to create the ADaM Subject-Level Analysis Dataset (ADSL) from SDTM domains. The implementation uses the {admiral} package and demonstrates derivations commonly required for an ADSL dataset.

The script uses SDTM domains including:
```
DM – Demographics
DS – Disposition
EX – Exposure
AE – Adverse Events
VS – Vital Signs
```
The script demonstrates:
```
Creation of the ADSL dataset from SDTM DM
Treatment variable derivation
Age group derivation
Treatment start date/time derivation
Treatment end date/time derivation
ITT flag derivation
Abnormal systolic blood pressure flag derivation
Cardiac adverse event flag derivation
Last available assessment date derivation
Merging information from multiple SDTM domains
Date and date-time transformations
Subject-level derivations
```

### Question 6 – GenAI Clinical Data Assistant
### Folder: question_6_genAI/

This folder contains a Python-based Generative AI Clinical Data Assistant designed to answer natural-language questions about the CDISC SDTM Adverse Events (AE) domain.

The solution combines:
```
Python
Pandas
Pydantic
LangChain
OpenAI LLM
Architecture
CDISC SDTM AE metadata
```
The assistant translates a natural-language clinical question into a structured query and then executes that query against the AE dataset. The LLM does not directly execute Python or Pandas code. Instead, the LLM generates a constrained structured representation of the query. The Python application then validates and executes those filters deterministically using Pandas. Below there is a high-level architecture schema. 

```
  Natural-language question
            |
            v
      LLM / LangChain
            |
            v
   Pydantic QueryStructure
            |
            v
     Structured filters
            |
            v
      Pandas execution
            |
            v
 Subject count + Subject IDs
```
The Question 06 deliverable consists of four files. 

1. The main Python script ('question_06_GenAI.py') containing the implementation of the GenAI Clinical Data Assistant.
2. The Jupyter Notebook ('question_06_test_script.ipynb') is the test script for the GenAI. It runs three example natural-language queries against the SDTM AE dataset and prints the results.
3. AE dataset dictionary / metadata ('Metadata_06_question.py'). This Python file contains the metadata dictionary for the CDISC SDTM Adverse Events (AE) domain.
4. Python package requirements that contain the third-party Python packages required to run the GenAI Clinical Data Assistant.

## Video Explanation

A 2-minute video explaining the approach, design decisions,
key challenges, and lessons learned from the assessment.

[Watch the video](./video/Video_Explanation.mp4)




