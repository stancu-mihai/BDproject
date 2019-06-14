--Ex8: Concatenate columns

--Solution
SELECT  LAST_NAME || 
        ', ' || 
        JOB_ID 
        AS "Employee, Title"
FROM EMPLOYEES