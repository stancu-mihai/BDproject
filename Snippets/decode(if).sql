--decode( expression, value , value if true  , value if false )


SELECT supplier_name,
DECODE(supplier_id, 10000, 'IBM',
                    10001, 'Microsoft',
                    10002, 'Hewlett Packard',
                    'Gateway') result
FROM suppliers;


SELECT JOB_ID "Job",
DECODE(DEPARTMENT_ID, 30, SUM(SALARY), '0') "Dep30", --if department_id is 30, display sum(salary), otherwise display 0
DECODE(DEPARTMENT_ID, 50, SUM(SALARY), '0') "Dep50",
DECODE(DEPARTMENT_ID, 80, SUM(SALARY), '0') "Dep80"
FROM EMPLOYEES
WHERE DEPARTMENT_ID IN (30,50,80)
GROUP BY JOB_ID, DEPARTMENT_ID; 