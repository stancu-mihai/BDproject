-- 16. Să se afişeze suma salariilor pe departamente şi, în cadrul acestora, pe job-uri.
SELECT DEPARTMENT_ID, JOB_ID, SUM(salary)
FROM EMPLOYEES
GROUP BY ROLLUP(DEPARTMENT_ID, JOB_ID); 