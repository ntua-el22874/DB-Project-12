-- cannot be run from sqltools(vscode) must be run from terminal
LOAD DATA LOCAL INFILE '/home/aris/DB/DB-Project-12/ListForDB_csv/Staff_Clean.csv'
INTO TABLE Staff 
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/home/aris/DB/DB-Project-12/ListForDB_csv/Nurse_Clean.csv' 
INTO TABLE Nurse 
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/home/aris/DB/DB-Project-12/ListForDB_csv/AdminStaff_Clean.csv'
INTO TABLE AdminStaff
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/home/aris/DB/DB-Project-12/ListForDB_csv/Department_Clean.csv'
INTO TABLE Department
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/home/aris/DB/DB-Project-12/ListForDB_csv/Doctor_Clean.csv'
INTO TABLE Doctor
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/home/aris/DB/DB-Project-12/ListForDB_csv/Bed_Clean.csv'
INTO TABLE Bed
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/home/aris/DB/DB-Project-12/ListForDB_csv/Patients_Clean.csv'
INTO TABLE Patient
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/home/aris/DB/DB-Project-12/ListForDB_csv/ICD10_codes.csv'
INTO TABLE ICD10
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/home/aris/DB/DB-Project-12/ListForDB_csv/KEN_codes.csv'
INTO TABLE KEN
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/home/aris/DB/DB-Project-12/ListForDB_csv/Hospitalizations_Clean.csv'
INTO TABLE Hospitalization
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/home/aris/DB/DB-Project-12/ListForDB_csv/Hospitalization_Ratings_Clean.csv'
INTO TABLE HospitalizationRating
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
-- up to here everything loads correctly

LOAD DATA LOCAL INFILE '/home/aris/DB/DB-Project-12/ListForDB_csv/Medical_Acts_Clean.csv'
INTO TABLE MedicalProcedure
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/home/aris/DB/DB-Project-12/ListForDB_csv/Shifts_Clean.csv'
INTO TABLE Shift
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/home/aris/DB/DB-Project-12/ListForDB_csv/Substances_Clean.csv'
INTO TABLE Substance
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/home/aris/DB/DB-Project-12/ListForDB_csv/Triage_Clean.csv'
INTO TABLE Triage
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;