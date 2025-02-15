-- Creatiing Database
CREATE DATABASE Netflix;

-- Creating Table 

CREATE TABLE Netflix
( 
   
    show_id  VARCHAR(5),
    type     VARCHAR(10),
    title    VARCHAR(250),
    director VARCHAR(550),
    casts    VARCHAR(1050),
    country  VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);

select * from netflix

--1) Count the number of Movies vs Tv Shows

SELECT 
    DISTINCT TYPE,
    COUNT(TYPE) AS MOVIE_VS_TV_SHOWS  
FROM netflix
    GROUP BY TYPE 

--2) FIND THE MOST COMMON RATING FOR MOVIES AND TV SHOWS

SELECT
    TYPE,
    rating
FROM
(
    SELECT 
        TYPE,
        RATING,
        COUNT(*),
        RANK() OVER(PARTITION BY TYPE ORDER BY COUNT(*) DESC) AS RANKING
    FROM Netflix
    GROUP BY 1,2
) AS RANKING_TABLE
WHERE RANKING =1

--3) LIST ALL MOVIES RELEASED IN A SPECIFIC YEAR (eg:2020)

SELECT
    title,
    release_year
FROM netflix
WHERE
    type = 'Movie'
    AND
    release_year=2020


--4) FIND THE TOP 5 COUNTRTES WITH THE MOST CONTENT ON NETFLIX 

SELECT
    UNNEST(STRING_TO_ARRAY(country,',')) AS NEW_COUNTRY,
    COUNT(show_id) AS TOTAL_CONTENT
FROM netflix
WHERE COUNTRY IS NOT NULL
    GROUP BY NEW_COUNTRY
    ORDER BY TOTAL_CONTENT DESC
    LIMIT 5

--5) IDENTIFY THE LONGEST MOVIE

SELECT
    title,
    duration
FROM netflix
WHERE 
    TYPE='Movie'
    AND
    duration= (select max(duration) from netflix)

--6) FIND CONTENT ADDET IN THE LAST 5 YEARS

SELECT 
    EXTRACT(YEAR FROM TO_DATE(date_added,'Month DD, YYYY')) AS YEAR,
    title
FROM 
    netflix
WHERE 
    TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5YEARS'

--7) FIND ALL MOVIES/TV SHOWS BY DIRECTOR 'Rajiv Chilaka'

SELECT
    director,
    type,
    title
FROM
    netflix
WHERE
    director LIKE '%Rajiv Chilaka%'

--8) LIST ALL TV SHOWS WITH MORE THAN 5 SEASONS

SELECT
    type,
    title,
    duration
FROM
    netflix
WHERE
    type= 'TV Show'
    AND
    SPLIT_PART(duration,' ',1)::NUMERIC > 5

--9) COUNT THE NUMBER OF CONTENTS ITEMS IN EACH GENRE

SELECT 
   UNNEST(STRING_TO_ARRAY(listed_in,',')) AS GENRE,
   COUNT(show_id) AS GENERE_COUNT
FROM
    netflix
    GROUP BY GENRE
    ORDER BY GENERE_COUNT DESC

/*10) FIND EACH YEAR AND THE AVERAGE NUMBERS OF CONTENT RELEASE BY INDIA ON NETFLIX.
      RETURN TOP 5 YEAR WITH HIGHEST AVG CONTENT RELEASE */

SELECT
    EXTRACT(YEAR FROM TO_DATE(date_added,'Month DD,YYYY')) AS YEAR_COLUMN,
    COUNT(show_id),
   ROUND(COUNT(show_id)::NUMERIC/(SELECT COUNT(show_id) FROM netflix WHERE COUNTRY = 'India')::NUMERIC * 100)AS AVG_YEAR
FROM
    netflix
WHERE
    COUNTRY = 'India'
    GROUP BY 1 
    ORDER BY AVG_YEAR DESC 
    LIMIT 5


--11) LIST ALL MOVIES THAT ARE DOCUMENTRIES

SELECT 
    type,
    title,
   UNNEST (STRING_TO_ARRAY(listed_in,',')) AS DOCUMENTRIES
FROM 
    NETFLIX
WHERE
    listed_in = 'Documentaries'

--12)FIND ALL CONTENT WITHOUT A DIRECTOR

SELECT 
    *,
    director
FROM  
    netflix
WHERE
    director IS NULL 

--13) FIND HOW MANY MOVIES ACTOR 'Salman Khan' APPEREAD IN LAST 10 YEARS

SELECT
    show_id,
    type,
    title,
    date_added
FROM
    netflix
WHERE
    casts ilike '%Salman Khan%'
    AND
    TO_DATE(date_added,'Month DD,YYYY')>= CURRENT_DATE - INTERVAL '10YEARS' 

--14) FIND THE TOP 10 ACTORS WHO HAVE APPEREAD IN THE HIGHEST NUMBER OF MOVIES PRODUCED IN INDIA 

SELECT 
    type,
    UNNEST(STRING_TO_ARRAY(casts,',')) AS ACTOR,
    COUNT(*) AS TOP_10
FROM
    netflix
WHERE
    type = 'Movie'
    AND
    country='India'
    GROUP BY ACTOR,type
    ORDER BY TOP_10 DESC
    LIMIT 10

/*15) CATEGORIZE THE CONTENT BASED ON THE PRESENCE OF THE KEYWORDS 'Kill' AND 'Violence' in 
      the description FIELD. LABEL CONTENT CONTAINING THESE KEYWORDS AS 'Bad' AND ALL OTHER CONTENT AS 'God'.
      COUNT HOW MANY TIMES FALL INTO EACH CATEGORY */

SELECT
    categories,
    COUNT(*) AS TOTAL_COUNT
FROM 
(
SELECT
    type,
    title,
    CASE
    WHEN
        description ILIKE '%Kill%'
        OR 
        description ILIKE '%Violence%' 
    THEN 
        'Bad_Content'
    ELSE
        'Good_Content'
    END categories
FROM
    netflix
) AS CAT_TABLE
    GROUP BY 1

