DELIMITER //
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

DELIMITER ;