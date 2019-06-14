--Ex16: Display current date in multiple formats

--Solution
select to_char(sysdate, 'd/dd/ddd/dy/day mm/mon/month yy/yyyy/year hh24:mi:ss:sssss')
from dual;