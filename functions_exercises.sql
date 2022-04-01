USE employees; #DB/Schema
SELECT * FROM employees;
#2 & 3
SELECT CONCAT(first_name, ' ', last_name) full_name
FROM employees
WHERE last_name LIKE 'E%E';
#3
SELECT UPPER(CONCAT(first_name, ' ', last_name)) full_name
FROM employees
WHERE last_name LIKE 'E%E';
#4
SELECT emp_no, DATEDIFF(CURDATE(), hire_date) employee_tenure_days
FROM employees
WHERE hire_date LIKE '199%'
	AND birth_date LIKE '%12-25';
#Variation on 4 - Trying to make more user friendly
SELECT emp_no, SUBSTR(FROM_DAYS(DATEDIFF(CURDATE(), hire_date)),3) tenure_YY_MM_DD 
FROM employees
WHERE hire_date LIKE '199%'
	AND birth_date LIKE '%12-25';
#Not great, but could break this out into 3 different columns.  
#It also would be better to dynamically remove the zeros from any years or months, 
    #so that we don't force a storage of two digits.  

#5
SELECT MIN(salary) AS min_salary, MAX(salary) AS max_salary 
FROM salaries
WHERE to_date >= CURDATE();

#6
SELECT LOWER(CONCAT(
	SUBSTR(first_name,1,1),
    SUBSTR(last_name,1,4), #how does it handle short last names
    '_',
    -- MONTH(birth_date), #month() can return a single digit - no bueno
    DATE_FORMAT(birth_date,'%m'),
    SUBSTR(YEAR(birth_date),3)
    )) AS username,
    first_name,
    last_name,
    birth_date
FROM employees;
#Shouldn't use BD in username, also should check if unused to make sure it is unique