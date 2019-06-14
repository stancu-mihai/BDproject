--Ex20: Display last name, salary and commission for each employee that earns a comission
--Order by commission descending

--Solution:
SELECT LAST_NAME, SALARY, COMMISSION_PCT
FROM EMPLOYEES
WHERE COMMISSION_PCT IS NOT NULL
ORDER BY COMMISSION_PCT DESC