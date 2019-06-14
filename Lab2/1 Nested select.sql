-- Display name, month (in letters) and hire date for all employees from the same department with Gates
--Only employees whose name contain the letter "a" will be shown (2 solutions required). gates will be excluded.

--Solution1:
SELECT LAST_NAME,FIRST_NAME, to_char(HIRE_DATE,'mon') AS "Month", to_char(HIRE_DATE,'dd') AS "Date" FROM EMPLOYEES
WHERE DEPARTMENT_ID= (
    SELECT DEPARTMENT_ID FROM EMPLOYEES WHERE LAST_NAME='Gates'
)
AND LAST_NAME NOT IN ('Gates')
AND LAST_NAME LIKE '%a%'