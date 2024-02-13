SELECT *
FROM distributors
SELECT * 
FROM rating
SELECT * 
FROM revenue
SELECT * 
FROM specs

--1. Give the name, release year, and worldwide gross of the lowest grossing movie.
SELECT specs.film_title AS title , specs.release_year, revenue.worldwide_gross
FROM specs
INNER JOIN revenue
ON specs.movie_id = revenue.movie_id
GROUP BY specs.film_title, specs.release_year, revenue.worldwide_gross
ORDER BY revenue.worldwide_gross
LIMIT 10;
--Answer: Semi-Tough	1977	37187139

--2.What year has the highest average imdb rating?

SELECT specs.release_year, AVG(rating.imdb_rating) 
FROM specs
INNER JOIN rating
ON specs.movie_id = rating.movie_id
GROUP BY specs.release_year, rating.imdb_rating
ORDER BY rating.imdb_rating DESC;
--Answer: 2008 with 9.0
 
--3.What is the highest grossing G-rated movie? Which company distributed it?
SELECT specs.film_title AS title,
	   specs.mpaa_rating,
	   distributors.company_name AS company,
	   revenue.worldwide_gross
FROM specs
INNER JOIN revenue
ON specs.movie_id = revenue.movie_id
INNER JOIN distributors
ON specs.domestic_distributor_id = distributors.distributor_id
WHERE specs.mpaa_rating IN ('G')
ORDER BY revenue.worldwide_gross DESC
--Answer: The highest grossing movie is Toy Story 4 from Walt Disney

--4.Write a query that returns, for each distributor in the distributors table, the distributor name and the number of movies associated with that distributor in the movies table. Your result set should include all of the distributors, whether or not they have any movies in the movies table.
SELECT distributors.distributor_id, 
	   COUNT(specs.domestic_distributor_id)
FROM distributors
LEFT JOIN specs
ON distributors.distributor_id = specs.domestic_distributor_id
GROUP BY distributors.distributor_id
ORDER BY COUNT(specs.domestic_distributor_id) DESC
--Answer: ^^

--5.Write a query that returns the five distributors with the highest average movie budget.
SELECT distributors.distributor_id,
	   AVG(revenue.film_budget) AS avg_film_budget
FROM specs
INNER JOIN revenue
ON specs.movie_id = revenue.movie_id
INNER JOIN distributors
ON specs.domestic_distributor_id = distributors.distributor_id
GROUP BY distributors.distributor_id
ORDER BY AVG(revenue.film_budget) DESC
LIMIT 5;
--Answer: ^^

--6. How many movies in the dataset are distributed by a company which is not headquartered in California? Which of these movies has the highest imdb rating?

SELECT specs.movie_id,
	   specs.film_title,
	   distributors.headquarters,
	   rating.imdb_rating
FROM specs
INNER JOIN distributors
ON specs.domestic_distributor_id = distributors.distributor_id
INNER JOIN rating
ON specs.movie_id = rating.movie_id
WHERE distributors.headquarters NOT iLIKE ('%CA')
GROUP BY specs.movie_id, distributors.headquarters, specs.film_title, rating.imdb_rating
ORDER BY rating.imdb_rating DESC;
--Answer: Dirty Dancing

--7. Which have a higher average rating, movies which are over two hours long or movies which are under two hours?

SELECT length_in_min, ROUND(avg(imdb_rating),2), 
CASE
	WHEN length_in_min >= 120 THEN '>2 Hours'
	ELSE '<2 Hours'
END AS length_of_movie, ROUND(avg(imdb_rating), 2) AS avg_rating
FROM specs
INNER JOIN rating
USING (movie_id)
GROUP BY specs.length_in_min
ORDER BY avg_rating DESC;



















