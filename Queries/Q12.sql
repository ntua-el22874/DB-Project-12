SELECT 
    d.dept_id,
    d.name AS department_name,
    s.date,
    s.type AS shift_type,
    'DOCTOR' AS staff_category,
    doc.specialty AS subclass,
    COUNT(sa.amka) AS staff_count
FROM ShiftAssignment sa
JOIN Shift s
    ON sa.shift_id = s.shift_id
JOIN Department d
    ON s.dept = d.dept_id
JOIN Doctor doc
    ON sa.amka = doc.amka
WHERE s.date BETWEEN '2026-05-12' AND '2026-05-18'
GROUP BY d.dept_id, d.name, s.date, s.type, doc.specialty

UNION ALL

SELECT 
    d.dept_id,
    d.name,
    s.date,
    s.type,
    'NURSE',
    n.rank,
    COUNT(sa.amka)
FROM ShiftAssignment sa
JOIN Shift s
    ON sa.shift_id = s.shift_id
JOIN Department d
    ON s.dept = d.dept_id
JOIN Nurse n
    ON sa.amka = n.amka
WHERE s.date BETWEEN '2026-05-12' AND '2026-05-18'
GROUP BY d.dept_id, d.name, s.date, s.type, n.rank

UNION ALL

SELECT 
    d.dept_id,
    d.name,
    s.date,
    s.type,
    'ADMIN',
    a.role,
    COUNT(sa.amka)
FROM ShiftAssignment sa
JOIN Shift s
    ON sa.shift_id = s.shift_id
JOIN Department d
    ON s.dept = d.dept_id
JOIN AdminStaff a
    ON sa.amka = a.amka
WHERE s.date BETWEEN '2026-05-12' AND '2026-05-18'
GROUP BY d.dept_id, d.name, s.date, s.type, a.role

ORDER BY department_name, date, shift_type;