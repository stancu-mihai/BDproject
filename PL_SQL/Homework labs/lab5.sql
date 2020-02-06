-- 1. Să se creeze un trigger care asigură ca inserarea de angajaţi în tabelul EMP_PNU se poate realiza numai în zilele lucrătoare, între orele 8-18.
-- Obs:Trigger-ul nu are legătură directă cu datele => este un trigger la nivel de instrucţiune.
CREATE OR REPLACE TRIGGER b_i_emp_pnu
BEFORE INSERT ON emp_pnu
BEGIN
IF (TO_CHAR(SYSDATE, ‘dy’) IN (‘sat’, ‘sun’)) OR
(TO_CHAR(SYSDATE, ‘HH24:MI’)
NOT BETWEEN ’08:00’ AND ’18:00’)
THEN
RAISE_APPLICATION_ERROR (-20500, ‘Nu se pot introduce
inregistrari decat in timpul orelor de lucru’);
END IF;
END;
/
Testaţi trigger-ul:
INSERT INTO emp_pnu (employee_id, last_name, first_name, email, hire_date,
job_id, salary, department_id)
VALUES (300, ‘Smith’, ‘Robert’, ‘rsmith’, SYSDATE, ‘IT_PROG’, 4500, 60);

--Solutia mea (independenta)
CREATE OR REPLACE TRIGGER Ex1
    BEFORE INSERT ON EMPLOYEES
DECLARE
    v_wd VARCHAR(3);
    v_hr NUMBER(2);
BEGIN
    SELECT TO_CHAR(SYSDATE, 'dy') INTO v_wd FROM DUAL;
    SELECT TO_CHAR(SYSDATE, 'hh24') INTO v_wd FROM DUAL;
    IF (LOWER(v_wk) = 'sat' OR
        LOWER(v_wk) = 'sun')
    OR
        (v_wk < 8 AND v_wk>=18)
    THEN
        RAISE_APPLICATION_EXCEPTION(-20345,'In afara orelor de program');
    END IF; 
END;


--2. Modificaţi trigger-ul anterior, astfel încât să fie generate erori cu mesaje diferite pentru 
--inserare, actualizare, actualizarea salariului, ştergere.
CREATE OR REPLACE TRIGGER b_i_emp_pnu
BEFORE INSERT OR UPDATE OR DELETE ON emp_pnu
BEGIN
    IF (TO_CHAR(SYSDATE, ‘dy’) IN (‘sat’, ‘sun’)) OR
       (TO_CHAR(SYSDATE, ‘HH24:MI’) NOT BETWEEN ’08:00’ AND ’18:00’)
    THEN
        IF DELETING THEN
            RAISE_APPLICATION_ERROR (-20501, ‘Nu se pot
            sterge inregistrari decat in timpul orelor de luru’);
        ELSIF INSERTING THEN
            RAISE_APPLICATION_ERROR (-20500, ‘Nu se pot
            adauga inregistrari decat in timpul orelor de lucru’);
        ELSIF UPDATING (‘SALARY’) THEN
            RAISE_APPLICATION_ERROR (-20502, ‘Nu se poate
            actualiza campul SALARY decat in timpul orelor de
            lucru’);
        ELSE
            RAISE_APPLICATION_ERROR (-20503, ‘Nu se pot
            actualiza inregistrari decat in timpul orelor de
            lucru’);
        END IF;
    END IF;
END;
--Solutia mea (independenta)
create or replace TRIGGER Ex2
    BEFORE INSERT OR UPDATE OR DELETE ON EMPLOYEES
DECLARE
    v_wd VARCHAR(3);
    v_hr NUMBER(2);
BEGIN
    SELECT TO_CHAR(SYSDATE, 'dy') INTO v_wd FROM DUAL;
    SELECT TO_CHAR(SYSDATE, 'hh24') INTO v_hr FROM DUAL;
    IF (LOWER(v_wd) = 'sat' OR LOWER(v_wd) = 'sun')
    OR
        (v_hr < 8 AND v_hr>=18)
    THEN
        IF INSERTING THEN
                RAISE_APPLICATION_ERROR(-20345,'Insert in afara orelor de program');
        ELSIF UPDATING THEN
                RAISE_APPLICATION_ERROR(-20346,'Update in afara orelor de program');
        ELSIF DELETING THEN
                RAISE_APPLICATION_ERROR(-20347,'Delete in afara orelor de program');
        END IF;
    END IF; 
END;

--3. Să se creeze un trigger care să permită ca numai salariaţii având codul job-ului AD_PRES sau AD_VP 
--să poată câştiga mai mult de 15000.
CREATE OR REPLACE TRIIGER b_i_u_emp_pnu
BEFORE INSERT OR UPDATE OF salary ON emp_pnu
FOR EACH ROW
BEGIN
IF NOT (:NEW>job_id IN (‘AD_PRES’, ‘AD_VP’))
AND :NEW.salary > 15000
THEN
RAISE_APPLICTION_ERROR (-20202, ‘Angajatul nu poate
castiga aceasta suma’);
END IF;
END;
--Solutia mea (independenta)
create or replace TRIGGER EX3
AFTER INSERT OR UPDATE OF SALARY ON EMPLOYEES
FOR EACH ROW
BEGIN
    IF :new.SALARY>15000 AND
       (:new.JOB_ID NOT IN ('AD_PRES', 'AD_VP')) THEN
            RAISE_APPLICATION_ERROR(-20456, 'Prea mare');
    END IF;
END;

--4. Să se implementeze cu ajutorul unui declanşator constrângerea 
--că valorile salariilor nu pot fi reduse (trei variante). 
--După testare, suprimaţi trigger-ii creaţi.
Varianta 1:
CREATE OR REPLACE TRIGGER verifica_salariu_pnu
BEFORE UPDATE OF salary ON emp_pnu
FOR EACH ROW
WHEN (NEW.salary < OLD.salary)
BEGIN
RAISE_APPLICATION_ERROR (-20222, 'valoarea unui salariu nu poate fi micşorată');
END;
/
Update emp_pnu
Set salary = salary/2;
Drop trigger verifica_salariu_pnu;
Varianta 2:
CREATE OR REPLACE TRIGGER verifica_salariu_pnu
BEFORE UPDATE OF salary ON emp_pnu
FOR EACH ROW
BEGIN
IF (:NEW.salary < :OLD.salary) THEN
RAISE_APPLICATION_ERROR (-20222, 'valoarea unui salariu nu poate fi micsorata');
END IF;
END;
/
Varianta 3:
CREATE OR REPLACE PROCEDURE p4l6_pnu IS
BEGIN
RAISE_APPLICATION_ERROR (-20222, 'valoarea unui salariu nu poate fi
micsorata');
END;
/
CREATE OR REPLACE TRIGGER verifica_salariu_pnu
BEFORE UPDATE OF salary ON emp_pnu
FOR EACH ROW
WHEN (NEW.salary < OLD.salary)
CALL p4l6_pnu;
--Solutia mea (independenta)
--1
create or replace TRIGGER Ex4
AFTER UPDATE OF SALARY ON EMPLOYEES
FOR EACH ROW
BEGIN
    IF :NEW.SALARY < :OLD.SALARY THEN
        RAISE_APPLICATION_ERROR(-20456, 'Salariu mai mic decat cel vechi');
    END IF;
END;
--2
create or replace TRIGGER Ex4
AFTER UPDATE OF SALARY ON EMPLOYEES
FOR EACH ROW
WHEN (NEW.SALARY < OLD.SALARY)
BEGIN
    RAISE_APPLICATION_ERROR(-20456, 'Salariu mai mic decat cel vechi');
END;

--5. Să se creeze un trigger care calculează comisionul unui angajat ‘SA_REP’ 
--atunci când este adăugată o linie tabelului emp_pnu sau când este 
--modificat salariul.
--Obs: Dacă se doreşte atribuirea de valori coloanelor utilizând NEW, 
--trebuie creaţi triggeri BEFORE ROW. Dacă se încearcă scrierea unui 
--trigger AFTER ROW, atunci se va obţine o eroare la compilare.
CREATE OR REPLACE TRIGGER b_i_u__sal_emp_pnu
BEFORE INSERT OR UPDATE OF salary ON emp_pnu
FOR EACH ROW
WHEN (NEW.job_id = ‘SA_REP’)
BEGIN
    IF INSERTING
        THEN :NEW.commission_pct := 0;
    ELSIF :OLD.commission_pct IS NULL
        THEN :NEW.commission_pct := 0;
    ELSE :NEW.commission_pct := :OLD.commission_pct * (:NEW.salary/:OLD.salary);
    END IF;
END;
--Solutia mea (independenta)
create or replace TRIGGER Ex5
BEFORE INSERT OR UPDATE OF SALARY ON EMPLOYEES
FOR EACH ROW
WHEN (NEW.JOB_ID='SA_REP')
BEGIN
    IF INSERTING THEN
        :NEW.COMMISSION_PCT := 0;
    ELSIF :NEW.COMMISSION_PCT IS NULL THEN
        :NEW.COMMISSION_PCT := 0;
    ELSE
        :NEW.COMMISSION_PCT := :OLD.COMMISSION_PCT * (:NEW.SALARY/:OLD.SALARY);
    END IF;
END;

--6. Să se implementeze cu ajutorul unui declanşator constrângerea că, 
--dacă salariul minim şi cel maxim al unui job s-ar modifica, 
--orice angajat având job-ul respectiv trebuie să aibă salariul între noile limite .
CREATE OR REPLACE TRIGGER verifica_sal_job_pnu
BEFORE UPDATE OF min_salary, max_salary ON jobs_pnu
FOR EACH ROW
DECLARE
v_min_sal emp_pnu.salary%TYPE;
v_max_sal emp_pnu.salary%TYPE;
e_invalid EXCEPTION;
BEGIN
SELECT MIN(salary), MAX(salary)
INTO v_min_sal, v_max_sal
FROM emp_pnu
WHERE job_id = :NEW.job_id;
IF (v_min_sal < :NEW.min_salary) OR
(v_max_sal > :NEW.max_salary) THEN
RAISE e_invalid;
END IF;
EXCEPTION
WHEN e_invalid THEN
RAISE_APPLICATION_ERROR (-20567, 'Exista angajati avand salariul in afara
domeniului permis pentru job-ul corespunzator');
END verifica_sal_job_pnu;
--Solutia mea (independenta)
create or replace TRIGGER EX6
BEFORE INSERT OR UPDATE OF MIN_SALARY, MAX_SALARY ON JOBS
FOR EACH ROW
BEGIN
    FOR i in (SELECT SALARY FROM EMPLOYEES
        WHERE JOB_ID = :NEW.JOB_ID) LOOP
        IF (i.SALARY < :NEW.MIN_SALARY) THEN
            RAISE_APPLICATION_ERROR(-20202, 'Exista angajati cu salariu sub minim');
        ELSIF  (i.SALARY> :NEW.MAX_SALARY) THEN
            RAISE_APPLICATION_ERROR(-20202, 'Exista angajati cu salariu peste maxim');
        END IF;
    END LOOP;
END;

--7. Sa se creeze un trigger check_sal_pnu care garanteaza ca, ori de câte ori un angajat nou 
--este introdus în tabelul EMPLOYEES sau atunci când este modificat salariul sau codul job-ului unui angajat, 
--salariul se încadreaza între minimul si maximul salariior corespunzatoare job-ului respectiv. 
--Se vor exclude angajatii AD_PRES.
CREATE OR REPLACE TRIGGER check_sal_pnu
BEFORE INSERT OR UPDATE OF salary, job_id
ON emp_pnu
FOR EACH ROW
WHEN (NEW.job_id <> ‘AD_PRES’)
DECLARE
    v_min employees.salary %TYPE;
    v_max employees.salary %TYPE;
BEGIN
    SELECT MIN(salary), MAX(salary)
    INTO v_min, v_max
    FROM emp_pnu -- FROM copie_emp_pnu
    WHERE job_id = :NEW.job_id;
    IF :NEW.salary < v_min OR
        :NEW.salary > v_max THEN
            RAISE_APPLICATION_ERROR (-20505, ‘In afara domeniului’);
    END IF;
END;
--Solutia mea (independenta)
create or replace TRIGGER check_sal_pnu
BEFORE INSERT OR UPDATE OF SALARY, JOB_ID ON EMPLOYEES
FOR EACH ROW
WHEN (NEW.JOB_ID != 'AD_PRES')
DECLARE 
   min_sal EMPLOYEES.SALARY%TYPE;
   max_sal EMPLOYEES.SALARY%TYPE;
BEGIN
    SELECT MIN_SALARY, MAX_SALARY
    INTO min_sal, max_sal
    FROM JOBS
    WHERE JOB_ID = :NEW.JOB_ID;
    IF :NEW.SALARY NOT BETWEEN min_sal AND max_sal THEN
        RAISE_APPLICATION_ERROR(-20202, 'Nu este salariul intre limite');
    END IF;
END;

--8. a) Se presupune că în tabelul dept_pnu se păstrează (într-o coloană numită total_sal) 
--valoarea totală a salariilor angajaţilor în departamentul respectiv.
--Introduceţi această coloană în tabel şi actualizaţi conţinutul.
--b) Creaţi un trigger care permite reactualizarea automată a acestui câmp.
CREATE OR REPLACE PROCEDURE creste_total_pnu
(v_cod_dep IN dept_pnu.department_id%TYPE,
v_sal IN dept_pnu.total_sal%TYPE) AS
BEGIN
UPDATE dept_pnu
SET total_sal = NVL (total_sal, 0) + v_sal
WHERE department_id = v_cod_dep;
END creste_total_pnu;
/
CREATE OR REPLACE TRIGGER calcul_total_pnu
AFTER INSERT OR DELETE OR UPDATE OF salary ON emp_pnu
FOR EACH ROW
BEGIN
IF DELETING THEN
creste_total_pnu (:OLD.department_id, -1*:OLD.salary);
ELSIF UPDATING THEN
creste_total_pnu (:NEW.department_id, :NEW.salary - :OLD.salary);
ELSE /* inserting */
Creste_total_pnu (:NEW.department_id, :NEW.salary);
END IF;
END;
--Solutia mea(independenta)
CREATE TABLE DEPARTMENTS_MS AS SELECT * FROM DEPARTMENTS
/
ALTER TABLE departments_ms
ADD total_sal NUMBER(8,2);
/
BEGIN
    FOR i IN
        (SELECT DEPARTMENT_ID, SUM(SALARY) as SUMA
        FROM EMPLOYEES
        WHERE DEPARTMENT_ID IS NOT NULL
        GROUP BY DEPARTMENT_ID) LOOP
            UPDATE DEPARTMENTS_MS
            SET total_sal = i.suma
            WHERE DEPARTMENT_ID = i.department_id;
    END LOOP;
END;

create or replace TRIGGER EX8
BEFORE INSERT OR UPDATE OR DELETE OF SALARY ON EMPLOYEES
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        UPDATE DEPARTMENTS_MS
        SET TOTAL_SAL = TOTAL_SAL + :NEW.SALARY
        WHERE DEPARTMENT_ID = :NEW.DEPARTMENT_ID;
    ELSIF UPDATING THEN
        UPDATE DEPARTMENTS_MS
        SET TOTAL_SAL = TOTAL_SAL + :NEW.SALARY - :OLD.SALARY
        WHERE DEPARTMENT_ID = :NEW.DEPARTMENT_ID;
    ELSE
        UPDATE DEPARTMENTS_MS
        SET TOTAL_SAL = TOTAL_SAL - :OLD.SALARY
        WHERE DEPARTMENT_ID = :OLD.DEPARTMENT_ID;
    END IF;
END;

--10. Să se creeze un declanşator care:
--a) dacă este eliminat un departament, va şterge toţi angajaţii care lucrează în departamentul respectiv;
--b) dacă se schimbă codul unui departament, 
--va modifica această valoare pentru fiecare angajat care lucrează în departamentul respectiv.
CREATE OR REPLACE TRIGGER dep_cascada_pnu
BEFORE DELETE OR UPDATE OF department_id ON dept_pnu
FOR EACH ROW
BEGIN
IF DELETING THEN
DELETE FROM emp_pnu
WHERE department_id = :OLD.department_id;
END IF;
IF UPDATING AND :OLD. department_id != :NEW. department_id THEN
UPDATE emp_pnu
SET department_id = :NEW. department_id
WHERE department_id = :OLD. department_id;
END IF;
END dep_cascada_pnu;
--Solutia mea (independenta)
CREATE OR REPLACE TRIGGER EX10
BEFORE DELETE OR UPDATE ON DEPARTMENTS
FOR EACH ROW
BEGIN
    IF DELETING THEN
        DELETE
        FROM EMPLOYEES
        WHERE DEPARTMENT_ID = :OLD.DEPARTMENT_ID;
    ELSE
        UPDATE EMPLOYEES
        SET DEPARTMENT_ID = :NEW.DEPARTMENT_ID
        WHERE DEPARTMENT_ID = :OLD.DEPARTMENT_ID;
    END IF;
END;