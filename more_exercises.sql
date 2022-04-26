USE sakila;
#skipping to 
#4b
SELECT payment_id, amount, DATE(payment_date)
FROM payment
WHERE DATE(payment_date) IN ('2005-05-25','2005-05-27','2005-05-29');
#5A
SELECT *
FROM payment
WHERE payment_date BETWEEN '2005-05-25' AND '2005-05-27';
#8D
SELECT title, description, special_features, rental_duration
FROM film
WHERE length < 120 
	AND rental_duration BETWEEN 5 AND 8
ORDER BY length DESC
LIMIT 10;
#SAKILA begin complex problems
#1 - avg replacement cost of film, compare with rating
SELECT * FROM film LIMIT 2;
SELECT AVG(replacement_cost) FROM film; #19.98
SELECT rating,AVG(replacement_cost) AS avg_replacement_cost FROM film
GROUP BY rating
ORDER BY avg_replacement_cost;
#2 - films per genre
SELECT cat.name, COUNT(fc.film_id) as 'count'
FROM film_category as fc
	LEFT JOIN category as cat USING(category_id) #left in case there were uncategorized films
GROUP BY cat.category_id
ORDER BY count DESC;
#3 5 frequently rented films
SELECT * FROM rental;
SELECT f.title, COUNT(rental_id) AS total
FROM rental as r
	JOIN inventory as i USING(inventory_id) #get film id
    JOIN film AS f USING(film_id) #get film name
GROUP BY f.film_id #use film id, there may be 2+ inventory ids that map to a single film
ORDER BY total DESC
LIMIT 5;
	
#4 most profitable films (by gross revenue)
# payment.amount >> rental_id to rental.rental_id >> inventory_id to inventory.inventory_id >> film_id
SELECT f.title, SUM(p.amount) as total
FROM payment as p
	JOIN rental as r USING(rental_id)
    JOIN inventory as i USING(inventory_id)
    JOIN film as f USING(film_id)
GROUP BY f.film_id
ORDER BY total DESC;
-- 'TELEGRAPH VOYAGE','231.73'
-- 'WIFE TURN','223.69'

#5 Who is the best customer
SELECT c.first_name, c.last_name, SUM(p.amount) as total
FROM payment as p
	JOIN customer as c USING(customer_id)
GROUP BY c.customer_id
ORDER BY total DESC LIMIT 1;
-- 'KARL','SEAL','221.55'

#6 actors who have appeared in most films
SELECT a.first_name, a.last_name, COUNT(fa.film_id) AS film_number
FROM film_actor as fa
	JOIN actor as a USING(actor_id)
GROUP BY actor_id
ORDER BY film_number DESC;
-- 'GINA','DEGENERES','42'
-- 'WALTER','TORN','41'
-- 'MARY','KEITEL','40'

#7 Sales per store for each month in 2005
SELECT DATE_FORMAT(p.payment_date,'%Y-%m') AS 'month',store_id,SUM(amount)
FROM payment as p
	JOIN staff USING(staff_id)
    JOIN store USING(store_id)
WHERE YEAR(p.payment_date) = 2005
GROUP BY month, store_id #MONTH(p.payment_date)
ORDER BY month;
#trying different chain. payment >> rental_id >> inventory_id >> store_id
SELECT DATE_FORMAT(p.payment_date,'%Y-%m') AS 'month',store_id,SUM(amount)
FROM payment as p
	JOIN rental USING(rental_id)
    JOIN inventory USING(inventory_id)
WHERE YEAR(p.payment_date) = 2005
GROUP BY month, store_id 
ORDER BY month;
#USE v2.  First query assumes staff of sale doesn't switch stores, 
#.        second one assumes inventory of sale doesn't switch stores

#8 Find film title, customer name, cust phone and cust add for all outstanding DVDs
SELECT title, first_name, last_name, phone
FROM (SELECT inventory_id, customer_id FROM rental WHERE return_date IS NULL) AS t1
	JOIN customer USING(customer_id)
    JOIN inventory USING(inventory_id)
    JOIN film USING(film_id)
    JOIN address USING (address_id);

### EMPLOYEES DATABASE ###
USE employees;
#1 - how much do the current managers get paid vs average salary? 
SELECT dept_name, 
	ROUND(avg_salary) AS 'Department Average Salary', 
    CONCAT(e.first_name,' ',e.last_name) AS 'Department Manager', 
    ROUND(salary) AS 'Manager''s Salary',
    ROUND(salary-avg_salary) AS pay_difference
FROM (
	#Subquery w/ dept average
	SELECT dept_no, AVG(salary) AS avg_salary
	FROM salaries AS s
		JOIN dept_emp AS de USING(emp_no)
	WHERE s.to_date >= CURDATE() 
		AND de.to_date >= CURDATE()
	GROUP BY dept_no
    ) AS t_dep_avg_sal
	JOIN departments USING(dept_no)
    JOIN dept_manager as dm USING(dept_no)
    JOIN employees as e USING(emp_no)
    JOIN salaries as s USING(emp_no)
WHERE s.to_date >= CURDATE()
	AND dm.to_date >= CURDATE()
ORDER BY pay_difference;

### WORLD DATABASE ###
USE world;
#Languages spoken in Santa Monica - This is a terrible question. 
#Language is broken down by country, it is inappropriate to assume the same percentage of language spoken
# at the country level also applies to the city level
SELECT * FROM country LIMIT 5;
SELECT Language, percentage 
FROM countrylanguage as cl
	#JOIN country as c ON cl.countryCode = c.code
    JOIN city USING(CountryCode)
WHERE city.name = 'Santa Monica';
#How many different countries are in each region
SELECT Region, COUNT(Code) AS num_countries
FROM country
Group By Region
ORDER BY num_countries DESC;
#north america so low b/c they break into south, central and north america
SELECT DISTINCT Region FROM country WHERE Region LIKE "%America";
#What is the population for each region
SELECT Region, SUM(population) as population
FROM country
GROUP BY Region;
#What is the population for each region
SELECT Continent, SUM(population) as population
FROM country
GROUP BY Continent
ORDER BY population DESC;

#What is the average life expectancy globally
#The wrong way:
SELECT AVG(LifeExpectancy) as 'Global Life Expectancy'
FROM country; #66.486
#population adjusted
# (country pop * country life expectancy) / sum(pop)
SELECT SUM(val)/SUM(Population) as 'Global Life Expectancy'
FROM ( #grab table of population and pop*lifeExp per row
	SELECT Population, (Population * LifeExpectancy) AS val FROM country
    ) as T1; #66.806

#avg life expectancy per continent 
SELECT continent, AVG(LifeExpectancy) AS life_expectancy
FROM country
GROUP BY continent
ORDER BY life_expectancy;
#avg life expectancy per continent  - weighted
SELECT continent, (SUM(val)/SUM(Population)) AS life_expectancy
FROM (
	SELECT continent, Population, (Population * LifeExpectancy) AS val FROM country
    ) as T1
GROUP BY continent
ORDER BY life_expectancy;

#avg life expectancy per region - weighted
SELECT Region, (SUM(val)/SUM(Population)) AS life_expectancy
FROM (
	SELECT Region, Population, (Population * LifeExpectancy) AS val FROM country
    ) as T1
GROUP BY Region
ORDER BY life_expectancy;

#Bonus
#Countries with different local and official names
SELECT name, LocalName
FROM country 
WHERE name != LocalName;

#How many country have a life expectancy less than 40?
SELECT COUNT(*)
FROM country
WHERE LifeExpectancy < 40;

#What state is "Madison" located in?
SELECT District FROM city
WHERE Name = 'Madison';

#What region and country of the world is Cartagena located in?
SELECT Region, city.Name, country.Name
FROM city
	JOIN country ON city.CountryCode = country.Code
WHERE city.Name = 'Cartagena';

#What is the life expectancy in Cartagena
SELECT Region, city.Name, country.Name, LifeExpectancy
FROM city
	JOIN country ON city.CountryCode = country.Code
WHERE city.Name = 'Cartagena';

### PIZZA DATABASE ###
USE pizza;

# topping table contains an ID, name and price
SELECT * FROM toppings LIMIT 5;
SELECT * FROM pizza_toppings LIMIT 5;
#Pizza table has an ID, that you can take to pizza toppings, where you can find topping_Id per pizza 

#modifier table has an id, name and price
SELECT * FROM modifiers LIMIT 5;

#number of unique toppings?
SELECT COUNT(DISTINCT topping_id) FROM toppings; #9

#number of unique orders? - DISTINCT NEEDS TO GO INSIDE COUNT!!!
SELECT COUNT(DISTINCT order_id) FROM pizzas; #10K

#What Size Pizza is sold most?
SELECT size_name, COUNT(*) AS num_ordered
FROM pizzas
	JOIN sizes USING(size_id)
GROUP BY size_id
ORDER BY num_ordered DESC
LIMIT 1;

#How many pizzas have been sold in total
SELECT COUNT(*) FROM pizzas; #20,001

#What is the average number of pizzas per order?
SELECT AVG(num_pizzas) 
FROM (
	SELECT order_id, COUNT(pizza_id) as num_pizzas
    FROM pizzas 
    GROUP BY order_id
	) as T1;  #2.0001
