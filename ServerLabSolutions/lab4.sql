-- 1. a) Functiile grup includ valorile NULL in calcule?
Toate funcţiile grup, cu excepţia lui COUNT(*), ignoră valorile null. COUNT(expresie)
returnează numărul de linii pentru care expresia dată nu are valoarea null. 
-- b) Care este deosebirea dintre clauzele WHERE şi HAVING?
HAVING se foloseste pentru a filtra rezultatele obtinute in urma unei grupari.

-- 2. Să se afişeze cel mai mare salariu, cel mai mic salariu, suma şi media salariilor
-- tuturor angajaţilor. Etichetaţi coloanele Maxim, Minim, Suma, respectiv Media. Sa se
-- rotunjeasca rezultatele.
SELECT  MAX(SALARY) "Maxim", MIN(SALARY) "Minim", SUM(SALARY) "Suma", TO_CHAR(AVG(SALARY),'$99,999') "Media"
FROM EMPLOYEES

-- 3. Să se afişeze minimul, maximul, suma şi media salariilor pentru fiecare job.
SELECT  JOB_ID, MAX(SALARY), MIN(SALARY), SUM(SALARY), AVG(SALARY)
FROM EMPLOYEES
GROUP BY JOB_ID

-- 4. Să se afişeze numărul de angajaţi pentru fiecare job.
SELECT  JOB_ID, COUNT(FIRST_NAME)
FROM EMPLOYEES
GROUP BY JOB_ID

-- 5. Să se determine numărul de angajaţi care sunt şefi. Etichetati coloana “Nr. manageri”.
SELECT COUNT(DISTINCT MANAGER_ID) "Nr manageri"
FROM EMPLOYEES

-- 6. Să se afişeze diferenţa dintre cel mai mare si cel mai mic salariu. Etichetati coloana. 
SELECT MAX(SALARY) - MIN(SALARY) "Diferenta"
FROM EMPLOYEES

-- 7. Scrieţi o cerere pentru a se afişa numele departamentului, locaţia, numărul de
-- angajaţi şi salariul mediu pentru angajaţii din acel departament. Coloanele vor fi
-- etichetate corespunzător.
-- !!!Obs: În clauza GROUP BY se trec obligatoriu toate coloanele prezente în clauza
-- SELECT, care nu sunt argument al funcţiilor grup.
SELECT  DEPARTMENT_NAME, CITY, STREET_ADDRESS, COUNT(LAST_NAME), AVG(SALARY)
FROM EMPLOYEES E
LEFT JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
LEFT JOIN LOCATIONS L ON D.LOCATION_ID = L.LOCATION_ID
GROUP BY DEPARTMENT_NAME, CITY, STREET_ADDRESS

-- 8. Să se afişeze codul şi numele angajaţilor care câstiga mai mult decât salariul mediu
-- din firmă. Se va sorta rezultatul în ordine descrescătoare a salariilor.
SELECT FIRST_NAME, LAST_NAME, SALARY
FROM EMPLOYEES
WHERE SALARY > 
    (SELECT AVG(SALARY)
    FROM EMPLOYEES)
ORDER BY SALARY DESC

-- 9. Pentru fiecare şef, să se afişeze codul său şi salariul celui mai prost platit
-- subordonat. Se vor exclude cei pentru care codul managerului nu este cunoscut. De
-- asemenea, se vor exclude grupurile în care salariul minim este mai mic de 1000$.
-- Sortaţi rezultatul în ordine descrescătoare a salariilor.
SELECT MIN(SALARY), MANAGER_ID
FROM EMPLOYEES
WHERE MANAGER_ID IS NOT NULL
GROUP BY MANAGER_ID
HAVING MIN(SALARY)>1000
ORDER BY MIN(SALARY) DESC

-- 10. Pentru departamentele in care salariul maxim depăşeşte 3000$, să se obţină codul,
-- numele acestor departamente şi salariul maxim pe departament.
SELECT DEPARTMENT_NAME, MAX(SALARY)
FROM EMPLOYEES E
LEFT JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
HAVING MAX(SALARY)>3000
AND DEPARTMENT_NAME IS NOT NULL
GROUP BY DEPARTMENT_NAME

-- 11. Care este salariul mediu minim al job-urilor existente? Salariul mediu al unui job va fi
-- considerat drept media arirmetică a salariilor celor care îl practică.
-- !!!Obs: Într-o imbricare de funcţii agregat, criteriul de grupare specificat în clauza GROUP
-- BY se referă doar la funcţia agregat cea mai interioară. Astfel, într-o clauză SELECT în
-- care există funcţii agregat imbricate nu mai pot apărea alte expresii. 
SELECT MIN(AVG_SALARY) FROM
    (SELECT AVG(SALARY) AS "AVG_SALARY", JOB_ID
    FROM EMPLOYEES
    GROUP BY JOB_ID)

-- 12. Să se afişeze codul, numele departamentului şi suma salariilor pe departamente.
SELECT E.DEPARTMENT_ID, DEPARTMENT_NAME, SUM(SALARY)
FROM EMPLOYEES E
LEFT JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
GROUP BY E.DEPARTMENT_ID, DEPARTMENT_NAME
HAVING E.DEPARTMENT_ID IS NOT NULL

-- 13. Să se afişeze maximul salariilor medii pe departamente.
SELECT MAX(AVG_SALARY) FROM
    (SELECT AVG(SALARY) AS "AVG_SALARY", DEPARTMENT_ID
    FROM EMPLOYEES E
    GROUP BY DEPARTMENT_ID)

-- 14. Să se obtina codul, titlul şi salariul mediu al job-ului pentru care salariul mediu este
--  minim.
SELECT * FROM 
    (SELECT AVG_SAL, JOB_TITLE FROM
        (SELECT JOB_TITLE, (MIN_SALARY+MAX_SALARY)/2 "AVG_SAL" 
        FROM JOBS)

    ORDER BY AVG_SAL ASC)
WHERE ROWNUM=1

-- 15. Să se afişeze salariul mediu din firmă doar dacă acesta este mai mare decât 2500.
--  (clauza HAVING fără GROUP BY)
SELECT * FROM
    (SELECT AVG(SALARY) "AVG_SAL"
    FROM EMPLOYEES)
WHERE AVG_SAL > 2500

-- 16. Să se afişeze suma salariilor pe departamente şi, în cadrul acestora, pe job-uri.
SELECT DEPARTMENT_ID, JOB_ID, SUM(salary)
FROM EMPLOYEES
GROUP BY ROLLUP(DEPARTMENT_ID, JOB_ID); 

-- 17. Să se afişeze numele departamentului si cel mai mic salariu din departamentul
--  avand cel mai mare salariu mediu.
SELECT DEPARTMENT_NAME, MIN(SALARY)
FROM EMPLOYEES E
LEFT JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
WHERE E.DEPARTMENT_ID =
    (SELECT DEPARTMENT_ID
    FROM
        (SELECT  DEPARTMENT_ID, AVG(SALARY) "AVG_SAL"
        FROM EMPLOYEES E
        HAVING DEPARTMENT_ID IS NOT NULL
        GROUP BY DEPARTMENT_ID
        ORDER BY AVG_SAL DESC)
    WHERE ROWNUM=1)
GROUP BY DEPARTMENT_NAME


-- 18. Sa se afiseze codul, numele departamentului si numarul de angajati care lucreaza
--  in acel departament pentru:
--  a) departamentele in care lucreaza mai putin de 4 angajati;
SELECT DEPARTMENT_ID, DEPARTMENT_NAME, "Employees" FROM
    (SELECT COUNT(EMPLOYEE_ID) "Employees", E.DEPARTMENT_ID, DEPARTMENT_NAME
    FROM EMPLOYEES E
    LEFT JOIN DEPARTMENTS D
    ON E.DEPARTMENT_ID= D.DEPARTMENT_ID
    GROUP BY E.DEPARTMENT_ID, DEPARTMENT_NAME
    HAVING E.DEPARTMENT_ID IS NOT NULL)
WHERE "Employees" < 4
--  b) departamentul care are numarul maxim de angajati.
SELECT DEPARTMENT_ID, DEPARTMENT_NAME, "Employees" FROM
    (SELECT COUNT(EMPLOYEE_ID) "Employees", E.DEPARTMENT_ID, DEPARTMENT_NAME
    FROM EMPLOYEES E
    LEFT JOIN DEPARTMENTS D
    ON E.DEPARTMENT_ID= D.DEPARTMENT_ID
    GROUP BY E.DEPARTMENT_ID, DEPARTMENT_NAME
    HAVING E.DEPARTMENT_ID IS NOT NULL
    ORDER BY "Employees" DESC)
WHERE ROWNUM=1

-- 19. Sa se afiseze salariatii care au fost angajati în aceeaşi zi a lunii în care cei mai multi
--  dintre salariati au fost angajati.
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME
FROM EMPLOYEES
WHERE HIRE_DATE =
    (SELECT HIRE_DATE FROM
        (SELECT COUNT(EMPLOYEE_ID) "Hired", HIRE_DATE
        FROM EMPLOYEES
        GROUP BY HIRE_DATE
        ORDER BY "Hired" DESC
        )
    WHERE ROWNUM=1)

-- 20. Să se obţină numărul departamentelor care au cel puţin 15 angajaţi.
SELECT COUNT(DEPARTMENT_ID) FROM
    (SELECT COUNT(EMPLOYEE_ID) "Employees", E.DEPARTMENT_ID, DEPARTMENT_NAME
    FROM EMPLOYEES E
    LEFT JOIN DEPARTMENTS D
    ON E.DEPARTMENT_ID= D.DEPARTMENT_ID
    GROUP BY E.DEPARTMENT_ID, DEPARTMENT_NAME
    HAVING E.DEPARTMENT_ID IS NOT NULL)
WHERE "Employees" >14

-- 21. Să se obţină codul departamentelor şi suma salariilor angajaţilor care lucrează în
--  acestea, în ordine crescătoare. Se consideră departamentele care au mai mult de 10
--  angajaţi şi al căror cod este diferit de 30. 
SELECT * FROM
    (SELECT DEPARTMENT_ID, COUNT(EMPLOYEE_ID) "Angajati", SUM(SALARY)
    FROM EMPLOYEES
    WHERE DEPARTMENT_ID IS NOT NULL
    GROUP BY DEPARTMENT_ID
    HAVING DEPARTMENT_ID != 30)
WHERE "Angajati" > 10

-- 22. Sa se afiseze codul, numele departamentului, numarul de angajati si salariul mediu
-- din departamentul respectiv, impreuna cu numele, salariul si jobul angajatilor din acel
-- departament. Se vor afişa şi departamentele fără angajaţi (outer join).
SELECT E.DEPARTMENT_ID, DEPARTMENT_NAME, LAST_NAME, SALARY, COUNT(LAST_NAME), AVG(SALARY)
FROM EMPLOYEES E
LEFT JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
GROUP BY ROLLUP(E.DEPARTMENT_ID, DEPARTMENT_NAME, LAST_NAME, SALARY);

-- 23. Scrieti o cerere pentru a afisa, pentru departamentele avand codul > 80, salariul total
-- pentru fiecare job din cadrul departamentului. Se vor afisa orasul, numele
-- departamentului, jobul si suma salariilor. Se vor eticheta coloanele corespunzator.
-- Obs: Plasaţi condiţia department_id > 80, pe rând, în clauzele WHERE şi HAVING.
-- Testaţi în fiecare caz. Ce se observă? Care este diferenţa dintre cele două abordări?
SELECT E.DEPARTMENT_ID, JOB_ID, SUM(SALARY)
FROM EMPLOYEES E
LEFT JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
LEFT JOIN LOCATIONS L
ON L.LOCATION_ID = D.LOCATION_ID
HAVING E.DEPARTMENT_ID >80
GROUP BY ROLLUP(E.DEPARTMENT_ID, JOB_ID);

-- Intrebare: Ce criteriu ar indeplini un angajat cu mai multe joburi? Mai multe intrari in tabela, dar cu acelasi nume? Nu exista...
-- 24. Care sunt angajatii care au mai avut cel putin doua joburi?
SELECT * FROM 
    (SELECT LAST_NAME, FIRST_NAME, COUNT(HIRE_DATE) "Joburi" FROM EMPLOYEES
    GROUP BY LAST_NAME, FIRST_NAME )
WHERE "Joburi" >1

-- 25. Să se calculeze comisionul mediu din firmă, luând în considerare toate liniile din
-- tabel.
SELECT AVG(COMMISSION_PCT) 
FROM EMPLOYEES

-- 26. Analizaţi cele 2 exemple prezentate mai sus (III – IV), referitor la operatorii ROLLUP
-- şi CUBE.
ROLLUP face subtotal, CUBE face combinatii

-- 27. Scrieţi o cerere pentru a afişa job-ul, salariul total pentru job-ul respectiv pe departamente
--  si salariul total pentru job-ul respectiv pe departamentele 30, 50, 80.
--  Se vor eticheta coloanele corespunzător. Rezultatul va apărea sub forma de mai jos:
--  Job Dep30 Dep50 Dep80 Total
--  ------------------------------------------------------------------------------
--  ………….
SELECT JOB_ID "Job",
DECODE(DEPARTMENT_ID, 30, SUM(SALARY), '0') "Dep30",
DECODE(DEPARTMENT_ID, 50, SUM(SALARY), '0') "Dep50",
DECODE(DEPARTMENT_ID, 80, SUM(SALARY), '0') "Dep80"
FROM EMPLOYEES
WHERE DEPARTMENT_ID IN (30,50,80)
GROUP BY JOB_ID, DEPARTMENT_ID; 

-- 28. Să se creeze o cerere prin care să se afişeze numărul total de angajaţi şi, din acest total,
--  numărul celor care au fost angajaţi în 1997, 1998, 1999 si 2000. Denumiti capetele de
--  tabel in mod corespunzator.
SELECT DISTINCT
DECODE(TO_CHAR(HIRE_DATE, 'YYYY'), 1997, (SELECT COUNT(EMPLOYEE_ID) FROM EMPLOYEES WHERE TO_CHAR(HIRE_DATE, 'YYYY')=1997), '0') "1997",
DECODE(TO_CHAR(HIRE_DATE, 'YYYY'), 1998, (SELECT COUNT(EMPLOYEE_ID) FROM EMPLOYEES WHERE TO_CHAR(HIRE_DATE, 'YYYY')=1998), '0') "1998",
DECODE(TO_CHAR(HIRE_DATE, 'YYYY'), 1999, (SELECT COUNT(EMPLOYEE_ID) FROM EMPLOYEES WHERE TO_CHAR(HIRE_DATE, 'YYYY')=1999), '0') "1999",
DECODE(TO_CHAR(HIRE_DATE, 'YYYY'), 2000, (SELECT COUNT(EMPLOYEE_ID) FROM EMPLOYEES WHERE TO_CHAR(HIRE_DATE, 'YYYY')=2000), '0') "2000"
FROM EMPLOYEES

-- 29. Rezolvaţi problema 22 cu ajutorul subcererilor specificate în clauza SELECT.
SELECT * FROM
    (SELECT DEPARTMENT_ID, COUNT(EMPLOYEE_ID) "Angajati", SUM(SALARY)
    FROM EMPLOYEES
    WHERE DEPARTMENT_ID IS NOT NULL
    GROUP BY DEPARTMENT_ID
    HAVING DEPARTMENT_ID != 30)
WHERE "Angajati" > 10

-- Obs: Subcererile pot apărea în clauza SELECT, WHERE sau FROM a unei cereri.
--  O subcerere care apare în clauza FROM se mai numeşte view in-line.
-- 30. Să se afişeze codul, numele departamentului şi suma salariilor pe departamente.
SELECT E.DEPARTMENT_ID, DEPARTMENT_NAME, SUM(SALARY)
FROM EMPLOYEES E
LEFT JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
GROUP BY ROLLUP(E.DEPARTMENT_ID, DEPARTMENT_NAME);

-- 31. Să se afişeze numele, salariul, codul departamentului si salariul mediu din departamentul
--  respectiv.
SELECT E.DEPARTMENT_ID, DEPARTMENT_NAME, AVG(SALARY)
FROM EMPLOYEES E
LEFT JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
GROUP BY ROLLUP(E.DEPARTMENT_ID, DEPARTMENT_NAME);

-- 32. Modificaţi cererea anterioară, pentru a determina şi listarea numărului de angajaţi din
--  departamente.
SELECT E.DEPARTMENT_ID, DEPARTMENT_NAME, AVG(SALARY), COUNT(EMPLOYEE_ID)
FROM EMPLOYEES E
LEFT JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
GROUP BY ROLLUP(E.DEPARTMENT_ID, DEPARTMENT_NAME);

--Intrebare: Cum se rezolva?
-- 33. Pentru fiecare departament, să se afişeze numele acestuia, numele şi salariul celor mai
--  prost plătiţi angajaţi din cadrul său.
SELECT DEPARTMENT_ID, MIN(SALARY) FROM EMPLOYEES
    WHERE DEPARTMENT_ID IS NOT NULL
    GROUP BY DEPARTMENT_ID

--  34. Rezolvaţi problema 22 cu ajutorul subcererilor specificate în clauza FROM.