SELECT
    Hospitalization.patient_id,
    Hospitalization.hosp_id,
    Hospitalization.admission_date,
    Hospitalization.total_cost,
    icd_in.description,
    icd_out.description,
    (medical_care + nursing_care + cleanliness + food + overall)/5.0 AS average_rating
FROM Hospitalization LEFT JOIN HospitalizationRating ON Hospitalization.hosp_id = HospitalizationRating.hosp_id
    LEFT JOIN ICD10 AS icd_in ON Hospitalization.diagnosis_in = icd_in.code
    LEFT JOIN ICD10 AS icd_out ON Hospitalization.diagnosis_out = icd_out.code
WHERE Hospitalization.patient_id = 79193941824 ;