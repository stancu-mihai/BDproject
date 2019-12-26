-- 2. Să se iniţieze o sesiune SQL*Plus folosind user ID-ul şi parola indicate. 
-- name: FMI
-- user: idd
-- pass: bazededate
-- hostname: 193.226.51.37
-- port: 1521
-- sid: o11g

-- 3. Să se listeze structura tabelelor din schema HR (EMPLOYEES, DEPARTMENTS,
-- JOBS, JOB_HISTORY, LOCATIONS, COUNTRIES, REGIONS), observând tipurile de
-- date ale coloanelor.
-- Obs: Se va utiliza comanda DESC[RIBE] nume_tabel. 
DESCRIBE EMPLOYEES;
DESCRIBE DEPARTMENTS;
DESCRIBE JOBS;
DESCRIBE JOB_HISTORY;
DESCRIBE LOCATIONS;
DESCRIBE COUNTRIES;
DESCRIBE REGIONS;

-- 4. Să se listeze conţinutul tabelelor din schema considerată, afişând valorile tuturor
-- câmpurilor.
-- Obs: SELECT * FROM nume_tabel;
SELECT * FROM EMPLOYEES;
SELECT * FROM DEPARTMENTS;
SELECT * FROM JOBS;
SELECT * FROM JOB_HISTORY;
SELECT * FROM LOCATIONS;
SELECT * FROM COUNTRIES;
SELECT * FROM REGIONS;

-- QUESTION
-- 5. Să se afişeze codul angajatului, numele, codul job-ului, data angajarii. Ce fel de
-- operaţie este aceasta (selecţie sau proiecţie)?. 
SELECT EMPLOYEE_ID, FIRST_NAME, JOB_ID, HIRE_DATE FROM EMPLOYEES

-- 6. Să se listeze, cu şi fără duplicate, codurile job-urilor din tabelul EMPLOYEES.
SELECT JOB_ID FROM EMPLOYEES;
SELECT DISTINCT JOB_ID FROM EMPLOYEES;

-- 7. Să se afişeze numele concatenat cu job_id-ul, separate prin virgula si spatiu, si
-- etichetati coloana “Angajat si titlu”.
-- Obs: Operatorul de concatenare este “||”. Şirurile de caractere se specifică între
-- apostrofuri (NU ghilimele, caz în care ar fi interpretate ca alias-uri).
SELECT LAST_NAME || ', ' || JOB_ID "Angajat si titlu" FROM EMPLOYEES; 

-- 8. Creati o cerere prin care sa se afiseze toate datele din tabelul EMPLOYEES. Separaţi
-- fiecare coloană printr-o virgulă. Etichetati coloana ”Informatii complete”.
SELECT 
EMPLOYEE_ID || ', ' || 
FIRST_NAME || ', ' ||
LAST_NAME || ', ' ||
EMAIL || ', ' ||
PHONE_NUMBER || ', ' ||
HIRE_DATE || ', ' ||
JOB_ID || ', ' ||
SALARY || ', ' ||
COMMISSION_PCT || ', ' ||
MANAGER_ID || ', ' ||
DEPARTMENT_ID "Informatii complete"
FROM EMPLOYEES; 

-- 9. Sa se listeze numele si salariul angajaţilor care câştigă mai mult de 2850 $.
SELECT LAST_NAME, SALARY
FROM EMPLOYEES
WHERE SALARY > 2850; 

-- 10. Să se creeze o cerere pentru a afişa numele angajatului şi numărul departamentului
-- pentru angajatul nr. 104.
SELECT LAST_NAME, DEPARTMENT_ID
FROM EMPLOYEES
WHERE EMPLOYEE_ID = 104; 

-- 11. Să se afişeze numele şi salariul pentru toţi angajaţii al căror salariu nu se află în
-- domeniul 1500-2850$. 
-- Obs: Pentru testarea apartenenţei la un domeniu de valori se poate utiliza operatorul
-- [NOT] BETWEEN valoare1 AND valoare2. 
SELECT LAST_NAME, SALARY
FROM EMPLOYEES
WHERE SALARY NOT BETWEEN 1500 AND 2850

-- 12. Să se afişeze numele, job-ul şi data la care au început lucrul salariaţii angajaţi între
-- 20 Februarie 1987 şi 1 Mai 1989. Rezultatul va fi ordonat crescător după data de
-- început. 
SELECT LAST_NAME, JOB_ID, HIRE_DATE
FROM EMPLOYEES
WHERE HIRE_DATE BETWEEN '20-FEB-1987' AND '1-MAY-1989'
ORDER BY HIRE_DATE; 

-- 13. Să se afişeze numele salariaţilor şi codul departamentelor pentru toti angajaţii din
-- departamentele 10 şi 30 în ordine alfabetică a numelor. 
-- Obs: Apartenenţa la o mulţime finită de valori se poate testa prin intermediul
-- operatorului IN, urmat de lista valorilor între paranteze şi separate prin virgule:
-- expresie IN (valoare_1, valoare_2, …, valoare_n)
SELECT LAST_NAME, DEPARTMENT_ID
FROM EMPLOYEES
WHERE department_id IN (10, 30)
ORDER BY LAST_NAME;

-- 14. Să se afişeze numele şi salariile angajatilor care câştigă mai mult de 3500 $ şi
-- lucrează în departamentul 10 sau 30. Se vor eticheta coloanele drept Angajat si Salariu
-- lunar. 
SELECT LAST_NAME "Angajat", SALARY "Salariu"
FROM EMPLOYEES
WHERE DEPARTMENT_ID IN (10,30)
AND SALARY > 3500

-- 15. Care este data curentă? Afişaţi diferite formate ale acesteia.
-- Obs:
--  Functia care returnează data curentă este SYSDATE. Pentru completarea sintaxei
-- obligatorii a comenzii SELECT, se utilizează tabelul DUAL: 
SELECT SYSDATE
FROM dual; 

SELECT TO_CHAR(SYSDATE,'DD-MM-YYYY')
FROM dual; 

-- 16. Sa se afiseze numele şi data angajării pentru fiecare salariat care a fost angajat in
-- 1987. Se cer 2 soluţii: una în care se lucrează cu formatul implicit al datei şi alta prin
-- care se formatează data.
SELECT FIRST_NAME, LAST_NAME, HIRE_DATE
FROM EMPLOYEES
WHERE HIRE_DATE LIKE ('%87%');

SELECT FIRST_NAME, LAST_NAME, HIRE_DATE
FROM EMPLOYEES
WHERE TO_CHAR(HIRE_DATE, 'YYYY')='1987';

-- 17. Să se afişeze numele şi job-ul pentru toţi angajaţii care nu au manager. 
SELECT LAST_NAME, JOB_ID
FROM EMPLOYEES
WHERE MANAGER_ID is null;

-- 18. Sa se afiseze numele, salariul si comisionul pentru toti salariatii care castiga
-- comisioane. Sa se sorteze datele in ordine descrescatoare a salariilor si comisioanelor. 
SELECT LAST_NAME, SALARY, COMMISSION_PCT
FROM EMPLOYEES
WHERE COMMISSION_PCT IS NOT NULL
ORDER BY SALARY DESC, COMMISSION_PCT DESC

-- QUESTION
-- 19. Eliminaţi clauza WHERE din cererea anterioară. Unde sunt plasate valorile NULL în
-- ordinea descrescătoare? 

-- 20. Să se listeze numele tuturor angajatilor care au a treia literă din nume ‘A’.
-- Obs: Pentru compararea şirurilor de caractere, împreună cu operatorul LIKE se
-- utilizează caracterele wildcard:
--  % - reprezentând orice şir de caractere, inclusiv şirul vid;
--  _ (underscore) – reprezentând un singur caracter şi numai unul. 
SELECT LAST_NAME
FROM EMPLOYEES
WHERE LAST_NAME LIKE '__a%'

-- 21. Să se listeze numele tuturor angajatilor care au 2 litere ‘L’ in nume şi lucrează în
-- departamentul 30 sau managerul lor este 101. 
SELECT LAST_NAME
FROM EMPLOYEES
WHERE LAST_NAME LIKE '%l%l%'
AND (DEPARTMENT_ID = 30
OR MANAGER_ID = 101)

-- 22. Să se afiseze numele, job-ul si salariul pentru toti salariatii al caror job conţine şirul
-- “clerk” sau “rep” si salariul nu este egal cu 1000, 2000 sau 3000 $. (operatorul NOT IN) 
SELECT LAST_NAME, JOB_ID, SALARY
FROM EMPLOYEES
WHERE (JOB_ID LIKE '%CLERK%'
OR JOB_ID LIKE '%REP%')
AND SALARY NOT IN (1000,2000,3000)

-- 23. Să se afiseze numele, salariul si comisionul pentru toti angajatii al caror salariu este
-- mai mare decat comisionul (salary*commission_pct) marit de 5 ori. 
SELECT LAST_NAME, SALARY, COMMISSION_PCT
FROM EMPLOYEES
WHERE SALARY > SALARY * COMMISSION_PCT * 5