--1. Care dintre urmatoarele declaratii nu sunt corecte si explicati de ce:
--a)
DECLARE
    v_id NUMBER(4);
-- Corect
--b)
DECLARE
    v_x, v_y, v_z VARCHAR2(10);
--Incorect, nu se pot declara mai multe pe linie var fara ";"
--c)
DECLARE
    v_birthdate DATE NOT NULL;
--Incorect, daca este NOT NULL trebuie initializata
--d)
DECLARE
    v_in_stock BOOLEAN := 1;
--Incorect, trebuie TRUE/FALSE
--e)
DECLARE
    TYPE name_table_type IS TABLE OF VARCHAR2(20)
    INDEX BY BINARY_INTEGER;
    dept_name_table name_table_type;
--Corect

--2. Determinati tipul de date al rezultatului in fiecare din atribuirile urmatoare:
a) v_days_to_go := v_due_date - SYSDATE; -- DATE
b) v_sender := USER || ': '||TO_CHAR(v_dept_no); --VARCHAR2(40)
c) v_sum := $100,000 + $250,000;  --INTREBARE? PARE NUMAR, DAR CU DOLAR? STRINGUL NU SE POATE SCRIE ASA...
d) v_flag :=TRUE; --BOOLEAN
e) v_n1 := v_n2 > (2 * v_n3); --BOOLEAN
f) v_value :=NULL; --Poate fi VARCHAR, NUMBER, si multe altele... Trebuie sa nu fie declarat NOT NULL
--INTREBARE? CARE ESTE RASPUNSUL CORECT LA PCT F?

--3. Se consideră următorul bloc PL/SQL:
<<bloc>>
DECLARE
    v_cantitate NUMBER(3) := 300;
    v_mesaj VARCHAR2(255) := 'Produs 1';
BEGIN
    <<subbloc>>
    DECLARE
        v_cantitate NUMBER(3) := 1;
        v_mesaj VARCHAR2(255) := 'Produs 2';
        v_locatie VARCHAR2(50) := 'Europa';
    BEGIN
        v_cantitate := v_cantitate + 1;
        v_locatie := v_locatie || 'de est';
    END;
    v_cantitate:= v_cantitate + 1;
    v_mesaj := v_mesaj ||' se afla in stoc';
    v_locatie := v_locatie || 'de est' ;
END;
/
Evaluaţi:
- valoarea variabilei v_cantitate în subbloc; --2
- valoarea variabilei v_locatie la poziţia în subbloc ; --Europe de est, având tipul VARCHAR2
- valoarea variabilei v_cantitate în blocul principal ; --601, iar tipul este NUMBER
--INTREBARE? DE UNDE VINE 601? NU ESTE 301?
- valoarea variabilei v_mesaj în blocul principal ; --'Produs 1 se afla in stoc'
- valoarea variabilei v_locaţie în blocul principal. --nu este corectă ; v_locatie nu este vizibilă în afara subblocului

--4. Să se creeze un bloc anonim în care se declară o variabilă v_oras de tipul coloanei city (locations.city%TYPE). 
--Atribuiţi acestei variabile numele oraşului în care se află departamentul având codul 30. Afişaţi în cele două moduri descrise anterior.
SET SERVEROUTPUT ON
DECLARE
    v_oras locations.city%TYPE;
BEGIN
    SELECT city
    INTO v_oras
    FROM departments d, locations l
    WHERE d.location_id=l.location_id AND department_id=30;
    DBMS_OUTPUT.PUT_LINE('Oraşul este '|| v_oras);
END;
/
SET SERVEROUTPUT OFF
VARIABLE g_oras VARCHAR2(20)
BEGIN
    SELECT city
    INTO :g_oras
    FROM departments d, locations l
    WHERE d.location_id=l.location_id AND department_id=30;
END;
/
PRINT g_oras

--Solutia mea (independenta)
SET SERVEROUTPUT ON
DECLARE
    v_oras locations.city%TYPE;
BEGIN
    SELECT CITY INTO v_oras
    FROM DEPARTMENTS D
    LEFT JOIN LOCATIONS L ON D.LOCATION_ID = L.LOCATION_ID
    WHERE D.DEPARTMENT_ID = 30;
    DBMS_OUTPUT.PUT_LINE('Orasul este ' || v_oras);
END;

--5. Să se creeze un bloc anonim în care să se afle media salariilor pentru angajaţii al căror departament este 50. 
--Se vor folosi variabilele v_media_sal de tipul coloanei salary şi v_dept (de tip NUMBER).

SET SERVEROUTPUT ON
DECLARE
v_media_sal employees.salary%TYPE;
v_dept NUMBER:=50;
BEGIN
SELECT AVG(salary)
INTO v_media_sal
FROM employees
WHERE department_id= v_dept;
DBMS_OUTPUT.PUT_LINE('media salariilor este '|| v_media_sal);
END;
/
SET SERVEROUTPUT OFF

--Solutia mea (independenta)
SET SERVEROUTPUT ON
DECLARE
 v_media_sal EMPLOYEES.SALARY%TYPE;
 v_dept NUMBER := 50;
BEGIN
 SELECT AVG(SALARY) INTO v_media_sal
 FROM EMPLOYEES 
 WHERE DEPARTMENT_ID=v_dept;
 DBMS_OUTPUT.PUT_LINE('Media ptr dept '|| v_dept||' este ' || v_media_sal);
END;

--6. Să se specifice dacă un departament este mare, mediu sau mic după cum numărul angajaţilor săi este mai mare ca 30, 
--cuprins între 10 şi 30 sau mai mic decât 10. Codul departamentului va fi cerut utilizatorului.
ACCEPT p_cod_dep PROMPT 'Introduceti codul departamentului '
DECLARE
v_cod_dep departments.department_id%TYPE := &p_cod_dep;
v_numar NUMBER(3) := 0;
v_comentariu VARCHAR2(10);
BEGIN
SELECT COUNT(*)
INTO v_numar
FROM employees
WHERE department_id = v_cod_dep;
IF v_numar < 10 THEN
v_comentariu := 'mic';
ELSIF v_numar BETWEEN 10 AND 30 THEN
v_comentariu := 'mediu';
ELSE
v_comentariu := 'mare';
END IF;
DBMS_OUTPUT.PUT_LINE('Departamentul avand codul' || v_cod_dep
|| 'este de tip' || v_comentariu);
END;
/
--Solutia mea (independenta)
SET SERVEROUTPUT ON
ACCEPT p_cod_dep PROMPT 'Introduceti codul departamentului '
DECLARE
    v_cod_dep departments.department_id%TYPE := &p_cod_dep;
    v_nr_utilizatori NUMBER(3) := 0;
BEGIN
    SELECT 
    COUNT(EMPLOYEE_ID)
    INTO v_nr_utilizatori
    FROM EMPLOYEES
    WHERE DEPARTMENT_ID = v_cod_dep;
    DBMS_OUTPUT.PUT_LINE('In departamentul ' || v_cod_dep || ' sunt ' || v_nr_utilizatori || ' angajati');
    IF v_nr_utilizatori>30 THEN
        DBMS_OUTPUT.PUT_LINE('Departamentul este mare');
    ELSIF v_nr_utilizatori BETWEEN 10 AND 30 THEN
        DBMS_OUTPUT.PUT_LINE('Departamentul este mediu');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Departamentul este mic');
    END IF;
END;

--7. Stocaţi într-o variabilă de substituţie p_cod_dep valoarea unui cod de departament. 
--Definiţi şi o variabilă p_com care reţine un număr din intervalul [0, 100). 
--Pentru angajaţii din departamentul respectiv care nu au comision, să se atribuie valoarea lui p_com câmpului commission_pct. 
--Afişaţi numărul de linii afectate de această actualizare. Dacă acest număr este 0, să se scrie « Nici o linie actualizata ».
SET SERVEROUTPUT ON
SET VERIFY OFF
DEFINE p_cod_dep= 50
DEFINE p_com =10
DECLARE
v_cod_dep emp_pnu.department_id%TYPE:= &p_cod_dep;
v_com NUMBER(2);
BEGIN
UPDATE emp_pnu
SET commission_pct = &p_com/100
WHERE department_id= v_cod_dep;
IF SQL%ROWCOUNT = 0 THEN
DBMS_OUTPUT.PUT_LINE('Nici o linie actualizata');
ELSE DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT ||' linii actualizate ');
END IF;
END;
/ -- ATENTIE! LINIILE URMATOARE SE FAC INTR-UN NOU QUERY (NU ESTE PERMIS "SET" dupa "END")!!!
SET VERIFY ON
SET SERVEROUTPUT OFF
Obs: (vom reveni în laboratorul despre cursoare)
Atributele cursoarelor implicite :
 SQL%ROWCOUNT – Numarul de linii afectate de cea mai recenta comanda SQL;
 SQL%FOUND – Atribut boolean ce returneaza TRUE daca ultima comanda SQL a afectat cel putin o linie;
 SQL%NOTFOUND – Atribut boolean ce returneaza TRUE daca ultima comanda SQL nu a afectat nici o linie
 SQL%ISOPEN – Atribut boolean ce returneaza TRUE daca cursorul implicit asociat ultimei comenzi a ramas deschis. Nu e niciodata true pentru ca serverul inchide automat cursorul la terminarea comenzii SQL.
--Solutia mea
SET SERVEROUTPUT ON
SET VERIFY OFF
DECLARE
    p_cod_dep EMPLOYEES.DEPARTMENT_ID%TYPE:=30;
    p_com NUMBER(2):=10;
BEGIN
    UPDATE employees
    SET commission_pct = &p_com/100
    WHERE commission_pct IS NULL
    AND department_id = p_cod_dep;

    IF SQL%ROWCOUNT = 0 THEN 
        DBMS_OUTPUT.PUT_LINE('Nicio linie actualizata');
    ELSE
        DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' linii actualizate');
    END IF;
END;

SELECT * 
FROM EMPLOYEES
WHERE COMMISSION_PCT IS NULL;


--8. În structura tabelului emp_pnu se va introduce un nou câmp (stea de tip VARCHAR2(200)). 
--Să se creeze un bloc PL/SQL care va reactualiza acest câmp, 
--introducând o steluţă pentru fiecare 100$ din salariul unui angajat al cărui cod este specificat de către utilizator.
ALTER TABLE emp_pnu
ADD stea VARCHAR2(200);
SET VERIFY OFF
ACCEPT p_cod_ang PROMPT 'Dati codul unui angajat'
DECLARE
v_cod_ang emp_pnu.employee_id%TYPE := &p_cod_ang;
v_salariu emp_pnu.salary%TYPE;
v_stea emp_pnu.stea%TYPE:= NULL;
BEGIN
SELECT NVL(ROUND(salary/100),0)
INTO v_salariu
FROM emp_pnu
WHERE employee_id = v_cod_ang;
FOR i IN 1..v_salariu LOOP
v_stea := v_stea || '*'
END LOOP;
UPDATE emp_pnu
SET stea = v_stea
WHERE employee_id = v_cod_ang;
COMMIT;
END;
/
SET VERIFY ON
--Solutia mea
SET SERVEROUTPUT ON;
DECLARE
    v_cod EMPLOYEES.EMPLOYEE_ID%TYPE:=&v_cod;
    v_sal EMPLOYEES.SALARY%TYPE;
    v_result VARCHAR2(300):=''; 
BEGIN  
    --find no of stars
    SELECT ROUND(SALARY/100)
    INTO v_sal
    FROM EMPLOYEES
    WHERE EMPLOYEE_ID = v_cod;
    
    --create new string
    FOR i IN 1..v_sal LOOP
          v_result := v_result || '*';
    END LOOP;
    
    --update employee's star field
    UPDATE EMPLOYEES 
    SET stea = v_result
    WHERE EMPLOYEE_ID = v_cod;
END;