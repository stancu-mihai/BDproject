--Show employee name and the name of department they are working in
--Also show employees with no department (2 solutions required)

--Solution1
SELECT E.LAST_NAME, D.DEPARTMENT_NAME
FROM EMPLOYEES E
LEFT JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID=D.DEPARTMENT_ID

--Solution2
SELECT E.LAST_NAME, D.DEPARTMENT_NAME
FROM DEPARTMENTS D
RIGHT JOIN EMPLOYEES E
ON E.DEPARTMENT_ID=D.DEPARTMENT_ID