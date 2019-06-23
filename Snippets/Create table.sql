CREATE TABLE EMPLOYEES (
   emp_code number(9) ,
   last_name varchar2(30),
   first_name varchar2(30),
   salary number(10,2),
   department_id number(9),
   date_hire date not null,
   time_hire timestamp not null,
   CONSTRAINT pk_ibd PRIMARY KEY (emp_code),
   CONSTRAINT u_ibd unique (last_name),
   CONSTRAINT  c_ibd CHECK (salary > 2000),
   CONSTRAINT countr_reg_fk FOREIGN KEY (region_id) REFERENCES regions(region_id) 
   );