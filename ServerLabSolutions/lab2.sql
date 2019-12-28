-- 1. Scrieţi o cerere care are următorul rezultat pentru fiecare angajat:
-- <prenume angajat> <nume angajat> castiga <salariu> lunar dar doreste <salariu de 3 ori
-- mai mare>. Etichetati coloana “Salariu ideal”. Pentru concatenare, utilizaţi atât funcţia
-- CONCAT cât şi operatorul “||”. 
SELECT FIRST_NAME || ' castiga ' || SALARY || ' lunar dar doreste ' || SALARY *3 AS "Salariul ideal"
FROM EMPLOYEES

SELECT CONCAT (FIRST_NAME || ' castiga ' || SALARY || ' lunar dar doreste ', SALARY *3) AS "Salariul ideal"
FROM EMPLOYEES

-- 2. Scrieţi o cerere prin care să se afişeze prenumele salariatului cu prima litera majusculă şi
-- toate celelalte litere mici, numele acestuia cu majuscule şi lungimea numelui, pentru
-- angajaţii al căror nume începe cu J sau M sau care au a treia literă din nume A. Rezultatul
-- va fi ordonat descrescător după lungimea numelui. Se vor eticheta coloanele
-- corespunzător. Se cer 2 soluţii (cu operatorul LIKE şi funcţia SUBSTR). 
SELECT FIRST_NAME, SUBSTR(LAST_NAME,1,1), LENGTH(LAST_NAME)
FROM EMPLOYEES
WHERE (SUBSTR(FIRST_NAME, 1, 1) IN ('J','M')
OR SUBSTR(FIRST_NAME, 3, 1) = 'a')
ORDER BY LENGTH(LAST_NAME) DESC

-- 3. Să se afişeze pentru angajaţii cu prenumele „Steven”, codul, numele şi codul
-- departamentului în care lucrează. Căutarea trebuie să nu fie case-sensitive, iar
-- eventualele blank-uri care preced sau urmează numelui trebuie ignorate.
SELECT FIRST_NAME, EMPLOYEE_ID, DEPARTMENT_ID
FROM EMPLOYEES
WHERE LTRIM(LOWER(FIRST_NAME)) = 'steven'

-- 4. Să se afişeze pentru toţi angajaţii al căror nume se termină cu litera 'e', codul, numele,
-- lungimea numelui şi poziţia din nume în care apare prima data litera 'a'. Utilizaţi alias-uri
-- corespunzătoare pentru coloane. 
SELECT FIRST_NAME, EMPLOYEE_ID, LAST_NAME, LENGTH(FIRST_NAME), INSTR(FIRST_NAME,'a')
FROM EMPLOYEES
WHERE LOWER(SUBSTR(FIRST_NAME, -1)) = 'e'
AND FIRST_NAME LIKE '%a%'

-- 5. Să se afişeze detalii despre salariaţii care au lucrat un număr întreg de săptămâni până la
-- data curentă
SELECT LAST_NAME, FIRST_NAME
FROM EMPLOYEES
WHERE MOD(TO_DATE(TO_CHAR(SYSDATE,'DD-MON-YY'))-HIRE_DATE,7)=0

-- 6. Să se afişeze codul salariatului, numele, salariul, salariul mărit cu 15%, exprimat cu două
-- zecimale şi numărul de sute al salariului nou rotunjit la 2 zecimale. Etichetaţi ultimele două
-- coloane “Salariu nou”, respectiv “Numar sute”. Se vor lua în considerare salariaţii al căror
-- salariu nu este divizibil cu 1000. 
SELECT EMPLOYEE_ID, LAST_NAME, FIRST_NAME, SALARY, SALARY *1.15 "Salariu nou", SALARY/100 "Numar sute"
FROM EMPLOYEES
WHERE MOD(SALARY, 1000) != 0

-- 7. Să se listeze numele şi data angajării salariaţilor care câştigă comision. Să se eticheteze
-- coloanele „Nume angajat”, „Data angajarii”. Pentru a nu obţine alias-ul datei angajării
-- trunchiat, utilizaţi funcţia RPAD.
SELECT FIRST_NAME "Nume angajat", RPAD(HIRE_DATE, 9) "Data angajarii"
FROM EMPLOYEES
WHERE COMMISSION_PCT IS NOT NULL

-- 8. Să se afişeze data (numele lunii, ziua, anul, ora, minutul si secunda) de peste 30 zile.
SELECT TO_CHAR(ADD_MONTHS(SYSDATE, 1),'MON-DD-YYYY-HH24-MI-SS')
FROM dual; 

-- 9. Să se afişeze numărul de zile rămase până la sfârşitul anului.
SELECT TRUNC(TO_DATE('31-12-2019', 'DD-MM-YYYY') - SYSDATE)
FROM dual; 

-- 10. a) Să se afişeze data de peste 12 ore.
SELECT SYSDATE + 12*60*60/(24*60*60)
FROM dual; 
--  b) Să se afişeze data de peste 5 minute.
SELECT SYSDATE + 5*60/(24*60*60)
FROM dual; 

-- 11. Să se afişeze numele şi prenumele angajatului (într-o singură coloană), data angajării şi
-- data negocierii salariului, care este prima zi de Luni după 6 luni de serviciu. Etichetaţi
-- această coloană “Negociere”.
SELECT FIRST_NAME || ' ' || LAST_NAME, HIRE_DATE, ADD_MONTHS(HIRE_DATE, 6) AS "Negociere"
FROM EMPLOYEES; 

-- 12. Pentru fiecare angajat să se afişeze numele şi numărul de luni de la data angajării.
-- Etichetaţi coloana “Luni lucrate”. Să se ordoneze rezultatul după numărul de luni lucrate.
-- Se va rotunji numărul de luni la cel mai apropiat număr întreg.
SELECT FIRST_NAME, LAST_NAME, ROUND(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) "Luni Lucrate"
FROM EMPLOYEES
ORDER BY 3 ASC

-- QUESTION
-- 13. Să se afişeze numele, data angajării şi ziua săptămânii în care a început lucrul fiecare
-- salariat. Etichetaţi coloana “Zi”. Ordonaţi rezultatul după ziua săptămânii, începând cu
-- Luni. 
SELECT FIRST_NAME, LAST_NAME, TO_CHAR(TO_DATE(HIRE_DATE, 'DD-MON-YY'),'DAY') "Luni Lucrate"
FROM EMPLOYEES
ORDER BY 3 DESC

-- 14. Să se afişeze numele angajaţilor şi comisionul. Dacă un angajat nu câştigă comision, să
-- se scrie “Fara comision”. Etichetaţi coloana “Comision”.
SELECT FIRST_NAME, LAST_NAME, COALESCE(TO_CHAR(COMMISSION_PCT * SALARY), 'Fara comision') "Comision"
FROM EMPLOYEES

-- 15. Să se listeze numele, salariul şi comisionul tuturor angajaţilor al căror venit lunar
-- depăşeşte 10000$. 
SELECT FIRST_NAME, LAST_NAME, COMMISSION_PCT * SALARY "Comision"
FROM EMPLOYEES
WHERE COMMISSION_PCT * SALARY + SALARY > 10000

-- QUESTION
-- 16. Să se afişeze numele, codul job-ului, salariul şi o coloană care să arate salariul după
-- mărire. Se presupune că pentru IT_PROG are loc o mărire de 20%, pentru SA_REP
-- creşterea este de 25%, iar pentru SA_MAN are loc o mărire de 35%. Pentru ceilalţi
-- angajaţi nu se acordă mărire. Să se denumească coloana "Salariu renegociat". 

-- 17. Să se afişeze numele salariatului, codul şi numele departamentului pentru toţi angajaţii.
-- Obs: Numele sau alias-urile tabelelor sunt obligatorii în dreptul coloanelor care au acelaşi
-- nume în mai multe tabele. Altfel, nu sunt necesare dar este recomandată utilizarea lor pentru
-- o mai bună claritate a cererii.
SELECT FIRST_NAME, LAST_NAME, E.DEPARTMENT_ID "ID Departament", DEPARTMENT_NAME
FROM EMPLOYEES E
LEFT JOIN DEPARTMENTS D ON E.DEPARTMENT_ID=D.DEPARTMENT_ID

-- 18. Să se listeze titlurile job-urile care există în departamentul 30.
SELECT DISTINCT JOB_ID
FROM EMPLOYEES
WHERE DEPARTMENT_ID=30

-- 19. Să se afişeze numele angajatului, numele departamentului şi locatia pentru toţi angajaţii
-- care câştigă comision. 
SELECT FIRST_NAME, LAST_NAME, DEPARTMENT_NAME, STREET_ADDRESS
FROM EMPLOYEES E
LEFT JOIN DEPARTMENTS D ON E.DEPARTMENT_ID=D.DEPARTMENT_ID
LEFT JOIN LOCATIONS L ON D.LOCATION_ID = L.LOCATION_ID
WHERE COMMISSION_PCT IS NOT NULL

-- 20. Să se afişeze numele salariatului şi numele departamentului pentru toţi salariaţii care au
-- litera A inclusă în nume.
SELECT FIRST_NAME, LAST_NAME, DEPARTMENT_NAME
FROM EMPLOYEES E
LEFT JOIN DEPARTMENTS D ON E.DEPARTMENT_ID=D.DEPARTMENT_ID
WHERE FIRST_NAME LIKE '%a%'

-- 21. Să se afişeze numele, job-ul, codul şi numele departamentului pentru toţi angajaţii care
-- lucrează în Oxford.
SELECT FIRST_NAME, LAST_NAME, JOB_ID, E.DEPARTMENT_ID, DEPARTMENT_NAME
FROM EMPLOYEES E
LEFT JOIN DEPARTMENTS D ON E.DEPARTMENT_ID=D.DEPARTMENT_ID
LEFT JOIN LOCATIONS L ON D.LOCATION_ID = L.LOCATION_ID
WHERE CITY='Oxford'

-- 22. Să se afişeze codul angajatului şi numele acestuia, împreună cu numele şi codul şefului
-- său direct. Se vor eticheta coloanele Ang#, Angajat, Mgr#, Manager.
SELECT E1.FIRST_NAME "Angajat FN", E1.LAST_NAME "Angajat LN", E1.EMPLOYEE_ID "Ang#", E1.MANAGER_ID "Mgr#", E2.LAST_NAME "Manager last name"
FROM EMPLOYEES E1
LEFT JOIN EMPLOYEES E2 ON E1.MANAGER_ID=E2.EMPLOYEE_ID

-- 23. Să se modifice cererea precedenta pentru a afişa toţi salariaţii, inclusiv cei care nu au şef.
SELECT E1.FIRST_NAME "Angajat FN", E1.LAST_NAME "Angajat LN", E1.EMPLOYEE_ID "Ang#", E1.MANAGER_ID "Mgr#", E2.LAST_NAME "Manager last name"
FROM EMPLOYEES E1
LEFT JOIN EMPLOYEES E2 ON E1.MANAGER_ID=E2.EMPLOYEE_ID

-- QUESTION
-- 24. Creaţi o cerere care să afişeze numele angajatului, codul departamentului şi toţi salariaţii
-- care lucrează în acelaşi departament cu el. Se vor eticheta coloanele corespunzător.
SELECT FIRST_NAME, LAST_NAME, DEPARTMENT_ID
FROM EMPLOYEES
ORDER BY DEPARTMENT_ID

-- 25. Să se listeze structura tabelului JOBS. Creaţi o cerere prin care să se afişeze numele,
-- codul job-ului, titlul job-ului, numele departamentului şi salariul angajaţilor.
DESCRIBE JOBS

SELECT FIRST_NAME, LAST_NAME, E.JOB_ID, JOB_TITLE, DEPARTMENT_NAME,SALARY
FROM EMPLOYEES E
LEFT JOIN DEPARTMENTS D ON E.DEPARTMENT_ID=D.DEPARTMENT_ID
LEFT JOIN JOBS J ON E.JOB_ID=J.JOB_ID

-- 26. Să se afişeze numele şi data angajării pentru salariaţii care au fost angajaţi după Gates.
SELECT LAST_NAME, HIRE_DATE 
FROM EMPLOYEES
WHERE HIRE_DATE > 
    (SELECT HIRE_DATE FROM EMPLOYEES
    WHERE LOWER(LAST_NAME) = 'gates')

-- 27. Să se afişeze numele salariatului şi data angajării împreună cu numele şi data angajării
-- şefului direct pentru salariaţii care au fost angajaţi înaintea şefilor lor. Se vor eticheta
-- coloanele Angajat, Data_ang, Manager si Data_mgr. 
SELECT E1.FIRST_NAME "Prenume angajat", E1.LAST_NAME "Nume angajat", E1.HIRE_DATE "Data ang", E2.LAST_NAME "Manager", E2.HIRE_DATE "Data mgr"
FROM EMPLOYEES E1
LEFT JOIN EMPLOYEES E2 ON E1.MANAGER_ID=E2.EMPLOYEE_ID
WHERE E1.HIRE_DATE<E2.HIRE_DATE