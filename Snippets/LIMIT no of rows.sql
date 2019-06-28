select * 
from employees
WHERE
  rownum <= 3
order by employee_id;
