--Ex19: Display last name and job id for each employee without a manager

--Solution:
SELECT LAST_NAME, JOB_ID
FROM EMPLOYEES
WHERE MANAGER_ID IS NULL;