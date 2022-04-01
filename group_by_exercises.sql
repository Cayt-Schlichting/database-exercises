USE employees;
#2
SELECT DISTINCT title from titles; # 7 unique titles
#3
SELECT last_name FROM employees #have to select last_name, can have more since other columns aren't dependent on it. 
WHERE last_name LIKE 'E%E'
GROUP BY last_name;
#4
SELECT first_name, last_name
FROM employees
WHERE last_name LIKE 'E%E'
GROUP BY first_name, last_name;
#5
SELECT last_name
FROM employees
WHERE last_name LIKE '%Q%' AND last_name NOT LIKE '%qu%'
GROUP BY last_name;
-- 'Chleq'
-- 'Lindqvist'
-- 'Qiwen'

#6
SELECT last_name,COUNT(last_name)
FROM employees
WHERE last_name LIKE '%Q%' AND last_name NOT LIKE '%qu%'
GROUP BY last_name;
-- 'Chleq','189'
-- 'Lindqvist','190'
-- 'Qiwen','168'

#7
SELECT gender, COUNT(*)
FROM employees
WHERE first_name IN ('Irena','Vidya','Maya')
GROUP BY gender;
-- 'M','441'
-- 'F','268'

#8 
SELECT 
	LOWER(CONCAT(
		SUBSTR(first_name,1,1),
		SUBSTR(last_name,1,4), #how does it handle short last names
		'_',
		DATE_FORMAT(birth_date,'%m'),
		SUBSTR(YEAR(birth_date),3)
	)) AS username,
    COUNT(*) AS num_username
FROM employees
GROUP BY username
HAVING num_username >1; #yes there are duplicates

#FANCY 8 - nested query.  get simple SUM from first table
SELECT SUM(num_username) AS num_duplicates
FROM (
	SELECT 
		LOWER(CONCAT(
			SUBSTR(first_name,1,1),
			SUBSTR(last_name,1,4), #how does it handle short last names
			'_',
			DATE_FORMAT(birth_date,'%m'),
			SUBSTR(YEAR(birth_date),3)
		)) AS username,
		COUNT(*) AS num_username
	FROM employees
	GROUP BY username
	HAVING num_username > 1 #Can alternatively put this in second query as a WHERE
) AS T1;

#9
#A) average salary per employee. -technically just the average of all salaries
SELECT emp_no, CONCAT('$',FORMAT(AVG(salary), 2, 'en-US')) AS avg_salary #playing with formating
FROM salaries
GROUP BY emp_no;
#B) how many current employes work in each dept
SELECT dept_no, COUNT(*) as num_emps
FROM (
	SELECT *
	FROM dept_emp
	WHERE to_date >= CURDATE()
    ) AS T_current_only #Get only current emp/dep relationships
GROUP BY dept_no; #summarize by dept and count.
#C/D/E/F) number of different salaries per employee, min, max, stddev
SELECT emp_no, 
	COUNT(*) AS num_salaries, #doesn't actually check that they are different, just that there are multiple entries
	CONCAT('$',FORMAT(MIN(salary)), 2, 'EN-US') AS min_salary
    CONCAT('$',FORMAT(MAX(salary)), 2, 'EN-US') AS max_salary
    CONCAT('$',FORMAT(STDEV(salary)), 2, 'EN-US') AS stdev_salary
FROM salaries
GROUP BY emp_no;
#G) max salary for employee when it is > 150k
SELECT emp_no, MAX(salary) AS max_salary
FROM salaries
GROUP BY emp_no
HAVING max_salary >= 150000; # > probably wasn't going to work well if I already had it formatted.
#H) avg salary when avg is between 80 & 90 k
SELECT emp_no, AVG(salary) AS avg_salary #playing with formating
FROM salaries
GROUP BY emp_no
HAVING avg_salary >= 80000 AND avg_salary <90000; #Chose to make this inclusive of 80k and exclusive of 90k
