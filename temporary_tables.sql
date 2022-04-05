USE employees;
SHOW CREATE TABLE employees;

CREATE TEMPORARY TABLE jemison_1764.employees_with_salaries AS 
SELECT * FROM employees JOIN salaries USING (emp_no);

USE jemison_1764;
SELECT * FROM employees_with_salaries;

#1
USE employees;
CREATE TEMPORARY TABLE jemison_1764.employees_with_departments AS
SELECT e.first_name, e.last_name, d.dept_name
FROM employees AS e
	JOIN dept_emp AS de USING(emp_no) #link to dept
    JOIN departments AS d USING(dept_no) #grab dept name 
WHERE de.to_date >= CURDATE();

USE jemison_1764;
SET SQL_SAFE_UPDATES = 0; #gets around safe update
#1a - add full name column.  varchar length determined from employees varchar length (14+16+1)
ALTER TABLE employees_with_departments ADD full_name VARCHAR(31);
#1b - populate full name column
UPDATE employees_with_departments as e_d
SET full_name = CONCAT(e_d.first_name,' ',e_d.last_name);
#1c - remove first and last name columns
SELECT * FROM employees_with_departments LIMIT 2;
ALTER TABLE employees_with_departments DROP COLUMN first_name, DROP COLUMN last_name;
#1d - alternative method for same table
USE employees;
CREATE TEMPORARY TABLE jemison_1764.emp_with_dept_v2 AS
SELECT CONCAT(e.first_name,' ', e.last_name) AS full_name, d.dept_name
FROM employees AS e
	JOIN dept_emp AS de USING(emp_no) #link to dept
    JOIN departments AS d USING(dept_no) #grab dept name 
WHERE de.to_date >= CURDATE();
USE jemison_1764;
SELECT * FROM emp_with_dept_v2 LIMIT 2;

#2 Create temp table from sakila.payment
USE sakila;
CREATE TEMPORARY TABLE jemison_1764.payment_cents AS
SELECT payment_id, customer_id, staff_id, rental_id, round(amount*100) AS amount_cents, payment_date, last_update
FROM payment;
USE jemison_1764;
SELECT * FROM payment_cents LIMIT 2;
#NOTE: can't just duplicate table then multiple amount by 100. Amount column created using DECIMAL(5,2)
#. Meaning value can't go over 3 digits before the decimal. Format is ###.##

#3
USE employees;
# Create table with dept_no and the avg department salary
CREATE TEMPORARY TABLE jemison_1764.avg_pay_dept AS (
    SELECT de.dept_no,
		ROUND(AVG(s.salary)) AS avg_dept_sal
    FROM salaries as s
		JOIN dept_emp as de USING(emp_no)
	WHERE s.to_date >= CURDATE() #only current salaries
	GROUP BY de.dept_no);

USE jemison_1764;
SELECT d.dept_name as 'Department', CONCAT('$',FORMAT(avg_pay_dept.avg_dept_sal,0)) AS 'Average Salary',
	FORMAT(( 
		#zscore = (deptavg - histavg)/stdev(histavg)
		(avg_dept_sal - (SELECT AVG(salary) FROM employees.salaries))
		/ (SELECT STDDEV(salary) FROM employees.salaries)
    ),2) AS zscore
FROM avg_pay_dept
	JOIN employees.departments as d USING(dept_no)
ORDER BY zscore DESC;
-- 'Sales','$88,842','1.48'
-- 'Marketing','$80,015','0.96'
-- 'Finance','$78,645','0.88'
-- 'Production','$67,842','0.24'
-- 'Research','$67,933','0.24'
-- 'Development','$67,666','0.23'
-- 'Customer Service','$66,971','0.19'
-- 'Quality Management','$65,382','0.09'
-- 'Human Resources','$63,795','-0.00'

SET SQL_SAFE_UPDATES = 1;
