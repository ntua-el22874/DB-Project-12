SELECT 
    s1.name AS substance_1,
    s2.name AS substance_2,
    COUNT(*) AS frequency
FROM Prescription p1
JOIN Prescription p2
    ON p1.hosp_id = p2.hosp_id
    AND p1.drug_id < p2.drug_id

JOIN DrugSubstance ds1
    ON p1.drug_id = ds1.drug_id
JOIN DrugSubstance ds2
    ON p2.drug_id = ds2.drug_id

JOIN Substance s1
    ON ds1.substance_id = s1.substance_id
JOIN Substance s2
    ON ds2.substance_id = s2.substance_id

WHERE s1.substance_id < s2.substance_id

GROUP BY s1.name, s2.name
ORDER BY frequency DESC
LIMIT 3;