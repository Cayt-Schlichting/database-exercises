###JOIN DATABASE###
USE join_example_db;
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
SELECT r.name, COUNT(*) AS num_users
FROM roles AS r
LEFT JOIN users AS u on r.id = u.role_id
GROUP BY r.name;
-- 'admin','1'
-- 'author','1'
-- 'reviewer','2'
-- 'commenter','1'

### EMPLOYEES DATABASE ###
USE employees;
#2 DEP & current manager
SELECT d.dept_name AS 'Department Name', CONCAT(e.first_name,' ',e.last_name) AS 'Department Manager'
FROM dept_manager AS dm
	JOIN departments AS d ON dm.dept_no = d.dept_no
    JOIN employees AS e ON dm.emp_no = e.emp_no
WHERE dm.to_date >= CURDATE();
#3 Name of all depts currently managed by women
SELECT d.dept_name AS 'Department Name', CONCAT(e.first_name,' ',e.last_name) AS 'Department Manager'
FROM dept_manager AS dm
	JOIN departments AS d ON dm.dept_no = d.dept_no
    JOIN employees AS e ON dm.emp_no = e.emp_no
WHERE dm.to_date >= CURDATE() AND e.gender = 'F';
#4
