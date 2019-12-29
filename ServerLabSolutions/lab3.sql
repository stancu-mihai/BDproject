-- 1. Scrieţi o cerere pentru a se afişa numele, luna (în litere) şi anul angajării pentru toţi
-- salariaţii din acelaşi departament cu Gates, al căror nume conţine litera “a”. Se va
-- exclude Gates. Se vor da 2 soluţii pentru determinarea apariţiei literei “A” în nume. De
-- asemenea, pentru una din metode se va da şi varianta join-ului conform standardului
-- SQL99. 
SELECT FIRST_NAME, LAST_NAME, TO_CHAR(HIRE_DATE, 'MON'), TO_CHAR(HIRE_DATE, 'YY')
FROM EMPLOYEES
WHERE DEPARTMENT_ID = 
    (SELECT DEPARTMENT_ID
    FROM EMPLOYEES
    WHERE LOWER(LAST_NAME)='gates')
AND LOWER(LAST_NAME) != 'gates'
AND LAST_NAME LIKE '%a%'

-- QUESTION
-- 2. Să se afişeze codul şi numele angajaţilor care lucrează în acelasi departament cu
-- cel puţin un angajat al cărui nume conţine litera “t”. Se vor afişa, de asemenea, codul şi 
-- numele departamentului respectiv. Rezultatul va fi ordonat alfabetic după nume. Se vor
-- da 2 soluţii pentru join (condiţie în clauza WHERE şi sintaxa introdusă de standardul
-- SQL3).
SELECT FIRST_NAME, LAST_NAME, EMPLOYEE_ID, DEPARTMENT_ID
FROM EMPLOYEES
WHERE DEPARTMENT_ID IN
    (SELECT DEPARTMENT_ID
    FROM EMPLOYEES
    WHERE LAST_NAME LIKE '%t%')
ORDER BY DEPARTMENT_ID

-- 3. Sa se afiseze numele, salariul, titlul job-ului, oraşul şi ţara în care lucrează angajatii
--  condusi direct de King.
SELECT E.FIRST_NAME, E.LAST_NAME, E.SALARY, E.JOB_ID, L.CITY
FROM EMPLOYEES E
LEFT JOIN DEPARTMENTS D ON E.DEPARTMENT_ID=D.DEPARTMENT_ID
LEFT JOIN LOCATIONS L ON D.LOCATION_ID = L.LOCATION_ID
WHERE E.MANAGER_ID IN
    (SELECT EMPLOYEE_ID
    FROM EMPLOYEES
    WHERE LOWER(LAST_NAME) = 'king')

-- 4. Sa se afiseze codul departamentului, numele departamentului, numele si job-ul tuturor
-- angajatilor din departamentele al căror nume conţine şirul ‘ti’. De asemenea, se va lista
-- salariul angajaţilor, în formatul “$99,999.00”. Rezultatul se va ordona alfabetic după numele
-- departamentului, şi în cadrul acestuia, după numele angajaţilor.
SELECT E.DEPARTMENT_ID, DEPARTMENT_NAME, FIRST_NAME, LAST_NAME, JOB_ID, TO_CHAR(SALARY, '$99,999.00')SALARY
FROM EMPLOYEES E
LEFT JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
WHERE E.DEPARTMENT_ID IN
    (SELECT DISTINCT E.DEPARTMENT_ID
    FROM EMPLOYEES E
    LEFT JOIN DEPARTMENTS D ON E.DEPARTMENT_ID=D.DEPARTMENT_ID
    WHERE DEPARTMENT_NAME LIKE '%ti%')
ORDER BY DEPARTMENT_NAME, LAST_NAME, FIRST_NAME

-- 5. Sa se afiseze numele angajatilor, numarul departamentului, numele departamentului,
-- oraşul si job-ul tuturor salariatilor al caror departament este localizat in Oxford.
SELECT FIRST_NAME, LAST_NAME, E.DEPARTMENT_ID, DEPARTMENT_NAME, CITY, JOB_ID
FROM EMPLOYEES E
LEFT JOIN DEPARTMENTS D ON E.DEPARTMENT_ID=D.DEPARTMENT_ID
LEFT JOIN LOCATIONS L ON D.LOCATION_ID = L.LOCATION_ID
WHERE CITY='Oxford'

-- 6. Afisati codul, numele si salariul tuturor angajatilor care castiga mai mult decat salariul
-- mediu pentru job-ul corespunzător si lucreaza intr-un departament cu cel putin unul din
-- angajatii al caror nume contine litera “t”.
-- Obs: Salariul mediu pentru un job se va considera drept media aritmetică a valorilor minime
-- şi maxime admise pentru acesta (media valorilor coloanelor min_salary şi max_salary).
SELECT E.JOB_ID, FIRST_NAME, LAST_NAME, SALARY,(MIN_SALARY+MAX_SALARY)/2, DEPARTMENT_ID
FROM EMPLOYEES E
LEFT JOIN JOBS J ON E.JOB_ID = J.JOB_ID
WHERE SALARY > (MIN_SALARY+MAX_SALARY)/2
AND DEPARTMENT_ID IN
    (SELECT DISTINCT DEPARTMENT_ID
    FROM EMPLOYEES 
    WHERE LOWER(LAST_NAME) LIKE '%t%'
    AND DEPARTMENT_ID IS NOT NULL)
ORDER BY DEPARTMENT_ID

-- 7. Să se afişeze numele salariaţilor şi numele departamentelor în care lucrează. Se vor
-- afişa şi salariaţii care nu au asociat un departament. (right outer join, 2 variante).
SELECT FIRST_NAME, LAST_NAME, DEPARTMENT_NAME
FROM EMPLOYEES E
LEFT JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID

-- 8. Să se afişeze numele departamentelor şi numele salariaţilor care lucrează în ele. Se vor
-- afişa şi departamentele care nu au salariaţi. (left outer join, 2 variante)
SELECT DEPARTMENT_NAME, FIRST_NAME, LAST_NAME
FROM DEPARTMENTS D
LEFT OUTER JOIN EMPLOYEES E ON E.DEPARTMENT_ID = D.DEPARTMENT_ID

-- 9. Cum se poate implementa full outer join?
-- Obs: Full outer join se poate realiza fie prin reuniunea rezultatelor lui right outer join şi left
-- outer join, fie utilizând sintaxa introdusă de standardul SQL99.

-- 10. Se cer codurile departamentelor al căror nume conţine şirul “re” sau în care lucrează
-- angajaţi având codul job-ului “SA_REP”. Cum este ordonat rezultatul? 
SELECT DISTINCT E.DEPARTMENT_ID
FROM EMPLOYEES E
LEFT JOIN DEPARTMENTS D ON E.DEPARTMENT_ID=D.DEPARTMENT_ID
WHERE JOB_ID='SA_REP'
OR LOWER(DEPARTMENT_NAME) LIKE '%re%'

-- 11. Ce se întâmplă dacă înlocuim UNION cu UNION ALL în comanda precedentă?

-- 12. Sa se obtina codurile departamentelor in care nu lucreaza nimeni (nu este introdus
-- niciun salariat in tabelul employees). Se cer două soluţii.
SELECT DEPARTMENT_NAME
FROM EMPLOYEES E
RIGHT JOIN DEPARTMENTS D ON E.DEPARTMENT_ID=D.DEPARTMENT_ID
WHERE EMPLOYEE_ID IS NULL

-- 13. Se cer codurile departamentelor al căror nume conţine şirul “re” şi în care lucrează
-- angajaţi având codul job-ului “HR_REP”.
SELECT DISTINCT E.DEPARTMENT_ID
FROM EMPLOYEES E
LEFT JOIN DEPARTMENTS D ON E.DEPARTMENT_ID=D.DEPARTMENT_ID
WHERE JOB_ID='HR_REP'
OR LOWER(DEPARTMENT_NAME) LIKE '%re%'

-- 14. Să se determine codul angajaţilor, codul job-urilor şi numele celor al căror salariu este
-- mai mare decât 3000 sau este egal cu media dintre salariul minim şi cel maxim pentru
-- job-ul respectiv. 
SELECT E.EMPLOYEE_ID, E.JOB_ID, FIRST_NAME, LAST_NAME, SALARY,(MIN_SALARY+MAX_SALARY)/2
FROM EMPLOYEES E
LEFT JOIN JOBS J ON E.JOB_ID = J.JOB_ID
WHERE SALARY > 3000
OR SALARY = (MIN_SALARY+MAX_SALARY)/2

-- 15. Folosind subcereri, să se afişeze numele şi data angajării pentru salariaţii care au
-- fost angajaţi după Gates.
SELECT LAST_NAME, HIRE_DATE 
FROM EMPLOYEES
WHERE HIRE_DATE > 
    (SELECT HIRE_DATE FROM EMPLOYEES
    WHERE LOWER(LAST_NAME) = 'gates')

-- 16. Folosind subcereri, scrieţi o cerere pentru a afişa numele şi salariul pentru toţi
-- colegii (din acelaşi departament) lui Gates. Se va exclude Gates.
SELECT LAST_NAME, FIRST_NAME, SALARY, DEPARTMENT_ID
FROM EMPLOYEES
WHERE DEPARTMENT_ID IN 
    (SELECT DEPARTMENT_ID FROM EMPLOYEES
    WHERE LOWER(LAST_NAME) = 'gates')

-- ? Se putea pune ”=” în loc de ”IN”? In care caz nu se poate face această înlocuire?
Da. Daca erau mai multe departamente, nu se putea face inlocuirea.

-- 17. Folosind subcereri, să se afişeze numele şi salariul angajaţilor conduşi direct de
-- preşedintele companiei (acesta este considerat angajatul care nu are manager).
SELECT FIRST_NAME, LAST_NAME, SALARY
FROM EMPLOYEES
WHERE MANAGER_ID =
    (SELECT EMPLOYEE_ID
    FROM EMPLOYEES
    WHERE MANAGER_ID IS NULL)

-- QUESTION: Al carui angajat? Oricare?
-- 18. Scrieti o cerere pentru a afişa numele, codul departamentului si salariul angajatilor
-- al caror număr de departament si salariu coincid cu numarul departamentului si salariul
-- unui angajat care castiga comision.
SELECT FIRST_NAME, LAST_NAME, DEPARTMENT_ID, SALARY
FROM EMPLOYEES
WHERE DEPARTMENT_ID IN
    (SELECT DEPARTMENT_ID 
    FROM EMPLOYEES
    WHERE COMMISSION_PCT IS NULL)
AND SALARY IN
    (SELECT SALARY
    FROM EMPLOYEES
    WHERE COMMISSION_PCT IS NULL)

-- 19. Rezolvaţi problema 6 utilizând subcereri.
SELECT FIRST_NAME, LAST_NAME, DEPARTMENT_ID, SALARY
FROM EMPLOYEES
WHERE DEPARTMENT_ID IN
    (SELECT DEPARTMENT_ID 
    FROM EMPLOYEES
    WHERE COMMISSION_PCT IS NULL)
AND SALARY IN
    (SELECT SALARY
    FROM EMPLOYEES
    WHERE COMMISSION_PCT IS NULL)

-- 20. Scrieti o cerere pentru a afisa angajatii care castiga mai mult decat oricare functionar
-- (job-ul conţine şirul “CLERK”). Sortati rezultatele dupa salariu, in ordine descrescatoare.
-- (ALL). Ce rezultat este returnat dacă se înlocuieşte “ALL” cu “ANY”?
SELECT FIRST_NAME, LAST_NAME, SALARY
FROM EMPLOYEES
WHERE SALARY > 
    (SELECT MAX(SALARY)
    FROM EMPLOYEES
    WHERE JOB_ID LIKE '%CLERK%')
ORDER BY SALARY DESC

-- 21. Scrieţi o cerere pentru a afişa numele, numele departamentului şi salariul angajaţilor
-- care nu câştigă comision, dar al căror şef direct coincide cu şeful unui angajat care
-- câştigă comision.
SELECT FIRST_NAME, LAST_NAME, DEPARTMENT_NAME, SALARY
FROM EMPLOYEES E
LEFT JOIN DEPARTMENTS D ON E.DEPARTMENT_ID=D.DEPARTMENT_ID
WHERE COMMISSION_PCT IS NULL
AND E.MANAGER_ID IN
    (SELECT E.MANAGER_ID
    FROM EMPLOYEES
    WHERE COMMISSION_PCT IS NOT NULL)

-- 22. Sa se afiseze numele, departamentul, salariul şi job-ul tuturor angajatilor al caror salariu
-- si comision coincid cu salariul si comisionul unui angajat din Oxford.
SELECT FIRST_NAME, LAST_NAME, E.DEPARTMENT_ID, SALARY, JOB_ID
FROM EMPLOYEES E
WHERE SALARY IN
    (SELECT SALARY
    FROM EMPLOYEES E
    LEFT JOIN DEPARTMENTS D ON E.DEPARTMENT_ID=D.DEPARTMENT_ID
    LEFT JOIN LOCATIONS L ON D.LOCATION_ID = L.LOCATION_ID
    WHERE CITY='Oxford')
AND COMMISSION_PCT IN
    (SELECT COMMISSION_PCT
    FROM EMPLOYEES E
    LEFT JOIN DEPARTMENTS D ON E.DEPARTMENT_ID=D.DEPARTMENT_ID
    LEFT JOIN LOCATIONS L ON D.LOCATION_ID = L.LOCATION_ID
    WHERE CITY='Oxford')

-- 23. Să se afişeze numele angajaţilor, codul departamentului şi codul job-ului salariaţilor al
-- căror departament se află în Toronto. 
SELECT FIRST_NAME, LAST_NAME, JOB_ID, E.DEPARTMENT_ID
FROM EMPLOYEES E
LEFT JOIN DEPARTMENTS D ON E.DEPARTMENT_ID=D.DEPARTMENT_ID
LEFT JOIN LOCATIONS L ON D.LOCATION_ID = L.LOCATION_ID
WHERE CITY='Toronto'