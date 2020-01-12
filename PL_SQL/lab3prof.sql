set serveroutput on
DECLARE  
CURSOR c_emp IS   
SELECT last_name, salary*12 sal_an   
FROM emp_pnu 
WHERE department_id = 50;  
V_emp c_emp%ROWTYPE; 
BEGIN  
OPEN c_emp;  
FETCH c_emp INTO v_emp;  
WHILE (c_emp%FOUND) LOOP       
DBMS_OUTPUT.PUT_LINE (' Nume:' || 
v_emp.last_name || ' are salariul anual : '
|| v_emp.sal_an);      
FETCH c_emp INTO v_emp;  
END LOOP;  
CLOSE c_emp; 
END;

DECLARE  
CURSOR c_emp IS  
SELECT last_name, salary*12 sal_an   
FROM emp_pnu 
WHERE department_id = 50;  
BEGIN   
FOR v_emp IN c_emp LOOP 
  DBMS_OUTPUT.PUT_LINE (' Nume:' || 
  v_emp.last_name || ' are salariul anual : '
  || v_emp.sal_an);   
END LOOP; 
END;

BEGIN   
FOR v_emp IN (SELECT last_name, salary*12 sal_an   
FROM emp_pnu 
WHERE department_id = 50) LOOP 
  DBMS_OUTPUT.PUT_LINE (' Nume:' || 
  v_emp.last_name || ' are salariul anual : '
  || v_emp.sal_an);   
END LOOP; 
END;


DECLARE   
TYPE  emp_tip IS REF CURSOR RETURN emp_pnu%ROWTYPE;   
V_emp emp_tip;   
V_optiune NUMBER := &p_optiune; 
linie emp_pnu%rowtype;
BEGIN   
              IF v_optiune = 1 THEN     
                    OPEN v_emp FOR SELECT * FROM emp_pnu;    
               ELSIF v_optiune = 2 THEN       
                    OPEN v_emp FOR SELECT * FROM emp_pnu                       
                    WHERE salary BETWEEN 10000 AND 20000;    
              ELSIF v_optiune = 3 THEN     
                    OPEN v_emp FOR SELECT * FROM emp_pnu                         
                    WHERE TO_CHAR(hire_date, 'YYYY') = 1990;     
              ELSE     
                   DBMS_OUTPUT.PUT_LINE('Optiune incorecta');   
                   -- raise_application_error(-20134,'Optiune incorecta');
              END IF; 
        if   v_emp%isopen then    
            loop
              fetch v_emp into linie;
              exit when v_emp%notfound;
              dbms_output.put_line(linie.employee_id||' '||linie.salary||' '||linie.hire_date);
            end loop;
        close v_emp; 
       end if; 
END; 

DECLARE   
TYPE  cursor_dinamic IS REF CURSOR;   
V_cursor cursor_dinamic;   
V_optiune NUMBER := &p_optiune; 
linie_emp emp_pnu%rowtype;
linie_dept departments%rowtype;
linie_job jobs%rowtype;
BEGIN   
              IF v_optiune = 1 THEN     
                    OPEN v_cursor FOR SELECT * FROM emp_pnu;  
                     loop
                        fetch v_cursor into linie_emp;
                        exit when v_cursor%notfound;
                        dbms_output.put_line(linie_emp.employee_id||' '||linie_emp.salary||' '
                        ||linie_emp.hire_date);
                        end loop;
               ELSIF v_optiune = 2 THEN       
                    OPEN v_cursor FOR SELECT * FROM departments;   
                     loop
                        fetch v_cursor into linie_dept;
                        exit when v_cursor%notfound;
                        dbms_output.put_line(linie_dept.department_id||' '||linie_dept.department_name);
                        end loop;
              ELSIF v_optiune = 3 THEN     
                    OPEN v_cursor FOR SELECT * FROM jobs; 
                        loop
                        fetch v_cursor into linie_job;
                        exit when v_cursor%notfound;
                        dbms_output.put_line(linie_job.job_id||' '||linie_job.job_title);
                        end loop;
              ELSE     
                   DBMS_OUTPUT.PUT_LINE('Optiune incorecta');   
                   -- raise_application_error(-20134,'Optiune incorecta');
              END IF; 
        if   v_cursor%isopen then    
           close v_cursor; 
       end if; 
END; 

create or replace 
PROCEDURE 
UPD_JOB_pnu19  (p_job_id IN jobs.job_id%TYPE, p_job_title IN jobs.job_title%TYPE) 
IS 
nr number(2):=0;
eroare exception;
BEGIN  
    select count(*) into nr
    from jobs_pnu19
    where job_id=p_job_id;
if nr=1 then 
    UPDATE jobs_pnu19  
    SET job_title =  p_job_title  
    WHERE job_id = p_job_id; 
else 
   raise eroare;
END IF; 
commit;
exception
 when eroare then RAISE_APPLICATION_ERROR(-20202, 'Nicio actualizare'); 
END;