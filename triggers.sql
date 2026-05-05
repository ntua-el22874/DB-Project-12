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

DELIMITER ;