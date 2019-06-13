--Ex24: Display last name, job and salary for all employees whose job contains 'CLERK' or 'REP'
--and salary is not 1000, 2000, or 3000

--Solution:
SELECT LAST_NAME, JOB_ID, SALARY
FROM EMPLOYEES
WHERE JOB_ID LIKE '%CLERK%'
OR JOB_ID LIKE '%REP%'
AND SALARY NOT IN (1000, 2000, 3000)