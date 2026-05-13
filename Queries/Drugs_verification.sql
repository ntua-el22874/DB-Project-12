--Returns each Drug and the active substances in it
SELECT
    d.drug_id,
    d.product_name,
    GROUP_CONCAT(s.name ORDER BY s.name SEPARATOR ' | ') AS substances
FROM Drug AS d
JOIN DrugSubstance AS ds
    ON d.drug_id = ds.drug_id
JOIN Substance AS s
    ON ds.substance_id = s.substance_id
GROUP BY
    d.drug_id,
    d.product_name
ORDER BY
    d.drug_id;