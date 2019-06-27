--Department id for departments containing RE
--having employees with job id containing hr_rep
select d.department_id from employees e
join departments d 
on e.department_id = d.department_id
where lower(e.job_id) like '%hr_rep%'
and lower(d.department_name) like '%re%'

--average salary for employees hired in 2000
select avg(salary) 
from employees
where to_char(hire_date, 'DD-MON-YY') like '__-___-00'

--deparment ids where the employee_id is null (no one is working)
select d.department_id
from departments d
left join employees e on e.department_id =d.department_id
where e.employee_id is null

--sum of salaries for employees from same department with same job_id
select sum(salary), department_id, job_id
from employees
group by department_id, job_id

-- Show sum of the salaries for each job_id in each department id as a subtotal
select department_id, job_id, sum(salary)
from employees
group by rollup (department_id, job_id  )
order by 1 nulls last, 2 nulls last;

--Show the sum of the salaries for each job id and for each department
select department_id, job_id, sum(salary), grouping(department_id), grouping(job_id)   
from employees
group by cube (department_id, job_id  )
order by 1 nulls last, 2 nulls last;

--union between 2 selects having different number of columns
select department_id, job_id, sum(salary)
from employees
group by department_id, job_id
    union all
select department_id, null , sum(salary)
from employees
group by department_id;

--Show department name and minimum salary for the department
--having the greatest average salary
select department_name, min(salary)
from employees e
join departments d
on e.department_id = d.department_id
where e.department_id = ( --department having the greatest average salary
         select department_id from 
         ( -- average salary for each department
            select department_id, avg(salary) as "mean"
            from employees 
            group by department_id
         ) 
         where "mean" = (  --max average salary
             select max("mean") from  
             ( -- average salary for each department
                select department_id, avg(salary) as "mean"
                from employees 
                group by department_id
             ) 
         )
)
group by department_name

--show only departments where people are working
select department_name from employees e
right join departments d on e.department_id= d.department_id
where first_name is not null

--show only departments where people are not working
select department_name from employees e
right join departments d on e.department_id= d.department_id
where first_name is not null

--show employees that have worked only on projects led by manager id 102
 select employee_id from works_on wo
 join projects p on p.project_id=wo.project_id
 where p.project_id in (
    select project_id from projects
    where project_manager=102
)
 
 minus
 
 select employee_id from works_on wo
 join projects p on p.project_id=wo.project_id
 where p.project_id not in (
    select project_id from projects
    where project_manager=102
)