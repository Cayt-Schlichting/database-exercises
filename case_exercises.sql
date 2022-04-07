USE employees;
#1 - get employee info with new flag 'is_current_employee'
SELECT DISTINCT emp_no FROM dept_emp; #300024
SELECT emp_no FROM dept_emp; #331603
#Not 1-1 in dept_emp.  Therefore we probalby want to pull the most recent department.
SELECT emp_no, dept_no, hire_date, to_date, 
	IF(to_date >= CURDATE(),1,0) AS is_current_employee
FROM (
	#Subquery to find most recent department per employee
	SELECT emp_no, dept_no, from_date, to_date, 
		row_number() OVER (partition by emp_no ORDER BY to_date DESC) as most_recent
	FROM dept_emp
    ) AS t1
    JOIN employees USING(emp_no)
    WHERE most_recent=1;
#1- version 2 - If you want a null end date for current employees
SELECT emp_no, dept_no, hire_date,
    CASE WHEN to_date >= CURDATE() THEN NULL ELSE to_date
    END AS end_date,	
    CASE WHEN to_date >= CURDATE() THEN 1 ELSE 0
    END AS is_current_employee
FROM (
	#Subquery to find most recent department per employee
	SELECT emp_no, dept_no, from_date, to_date, 
		row_number() OVER (partition by emp_no ORDER BY to_date DESC)
	FROM dept_emp
    ) AS t1
    JOIN employees USING(emp_no);
    
#2 - emp names, alpha group (a-h, i-q, r-z) depending on first letter of last name
SELECT first_name, last_name, 
	CASE  #first character of last name
		WHEN LEFT(last_name,1) BETWEEN 'a' AND 'h' THEN 'A-H' #Inclusive, also finds uppercase in lowercase range
        WHEN LEFT(last_name,1) BETWEEN 'i' AND 'q' THEN 'I-Q'
        WHEN LEFT(last_name,1) BETWEEN 'r' AND 'z' THEN 'R-Z'
        ELSE 'Other' #If first character not in english alphabet (accent, special character)
	END AS alpha_group
FROM employees;

#3 How many employees were born in each decade
SELECT 
	COUNT(CASE WHEN YEAR(birth_date) BETWEEN 1950 AND 1959 THEN '1950s' ELSE NULL END) AS '1950s',
    COUNT(CASE WHEN YEAR(birth_date) BETWEEN 1960 AND 1969 THEN '1960s' ELSE NULL END) AS '1960s'
FROM employees;
#3 - v2 - Better because it will choose the appropriate decades based off the data set
SELECT
	CONCAT(LEFT(birth_date,3),'0') as decade,
    COUNT(*) 
FROM employees
GROUP BY decade;

#4 Current avg salary for departments
SELECT
	#For each salary, assign it to a column of corresponding department group >> then take the average of that column
	ROUND(AVG(CASE WHEN dept_name = 'research' OR dept_name = 'development' THEN salary ELSE NULL END)) AS 'R&D',
    ROUND(AVG(CASE WHEN dept_name = 'sales' OR dept_name = 'marketing' THEN salary ELSE NULL END)) AS 'Sales & Marketing',
    ROUND(AVG(CASE WHEN dept_name = 'production' OR dept_name = 'quality management' THEN salary ELSE NULL END)) AS 'Prod & QM',
    ROUND(AVG(CASE WHEN dept_name = 'finance' OR dept_name = 'human resources' THEN salary ELSE NULL END)) AS 'Finance & HR',
    ROUND(AVG(CASE WHEN dept_name = 'customer service' THEN salary ELSE NULL END)) AS 'Customer Service'
FROM salaries
	JOIN dept_emp AS de USING(emp_no)
    JOIN departments USING(dept_no)
WHERE salaries.to_date >= CURDATE() AND de.to_date >= CURDATE();
#4 - v2 - how the instructor did it
SELECT
	CASE 
		WHEN dept_name = 'research' OR dept_name = 'development' THEN 'R&D'
		WHEN dept_name = 'sales' OR dept_name = 'marketing' THEN 'Sales & Marketing'
		WHEN dept_name = 'production' OR dept_name = 'quality management' THEN 'Prod & QM'
		WHEN dept_name = 'finance' OR dept_name = 'human resources' THEN 'Finance & HR'
		WHEN dept_name = 'customer service' THEN  'Customer Service'
	END AS 'Department_Group', #Assigns each row to a department group
    ROUND(AVG(salary)) AS Avg_Salary #Now get the average for each group >> will need a group by
FROM salaries
	JOIN dept_emp AS de USING(emp_no)
    JOIN departments USING(dept_no)
WHERE salaries.to_date >= CURDATE() AND de.to_date >= CURDATE()
GROUP BY Department_Group;

/* If I wanted to make #3 a function....
LOGIC:
	1) Pass in a date set.
    2) Determine min and max
    3) Grab first decade >> count employees
    4) increment to next decade and repeat
    5) terminate when after completing the max decade

REF: 
https://www.sqlshack.com/learn-sql-intro-to-sql-server-loops/
https://dev.mysql.com/doc/refman/8.0/en/declare-handler.html
*/
####### FINISH IF TIME #####
-- DECLARE @decade INTEGER;
-- SET @decade = LEFT(YEAR(MIN(birth_date)),3);
