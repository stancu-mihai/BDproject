--Ex20: Display last name, salary and commission for each employee that earns a comission

--Solution:
SELECT LAST_NAME, SALARY, COMMISSION_PCT
FROM EMPLOYEES
WHERE COMMISSION_PCT IS NOT NULL