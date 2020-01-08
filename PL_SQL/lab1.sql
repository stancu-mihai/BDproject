--Pentru un cod de departament citit de la tastatura, sa se afiseze numele, salariul si data angajarii
--dorim sa ajungem pana la procedura

-- start from
select last_name, salary, hire_date
from employees
where department_id = 30;

--read from keyboard
select last_name, salary, hire_date
from employees
where department_id = &cod;

--pl/sql first
declare
v_nume varchar(25);

begin
select last_name into  v_nume --, salary, hire_date 
from employees
where department_id = 10;
--DBMS.PUT_LINE (Database message output), requires toolbar from VIew/DBMS output (and the connection associated with "+")
DBMS_OUTPUT.PUT_LINE(v_nume);
end;

--without DbMS output window
set serveroutput on 
declare
v_nume varchar(25);

begin
select last_name into  v_nume --, salary, hire_date 
from employees
where department_id = 10;
--DBMS.PUT_LINE (Database message output), requires toolbar from VIew/DBMS output (and the connection associated with "+")
DBMS_OUTPUT.PUT_LINE('Result'||v_nume);
end;

-- get more than one field, not recommended because it is not scallable
set serveroutput on 
declare
v_nume employees.last_name%type; --get type from table
v_sal employees.salary%type;
v_data employees.hire_date%type;

begin
select last_name, salary, hire_date into v_nume, v_sal, v_data
from employees
where department_id = 10;
--DBMS.PUT_LINE (Database message output), requires toolbar from VIew/DBMS output (and the connection associated with "+")
DBMS_OUTPUT.PUT_LINE('Result: '||v_nume||' cu salariul '||v_sal);
end;


-- get more than one line of result
set serveroutput on 
declare
v_nume employees.last_name%type;
type angajati_nume is array(150) of v_nume%type;
vector_nume angajati_nume;

begin
select last_name bulk collect into vector_nume
from employees
where department_id = 50;
DBMS_OUTPUT.PUT_LINE('Result: '||v_nume);
end;

--display array results for one field
set serveroutput on 
declare
v_nume employees.last_name%type;
type angajati_nume is array(150) of v_nume%type;
vector_nume angajati_nume;

begin
select last_name bulk collect into vector_nume
from employees
where department_id = 50;
for i in 1..vector_nume.count loop
    DBMS_OUTPUT.PUT_LINE('Result: '||vector_nume(i));
end loop;
end;


-- display array results for multiple fields
set serveroutput on 
declare
v_nume employees.last_name%type;
type angajati_nume is array(150) of v_nume%type;
type angajati_salarii is array(150) of employees.salary%type;
type angajati_date is array(150) of employees.hire_date%type;
vector_nume angajati_nume;
vector_salarii angajati_salarii;
vector_date angajati_date;
begin
select last_name, salary, hire_date bulk collect into vector_nume, vector_salarii, vector_date
from employees
where department_id = 50;
for i in 1..vector_nume.count loop
    DBMS_OUTPUT.PUT_LINE('Result: '||vector_nume(i)||' '||vector_salarii(i)||' '||vector_date(i));
end loop;
end;


-- read from keyboard
set serveroutput on 
declare
v_cod employees.department_id%type := &dep; 
v_nume employees.last_name%type;
type angajati_nume is array(150) of v_nume%type;
type angajati_salarii is array(150) of employees.salary%type;
type angajati_date is array(150) of employees.hire_date%type;
vector_nume angajati_nume;
vector_salarii angajati_salarii;
vector_date angajati_date;
begin
select last_name, salary, hire_date bulk collect into vector_nume, vector_salarii, vector_date
from employees
where department_id = v_cod;
for i in 1..vector_nume.count loop
    DBMS_OUTPUT.PUT_LINE('Result: '||vector_nume(i)||' '||vector_salarii(i)||' '||vector_date(i));
end loop;
end;

--declare procedure
create procedure lista_ang(v_cod employees.department_id%type) is
v_nume employees.last_name%type;
type angajati_nume is array(150) of v_nume%type;
type angajati_salarii is array(150) of employees.salary%type;
type angajati_date is array(150) of employees.hire_date%type;
vector_nume angajati_nume;
vector_salarii angajati_salarii;
vector_date angajati_date;
begin
select last_name, salary, hire_date bulk collect into vector_nume, vector_salarii, vector_date
from employees
where department_id = v_cod;
for i in 1..vector_nume.count loop
    DBMS_OUTPUT.PUT_LINE('Result: '||vector_nume(i)||' '||vector_salarii(i)||' '||vector_date(i));
end loop;
end;

--run procedure
set serveroutput on
execute lista_ang(30);

--using cursor instead of variables
set serveroutput on 
declare
v_cod employees.department_id%type := 30; 
cursor listaang(dep employees.department_id%type) is 
select last_name, salary, hire_date 
from employees
where department_id = v_cod;

v_linie listaang%rowtype;

begin
open listaang(v_cod); -- deschidem cursorul cu parametrul 
loop
    fetch listaang into v_linie;
    exit when listaang%notfound;
    DBMS_OUTPUT.PUT_LINE('Result: '||v_linie.last_name||' '||v_linie.salary||' '||v_linie.hire_date);
end loop;
close listaang;
end;


--using inline cursor
set serveroutput on 
declare
v_cod employees.department_id%type := 30; 

begin

for i in 
    (select first_name, salary, hire_date
    from employees
    where department_id=v_cod)loop
    DBMS_OUTPUT.PUT_LINE('Result: '||i.first_name||' '||i.salary||' '||i.hire_date);
end loop;

end;


-- create a function
-- declare a function (functions with errors appear with RED)
create or replace function infodep(v_cod employees.department_id%type) return number is
x number;

begin

select count(*) into x
from employees
where department_id=v_cod;

for i in 
    (select first_name, salary, hire_date
    from employees
    where department_id=v_cod)loop
    DBMS_OUTPUT.PUT_LINE('Result: '||i.first_name||' '||i.salary||' '||i.hire_date);
end loop;

return x;

end;

--call the function
set serveroutput on
select infodep(30)
from dual;






