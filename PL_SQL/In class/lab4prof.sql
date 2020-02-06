set serveroutput on
DECLARE   
V_emp sys_refcursor;  
v_nr  INTEGER := &p_nr; 
type linie is record(cod employees.employee_id%type,
                                  nume employees.last_name%type,
                                  sal employees.salary%type,
                                  com employees.commission_pct%type);
type tab_linii is table of linie index by pls_integer;
v tab_linii;
BEGIN   
OPEN v_emp FOR      
          'SELECT employee_id, last_name, salary,commission_pct FROM emp_pnu 
          WHERE salary> :bind_var'      USING v_nr;  
fetch v_emp bulk collect into v;  --- !!!!!
close  v_emp;
for i in 1..v.count loop
  if v(i).com is not null then 
    dbms_output.put_line(v(i).nume||' '||v(i).sal);
  end if;  
end loop;
END; 




select d.department_id, count(employee_id)
from departments d left  join employees e on (e.department_id=d.department_id)
group by d.department_id;




create trigger pb9_v1 after insert or update
of department_id  on employees 
declare
nrmax number;
begin
select max(count(employee_id)) into nrmax
from departments d left  join employees e on (e.department_id=d.department_id)
group by d.department_id;
if nrmax>50 then
 raise_application_error(-20567,'prea multi angajati');
end if;
end;


update employees
set department_id=50
where department_id=30;

insert into employees
select employee_id+500,first_name,last_name,email||'@',phone_number,hire_date,
job_id,salary,commission_pct,manager_id,50,stea
from employees
where department_id=30 and employee_id<>117;


create or replace trigger pb9_gresit 
before insert or update of department_id on employees
for each row
declare
   nr number;
begin
nr:=n_ang(:new.department_id);
if nr>50 then
 raise_application_error(-20456,'prea multi ang');
end if; 
end;


update employees
set department_id=20
where department_id=30;



select d.department_id, count(employee_id)
from departments d left  join employees e on (e.department_id=d.department_id)
group by d.department_id;

=============================================
create or replace 
package aux is
type depinfo is record(cod number,
                                       nr number,
                                       ck number);
type tab_deps is table of depinfo index by pls_integer;
v tab_deps;
end;


create or replace 
trigger pb_9_v3_b before insert or update
of department_id on employees
begin
for l in (select d.department_id, count(employee_id) nr ,0 flag
from departments d left  join employees e on (e.department_id=d.department_id)
group by d.department_id) loop
 aux.v(nvl(l.department_id,0)).cod:=l.department_id;
 aux.v(nvl(l.department_id,0)).nr:=l.nr;
 aux.v(nvl(l.department_id,0)).ck:=l.flag;
end loop;
end;

create or replace 
trigger pb_9_v3_row before insert or update
of department_id on employees
for each row
begin
 if inserting then
    aux.v(nvl(:new.department_id,0)).nr:=aux.v(:new.department_id).nr+1;
    aux.v(nvl(:new.department_id,0)).ck:=1;
    if aux.v(nvl(:new.department_id,0)).nr>50 then
     raise_application_error(-20467,'prea multi ang insert in dep '||:new.department_id );
    end if; 
 else
    aux.v(nvl(:new.department_id,0)).nr:=aux.v(:new.department_id).nr+1;
    aux.v(nvl(:new.department_id,0)).ck:=1;
    aux.v(nvl(:old.department_id,0)).nr:=aux.v(:old.department_id).nr-1;
end if;
end;


create or replace 
trigger pb_9_v3_a after update
of department_id on employees
declare 
poz number;
begin
poz:=aux.v.first;
for i in 1..aux.v.count loop
   if aux.v(poz).ck=1 and aux.v(poz).nr>50 then
    raise_application_error(-20345,'prea multi ang update in dep '||poz);
   end if;
 poz:=aux.v.next(poz);
end loop;
aux.v.delete;
end;