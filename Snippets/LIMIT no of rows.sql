select * 
from employees
WHERE
  rownum <= 3
order by employee_id;

SELECT * FROM 
EMPLOYEES
WHERE ROWNUM=1 --SELECT ONE