DELIMITER //

DROP TRIGGER IF EXISTS check_doctor_supervisor_insert //
CREATE TRIGGER check_doctor_supervisor_insert
BEFORE INSERT ON Doctor
FOR EACH ROW
BEGIN
    IF NEW.rank = 'RESIDENT' AND NEW.supervisor_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Σφάλμα: Οι ειδικευόμενοι πρέπει υποχρεωτικά να έχουν επόπτη.';
    END IF;
    IF NEW.rank = 'DIRECTOR' AND NEW.supervisor_id IS NOT NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Σφάλμα: Οι διευθυντές δεν μπορούν να έχουν επόπτη.';
    END IF;
END //

DROP TRIGGER IF EXISTS check_doctor_supervisor_update //
CREATE TRIGGER check_doctor_supervisor_update
BEFORE UPDATE ON Doctor
FOR EACH ROW
BEGIN
    IF NEW.rank = 'RESIDENT' AND NEW.supervisor_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Σφάλμα: Οι ειδικευόμενοι πρέπει υποχρεωτικά να έχουν επόπτη.';
    END IF;
    IF NEW.rank = 'DIRECTOR' AND NEW.supervisor_id IS NOT NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Σφάλμα: Οι διευθυντές δεν μπορούν να έχουν επόπτη.';
    END IF;
END //

DROP TRIGGER IF EXISTS check_patient_allergy_insert //
CREATE TRIGGER check_patient_allergy_insert
BEFORE INSERT ON Prescription
FOR EACH ROW
BEGIN
    DECLARE p_id BIGINT;
    DECLARE allergy_count INT;

    SELECT patient_id INTO p_id FROM Hospitalization WHERE hosp_id = NEW.hosp_id;

    SELECT COUNT(*) INTO allergy_count FROM PatientAllergy
    JOIN DrugSubstance ON PatientAllergy.substance_id = DrugSubstance.substance_id
    WHERE PatientAllergy.patient_id = p_id AND DrugSubstance.drug_id = NEW.drug_id;

    IF allergy_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Σφάλμα: Ο ασθενής έχει αλλεργία σε δραστική ουσία αυτού του φαρμάκου.';
    END IF;
END //

DROP TRIGGER IF EXISTS check_patient_allergy_update //
CREATE TRIGGER check_patient_allergy_update
BEFORE UPDATE ON Prescription
FOR EACH ROW
BEGIN
    DECLARE p_id BIGINT;
    DECLARE allergy_count INT;

    SELECT patient_id INTO p_id FROM Hospitalization WHERE hosp_id = NEW.hosp_id;

    SELECT COUNT(*) INTO allergy_count FROM PatientAllergy
    JOIN DrugSubstance ON PatientAllergy.substance_id = DrugSubstance.substance_id
    WHERE PatientAllergy.patient_id = p_id AND DrugSubstance.drug_id = NEW.drug_id;

    IF allergy_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Σφάλμα: Ο ασθενής έχει αλλεργία σε δραστική ουσία αυτού του φαρμάκου.';
    END IF;
END //

DROP TRIGGER IF EXISTS check_bed_status_insert //
CREATE TRIGGER check_bed_status_insert
BEFORE INSERT ON Hospitalization
FOR EACH ROW
BEGIN
    DECLARE current_bed_status VARCHAR(30);
    SELECT status INTO current_bed_status FROM Bed WHERE bed_id = NEW.bed_id;
    IF current_bed_status != 'FREE' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Σφάλμα: Η επιλεγμένη κλίνη δεν είναι διαθέσιμη.';
    END IF;
END //

DROP TRIGGER IF EXISTS check_bed_status_update //
CREATE TRIGGER check_bed_status_update
BEFORE UPDATE ON Hospitalization
FOR EACH ROW
BEGIN
    DECLARE current_bed_status VARCHAR(30);
    IF NEW.bed_id != OLD.bed_id THEN
        SELECT status INTO current_bed_status FROM Bed WHERE bed_id = NEW.bed_id;
        IF current_bed_status != 'FREE' THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Σφάλμα: Η επιλεγμένη κλίνη δεν είναι διαθέσιμη.';
        END IF;
    END IF;
END //

DROP TRIGGER IF EXISTS check_shift_rules_insert //
CREATE TRIGGER check_shift_rules_insert
BEFORE INSERT ON ShiftAssignment
FOR EACH ROW
BEGIN
    DECLARE violation_count INT DEFAULT 0;
    DECLARE new_type VARCHAR(20);
    DECLARE new_date DATE;

    SELECT type, date INTO new_type, new_date FROM Shift WHERE shift_id = NEW.shift_id;

    SELECT COUNT(*) INTO violation_count FROM ShiftAssignment
    JOIN Shift ON ShiftAssignment.shift_id = Shift.shift_id
    WHERE ShiftAssignment.amka = NEW.amka
      AND (
          (Shift.date = new_date AND Shift.type = new_type)
          OR (Shift.date = new_date AND new_type = 'MORNING' AND Shift.type = 'AFTERNOON')
          OR (Shift.date = new_date AND new_type = 'AFTERNOON' AND Shift.type = 'MORNING')
          OR (Shift.date = new_date AND new_type = 'AFTERNOON' AND Shift.type = 'NIGHT')
          OR (Shift.date = new_date AND new_type = 'NIGHT' AND Shift.type = 'AFTERNOON')
          OR (new_type = 'MORNING' AND Shift.type = 'NIGHT' AND Shift.date = DATE_SUB(new_date, INTERVAL 1 DAY))
          OR (new_type = 'NIGHT' AND Shift.type = 'MORNING' AND Shift.date = DATE_ADD(new_date, INTERVAL 1 DAY))
      );

    IF violation_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Σφάλμα: Παραβίαση 8ωρης ανάπαυσης ή διπλή βάρδια την ίδια ώρα.';
    END IF;
END //

DROP TRIGGER IF EXISTS check_shift_rules_update //
CREATE TRIGGER check_shift_rules_update
BEFORE UPDATE ON ShiftAssignment
FOR EACH ROW
BEGIN
    DECLARE violation_count INT DEFAULT 0;
    DECLARE new_type VARCHAR(20);
    DECLARE new_date DATE;

    SELECT type, date INTO new_type, new_date FROM Shift WHERE shift_id = NEW.shift_id;

    SELECT COUNT(*) INTO violation_count FROM ShiftAssignment
    JOIN Shift ON ShiftAssignment.shift_id = Shift.shift_id
    WHERE ShiftAssignment.amka = NEW.amka
      AND ShiftAssignment.shift_id != OLD.shift_id
      AND (
          (Shift.date = new_date AND Shift.type = new_type)
          OR (Shift.date = new_date AND new_type = 'MORNING' AND Shift.type = 'AFTERNOON')
          OR (Shift.date = new_date AND new_type = 'AFTERNOON' AND Shift.type = 'MORNING')
          OR (Shift.date = new_date AND new_type = 'AFTERNOON' AND Shift.type = 'NIGHT')
          OR (Shift.date = new_date AND new_type = 'NIGHT' AND Shift.type = 'AFTERNOON')
          OR (new_type = 'MORNING' AND Shift.type = 'NIGHT' AND Shift.date = DATE_SUB(new_date, INTERVAL 1 DAY))
          OR (new_type = 'NIGHT' AND Shift.type = 'MORNING' AND Shift.date = DATE_ADD(new_date, INTERVAL 1 DAY))
      );

    IF violation_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Σφάλμα: Παραβίαση 8ωρης ανάπαυσης ή διπλή βάρδια την ίδια ώρα.';
    END IF;
END //

DROP TRIGGER IF EXISTS check_monthly_shift_limits_insert //
CREATE TRIGGER check_monthly_shift_limits_insert
BEFORE INSERT ON ShiftAssignment
FOR EACH ROW
BEGIN
    DECLARE shift_count INT;
    DECLARE staff_role VARCHAR(20);
    DECLARE shift_month INT;
    DECLARE shift_year INT;

    SELECT type INTO staff_role FROM Staff WHERE amka = NEW.amka;
    SELECT MONTH(date), YEAR(date) INTO shift_month, shift_year FROM Shift WHERE shift_id = NEW.shift_id;

    SELECT COUNT(*) INTO shift_count FROM ShiftAssignment
    JOIN Shift ON ShiftAssignment.shift_id = Shift.shift_id
    WHERE ShiftAssignment.amka = NEW.amka AND MONTH(Shift.date) = shift_month AND YEAR(Shift.date) = shift_year;

    IF staff_role = 'DOCTOR' AND shift_count >= 15 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Σφάλμα: Ο γιατρός ξεπέρασε το όριο των 15 βαρδιών.'; END IF;
    IF staff_role = 'NURSE' AND shift_count >= 20 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Σφάλμα: Το μέλος του νοσηλευτικού προσωπικού ξεπέρασε το όριο των 20 βαρδιών.'; END IF;
    IF staff_role = 'ADMIN' AND shift_count >= 25 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Σφάλμα: Το μέλος του διοικητικού προσωπικού ξεπέρασε το όριο των 25 βαρδιών.'; END IF;
END //

DROP TRIGGER IF EXISTS check_monthly_shift_limits_update //
CREATE TRIGGER check_monthly_shift_limits_update
BEFORE UPDATE ON ShiftAssignment
FOR EACH ROW
BEGIN
    DECLARE shift_count INT;
    DECLARE staff_role VARCHAR(20);
    DECLARE shift_month INT;
    DECLARE shift_year INT;

    SELECT type INTO staff_role FROM Staff WHERE amka = NEW.amka;
    SELECT MONTH(date), YEAR(date) INTO shift_month, shift_year FROM Shift WHERE shift_id = NEW.shift_id;

    SELECT COUNT(*) INTO shift_count FROM ShiftAssignment
    JOIN Shift ON ShiftAssignment.shift_id = Shift.shift_id
    WHERE ShiftAssignment.amka = NEW.amka AND ShiftAssignment.shift_id != OLD.shift_id AND MONTH(Shift.date) = shift_month AND YEAR(Shift.date) = shift_year;

    IF staff_role = 'DOCTOR' AND shift_count >= 15 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Σφάλμα: Ο γιατρός ξεπέρασε το όριο των 15 βαρδιών.'; END IF;
    IF staff_role = 'NURSE' AND shift_count >= 20 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Σφάλμα: Το μέλος του νοσηλευτικού προσωπικού ξεπέρασε το όριο των 20 βαρδιών.'; END IF;
    IF staff_role = 'ADMIN' AND shift_count >= 25 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Σφάλμα: Το μέλος του διοικητικού προσωπικού ξεπέρασε το όριο των 25 βαρδιών.'; END IF;
END //

DROP TRIGGER IF EXISTS check_room_overlap_insert //
CREATE TRIGGER check_room_overlap_insert
BEFORE INSERT ON MedicalProcedureOp
FOR EACH ROW
BEGIN
    DECLARE overlap_count INT;
    SELECT COUNT(*) INTO overlap_count FROM MedicalProcedureOp
    WHERE room_id = NEW.room_id AND start_datetime < DATE_ADD(NEW.start_datetime, INTERVAL NEW.duration MINUTE) AND DATE_ADD(start_datetime, INTERVAL duration MINUTE) > NEW.start_datetime;

    IF overlap_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Σφάλμα: Η αίθουσα χρησιμοποιείται ήδη για άλλη επέμβαση αυτή την ώρα.';
    END IF;
END //

DROP TRIGGER IF EXISTS check_room_overlap_update //
CREATE TRIGGER check_room_overlap_update
BEFORE UPDATE ON MedicalProcedureOp
FOR EACH ROW
BEGIN
    DECLARE overlap_count INT;
    SELECT COUNT(*) INTO overlap_count FROM MedicalProcedureOp
    WHERE room_id = NEW.room_id AND proc_id != OLD.proc_id AND start_datetime < DATE_ADD(NEW.start_datetime, INTERVAL NEW.duration MINUTE) AND DATE_ADD(start_datetime, INTERVAL duration MINUTE) > NEW.start_datetime;

    IF overlap_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Σφάλμα: Η αίθουσα χρησιμοποιείται ήδη για άλλη επέμβαση αυτή την ώρα.';
    END IF;
END //

DROP TRIGGER IF EXISTS check_doctor_surgery_overlap_insert //
CREATE TRIGGER check_doctor_surgery_overlap_insert
BEFORE INSERT ON ProcedureParticipation
FOR EACH ROW
BEGIN
    DECLARE overlap_count INT;
    DECLARE new_start DATETIME;
    DECLARE new_duration INT;

    SELECT start_datetime, duration INTO new_start, new_duration FROM MedicalProcedureOp WHERE proc_id = NEW.proc_id;

    SELECT COUNT(*) INTO overlap_count FROM ProcedureParticipation
    JOIN MedicalProcedureOp ON ProcedureParticipation.proc_id = MedicalProcedureOp.proc_id
    WHERE ProcedureParticipation.amka = NEW.amka AND MedicalProcedureOp.start_datetime < DATE_ADD(new_start, INTERVAL new_duration MINUTE) AND DATE_ADD(MedicalProcedureOp.start_datetime, INTERVAL MedicalProcedureOp.duration MINUTE) > new_start;

    IF overlap_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Σφάλμα: Ο γιατρός συμμετέχει ήδη σε άλλη επέμβαση αυτή την ώρα.';
    END IF;
END //

DROP TRIGGER IF EXISTS check_doctor_surgery_overlap_update //
CREATE TRIGGER check_doctor_surgery_overlap_update
BEFORE UPDATE ON ProcedureParticipation
FOR EACH ROW
BEGIN
    DECLARE overlap_count INT;
    DECLARE new_start DATETIME;
    DECLARE new_duration INT;

    SELECT start_datetime, duration INTO new_start, new_duration FROM MedicalProcedureOp WHERE proc_id = NEW.proc_id;

    SELECT COUNT(*) INTO overlap_count FROM ProcedureParticipation
    JOIN MedicalProcedureOp ON ProcedureParticipation.proc_id = MedicalProcedureOp.proc_id
    WHERE ProcedureParticipation.amka = NEW.amka AND ProcedureParticipation.proc_id != OLD.proc_id AND MedicalProcedureOp.start_datetime < DATE_ADD(new_start, INTERVAL new_duration MINUTE) AND DATE_ADD(MedicalProcedureOp.start_datetime, INTERVAL MedicalProcedureOp.duration MINUTE) > new_start;

    IF overlap_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Σφάλμα: Ο γιατρός συμμετέχει ήδη σε άλλη επέμβαση αυτή την ώρα.';
    END IF;
END //

DROP TRIGGER IF EXISTS check_three_nights_insert //
CREATE TRIGGER check_three_nights_insert
BEFORE INSERT ON ShiftAssignment
FOR EACH ROW
BEGIN
    DECLARE shift_type VARCHAR(20);
    DECLARE shift_date DATE;
    DECLARE night_count INT;

    SELECT type, date INTO shift_type, shift_date FROM Shift WHERE shift_id = NEW.shift_id;

    IF shift_type = 'NIGHT' THEN
        SELECT COUNT(*) INTO night_count FROM ShiftAssignment
        JOIN Shift ON ShiftAssignment.shift_id = Shift.shift_id
        WHERE ShiftAssignment.amka = NEW.amka AND Shift.type = 'NIGHT' AND (Shift.date = DATE_SUB(shift_date, INTERVAL 1 DAY) OR Shift.date = DATE_SUB(shift_date, INTERVAL 2 DAY));

        IF night_count = 2 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Σφάλμα: Απαγορεύεται η εργασία για πάνω από 3 συνεχόμενες νυχτερινές βάρδιες.';
        END IF;
    END IF;
END //

DROP TRIGGER IF EXISTS check_three_nights_update //
CREATE TRIGGER check_three_nights_update
BEFORE UPDATE ON ShiftAssignment
FOR EACH ROW
BEGIN
    DECLARE shift_type VARCHAR(20);
    DECLARE shift_date DATE;
    DECLARE night_count INT;

    SELECT type, date INTO shift_type, shift_date FROM Shift WHERE shift_id = NEW.shift_id;

    IF shift_type = 'NIGHT' THEN
        SELECT COUNT(*) INTO night_count FROM ShiftAssignment
        JOIN Shift ON ShiftAssignment.shift_id = Shift.shift_id
        WHERE ShiftAssignment.amka = NEW.amka AND ShiftAssignment.shift_id != OLD.shift_id AND Shift.type = 'NIGHT' AND (Shift.date = DATE_SUB(shift_date, INTERVAL 1 DAY) OR Shift.date = DATE_SUB(shift_date, INTERVAL 2 DAY));

        IF night_count = 2 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Σφάλμα: Απαγορεύεται η εργασία για πάνω από 3 συνεχόμενες νυχτερινές βάρδιες.';
        END IF;
    END IF;
END //

DROP TRIGGER IF EXISTS check_self_supervision_insert //
CREATE TRIGGER check_self_supervision_insert
BEFORE INSERT ON Doctor
FOR EACH ROW
BEGIN
    IF NEW.amka = NEW.supervisor_id THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Σφάλμα: Ένας γιατρός δεν μπορεί να οριστεί ως επόπτης του εαυτού του.';
    END IF;
END //

DROP TRIGGER IF EXISTS check_self_supervision_update //
CREATE TRIGGER check_self_supervision_update
BEFORE UPDATE ON Doctor
FOR EACH ROW
BEGIN
    IF NEW.amka = NEW.supervisor_id THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Σφάλμα: Ένας γιατρός δεν μπορεί να οριστεί ως επόπτης του εαυτού του.';
    END IF;
END //

CREATE TRIGGER calculate_hosp_cost_insert
BEFORE INSERT ON Hospitalization
FOR EACH ROW
BEGIN
    DECLARE v_base_cost DECIMAL(10,2);
    DECLARE v_avg_days INT;
    DECLARE v_actual_days INT;

    IF NEW.ken_code IS NOT NULL THEN

        SELECT 
            base_cost,
            avg_days
        INTO 
            v_base_cost,
            v_avg_days
        FROM KEN
        WHERE ken_code = NEW.ken_code;

        SET v_actual_days = GREATEST(
            1,
            DATEDIFF(NEW.discharge_date, NEW.admission_date)
        );

        SET NEW.total_cost =
            ROUND((v_base_cost / v_avg_days) * v_actual_days, 2);

    ELSE
        SET NEW.total_cost = NULL;
    END IF;
END //

CREATE TRIGGER calculate_hosp_cost_update
BEFORE UPDATE ON Hospitalization
FOR EACH ROW
BEGIN
    DECLARE v_base_cost DECIMAL(10,2);
    DECLARE v_avg_days INT;
    DECLARE v_actual_days INT;

    IF NEW.ken_code IS NOT NULL THEN

        SELECT 
            base_cost,
            avg_days
        INTO 
            v_base_cost,
            v_avg_days
        FROM KEN
        WHERE ken_code = NEW.ken_code;

        SET v_actual_days = GREATEST(
            1,
            DATEDIFF(NEW.discharge_date, NEW.admission_date)
        );

        SET NEW.total_cost =
            ROUND((v_base_cost / v_avg_days) * v_actual_days, 2);

    ELSE
        SET NEW.total_cost = NULL;
    END IF;
END //

DELIMITER ;