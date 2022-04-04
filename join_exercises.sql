###JOIN DATABASE###
USE join_example_db;
SELECT * FROM users;
SELECT * FROM roles;
#2-JOIN
SELECT *
FROM users AS u
JOIN roles AS r ON u.role_id = r.id;
#LEFT JOIN
SELECT *
FROM users AS u
LEFT JOIN roles AS r ON u.role_id = r.id;
#RIGHT JOIN
SELECT *
FROM users AS u
RIGHT JOIN roles AS r on u.role_id = r.id;

#3
SELECT r.name, COUNT(u.id) AS num_users
FROM roles AS r
LEFT JOIN users AS u on r.id = u.role_id
GROUP BY r.name;
-- 'admin','1'
-- 'author','1'
-- 'reviewer','2'
-- 'commenter','0'

### EMPLOYEES DATABASE ###
USE employees;
#2 DEP & current manager
SELECT d.dept_name AS 'Department Name', CONCAT(e.first_name,' ',e.last_name) AS 'Department Manager'
FROM dept_manager AS dm
	JOIN departments AS d ON dm.dept_no = d.dept_no
    #JOIN departments AS d USING(dept_no) <<<<THIS IS SO COOL
    JOIN employees AS e ON dm.emp_no = e.emp_no
WHERE dm.to_date >= CURDATE(); 
#3 Name of all depts currently managed by women
SELECT d.dept_name AS 'Department Name', CONCAT(e.first_name,' ',e.last_name) AS 'Department Manager'
FROM dept_manager AS dm
	JOIN departments AS d ON dm.dept_no = d.dept_no
    JOIN employees AS e ON dm.emp_no = e.emp_no
WHERE dm.to_date >= CURDATE() AND e.gender = 'F';
#4 Find current titles of emps currently working in customer service dept - really wants a count
SELECT t.title AS 'Employee Title', COUNT(*) AS 'Count'
FROM dept_emp AS de
	JOIN departments AS d on de.dept_no = d.dept_no #tie to dept name
    JOIN employees AS e on e.emp_no = de.emp_no #tie to emp name
    JOIN titles AS t on t.emp_no = de.emp_no #tie to titles
WHERE d.dept_name = 'Customer Service'
	AND de.to_date >= CURDATE() #validate emp is currently in department
    AND t.to_date >= CURDATE() #Only want current title.
GROUP BY t.title 
ORDER BY t.title ASC;
#5 Find the current salary of current managers
SELECT d.dept_name AS 'Department',
	CONCAT(e.first_name,' ',e.last_name) AS 'Name',
    CONCAT('$',FORMAT(s.salary,0)) AS 'Salary'
FROM dept_manager AS dm
	JOIN departments AS d ON dm.dept_no = d.dept_no #grab dept name
    JOIN employees AS e ON dm.emp_no = e.emp_no #grab emp name
    JOIN salaries AS s on dm.emp_no = s.emp_no #grab salary
WHERE dm.to_date >= CURDATE()
	AND s.to_date >= CURDATE()
ORDER BY d.dept_name ASC;
#6 Find # of current employees in each dept
SELECT d.dept_no AS 'Department ID', d.dept_name AS 'Department Name', COUNT(*) AS 'Number of Employees'
FROM dept_emp AS de
	JOIN departments AS d ON de.dept_no = d.dept_no
WHERE de.to_date >= CURDATE()
GROUP BY d.dept_no, d.dept_name
ORDER BY d.dept_no ASC;
#7 Which department has the highest average salary (current)
SELECT d.dept_name AS 'Department Name', AVG(s.salary) AS 'avg_salary'
FROM salaries AS s
	JOIN dept_emp AS de ON s.emp_no = de.emp_no #tie salaries to departments
    JOIN departments AS d ON de.dept_no = d.dept_no #grab department name
WHERE de.to_date >= CURDATE()
	AND s.to_date >= CURDATE()
GROUP BY d.dept_name 
ORDER BY avg_salary DESC #NOTE: ORDER BY wasn't working when i aliased with a string that had a space
LIMIT 1;
#8 Who is the highest paid employee in the Marketing Department
SELECT CONCAT(e.first_name,' ',e.last_name) AS 'Employee name'
FROM salaries AS s
	JOIN dept_emp AS de ON s.emp_no = de.emp_no
    JOIN departments AS d ON de.dept_no = d.dept_no
    JOIN employees AS e ON s.emp_no = e.emp_no
WHERE de.to_date >= CURDATE()
	AND s.to_date >= CURDATE()
    AND d.dept_name = 'Marketing'
ORDER BY s.salary DESC
LIMIT 1;
#9 Which current department manager has the highest salary
SELECT CONCAT(e.first_name,' ',e.last_name) AS 'Employee name',
	s.salary,
    d.dept_name
FROM salaries AS s
	JOIN dept_manager AS dm ON s.emp_no = dm.emp_no
    JOIN departments AS d ON dm.dept_no = d.dept_no
    JOIN employees AS e ON s.emp_no = e.emp_no
WHERE dm.to_date >= CURDATE()
	AND s.to_date >= CURDATE()
ORDER BY s.salary DESC
LIMIT 1;
#10 Determine the average salary for each dept - use all salary info
SELECT d.dept_name, ROUND(AVG(s.salary)) AS 'avg_salary'
FROM salaries AS s
	JOIN dept_emp AS de ON s.emp_no = de.emp_no #to de to grab associated department #
    JOIN departments AS d ON de.dept_no = d.dept_no #grab name for deptartment
GROUP BY d.dept_name
ORDER BY avg_salary DESC;
#The above gets you the answer you want, but it's a flawed business request.  There is no validation that 
# the salaries being averaged are the salaries actually held in that department.  This would only be actionable
# data if employees NEVER changed departments (at which point the dates employees were in a dept wouldn't matter
# and that still is just a historical average of salaries...which makes the number not very useful unless you are looking 
# for a general idea of departments that have been paid the highest (which also doesn't work well as it assumes
# all departments were created at the same time.
#This is a better query:
SELECT d.dept_name, ROUND(AVG(s.salary)) AS 'avg_salary'
FROM salaries AS s
	JOIN dept_emp AS de ON s.emp_no = de.emp_no #to de to grab associated department #
    JOIN departments AS d ON de.dept_no = d.dept_no #grab name for deptartment
WHERE de.to_date >= CURDATE() #make sure current dept employee
	AND s.to_date >= CURDATE() #only look at current salaries of those employees
GROUP BY d.dept_name
ORDER BY avg_salary DESC;

#11 Find names of all current employees, their dept name and manager name
SELECT CONCAT(e.first_name,' ',e.last_name) AS 'Employee Name',
	d1.dept_name AS 'Department Name',
    d1.dept_man AS 'Department Manager'
FROM ( #Make derived table that has dept no, dept name and manager name
	SELECT d.dept_no, 
		d.dept_name,
        CONCAT(e.first_name,' ',e.last_name) AS 'dept_man'
	FROM departments as d
		JOIN dept_manager as dm ON d.dept_no = dm.dept_no
        JOIN employees as e ON dm.emp_no = e.emp_no
	WHERE dm.to_date >= CURDATE()
) AS d1
JOIN dept_emp AS de ON d1.dept_no = de.dept_no
JOIN employees AS e ON de.emp_no = e.emp_no
WHERE de.to_date >= CURDATE();

#12 Who is the highest paid employee in each department
SELECT CONCAT(e.first_name,' ',e.last_name) AS 'Employee name',
	d.dept_name AS 'Department Name',
    CONCAT('$',FORMAT(sr.salary,0)) AS 'Salary'
FROM ( #CREATES a table with all current dept employees, their current salary, and their salary rank per dept
	SELECT de.dept_no,
		s.emp_no,
		s.salary,
		row_number() OVER (partition by de.dept_no ORDER BY s.salary DESC) AS dept_sal_rank
		#This breaks up the results by department, then for each department, assigns a rank based on salary
	FROM salaries AS s
		JOIN dept_emp AS de ON s.emp_no = de.emp_no
	WHERE s.to_date >= CURDATE() 
		AND de.to_date >= CURDATE()
) AS sr #salary ranks
JOIN employees AS e ON sr.emp_no = e.emp_no
JOIN departments AS d ON sr.dept_no = d.dept_no
WHERE sr.dept_sal_rank = 1;

