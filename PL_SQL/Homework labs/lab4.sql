--1. Să se creeze o procedură stocată fără parametri care afişează un mesaj “Programare PL/SQL”, 
--ziua de astăzi în formatul DD-MONTH-YYYY şi ora curentă, precum şi ziua de ieri în formatul DD-MON-YYYY.
CREATE PROCEDURE first_pnu IS
azi DATE := SYSDATE;
ieri azi%TYPE;
BEGIN
3
DBMS_OUTPUT.PUT_LINE(‘Programare PL/SQL’) ;
DBMS_OUTPUT.PUT_LINE(TO_CHAR(azi, ‘dd-month-yyyy hh24:mi:ss’));
ieri := azi -1;
DBMS_OUTPUT.PUT_LINE(TO_CHAR(ieri, ‘dd-mon-yyyy’));
END;
--Solutia mea (independenta)
create or replace PROCEDURE Ex1
IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('Programare PL/SQL' );
    DBMS_OUTPUT.PUT_LINE('Azi' || TO_CHAR(SYSDATE, 'DD-MONTH-YYYY HH:MM:SS'));
    DBMS_OUTPUT.PUT_LINE('Ieri' || TO_CHAR(SYSDATE-1, 'DD-MON-YYYY'));
END Ex1;
/
EXECUTE Ex1;

--2. Să se şteargă procedura precedentă şi să se re-creeze, astfel încât să accepte un parametru IN de tip VARCHAR2, numit p_nume. 
--Mesajul afişat de procedură va avea forma « <p_nume> invata PL/SQL». 
--Invocaţi procedura cu numele utilizatorlui curent furnizat ca parametru.
DROP PROCEDURE first_pnu ;
CREATE PROCEDURE first_pnu(p_nume VARCHAR2) IS
….
Pentru apel: EXECUTE first_pnu(USER);
--Solutia mea (independenta)
CREATE OR REPLACE PROCEDURE Ex2(p_nume IN VARCHAR2) 
IS
BEGIN
    DBMS_OUTPUT.PUT_LINE(p_nume || ' invata PL/SQL');
END Ex2;
/
Execute Ex2(USER);

--3. a) Creaţi o copie JOBS_pnu a tabelului JOBS. Implementaţi constrângerea de cheie primară asupra lui JOBS_pnu.
--CREATE TABLE jobs_pnu AS SELECT * FROM jobs ;
--ALTER TABLE jobs_pnu ADD CONSTRAINT pk_jobs_pnu PRIMARY KEY(job_id);
--b) Creaţi o procedură ADD_JOB_pnu care inserează un nou job în tabelul JOBS_pnu. Procedura va avea 2 parametri IN p_id şi p_title corespunzători codului şi denumirii noului job.
--c) Testaţi procedura, invocând-o astfel:
--EXECUTE ADD_JOB_pnu(‘IT_DBA’, ‘Database Administrator);
--SELECT * FROM JOBS_pnu;
--EXECUTE ADD_JOB_pnu(‘ST_MAN’, ‘Stock Manager’);
--SELECT * FROM JOBS_pnu;

CREATE OR REPLACE PROCEDURE ADD_JOB_pnu
(p_job_id IN jobs.job_id%TYPE, p_job_title IN jobs.job_title%TYPE)
IS
BEGIN
INSERT INTO jobs_pnu (job_id, job_title)
VALUES (p_job_id, p_job_title);
COMMIT;
END add_job_pnu;
--Solutia mea (independenta)
CREATE TABLE jobs_pnu AS SELECT * FROM jobs ;
/
ALTER TABLE jobs_pnu ADD CONSTRAINT pk_jobs_pnu PRIMARY KEY(job_id);
/
CREATE OR REPLACE PROCEDURE Ex3(p_id IN JOBS_PNU.JOB_ID%TYPE, p_title IN JOBS_PNU.JOB_TITLE%TYPE)
IS
BEGIN
    INSERT INTO JOBS_PNU VALUES (p_id, p_title, 1, 2);
END Ex3;

--4. a) Creaţi o procedură stocată numită UPD_JOB_pnu pentru modificarea unui job existent în tabelul JOBS_pnu. 
--Procedura va avea ca parametri codul job-ului şi noua sa denumire (parametri IN). 
--Se va trata cazul în care nu are loc nici o actualizare.
CREATE OR REPLACE PROCEDURE UPD_JOB_pnu
(p_job_id IN jobs.job_id%TYPE, p_job_title IN jobs.job_title%TYPE)
IS
BEGIN
UPDATE jobs_pnu
SET job_title = p_job_title
WHERE job_id = p_job_id;
IF SQL%NOTFOUND THEN
RAISE_APPLICATION_ERROR(-20202, ‘Nici o actualizare);
-- sau doar cu afisare mesaj
-- DBMS_OUTPUT.PUT_LINE(‘Nici o actualizare’);
END IF;
END upd_job_pnu;

-- b) Testaţi procedura, invocând-o astfel:
EXECUTE UPD_JOB_pnu(‘IT_DBA’, ‘Data Administrator’);
SELECT * FROM job_pnu
WHERE UPPER(job_id) = ‘IT_DBA’
EXECUTE UPD_JOB(‘IT_WEB’, ‘Web master’);
Obs : A doua invocare va conduce la apariţia excepţiei. Analizaţi ce s-ar fi întâmplat dacă nu prevedeam această excepţie, punând între comentarii liniile aferente din procedură şi recreând-o cu CREATE OR REPLACE PROCEDURE…

--Solutia mea (independenta)
CREATE OR REPLACE PROCEDURE UPD_JOB_pnu (cod IN JOBS_pnu.JOB_ID%TYPE, nume IN jobs_pnu.job_title%TYPE)
IS
BEGIN
    UPDATE JOBS_pnu
    SET job_title = nume
    WHERE job_id = cod;
    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('0 modificari');
    ELSE 
        DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' modificari');
    END IF;
END UPD_JOB_pnu;

-- 5. a) Creaţi o procedură stocată numită DEL_JOB_pnu care şterge un job din tabelul JOBS_pnu. Procedura va avea ca parametru (IN) codul job-ului. Includeţi o excepţie corespunzătoare situaţiei în care nici un job nu este şters.
-- b) Testaţi procedura, invocând-o astfel:
-- DEL_JOB_pnu(‘IT_DBA’);
-- DEL_JOB_pnu(‘IT_WEB’);

--Solutia mea (independenta)
CREATE OR REPLACE PROCEDURE DEL_JOB_pnu (cod IN JOBS_pnu.JOB_ID%TYPE)
IS
BEGIN
    DELETE FROM jobs_pnu
    WHERE job_id = cod;
    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_EXCEPTION(-20202, 'Nicio modificare');
    END IF;
END DEL_JOB_pnu;

-- 6. a) Să se creeze o procedură stocată care calculează salariul mediu al angajaţilor, returnându-l prin intermediul unui parametru de tip OUT.
CREATE OR REPLACE PROCEDURE p8l4_pnu (p_salAvg OUT employees.salary%TYPE)
AS
BEGIN
SELECT AVG(salary)
INTO p_salAvg
FROM employees;
END;
--Solutia mea (independenta)
CREATE OR REPLACE PROCEDURE Ex6( med OUT  EMPLOYEES.SALARY%TYPE) 
IS
BEGIN
    SELECT AVG(SALARY)
    INTO med
    FROM EMPLOYEES;
END Ex6;

--7. Să se creeze o funcţie stocată care determină numărul de salariaţi din employees angajaţi după 1995, 
--într-un departament dat ca parametru. Să se apeleze această funcţie.
CREATE OR REPLACE FUNCTION p14l4_pnu (p_dept employees.department_id%TYPE)
RETURN NUMBER
IS
rezultat NUMBER;
BEGIN
SELECT COUNT(*)
INTO rezultat
FROM employees
WHERE department_id=p_dept
AND TO_CHAR(hire_date,'yyyy')>1995;
RETURN rezultat;
END p14l4_pnu;

--Solutia mea (independenta)
CREATE OR REPLACE FUNCTION Ex7 (dep EMPLOYEES.DEPARTMENT_ID%TYPE)
RETURN number
IS 
v_nr NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_nr
    FROM EMPLOYEES
    WHERE (TO_CHAR(HIRE_DATE,'YYYY')>1995)
    AND DEPARTMENT_ID = dep;
    RETURN v_nr;
END Ex7;

--8. Să se calculeze recursiv numărul de permutări ale unei mulţimi cu n elemente, unde n va fi transmis ca parametru.
CREATE OR REPLACE FUNCTION permutari_pnu(p_n NUMBER)
RETURN INTEGER IS
BEGIN
IF (n=0) THEN
RETURN 1;
ELSE
RETURN p_n*permutari_pnu (n-1);
END IF;
END permutari_pnu;
/
VARIABLE g_n NUMBER
EXECUTE :g_n := permutari_pnu (5);
PRINT g_n
--Solutia mea (independenta)
create or replace FUNCTION PERM ( N NUMBER)
RETURN NUMBER
IS
BEGIN
    IF N = 1 THEN
        RETURN 1;
    ELSE 
        RETURN N*PERM(N-1);
    END IF;
END;

--9. Să se afişeze numele, job-ul şi salariul angajaţilor al căror salariu este mai mare decât media salariilor din tabelul employees.
CREATE OR REPLACE FUNCTION medie_pnu
RETURN NUMBER IS
medie NUMBER;
BEGIN
SELECT AVG(salary)
INTO medie
FROM employees;
RETURN medie;
END;
/
SELECT last_name, job_id, salary
FROM employees
WHERE salary >= medie_pnu;
--Solutia mea (independenta)
create or replace PROCEDURE GTMEDIE
IS
    v_MED EMPLOYEES.SALARY%TYPE;
BEGIN
    --AFLA MEDIA
    SELECT AVG(SALARY) 
    INTO v_MED
    FROM EMPLOYEES;
    FOR i IN (SELECT LAST_NAME, JOB_ID, SALARY FROM EMPLOYEES) LOOP
        IF i.SALARY > v_med THEN
            DBMS_OUTPUT.PUT_LINE('Nume:' || i.LAST_NAME || ' Job:' || i.JOB_ID || ' Salariu:' || i.SALARY);
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(V_MED);
END;