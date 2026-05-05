USE test1;

-- ONLY FOR PROTOTYPING
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS DoctorRating;
DROP TABLE IF EXISTS HospitalizationRating;
DROP TABLE IF EXISTS ShiftAssignment;
DROP TABLE IF EXISTS Shift;
DROP TABLE IF EXISTS ProcedureParticipation;
DROP TABLE IF EXISTS MedicalProcedure;
DROP TABLE IF EXISTS PatientAllergy;
DROP TABLE IF EXISTS Prescription;
DROP TABLE IF EXISTS DrugSubstance;
DROP TABLE IF EXISTS Substance;
DROP TABLE IF EXISTS Drug;
DROP TABLE IF EXISTS Examination;
DROP TABLE IF EXISTS Hospitalization;
DROP TABLE IF EXISTS Triage;
DROP TABLE IF EXISTS KEN;
DROP TABLE IF EXISTS ICD10;
DROP TABLE IF EXISTS Patient;
DROP TABLE IF EXISTS Bed;
DROP TABLE IF EXISTS Doctor_Department;
DROP TABLE IF EXISTS Department;
DROP TABLE IF EXISTS Doctor;
DROP TABLE IF EXISTS AdminStaff;
DROP TABLE IF EXISTS Nurse;
DROP TABLE IF EXISTS Staff;
SET FOREIGN_KEY_CHECKS = 1;


CREATE TABLE Staff (
    amka BIGINT NOT NULL,
    name VARCHAR(100) NOT NULL,
    surname VARCHAR(100) NOT NULL,
    age INT NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone BIGINT NOT NULL UNIQUE,
    hire_date DATETIME NOT NULL,
    type VARCHAR(20) NOT NULL,

    PRIMARY KEY (amka),

    CHECK (age >= 0),
    CHECK (type IN ('DOCTOR', 'NURSE', 'ADMIN'))
);

CREATE TABLE Nurse (
    amka BIGINT NOT NULL,
    rank VARCHAR(30) NOT NULL,

    PRIMARY KEY (amka),

    CHECK (rank IN ('ASS_NURSE', 'NURSE', 'ADMIN_NURSE')),

    CONSTRAINT fk_nurse_staff
        FOREIGN KEY (amka) REFERENCES Staff(amka)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE AdminStaff (
    amka BIGINT NOT NULL,
    role VARCHAR(30) NOT NULL,
    office INT NOT NULL UNIQUE,

    PRIMARY KEY (amka),

    CHECK (role IN ('DIRECTOR', 'SECRETARY', 'ACCOUNTANT')),

    CONSTRAINT fk_admin_staff
        FOREIGN KEY (amka) REFERENCES Staff(amka)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Doctor (
    amka BIGINT NOT NULL,
    licence_number INT NOT NULL UNIQUE,
    specialty VARCHAR(60) NOT NULL,
    rank VARCHAR(30) NOT NULL,
    supervisor_id BIGINT,

    PRIMARY KEY (amka),

    CHECK (specialty IN (
        'EMERGENCY_MEDICINE_PHYSICIAN',
        'INTERNAL_MEDICINE_PHYSICIAN',
        'GENERAL_SURGEON',
        'OBSTETRICIAN_GYNECOLOGIST',
        'PEDIATRICIAN',
        'ANESTHESIOLOGIST',
        'RADIOLOGIST',
        'PATHOLOGIST',
        'CARDIOLOGIST',
        'ORTHOPEDIC_SURGEON',
        'NEUROLOGIST',
        'PSYCHIATRIST'
    )),

    CHECK (rank IN (
        'RESIDENT',
        'JUNIOR_ATTENDING',
        'SENIOR_ATTENDING',
        'DIRECTOR'
    )),

    CONSTRAINT fk_doctor_staff
        FOREIGN KEY (amka) REFERENCES Staff(amka)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_doctor_supervisor
        FOREIGN KEY (supervisor_id) REFERENCES Doctor(amka)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

CREATE TABLE Department (
    dept_id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    beds_count INT NOT NULL,
    floor INT NOT NULL,
    director_id BIGINT,

    PRIMARY KEY (dept_id),

    CHECK (beds_count >= 0),

    CONSTRAINT fk_department_director
        FOREIGN KEY (director_id) REFERENCES AdminStaff(amka)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

CREATE TABLE Doctor_Department (
    doctor_id BIGINT NOT NULL,
    dept_id INT NOT NULL,

    PRIMARY KEY (doctor_id, dept_id),

    CONSTRAINT fk_doctor_department_doctor
        FOREIGN KEY (doctor_id) REFERENCES Doctor(amka)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_doctor_department_department
        FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Bed (
    bed_id INT NOT NULL AUTO_INCREMENT,
    type VARCHAR(30) NOT NULL,
    status VARCHAR(30) NOT NULL,
    dept_id INT NOT NULL,

    PRIMARY KEY (bed_id),

    CHECK (type IN ('ICU', 'SINGLE_BED', 'MULTI_BED')),
    CHECK (status IN ('FREE', 'OCCUPIED', 'MAINTENANCE')),

    CONSTRAINT fk_bed_department
        FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Patient (
    amka BIGINT NOT NULL,
    name VARCHAR(100) NOT NULL,
    surname VARCHAR(100) NOT NULL,
    father_name VARCHAR(100) NOT NULL,
    age INT NOT NULL,
    gender VARCHAR(10) NOT NULL,
    weight FLOAT NOT NULL,
    height FLOAT NOT NULL,
    address VARCHAR(255) NOT NULL,
    phone BIGINT NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    job VARCHAR(100) NOT NULL,
    nationality VARCHAR(100) NOT NULL,
    insurance VARCHAR(30) NOT NULL,

    PRIMARY KEY (amka),

    CHECK (age >= 0),
    CHECK (gender IN ('Male', 'Female')),
    CHECK (insurance IN ('ΕΦΚΑ', 'Ιδιωτική Ασφάλεια', 'Ανασφάλιστος'))
);

CREATE TABLE ICD10 (
    code VARCHAR(10) NOT NULL,
    description TEXT NOT NULL,

    PRIMARY KEY (code)
);

CREATE TABLE KEN (
    ken_code VARCHAR(10) NOT NULL,
    base_cost DECIMAL(10,2) NOT NULL,
    avg_days INT NOT NULL,

    PRIMARY KEY (ken_code),

    CHECK (base_cost >= 0),
    CHECK (avg_days > 0)
);

CREATE TABLE Triage (
    triage_id INT NOT NULL AUTO_INCREMENT,
    arrival_time DATETIME NOT NULL,
    urgency_level INT NOT NULL,
    symptoms TEXT NOT NULL,
    patient_id BIGINT NOT NULL,
    nurse_id BIGINT NOT NULL,

    PRIMARY KEY (triage_id),

    CHECK (urgency_level BETWEEN 1 AND 5),

    CONSTRAINT fk_triage_patient
        FOREIGN KEY (patient_id) REFERENCES Patient(amka)
        ON DELETE CASCADE ON UPDATE CASCADE,

    CONSTRAINT fk_triage_nurse
        FOREIGN KEY (nurse_id) REFERENCES Nurse(amka)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Hospitalization (
    hosp_id INT NOT NULL,
    admission_date DATE NOT NULL,
    discharge_date DATE,
    total_cost DECIMAL(10,2),
    patient_id BIGINT NOT NULL,
    bed_id INT NOT NULL,
    diagnosis_in VARCHAR(10) NOT NULL,
    diagnosis_out VARCHAR(10),
    ken_code VARCHAR(10),

    PRIMARY KEY (hosp_id),

    CONSTRAINT fk_hosp_patient
        FOREIGN KEY (patient_id) REFERENCES Patient(amka)
        ON DELETE CASCADE ON UPDATE CASCADE,

    CONSTRAINT fk_hosp_bed
        FOREIGN KEY (bed_id) REFERENCES Bed(bed_id)
        ON DELETE CASCADE ON UPDATE CASCADE,

    CONSTRAINT fk_hosp_icd_in
        FOREIGN KEY (diagnosis_in) REFERENCES ICD10(code)
        ON DELETE RESTRICT ON UPDATE CASCADE,

    CONSTRAINT fk_hosp_icd_out
        FOREIGN KEY (diagnosis_out) REFERENCES ICD10(code)
        ON DELETE SET NULL ON UPDATE CASCADE,

    CONSTRAINT fk_hosp_ken
        FOREIGN KEY (ken_code) REFERENCES KEN(ken_code)
        ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE Examination (
    exam_id INT NOT NULL,
    type VARCHAR(100) NOT NULL,
    exam_date DATE NOT NULL,
    result TEXT NOT NULL,
    cost DECIMAL(10,2) NOT NULL,
    hosp_id INT NOT NULL,
    doctor_id BIGINT NOT NULL,

    PRIMARY KEY (exam_id),

    CONSTRAINT fk_exam_hosp
        FOREIGN KEY (hosp_id) REFERENCES Hospitalization(hosp_id)
        ON DELETE CASCADE ON UPDATE CASCADE,

    CONSTRAINT fk_exam_doctor
        FOREIGN KEY (doctor_id) REFERENCES Doctor(amka)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Drug (
    drug_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,

    PRIMARY KEY (drug_id)
);

CREATE TABLE Substance (
    substance_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,

    PRIMARY KEY (substance_id)
);

CREATE TABLE DrugSubstance (
    drug_id INT NOT NULL,
    substance_id INT NOT NULL,

    PRIMARY KEY (drug_id, substance_id),

    CONSTRAINT fk_ds_drug
        FOREIGN KEY (drug_id) REFERENCES Drug(drug_id)
        ON DELETE CASCADE ON UPDATE CASCADE,

    CONSTRAINT fk_ds_substance
        FOREIGN KEY (substance_id) REFERENCES Substance(substance_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Prescription (
    doctor_id BIGINT NOT NULL,
    patient_id BIGINT NOT NULL,
    drug_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    dosage VARCHAR(100) NOT NULL,
    frequency VARCHAR(100) NOT NULL,

    PRIMARY KEY (doctor_id, patient_id, drug_id, start_date),

    CONSTRAINT fk_presc_doctor
        FOREIGN KEY (doctor_id) REFERENCES Doctor(amka)
        ON DELETE CASCADE ON UPDATE CASCADE,

    CONSTRAINT fk_presc_patient
        FOREIGN KEY (patient_id) REFERENCES Patient(amka)
        ON DELETE CASCADE ON UPDATE CASCADE,

    CONSTRAINT fk_presc_drug
        FOREIGN KEY (drug_id) REFERENCES Drug(drug_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE PatientAllergy
(
    patient_id   BIGINT NOT NULL,
    substance_id INT NOT NULL,

    PRIMARY KEY (patient_id, substance_id),

    CONSTRAINT fk_allergy_patient
        FOREIGN KEY (patient_id) REFERENCES Patient (amka)
            ON DELETE CASCADE ON UPDATE CASCADE,

    CONSTRAINT fk_allergy_substance
        FOREIGN KEY (substance_id) REFERENCES Substance (substance_id)
            ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE MedicalProcedure (
    proc_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(30) NOT NULL,
    duration INT NOT NULL,
    start_datetime DATETIME NOT NULL,
    cost DECIMAL(10,2) NOT NULL,
    room_id VARCHAR(10) NOT NULL,
    hosp_id INT NOT NULL,

    PRIMARY KEY (proc_id),

    CHECK (category IN ('SURGICAL', 'DIAGNOSTIC', 'THERAPEUTIC')),
    CHECK (cost >= 0),

    CONSTRAINT fk_proc_hosp
        FOREIGN KEY (hosp_id) REFERENCES Hospitalization(hosp_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE ProcedureParticipation (
    proc_id INT NOT NULL,
    amka BIGINT NOT NULL,
    role VARCHAR(30) NOT NULL,

    PRIMARY KEY (proc_id, amka),

    CHECK (role IN ('MAIN_SURGEON', 'ASSISTANT')),

    CONSTRAINT fk_part_proc
        FOREIGN KEY (proc_id) REFERENCES MedicalProcedure(proc_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_part_staff
        FOREIGN KEY (amka) REFERENCES Staff(amka)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Shift (
    shift_id INT NOT NULL AUTO_INCREMENT,
    date DATE NOT NULL,
    type VARCHAR(20) NOT NULL,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,

    PRIMARY KEY (shift_id),

    CHECK (type IN ('MORNING', 'AFTERNOON', 'NIGHT'))
);

CREATE TABLE ShiftAssignment (
    amka BIGINT NOT NULL,
    shift_id INT NOT NULL,
    role VARCHAR(30) NOT NULL,

    PRIMARY KEY (amka, shift_id),

    CHECK (role IN ('DOCTOR', 'NURSE', 'ADMIN')),

    CONSTRAINT fk_sa_staff
        FOREIGN KEY (amka) REFERENCES Staff(amka)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_sa_shift
        FOREIGN KEY (shift_id) REFERENCES Shift(shift_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE HospitalizationRating (
    hosp_id INT NOT NULL,
    medical_care INT NOT NULL,
    nursing_care INT NOT NULL,
    cleanliness INT NOT NULL,
    food INT NOT NULL,
    overall INT NOT NULL,

    PRIMARY KEY (hosp_id),

    CHECK (medical_care BETWEEN 1 AND 5),
    CHECK (nursing_care BETWEEN 1 AND 5),
    CHECK (cleanliness BETWEEN 1 AND 5),
    CHECK (food BETWEEN 1 AND 5),
    CHECK (overall BETWEEN 1 AND 5),

    CONSTRAINT fk_rating_hosp
        FOREIGN KEY (hosp_id) REFERENCES Hospitalization(hosp_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE DoctorRating (
    patient_id BIGINT NOT NULL,
    doctor_id BIGINT NOT NULL,
    rating INT NOT NULL,

    PRIMARY KEY (patient_id, doctor_id),

    CHECK (rating BETWEEN 1 AND 5),

    CONSTRAINT fk_drating_patient
        FOREIGN KEY (patient_id) REFERENCES Patient(amka)
        ON DELETE CASCADE ON UPDATE CASCADE,

    CONSTRAINT fk_drating_doctor
        FOREIGN KEY (doctor_id) REFERENCES Doctor(amka)
        ON DELETE CASCADE ON UPDATE CASCADE
);