-- (β) Εναλλακτικό Πλάνο Εκτέλεσης με χρήση HINT
-- Αναγκάζουμε τη βάση να αγνοήσει το Primary Key του HospitalizationRating.
-- Αυτό θα προκαλέσει Full Table Scan και θα αυξήσει δραματικά τον χρόνο εκτέλεσης.
ANALYZE
SELECT
    AVG(HospitalizationRating.medical_care) AS average_medical_care,
    AVG(HospitalizationRating.overall) AS average_overall_experience
FROM HospitalizationRating IGNORE INDEX (PRIMARY)
WHERE hosp_id IN (
    SELECT hosp_id
    FROM Examination
    WHERE doctor_id = 56784597458
);