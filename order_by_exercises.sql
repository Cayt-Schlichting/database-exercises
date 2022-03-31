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
SELECT * FROM employees 
WHERE first_name IN ('Irena', 'Vidya', 'Maya')
ORDER BY first_name; #1st row: Irena Reutenauer. Last row: Vidya Simmen
#3
SELECT * FROM employees 
WHERE first_name = 'Irena' 
  OR first_name='Vidya' 
  OR first_name='Maya'
ORDER BY first_name, last_name; #1st row: Irena Acton. last row: Vidya Zweizig
#4 - note: the question removes the gender component.
SELECT * FROM employees
WHERE (first_name = 'Irena' OR first_name='Vidya' OR first_name='Maya')
ORDER BY last_name, first_name; #1st row: Irena Acton  Last row: Maya Zyda

#5
SELECT * FROM employees 
WHERE last_name LIKE 'E%E'
ORDER BY emp_no; #1st row: Ramzi Erde. Last row: Tadahiro Erde

#6
SELECT * FROM employees 
WHERE last_name LIKE 'E%E'
ORDER BY hire_date DESC; 
#899 returned, newest emp is Teiji Eldridge, oldest emp [by hire date] Sergi Erde

#7 
SELECT * FROM employees 
WHERE birth_date LIKE '%12-25'
	AND hire_date LIKE '199%' 
ORDER BY birth_date, hire_date DESC; 
#362 returned, (of subset, oldest by age hired most recently) Khun Bernini, (of subsetyoungest by age, hired first) Douadi Petitis
