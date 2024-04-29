use netflix_data;
show tables;
SELECT * 
FROM netflix_titles;

-- Dataset Overview
SELECT * 
FROM netflix_titles;

-- unique data
SELECT DISTINCT(type)
FROM netflix_titles;

-- year range
SELECT DISTINCT(release_year)
FROM netflix_titles
ORDER BY 1 DESC;

-- number of rows
SELECT COUNT(*) AS total_rows
FROM netflix_titles;

-- Drammatic Genre
SELECT COUNT(title) AS Drama
FROM netflix_titles
WHERE listed_in LIKE '%Drama%';

-- FAMILY_FRIENDLY

SELECT COUNT(title) AS family_friendly
FROM netflix_titles
WHERE listed_in LIKE '%family%';

-- Horror Genre
SELECT COUNT(title) AS Horror
FROM netflix_titles
WHERE listed_in LIKE '%Hor%';

-- Released movies per Year
SELECT release_year AS year, COUNT(1) AS COUNT
FROM netflix_titles
GROUP BY release_year
ORDER BY 1 Desc;

-- How many tv shows/movies they have for each year
SELECT release_year , COUNT(title) AS 'movies/TV_shows'
FROM netflix_titles
GROUP BY release_year
ORDER BY release_year Desc;

-- Movies per location
SELECT country, COUNT(title) AS movies
FROM netflix_titles
WHERE country IN ('united states','japan','india') AND country IS NOT NULL
GROUP BY country
ORDER BY 2 Desc;

-- Movies which duration is equal or above 100 min of length in United states, japan, india

SELECT title, duration,Country
FROM netflix_titles
WHERE title IN (
							SELECT title
							FROM netflix_titles
							WHERE country in ('United States', 'Japan', 'India') 
							AND type in ('Movie')
							AND duration LIKE '1%%'
		        )
	ORDER BY 2 Desc;
                
-- CTE for movie Type

WITH CTE_Movies AS
(
SELECT title, duration ,country ,release_year, listed_in AS Genre
FROM netflix_titles
WHERE title IN (
				SELECT title
				FROM netflix_titles
				WHERE country in ('United States', 'Japan', 'India') 
				AND type in ('Movie')
				AND duration LIKE '1%%'
				)
) 
SELECT COUNT(CTE_Movies.title) AS HorrorCount, CTE_Movies.country
FROM CTE_Movies
WHERE CTE_Movies.title IN (
                           SELECT CTE_Movies.title
						   FROM CTE_Movies
                           WHERE Genre LIKE 'Horr%'
                           AND duration LIKE '1%%'
)
GROUP BY country
ORDER BY 1 DESC;

-- TEMP TABLE for TV shows

DROP TABLE IF EXISTS TV_SHOWS;
CREATE TABLE TV_SHOWS
(
Title   VARCHAR(255),
Director VARCHAR(255),
Country VARCHAR(255),
Year INT,
Duration VARCHAR(255),
Rating VARCHAR(255)
);

INSERT INTO TV_SHOWS
SELECT title, director, country, release_year,duration , rating
FROM netflix_titles
WHERE type='TV show';

SELECT * FROM  TV_SHOWS;

-- Ratings per year
SELECT rating,COUNT(rating) as totalratings, year
FROM TV_SHOWS
GROUP BY year, Rating
ORDER BY 3 DESC;

-- Released per year/country
SELECT COUNT(title), country, year
FROM TV_SHOWS
WHERE country IS NOT NULL
AND COUNTRY IN ('united states')
GROUP BY country , year
ORDER BY 3 Desc;


