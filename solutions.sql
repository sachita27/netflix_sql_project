DROP TABLE IF EXISTS NETFLIX;
CREATE TABLE NETFLIX
(show_id VARCHAR(6),
type	 VARCHAR(10),
title	 VARCHAR(150),
director VARCHAR(208),
casts	 VARCHAR(1000),
country	 VARCHAR(150),
date_added	VARCHAR(50),
release_year	INT,
rating	    VARCHAR(10),
duration	VARCHAR(15),
listed_in	VARCHAR(100),
description VARCHAR(250)
);


--Business Problems

--1. Count the number of Movies vs TV shows

SELECT TYPE, COUNT(*) AS total_content
FROM NETFLIX
GROUP BY TYPE

--2. Find the most common rating for movies and TV Shows

SELECT TYPE, RATING 
FROM
(SELECT TYPE, 
RATING, 
COUNT(*), 
RANK() OVER(PARTITION BY TYPE ORDER BY COUNT(*) DESC) AS RANKING
FROM NETFLIX
GROUP BY 1,2) AS T1
WHERE RANKING = 1
---------------------------------------------------------------------------------------------
WITH MOST_RATED AS
(SELECT TYPE, 
RATING, 
COUNT(*), 
RANK() OVER(PARTITION BY TYPE ORDER BY COUNT(*) DESC) AS RANKING
FROM NETFLIX
GROUP BY 1,2)

SELECT TYPE, RATING
FROM MOST_RATED
WHERE RANKING = 1

--3. List all movies released in a specific year 

SELECT * FROM NETFLIX
WHERE TYPE = 'Movie' AND RELEASE_YEAR = 2020

--4. Find the top 5 countries with the most content on Netflix

SELECT UNNEST(STRING_TO_ARRAY(COUNTRY,',')) AS new_country,
COUNT(*) AS total_content
FROM NETFLIX
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

--5. Identify the longest movie

SELECT * FROM NETFLIX
WHERE TYPE = 'Movie' AND
DURATION = (SELECT MAX(DURATION) FROM NETFLIX);

--6. Find content added in the last 5 years

SELECT * FROM NETFLIX
WHERE TO_DATE(DATE_ADDED, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years'

--7. Find all the movies/TV Shows by director 'Rajiv Chilaka'

SELECT * FROM NETFLIX
WHERE DIRECTOR ILIKE '%Rajiv Chilaka%'

--8. List all TV Shows with more than 5 seasons

SELECT * FROM NETFLIX 
WHERE TYPE = 'TV Show' 
AND SPLIT_PART(DURATION, ' ', 1)::numeric > 5 

--9. Count the number of content items in each genre

SELECT UNNEST(STRING_TO_ARRAY(LISTED_IN, ',')) AS GENRE,
COUNT(SHOW_ID) AS TOTAL_CONTENT
FROM NETFLIX
GROUP BY 1

/*10. Find each year and the average numbers of content release in India on netflix
Return top 5 year with highest avg content release*/

SELECT EXTRACT(YEAR FROM TO_DATE(DATE_ADDED, 'Month DD, YYYY')) AS YEAR,
COUNT(*) AS YEARLY_CONTENT,
ROUND(COUNT(*)::NUMERIC/(SELECT COUNT(*) FROM NETFLIX WHERE COUNTRY = 'India')::NUMERIC * 100
,2) AS AVG_CONTENT_PER_YEAR
FROM NETFLIX
WHERE COUNTRY = 'India'
GROUP BY 1
ORDER BY 3 DESC
LIMIT 5

--11. List all movies that are documentaries
SELECT * 
FROM NETFLIX
WHERE LISTED_IN ILIKE '%documentaries%'

--12. Find all content without a director

SELECT *
FROM NETFLIX
WHERE DIRECTOR IS NULL

--13. Find how many movies actor 'Salman Khan' appeared in last 10 years


SELECT * FROM NETFLIX 
WHERE CASTS ILIKE '%Salman Khan%'
AND RELEASE_YEAR >= EXTRACT(YEAR FROM CURRENT_DATE) - 10

---------------------------------------------------------------------------------------

SELECT * FROM NETFLIX 
WHERE CASTS ILIKE '%Salman Khan%'
AND RELEASE_YEAR >= EXTRACT(YEAR FROM CURRENT_DATE - INTERVAL '10 YEARS')

--14. Find the top 10 actors who have appeared in the highest number of movies produced in India

SELECT UNNEST(STRING_TO_ARRAY(CASTS, ',')) AS ACTORS,
COUNT(*) AS TOTAL_CONTENT
FROM NETFLIX 
WHERE TYPE = 'Movie' AND COUNTRY ILIKE '%India%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10

/*15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field.
Label content containing these keywords as 'Bad' and all other content as 'Good'. 
Count how many items fall into each category*/

SELECT
CASE WHEN DESCRIPTION ILIKE '%Kill%' OR DESCRIPTION ILIKE '%violence%' THEN 'BAD'
ELSE 'GOOD'
END AS CATEGORY,
COUNT(*) AS TOTAL_CONTENT
FROM NETFLIX
GROUP BY 1

