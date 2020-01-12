-- http://join.me/266-913-525
-- examen ora 10 sala 308???
-- 30calculatoare

--Recap
set serveroutput on --creates an extra line
declare
d number;
b d%type;
nume_job jobs.job_title%type;
begin
select job_title into nume_job
from jobs
where job_id='SA_MAN';
end;

-- DBMS_OUTPUT.PUT_LINE //write
-- DBMS_OUTPUT.PUT //write line


set serveroutput on
declare
d number;
b d%type;
--nume_job jobs.job_title%type;
line jobs%rowtype; --a line from jobs
begin
select * into line
from jobs
where job_id='SA_MAN';
dbms_output.put_line(line.job_title||' '||line.min_salary);
end;

--if
declare 
v_cod_dep departments.department_id%type :=&p_cod_dep;
v_numar number(3):=0;
v_comentariu varchar2(10);
begin
select count(*) into v_numar
from employees
where department_id = v_cod_dep;
v_comentariu:='mic';
elseif v_numar between 10 and 30 then
v_comentariu:='mediu';
else v_comentariu:='mare';
end if;
dbms_output.put_line('Departamentul avand codul' ||v_cod_dep || 'este de tip' || v_comentariu);
end;

--case
declare 
v_cod_dep departments.department_id%type :=&p_cod_dep;
v_numar number(3):=0;
v_comentariu varchar2(10);
begin
select count(*) into v_numar
from employees
where department_id = v_cod_dep;
case
    when v_numar <10 then v_comentariu:='mic';
    when v_numar between 10 and 30 then v_comentariu:='mediu';
    else v_comentariu:='mare';
end case;
dbms_output.put_line('Departamentul avand codul' ||v_cod_dep || 'este de tip' || v_comentariu);
end;

--for
declare 
v_cod_ang emp_pnu.employee_id%type :=&p_cod_ang;
v_salariu emp_pnu.salary%type;
v_stea emp_pnu.stea%type:=null;
begin
--nvl transforma null in 0
select nvl(round(salary/100),0) into v_salariu
from emp_pnu
where employee_id = v_cod_ang;
for i in 1..v_salariu loop
v_stea:=v_stea || '*';
end loop;
update emp_pnu
set stea= v_stea
where employee_id=v_cod_ang;
commit;
end;

--while
declare 
v_cod_ang emp_pnu.employee_id%type :=&p_cod_ang;
v_salariu emp_pnu.salary%type;
v_stea emp_pnu.stea%type:=null;
begin
--nvl transforma null in 0
select nvl(round(salary/100),0) into v_salariu
from emp_pnu
where employee_id = v_cod_ang;

--for i in 1..v_salariu loop
--v_stea:=v_stea || '*';
--end loop;
while v_salariu > 0 loop
    --v_stea:=v_stea || '*';
    v_salariu :=v_salariu-1;
end loop;

update emp_pnu
set stea= v_stea
where employee_id=v_cod_ang;
commit;
end;

--loop
declare 
v_cod_ang emp_pnu.employee_id%type :=&p_cod_ang;
v_salariu emp_pnu.salary%type;
v_stea emp_pnu.stea%type:=null;
begin
--nvl transforma null in 0
select nvl(round(salary/100),0) into v_salariu
from emp_pnu
where employee_id = v_cod_ang;

--for i in 1..v_salariu loop
--v_stea:=v_stea || '*';
--end loop;
--while v_salariu > 0 loop
--    v_stea:=v_stea || '*';
--    v_salariu :=v_salariu-1;
--end loop;
loop
    exit when v_salariu <= 0;
    v_stea:=v_stea || '*';
    v_salariu:=v_salariu-1;
end loop;

update emp_pnu
set stea= v_stea
where employee_id=v_cod_ang;
commit;
end;

--laborator1_plsql_an3.pdf (SGBD_IDD_2018)
--laborator2_plsql_an3.pdf (SGBD_IDD_2018)

--IN PL/SQL nu putem rula lDD (Create alter drop rename)
--putem executa cu "execute immediate", dar ea opreste temporat pl/sql 
--si ruleaza din sql

-- pl/sql nu este zero index; primul index e 1

--INTO nu salveaza array-uri, trebuie folosit BULK COLLECT INTO


alter table emp_pnu modify(stea varchar2(300);

--vector pentru toti angajatii
set serveroutput on
declare 
type vector is array (200) of emp_pnu.salary%type;
type angajati is array (200) of emp_pnu.employee_id%type;
v_salariu vector;
v_angajati vector;
v_stea emp_pnu.stea%type:=null;
begin
select nvl(round(salary/100),0), employee_id bulk collect into v_salariu, v_angajati
from emp_pnu;
dbms_output.put_line(v_salariu.count);
for i in 1..v_angajati.count loop
    v_stea:='*';
    for j in 1..v_salariu(i) loop
        dbms_output.put_line(v_angajati(i));
        v_stea:=v_stea || '*';
    end loop;
    update emp_pnu
    set stea = v_stea
    where employee_id=v_angajati(i);
end loop;
commit;
end;

--creare nou tip
create or replace type proiect_pnu_MS as varray(50) of varchar2(15);



create table MS (cod_ang NUMBER(4),
proiecte_alocate proiect_pnu_MS);



declare 
v_proiect v_proiect_pnu_ms := proiect_pnu_ms(); --initializare prin constructor
begin
v_proiect_pnu_ms.extend(2);
v_proiect_pnu_ms(1):='proiect alfa';
v_proiect_pnu_ms(2):='proiect beta';
v_proiect_pnu_ms(2):='proiect gama';
insert into ms values (1, v_proiect);
end;
commit;

--EXAMEN: Putem intreba functii predefinite, ne raspunde dl profesor



declare 
v_proiect v_proiect_pnu_ms := proiect_pnu_ms(); --initializare prin constructor
begin
v_proiect_pnu_ms.extend(2);
v_proiect_pnu_ms(1):='proiect alfa';
v_proiect_pnu_ms(2):='proiect beta';
v_proiect_pnu_ms(2):='proiect gama';
insert into ms values (1, v_proiect);
end;
commit;

declare 
type t_id is varray(100) of emp_pnu.employee_id%type
v_id t_id :=t_id();
begin
    for contor in (select * from emp_pnu) loop
        if contor.Department_id = 50 and contor.salary<5000 then
            v_id.extend;
            v_id(v_id.count):=contor.employee_id;
        end if;
    end loop;
    for contor in 1..v_id.count loop
        update emp_pnu
        set salary :=salary * 1.1
        where employee_id=v_id(contor);
    end loop;
end;

--for all (nu are end; contorul este musai integer)

--LA EXAMEN nu conteaza performanta


-- daca folosim vector in loc de tablou indexat/imbricat, suntem penalizati
-- dezavantajul vectorului este ca are dimensiune fixa


--tablouri (table) indexate
-- nu au limita
-- elementele nu sunt intr-o ordine particulara
-- pot fi inserate componente
-- tablourile sunt 1D, tabelele sunt 2D
-- nu necesita initializare
-- pot fi folosite DOAR in interiorul blocurilor PL/SQL!!!
declare 
type t_id is table of emp_pnu.employee_id%type index by pls_integer;
v_id t_id;
begin
    for contor in (select * from emp_pnu) loop
            V_id(v_id.count+1):=contor.employee_id;
    end loop;
    forall contor in 1..v_id.count
        update emp_pnu
        set salary =salary * 1.1
        where employee_id=v_id(contor);
end;
/
commit;


-- daca vrem ca una din componente sa fie variabila, folosim tablou imbricat
--tablouri (table) indexate
-- necesita initializare, necesita extend
declare 
type t_id is table of emp_pnu.employee_id%type;
v_id t_id:=t_id();
begin
    for contor in (select * from emp_pnu) loop
        V_id.extend();
        V_id(v_id.count):=contor.employee_id;
    end loop;
    forall contor in 1..v_id.count
        update emp_pnu
        set salary =salary * 1.1
        where employee_id=v_id(contor);
end;
/
commit;


--Vreau un tabel depinfo13 in care sa am lista departamentelor cu angajati
--depinfo13 ( dep number(3), lista ???, 
--tablouri (table) indexate

--pe randul urmator nu avem access la %type deoarece nu suntem in PL/SQL!!!
create type lista_ang8 is table of number(3);

create table depinfo8(dep number(3), lista lista_ang8)
nested table lista store as depinfo8_lista;
-- in lista de tabele vor aparea doua tabele, unul din ele il contine pe celalalt
-- apar depinfo8 si depinfo8_lista


--bulk collect se ocupa de initializare. daca contine ceva, sterge

declare
    type listadep is table of departments.department_id%type index by pls_integer;
    deps listadep;
    angajati lista_ang8;
begin
    select department_id bulk collect into deps
    from departments;
    
    for i in 1..deps.count loop
        select employee_id bulk collect into angajati
        from employees
        where department_id=deps(i);
        insert into depinfo8
        values(deps(i), angajati);
    end loop;
    commit;
end;

--tipul record in pl/sql este object in afara PL/SQL
create type anginfo8 is object(
    id number(3),
    nume varchar2(30),
    data date);
    
create type listaang8 is table of anginfo8;

create type ldep8 is object(
    nr number(3),
    list_ang  listaang8);

create type x8 is table of ldep8;

drop table depinfo8;

create table depinfo8(coddep number(3), angajati listaang8)
nested table angajati store as depinfo8_angajati;

declare 
x x13:=x13();
begin
    for d in (select department_id from departments) loop
        x.extend;
        x(x.count).nr:=d.department_id;
        --pentru linia urmatoare trebuie folosit constructorul, doearece noi avem 
        --componentele 'varsate' dar avem nevoie de ele 'impachetate'
        select listaang8(employee_id, last_name, hire_date) bulk collect into x(x.count).lista_ang
        from employees
        where department_id=d.department_id
        order by employee_id;
    end loop;
end;


declare 
x x8:=x8();
begin
    for d in (select department_id from departments) loop
        x.extend;
        x(x.count):=ldep8(d.department_id, listaang8());
        --!!!! Gresit x(x.count).list_ang:=listaang8();
        --pentru linia urmatoare trebuie folosit constructorul, doearece noi avem 
        --componentele 'varsate' dar avem nevoie de ele 'impachetate'
        for a in (select employee_id, last_name, hire_date
            from employees
            where department_id=d.department_id) loop
            
            x(x.count).list_ang.extend;
            x(x.count).list_ang(x(x.count).list_ang.count):=
                anginfo8(a.employee_id, a.last_name, a.hire_date);
        end loop;
--        select anginfo8(employee_id, last_name, hire_date) bulk collect into x(x.count).lista_ang
--        from employees
--        where department_id=d.department_id
--        order by employee_id;
    end loop;
end;


declare 
x x8:=x8();
begin
    for d in (select department_id from departments) loop
        x.extend;
        x(x.count):=ldep8(d.department_id, listaang8());
        --!!!! Gresit x(x.count).list_ang:=listaang8();
        --pentru linia urmatoare trebuie folosit constructorul, doearece noi avem 
        --componentele 'varsate' dar avem nevoie de ele 'impachetate'
        for a in (select employee_id, last_name, hire_date
            from employees
            where department_id=d.department_id) loop
            
            x(x.count).list_ang.extend;
            x(x.count).list_ang(x(x.count).list_ang.count):=
                anginfo8(a.employee_id, a.last_name, a.hire_date);
        end loop;
    end loop;
    
    forall i in 1..x.count
        insert into depinfo8
        values(x(i).nr , x(i).list_ang);
end;

--la examen un x(i) si un obiect ( nu asa de greu ca acest exemplu)