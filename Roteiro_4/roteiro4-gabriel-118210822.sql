-- Questão 1
SELECT * 
from department;

-- Questão 2
SELECT * 
from dependent;

-- Questão 3
SELECT *
from dept_locations;

-- Questão 4
SELECT *
from employee;

-- Questão 5
SELECT *
from project;

-- Questão 6
SELECT *
from works_on;

-- Questão 7
SELECT fname, lname
from employee
where sex = 'M';

-- Questão 8
select fname, lname
from employee
where superssn IS Null;

-- Questão 9
select e1.fname as Employee_Name, e2.fname as Super_Name
from employee as e1, employee as e2
where e1.superssn = e2.ssn;

-- Questão 10
select e1.fname
from employee as e1, employee as e2
where e1.superssn = e2.ssn and e2.fname = 'Franklin';

-- Questão 11
select d.dname, dl.dlocation
from department as d, dept_locations as dl
where d.Dnumber = dl.Dnumber;

-- Questão 12
select d.dname, dl.dlocation
from department as d, dept_locations as dl
where d.dnumber = dl.dnumber and dl.dlocation like 'S%';

-- Questão 13
select e.fname as Employee_Fname, e.lname as Employee_Lname, dp.dependent_name
from employee as e, dependent as dp
where dp.essn = e.ssn;

-- Questão 14
select fname || lname as fullname, salary
from employee
where salary > 50000;

-- Questão 15
select p.pname, d.dname
from project as p, department as d
where p.dnum = d.dnumber;

-- Questão 16
select p.pname, e.fname
from project as p, department as d, employee as e
where p.pnumber > 30 and p.dnum = d.dnumber and d.mgrssn = e.ssn;

-- Questão 17
select p.pname, e.fname
from project as p, employee as e, works_on as w
where e.ssn = w.essn and w.pno = p.pnumber;

-- Questão 18
select e.fname, d.dependent_name, d.relationship
from employee as e, works_on as w, dependent as d
where d.essn = e.ssn and e.ssn = w.essn and w.pno = 91;
