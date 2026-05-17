LOAD DATA LOCAL INFILE './ListForDB_csv/hospitalization.csv'
INTO TABLE Hospitalization
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(patient_id, bed_id, dept_name, admission_date, discharge_date, diagnosis_in, diagnosis_out, ken_code, total_cost);
