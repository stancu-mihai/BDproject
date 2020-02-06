create type anginfo13 
is object(id number(3),
          nume varchar2(30),
          data date);
          
create type listaang13 is table of  anginfo13;      

create type ldep13 is object
               (nr number(3),
                lista_ang listaang13);
                
create type x13 is table of ldep13;  


drop table depinfo13;

create table depinfo13(coddep number(3), angajati listaang13)
nested table angajati store as depinfo13_angajati;

declare
x x13:=x13();
begin
  for d in (select department_id from departments) loop
   x.extend;
   x(x.count):=ldep13(d.department_id,listaang13());
   
   for a in (select employee_id,last_name, hire_date
             from employees
             where department_id=d.department_id) loop
           x(x.count).lista_ang.extend;
           x(x.count).lista_ang(x(x.count).lista_ang.count):= 
           anginfo13(a.employee_id,a.last_name, a.hire_date);
   end loop;
   
  end loop;
  
   forall i in 1..x.count
   insert into depinfo13
   values(x(i).nr,x(i).lista_ang);
end;