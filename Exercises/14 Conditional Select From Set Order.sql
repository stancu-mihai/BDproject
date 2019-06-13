--Ex14: Display name, and department for employees in departments 10,30,50
--Sort by name, ascending

--Solution
SELECT LAST_NAME, DEPARTMENT_ID
FROM EMPLOYEES
WHERE DEPARTMENT_ID IN (10,30,50)
ORDER BY LAST_NAME ASC