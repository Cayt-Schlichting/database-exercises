USE employees;
#1 find all current employees with a hire date that matches emp 101010
SELECT emp_no
FROM employees
WHERE hire_date = (
	SELECT hire_date FROM employees WHERE emp_no = 101010
    ); #69 rows returned
#So that technically only grabs employees with the same hire date.  Ideally, that table would
# also have a "to_date" which would let us know if they are still employed there.  Since it doesn't,
# we have to assume that either the dept_emp or salaries tables are complete with all employees and
# are a good resource to identify current emps
#V2 - with dept_emp table
SELECT e.emp_no
FROM employees AS e
	JOIN dept_emp AS de ON e.emp_no = de.emp_no
WHERE hire_date = (
	SELECT hire_date FROM employees WHERE emp_no = 101010
    )
    AND de.to_date >= CURDATE(); #55 rows returned
#V3 - with salaries
SELECT e.emp_no
FROM employees AS e
	JOIN salaries AS s ON e.emp_no = s.emp_no
WHERE hire_date = (
	SELECT hire_date FROM employees WHERE emp_no = 101010
    )
    AND s.to_date >= CURDATE(); #55 rows returned
#since both v2 and v3 had 55 results, it indicates these are the current employees 
# however it would be more appropriate to cross reference the two lists (or just to have some database documentation)

#2 Find all titles ever held by all current employees with the first name Aamod
SELECT DISTINCT title #only want distinct titles
FROM titles
WHERE emp_no IN (
	#subquery find list of current emp_no for employees named 'aamod'
    SELECT emp_no FROM employees WHERE first_name="Aamod"
    )
    AND to_date >= CURDATE();
    
#3 How many ppl in employees table no longer work for the company
SELECT COUNT(*)
FROM employees
WHERE emp_no NOT IN (
	#This table of current employee ids
	SELECT e.emp_no
	FROM employees as e
		JOIN dept_emp AS de USING(emp_no)
	WHERE de.to_date >= CURDATE()
	); #59900
    
#4 Find all current department managers that are female
SELECT CONCAT(e.first_name,' ',e.last_name)
FROM dept_manager as dm
	LEFT JOIN employees AS e USING(emp_no)
WHERE dm.to_date >= CURDATE() 
	AND e.gender = 'F';
-- 'Isamu Legleitner'
-- 'Karsten Sigstam'
-- 'Leon DasSarma'
-- 'Hilary Kambil'

#5 Find all employees who currently have a higher salary than the companies overall, historical avg salary
SELECT emp_no 
FROM salaries
WHERE salary > (
	#historical avg salary of company
	SELECT AVG(salary) FROM salaries
	) AND to_date >= CURDATE();

#6 How many current salaries are w/i 1 stddev of current highest salary
# Answers: 78 salaries.  .03% of current salaries
SELECT COUNT(*)
FROM salaries
WHERE to_date >= CURDATE()
AND salary >= (
	#max salary minus one standard deviation
	(SELECT MAX(salary) FROM salaries WHERE to_date >- CURDATE())
	-(SELECT STDDEV(salary) FROM salaries WHERE to_date >- CURDATE())
); #78
#Get the percentage
SELECT (
	( #number w/i one std dev
    SELECT COUNT(*)
	FROM salaries
	WHERE to_date >= CURDATE()
	AND salary >= (
		#max salary minus one standard deviation
		(SELECT MAX(salary) FROM salaries WHERE to_date >- CURDATE())
		-(SELECT STDDEV(salary) FROM salaries WHERE to_date >- CURDATE())
		)) /
		( #total current salaries
		SELECT COUNT(*)
		FROM salaries
		WHERE to_date >= CURDATE()
		)
    ); #.03%

#B1 Find all dep names that currently have female managers
SELECT d.dept_name
FROM dept_manager as dm
	LEFT JOIN employees AS e USING(emp_no)
    LEFT JOIN departments AS d USING(dept_no)
WHERE dm.to_date >= CURDATE() 
	AND e.gender = 'F';
    
#B2 Find the first and last name
SELECT first_name, last_name
FROM employees
WHERE emp_no = 
    (SELECT emp_no FROM salaries WHERE to_date >= CURDATE() ORDER BY salary DESC LIMIT 1);
    
#B3 Find dept name that the employee with the highest salary works in
SELECT d.dept_name
FROM dept_emp AS de
	JOIN departments AS d USING(dept_no)
WHERE de.emp_no = 
    (SELECT emp_no FROM salaries WHERE to_date >= CURDATE() ORDER BY salary DESC LIMIT 1);
