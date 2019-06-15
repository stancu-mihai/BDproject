--Show department id, department name, name and id of the job
--for all employees belonging to departments having "ti" in the name
--List employee salary in format "$99,999.00"
--Sort ascending by department name, then by employee name

--Solution:
SELECT E.LAST_NAME, E.DEPARTMENT_ID, DEPARTMENT_NAME, E.JOB_ID, JOB_TITLE, TO_CHAR(SALARY, '$99,999.00') "Salary"
FROM (
    SELECT * FROM EMPLOYEES
    WHERE MANAGER_ID=100
    )
E
LEFT JOIN JOBS J ON E.JOB_ID = J.JOB_ID
LEFT JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
WHERE DEPARTMENT_NAME LIKE '%ti%'
ORDER BY D.DEPARTMENT_NAME, E.LAST_NAME ASC