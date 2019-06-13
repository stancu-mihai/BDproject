--Ex18: Display first name, last name and hire date for each employee 
--hired in the same day of the month as the current day of the month.

--Solution:
SELECT FIRST_NAME, LAST_NAME, HIRE_DATE
FROM EMPLOYEES
WHERE to_char(HIRE_DATE,'DD')=to_char(SYSDATE,'DD')