USE employees;
SHOW CREATE TABLE employees;
-- CREATE TABLE `employees` (
--   `emp_no` int NOT NULL,
--   `birth_date` date NOT NULL,
--   `first_name` varchar(14) NOT NULL,
--   `last_name` varchar(16) NOT NULL,
--   `gender` enum('M','F') NOT NULL,
--   `hire_date` date NOT NULL,
--   PRIMARY KEY (`emp_no`)
-- ) ENGINE=InnoDB DEFAULT CHARSET=latin1

#2 emp table doesn't specify if current or former, so assuming it holds both. 
SELECT * FROM employees WHERE first_name IN ('Irena', 'Vidya', 'Maya'); #709 rows returned
SELECT * FROM employees 
WHERE first_name = 'Irena' 
  OR first_name='Vidya' 
  OR first_name='Maya'; #709 still
#4
SELECT * FROM employees
WHERE gender = 'M'
  AND (first_name = 'Irena' OR first_name='Vidya' OR first_name='Maya'); #441 - odd but true
#5
SELECT * FROM employees WHERE last_name LIKE 'E%'; #7330
#6
SELECT * FROM employees 
WHERE last_name LIKE 'E%'
	OR last_name LIKE '%E'; #30723. (30723 - 7330)= 23393 end with E but don't start with it
#7
SELECT * FROM employees WHERE last_name LIKE 'E%E'; #899 - start and end with E
SELECT * FROM employees WHERE last_name LIKE '%E'; #24292 - ends with E
#8 
SELECT * FROM employees WHERE hire_date LIKE '199%'; #135214 - hired in 90s
#9
SELECT * FROM employees WHERE birth_date LIKE '%12-25'; #842 - employees born on christmas
#10
SELECT * FROM employees 
WHERE birth_date LIKE '%12-25'
	AND hire_date LIKE '199%'; #362 born on christmas and hired in the90s
#11
SELECT * FROM employees WHERE last_name LIKE '%q%'; #1873 - have a q in last name
#12
SELECT * FROM employees 
WHERE last_name LIKE '%Q%' 
	AND last_name NOT LIKE '%QU%'; #547 - have a q in last name and NOT a 'qu' in last name

