SELECT
    COUNT(ProcedureParticipation.role) AS number_of_surgeries,
    Staff.amka
FROM Staff JOIN ProcedureParticipation ON Staff.amka = ProcedureParticipation.amka
JOIN MedicalProcedureOp ON ProcedureParticipation.proc_id = MedicalProcedureOp.proc_id
WHERE age < 35 AND category = 'SURGICAL' AND ProcedureParticipation.role = 'MAIN_SURGEON'
GROUP BY Staff.amka
ORDER BY number_of_surgeries DESC
LIMIT 3;