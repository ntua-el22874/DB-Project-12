-- Query 4

SELECT
    AVG(HospitalizationRating.medical_care) AS average_medical_care,
    AVG(HospitalizationRating.overall) AS average_overall_experience
FROM HospitalizationRating
WHERE hosp_id IN (
    SELECT hosp_id
    FROM examination
    WHERE doctor_id = 56784597458
);

-- Query 3

SELECT
    patient_id,
    SUM(total_cost) AS total_amount,
    COUNT(patient_id) AS times_visited,
    dept_name
FROM Hospitalization
GROUP BY patient_id, dept_name
HAVING COUNT(*) > 3;

-- Query 5:

SELECT
    COUNT(ProcedureParticipation.role) AS number_of_surgeries,
    Staff.amka
FROM Staff JOIN ProcedureParticipation ON Staff.amka = ProcedureParticipation.amka
JOIN MedicalProcedure ON ProcedureParticipation.proc_id = MedicalProcedure.proc_id
WHERE age < 35 AND category = 'SURGICAL' AND ProcedureParticipation.role = 'MAIN_SURGEON'
GROUP BY Staff.amka
ORDER BY number_of_surgeries DESC
LIMIT 3;
