select e.* , jh.*
from employees e left join job_history jh
     on (e.employee_id = jh.employee_id)
order by e.employee_id;     

select e.* , d.*
from employees e right join departments d
     on (e.department_id = d.department_id)
order by e.department_id;  

**denumire departament, manager_dep, 
**nume_angajat si manager_angajat
**se vor afisa si departamentele 
**in care nu lucreaza niciun angajat

select d.department_name nume_dep, 
       e.last_name nume_ang, man_ang.last_name nume_man,
       man_dep.last_name manger_dep
from employees e
     right join departments d
          on (e.department_id = d.department_id)
     left join employees man_ang 
          on (man_ang.employee_id = e.manager_id)
     left join employees man_dep  
          on (man_dep.employee_id =d.manager_id)
order by e.department_id;  

GRUPARI
**sa se afiseze pentru 
**fiecare departament media salariilor angajatilor.

select d.department_name, e.last_name, e.salary
from employees e join departments d 
     on (e.department_id = d.department_id)
order by d.department_id;

select d.department_id, d.department_name, 
       round(avg(e.salary), 2) medie
from employees e join departments d 
     on (e.department_id = d.department_id)
group by d.department_id, d.department_name;

***sa se afiseze pentru fiecare angajat 
***cate joburi anterioare a avut
select e.employee_id, e.last_name, e.first_name, 
       jh.start_date, jh.department_id
from employees e left join job_history jh
    on (e.employee_id = jh.employee_id)
    order by e.employee_id;
    
select e.employee_id, e.last_name, e.first_name, 
      /*count(*),*/ count( jh.start_date ),
      count( distinct jh.department_id )
from employees e left join job_history jh
    on (e.employee_id = jh.employee_id)
group by e.employee_id, e.last_name, e.first_name
order by e.employee_id;

***sa se afiseze departamentle 
***si suma salariilor pe joburi
***pentru dep si joburile cu salariul minim mai mare decat 
***10000
dep_name, job_title, suma_salarii

select d.department_name, j.job_title, 
       sum(e.salary), min(e.salary)
from employees e join departments d 
    on (e.department_id = d.department_id)
                 join jobs j
    on (e.job_id = j.job_id)             
group by d.department_name, j.job_title
having min(salary) >= 10000;

select d.department_name, j.job_title, 
       sum(e.salary), min(e.salary)
from employees e join departments d 
    on (e.department_id = d.department_id)
                 join jobs j
    on (e.job_id = j.job_id) 
where e.employee_id in (select employee_id from  job_history)    
group by d.department_name, j.job_title
having min(salary) >= 10000;

select e.last_name, e.department_id, to_char(e.hire_date, 'yyyy')
from employees e
order by 2, 3;

dep, nr_96, nr_97, nr_98, nr_total

select e.department_id, count(*) nr_total
from employees e
group by e.department_id;

select e.department_id,to_char(e.hire_date, 'yyyy'), 
    count(*) nr_total
from employees e
group by e.department_id, to_char(e.hire_date, 'yyyy');

select d.department_name, (  select count(*) 
                             from employees 
                             where department_id 
                                    = d.department_id
                             and to_char(hire_date, 'yyyy')
                                 = '1996') ang_96,
                          (  select count(*) 
                             from employees 
                             where department_id 
                                    = d.department_id
                             and to_char(hire_date, 'yyyy')
                                 = '1997') ang_97
from departments d;

select d.department_name, e.last_name, 
       to_char(e.hire_date,'yyyy'),
       decode( to_char(e.hire_date,'yyyy'), '1996' , 1  , 0 )
from employees  e join departments d 
   on (e.department_id = d.department_id)
order by d.department_name;

select d.department_name, 
       sum(
        decode( to_char(e.hire_date,'yyyy'),'1996',1,0 )) a_96,
       sum(
        decode( to_char(e.hire_date,'yyyy'),'1997',1,0 )) a_97,
       count(*) nr_total 
from employees  e join departments d 
   on (e.department_id = d.department_id)
group by d.department_name;

*** sa se afiseze pentru ficare angajat numele, prenumele 
***si diferenta dintre salariul si media salariilor in 
***departamentul in care lucreaza

select e.last_name, e.first_name, e.salary - medie_dep.medie
from employees e join 
  (select d.department_id,
       round(avg(e.salary), 2) medie
       from employees e join departments d 
     on (e.department_id = d.department_id)
    group by d.department_id, d.department_name
  ) medie_dep 
on (e.department_id = medie_dep.department_id);

*** 
create table employees_ibd as select * from employees;
create table departments_ibd as select * from departments;

***comanda update
update employees_ibd 
set salary = salary + 1000 , 
    commission_pct  =  commission_pct + 0.1
where  commission_pct < 0.89;

rollback;

***sa se modifice salariul angajatilor cu salariul minim in
***in departamentul in care lucreaza 
***astfel incat sa se adauge 10% din media dep.
update employees_ibd e
set salary = (select  e.salary + round(avg(salary)*0.1)
              from employees 
              where department_id = e.department_id)
where e.salary = (/*sal min in e.department_id*/     
                  select min(salary)
                  from employees 
                  where department_id = e.department_id) ;  


delete employees_ibd e
where e.salary = (/*sal min in e.department_id*/     
                  select min(salary)
                  from employees 
                  where department_id = e.department_id) ;  
rollback;

create table angajati_ibd (
   cod_ang number(9) ,
   nume varchar2(30),
   prenume varchar2(30),
   salariu number(10,2),
   department_id number(9),
   data_ang date   not null,
   constraint pk_ibd primary key (cod_ang),
   constraint u_ibd unique (nume),
   constraint  c_ibd check (salariu > 2000) 
   );
  
create table departamente_ibd (
   department_id number(9) primary key,
   department_name varchar2(20));   

alter table angajati_ibd
add constraint fk_d_ibd foreign key (department_id)
            references departamente_ibd(department_id);

