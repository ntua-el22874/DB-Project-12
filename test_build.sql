USE test1;

-- ONLY FOR PROTOTYPING
DROP TABLE IF EXISTS Bed;
DROP TABLE IF EXISTS Doctor_Department;
DROP TABLE IF EXISTS Department;
DROP TABLE IF EXISTS Doctor;
DROP TABLE IF EXISTS AdminStaff;
DROP TABLE IF EXISTS Nurse;
DROP TABLE IF EXISTS Staff;


CREATE TABLE Staff (
    amka INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    surname VARCHAR(100) NOT NULL,
    age INT NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone INT NOT NULL UNIQUE,
    hire_date DATETIME NOT NULL,
    type VARCHAR(20) NOT NULL,

    PRIMARY KEY (amka),

    CHECK (age >= 0),
    CHECK (type IN ('DOCTOR', 'NURSE', 'ADMIN'))
);

CREATE TABLE Nurse (
    amka INT NOT NULL,
    rank VARCHAR(30) NOT NULL,

    PRIMARY KEY (amka),

    CHECK (rank IN ('ASS_NURSE', 'NURSE', 'ADMIN_NURSE')),

    CONSTRAINT fk_nurse_staff
        FOREIGN KEY (amka) REFERENCES Staff(amka)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE AdminStaff (
    amka INT NOT NULL,
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
    amka INT NOT NULL,
    licence_number INT NOT NULL UNIQUE,
    specialty VARCHAR(60) NOT NULL,
    rank VARCHAR(30) NOT NULL,
    supervisor_id INT,

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
    director_id INT,

    PRIMARY KEY (dept_id),

    CHECK (beds_count >= 0),

    CONSTRAINT fk_department_director
        FOREIGN KEY (director_id) REFERENCES AdminStaff(amka)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

CREATE TABLE Doctor_Department (
    doctor_id INT NOT NULL,
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

