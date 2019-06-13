--Ex9: Display all table info in one column

--Solution
SELECT EMPLOYEE_ID || ',' ||
       FIRST_NAME || ',' ||
       LAST_NAME || ',' ||
       EMAIL || ',' ||
       PHONE_NUMBER || ',' ||
       HIRE_DATE || ',' ||
       JOB_ID || ',' ||
       SALARY || ',' ||
       COMMISSION_PCT || ',' ||
       MANAGER_ID || ',' ||
       DEPARTMENT_ID || ',' 
       AS "Full info"
FROM EMPLOYEES