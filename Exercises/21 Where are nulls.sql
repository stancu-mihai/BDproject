--Ex21: If from exercise 20 we elliminate the WHERE clause, where are the nulls placed?

--Answer: At the beginning
SELECT LAST_NAME, SALARY, COMMISSION_PCT
FROM EMPLOYEES
ORDER BY COMMISSION_PCT DESC