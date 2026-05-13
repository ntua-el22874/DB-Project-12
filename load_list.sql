-- cannot be run from sqltools(vscode) must be run from terminal
--Every load instruction in this file tested on MariaDB Ver 15.1 Distrib 10.11.14-MariaDB, for debian-linux-gnu
LOAD DATA LOCAL INFILE './ListForDB_csv/Staff_Clean.csv'
INTO TABLE Staff 
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE './ListForDB_csv/Nurse_Clean.csv' 
INTO TABLE Nurse 
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE './ListForDB_csv/AdminStaff_Clean.csv'
INTO TABLE AdminStaff
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE './ListForDB_csv/Department_Clean.csv'
INTO TABLE Department
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE './ListForDB_csv/Doctor_Clean.csv'
INTO TABLE Doctor
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE './ListForDB_csv/Staff_Department_Clean.csv'
INTO TABLE Staff_Department
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE './ListForDB_csv/Bed_Clean.csv'
INTO TABLE Bed
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE './ListForDB_csv/Patients_Clean.csv'
INTO TABLE Patient
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE './ListForDB_csv/Next_of_kin_Clean.csv'
INTO TABLE Next_of_kin
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE './ListForDB_csv/ICD10_codes.csv'
INTO TABLE ICD10
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE './ListForDB_csv/KEN_codes.csv'
INTO TABLE KEN
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE './ListForDB_csv/Hospitalizations_Clean.csv'
INTO TABLE Hospitalization
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE './ListForDB_csv/Hospitalization_Ratings_Clean.csv'
INTO TABLE HospitalizationRating
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE './ListForDB_csv/Triage_Clean.csv'
INTO TABLE Triage
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE './ListForDB_csv/Drugs_Clean.csv'
INTO TABLE Drug
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(product_name,
route_of_administration,
product_authorisation_country,
marketing_authorisation_holder,
pharmacovigilance_system_master_file_location,
pharmacovigilance_enquiries_email_address,
pharmacovigilance_enquiries_telephone_number);

LOAD DATA LOCAL INFILE './ListForDB_csv/Substances_Clean.csv'
INTO TABLE Substance
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(name);

LOAD DATA LOCAL INFILE './ListForDB_csv/DrugSubstance_Clean.csv'
INTO TABLE DrugSubstance
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
