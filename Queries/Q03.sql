SELECT
    patient_id,
    SUM(total_cost) AS total_amount,
    COUNT(patient_id) AS times_visited,
    dept_name
FROM Hospitalization
GROUP BY patient_id, dept_name
HAVING COUNT(*) > 3;