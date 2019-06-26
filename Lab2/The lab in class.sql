--show average salary for each department
select first_name, last_name, count(salary) as "jobs" from job_history jh
join employees e on e.employee_id = jh.employee_id
group by first_name, last_name

--show sum of salaries >10000 for each department
select sum(e.salary), department_name from departments d
join employees e on e.department_id=d.department_id
where e.salary > 10000
group by department_name
order by department_name