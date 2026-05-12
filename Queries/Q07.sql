SELECT
    Substance.name,
    COUNT(DISTINCT PatientAllergy.patient_id) AS allergic_patients,
    COUNT(DISTINCT DrugSubstance.drug_id) AS drugs_count
FROM Substance LEFT JOIN PatientAllergy ON substance.substance_id = PatientAllergy.substance_id
    LEFT JOIN DrugSubstance ON Substance.substance_id = DrugSubstance.substance_id
GROUP BY Substance.name
ORDER BY allergic_patients DESC;