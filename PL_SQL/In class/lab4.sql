--primim exception handling

--tablou indexat
    --nu suporta tip separat stocat in types
    --nu poate fi folosit in tabel
    --nu trebuie initializat cu constructor
    --prima componenta poate fi 1937
--tablou imbricat
    --tip separat stocat in types
    --poate fi folosit in tabel
    --trebuie initializat
    --trebuie folosit extend

--ambele sunt tipuri de date specifice sql
--ambele au COUNT, FIRst, last, next

--examen: 2 randuri, scheme diferite

--2 subprograme si un trigger
--probabil fara teorie

--SQL developer online Help release, 5

--nu crede ca ne da cursor dinamic

declare 
    type tip is ref cursor return emp_pnu%rowtype;
    v_cursor tip;
    --SAU v_cursor sys_refcursor;
begin
    open v_cursor for select * from employees;
    close v_cursor;
end;

--declare in interiorul blocului - NU!
--macar un into in selectul principal

--trigger
--identificare tabel
--nivel tabel sau linie
--cand se declanseaza
--0..5pct

--versiune sql developer 17.3.1.279

--problema 9 triggeri
--tabelul: employees
--declansare la insert, update

--la insert e simplu, ne limitam la 50.
--la update e mai complicat:
--ce facem la 
UPDATE EMPLOYEES Set department_id = 10 * length(last_name);
--?

--avem triggeri inainte si dupa tabel, inainte si dupa linie
--daca unul arunca exceptie, se anuleaza toti

select d.department_id, count(employee_id)
from departments d 
left join employees e on (e.department_id=d.department_id)
group by d.department_id;

create trigger pb9_v1 after insert or update
of department_id on employees 
nrmax number;
begin
    select max(count(employee_id)) into nrmax
    from departments d 
    left join employees e on (e.department_id=d.department_id)
    group by d.department_id;
end;

--pentru testare update
update employees
set department_id = 50
where department_id =30;

--pentru testare insert cu mai multe linii deodata
insert into employees
select employee_id+500, first_name, last_name, email || '@', phone_number, hire_date, job_id, salary, commission_pct, manager_id, 50, stea
from employees
where department_id =30
and employee_id <> 117;
--s-a adaugat la employee_id si email din motive de unicitate
insert into employees
select employee_id+500, first_name, last_name, email || '@', phone_number, hire_date, job_id, salary, commission_pct, manager_id, 50, stea
from employees
where department_id =30;

--triggerul de sus e vulnerabil daca e adaugat dupa ce tabelul e populat
--vreau ca triggerul sa dea eroare doar in tabelul in care am intervenit eu

-- nu se poate ca in timpul triggerului sa mai citim inca odata tabelul, deoarece este blocat

create function nr_ang(dep number) return number is
nr number;
begin
select count(employee_id) into nr
from departments d left join employees e on (e.department_id=d.department_id)
where d.department_id=dep;
return nr;
end;

select n_ang(50) from dual;

--exemplu blocare
create or replace trigger pb9_gresita
before insert or update of department_id on employees
for each row --am acces la informatiile pe care vreau sa le modific prin :new.department_id
declare 
    nr number;
begin
    nr:=n_ang(:new.department_id);
    if nr>50 then 
        raise_application_error(-20456, 'prea multi angajati');
end;

--daca incercam sa ducem angajatii din dep 30 in 50, nu merge (mutating error)
--pentru fiecare linie modificata se declanseaza triggerul
--triggerul vrea sa consulte tabelul sa numere cati angajati sunt
--nu se poate deoarece tabelul este deja blocat
--putem, in schimb sa facem asta in alt tabel
--putem adauga o coloana in departments, o populam, facem trigger care o actualizeaza automat

--Rezolvarea corecta
--salvam pe inainte, la nivel de tabel
--pe dupa, tot la nivel de tabel, daca s-a depasit dam eroare
--ce salvam? nr departamen, nr angajati, daca s-au facut sau nu modificari
--cum salvam? sa avem o variabila, populata, de un tip tabel indexat, totul sa fie salvat
-- o salvam intr-un pachet

create package aux is --appears in "packages"
    type depinfo is record(cod number, nr number, ck number);
    type tab_deps is table of depinfo index by pls_integer;
    v tab_deps;
    end;

--pe before la nivel de tabel salvam componenta
create trigger pb_9_v2 before insert or update
of department_id on employees
begin
    for i in (select d.department_id, count(employee_id), 0 flag
        bulk collect into aux.v --accesare pachet aux, componenta v
        from departments d ) loop
        left join employees e on (e.department_id=d.department_id)
        group by d.department_id;
        aux.v(nvl(l.department_id,0)).cod:=l.department_id;
        aux.v(nvl(l.department_id,0)).nr:=l.nr;
        aux.v(nvl(l.department_id,0)).ck:=l.flag; --ck=check
    end loop;
end;

--pe before la nivel de linie
create trigger pb_9_v3 before insert or update
of department_id on employees
for each row
begin
if inserting then
    aux.v(nvl(:new.department_id,0)).nr:=aux.v(:new.department_id).nr+1;
    aux.v(nvl(:new.department_id,0)).ck:=1;
    if aux.v(nvl(:new.department_id,0)).nr>50 then
        raise_application_error(-20467,'prea multi angajati insert in dep ' || :new.department_id);
    end if;
else 
    aux.v(nvl(:new.department_id,0)).nr:=aux.v(:new.department_id).nr+1;
    aux.v(nvl(:new.department_id,0)).ck:=1;
    aux.v(nvl(:old.department_id,0)).nr:=aux.v(:new.department_id).nr-1;
end if;
end;

    select d.department_id, count(employee_id), 0
    bulk collect into aux.v --accesare pachet aux, componenta v
    from departments d 
    left join employees e on (e.department_id=d.department_id)
    group by d.department_id;

--pe after la nivel de tabel facem curat
create trigger pb_9_v3_a after update
of department_id on employees
declare 
poz number;
begin
    poz:=aux.v.first;
    for i in 1..aux.v.count loop
        if aux.v(poz).ck=1 and aux.v(poz).nr>50 then
            raise_application_error(20456,'prea multi angajati update in dep '||poz);
        end if;
        poz:=aux.v.next(poz);
    end loop;
    aux.v.delete;
end;

update employees
set department_id =10* length(last_name)
where department_id is not null;

--nu se cer pachete la examen