WITH DoctorOperations AS (
    SELECT 
        d.amka AS doctor_id,
        s.name,
        s.surname,
        COUNT(pp.proc_id) AS total_operations
    FROM Doctor d

    JOIN Staff s
        ON d.amka = s.amka

    LEFT JOIN ProcedureParticipation pp
        ON d.amka = pp.amka
       AND pp.role = 'MAIN_SURGEON'

    LEFT JOIN MedicalProcedureOp mpo
        ON pp.proc_id = mpo.proc_id
       AND YEAR(mpo.start_datetime) = YEAR(CURDATE())

    GROUP BY d.amka, s.name, s.surname
),

MaxOperations AS (
    SELECT MAX(total_operations) AS max_ops
    FROM DoctorOperations
)

SELECT 
    dox.doctor_id,
    dox.name,
    dox.surname,
    dox.total_operations
FROM DoctorOperations dox
CROSS JOIN MaxOperations mo
WHERE dox.total_operations <= mo.max_ops - 5
ORDER BY dox.total_operations DESC;