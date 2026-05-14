-- cannot be run from sqltools(vscode) must be run from terminal
--Every load instruction in this file tested on MariaDB Ver 15.1 Distrib 10.11.14-MariaDB, for debian-linux-gnu
LOAD DATA LOCAL INFILE './ListForDB_csv/Staff_Clean.csv'
INTO TABLE Staff 
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS
(amka, name, surname, age, email, phone, hire_date, type);

LOAD DATA LOCAL INFILE './ListForDB_csv/Nurse_Clean.csv' 
INTO TABLE Nurse 
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS
(amka, rank);

LOAD DATA LOCAL INFILE './ListForDB_csv/AdminStaff_Clean.csv'
INTO TABLE AdminStaff
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(amka, role, office);

LOAD DATA LOCAL INFILE './ListForDB_csv/Department_Clean.csv'
INTO TABLE Department
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(name, description, beds_count, floor, director_id);

LOAD DATA LOCAL INFILE './ListForDB_csv/Doctor_Clean.csv'
INTO TABLE Doctor
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(amka, licence_number, specialty, rank, supervisor_id);

LOAD DATA LOCAL INFILE './ListForDB_csv/Staff_Department_Clean.csv'
INTO TABLE Staff_Department
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(Staff_id, dept_id);

LOAD DATA LOCAL INFILE './ListForDB_csv/Bed_Clean.csv'
INTO TABLE Bed
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(type, status, dept_id);

LOAD DATA LOCAL INFILE './ListForDB_csv/Patients_Clean.csv'
INTO TABLE Patient
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(amka, name, surname, father_name, age, gender, weight, height, address, phone, email, job, nationality, insurance);

LOAD DATA LOCAL INFILE './ListForDB_csv/Next_of_kin_Clean.csv'
INTO TABLE Next_of_kin
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(patient_id, name, phone, realationship);

LOAD DATA LOCAL INFILE './ListForDB_csv/ICD10_codes.csv'
INTO TABLE ICD10
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(code, description);

LOAD DATA LOCAL INFILE './ListForDB_csv/KEN_codes.csv'
INTO TABLE KEN
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(ken_code, description, base_cost, avg_days);

LOAD DATA LOCAL INFILE './ListForDB_csv/Hospitalizations_Clean.csv'
INTO TABLE Hospitalization
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(patient_id, bed_id, dept_name, admission_date, discharge_date, diagnosis_in, diagnosis_out, ken_code, total_cost);

LOAD DATA LOCAL INFILE './ListForDB_csv/Hospitalization_Ratings_Clean.csv'
INTO TABLE HospitalizationRating
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(hosp_id, patient_id, medical_care, nursing_care, cleanliness, food, overall);

LOAD DATA LOCAL INFILE './ListForDB_csv/Triage_Clean.csv'
INTO TABLE Triage
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(patient_id, nurse_id, arrival_time, urgency_level, symptoms);

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
IGNORE 1 ROWS
(drug_id, substance_id);

LOAD DATA LOCAL INFILE './ListForDB_csv/Patient_Allergies_Clean.csv'
INTO TABLE PatientAllergy
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(patient_id, substance_id, reaction);

LOAD DATA LOCAL INFILE './ListForDB_csv/Prescriptions_Clean.csv'
INTO TABLE Prescription
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(doctor_id, hosp_id, drug_id, start_date, end_date, dosage, frequency);

LOAD DATA LOCAL INFILE './ListForDB_csv/Medical_acts.csv'
INTO TABLE MedicalAct
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(code, name);

LOAD DATA LOCAL INFILE './ListForDB_csv/Rooms_Clean.csv'
INTO TABLE Room
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(room_id, type);

LOAD DATA LOCAL INFILE './ListForDB_csv/Examinations_Clean.csv'
INTO TABLE Examination
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(code, type, exam_date, result, cost, hosp_id, doctor_id);

LOAD DATA LOCAL INFILE './ListForDB_csv/Medical_Procedures_Clean.csv'
INTO TABLE MedicalProcedureOp
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(proc_code, category, duration, start_datetime, cost, room_id, hosp_id);

LOAD DATA LOCAL INFILE './ListForDB_csv/Shifts_Clean.csv'
INTO TABLE Shift
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(date, type, dept);

LOAD DATA LOCAL INFILE './ListForDB_csv/Shift_Assignment_Clean.csv'
INTO TABLE ShiftAssignment
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(amka, shift_id, role);
