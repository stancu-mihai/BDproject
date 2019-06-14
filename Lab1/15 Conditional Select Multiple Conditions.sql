--Ex15: Display name, and salary for employees in departments 10,30,50 that earn more than 1500

--Solution
SELECT LAST_NAME AS "Name", SALARY AS "Salary"
FROM EMPLOYEES
WHERE DEPARTMENT_ID IN (10,30,50)
AND SALARY > 1500