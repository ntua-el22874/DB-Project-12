-- =========================================
-- HOSPITAL MANAGEMENT DATABASE
-- Generated from ER Diagram
-- MySQL Schema
-- =========================================

CREATE DATABASE HospitalDB;
USE HospitalDB;

-- =========================================
-- STAFF
-- =========================================

CREATE TABLE Staff (
    amka BIGINT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    age INT,
    email VARCHAR(100),
    phone VARCHAR(20),
    hire_date DATE,
    salary DECIMAL(10,2)
);

-- =========================================
-- DOCTOR
-- =========================================

CREATE TABLE Doctor (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    amka BIGINT UNIQUE,
    specialty VARCHAR(100),
    rank_name VARCHAR(50),
    supervisor_id INT NULL,

    FOREIGN KEY (amka) REFERENCES Staff(amka),
    FOREIGN KEY (supervisor_id) REFERENCES Doctor(doctor_id)
);

-- =========================================
-- NURSE
-- =========================================

CREATE TABLE Nurse (
    nurse_id INT AUTO_INCREMENT PRIMARY KEY,
    amka BIGINT UNIQUE,
    rank_name VARCHAR(50),

    FOREIGN KEY (amka) REFERENCES Staff(amka)
);

-- =========================================
-- DEPARTMENT
-- =========================================

CREATE TABLE Department (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    description TEXT,
    floor_number INT,
    total_beds INT
);

-- =========================================
-- BED
-- =========================================

CREATE TABLE Bed (
    bed_id INT AUTO_INCREMENT PRIMARY KEY,
    department_id INT,
    bed_number VARCHAR(20),
    status ENUM('AVAILABLE','OCCUPIED','MAINTENANCE'),

    FOREIGN KEY (department_id)
    REFERENCES Department(department_id)
);

-- =========================================
-- SHIFT
-- =========================================

CREATE TABLE ShiftSchedule (
    shift_id INT AUTO_INCREMENT PRIMARY KEY,
    shift_date DATE,
    shift_type ENUM('MORNING','AFTERNOON','NIGHT')
);

-- =========================================
-- SHIFT ASSIGNMENT
-- =========================================

CREATE TABLE ShiftAssignment (
    assignment_id INT AUTO_INCREMENT PRIMARY KEY,
    shift_id INT,
    amka BIGINT,
    role_name VARCHAR(50),

    FOREIGN KEY (shift_id)
    REFERENCES ShiftSchedule(shift_id),

    FOREIGN KEY (amka)
    REFERENCES Staff(amka)
);

-- =========================================
-- PATIENT
-- =========================================

CREATE TABLE Patient (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    amka BIGINT UNIQUE,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    gender ENUM('MALE','FEMALE','OTHER'),
    birth_date DATE,
    insurance_company VARCHAR(100),
    phone VARCHAR(20),
    address TEXT
);

-- =========================================
-- TRIAGE
-- =========================================

CREATE TABLE Triage (
    triage_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    arrival_time DATETIME,
    urgency_level INT,
    symptoms TEXT,

    FOREIGN KEY (patient_id)
    REFERENCES Patient(patient_id)
);

-- =========================================
-- HOSPITALIZATION
-- =========================================

CREATE TABLE Hospitalization (
    hospitalization_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    department_id INT,
    bed_id INT,
    admission_date DATE,
    discharge_date DATE,
    total_cost DECIMAL(10,2),

    FOREIGN KEY (patient_id)
    REFERENCES Patient(patient_id),

    FOREIGN KEY (department_id)
    REFERENCES Department(department_id),

    FOREIGN KEY (bed_id)
    REFERENCES Bed(bed_id)
);

-- =========================================
-- EXAMINATION
-- =========================================

CREATE TABLE Examination (
    examination_id INT AUTO_INCREMENT PRIMARY KEY,
    hospitalization_id INT,
    doctor_id INT,
    exam_type VARCHAR(100),
    exam_result TEXT,
    exam_cost DECIMAL(10,2),

    FOREIGN KEY (hospitalization_id)
    REFERENCES Hospitalization(hospitalization_id),

    FOREIGN KEY (doctor_id)
    REFERENCES Doctor(doctor_id)
);

-- =========================================
-- MEDICAL PROCEDURE
-- =========================================

CREATE TABLE MedicalProcedure (
    procedure_id INT AUTO_INCREMENT PRIMARY KEY,
    hospitalization_id INT,
    doctor_id INT,
    procedure_name VARCHAR(100),
    duration_minutes INT,
    procedure_cost DECIMAL(10,2),

    FOREIGN KEY (hospitalization_id)
    REFERENCES Hospitalization(hospitalization_id),

    FOREIGN KEY (doctor_id)
    REFERENCES Doctor(doctor_id)
);

-- =========================================
-- DRUG
-- =========================================

CREATE TABLE Drug (
    drug_id INT AUTO_INCREMENT PRIMARY KEY,
    drug_name VARCHAR(100),
    manufacturer VARCHAR(100)
);

-- =========================================
-- SUBSTANCE
-- =========================================

CREATE TABLE Substance (
    substance_id INT AUTO_INCREMENT PRIMARY KEY,
    substance_name VARCHAR(100)
);

-- =========================================
-- DRUG SUBSTANCE
-- =========================================

CREATE TABLE DrugSubstance (
    drug_id INT,
    substance_id INT,

    PRIMARY KEY (drug_id, substance_id),

    FOREIGN KEY (drug_id)
    REFERENCES Drug(drug_id),

    FOREIGN KEY (substance_id)
    REFERENCES Substance(substance_id)
);

-- =========================================
-- PRESCRIPTION
-- =========================================

CREATE TABLE Prescription (
    prescription_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    drug_id INT,
    dosage VARCHAR(100),
    start_date DATE,
    end_date DATE,

    FOREIGN KEY (patient_id)
    REFERENCES Patient(patient_id),

    FOREIGN KEY (doctor_id)
    REFERENCES Doctor(doctor_id),

    FOREIGN KEY (drug_id)
    REFERENCES Drug(drug_id)
);

-- =========================================
-- ALLERGY
-- =========================================

CREATE TABLE Allergy (
    allergy_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    substance_id INT,
    severity_level VARCHAR(50),

    FOREIGN KEY (patient_id)
    REFERENCES Patient(patient_id),

    FOREIGN KEY (substance_id)
    REFERENCES Substance(substance_id)
);

-- =========================================
-- PATIENT EVALUATION
-- =========================================

CREATE TABLE Evaluation (
    evaluation_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    hospitalization_id INT,
    rating INT,
    comments TEXT,
    evaluation_date DATE,

    FOREIGN KEY (patient_id)
    REFERENCES Patient(patient_id),

    FOREIGN KEY (hospitalization_id)
    REFERENCES Hospitalization(hospitalization_id)
);

-- =========================================
-- SAMPLE INDEXES
-- =========================================

CREATE INDEX idx_patient_amka
ON Patient(amka);

CREATE INDEX idx_staff_amka
ON Staff(amka);

CREATE INDEX idx_hospitalization_patient
ON Hospitalization(patient_id);

CREATE INDEX idx_prescription_patient
ON Prescription(patient_id);

-- =========================================
-- END OF DATABASE
-- =========================================