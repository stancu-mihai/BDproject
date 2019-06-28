select employee_id cod_angajat,
       last_name "Nume angajat",
       job_id cod_jb,
       hire_date data_angajarii
from employees;

select last_name || ', ' || job_id "Angajat si titlu"
from employees;

select sysdate from employees;

select sysdate from dual;
select * from dual;

select to_char(sysdate, 'dd-mon-yy') from dual;
select to_char(sysdate, 'dd-mm-yyyy hh24:mi:ss AM') from dual;

SELECT job_id FROM employees;
SELECT DISTINCT job_id FROM employees;

select distinct department_id, to_char(hire_date, 'mm-yyyy')
from employees
order by department_id;

select last_name, salary salariu, salary + salary * nvl(commission_pct, 0) venit
from employees
where salary + salary * nvl(commission_pct, 0) > 6000
order by venit DESC;

select first_name nume, last_name prenume, hire_date
from employees
where hire_date >= to_date('01-01-1990', 'dd-mm-yyyy')
order by hire_date asc;

SELECT last_name nume, first_name prenume, department_id
FROM employees

--WHERE department_id IN (10, 30, 80)
--WHERE department_id = 10 or department_id = 30 or department_id = 80

--WHERE department_id NOT IN (10, 30, 80)
WHERE department_id <> 10 and department_id <> 30 and department_id <> 80

--ORDER BY first_name, last_name;
--ORDER BY 2, 1;
ORDER BY prenume, nume;

---***sa se afiseze numele dept. in care lucreaza/nu lucreaza angajati
select department_name from departments
where department_id in (select department_id from employees where department_id is not null);

select distinct department_id from employees where department_id is not null order by 1;

---***angajatii din Oxford
select employee_id, last_name, first_name from employees where department_id in (select department_id from departments where location_id in (select location_id from locations where city='Oxford'));

***JOIN
***nume ang, nume departament

select *
from employees, departments
where EMPLOYEES.DEPARTMENT_ID = DEPARTMENTS.DEPARTMENT_ID;

select e.last_name, d.department_name
from employees e, departments d
where e.DEPARTMENT_ID = d.DEPARTMENT_ID;

select *
from employees cross join departments;

***sa se afiseze numele angajatilor si titlurile joburilor

select e.last_name, j.job_title
from employees e, jobs j
where e.job_id = j.job_id;

** nume, prenume, oras
select e.last_name, d.department_name, l.city
from employees e, departments d, locations l
where e.DEPARTMENT_ID = d.DEPARTMENT_ID
and d.location_id = l.location_id;

*** nume, prenume, oras, job_title
select e.last_name, e.first_name, l.city, j.job_title
from employees e, departments d, locations l, jobs j
where e.DEPARTMENT_ID = d.DEPARTMENT_ID
and d.location_id = l.location_id and e.job_id = j.job_id;

*** join sintaxa standard
*** nume si departamaent
select e.last_name, d.department_name
from employees e join departments d
on (e.DEPARTMENT_ID = d.DEPARTMENT_ID);

*** nume, prenume, oras, job_title
select e.last_name, e.first_name, l.city, j.job_title
from employees e
    join departments d
        on (e.DEPARTMENT_ID = d.DEPARTMENT_ID)
    join locations l
        on (d.location_id = l.location_id)
    join jobs j
        on(e.job_id = j.job_id);

--L2 exe 22 (self join)
*** S? se afi?eze codul angajatului ?i numele acestuia, īmpreun? cu numele ?i codul ?efului
*** s?u direct. Se vor eticheta coloanele Ang#, Angajat, Mgr#, Manager.

select ang.employee_id "Ang#", ang.last_name "Angajat",
       man.employee_id "Mgr#", man.last_name "Manager"
from employees ang join employees man on (ang.manager_id = man.employee_id);

---OUTER JOIN
select e.last_name, nvl(d.department_name, 'department necunoscut')
from employees e left join departments d
on (e.department_id = d.department_id);

select e.last_name, d.department_name
from employees e right join departments d
on (e.department_id = d.department_id);

select e.last_name, d.department_name
from employees e full outer join departments d
on (e.department_id = d.department_id);

 ---Ang#, Angajat, Mgr#, Manager inclusiv angajatul care nu are manager
 select ang.employee_id "Ang#", ang.last_name "Angajat",
       man.employee_id "Mgr#", man.last_name "Manager"
from employees ang left join employees man on (ang.manager_id = man.employee_id);

 ---nume oren oras job si cei pentru care nu este cunoscut departamentul
select e.last_name, e.first_name, l.city, j.job_title
from employees e
    left join departments d
        on (e.DEPARTMENT_ID = d.DEPARTMENT_ID)
    left join locations l
        on (d.location_id = l.location_id)
    join jobs j
        on(e.job_id = j.job_id);