--Ex23: Display last name for all employees having two 'L' letters in the name and
--work in department 30 or have 102 as manager

--Solution:
SELECT FIRST_NAME
FROM EMPLOYEES
WHERE FIRST_NAME LIKE '%l%l%'
AND DEPARTMENT_ID=30
OR MANAGER_ID=102