--Ex12: Display name and salary for employees that DO NOT earn in interval [1500..2850]

--Solution
SELECT FIRST_NAME, SALARY FROM EMPLOYEES
WHERE SALARY NOT BETWEEN 1500 AND 2850