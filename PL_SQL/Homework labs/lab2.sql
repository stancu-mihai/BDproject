-- 1. Să se şteargă angajatul având codul 200 din tabelul EMP_PNU. Să se reţină într-o variabilă de tip RECORD codul, 
-- numele, salariul şi departamentul acestui angajat (clauza RETURNING) . Să se afişeze înregistrarea respectivă. Rollback.
DECLARE
TYPE info_ang_pnu IS RECORD (
cod_ang NUMBER(4),
nume VARCHAR2(20),
salariu NUMBER(8),
cod_dep NUMBER(4));
v_info_ang info_ang_pnu;
BEGIN
DELETE FROM emp_pnu
WHERE employee_id = 200
RETURNING employee_id, last_name, salary, department_id
INTO v_info_ang;
DBMS_OUTPUT.PUT_LINE(‘A fost stearsa linia continand valorile ‘ ||
v_info_ang.cod_ang ||’ ‘||v_info_ang.nume||’ ‘ ||v_info_ang.salariu ||’ ‘
|| v_info_ang.cod_dep) ;
END;
/
ROLLBACK ;
--Solutia mea (independenta)
SET SERVEROUTPUT ON
SET VERIFY OFF
DECLARE
v_cod NUMBER(3) := 200;
TYPE v_angajat_type IS RECORD (
    cod EMPLOYEES.EMPLOYEE_ID%TYPE,
    nume EMPLOYEES.FIRST_NAME%TYPE,
    salariu EMPLOYEES.SALARY%TYPE,
    departament EMPLOYEES.DEPARTMENT_ID%TYPE);
v_angajat v_angajat_type;
BEGIN
    DELETE FROM EMPLOYEES
    WHERE EMPLOYEE_ID = v_cod
    RETURNING EMPLOYEE_ID, FIRST_NAME, SALARY, DEPARTMENT_ID
    INTO v_angajat;
    
    DBMS_OUTPUT.PUT_LINE('Nume: ' || v_angajat.nume || 
                         ', salariu:' || v_angajat.salariu || 
                         ' dep:' || v_angajat.departament);
END;

--2. Să se definească un tablou indexat PL/SQL având elemente de tipul NUMBER. 
--Să se introducă 20 de elemente în acest tablou. Să se afişeze, apoi să se şteargă tabloul utilizând diverse metode.
DECLARE
TYPE tablou_numar IS TABLE OF NUMBER
INDEX BY PLS_INTEGER;
v_tablou tablou_numar;
v_aux tablou_numar; -- tablou folosit pentru stergere
BEGIN
FOR i IN 1..20 LOOP
v_tablou(i) := i*i;
DBMS_OUTPUT.PUT_LINE(v_tablou(i));
END LOOP;
--v_tablou := NULL;
--aceasta atribuire da eroarea PLS-00382
FOR i IN v_tablou.FIRST..v_tablou.LAST LOOP -- metoda 1 de stergere
v_tablou(i) := NULL;
END LOOP;
--sau
v_tablou := v_aux; -- metoda 2 de stergere
--sau
v_tablou.delete; --metoda 3 de stergere
DBMS_OUTPUT.PUT_LINE('tabloul are ' || v_tablou.COUNT ||
' elemente');
END;
--Solutia mea (independenta)
SET SERVEROUTPUT ON
SET VERIFY OFF
DECLARE
    TYPE ti IS TABLE OF NUMBER 
    INDEX BY PLS_INTEGER;
    v_tablou ti;
    v_tablou_nul ti;
BEGIN
    FOR i IN 1..20 LOOP
          v_tablou(i) := i;
          DBMS_OUTPUT.PUT_LINE('tablou(' || i || ')=' || v_tablou(i));
    END LOOP;
    
    FOR i IN v_tablou.FIRST..v_tablou.LAST LOOP
        v_tablou(i):= null; --stergere element cu element
    END LOOP;
    --Stergere prin atribuire tablou nul
    v_tablou := v_tablou_nul;
    --Stergere directa
    v_tablou.delete;
END;

--3. Să se definească un tablou de înregistrări având tipul celor din tabelul dept_pnu. 
--Să se iniţializeze un element al tabloului şi să se introducă în tabelul dept_pnu. Să se şteargă elementele tabloului.
DECLARE
TYPE dept_pnu_table_type IS TABLE OF dept_pnu%ROWTYPE
INDEX BY BINARY_INTEGER;
dept_table dept_pnu_table_type;
i NUMBER;
BEGIN
IF dept_table.COUNT <>0 THEN
i := dept_table.LAST+1;
ELSE i:=1;
END IF;
dept_table(i).department_id := 92;
dept_table(i).department_name := 'NewDep';
dept_table(i).location_id := 2700;
INSERT INTO dept_pnu(department_id, department_name, location_id)
VALUES (dept_table(i).department_id,
dept_table(i).department_name,
dept_table(i).location_id);
-- sau folosind noua facilitate Oracle9i
-- INSERT INTO dept_pnu
-- VALUES dept_table(i);
dept_table.DELETE; -- sterge toate elementele
DBMS_OUTPUT.PUT_LINE('Dupa aplicarea metodei DELETE
sunt '||TO_CHAR(dept_table.COUNT)||' elemente');
END;
--Solutia mea
SET SERVEROUTPUT ON
SET VERIFY OFF
DECLARE
    TYPE ti IS TABLE OF DEPARTMENTS%rowtype
    INDEX BY BINARY_INTEGER;
    v_row departments%rowtype;
    v_tablou ti;
BEGIN
    v_row.DEPARTMENT_ID :=11;
    v_row.DEPARTMENT_NAME :='TestDep';
    v_row.MANAGER_ID :=100;
    v_row.LOCATION_ID :=1000;
    v_tablou(1):=v_row;
    
    INSERT INTO DEPARTMENTS(DEPARTMENT_ID,DEPARTMENT_NAME,MANAGER_ID,LOCATION_ID) 
    VALUES(v_tablou(1).DEPARTMENT_ID, v_tablou(1).DEPARTMENT_NAME, v_tablou(1).MANAGER_ID,v_tablou(1).LOCATION_ID) ;
    
    v_tablou.delete;
END;

--4. Analizaţi şi comentaţi exemplul următor.
DECLARE
TYPE secventa IS VARRAY(5) OF VARCHAR2(10);
v_sec secventa := secventa ('alb', 'negru', 'rosu','verde');
BEGIN
v_sec (3) := 'rosu';
v_sec.EXTEND; -- adauga un element null
v_sec(5) := 'albastru';
-- extinderea la 6 elemente va genera eroarea ORA-06532
v_sec.EXTEND;
END;


--5. a) Să se declare un tip proiect_pnu care poate reţine maxim 50 de valori de tip VARCHAR2(15).
--b) Să se creeze un tabel test_pnu având o coloana cod_ang de tip NUMBER(4) şi o coloană proiecte_alocate de tip proiect_pnu. 
--Ce relaţie se modelează în acest fel?
--c) Să se creeze un bloc PL/SQL care declară o variabilă (un vector) de tip proiect_pnu, 
--introduce valori în aceasta iar apoi valoarea vectorului respectiv este introdusă pe una din liniile tabelului test_pnu.
CREATE TYPE proiect_pnu AS VARRAY(50) OF VARCHAR2(15)
/
CREATE TABLE test_pnu (cod_ang NUMBER(4),
proiecte_alocate proiect_pnu);

--Blocul PL/SQL:

DECLARE
    v_proiect proiect_pnu := proiect_pnu(); --initializare utilizând constructorul
BEGIN
    v_proiect.extend (2);
    v_proiect(1) := 'proiect 1';
    v_proiect(2) := 'proiect 2';
    INSERT INTO test_pnu VALUES (1, v_proiect);
END;
--Solutia mea(independenta)
CREATE OR REPLACE TYPE proiect_pnu IS VARRAY(50) OF VARCHAR2(15);
CREATE TABLE test_pnu (cod_ang NUMBER(4), proiecte_alocate proiect_pnu);
/
SET SERVEROUTPUT ON
SET VERIFY OFF
DECLARE
    v_proiect proiect_pnu:= proiect_pnu();
BEGIN
    v_proiect.extend(50);--add fifty elements
    INSERT INTO test_pnu VALUES(1,v_proiect);
    INSERT INTO test_pnu VALUES(2,v_proiect);
    FOR i IN 1..50 LOOP
        v_proiect(i):=2*i;
    END LOOP;
    INSERT INTO test_pnu VALUES(3,v_proiect);
END;

--7. Să se declare un tip tablou imbricat şi o variabilă de acest tip. 
--Iniţializaţi variabila şi afişaţi conţinutul tabloului, de la primul la ultimul element şi invers.
DECLARE
TYPE CharTab IS TABLE OF CHAR(1);
v_Characters CharTab :=
CharTab('M', 'a', 'd', 'a', 'm', ',', ' ','I', '''', 'm', ' ', 'A', 'd', 'a', 'm');
v_Index INTEGER;
BEGIN
v_Index := v_Characters.FIRST;
WHILE v_Index <= v_Characters.LAST LOOP
DBMS_OUTPUT.PUT(v_Characters(v_Index));
v_Index := v_Characters.NEXT(v_Index);
END LOOP;
DBMS_OUTPUT.NEW_LINE;
v_Index := v_Characters.LAST;
WHILE v_Index >= v_Characters.FIRST LOOP
DBMS_OUTPUT.PUT(v_Characters(v_Index));
v_Index := v_Characters.PRIOR(v_Index);
END LOOP;
DBMS_OUTPUT.NEW_LINE;
END;
--Solutia mea (independenta)
SET SERVEROUTPUT ON
SET VERIFY OFF
DECLARE 
    TYPE tablou IS TABLE OF CHAR(1);
    v_var tablou:=tablou('A','n','a', ' ', 'a', 'r', 'e', ' ' , 'm', 'e', 'r', 'e');
BEGIN
    FOR i IN v_var.FIRST..v_var.LAST LOOP
        DBMS_OUTPUT.PUT_LINE(v_var(i));
    END LOOP;
    
    FOR i IN REVERSE v_var.FIRST..v_var.LAST LOOP
        DBMS_OUTPUT.PUT_LINE(v_var(i));
    END LOOP;
END;

--8. Creaţi un tip tablou imbricat, numit NumTab.
--Afişaţi conţinutul acestuia, utilizând metoda EXISTS. 
--Atribuiţi valorile tabloului unui tablou index-by. Afişaţi şi acest tablou, in ordine inversă.

DECLARE -- cod partial, nu sunt declarate tipurile!
v_NestedTable NumTab := NumTab(-7, 14.3, 3.14159, NULL, 0);
v_Count BINARY_INTEGER := 1;
v_IndexByTable IndexByNumTab;
BEGIN
LOOP
IF v_NestedTable.EXISTS(v_Count) THEN
DBMS_OUTPUT.PUT_LINE(
'v_NestedTable(' || v_Count || '): ' ||
v_NestedTable(v_Count));
v_IndexByTable(v_count) := v_NestedTable(v_count);
v_Count := v_Count + 1;
ELSE
EXIT;
END IF;
END LOOP;
-- atribuire invalida
-- v_IndexByTable := v_NestedTable;
v_Count := v_IndexByTable.COUNT;
LOOP
IF v_IndexByTable.EXISTS(v_Count) THEN
DBMS_OUTPUT.PUT_LINE(
'v_IndexByTable(' || v_Count || '): ' ||
v_IndexByTable(v_Count));
v_Count := v_Count - 1;
ELSE
EXIT;
END IF;
END LOOP;
END;
--Solutia mea (independenta)
SET SERVEROUTPUT ON
SET VERIFY OFF
DECLARE
    TYPE NumTab IS TABLE OF CHAR(1);
    TYPE Indexed IS TABLE OF CHAR(1)
    INDEX BY PLS_INTEGER;
    v_numtab NumTab:=NumTab('A','n','a', ' ', 'a', 'r', 'e', ' ' , 'm', 'e', 'r', 'e');
    v_indexed Indexed;
    i NUMBER(4):=1;
    n NUMBER(4);
BEGIN
    n:=v_numtab.COUNT;
    LOOP
        IF v_numtab.EXISTS(i) THEN
            DBMS_OUTPUT.PUT_LINE ('v_numtab(' || i || ')=' || v_numtab(i)); 
            v_indexed(n-i+1) := v_numtab(i);
            i:=i+1;
        ELSE
            EXIT;            
        END IF;
    END LOOP;
    
    i:=1;
    LOOP
        IF v_indexed.EXISTS(i) THEN
            DBMS_OUTPUT.PUT_LINE ('v_indexed(' || i || ')=' || v_indexed(i)); 
            i:=i+1;
        ELSE
            EXIT;            
        END IF;
    END LOOP;
END;

--9. Analizaţi următorul exemplu, urmărind excepţiile semnificative care apar în cazul utilizării incorecte a colecţiilor:
DECLARE
TYPE numar IS TABLE OF INTEGER;
alfa numar;
BEGIN
alfa(1) := 77;
-- declanseaza exceptia COLLECTION_IS_NULL
alfa := numar(15, 26, 37);
alfa(1) := ASCII('X');
alfa(2) := 10*alfa(1);
alfa('P') := 77;
/* declanseaza exceptia VALUE_ERROR deoarece indicele
nu este convertibil la intreg */
alfa(4) := 47;
/* declanseaza exceptia SUBSCRIPT_BEYOND_COUNT deoarece
indicele se refera la un element neinitializat */
alfa(null) := 7; -- declanseaza exceptia VALUE_ERROR
alfa(0) := 7; -- exceptia SUBSCRIPT_OUTSIDE_LIMIT
alfa.DELETE(1);
IF alfa(1) = 1 THEN … -- exceptia NO_DATA_FOUND
…
END;

-- 10. a) Să se creeze un tip LIST_ANG_PNU, de tip vector, cu maxim 10 componente de tip NUMBER(4).
-- b) Să se creeze un tabel JOB_EMP_PNU, având coloanele: 
--cod_job de tip NUMBER(3), titlu_job de tip VARCHAR2(25) şi info de tip LIST_ANG_PNU.
-- c) Să se creeze un bloc PL/SQL care declară şi iniţializează două variabile de tip LIST_ANG_PNU, 
--o variabilă de tipul coloanei info din tabelul JOB_EMP_PNU şi o variabilă de tipul codului job-ului. 
--Să se insereze prin diverse metode 3 înregistrări în tabelul JOB_EMP_PNU.
CREATE OR REPLACE TYPE list_ang_pnu AS VARRAY(10) OF NUMBER(4)
/
CREATE TABLE job_emp_pnu (cod_job NUMBER(3),titlu_job VARCHAR2(25),info list_ang_pnu);DECLARE
v_list list_ang_pnu := list_ang_pnu (123, 124, 125);
v_info_list list_ang_pnu := list_ang_pnu (700);
v_info job_emp_pnu.info%TYPE;
v_cod job_emp_pnu.cod_job%TYPE := 7;
i INTEGER;
BEGIN
    INSERT INTO job_emp_pnu
    VALUES (5, 'Analist', list_ang_pnu (456, 457));
    INSERT INTO job_emp_pnu
    VALUES (7, 'Programator', v_list);
    INSERT INTO job_emp_pnu
    VALUES (10, 'Inginer', v_info_list);
    SELECT info
    INTO v_info
    FROM job_emp_pnu
    WHERE cod_job = v_cod;
    --afisare v_info
    DBMS_OUTPUT.PUT_LINE('v_info:');
    i := v_info.FIRST;
    while (i <= v_info.last) loop
        DBMS_OUTPUT.PUT_LINE(v_info(i));
        i := v_info.next(i);
    end loop;
END;
/
ROLLBACK;
--Solutia mea (independenta)
CREATE OR REPLACE TYPE list_ang_pnu AS VARRAY(10) OF NUMBER(4);
/
CREATE TABLE job_emp_pnu (cod_job NUMBER(3), titlu_job VARCHAR2(25), info LIST_ANG_PNU);
/
SET SERVEROUTPUT ON
SET VERIFY OFF
DECLARE
    v_var1 list_ang_pnu:=LIST_ANG_PNU(10, 20, 30, 40);
    v_var2 list_ang_pnu;
    v_info job_emp_pnu.info%TYPE:=LIST_ANG_PNU(1, 2, 3, 4);
    v_cod job_emp_pnu.cod_job%TYPE:=100;
BEGIN
    INSERT INTO job_emp_pnu VALUES(v_cod, 'Test job', v_info);
END;

-- 11. Creaţi un tip de date tablou imbricat DateTab_pnu cu elemente de tip DATE. 
--Creati un tabel FAMOUS_DATES_PNU având o coloană de acest tip. 
--Declaraţi o variabilă de tip DateTab_pnu şi adăugaţi-i 5 date calendaristice.
--Ştergeţi al doilea element şi apoi introduceţi tabloul în tabelul FAMOUS_DATES_PNU. Selectaţi-l din tabel. Afişaţi la fiecare pas.
-- Obs: După crearea tabelului (prin comanda CREATE TABLE), pentru fiecare câmp de tip tablou imbricat din tabel este necesară clauza de stocare:
NESTED TABLE nume_câmp STORE AS nume_tabel;

DROP TABLE famous_dates_pnu;
DROP TYPE DateTab_pnu;
CREATE OR REPLACE TYPE DateTab_pnu AS
TABLE OF DATE;
/
CREATE TABLE famous_dates_pnu (key VARCHAR2(100) PRIMARY KEY,date_list DateTab_pnu)
NESTED TABLE date_list STORE AS dates_tab;

Blocul PL/SQL:

DECLARE
v_Dates DateTab_pnu := DateTab_pnu(TO_DATE('04-JUL-1776', 'DD-MON-YYYY'),
TO_DATE('12-APR-1861', 'DD-MON-YYYY'),
TO_DATE('05-JUN-1968', 'DD-MON-YYYY'),
TO_DATE('26-JAN-1986', 'DD-MON-YYYY'),
TO_DATE('01-JAN-2001', 'DD-MON-YYYY'));
-- Procedura locala pentru afisarea unui DateTab.
PROCEDURE Print(p_Dates IN DateTab_pnu) IS
    v_Index BINARY_INTEGER := p_Dates.FIRST;
BEGIN
    WHILE v_Index <= p_Dates.LAST LOOP
        DBMS_OUTPUT.PUT(' ' || v_Index || ': ');
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(p_Dates(v_Index),
        'DD-MON-YYYY'));
        v_Index := p_Dates.NEXT(v_Index);
    END LOOP;
END Print;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Valoarea initiala a tabloului');
    Print(v_Dates);
    INSERT INTO famous_dates_pnu (key, date_list)
    VALUES ('Date importante', v_Dates);
    v_Dates.DELETE(2); -- tabloul va avea numai 4 elemente
    SELECT date_list
    INTO v_Dates
    FROM famous_dates
    WHERE key = 'Date importante';
    DBMS_OUTPUT.PUT_LINE('Tabloul dupa INSERT si SELECT:');
    Print(v_Dates);
END;
/
ROLLBACK;
--Solutia mea(independenta)
CREATE OR REPLACE TYPE DateTab_pnu AS TABLE OF DATE;

CREATE TABLE famous_dates_pnu (date_list DateTab_pnu)
NESTED TABLE date_list STORE AS dates_tab;

SET SERVEROUTPUT ON
SET VERIFY OFF
DECLARE
    v_var1 DateTab_pnu:=DateTab_pnu(TO_DATE('01-JAN-2020','DD-MON-YYYY'), 
                                    TO_DATE('02-FEB-2019','DD-MON-YYYY'), 
                                    TO_DATE('03-MAR-2018','DD-MON-YYYY'), 
                                    TO_DATE('04-APR-2017','DD-MON-YYYY'),
                                    TO_DATE('05-MAY-2016','DD-MON-YYYY'));
BEGIN
    v_var1.DELETE(2);
    INSERT INTO Famous_Dates_Pnu(DATE_LIST) VALUES(v_var1);
END;
