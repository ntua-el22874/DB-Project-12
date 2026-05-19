-- (α) Κανονικό Πλάνο Εκτέλεσης (EXPLAIN ANALYZE)
-- Η βάση χρησιμοποιεί τα Primary Keys και τα Foreign Keys για γρήγορη αναζήτηση.
ANALYZE
SELECT
    AVG(HospitalizationRating.medical_care) AS average_medical_care,
    AVG(HospitalizationRating.overall) AS average_overall_experience
FROM HospitalizationRating
WHERE hosp_id IN (
    SELECT hosp_id
    FROM Examination
    WHERE doctor_id = 56784597458
);

