--Show code, name and salary for employees working in the same department 
--having at least an employee whose name contains the letter "t" and 
--having the salary larger than the average salary for that job
--Sort by name

--Intermediary: Find departments having at least one employee containing "t" in last name
SELECT *
FROM EMPLOYEES
WHERE LOWER(LAST_NAME) LIKE '%t%' 
AND DEPARTMENT_ID IS NOT NULL
ORDER BY DEPARTMENT_ID

--Intermediary: Find average salary by job title
SELECT AVG(SALARY), JOB_TITLE
FROM EMPLOYEES E
LEFT JOIN JOBS J
ON E.JOB_ID=J.JOB_ID
GROUP BY JOB_TITLE 

--Solution:
SELECT E.EMPLOYEE_ID, E.LAST_NAME, JOB_TITLE
FROM EMPLOYEES E
LEFT JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID=D.DEPARTMENT_ID
LEFT JOIN JOBS J
ON E.JOB_ID=J.JOB_ID
WHERE E.DEPARTMENT_ID IN (
    SELECT DISTINCT DEPARTMENT_ID 
    FROM EMPLOYEES
    WHERE LOWER(LAST_NAME) LIKE '%t%' 
    AND DEPARTMENT_ID IS NOT NULL
    )
AND E.SALARY >= (
  SELECT RESULT FROM (
    SELECT AVG(SALARY) AS "RESULT", JOB_TITLE
    FROM EMPLOYEES E
    LEFT JOIN JOBS J
    ON E.JOB_ID=J.JOB_ID
    GROUP BY JOB_TITLE 
  )
  WHERE JOB_TITLE=J.JOB_TITLE
)