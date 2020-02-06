--1. Să se obţină câte o linie de forma ‘ <nume> are salariul anual <salariu annual> pentru fiecare angajat din departamentul 50. 
--Se cer 4 soluţii (WHILE, LOOP, FOR specific cursoarelor cu varianta de scriere a cursorului în interiorul său).
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
DBMS_OUTPUT.PUT_LINE (‘ Nume:’ || v_emp.last_name ||
‘ are salariul anual : ‘ || v_emp.sal_an);
FETCH c_emp INTO v_emp;
END LOOP;
CLOSE c_emp;
END;
Soluţia 2:
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
DBMS_OUTPUT.PUT_LINE (‘ Nume:’ || v_emp.last_name ||
‘ are salariul anual : ‘ || v_emp.sal_an);
END LOOP;
CLOSE c_emp;
END;
Soluţia 3: // nu mai este nevoie explicit de OPEN, FETCH, CLOSE !!!
DECLARE
CURSOR c_emp IS
SELECT last_name, salary*12 sal_an
FROM emp_pnu
WHERE department_id = 50;
BEGIN
FOR v_emp IN c_emp LOOP
DBMS_OUTPUT.PUT_LINE (‘ Nume:’ || v_emp.last_name ||
‘ are salariul anual : ‘ || v_emp.sal_an);
END LOOP;
END;
Soluţia 4:
BEGIN
FOR v_rec IN (SELECT last_name, salary*12 sal_an
FROM employees
WHERE department_id = 50) LOOP
DBMS_OUTPUT.PUT_LINE (‘ Nume:’ || v_rec.last_name ||
‘ are salariul anual : ‘ || v_rec.sal_an);
END LOOP;
END;

--Solutiile mele (independente)
-- FOR
SET SERVEROUTPUT ON
DECLARE
    CURSOR c_cursor IS
        SELECT first_name, salary * 12 AS an_sal
        FROM employees
        WHERE DEPARTMENT_ID=50;
    v_cursor c_cursor%ROWTYPE;
    v_n NUMBER(8);
BEGIN
    OPEN c_cursor;
    SELECT count(*) 
    INTO v_n
    FROM employees
    WHERE DEPARTMENT_ID=50;
    
    FOR i IN 1..v_n LOOP
        FETCH c_cursor INTO v_cursor;
        DBMS_OUTPUT.PUT_LINE(v_cursor.first_name || ' are salariul anual ' || v_cursor.an_sal);
    END LOOP;
    CLOSE c_cursor;
END;

--While
SET SERVEROUTPUT ON
DECLARE
    CURSOR c_cursor IS
        SELECT first_name, salary * 12 AS an_sal
        FROM employees
        WHERE DEPARTMENT_ID=50;
    v_cursor c_cursor%ROWTYPE;
    v_n NUMBER(8);
BEGIN
    OPEN c_cursor;
    FETCH c_cursor INTO v_cursor;
    WHILE c_cursor%FOUND LOOP
          FETCH c_cursor INTO v_cursor;
          DBMS_OUTPUT.PUT_LINE(v_cursor.first_name || ' are salariul anual ' || v_cursor.an_sal);
    END LOOP;
    CLOSE c_cursor;
END;

--LOOP
SET SERVEROUTPUT ON
DECLARE
    CURSOR c_cursor IS
        SELECT first_name, salary * 12 AS an_sal
        FROM employees
        WHERE DEPARTMENT_ID=50;
    v_cursor c_cursor%ROWTYPE;
    v_n NUMBER(8);
BEGIN
    OPEN c_cursor;
    LOOP
          DBMS_OUTPUT.PUT_LINE(v_cursor.first_name || ' are salariul anual ' || v_cursor.an_sal);
          FETCH c_cursor INTO v_cursor;
          EXIT WHEN c_cursor%NOTFOUND;
    END LOOP;
    CLOSE c_cursor;
END;

--FOR without OPEN, CLOSE, and FETCH
SET SERVEROUTPUT ON
DECLARE
    CURSOR c_cursor IS
        SELECT first_name, salary * 12 AS an_sal
        FROM employees
        WHERE DEPARTMENT_ID=50;
BEGIN
    FOR i IN c_cursor LOOP
        DBMS_OUTPUT.PUT_LINE(i.first_name || ' are salariul anual ' || i.an_sal);
    END LOOP;
END;

--FOR without cursor
SET SERVEROUTPUT ON
BEGIN
    FOR i IN (SELECT first_name, salary * 12 AS an_sal
        FROM employees
        WHERE DEPARTMENT_ID=50) LOOP
        DBMS_OUTPUT.PUT_LINE(i.first_name || ' are salariul anual ' || i.an_sal);
    END LOOP;
END;

--2. Creaţi un bloc PL/SQL care determină cele mai mari n salarii, urmând paşii descrişi în continuare:
--a) creaţi un tabel top_salarii_pnu, având o coloană salary.
--b) Numărul n (al celor mai bine plătiţi salariaţi) se va introduce de către utilizator 
--(se va folosi comanda SQL*Plus ACCEPT şi o varianilă de substituţie p_num).
--c) În secţiunea declarativă a blocului PL/SQL se vor declara 2 variabile: 
--v_num de tip NUMBER (corespunzătoare lui p_num) şi 
--v_sal de tipul coloanei salary. 
--Se va declara un cursor emp_cursor pentru regăsirea salariilor în ordine descrescătoare (se presupune că nu avem valori duplicate).
--d) Se vor introduce cele mai mari mai bine plătiţi n angajaţi în tabelul top_salarii_pnu;
--e) Afişaţi conţinurtul tabelului top_salarii_pnu.
--f) Testaţi cazuri speciale, de genul n = 0 sau n mai mare decât numărul de angajaţi. 
--Se vor elimina înregistrările din tabelul top_salarii_pnu după fiecare test.
ACCEPT p_num PROMPT ‘ … ‘
DECLARE
    V_num NUMBER(3) := &p_num;
    V_sal emp_pnu.salary%TYPE;
    CURSOR emp_cursor IS
        SELECT DISTINCT salary
        FROM emp_pnu
        ORDER BY salary DESC;
BEGIN
    OPEN emp_cursor; -- folositi si alte variante de lucru cu cursorul !!!!
        FETCH emp_cursor INTO v_sal;
        WHILE emp_cursor%ROWCOUNT <= v_num AND emp_cursor%FOUND LOOP
            INSERT INTO top_salarii_pnu (salary)
            VALUES (v_sal);
            FETCH emp_cursor INTO v_sal;
        END LOOP;
    CLOSE emp_cursor;
END;
/
SELECT * FROM top_salarii_pnu;

--Solutia mea (independenta)
CREATE TABLE top_salarii_pnu (SALARY NUMBER(8));
/
SET SERVEROUTPUT ON
DECLARE 
    v_num NUMBER(8):=&p_pnum;
    v_i NUMBER(8);
    v_sal EMPLOYEES.SALARY%TYPE;
    CURSOR emp_cursor IS 
        SELECT salary 
        FROM EMPLOYEES
        ORDER BY salary DESC;
    v_cursor emp_cursor%ROWTYPE;
BEGIN
    IF v_num=0 THEN
        DBMS_OUTPUT.PUT_LINE('n=0! Se termina programul... ');
    ELSE
        OPEN emp_cursor;
        v_i:=0;
        LOOP
            FETCH emp_cursor INTO v_cursor;
            EXIT WHEN emp_cursor%NOTFOUND;          
            EXIT WHEN v_i>=v_num;
            INSERT INTO top_salarii_pnu(salary) VALUES (v_cursor.salary);
            DBMS_OUTPUT.PUT_LINE(v_cursor.salary);
            v_i:=v_i+1;
        END LOOP;
        CLOSE emp_cursor;
        DELETE FROM top_salarii_pnu;
    END IF;
END;

--3. Să se declare un cursor cu un parametru de tipul codului angajatului, 
--care regăseşte numele şi salariul angajaţilor având codul transmis ca parametru sau 
--ale numele si salariile tuturor angajatilor daca valoarea parametrului este null. 
--Să se declare o variabilă v_nume de tipul unei linii a cursorului. 
--Să se declare două tablouri de nume (v_tab_nume), respectiv salarii (v_tab_sal). 
--Să se parcurgă liniile cursorului în două moduri: regăsindu-le în v_nume sau în cele două variabile de tip tablou.

DECLARE
CURSOR c_nume (p_id employees.employee_id%TYPE) IS
SELECT last_name, salary
FROM employees
WHERE p_id IS NULL // conditia este adevarata pentru toate liniile tabelului atunci cand
// parametrul este null
OR employee_id = p_id;
V_nume c_nume%ROWTYPE;
-- sau
/* TYPE t_nume IS RECORD
(last_name employees.employee_id%TYPE,
salary employees.salary%TYPE
v_nume t_nume;
*/
4
TYPE t_tab_nume IS TABLE OF employees.last_name%TYPE;
TYPE t_tab_sal IS TABLE OF employees.salary%TYPE;
V_tab_nume t_tab_nume;
V_tab_Sal t_tab_sal;
BEGIN
IF c_nume%ISOPEN THEN
CLOSE c_nume;
END IF;
OPEN c_nume (104);
FETCH c_nume INTO v_nume;
WHILE c_nume%FOUND LOOP
DBMS_OUTPUT.PUT_LINE (‘ Nume:’ || v_nume.last_name ||
‘ salariu : ‘ || v_nume.salary);
FETCH c_nume INTO v_nume;
END LOOP;
CLOSE c_nume;
-- eroare INVALID CURSOR
-- FETCH c_nume INTO v_nume;
DBMS_OUTPUT.PUT_LINE (‘ SI o varianta mai eficienta’);
OPEN c_nume (null);
FETCH c_nume BULK COLLECT INTO v_tab_nume, v_tab_sal;
CLOSE c_nume;
FOR i IN v_tab_nume.FIRST..v_tab_nume.LAST LOOP
DBMS_OUTPUT.PUT_LINE (i || ‘ Nume:’ || v_tab_nume(i) ||
‘ salariu : ‘ || v_tab_sal(i));
END LOOP;
END;

--Solutia mea(independenta)
SET SERVEROUTPUT ON
DECLARE
    CURSOR c_cursor(cod EMPLOYEES.EMPLOYEE_ID%TYPE) IS
        SELECT FIRST_NAME, SALARY
        FROM EMPLOYEES
        WHERE cod is NULL 
        OR EMPLOYEE_ID = cod;
    v_nume c_cursor%ROWTYPE;
    TYPE t_tab_nume IS TABLE OF EMPLOYEES.FIRST_NAME%TYPE;
    TYPE t_tab_sal IS TABLE OF EMPLOYEES.SALARY%TYPE;
    v_nume1 t_tab_nume;
    v_sal1 t_tab_sal;
    v_i NUMBER(8);
BEGIN
    DBMS_OUTPUT.PUT_LINE('Metoda1:');
    FOR v_nume in c_cursor(null) LOOP
        DBMS_OUTPUT.PUT_LINE('Nume: ' || v_nume.FIRST_NAME  || ' Salariu: ' || v_nume.SALARY);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Metoda2:');
    OPEN c_cursor(null);
        FETCH c_cursor BULK COLLECT INTO v_nume1, v_sal1;
    CLOSE c_cursor;
    FOR v_i IN v_nume1.FIRST..v_nume1.LAST LOOP
        DBMS_OUTPUT.PUT_LINE('Nume: ' || v_nume1(v_i)  || ' Salariu: ' || v_sal1(v_i));
    END LOOP;
END;

--4. Utilizând un cursor parametrizat să se obţină codurile angajaţilor din fiecare departament şi pentru fiecare job. 
--Rezultatele să fie inserate în tabelul mesaje, sub forma câte unui şir de caractere obţinut prin concatenarea valorilor celor 3 coloane.

DECLARE
v_cod_dep departments.department_id%TYPE;
v_cod_job departments.job_id%TYPE;
v_mesaj VARCHAR2(75);
CURSOR dep_job IS
SELECT department_id, job_id
FROM emp_pnu;
CURSOR emp_cursor (v_id_dep NUMBER,v_id_job VARCHAR2) IS
SELECT employee_id || department_id || job_id
FROM emp_pnu
WHERE department_id = v_id_dep
AND job_id = v_id_job;
BEGIN
OPEN dep_job;
LOOP
FETCH dep_job INTO v_cod_dep,v_cod_job;
EXIT WHEN dep_job%NOTFOUND;
IF emp_cursor%ISOPEN THEN
CLOSE emp_cursor;
END IF;
OPEN emp_cursor (v_cod_dep, v_cod_job);
LOOP
FETCH emp_cursor INTO v_mesaj;
EXIT WHEN emp_cursor%NOTFOUND;
INSERT INTO mesaje (rezultat)
VALUES (v_mesaj);
END LOOP;
CLOSE emp_cursor;
END LOOP;
CLOSE dep_job;
COMMIT;
END;
--Solutia mea (independenta)
SET SERVEROUTPUT ON
DECLARE
    CURSOR c_cursor(cod EMPLOYEES.DEPARTMENT_ID%TYPE,job EMPLOYEES.JOB_ID%TYPE) IS
        SELECT TO_CHAR(EMPLOYEE_ID || DEPARTMENT_ID || JOB_ID) as Result
        FROM EMPLOYEES
        WHERE DEPARTMENT_ID = cod
        AND JOB_ID = job;
    v_cursor c_cursor%ROWTYPE;
BEGIN
    FOR pereche IN (SELECT DISTINCT department_id, job_id FROM employees) LOOP
        DBMS_OUTPUT.PUT_LINE(pereche.department_id ||' '||pereche.job_id);
        OPEN c_cursor(pereche.department_id, pereche.job_id);
        LOOP    
            FETCH c_cursor INTO v_cursor;
            INSERT INTO mesaje VALUES (v_cursor.Result);
            EXIT WHEN c_cursor%NOTFOUND;
        END LOOP;
        CLOSE c_cursor;
    END LOOP;
END;

--5. Să se declare un cursor dinamic care întoarce linii de tipul celor din tabelul emp_pnu. 
--Să se citească o opţiune de la utilizator, care va putea lua valorile 1, 2 sau 3. 
--Pentru opţiunea 1 deschideţi cursorul astfel încât să regăsească toate informaţiile din tabelul EMP_pnu, 
--pentru opţiunea 2, cursorul va regăsi doar angajaţii având salariul cuprins între 10000 şi 20000, 
--iar pentru opţiunea 3 se vor regăsi salariaţii angajaţi în anul 1990.
ACCEPT p_optiune PROMPT ‘Introduceti optiunea (1,2 sau 3) ‘
DECLARE
TYPE emp_tip IS REF CURSOR RETURN emp_pnu%ROWTYPE;
V_emp emp_tip;
V_optiune NUMBER := &p_optiune;
BEGIN
IF v_optiune = 1 THEN
OPEN v_emp FOR SELECT * FROM emp_pnu;
--!!! Introduceţi cod pentru afişare
ELSIF v_optiune = 2 THEN
OPEN v_emp FOR SELECT * FROM emp_pnu
WHERE salary BETWEEN 10000 AND 20000;
--!!! Introduceţi cod pentru afişare
ELSIF v_optiune = 3 THEN
OPEN emp_pnu FOR SELECT * FROM emp_pnu
WHERE TO_CHAR(hire_date, ‘YYYY’) = 1990;
--!!! Introduceţi cod pentru afişare
ELSE
DBMS_OUTPUT.PUT_LINE(‘Optiune incorecta’);
END IF;
END;

--Solutia mea (independenta)
SET SERVEROUTPUT ON
DECLARE
    TYPE emp_tip IS REF CURSOR RETURN EMPLOYEES%ROWTYPE;
    v_emp emp_tip;
    v_optiune NUMBER(8) := &p_optiune;
BEGIN
    CASE
        WHEN v_optiune = 1 THEN 
            OPEN v_emp FOR
                SELECT * FROM employees;
        WHEN v_optiune = 2 THEN 
            OPEN v_emp FOR
                SELECT * FROM employees
                WHERE SALARY BETWEEN 10000 AND 20000;
        WHEN v_optiune = 3 THEN 
            OPEN v_emp FOR
                SELECT * FROM employees
                WHERE TO_CHAR(HIRE_DATE, 'YYYY')='1990';
    END CASE;
END;

--6. Să se citească o valoare n de la tastatura. 
--Prin intermediul unui cursor deschis cu ajutorul unui şir dinamic să se regăsească angajaţii având salariul mai mare decât n. 
--Pentru fiecare linie regăsită de cursor, dacă angajatul are comision, să se afişeze numele său şi salariul.
DECLARE
TYPE empref IS REF CURSOR;
V_emp empref;
v_nr INTEGER := &p_nr;
BEGIN
OPEN v_emp FOR
'SELECT employee_id, salary FROM emp_pnu WHERE salary> :bind_var'
USING v_nr;
-- introduceti liniile corespunzatoare rezolvării problemei
END;

--Solutia mea
set SERVEROUTPUT on;
DECLARE
TYPE empref IS REF CURSOR;
V_emp empref;
v_nr INTEGER := &p_nr;
type linie is record(cod employees.employee_id%type,
                    nume employees.last_name%type,
                    sal employees.salary%type,
                    com employees.commission_pct%type);
type tab_linii is table of linie index by pls_integer;
v tab_linii;
BEGIN
    OPEN v_emp FOR
        'SELECT employee_id, last_name, salary, commission_pct FROM emp_pnu WHERE salary> :bind_var'
        USING v_nr;
    FETCH v_emp bulk collect into v;
    ClOse v_emp;
    for i in 1..v.count LOOP
        if v(i).com is not null THEN
            dbms_output.put_line(v(i).nume || '' || v(i).sal);
        end if;
    end loop;
    DBMS_OUTPUT.PUT_LINE('');
END;
--se inlocuieste ":bind_var" cu v_nr (variabila de legatura)