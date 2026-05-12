SELECT
    Doctor.specialty,
    Staff.name,
    Staff.surname,
    COUNT(DISTINCT ProcedureParticipation.proc_id) AS number_of_surgeries_as_main_surgeon,
    COUNT(DISTINCT Shift.shift_id) AS shifts
FROM Doctor JOIN Staff ON Doctor.amka = Staff.amka
    LEFT JOIN ProcedureParticipation ON Doctor.amka = ProcedureParticipation.amka AND ProcedureParticipation.role = 'MAIN_SURGEON'
    LEFT JOIN ShiftAssignment ON Doctor.amka = ShiftAssignment.amka
    LEFT JOIN Shift ON ShiftAssignment.shift_id = Shift.shift_id AND YEAR(Shift.date) = 2026
WHERE Doctor.specialty = 'GENERAL_SURGEON'
GROUP BY Doctor.amka, Staff.name, Staff.surname, Doctor.specialty;