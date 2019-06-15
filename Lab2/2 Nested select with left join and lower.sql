 --Show code and name for employees working in the same department 
--having at least an employee whose name contains the letter "t"
--Also display code and name of that department
--Sort by name

--Intermediary: Find departments having at least one employee containing "t" in last name
SELECT *
FROM EMPLOYEES
WHERE LOWER(LAST_NAME) LIKE '%t%' 
AND DEPARTMENT_ID IS NOT NULL
ORDER BY DEPARTMENT_ID

--Solution1:
SELECT E.EMPLOYEE_ID, E.LAST_NAME, E.DEPARTMENT_ID, D.DEPARTMENT_NAME
FROM EMPLOYEES E
LEFT JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID=D.DEPARTMENT_ID
WHERE E.DEPARTMENT_ID IN (
    SELECT DISTINCT DEPARTMENT_ID 
    FROM EMPLOYEES
    WHERE LOWER(LAST_NAME) LIKE '%t%' 
    AND DEPARTMENT_ID IS NOT NULL
    )
ORDER BY LAST_NAME