Student (cod_student, nume, prenume, data_nasterii, nr_matricol, grupa, an, CNP, sectie)
Profesor(cod_profesor, nume, prenume, data_nasterii, data_angajarii, titlu, salariu)
Curs (cod_curs, denumire, nr_credite, cod_profesor)
Note (cod_student, cod_curs, nota, data_examinare)

--1(1pct). Enuntati o cerere, pe schema de mai sus, care sa se poata rezolva cu ajutorului unei proceduri stocate, 
--dar nu si cu ajutorul unei functii stocate.
Sa se creeze un subprogram care, dat fiind un parametru de intrare de tip cod_profesor, sa intoarca numele si salariul profesorului.

--2(1pct). Creati un tip de date stocat care sa permita definirea unei variabile de tipul matrice cu dimensiunea 3x7. 
--Folositi un bloc anonim care sa populeze o variabila de tipul definit mai sus cu primele numere prime.

--NOT DONE!!!

CREATE TYPE v_array_ms IS VARRAY(7) OF NUMBER;
\
CREATE TYPE v_mat_ms IS VARRAY(3) OF v_array_ms;
\
SET SERVEROUTPUT ON
DECLARE
    TYPE v_array is VARRAY(5) OF NUMBER;
    v_v v_array:=v_array();
    TYPE v_mat is VARRAY(3) OF v_array;
    v_m v_mat:=v_mat();
BEGIN
    FOR i IN 1..3 LOOP
        v_m.EXTEND;
        FOR j IN 0..3 LOOP
            v_m(i).EXTEND;
            v_m(i)(j) := i*j;
            DBMS_OUTPUT.PUT_LINE('v_m(' || i || ')(' || j || ')=' ||v_m(i)(j));
        END LOOP;
    END LOOP;
END;

declare
    v_bool boolean;
begin
    for i in 1..100 loop
        v_bool:=true;
        for j in 1..i loop
            if mod(i,j)=0 then
                v_bool:=false;
            end if;
        end loop;
        if v_bool then
            dbms_output.put_line(i || ' este prim');
        end if;
    end loop;
end; 
--1 2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 57 59 61 67 71

--3 (1pct) Semnalati greselile din urmatorul subprogram:
create or replace function f3(v_nume employees.employee_id%types default 'Bell') return
salary number is
salariu employees.salary%types;
begin
select salary
from employees
where lower(last_name)=v_nume;
return salary;
end f3;


create or replace function f3(v_nume employees.employee_id%types default 'Bell') return --corect este "type" in loc de "types"
salary number is --corect este fara "salary" (parametrul de iesire nu are nume)
salariu employees.salary%types; --corect este "type" in loc de "types"
begin
select salary --lipseste "into salariu" pentru a fi corect
from employees
where lower(last_name)=v_nume;
return salary; --corect este "return salariu"
end f3; 

--4 (2pct)Scrieti un subprogram care pentru un cod de curs transmis ca parametru afiseaza numele si prenumele profesorului titular, 
--precum si numarul de studenti care nu au promovat cursul respectiv. 
--Cu ajutorul unui bloc anonim sa se afiseze informatiile de mai sus pentru fiecare curs.
Student (cod_student, nume, prenume, data_nasterii, nr_matricol, grupa, an, CNP, sectie)
Profesor(cod_profesor, nume, prenume, data_nasterii, data_angajarii, titlu, salariu)
Curs (cod_curs, denumire, nr_credite, cod_profesor)
Note (cod_student, cod_curs, nota, data_examinare)

CREATE OR REPLACE PROCEDURE Ex4(cod IN CURS.COD_CURS%TYPE)
IS
    v_nume PROFESOR.NUME%TYPE;
    v_prenume PROFESOR.PRENUME%TYPE;
    v_studenti INTEGER;
BEGIN
    SELECT Nume, Prenume
    INTO v_nume, v_prenume
    FROM Curs C
    LEFT JOIN Profesor P on C.cod_profesor=P.cod_profesor
    WHERE cod_curs = cod;
    DBMS_OUTPUT.PUT_LINE('Profesor titular:' || v_nume || ' ' ||v_prenume);

    SELECT COUNT(cod_student)
    INTO v_studenti
    FROM Curs C
    LEFT JOIN Note N ON C.cod_curs=N.cod_curs
    WHERE nota<5;
    DBMS_OUTPUT.PUT_LINE('Studenti picati:' || v_studenti);
END;

BEGIN
    FOR i IN (SELECT DISTINCT cod_curs
              FROM Curs) LOOP
        Execute Ex4(i.cod_curs);
    END LOOP;
END;

--5(2pc) Creati o functie care primeste ca parametru un numar natural n. 
--Pentru studentii care au acumulat mai mult de n credite se va afisa numarul matricol, 
--CNP-ul si cel mai mare numar de credite pe care l-au acumulat la un singur examen. Testati
Student (cod_student, nume, prenume, data_nasterii, nr_matricol, grupa, an, CNP, sectie)
Profesor(cod_profesor, nume, prenume, data_nasterii, data_angajarii, titlu, salariu)
Curs (cod_curs, denumire, nr_credite, cod_profesor)
Note (cod_student, cod_curs, nota, data_examinare)

CREATE OR REPLACE FUNCTION ( IN n NATURAL)
RETURN STUDENT.nr_matricol%TYPE
IS
    v_nrm STUDENT.nr_matricol%TYPE;
    v_cnp STUDENT.cnp%TYPE;
    v_max CURS.nr_credite%TYPE;
    v_sum CURS.nr_credite%TYPE;
BEGIN
    SELECT nr_matricol, cnp, MAX(nr_credite) AS nrc, SUM(nr_credite) AS suma
    INTO v_nrm, v_cnp, v_max, v_sum
    FROM Note N
    LEFT JOIN Student S on N.cod_student=S.cod_student
    LEFT JOIN Curs C on N.cod_curs=C.cod_curs
    WHERE nota >=5
    GROUP BY nr_matricol, cnp
    HAVING nr_credite > n;
    DBMS_OUTPUT.PUT_LINE('Nr matricol:' || v_nrm);
    DBMS_OUTPUT.PUT_LINE('CNP:' || v_cnp;
    DBMS_OUTPUT.PUT_LINE('Max credite:' || v_max;
    RETURN v_nrm;
END;

--6. Scrieti un trigger care sa implementeze constrangerile de cheie externa in tabelul note.Testati.
Student (cod_student, nume, prenume, data_nasterii, nr_matricol, grupa, an, CNP, sectie)
Profesor(cod_profesor, nume, prenume, data_nasterii, data_angajarii, titlu, salariu)
Curs (cod_curs, denumire, nr_credite, cod_profesor)
Note (cod_student, cod_curs, nota, data_examinare)

CREATE OR REPLACE TRIGGER FK_Note
BEFORE INSERT OR UPDATE OF Note
FOR EACH ROW
DECLARE 
    codstd Student.cod_student%TYPE;
    codcrs Curs.cod_curs%TYPE;
BEGIN
    SELECT cod_student
    INTO cod_std 
    FROM Student
    WHERE cod_student = :NEW.cod_student;
    SELECT cod_curs
    INTO cod_crs
    FROM Curs
    WHERE cod_curs = :NEW.cod_curs;

    IF cod_std IS NULL then
        RAISE_APPLICATION_ERROR(-20202, 'Codul de student nu exista');
    
    IF cod_crs IS NULL then
        RAISE_APPLICATION_ERROR(-20202, 'Codul de curs nu exista');
END;