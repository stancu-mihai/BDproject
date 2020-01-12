--se vor parcurge obligatoriu din 193... SGBD.. Materiale Idd...laboratoare
--examen: matrice 2x5 (vector de vector, se creaza intai vectorul de 5)

-- tipul de date era creat (gen lab2), trebuia doar inserata o linie

begin
select into --musai o variabila aici
end;

--alta cerinta posibila: sa se salveze toata cererea intr-o variabila in partea de declarare (cursor)

cursor numecursor is (un select)
open numecursor --se proceseaza cererea, nu se mai poate folosi for (trebuie citit linie cu linie cu fetch, intrebam daca am ajuns la sfarsit)
-- cursorul e un pointer la o cerere
--se poate defini o variabila de tipul linie de cursor ( fetch into)

-- stim cate sunt? vector1
-- nu stim? tablou

--exemplu lab 3, ex1, sol1
set serveroutput on
DECLARE
CURSOR c_emp IS
    SELECT last_name, salary*12 sal_an
    FROM emp_pnu
    WHERE department_id = 50;
V_emp c_emp%ROWTYPE;
BEGIN
    OPEN c_emp;
    FETCH c_emp INTO v_emp;
    WHILE (c_emp%FOUND) LOOP
        DBMS_OUTPUT.PUT_LINE (' Nume ' || v_emp.last_name ||
        ' are salariul anual : ' || v_emp.sal_an);
        FETCH c_emp INTO v_emp;
    END LOOP;
    CLOSE c_emp;
END;

--sol2 e cu loop
DECLARE
CURSOR c_emp IS
    SELECT last_name, salary*12 sal_an
    FROM emp_pnu
    WHERE department_id = 50;
V_emp c_emp%TYPE;
BEGIN
    OPEN c_emp;
    LOOP
        FETCH c_emp INTO v_emp;
        EXIT WHEN c_emp%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE (' Nume: '|| v_emp.last_name ||
        ' are salariul anual : ' || v_emp.sal_an);
    END LOOP;
    CLOSE c_emp;
END;

--sol 3 (for-ul se ocupa automat de inchidere deschidere cursor)
DECLARE
CURSOR c_emp IS
    SELECT last_name, salary*12 sal_an
    FROM emp_pnu
    WHERE department_id = 50;
BEGIN
    FOR v_emp IN c_emp LOOP
        DBMS_OUTPUT.PUT_LINE (' Nume: '|| v_emp.last_name ||
        ' are salariul anual : ' || v_emp.sal_an);
    END LOOP;
END;

--sol 4 (dispare cursorul, devine un cursor inline - definit la runtime)
BEGIN
    FOR v_rec IN (SELECT last_name, salary*12 sal_an
        FROM employees
        WHERE department_id = 50) LOOP
        DBMS_OUTPUT.PUT_LINE (' Nume: '|| v_emp.last_name ||
        ' are salariul anual : ' || v_emp.sal_an);
    END LOOP;
END;

--daca trebuie citita o optiune de la tastatura, si in functie de ea trebuie sa citim altceva din tabel, e mai greu sa folosim cursor (vezi ex 5 din lab3)
--cursorul poate avea parametru:
set serveroutput on
DECLARE
CURSOR c_emp(dep departments.department_id%type) is --cursor cu parametru
    SELECT last_name, salary*12 sal_an
    FROM emp_pnu
    WHERE department_id = 50;
V_emp c_emp%ROWTYPE;
BEGIN
    OPEN c_emp(&cod_dep); --parametrul se da la open
    FETCH c_emp INTO v_emp;
    WHILE (c_emp%FOUND) LOOP
        DBMS_OUTPUT.PUT_LINE (' Nume ' || v_emp.last_name ||
        ' are salariul anual : ' || v_emp.sal_an);
        FETCH c_emp INTO v_emp;
    END LOOP;
    CLOSE c_emp;
END;

--ex5
ACCEPT p_optiune PROMPT 'Introduceti optiunea (1,2 sau 3) '
DECLARE
TYPE emp_tip IS REF CURSOR RETURN emp_pnu%ROWTYPE;
V_emp emp_tip;
V_optiune NUMBER := &p_optiune;
linie emp_pnu%ROWTYPE;
BEGIN
    IF v_optiune = 1 THEN
        OPEN v_emp FOR SELECT * FROM emp_pnu;
        --!!! Introduceţi cod pentru afişare
    ELSIF v_optiune = 2 THEN
        OPEN v_emp FOR SELECT * FROM emp_pnu
        WHERE salary BETWEEN 10000 AND 20000;
        --!!! Introduceţi cod pentru afişare
    ELSIF v_optiune = 3 THEN
        OPEN v_emp FOR SELECT * FROM emp_pnu
        WHERE TO_CHAR(hire_date, 'YYYY') = 1990;
        --!!! Introduceţi cod pentru afişare
    ELSE
        DBMS_OUTPUT.PUT_LINE('Optiune incorecta');
        -- nu se mai ruleaza bucla de jos, se iese
        raise_application_error(-20134, 'Optiune incorecta');
    END IF;

    if v_emp%isopen THEN
        loop    
            fetch v_emp into linie;
            exit when v_emp%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(linie.employee_id||' '|| linie.salary || ' ' || linie.hire_date);
        end loop;
        close v_emp;
    end if;
END;


--cursor dinamic
ACCEPT p_optiune PROMPT 'Introduceti optiunea (1,2 sau 3) '
DECLARE
TYPE cursor_dinamic IS REF CURSOR;
v_cursor cursor_dinamic;
V_optiune NUMBER := &p_optiune;
linie_emp emp_pnu%rowtype;
linie_dept departments%rowtype;
linie_job jobs%rowtype;
BEGIN
    IF v_optiune = 1 THEN
        OPEN v_cursor FOR SELECT * FROM emp_pnu;
        loop    
            fetch v_cursor into linie_emp;
            exit when v_cursor%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(linie_emp.employee_id||' '|| linie_emp.salary || ' ' || linie_emp.hire_date);
        end loop;
    ELSIF v_optiune = 2 THEN
        OPEN v_cursor FOR SELECT * FROM departments;
        loop    
            fetch v_cursor into linie_dept;
            exit when v_cursor%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(linie_dept.department_id||' '|| linie_dept.department_name);
        end loop;
    ELSIF v_optiune = 3 THEN
        OPEN v_cursor FOR SELECT * FROM jobs;
        loop    
            fetch v_cursor into linie_job;
            exit when v_cursor%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(linie_job.job_id||' '|| linie_job.job_title);
        end loop;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Optiune incorecta');
    END IF;
END;


--examen: o functie locala declarata in declare
--Atentie!!! Functiile intorc tipuri de date generice (NUmber, nu Number(3)!!!)
-- Functiile au doar parametrii de tip IN ()

--daca se cere subprogram la examen, cu procedura nu se poate gresi
-- cu functie, daca trebuie sa intoarca doar un lucru, e ok

--functiile si procedurile se pot depana din FUNCTIons sau PROCEdures, iconita cu rotite:
-- pe margine sunt notate zonele rosii cu erori
-- in log apar erorile
-- se poate selecta compile for debug de la iconita cu rotite

--procedurile nu pot fi folosite in select, doar functiile

--functiile se cheama cu un select, procedurile cu execute

create or replace procedure first_pnu11(nume in varchar) is
azi date:=sysdate;
ieri azi%type;
begin
    dbms_output.put_line(nume || ' programare pl/sql');
    dbms_output.put_line(TO_CHAR(azi, 'dd-month-yyyy hh24:mi:ss'));
    ieri:=azi-1;
    dbms_output.put_line(to_char(ieri, 'dd-mon-yyyy'));
end;

execute first_pnu11('etc');

create table jobs_pnu11 as select * from jobs;


alter table jobs_pnu11 add constraint pk_jobs_pnu11 primary key (job_id);

--lab4ex3
CREATE OR REPLACE PROCEDURE ADD_JOB_pnu11
(p_job_id IN jobs.job_id%TYPE, p_job_title IN jobs.job_title%TYPE)
IS
BEGIN
    INSERT INTO jobs_pnu11 (job_id, job_title)
    VALUES (p_job_id, p_job_title);
    COMMIT;
END add_job_pnu11;

EXECUTE ADD_JOB_pnu11('IT_DBA', 'Database Administrator');
SELECT * FROM JOBS_pnu11;
EXECUTE ADD_JOB_pnu11('ST_MAN', 'Stock Manager');
SELECT * FROM JOBS_pnu11;


--ex4
CREATE OR REPLACE PROCEDURE UPD_JOB_pnu11
(p_job_id IN jobs.job_id%TYPE, p_job_title IN jobs.job_title%TYPE)
IS
BEGIN
    UPDATE jobs_pnu11
    SET job_title = p_job_title
    WHERE job_id = p_job_id;
    IF SQL%NOTFOUND THEN
        RAISE_APPLICATION_ERROR(-20202,'Nici o actualizare');
    END IF;
END upd_job_pnu11;

execute upd_job_pnu11('SA_MAN', 'Manager de resurse umane');


--examen: trebuie verificat input-ul procedurii 
--daca input-ul este job_id, verificam cu select count(*) deoarece nu returneaza null


CREATE OR REPLACE PROCEDURE UPD_JOB_pnu11
(p_job_id IN jobs.job_id%TYPE, p_job_title IN jobs.job_title%TYPE)
IS
nr number(2):=0;
BEGIN
    select count(*) into nr
    from jobs_pnu11
    where job_id=p_job_id;
    if nr=1 then
        update jobs_pnu11
        set job_title = p_job_title
        where job_id=p_job_id;
    else
        RAISE_APPLICATION_ERROR(-20202,'Nici o actualizare');
    END IF;
END upd_job_pnu11;


CREATE OR REPLACE PROCEDURE UPD_JOB_pnu11
(p_job_id IN jobs.job_id%TYPE, p_job_title IN jobs.job_title%TYPE)
IS
nr number(2):=0;
eroare exception;
BEGIN
    select count(*) into nr
    from jobs_pnu11
    where job_id=p_job_id;
    if nr=1 then
        update jobs_pnu11
        set job_title = p_job_title
        where job_id=p_job_id;
    else
        raise eroare;
    END IF;
    exception 
        when eroare then raise_application_error(-20202, 'Nici o actualizare');
END upd_job_pnu11;

--examen: unele subiecte pot cere tratarea erorilor (a exceptiilor) - se poate face in orice forma


--lab4 similar ex 6, dar cu functie

CREATE OR REPLACE FUNCTION p8l4_pnu11 (dep IN number)
return number
AS
p_salAvg employees.salary%type;
BEGIN
    SELECT round(AVG(salary),2) INTO p_salAvg
    FROM employees
    WHERE department_id=dep;
return p_salAvg;
END;

select p8l4_pnu11(20)
from dual;

update employees
set salary=salary+p8l4_pnu11(department_id);
-- ORA-04091: table IDD.EMPLOYEES is mutating, trigger/function may not see it
-- ORA-06512: at "IDD.P8L4_PNU11", line 6

--NU PUTEM MODIFICA TABELUL CARE ESTE BLOCAT DE COMANDA

--triggeri: blocuri Pl/sql care se declanseaza la un eveniment
--eveniment: context restrans (eveniment pe tabel: insert, delete, update) 
-- cand tabelul este sters, se sterge si triggerul
-- un trigger monitorizeaza un tabel, nu mai multe!
-- evenimente: inserting, deleting, updating

--trigger nu este egal cu o constrangere
--exista triggeri de before si after la nivel de tabel si de linie

--ordine:
--before tabel
--before linie
--after linie
--before linie
--after linie
--after tabel

--daca una faileaza, faileaza toate

--examen-probleme trigger:
--pas1: identificare tabel
--pas2: care sunt evenimentele la care trebuie sa se declanseze
--pas2.1: poti particulariza evenimentul? (doar pentru anumite coloane?)
--pas3: cand se declanseaza? before vs after
--pas4: trigger este la nivel de linie sau la nivel de tabel?

--lab5
CREATE OR REPLACE TRIGGER b_i_u_emp_pnu11
    BEFORE INSERT OR UPDATE OF salary ON emp_pnu
    FOR EACH ROW
BEGIN
    IF NOT (:NEW.job_id IN ('AD_PRES', 'AD_VP'))
    AND :NEW.salary > 15000
    THEN
    RAISE_APPLICATION_ERROR (-20202, 'Angajatul nu poate castiga aceasta suma');
    END IF;
END;

update emp_pnu
set salary=20000;

CREATE OR REPLACE TRIGGER b_i_u_emp_pnu11
    BEFORE INSERT OR UPDATE OF salary ON emp_pnu
    FOR EACH ROW
    --NEW nu merge cu : deoarece nu suntem in bloc pl/sql)
    WHEN (NEW.job_id not in ('AD_PRES','AD_VP'))
BEGIN
    IF :NEW.salary > 15000
    THEN
    RAISE_APPLICATION_ERROR (-20202, 'Angajatul nu poate castiga aceasta suma');
    END IF;
END;


CREATE OR REPLACE TRIGGER b_i_u_emp_pnu11
    BEFORE INSERT OR UPDATE OF salary ON emp_pnu
    FOR EACH ROW
    --NEW nu merge cu : deoarece nu suntem in bloc pl/sql)
    WHEN (NEW.job_id not in ('AD_PRES','AD_VP'))
BEGIN
    IF :NEW.salary > 15000
    THEN
    RAISE_APPLICATION_ERROR (-20202, 'Angajatul nu poate castiga aceasta suma');
    END IF;
END;


alter trigger nume disable;

drop trigger nume;


--sanse mari sa primit problema 9 (sau similara)

--examen
--proceduri functii si triggeri
--tipuri de date, blocuri pl/sql si sql

--differenta intre cursor si vector, poate fi de teorie
--unul are lungime fixa altul nu
--unul e pointer altul nu
--asemanari: ambele sunt tipuri de date

--identificare cheie primara
--definiti o structura de date ptr matrice
--inserati o linie intr-un tabel cu structurile de date gata definite

--Putem folosi documentatia de sQl developer
--nu avem voie cu laptop
--minim 90 minute examenul
--fara internet
--se da pe numere, cu diagrame diferite

--IARNA
--student profesor curs note
--enuntati o cerere (ca enunt) pe schema de mai sus care se poate rezolva cu ajutorul unei proceduri dar nu si a unei functii
--matrice 3x7
--bloc anonim care sa umple matricea cu numere prime
--semnalati greselile din enuntul urmator
--scrieti un subprogram/creati o functie/scrieti un trigger

--RESTANTA
--firma angajat utilaj
--functie care primeste cod firma si data calendaristica, returneaza cheltuieli cu salarii si achizitii utilaje
--adaugati o linie cu informatii relevante in tabelul X (care contine un tip special-o colectie)
--subprogram care populeaza tabelul de utilaje cu ceva conditii
--trigger

--student profesor curs note
--enuntati o cerere in limbaj natural care sa faca un program din cel putin 3 tabele


--vom numi tip3 un tip de date ce foloseste tip2 care foloseste tipul de date tip1.
--definiti un astfel de tip, spuneti ce reprezinta si utilizati-l intr-un bloc anonim 
--poate fi matrice 3d (tablou indexat)

--enuntati o cerere in limbaj nat care sa foloseasca un trigger la nivel de linie ptr delete si implementati-l


--lab5 ex9
--trigger pe employees
--insert sau update
--la nivel de linie
--ma pregatesc sa adaug un angajat
--vreau ca la linia 51 sa dea eroare fiindca deja erau 50 (trebuie facut count in prealabil)
--atunci cand am o scriere, nu mai pot sa consult tabelul, deoarece e blocat (vezi mai sus mutating)
--creez un spatiu in care salvez o lista cu nr de angajati in fiecare departament (folosesc trigger before, cu o variabila globala)
--tinem minte daca a fost insert sau update;
