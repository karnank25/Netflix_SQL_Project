# 📊 Netflix Data Analysis

## 📌 Overview
This project involves analyzing a Netflix dataset using SQL queries to extract insights related to movies, TV shows, ratings, genres, and actors.

## 📂 Database & Table Structure 
**Database:** `Netflix`
**Table:** `Netflix`

### 📌 Table Columns:
- `show_id` (VARCHAR) – Unique ID for each show
- `type` (VARCHAR) – Movie or TV Show
- `title` (VARCHAR) – Title of the content
- `director` (VARCHAR) – Director of the content
- `casts` (VARCHAR) – Actors in the content
- `country` (VARCHAR) – Country of production
- `date_added` (VARCHAR) – Date when added to Netflix
- `release_year` (INT) – Year of release
- `rating` (VARCHAR) – Content rating
- `duration` (VARCHAR) – Duration of content
- `listed_in` (VARCHAR) – Genre of the content
- `description` (VARCHAR) – Short description of content

## 🔍 Key SQL Queries & Insights

### 🎬 1) Count Movies vs TV Shows
Finds how many movies and TV shows exist in the dataset.
```sql
SELECT 
    type,
    COUNT(type) AS MOVIE_VS_TV_SHOWS  
FROM netflix
GROUP BY type;
```
### ⭐ 2) Most Common Ratings
Identifies the most frequent content ratings.
```sql
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
WHERE RANKING =1;
```
### 📅 3) Movies Released in a Specific Year
Filters movies based on a given release year (e.g., 2020).
```sql
SELECT
    title,
    release_year
FROM netflix
WHERE
    type = 'Movie'
    AND
    release_year=2020;
```
### 🌎 4) Top 5 Countries with Most Content
Lists the top 5 countries producing the most Netflix content.
```sql
SELECT
    UNNEST(STRING_TO_ARRAY(country,',')) AS NEW_COUNTRY,
    COUNT(show_id) AS TOTAL_CONTENT
FROM netflix
WHERE COUNTRY IS NOT NULL
GROUP BY NEW_COUNTRY
ORDER BY TOTAL_CONTENT DESC
LIMIT 5;
```
### ⏳ 5) Longest Movie
Finds the movie with the longest duration.
```sql
SELECT
    title,
    duration
FROM netflix
WHERE 
    TYPE='Movie'
    AND
    duration= (SELECT MAX(duration) FROM netflix);
```
### 🆕 6) Content Added in the Last 5 Years
Filters content added in the last 5 years.
```sql
SELECT 
    EXTRACT(YEAR FROM TO_DATE(date_added,'Month DD, YYYY')) AS YEAR,
    title
FROM 
    netflix
WHERE 
    TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 YEARS';
```
### 🎥 7) All Movies/TV Shows by Director 'Rajiv Chilaka'
Lists all content directed by Rajiv Chilaka.
```sql
SELECT
    director,
    type,
    title
FROM
    netflix
WHERE
    director LIKE '%Rajiv Chilaka%';
```
### 📺 8) TV Shows with More Than 5 Seasons
Finds TV Shows having more than 5 seasons.
```sql
SELECT
    type,
    title,
    duration
FROM
    netflix
WHERE
    type= 'TV Show'
    AND
    SPLIT_PART(duration,' ',1)::NUMERIC > 5;
```
### 🎭 9) Content Count by Genre
Counts how many shows/movies exist per genre.
```sql
SELECT 
   UNNEST(STRING_TO_ARRAY(listed_in,',')) AS GENRE,
   COUNT(show_id) AS GENRE_COUNT
FROM
    netflix
GROUP BY GENRE
ORDER BY GENRE_COUNT DESC;
```
### 📊 10) Top 5 Years with Highest Content Release in India
Analyzes the average number of content releases per year in India.
```sql
SELECT
    EXTRACT(YEAR FROM TO_DATE(date_added,'Month DD,YYYY')) AS YEAR_COLUMN,
    COUNT(show_id),
    ROUND(COUNT(show_id)::NUMERIC/(SELECT COUNT(show_id) FROM netflix WHERE COUNTRY = 'India')::NUMERIC * 100) AS AVG_YEAR
FROM
    netflix
WHERE
    COUNTRY = 'India'
GROUP BY 1 
ORDER BY AVG_YEAR DESC 
LIMIT 5;
```
### 📜 11) Movies Categorized as Documentaries
Lists all movies that belong to the Documentary genre.
```sql
SELECT 
    type,
    title,
    UNNEST (STRING_TO_ARRAY(listed_in,',')) AS DOCUMENTARIES
FROM 
    NETFLIX
WHERE
    listed_in = 'Documentaries';
```
### 🚫 12) Content Without a Director
Identifies content missing a director.
```sql
SELECT 
    *,
    director
FROM  
    netflix
WHERE
    director IS NULL;
```
### 🎭 13) Salman Khan Movies in the Last 10 Years
Lists movies featuring Salman Khan released in the last 10 years.
```sql
SELECT
    show_id,
    type,
    title,
    date_added
FROM
    netflix
WHERE
    casts ILIKE '%Salman Khan%'
    AND
    TO_DATE(date_added,'Month DD,YYYY')>= CURRENT_DATE - INTERVAL '10 YEARS';
```
### 🎭 14) Top 10 Actors in Indian Movies
Ranks actors by how often they appear in Indian movies.
```sql
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
LIMIT 10;
```
### 🚨 15) Categorizing Content Based on Keywords
Labels content as `Bad` if descriptions contain 'Kill' or 'Violence', otherwise marks it as `Good`. Counts occurrences in each category.
```sql
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
GROUP BY 1;
```

## 🛠️ Technologies Used
- **SQL** (PostgreSQL)
- **Data Analysis**

## 📌 Conclusion
This analysis helps in understanding the Netflix content trends, most popular genres, frequent actors, and other valuable insights. 📊✨

