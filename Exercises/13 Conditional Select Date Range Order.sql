--Ex13: Display name, job and hire date for employees that started working between
--20th of Feb 1987 and 1st of May 1989. Order by hire date

--Solution
SELECT LAST_NAME, JOB_ID, HIRE_DATE
FROM EMPLOYEES
WHERE HIRE_DATE BETWEEN '20-FEB-1987' AND '1-MAY-1989'
ORDER BY HIRE_DATE