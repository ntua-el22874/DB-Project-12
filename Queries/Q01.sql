SELECT
    SUM(total_cost) AS total_cost,
    SUM(GREATEST(0, total_cost - base_cost)) AS total_additional_cost,
    SUM(base_cost) AS total_base_cost,
    dept_name,
    YEAR(discharge_date) AS year,
    insurance,
    Hospitalization.ken_code
FROM Hospitalization JOIN KEN ON Hospitalization.ken_code = KEN.ken_code
    JOIN Patient ON Patient.amka = Hospitalization.patient_id
GROUP BY dept_name, YEAR(discharge_date), insurance, Hospitalization.ken_code
ORDER BY dept_name, year;