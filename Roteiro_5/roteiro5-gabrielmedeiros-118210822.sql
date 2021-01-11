-- Questão 1
select COUNT(*)
from employee
where sex = 'F'

-- Questão 2
select avg(salary) as avg
from employee
where sex = 'M' and address LIKE '%TX'

-- Questão 3
select superssn as ssn_supervisor, count(*) as qtd_supervisionados
from employee
GROUP by superssn
order by count(*)

-- Questão 4
select e2.fname as nome_supervisor, count(*) as qtd_supervisionados
from employee e1 inner join employee e2 on e1.superssn = e2.ssn
group by e2.fname, e1.superssn
order by count(*)

-- Questão 5
select e2.fname as nome_supervisor, count(*) as qtd_supervisionados
from employee e1 left join employee e2 on e1.superssn = e2.ssn
group by e2.fname, e1.superssn
order by count(*)


-- Questão 6
select min(mycount) as qtd
from (select count(*) as  mycount
	from works_on w
	GROUP by w.pno) r;

-- Questão 7
select pno as num_proj, qtd_func
from (select w.pno, count(*) as  qtd_func
      from works_on w
      GROUP by w.pno) r
where r.qtd_func <= all (select count(*) as qtd from works_on w GROUP by w.pno);


-- Questão 8
select w.pno as proj_num, avg(e.salary) as media_sal
from employee as e, works_on as w
where e.ssn = w.essn
group by w.pno

-- Questão 9
select p.pnumber as prof_num, p.pname as proj_name, avg(e.salary) as media_sal
from employee as e, works_on as w, project as p
where e.ssn = w.essn and w.pno = p.pnumber
group by p.pnumber

-- Questão 10
select fname, salary
from employee
where salary > all (select e.salary 
                    from employee e, works_on w
                    where e.ssn = w.essn and w.pno = 92)

-- Questão 11
select w.essn as ssn, count(*) as qtd_proj
from works_on w
group by w.essn
order by count(*)

-- Questão 12
SELECT w.pno, count(*)
from works_on w right join employee e on w.essn = e.ssn
group by w.pno
having count(*) < 5
order by count (*)

-- Questão 13.1
select fname
from employee
where ssn in (select ssn
              from employee e, works_on w, project pr
              where e.ssn = w.essn and w.pno = pr.pnumber and pr.plocation = 'Sugarland')
      and ssn in (select ssn
                  from employee e, dependent d
                  where e.ssn = d.essn)

-- Questão 13.2
select DISTINCT e.fname
from employee e, works_on w, project p, dependent d
where e.ssn = w.essn and w.pno = p.pnumber 
		and p.plocation = 'Sugarland' and e.ssn = d.essn


-- Questão 14
select dname 
from department
except 
select dname 
from project pr, department d
where pr.dnum = d.dnumber

-- Questão 15
select e.fname, e.lname
from employee e
where not exists ((select w.pno
                   from works_on w
                   where w.essn = '123456789') 
                   except 
                 (select w1.pno
                   from works_on w1
                   where e.ssn <> '123456789'
                  		and w1.essn = e.ssn))