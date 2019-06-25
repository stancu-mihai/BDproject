select avg(salary) 
from employees
where to_char(hire_date, 'DD-MON-YY') like '__-___-00'