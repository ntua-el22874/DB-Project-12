SELECT 
    p.amka,
    p.name,
    p.surname,
    YEAR(h.admission_date) AS hosp_year,
    DATEDIFF(h.discharge_date, h.admission_date) AS hospitalization_days,
    COUNT(*) AS same_duration_hospitalizations,
    SUM(DATEDIFF(h.discharge_date, h.admission_date)) AS total_days
FROM Patient p
JOIN Hospitalization h
    ON p.amka = h.patient_id
GROUP BY 
    p.amka,
    p.name,
    p.surname,
    YEAR(h.admission_date),
    DATEDIFF(h.discharge_date, h.admission_date)
HAVING 
    COUNT(*) > 1
    AND SUM(DATEDIFF(h.discharge_date, h.admission_date)) > 15
ORDER BY total_days DESC;