--1(2pct)Sa se citeasca o valoare n de la tastatura. Prin intermediul unui cursor sa se gasesca angajatii cu salariu mai mare decat n.
--Pentru fiecare linie gasita de cursor, daca angajatul are comision, sa se afiseze numele sau si salariul.
SET SERVEROUTPUT ON
ACCEPT p_n PROMPT 'Introduceti limita salariu:';
DECLARE
    v_n NUMBER:=&p_n;
BEGIN
    FOR ang IN 
        (SELECT LAST_NAME, SALARY
        FROM EMPLOYEES
        WHERE COMMISSION_PCT IS NOT NULL
        AND SALARY > v_n) LOOP
        DBMS_OUTPUT.PUT_LINE('Nume:' || ANG.LAST_NAME || ' are salariul: ' || ang.SALARY);
    END LOOP;
END;

--2(3pct) Creati un tip de date tablou imbricat. 
--Initializati la declarare o variabila ce foloseste tipul definit anterior cu cel putin 100 de valori.
--Stergeti componentele impare.
--Afisati continutul tabloului. 
--Atribuiti valorile tabloului imbricat unui tablou indexat.
--Afisati si acest tablou, dar in ordine inversa
SET SERVEROUTPUT ON;
DECLARE
    TYPE t_ntable IS TABLE OF NUMBER;
    TYPE t_itable IS TABLE OF NUMBER
    INDEX BY PLS_INTEGER;
    v_ntable t_ntable:=t_ntable(1,2,3,4,5,6,7,8,9,10,
    11,12,13,14,15,16,17,18,19,20,
    21,22,23,24,25,26,27,28,29,30,
    31,32,33,34,35,36,37,38,39,40,
    41,42,43,44,45,46,47,48,49,50,
    51,52,53,54,55,56,57,58,59,60,
    61,62,63,64,65,66,67,68,69,70,
    71,72,73,74,75,76,77,78,79,80,
    81,82,83,84,85,86,87,88,89,90,
    91,92,93,94,95,96,97,98,99,100);
    v_itable t_itable;
    v_i NUMBER:=1;
BEGIN
    DBMS_OUTPUT.PUT_LINE('########Tablou imbricat:##########');
    FOR i IN v_ntable.FIRST..v_ntable.LAST LOOP
        IF MOD(v_ntable(i),2) = 1 THEN 
            v_ntable(i):=null;
        ELSE
            DBMS_OUTPUT.PUT_LINE(i);
            v_itable(v_i):=v_ntable(i);
            v_i:=v_i+1;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('########Tablou indexat:##########');
    FOR i IN REVERSE v_itable.FIRST..v_itable.LAST LOOP
        DBMS_OUTPUT.PUT_LINE(v_itable(i));
    END LOOP;
END;

--3(2pct) Sa se creeze o procedura stocata care primeste printr-un parametru codul unui angajat si 
--returneaza prin intermediul aceluiasi parametru salariul angajatului actualizat astfel: daca are salariul mai mic de 3000, 
--valoarea acestuia creste cu 20%, daca este cuprins intre 3000 si 7000, 
--valoarea creste cu 15% daca este mai mare de 7000 va fi marit doar cu 10%
--iar daca salariul este null va returna valoarea 1000. Apelati
create or replace PROCEDURE Test (v_param IN OUT NUMBER)
IS
    v_var EMPLOYEES.SALARY%TYPE;
BEGIN
    SELECT SALARY
    INTO v_var
    FROM EMPLOYEES
    WHERE EMPLOYEE_ID = v_param;
    IF v_var IS NULL THEN
        v_param:=1000;
    ELSIF v_var<3000 THEN --128
        v_param:=v_var*1.2;
    ELSIF v_var BETWEEN 3000 AND 7000 THEN --123
        v_param:=v_var*1.15;
    ELSE --100
        v_param:=v_var*1.1;
    END IF;
END;

Execute Test(128); --Err! Don't know how to retrieve the data!

--4(2pct) Sa se creeze un trigger care garanteaza ca salariul angajatilor se incadreaza intre
--minimul si maximul salariilor definite pentru job-ul detinut de fiecare angajat.
CREATE OR REPLACE TRIGGER I_U_Salary
BEFORE INSERT OR UPDATE OF SALARY ON EMPLOYEES
FOR EACH ROW
DECLARE 
    v_min EMPLOYEES.SALARY%TYPE;
    v_max EMPLOYEES.SALARY%TYPE;
BEGIN
    SELECT MIN_SALARY, MAX_SALARY
    INTO v_min, v_max
    FROM JOBS
    WHERE JOB_ID=:NEW.JOB_ID;
    IF :NEW.SALARY NOT BETWEEN v_min AND v_max THEN
        RAISE_APPLICATION_ERROR(-20202, 'Salariul nu este intre limitele jobului');
    END IF;
END;