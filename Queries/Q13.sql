WITH RECURSIVE DoctorHierarchy AS (

    SELECT
        d.amka AS doctor_id,
        s.name AS doctor_name,
        s.surname AS doctor_surname,

        sup.amka AS supervisor_id,
        ss.name AS supervisor_name,
        ss.surname AS supervisor_surname,

        sup.rank,
        1 AS hierarchy_level

    FROM Doctor d

    JOIN Staff s
        ON d.amka = s.amka

    LEFT JOIN Doctor sup
        ON d.supervisor_id = sup.amka

    LEFT JOIN Staff ss
        ON sup.amka = ss.amka

    WHERE d.supervisor_id IS NOT NULL

    UNION ALL

    SELECT
        dh.doctor_id,
        dh.doctor_name,
        dh.doctor_surname,

        sup2.amka,
        ss2.name,
        ss2.surname,

        sup2.rank,
        dh.hierarchy_level + 1

    FROM DoctorHierarchy dh

    JOIN Doctor sup1
        ON dh.supervisor_id = sup1.amka

    JOIN Doctor sup2
        ON sup1.supervisor_id = sup2.amka

    JOIN Staff ss2
        ON sup2.amka = ss2.amka

    WHERE sup1.supervisor_id IS NOT NULL
)

SELECT
    doctor_id,
    doctor_name,
    doctor_surname,
    supervisor_id,
    supervisor_name,
    supervisor_surname,
    rank,
    hierarchy_level
FROM DoctorHierarchy

ORDER BY doctor_id, hierarchy_level;