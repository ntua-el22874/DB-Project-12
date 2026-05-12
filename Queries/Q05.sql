SELECT
    COUNT(ProcedureParticipation.role) AS number_of_surgeries,
    Staff.amka
FROM Staff JOIN ProcedureParticipation ON Staff.amka = ProcedureParticipation.amka
JOIN MedicalProcedure ON ProcedureParticipation.proc_id = MedicalProcedure.proc_id
WHERE age < 35 AND category = 'SURGICAL' AND ProcedureParticipation.role = 'MAIN_SURGEON'
GROUP BY Staff.amka
ORDER BY number_of_surgeries DESC
LIMIT 3;