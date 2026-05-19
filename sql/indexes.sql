-- Index	Queries
-- idx_hosp_ken_year	Q1
-- idx_hosp_patient_dept	Q3, Q6
-- idx_hosp_diag_admission	Q14
-- idx_hosp_patient_admission	Q15
-- Το Q1 κάνει aggregation ανά KEN και έτος.
-- Τα Q3 και Q6 κάνουν αναζητήσεις ανά ασθενή και τμήμα.
-- Το Q14 κάνει grouping ανά ICD-10 και έτος εισαγωγής.
-- Το Q15 συνδέει triage και hospitalization μέσω patient/date.

CREATE INDEX idx_hosp_ken_year
ON Hospitalization(ken_code, discharge_date);

CREATE INDEX idx_hosp_patient_dept
ON Hospitalization(patient_id, dept_name);

CREATE INDEX idx_hosp_diag_admission
ON Hospitalization(diagnosis_in, admission_date);

CREATE INDEX idx_hosp_patient_admission
ON Hospitalization(patient_id, admission_date);



-- idx_proc_part_amka_role	Q2, Q5, Q11, Q13
-- idx_proc_part_proc_role	Q10, Q11
-- Τα περισσότερα queries φιλτράρουν συμμετοχές με role='MAIN_SURGEON'.
-- Βελτιστοποιείται το join με MedicalProcedureOp.

CREATE INDEX idx_proc_part_amka_role
ON ProcedureParticipation(amka, role);

CREATE INDEX idx_proc_part_proc_role
ON ProcedureParticipation(proc_id, role);

-- idx_medproc_datetime	Q5, Q11
-- idx_medproc_hosp	Q10
-- Τα Q5 και Q11 φιλτράρουν ανά έτος επέμβασης.
-- Το Q10 συνδέει επεμβάσεις με νοσηλείες.


CREATE INDEX idx_medproc_datetime
ON MedicalProcedureOp(start_datetime);

CREATE INDEX idx_medproc_hosp
ON MedicalProcedureOp(hosp_id);


-- idx_shift_date_type	Q8, Q12
-- idx_shift_dept	Q12
-- Τα queries φιλτράρουν βάρδιες ανά εβδομάδα και τύπο.
-- Συχνά joins με Department.

CREATE INDEX idx_shift_date_type
ON Shift(date, type);

CREATE INDEX idx_shift_dept
ON Shift(dept);


-- idx_shift_assignment_shift	Q8, Q12
-- idx_shift_assignment_amka	Q8, Q12
-- Το Q12 κάνει joins προσωπικού ανά βάρδια.
-- Το Q8 αναζητά προσωπικό χωρίς βάρδια.

CREATE INDEX idx_shift_assignment_shift
ON ShiftAssignment(shift_id);

CREATE INDEX idx_shift_assignment_amka
ON ShiftAssignment(amka);

-- idx_doctor_specialty	Q2, Q12
-- idx_doctor_supervisor	Q13
-- idx_doctor_rank	Q13
-- Το recursive query του Q13 απαιτεί γρήγορη πλοήγηση στην ιεραρχία.
-- Το Q2 κάνει filtering ανά ειδικότητα.


CREATE INDEX idx_doctor_specialty
ON Doctor(specialty);

CREATE INDEX idx_doctor_supervisor
ON Doctor(supervisor_id);

CREATE INDEX idx_doctor_rank
ON Doctor(rank);



-- idx_prescription_hosp_drug	Q10
-- idx_prescription_doctor	Q4
-- Το Q10 κάνει self joins στα prescriptions.
-- Το Q4 φιλτράρει prescriptions ανά ιατρό.
CREATE INDEX idx_prescription_hosp_drug
ON Prescription(hosp_id, drug_id);

CREATE INDEX idx_prescription_doctor
ON Prescription(doctor_id);

-- idx_drug_substance_drug	Q7, Q10
-- idx_drug_substance_substance	Q7, Q10
-- Τα queries κάνουν συνεχόμενα joins μεταξύ φαρμάκων και δραστικών ουσιών.


CREATE INDEX idx_drug_substance_drug
ON DrugSubstance(drug_id);

CREATE INDEX idx_drug_substance_substance
ON DrugSubstance(substance_id);

-- idx_patient_allergy_substance	Q7
-- Το Q7 κάνει aggregation ανά δραστική ουσία.
CREATE INDEX idx_patient_allergy_substance
ON PatientAllergy(substance_id);

-- idx_triage_patient_arrival	Q15
-- idx_triage_urgency	Q15
-- Το Q15 κάνει grouping ανά urgency level.
-- Υπάρχει join με hospitalization μέσω patient/date.

CREATE INDEX idx_triage_patient_arrival
ON Triage(patient_id, arrival_time);

CREATE INDEX idx_triage_urgency
ON Triage(urgency_level);

-- idx_staff_department_dept	Q2, Q8, Q12
-- Συχνά joins προσωπικού με τμήματα.
CREATE INDEX idx_staff_department_dept
ON Staff_Department(dept_id);



