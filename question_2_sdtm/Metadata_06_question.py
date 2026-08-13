# SCHEMA DEFINITION
# CDISC SDTM AE domain
# SDTMIG v3.4 FINAL
# The LLM does not know what AETERM, AESEV, AESOC, etc. mean simply from the dataframe.
# We therefore provide semantic descriptions of the relevant CDISC SDTM variables.

AE_METADATA = {
    "STUDYID": {
        "label": "Study Identifier",
        "definition": "Unique identifier for the clinical study.",
        "type": "string",
        "categorical": False,
        "examples": ["ABC123", "STUDY001"]
    },

    "DOMAIN": {
        "label": "Domain Abbreviation",
        "definition": "Two-character abbreviation identifying the domain. For the Adverse Events domain, the value is AE.",
        "type": "string",
        "categorical": True,
        "examples": ["AE"]
    },

    "USUBJID": {
        "label": "Unique Subject Identifier",
        "definition": "Identifier used to uniquely identify a subject across all studies for all applications or submissions involving the product.",
        "type": "string",
        "categorical": False,
        "examples": ["ABC123-001", "STUDY001-001-001"]
    },

    "AESEQ": {
        "label": "Sequence Number",
        "definition": "Sequence number given to ensure uniqueness of adverse event records within a subject.",
        "type": "integer",
        "categorical": False,
        "examples": [1, 2, 3]
    },

    "AESPID": {
        "label": "Sponsor-Defined Identifier",
        "definition": "Sponsor-defined identifier for the adverse event, which may correspond to a CRF line identifier or an identifier from the sponsor's operational database.",
        "type": "string",
        "categorical": False,
        "examples": ["AE-001", "A001", "AE01"]
    },

    "AETERM": {
        "label": "Reported Term for the Adverse Event",
        "definition": "Verbatim term used by the subject, investigator, or other source to describe the adverse event as collected.",
        "type": "string",
        "categorical": False,
        "examples": ["Headache", "Nausea", "Chest pain", "Fever"]
    },

    "AELLT": {
        "label": "Lowest Level Term",
        "definition": "Dictionary-derived Lowest Level Term (LLT) corresponding to the reported adverse event term, typically from MedDRA.",
        "type": "string",
        "categorical": False,
        "examples": ["Headache", "Nausea"]
    },

    "AELLTCD": {
        "label": "Lowest Level Term Code",
        "definition": "Dictionary-derived code identifying the Lowest Level Term (LLT), typically from MedDRA.",
        "type": "integer",
        "categorical": False,
        "examples": [10019211, 422587008]
    },

    "AEDECOD": {
        "label": "Dictionary-Derived Term",
        "definition": "Dictionary-derived Preferred Term (PT) used to code the reported adverse event, typically from MedDRA.",
        "type": "string",
        "categorical": False,
        "examples": ["Headache", "Nausea", "Pyrexia"]
    },

    "AEPTCD": {
        "label": "Preferred Term Code",
        "definition": "Dictionary-derived code identifying the Preferred Term (PT), typically from MedDRA.",
        "type": "integer",
        "categorical": False,
        "examples": [10019211, 10028813]
    },

    "AEHLT": {
        "label": "High Level Term",
        "definition": "Dictionary-derived High Level Term (HLT) associated with the adverse event, typically from MedDRA.",
        "type": "string",
        "categorical": False,
        "examples": ["Headaches", "Nausea and vomiting symptoms"]
    },

    "AEHLTCD": {
        "label": "High Level Term Code",
        "definition": "Dictionary-derived code identifying the High Level Term (HLT), typically from MedDRA.",
        "type": "integer",
        "categorical": False,
        "examples": [10019231, 10028817]
    },

    "AEHLGT": {
        "label": "High Level Group Term",
        "definition": "Dictionary-derived High Level Group Term (HLGT) associated with the adverse event, typically from MedDRA.",
        "type": "string",
        "categorical": False,
        "examples": ["Headaches", "Nausea and vomiting symptoms"]
    },

    "AEHLGTCD": {
        "label": "High Level Group Term Code",
        "definition": "Dictionary-derived code identifying the High Level Group Term (HLGT), typically from MedDRA.",
        "type": "integer",
        "categorical": False,
        "examples": [10019227, 10028818]
    },

    "AEBODSYS": {
        "label": "Body System or Organ Class",
        "definition": "Dictionary-derived Body System or Organ Class (SOC) used by the sponsor for the adverse event. In a multi-axial dictionary such as MedDRA, this may be the SOC selected by the sponsor for analysis.",
        "type": "string",
        "categorical": True,
        "examples": [
            "Nervous system disorders",
            "Gastrointestinal disorders",
            "Cardiac disorders",
            "Respiratory, thoracic and mediastinal disorders"
        ]
    },

    "AEBDSYCD": {
        "label": "Body System or Organ Class Code",
        "definition": "Dictionary-derived code identifying the Body System or Organ Class (SOC) used by the sponsor.",
        "type": "integer",
        "categorical": False,
        "examples": [10029205, 10017954, 10007541]
    },

    "AESOC": {
        "label": "Primary System Organ Class",
        "definition": "Dictionary-derived primary System Organ Class (SOC) for the adverse event, typically from MedDRA.",
        "type": "string",
        "categorical": True,
        "examples": [
            "Nervous system disorders",
            "Gastrointestinal disorders",
            "Cardiac disorders"
        ]
    },

    "AESOCCD": {
        "label": "Primary System Organ Class Code",
        "definition": "Dictionary-derived code identifying the primary System Organ Class (SOC), typically from MedDRA.",
        "type": "integer",
        "categorical": False,
        "examples": [10029205, 10017954, 10007541]
    },

    "AESEV": {
        "label": "Severity/Intensity",
        "definition": "Severity or intensity of the adverse event.",
        "type": "string",
        "categorical": True,
        "examples": ["MILD", "MODERATE", "SEVERE"]
    },

    "AESER": {
        "label": "Serious Event",
        "definition": "Indicates whether the adverse event is considered serious according to the applicable serious adverse event criteria.",
        "type": "string",
        "categorical": True,
        "examples": ["Y", "N"]
    },

    "AEACN": {
        "label": "Action Taken with Study Treatment",
        "definition": "Action taken with the study treatment as a result of the adverse event.",
        "type": "string",
        "categorical": True,
        "examples": [
            "DRUG WITHDRAWN",
            "DOSE REDUCED",
            "DOSE INCREASED",
            "DOSE NOT CHANGED",
            "UNKNOWN",
            "NOT APPLICABLE"
        ]
    },

    "AEREL": {
        "label": "Causality",
        "definition": "Investigator's assessment of the causal relationship between the adverse event and the study treatment.",
        "type": "string",
        "categorical": True,
        "examples": [
            "NOT RELATED",
            "UNLIKELY RELATED",
            "POSSIBLY RELATED",
            "PROBABLY RELATED",
            "RELATED"
        ]
    },

    "AEOUT": {
        "label": "Outcome of Adverse Event",
        "definition": "Outcome or status of the adverse event after it was reported.",
        "type": "string",
        "categorical": True,
        "examples": [
            "RECOVERED/RESOLVED",
            "RECOVERING/RESOLVING",
            "NOT RECOVERED/NOT RESOLVED",
            "FATAL",
            "UNKNOWN"
        ]
    },

    "AESCAN": {
        "label": "Serious Event: Cancer",
        "definition": "Indicates whether the serious adverse event was associated with the development of cancer.",
        "type": "string",
        "categorical": True,
        "examples": ["Y", "N"]
    },

    "AESCONG": {
        "label": "Serious Event: Congenital Anomaly or Birth Defect",
        "definition": "Indicates whether the serious adverse event resulted in a congenital anomaly or birth defect.",
        "type": "string",
        "categorical": True,
        "examples": ["Y", "N"]
    },

    "AESDISAB": {
        "label": "Serious Event: Disability",
        "definition": "Indicates whether the serious adverse event resulted in persistent or significant disability or incapacity.",
        "type": "string",
        "categorical": True,
        "examples": ["Y", "N"]
    },

    "AESDTH": {
        "label": "Serious Event: Death",
        "definition": "Indicates whether the serious adverse event resulted in death.",
        "type": "string",
        "categorical": True,
        "examples": ["Y", "N"]
    },

    "AESHOSP": {
        "label": "Serious Event: Hospitalization",
        "definition": "Indicates whether the serious adverse event required or prolonged hospitalization.",
        "type": "string",
        "categorical": True,
        "examples": ["Y", "N"]
    },

    "AESLIFE": {
        "label": "Serious Event: Life Threatening",
        "definition": "Indicates whether the serious adverse event was life-threatening.",
        "type": "string",
        "categorical": True,
        "examples": ["Y", "N"]
    },

    "AESOD": {
        "label": "Serious Event: Overdose",
        "definition": "Indicates whether the serious adverse event occurred in association with an overdose.",
        "type": "string",
        "categorical": True,
        "examples": ["Y", "N"]
    },

    "AEDTC": {
        "label": "Collection Date/Time",
        "definition": "Date and time when the adverse event information was collected or recorded.",
        "type": "datetime",
        "categorical": False,
        "examples": ["2024-01-15T14:30", "2024-01-15"]
    },

    "AESTDTC": {
        "label": "Start Date/Time of Adverse Event",
        "definition": "Start date and/or time of the adverse event in ISO 8601 character format.",
        "type": "datetime",
        "categorical": False,
        "examples": ["2024-01-15", "2024-01-15T14:30", "2024-01"]
    },

    "AEENDTC": {
        "label": "End Date/Time of Adverse Event",
        "definition": "End date and/or time of the adverse event in ISO 8601 character format.",
        "type": "datetime",
        "categorical": False,
        "examples": ["2024-01-20", "2024-01-20T16:45", "2024-01"]
    },

    "AESTDY": {
        "label": "Study Day of Start",
        "definition": "Study day on which the adverse event started, calculated relative to the sponsor-defined reference start date (RFSTDTC).",
        "type": "integer",
        "categorical": False,
        "examples": [1, 5, 30, -2]
    },

    "AEENDY": {
        "label": "Study Day of End",
        "definition": "Study day on which the adverse event ended, calculated relative to the sponsor-defined reference start date (RFSTDTC).",
        "type": "integer",
        "categorical": False,
        "examples": [3, 7, 35, -1]
    }
}