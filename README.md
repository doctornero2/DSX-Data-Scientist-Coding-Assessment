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

Key {sdtm.oak} functions demonstrated include:

assign_no_ct()
assign_ct()
hardcode_ct()
hardcode_no_ct()
assign_datetime()
derive_seq()
derive_study_day()

Question 3 – ADaM ADSL Dataset Creation
Folder question_3_adam/







