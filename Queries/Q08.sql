SELECT * FROM Staff
WHERE amka NOT IN (
    SELECT ShiftAssignment.amka
    FROM ShiftAssignment
    JOIN Shift ON ShiftAssignment.shift_id = Shift.shift_id
    WHERE date = '2026-05-15');