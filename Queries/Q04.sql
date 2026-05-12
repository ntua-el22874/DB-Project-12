SELECT
    AVG(HospitalizationRating.medical_care) AS average_medical_care,
    AVG(HospitalizationRating.overall) AS average_overall_experience
FROM HospitalizationRating
WHERE hosp_id IN (
    SELECT hosp_id
    FROM examination
    WHERE doctor_id = 56784597458
);