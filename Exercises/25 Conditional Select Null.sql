--Ex25: Display all departments that have no manager

--Solution:
SELECT *
FROM DEPARTMENTS
WHERE MANAGER_ID IS NULL