BEGIN
DECLARE sup BIGINT;

SELECT supervisor_id FROM Doctor
INTO sup
WHERE amka = 53434182353;


SELECT amka FROM Doctor
WHERE supervisor_id = sup;
END
