DELIMITER //

CREATE TRIGGER check_patient_allergy
BEFORE INSERT ON Prescription
FOR EACH ROW
BEGIN
    DECLARE allergy_count INT;

    SELECT COUNT(*) INTO allergy_count
    FROM PatientAllergy
    JOIN DrugSubstance ON PatientAllergy.substance_id = DrugSubstance.substance_id
    WHERE PatientAllergy.patient_id = NEW.patient_id
      AND DrugSubstance.drug_id = NEW.drug_id;

    IF allergy_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Σφάλμα: Ο ασθενής έχει αλλεργία σε δραστική ουσία αυτού του φαρμάκου.';
    END IF;
END //

CREATE TRIGGER check_bed_status
BEFORE INSERT ON Hospitalization
FOR EACH ROW
BEGIN
    DECLARE current_bed_status VARCHAR(30);

    SELECT status INTO current_bed_status
    FROM Bed
    WHERE bed_id = NEW.bed_id;

    IF current_bed_status != 'FREE' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Σφάλμα: Η επιλεγμένη κλίνη δεν είναι διαθέσιμη.';
    END IF;
END //

CREATE TRIGGER check_shift_overlap
BEFORE INSERT ON ShiftAssignment
FOR EACH ROW
BEGIN
    DECLARE overlap_count INT;

    SELECT COUNT(*) INTO overlap_count
    FROM ShiftAssignment
    JOIN Shift ON ShiftAssignment.shift_id = Shift.shift_id
    WHERE ShiftAssignment.amka = NEW.amka
      AND Shift.date = (SELECT date FROM Shift WHERE shift_id = NEW.shift_id);

    IF overlap_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Σφάλμα: Το μέλος του προσωπικού έχει ήδη βάρδια αυτή την ημερομηνία.';
    END IF;
END //

CREATE TRIGGER check_doctor_supervisor_insert
BEFORE INSERT ON Doctor
FOR EACH ROW
BEGIN
    IF NEW.rank = 'RESIDENT' AND NEW.supervisor_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Σφάλμα: Οι ειδικευόμενοι πρέπει υποχρεωτικά να έχουν επόπτη.';
    END IF;

    IF NEW.rank = 'DIRECTOR' AND NEW.supervisor_id IS NOT NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Σφάλμα: Οι διευθυντές δεν μπορούν να έχουν επόπτη.';
    END IF;
END //

CREATE TRIGGER check_doctor_supervisor_update
BEFORE UPDATE ON Doctor
FOR EACH ROW
BEGIN
    IF NEW.rank = 'RESIDENT' AND NEW.supervisor_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Σφάλμα: Οι ειδικευόμενοι πρέπει υποχρεωτικά να έχουν επόπτη.';
    END IF;

    IF NEW.rank = 'DIRECTOR' AND NEW.supervisor_id IS NOT NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Σφάλμα: Οι διευθυντές δεν μπορούν να έχουν επόπτη.';
    END IF;
END //

CREATE TRIGGER check_monthly_shift_limits
BEFORE INSERT ON ShiftAssignment
FOR EACH ROW
BEGIN
    DECLARE shift_count INT;
    DECLARE staff_role VARCHAR(20);
    DECLARE shift_month INT;
    DECLARE shift_year INT;

    SELECT type INTO staff_role
    FROM Staff
    WHERE amka = NEW.amka;

    SELECT MONTH(date), YEAR(date) INTO shift_month, shift_year
    FROM Shift
    WHERE shift_id = NEW.shift_id;

    SELECT COUNT(*) INTO shift_count
    FROM ShiftAssignment
    JOIN Shift ON ShiftAssignment.shift_id = Shift.shift_id
    WHERE ShiftAssignment.amka = NEW.amka
      AND MONTH(Shift.date) = shift_month
      AND YEAR(Shift.date) = shift_year;

    IF staff_role = 'DOCTOR' AND shift_count >= 15 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Σφάλμα: Το μέλος του ιατρικού προσωπικού ξεπέρασε το όριο των 15 βαρδιών.';
    END IF;

    IF staff_role = 'NURSE' AND shift_count >= 20 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Σφάλμα: Το μέλος του νοσηλευτικού προσωπικού ξεπέρασε το όριο των 20 βαρδιών.';
    END IF;

    IF staff_role = 'ADMIN' AND shift_count >= 25 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Σφάλμα: Το μέλος του διοικητικού προσωπικού ξεπέρασε το όριο των 25 βαρδιών.';
    END IF;
END //

    CREATE TRIGGER check_room_overlap
BEFORE INSERT ON MedicalProcedure
FOR EACH ROW
BEGIN
    DECLARE overlap_count INT;

    SELECT COUNT(*) INTO overlap_count
    FROM MedicalProcedure
    WHERE room_id = NEW.room_id
      AND start_datetime < DATE_ADD(NEW.start_datetime, INTERVAL NEW.duration MINUTE)
      AND DATE_ADD(start_datetime, INTERVAL duration MINUTE) > NEW.start_datetime;

    IF overlap_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Σφάλμα: Η αίθουσα χρησιμοποιείται ήδη για άλλη επέμβαση αυτή την ώρα.';
    END IF;
END //

CREATE TRIGGER check_doctor_surgery_overlap
BEFORE INSERT ON ProcedureParticipation
FOR EACH ROW
BEGIN
    DECLARE overlap_count INT;
    DECLARE new_start DATETIME;
    DECLARE new_duration INT;

    SELECT start_datetime, duration INTO new_start, new_duration
    FROM MedicalProcedure
    WHERE proc_id = NEW.proc_id;

    SELECT COUNT(*) INTO overlap_count
    FROM ProcedureParticipation
    JOIN MedicalProcedure ON ProcedureParticipation.proc_id = MedicalProcedure.proc_id
    WHERE ProcedureParticipation.amka = NEW.amka
      AND MedicalProcedure.start_datetime < DATE_ADD(new_start, INTERVAL new_duration MINUTE)
      AND DATE_ADD(MedicalProcedure.start_datetime, INTERVAL MedicalProcedure.duration MINUTE) > new_start;

    IF overlap_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Σφάλμα: Ο ιατρός συμμετέχει ήδη σε άλλη επέμβαση αυτή την ώρα.';
    END IF;
END //

CREATE TRIGGER check_8_hour_rest
BEFORE INSERT ON ShiftAssignment
FOR EACH ROW
BEGIN
    DECLARE new_start DATETIME;
    DECLARE new_end DATETIME;
    DECLARE rest_violations INT;

    SELECT start_time, end_time INTO new_start, new_end
    FROM Shift
    WHERE shift_id = NEW.shift_id;

    SELECT COUNT(*) INTO rest_violations
    FROM ShiftAssignment
    JOIN Shift ON ShiftAssignment.shift_id = Shift.shift_id
    WHERE ShiftAssignment.amka = NEW.amka
      AND (
          (Shift.end_time > DATE_SUB(new_start, INTERVAL 8 HOUR) AND Shift.end_time <= new_start)
          OR
          (Shift.start_time < DATE_ADD(new_end, INTERVAL 8 HOUR) AND Shift.start_time >= new_end)
      );

    IF rest_violations > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Σφάλμα: Πρέπει να μεσολαβούν τουλάχιστον 8 ώρες ανάπαυσης μεταξύ των βαρδιών.';
    END IF;
END //

CREATE TRIGGER check_three_nights
BEFORE INSERT ON ShiftAssignment
FOR EACH ROW
BEGIN
    DECLARE shift_type VARCHAR(20);
    DECLARE shift_date DATE;
    DECLARE night_count INT;

    SELECT type, date INTO shift_type, shift_date
    FROM Shift
    WHERE shift_id = NEW.shift_id;

    IF shift_type = 'NIGHT' THEN
        SELECT COUNT(*) INTO night_count
        FROM ShiftAssignment
        JOIN Shift ON ShiftAssignment.shift_id = Shift.shift_id
        WHERE ShiftAssignment.amka = NEW.amka
          AND Shift.type = 'NIGHT'
          AND (Shift.date = DATE_SUB(shift_date, INTERVAL 1 DAY)
               OR Shift.date = DATE_SUB(shift_date, INTERVAL 2 DAY));

        IF night_count = 2 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Σφάλμα: Απαγορεύεται η εργασία σε πάνω από 3 συνεχόμενες νυχτερινές βάρδιες.';
        END IF;
    END IF;
END //
DELIMITER ;