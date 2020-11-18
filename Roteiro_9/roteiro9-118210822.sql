-- Proposed Questions

-- Questions 1

-- Question 1.A

drop VIEW if exists vw_dptmgr;
create VIEW vw_dptmgr as
	select d.dnumber, e.fname, e.lname
    from employee e, department d
    where e.ssn = d.mgrssn;
    
-- Question 1.B

drop VIEW if exists vw_empl_houston;
create VIEW vw_empl_houston as
	select e.ssn, e.fname, e.lname
    from employee e
    where e.address like '%Houston%';
    
-- Question 1.C

drop VIEW if exists vw_deptstats;
create VIEW vw_deptstats as
	select d.dnumber, d.dname, COUNT(*)
    from employee e inner join department d on e.dno = d.dnumber
   	group by d.dnumber, d.dname;
    
-- Question 1.D

drop VIEW if exists vw_projstats;
create VIEW vw_projstats as
	select w.pno, count(*)
    from works_on w
   	group by w.pno;
    
---- Question 2

SELECT * from vw_dptmgr;

Select * from vw_empl_houston;

select * from vw_deptstats;

select * from vw_projstats;

-- Question 3

Drop view vw_dptmgr;

Drop view vw_empl_houston;

Drop view vw_deptstats;

Drop view vw_projstats;

-- Question 4

CREATE OR REPLACE FUNCTION check_age(ssn_ char(9))
RETURNS VARCHAR AS $$
DECLARE age integer;
BEGIN
	SELECT into age DATE_PART('year', AGE(CURRENT_DATE, e.bdate)) from employee e where e.ssn = ssn_;
	IF (age is NULL) THEN
    	return 'UNKNOWN';
	ELsIF (age < 0) THEN
    	RETURN 'INVALID';
    ELSIF (age < 50) THEN
    	RETURN 'YOUNG';
    ELsIF (age >= 50) THEN
    	RETURN 'SENIOR';
	END IF;
END;
$$ LANGUAGE plpgsql;

-- Question 5

CREATE OR REPLACE FUNCTION check_mgr() RETURNS TRIGGER AS $$
	DECLARE emp char(9);	
    BEGIN
    	IF (NEW.mgrssn is null) THEN
            RAISE EXCEPTION 'Mgrssn cannot be null';
        END IF;
        
        IF (check_age(NEW.mgrssn) <> 'SENIOR') THEN
            RAISE EXCEPTION 'Manager must be a SENIOR employee';
        END IF;
        
        if (not Exists (select e.ssn from employee e where e.superssn = NEW.mgrssn)) THEN
        	RAISE EXCEPTION 'Manager must have supevisees';
        end if;
        
        IF (NEW.mgrssn not in (select e.ssn from employee e where e.dno = new.dnumber)) THEN
            RAISE EXCEPTION 'Manager must be a department employee';
        END IF;
    END;
$$ LANGUAGE plpgsql;

drop trigger if exists check_mgr on department;
CREATE TRIGGER check_mgr BEFORE INSERT or UPDATE ON department FOR EACH ROW EXECUTE PROCEDURE check_mgr();
