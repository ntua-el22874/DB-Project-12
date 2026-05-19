ANALYZE
SELECT
    Hospitalization.patient_id,
    Hospitalization.hosp_id,
    Hospitalization.admission_date,
    Hospitalization.total_cost,
    icd_in.description AS diagnosis_in_desc,
    icd_out.description AS diagnosis_out_desc,
    (IFNULL(medical_care,0) + IFNULL(nursing_care,0) + IFNULL(cleanliness,0) + IFNULL(food,0) + IFNULL(overall,0))/5.0 AS average_rating
FROM Hospitalization
    LEFT JOIN HospitalizationRating ON Hospitalization.hosp_id = HospitalizationRating.hosp_id
    LEFT JOIN ICD10 AS icd_in ON Hospitalization.diagnosis_in = icd_in.code
    LEFT JOIN ICD10 AS icd_out ON Hospitalization.diagnosis_out = icd_out.code
WHERE Hospitalization.patient_id = 79193941824;