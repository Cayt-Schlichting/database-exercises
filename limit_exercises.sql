USE employees;
#2
SELECT DISTINCT last_name FROM employees 
ORDER BY last_name DESC
LIMIT 10;
-- 'Zykh'
-- 'Zyda'
-- 'Zwicker'
-- 'Zweizig'
-- 'Zumaque'
-- 'Zultner'
-- 'Zucker'
-- 'Zuberek'
-- 'Zschoche'
-- 'Zongker'

#3
SELECT first_name, last_name FROM employees
WHERE hire_date LIKE '199%'
	AND birth_date LIKE '%12-25'
ORDER BY hire_date #asc/oldest first
LIMIT 5;
/*
Alselm Cappello
Utz Mandell
Bouchung Schreiter
Baocai Kushner
Petter Stroustrup
*/

#4
SELECT first_name, last_name FROM employees
WHERE hire_date LIKE '199%'
	AND birth_date LIKE '%12-25'
ORDER BY hire_date #asc/oldest first
LIMIT 5 OFFSET 45; #NOTE: This makes it start on result 46
/*
OFFSET = (#OF PAGES TO SKIP) * (LIMIT [AKA number of results per page])
Since we are saying the limit is 5 per page, and we want to skip 9 pages,
then the total number of results to skip is 5*9 or 45 entries.  

10th page:
Pranay Narwekar
Marjo Farrow
Ennio Karcich
Dines Lubachevsky
Ipke Fontan
*/
