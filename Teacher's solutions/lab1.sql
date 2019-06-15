--13
SELECT last_name, job_id, hire_date
FROM employees
WHERE hire_date BETWEEN '20-FEB-1987' and '1-MAY-1989'
ORDER BY hire_date;

SELECT last_name, job_id, 
       to_char(hire_date,'dd/mm/yyyy') "Data angajarii"
FROM employees
WHERE hire_date BETWEEN to_date('20/02/1987', 'dd/mm/yyyy') 
              and to_date('1/05/1989', 'dd/mm/yyyy')
ORDER BY hire_date;

--14
desc employees;
select last_name, department_id
from employees
where department_id in (10, 30, 50)
--order by last_name;
order by 1;

--15
select last_name "Angajat", salary "Salariu lunar"
from employees
where department_id in (10, 30, 50) and salary > 1500
order by 1;

--16
select sysdate
from dual;

select to_char(sysdate, 'd/dd/ddd/dy/day mm/mon/month yy/yyyy/year hh24:mi:ss:sssss')
from dual;

--17
select last_name, hire_date
from employees
where hire_date like '%87%';

select last_name, hire_date
from employees
where to_char(hire_date, 'yyyy') = 1987;

select last_name, hire_date
from employees
where extract(year from hire_date) = 1987; 

--19
SELECT last_name, job_id
FROM employees
WHERE manager_id IS NULL;

--20, 21
select last_name, salary, commission_pct
from employees
--where commission_pct is not null
order by salary desc, commission_pct desc;

--22
select last_name
from employees
where last_name like '__a%';

--23
select last_name
from employees
where lower(last_name) like '%l%l%' 
and (department_id=30 or manager_id=102);

--24
select last_name, job_id, salary
from employees
where (lower(job_id) like '%clerk%' or lower(job_id) like '%rep%')
and salary not in (1000, 2000, 3000);

--25
desc departments;
select department_name
from departments
where manager_id is null;

--Lab 2
select LENGTH('Informatica')
from dual;