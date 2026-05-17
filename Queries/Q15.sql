SELECT
    t.urgency_level,

    COUNT(*) AS total_cases,

    AVG(
    ABS(
        TIMESTAMPDIFF(
            MINUTE,
            t.arrival_time,
            TIMESTAMP(h.admission_date)
        )
    )
) AS avg_waiting_minutes,

    ROUND(
        100 * COUNT(h.hosp_id) / COUNT(*),
        2
    ) AS hospitalization_percentage,

    COALESCE(h.dept_name, 'NO_HOSPITALIZATION') AS department_name,

    COUNT(h.hosp_id) AS referrals_to_department

FROM Triage t

LEFT JOIN Hospitalization h
    ON t.patient_id = h.patient_id
   AND DATE(t.arrival_time) = h.admission_date

GROUP BY
    t.urgency_level,
    h.dept_name

ORDER BY
    t.urgency_level,
    referrals_to_department DESC
LIMIT 25;