--L3 exe 13. 
--Se cer codurile departamentelor al c?ror nume con?ine ?irul “re” 
--?i în care lucreaz?
--angaja?i având codul job-ului “HR_REP”.

select department_id
from departments
where lower(department_name) like '%re%'
  intersect
select department_id
from employees
where job_id = 'HR_REP';

*** sa se obtina media salariilor angajatilor angajati in anul 2000 
*** si media salariilor tuturor angajatilor
select avg(salary) medie, 'medie salariati ang in anul 2000'
from employees
where to_char(hire_date,  'yyyy' ) = '2000'
  union
select avg(salary), 'medie companie'
from employees 
order by 2; 
--***12. Sa se obtina codurile departamentelor in care nu lucreaza nimeni (nu este introdus
--*** niciun salariat in tabelul employees). Se cer dou? solu?ii.
select department_id 
from departments
    minus
select department_id
from employees;
*** sa se obtina suma salariilor angajatilor din acelasi departament avand acelasi job_id
***     suma salariilor angajatilor care lucreaza in acelasi departament
***     suma salariilor angajatilor

select department_id, job_id, sum(salary)
from employees
group by department_id, job_id
    union all
select department_id, null , sum(salary)
from employees
group by department_id
    union all
select null, null , sum(salary)
from employees    
order by 1 nulls last, 2 nulls last;


select department_id
from departments
where lower(department_name) like '%re%'
  union 
select department_id
from employees
where job_id = 'HR_REP';


select department_id, job_id, sum(salary)
from employees
group by rollup (department_id, job_id  )
order by 1 nulls last, 2 nulls last;

select department_id, job_id, sum(salary), grouping(department_id), grouping(job_id)   
from employees
group by cube (department_id, job_id  )
order by 1 nulls last, 2 nulls last;

select department_id, job_id, sum(salary)
from employees
group by department_id, job_id
    union all
select department_id, null , sum(salary)
from employees
group by department_id;

select department_id, job_id, sum(salary), grouping(department_id), grouping(job_id)   
from employees
group by grouping sets ( (department_id, job_id), (department_id) )
order by 1 nulls last, 2 nulls last;

select department_id, job_id, sum(salary), grouping(department_id), grouping(job_id)   
from employees
group by grouping sets ( (department_id, job_id), () )
order by 1 nulls last, 2 nulls last;

*** sa se obtina pentru fiecare magazin valoarea totala a stocului 
*** in functie de categorii de produse;
*** valoarea totala a stocului pentru fiecare magazin
*** sa se obtina valoarea totala a stocului 
*** (nume_magazin, deminumire_categorie, valoare_stoc)

select m.denumire nume_magazin, c.denumire denumire_categorie, sum(cantitate * pret)
from stoc s join produs p on (s.cod_produs = p.id_produs )
            join categorie c on (p.cod_categorie = c.id_categorie)
            join magazin m on (s.cod_magazin = m.id_magazin)
group by rollup (m.denumire, c.denumire ) ; 


--*** Exerci?iul 8: S? se listeze pentru fiecare produc?tor num?rul produselor de tip 'tablete',
--*** num?rul produselor de tip 'telefoane'
select pr.nume, (select count(*) from produs  where cod_producator = pr.id_producator
                                                 and  cod_categorie in (select id_categorie
                                                                      from categorie 
                                                                      where denumire = 'tablete')  
                 ) nr_tablete ,      
                        
                  (select count(*) from produs  where cod_producator = pr.id_producator
                                                 and cod_categorie in (select id_categorie
                                                                      from categorie 
                                                                      where denumire = 'telefoane'))
                                                                      nr_telefoane
from producator pr;

select p.id_produs, p.denumire, pr.nume, c.denumire , decode(c.denumire, 'tablete', 1, 0)
                                                     ,decode(c.denumire, 'telefoane', 1, 0)
from produs p join producator pr on ( p.cod_producator = pr.id_producator)
              join categorie c  on (p.cod_categorie = c.id_categorie)
order by 3, 4;

select  pr.nume, sum(decode(c.denumire, 'tablete', 1, 0)) nr_tablete
                ,sum(decode(c.denumire, 'telefoane', 1, 0)) nr_telefoane
from produs p right join producator pr on ( p.cod_producator = pr.id_producator)
              left join categorie c  on (p.cod_categorie = c.id_categorie)
group by pr.nume ;

--L4 17. S? se afi?eze numele departamentului si cel mai mic salariu din departamentul
-- avand cel mai mare salariu mediu. 

select e.department_id, d.department_name, min(salary) sal_min
from employees e join departments d on (e.department_id = d.department_id)
group by e.department_id, d.department_name
having avg(salary) = (
                        select max(medie)
                        from (
                            select department_id, avg(salary) medie
                            from employees
                            group by department_id
                        )
                    );                
--*** Exerci?iul 13: Pentru fiecare magazin s? se obtin? categoria 
--*** cu ponderea cea mai mare în totalul stocului.                  
select m.denumire, c.denumire
from stoc s join magazin m on (s.cod_magazin = m.id_magazin)
            join produs p on (s.cod_produs = p.id_produs)
            join categorie c on (p.cod_categorie = c.id_categorie)
group by m.denumire, c.denumire   
having (m.denumire, sum( s.cantitate * s.pret )  ) 
                                in (select mag, max(val_stoc)
                                    from (
                                        select m1.denumire mag, c1.denumire cat,
                                               sum( s1.cantitate * s1.pret )  val_stoc 
                                        from stoc s1 
                                        join magazin m1 on (s1.cod_magazin = m1.id_magazin)
                                        join produs p1 on (s1.cod_produs = p1.id_produs)
                                        join categorie c1 on (p1.cod_categorie = c1.id_categorie)
                                        group by m1.denumire, c1.denumire)
                                      group by mag  
                                    );
                                  
                                    
*** sa se afiseze departamentele in care lucreaza/(nu lucreaza) angajati
select department_name
from departments d 
where exists ( select 'x' from employees where department_id = d.department_id);     
     
select department_name
from departments d 
where not exists ( select 'x' from employees where department_id = d.department_id);      
                                    
***L6 11. S? se afi?eze lista angajatilor care au lucrat numai pe proiecte conduse 
*** de managerul de proiect având codul 102.                                     
select e.employee_id, e.last_name
from employees e
where   not exists  ( select distinct project_id
        from works_on
        where employee_id = e.employee_id
        minus
        select project_id
        from project 
        where project_manager = 102)
and exists  ( select distinct project_id
        from works_on
        where employee_id = e.employee_id);
        
***sa se creeze tabelul  producator_***(id_producator, nume, service, rating)
create table producator_ib ( id_producator number(7),
                             nume varchar2(30) constraint u_prod_ib unique,
                             service varchar2(30) not null,
                             rating number(1),
                             constraint c_prod_ib check (rating between 1 and 5),
                             constraint pk_prod_ib primary key(id_producator)
    );
CREATE SEQUENCE scv_producator_ib
INCREMENT BY 1 
START WITH 1;

insert into producator_ib  (id_producator, nume, service, rating)
values (scv_producator_ib.NEXTVAL, 'prod 1', 'service 1', 5);
    
insert into producator_ib  (id_producator, nume, service, rating)
values (scv_producator_ib.NEXTVAL, 'prod 2', 'service 2', 5);    

***sa se creeze tabelul PRODUS_***(id_produs, denumire, cod_producator)
create table produs_ib(id_produs number(7),
                        denumire varchar(30),
                        cod_producator number(7),
                        constraint pk_produs_ib primary key (id_produs),
                        constraint fk_produs_prod_ib foreign key (cod_producator)
                                                     references producator_ib(id_producator));

alter table produs_ib
add ( rating number(1),
      constraint c_produs_ib check (rating between 1 and 5));

CREATE SEQUENCE scv_produs_ib
INCREMENT BY 1 
START WITH 1;

insert into produs_ib  (id_produs, denumire, cod_producator, rating)
values (scv_produs_ib.NEXTVAL, 'produs 1', 1, 5);
    
insert into produs_ib  (id_produs, denumire, cod_producator, rating)
values (scv_produs_ib.NEXTVAL, 'produs 2', 1, 3);

commit;

*** sa se modifie ratingurile producatorilor astfel incat sa fie media ratingurilor produselor. 
update producator_ib  pr
set rating = (  select avg(rating ) 
                from produs_ib 
                where cod_producator  = pr.id_producator);
                
select * from producator_ib;                

select * from USER_CONSTRAINTS where constraint_name like '%_IB';










