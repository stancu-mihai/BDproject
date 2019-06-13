--Ex17: Display name and hire date for each employee hired in 1987.
--2 solutions required:
--one with default data format
--one with formated data

--Solution1:
SELECT LAST_NAME, HIRE_DATE
FROM EMPLOYEES
WHERE HIRE_DATE LIKE '%-87%'

--Solution2:
SELECT LAST_NAME, to_char(HIRE_DATE)
FROM EMPLOYEES
WHERE to_char(HIRE_DATE,'YYYY')='1987'