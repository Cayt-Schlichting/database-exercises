USE employees;
SHOW tables;
DESCRIBE employees;
DESCRIBE departments;
/*
6) emp_no has numeric data types
7) first_name, last_name and gender have string data types (though gender is pulled from a list)
8) birth_date and hire_date both have date data types
9) They are in the same DB :).  But seriously, we haven't discussed relationships.  Glancing at the two tables, there 
	is no foreign key that ties them together, however you can chain emp_no to dept_no using dept_emp.  Granted, those
    seem to be 1-1 which seems like it might cause issue if an emp worked at multiple locations.
*/
SHOW CREATE TABLE dept_manager;
-- CREATE TABLE `dept_manager` (
--   `emp_no` int NOT NULL,
--   `dept_no` char(4) NOT NULL,
--   `from_date` date NOT NULL,
--   `to_date` date NOT NULL,
--   PRIMARY KEY (`emp_no`,`dept_no`),
--   KEY `dept_no` (`dept_no`),
--   CONSTRAINT `dept_manager_ibfk_1` FOREIGN KEY (`emp_no`) REFERENCES `employees` (`emp_no`) ON DELETE CASCADE ON UPDATE RESTRICT,
--   CONSTRAINT `dept_manager_ibfk_2` FOREIGN KEY (`dept_no`) REFERENCES `departments` (`dept_no`) ON DELETE CASCADE ON UPDATE RESTRICT
-- ) ENGINE=InnoDB DEFAULT CHARSET=latin1


/* Other random work
DESCRIBE dept_emp;
SHOW CREATE TABLE dept_emp;
*/
