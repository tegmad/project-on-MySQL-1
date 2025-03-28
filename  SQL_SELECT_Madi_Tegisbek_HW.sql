-- Madi Tegisbek 

-- PART 1.
  -- TASK 1. All animation movies released between 2017 and 2019 with rate more than 1, alphabetical
SELECT film.title, film.release_year
FROM film 
LEFT JOIN
 film_category on film_category.film_id = film.film_id
LEFT JOIN
 category on film_category.category_id = category.category_id 
WHERE 
(film.release_year BETWEEN 2017 AND 2019 ) AND film.rental_rate > 1
ORDER BY 
  film.title ;
 
  -- TASK 2.The revenue earned by each rental store after March 2017 (columns: address and address2 – as one column, revenue) 
SELECT 
    CONCAT(address.address, ' ', COALESCE(address.address2, '')) AS full_address,
    SUM(payment.amount) AS revenue
FROM payment 
JOIN rental  ON payment.rental_id = rental.rental_id
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN store ON inventory.store_id = store.store_id
JOIN address ON store.address_id = address.address_id
WHERE payment.payment_date > '2017-03-31'
GROUP BY full_address
ORDER BY revenue DESC;

  -- TASK 3. NAME ACTORS And their Apperiences in films
SELECT
 actor.first_name, actor.last_name,
 COUNT(*) as how_many_time_played
FROM film
LEFT JOIN film_actor on film_actor.film_id = film.film_id
LEFT JOIN actor on actor.actor_id = film_actor.actor_id
group by 
  actor.actor_id
ORDER BY
 how_many_time_played DESC;
 
  -- TASK 4.NUMBER OF DRAMA, TRAVEL, DOCUMENTARY by per year.
WITH RECURSIVE years AS (
    SELECT 1990 AS y
    UNION ALL 
    SELECT y + 1 FROM years
    WHERE y < 2025
),
movies AS (
    SELECT
        film.release_year,
        SUM(CASE WHEN category.name = 'Drama' THEN 1 ELSE 0 END) AS number_of_drama_films,
        SUM(CASE WHEN category.name = 'Documentary' THEN 1 ELSE 0 END) AS number_of_documentary,
        SUM(CASE WHEN category.name = 'Travel' THEN 1 ELSE 0 END) AS number_of_travel
    FROM film
    JOIN film_category ON film_category.film_id = film.film_id
    JOIN category ON film_category.category_id = category.category_id
    WHERE category.name IN ('Drama', 'Documentary', 'Travel')
    GROUP BY film.release_year
)
SELECT
    years.y AS release_year,
    COALESCE(movies.number_of_drama_films, 0) AS number_of_drama_films,
    COALESCE(movies.number_of_documentary, 0) AS number_of_documentary,
    COALESCE(movies.number_of_travel, 0) AS number_of_travel
FROM years
LEFT JOIN movies ON movies.release_year = years.y;
 

-- PART 2.

 -- TASK 1. Which three employees generated the most revenue in 2017? THERE ARE SOME ASSUMPTIONS.
SELECT 
    staff.staff_id,
    staff.first_name, 
	staff.last_name,
    staff.store_id AS store_worked,
    SUM(payment.amount) AS total_revenue
FROM payment 
JOIN staff  ON payment.staff_id = staff.staff_id
WHERE EXTRACT(YEAR FROM payment.payment_date) = 2017
GROUP BY staff.staff_id, staff.first_name, staff.last_name, staff.store_id
ORDER BY total_revenue DESC
LIMIT 3;



  -- TASK 2. Which 5 movies were rented more than others (number of rentals).
SELECT 
    film.title, 
    COUNT(rental.rental_id) AS rental_count,
    CASE
        WHEN film.rating = 'G' THEN '0+'
        WHEN film.rating = 'PG' THEN '6+'
        WHEN film.rating = 'PG-13' THEN '13+'
        WHEN film.rating = 'R' THEN '17+'
        WHEN film.rating = 'NC-17' THEN '18+'
    END AS expected_age
FROM film
LEFT JOIN inventory ON film.film_id = inventory.film_id
LEFT JOIN rental ON rental.inventory_id = inventory.inventory_id
GROUP BY film.title, film.rating
ORDER BY rental_count DESC
LIMIT 5;

 

-- Part 3. Which actors/actresses didn't act for a longer period of time than the others? 
  -- V1: gap between the latest release_year and current year per each actor;
WITH latest AS (	
	SELECT
	  actor.first_name as first_name,
	  actor.last_name as last_name,
	  MAX(film.release_year) as last_time
	FROM film 
	 JOIN film_actor ON film_actor.film_id = film.film_id
	 JOIN actor ON actor.actor_id = film_actor.actor_id
	GROUP BY
	 actor.actor_id 
)
SELECT 
 first_name,
 last_name,
 EXTRACT(YEAR FROM CURRENT_DATE) - last_time as gap
FROM 
 latest
ORDER BY
 gap desc;
























 

 

 
 
 
 
 