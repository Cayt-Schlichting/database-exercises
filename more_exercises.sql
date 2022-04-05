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
#TEST THIS QUERY TOMORROW
SELECT title, first_name, last_name, phone
FROM (SELECT inventory_id, customer_id FROM rental WHERE return_date IS NULL)
	JOIN customer USING(customer_id)
    JOIN inventory USING(inventory_id)
    JOIN film USING(film_id);