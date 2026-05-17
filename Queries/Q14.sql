WITH YearlyAdmissions AS (

    SELECT
        diagnosis_in AS icd_code,
        YEAR(admission_date) AS admission_year,
        COUNT(*) AS total_cases

    FROM Hospitalization

    GROUP BY
        diagnosis_in,
        YEAR(admission_date)

)

SELECT
    y1.icd_code,
    y1.admission_year AS year_1,
    y2.admission_year AS year_2,
    y1.total_cases

FROM YearlyAdmissions y1

JOIN YearlyAdmissions y2
    ON y1.icd_code = y2.icd_code
   AND y2.admission_year = y1.admission_year + 1
   AND y1.total_cases = y2.total_cases

WHERE y1.total_cases >= 5

ORDER BY
    y1.icd_code,
    y1.admission_year;