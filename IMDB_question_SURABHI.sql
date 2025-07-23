USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

-- Count of rows of movie table
SELECT 	COUNT(*) 
FROM 	movie; -- 7997 rows

-- count of rows of genre table
SELECT 	COUNT(*) 
FROM 	genre; -- 14662 rows

-- count of rows of ratings table
SELECT 	COUNT(*) 
FROM 	ratings; -- 7997

-- count of rows of role_mapping table
SELECT 	COUNT(*) 
FROM 	role_mapping; -- 15615

-- count of rows of director_mapping table
SELECT 	COUNT(*) 
FROM 	director_mapping; -- 3867

-- count of rows of names table
SELECT 	COUNT(*) 
FROM 	names; -- 25735



-- Q2. Which columns in the movie table have null values?
-- Type your code below:

-- columns in movie table are id , title, year, date_published, duration, country, worlwide_gross_income, languages, production_company

SELECT * 
FROM 	movie 
WHERE 	id IS NULL; -- id column has no null values
 
SELECT * 
FROM 	movie 
WHERE 	title IS NULL; -- title column has no null values

SELECT * 
FROM 	movie 
WHERE 	year IS NULL; -- year column has no null values

SELECT * 
FROM 	movie 
WHERE 	date_published IS NULL; -- date_published column has no null values

SELECT * 
FROM 	movie 
WHERE 	duration IS NULL; -- duration column has no null values

SELECT * 
FROM 	movie 
WHERE 	country IS NULL OR country=''; -- country column has 20 null values

SELECT * 
FROM 	movie 
WHERE 	worldwide_gross_income IS NULL OR worldwide_gross_income='';    -- worldwide_gross_income column has 3724 null values

SELECT * 
FROM 	movie 
WHERE 	languages IS NULL OR languages='';  -- languages column has 194 null values

SELECT * 
FROM 	movie 
WHERE 	production_company IS NULL OR production_company='';  -- production_company column has 528 null values
 


-- Country, worlwide_gross_income, languages, production_company have null values



-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 	year AS YEAR, 
		COUNT(*) AS number_of_movies
FROM 	movie 
GROUP 	BY year;

/*
2017	3052
2018	2944
2019	2001 */

SELECT 	MONTH(date_published) AS month_num, 
		COUNT(*) AS number_of_movies
FROM 	movie
GROUP 	BY month_num
ORDER 	BY  month_num;

/*
1	804
2	640
3	824
4	680
5	625
6	580
7	493
8	678
9	809
10	801
11	625
12	438
*/


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT 	COUNT(DISTINCT id) 
FROM 	movie 
WHERE 	year=2019 AND 
		country REGEXP 'USA' or country REGEXP 'India'; -- 1818 movies are produced in the year 2019


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT genre FROM genre;

/*
Drama
Fantasy
Thriller
Comedy
Horror
Family
Romance
Adventure
Action
Sci-Fi
Crime
Mystery
Others
*/

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

WITH top_genre AS                                -- finding top genre based on movie count
(
	SELECT 	COUNT(g.movie_id) AS number_of_movies,
			genre,
			ROW_NUMBER() OVER(ORDER BY COUNT(g.movie_id) DESC) AS row_no
	FROM 	movie m
	INNER JOIN 
			genre g
	ON 		m.id=g.movie_id
	GROUP 	BY genre
)
SELECT 		genre,                         
			number_of_movies
FROM 		top_genre
WHERE 		row_no=1;                                 -- finding top 1 genre based on movie count

/* 
4285	Drama
*/



/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH genre_count AS                 -- finding count of movies belong to genre
(
	SELECT 	movie_id, 
			COUNT(genre) as count_of_genre
	FROM 	genre 
	GROUP 	BY movie_id
)
SELECT 		COUNT(movie_id) as num_movie_one_genre
FROM 		genre_count 
WHERE 		count_of_genre = 1;            -- finding count of movie belong to one genre


/* 3289 movies belong to one genre */


/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


SELECT 	genre,                                      -- finding genre based on average duration
		ROUND(AVG(duration),2) AS avg_duration
FROM 	movie  m
INNER JOIN 
		genre  g
ON 		m.id=g.movie_id
GROUP 	BY genre;


/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 	genre,                                   -- Ranking genre based on movie count
		COUNT(m.id) AS movie_count,
		RANK() OVER(ORDER BY COUNT(m.id) DESC) AS genre_rank
FROM 	movie m
INNER JOIN 
		genre g
ON 		m.id=g.movie_id
GROUP 	BY genre;

-- Drama, comedy and Thriller are top 3 genre based on movie count

/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/


-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT 
		MIN(avg_rating) 	AS min_avg_rating,        -- finding outliers in each column of rating table
		MAX(avg_rating) 	AS max_avg_rating,
		MIN(total_votes) 	AS min_total_votes,
		MAX(total_votes) 	AS max_total_votes,
		MIN(median_rating) 	AS min_median_rating,
		MAX(median_rating) 	AS max_median_rating
FROM 
		ratings;


/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- Keep in mind that multiple movies can be at the same rank. You only have to find out the top 10 movies (if there are more than one movies at the 10th place, consider them all.)

SELECT 	title,
		avg_rating,
		movie_rank
FROM (
    SELECT title,					--  Ranking of movies based on average rating
           avg_rating,
           RANK() OVER (ORDER BY avg_rating DESC) AS movie_rank
    FROM 	movie m
    INNER JOIN 
			ratings r 
    ON 		m.id = r.movie_id
) AS 		ranked_movies

WHERE 	movie_rank <= 10;          -- finding top 10 movies based on average rating



/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT                                      -- median rating and count of movies
		median_rating,
		COUNT(movie_id) AS movie_count
FROM
		ratings
GROUP BY
		median_rating
ORDER BY 
		median_rating ;


/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 	production_company,           -- Ranking production comapnay based on count movies 
		COUNT(id) AS movie_count,
		DENSE_RANK() OVER (ORDER BY COUNT(id) DESC) AS prod_company_rank
FROM   	movie m
		INNER JOIN ratings r
		ON r.movie_id = m.id
WHERE  	r.avg_rating > 8 AND          -- filtering on average rating > 8
		m.production_company IS NOT NULL
GROUP  	BY production_company; 


-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 	g.genre,                                
		COUNT(g.movie_id) AS movie_count
FROM 	genre g
INNER JOIN
		(
			SELECT 	id 
            FROM 	movie 
            WHERE 	year = 2017 AND 
					MONTH(date_published) = 3 AND
					UPPER(country) LIKE '%USA%' 
		) m
ON 		g.movie_id = m.id
INNER JOIN 
		ratings r
ON 
		m.id = r.movie_id
WHERE 	r.total_votes > 1000
GROUP 	BY g.genre
ORDER 	BY movie_count DESC;

	

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT
		title,
		avg_rating,
		genre
FROM
		genre g
INNER JOIN
		movie m
ON 		g.movie_id = m.id
INNER JOIN
		ratings r
ON 		m.id = r.movie_id
WHERE 	r.avg_rating > 8 AND
		title LIKE 'The%'
ORDER 	BY avg_rating DESC;





-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT COUNT(id) AS movie_count
FROM   movie m
       INNER JOIN ratings r
	   ON m.id = r.movie_id
WHERE  m.date_published BETWEEN '2018-04-01' AND '2019-04-01'
       AND r.median_rating = 8; 

-- so 361 movies released between 1 April 2018 and 1 April 2019 have been given median rating 8.

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:


WITH german_votes AS
(
	SELECT
			SUM(total_votes) AS Total_votes_of_German
	FROM
			movie m
	INNER JOIN
			ratings r
	ON 		m.id = r.movie_id
	WHERE
			languages LIKE '%German%'
),
italian_votes AS
(
	SELECT
			SUM(total_votes) AS Total_votes_of_Italian
	FROM
			movie m
	INNER JOIN
			ratings r
	ON 		m.id = r.movie_id
	WHERE
			languages LIKE '%Italian%'
)
SELECT 
			g.*,
			i.*
FROM
			german_votes g
INNER JOIN
			italian_votes i;

-- German votes -4421525	,      Italian votes - 2559540

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT Sum(CASE
             WHEN NAME IS NULL THEN 1
             ELSE 0
           END) AS name_nulls,
       Sum(CASE
             WHEN height IS NULL THEN 1
             ELSE 0
           END) AS height_nulls,
       Sum(CASE
             WHEN date_of_birth IS NULL THEN 1
             ELSE 0
           END) AS date_of_birth_nulls,
       Sum(CASE
             WHEN known_for_movies IS NULL THEN 1
             ELSE 0
           END) AS known_for_movies_nulls
FROM   names; 

/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH top_genre AS                     -- finding top genre based on average rating
(
	SELECT 
		g.genre,
		COUNT(g.movie_id) AS movie_count
	FROM 
		genre AS g
	INNER JOIN 
		ratings AS r
	ON g.movie_id = r.movie_id
	WHERE avg_rating > 8              -- filtering by average rating > 8
    GROUP BY genre
    ORDER BY movie_count DESC
    LIMIT 3
),
top_director AS                        -- Ranking top director based on count of movies 
(
	SELECT 
			n.name AS director_name,
			COUNT(g.movie_id) AS movie_count,
			ROW_NUMBER() OVER(ORDER BY COUNT(g.movie_id) DESC) AS director_row_rank
	FROM 
			names AS n 
	INNER JOIN 
			director_mapping AS d
	ON 		n.id = d.name_id 
	INNER JOIN 
			genre AS g 
	ON 		d.movie_id = g.movie_id 
	INNER JOIN 
			ratings AS r 
	ON 		r.movie_id = g.movie_id,
	top_genre
	WHERE 	g.genre in (top_genre.genre) AND avg_rating > 8
	GROUP 	BY director_name
	ORDER 	BY movie_count DESC
	)
SELECT 
			director_name,
			movie_count
FROM 
			top_director
WHERE 
			director_row_rank <= 3;     -- finding top 3 director


/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT name AS actor_name,                        -- finding top 2 actor based on count of movies and median rating > 8
       COUNT(r.movie_id) AS movie_count
FROM   names n
       INNER JOIN role_mapping rm
	   ON n.id = rm.name_id
       INNER JOIN ratings r
	   ON rm.movie_id = r.movie_id
WHERE  median_rating >= 8
       AND category = 'actor'
GROUP  BY name
ORDER  BY movie_count DESC
LIMIT  2; 



/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH rank_info AS                           -- ranking production company based on total votes 
(
	SELECT 	production_company,
			SUM(total_votes) AS vote_count,
			RANK() OVER(ORDER BY SUM(total_votes) DESC) AS prod_comp_rank   -- rank of each production company based on total votes
	FROM  	movie m
	INNER JOIN 
			ratings r
	ON 
			m.id=r.movie_id
	GROUP 	BY production_company
)
SELECT *
FROM 		rank_info
WHERE 		prod_comp_rank<=3;      -- selecting top 3 production company
-- MARVEL STUDIOS , Twentieth Century Fox AND WARNER BROS are top 3 production company



/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH actor_info AS         -- Actor ranking based on actor average rating 
(
	SELECT 	name AS actor_name,
			SUM(total_votes) AS total_votes,
			COUNT(rm.movie_id) AS movie_count,
			ROUND(SUM(avg_rating*total_votes)/SUM(total_votes)) AS actor_avg_rating,
			DENSE_RANK() OVER(ORDER BY ROUND(SUM(avg_rating*total_votes)/SUM(total_votes)) DESC,SUM(total_votes) DESC) AS actor_rank 
	FROM names n
	INNER JOIN 
			role_mapping rm
	ON 
			n.id=rm.name_id
	INNER JOIN 
			movie m
	ON 
			rm.movie_id=m.id
	INNER JOIN 
			ratings r
	ON 
			m.id=r.movie_id
	WHERE 	category='actor' AND 
			country LIKE '%India%' -- movie released in India 
	GROUP 	BY name_id, name
	HAVING 	COUNT(DISTINCT rm.movie_id)>=5  -- actor acted in atleast 5 Indian movie
)
SELECT*
FROM 		actor_info
WHERE 		actor_rank=1;         -- Top 1 actor based on actor average rating




-- Top actor is Vijay Sethupathi 

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


WITH actress_info AS       -- Actress ranking based on actress average rating
	(
	SELECT 	name AS actress_name,
			SUM(total_votes) AS total_votes,
			COUNT(rm.movie_id) AS movie_count,
			ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) AS actor_avg_rating,
			DENSE_RANK() OVER(ORDER BY ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) DESC, SUM(total_votes) DESC) AS actress_rank 
	FROM 	names n
	INNER JOIN 
			role_mapping rm
	ON 
			n.id=rm.name_id
	INNER JOIN 
			movie m
	ON 
			rm.movie_id=m.id
	INNER JOIN 
			ratings r
	ON 
			m.id=r.movie_id
	WHERE 	category='actress' AND 
			country LIKE '%India%' AND 
            languages LIKE '%Hindi%' -- Actresses worked in India and also in Hindi language
	GROUP 	BY name_id, name
	HAVING 	COUNT(DISTINCT rm.movie_id)>=3 -- Actresses acted in atleast 3 movies
	)
SELECT*
FROM 		actress_info
WHERE 		actress_rank<=5;  -- Top 5 actresses


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Consider thriller movies having at least 25,000 votes. Classify them according to their average ratings in
   the following categories:  

			Rating > 8: Superhit
			Rating between 7 and 8: Hit
			Rating between 5 and 7: One-time-watch
			Rating < 5: Flop
	
    Note: Sort the output by average ratings (desc).
--------------------------------------------------------------------------------------------*/
/* Output format:
+---------------+-------------------+
| movie_name	|	movie_category	|
+---------------+-------------------+
|	Get Out		|			Hit		|
|		.		|			.		|
|		.		|			.		|
+---------------+-------------------+*/

-- Type your code below:

SELECT title as movie_name,           -- classifying the movies into different categories based on their average rating 
       CASE
			WHEN avg_rating > 8 THEN 'Superhit'
            WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit'
            WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time watch'
            ELSE 'Flop'
		END AS movie_category
FROM 
		movie m
INNER JOIN 
		ratings r
ON 
		m.id=r.movie_id
INNER JOIN 
		genre g
ON 
		m.id=g.movie_id
WHERE 	genre='Thriller' AND total_votes>25000    -- filtering by thriller movies and more than 25000 total votes
ORDER 	BY avg_rating DESC;

/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

WITH avg_duration_genre AS        -- finding the average duration per genre
	(
	SELECT 	genre,
			ROUND(AVG(duration),2) AS avg_duration
	FROM 	movie m
	INNER JOIN 
			genre g
	ON 
			m.id=g.movie_id
	GROUP 	BY genre
	)
SELECT*,
			SUM(avg_duration) OVER W AS running_total_duration,  -- finding cumulative sum of avg_duration
			AVG(avg_duration) OVER W AS moving_avg_duration -- finding moving averages of avg_duration
FROM 		avg_duration_genre
WINDOW 		W AS (ORDER BY genre ROWS UNBOUNDED PRECEDING); -- defining window for cumulative sum and moving average

-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

WITH top_3_genre AS                               -- finding top 3 genre
	(
	SELECT 	genre,
			COUNT(movie_id) AS total_movies,
			DENSE_RANK() OVER(ORDER BY COUNT(movie_id) DESC) AS rank_total_movie     -- ranking genre based on total no of movies
	FROM 	genre
	GROUP 	BY genre
	LIMIT 3
	),
top_5_movies_each_year AS
	(
	SELECT 	genre,
			year,
			title as movie_name,
			worlwide_gross_income AS worldwide_gross_income,
			DENSE_RANK() OVER(PARTITION BY year ORDER BY worlwide_gross_income DESC) AS movie_rank   -- ranking for each year separately based on worldwide gross income
	FROM 	movie m
	INNER JOIN 
			genre g
	ON 
			m.id=g.movie_id
	WHERE 	genre IN (SELECT genre FROM top_3_genre)
	)
SELECT *
FROM 		top_5_movies_each_year
WHERE 		movie_rank<=5;                     -- selecting the top 5 ranked movies for each year 

-- Top 3 genre are Drama, Comedy and Thriller

-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
WITH top_production AS                            -- ranking production company based on count of hit movies
	(
	SELECT 	production_company,
			COUNT(m.id) AS movie_count,
			DENSE_RANK() OVER(ORDER BY COUNT(m.id) DESC) AS prod_comp_rank
	FROM 	movie m
	INNER JOIN 
			ratings r
	ON 
			m.id=r.movie_id
	WHERE 	median_rating>=8 AND 
			production_company IS NOT NULL AND 
            POSITION(',' IN languages)>0  			-- defining hit movie and multilingual movies
	GROUP BY production_company
	)
SELECT*
FROM 		top_production
WHERE 		prod_comp_rank<=2;                            -- top 2 production company


-- Star cinema and Twentieth century fox are the top 2 production company that produce highest number of hits among 
-- multilingual movies





-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on the number of Super Hit movies (Superhit movie: average rating of movie > 8) in 'drama' genre?

-- Note: Consider only superhit movies to calculate the actress average ratings.
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes
-- should act as the tie breaker. If number of votes are same, sort alphabetically by actress name.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	  actress_avg_rating |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.6000		     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/

-- Type your code below:

WITH top_3_actress AS             -- ranking each actress by count of superhit movies
	(
	SELECT 	name AS actress_name,
			SUM(total_votes) AS total_votes,
			COUNT(rm.movie_id) AS movie_count,
			ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) AS actress_avg_rating,
			DENSE_RANK() OVER(ORDER BY ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) DESC, SUM(total_votes) DESC) AS actress_rank 
	FROM 	names n
	INNER JOIN 
			role_mapping rm
	ON 
			n.id=rm.name_id
	INNER JOIN 
			movie m
	ON 
			rm.movie_id=m.id
	INNER JOIN 
			ratings r
	ON 
			m.id=r.movie_id
	INNER JOIN 
			genre g
	ON 
			m.id=g.movie_id
	WHERE 	category='actress' AND 
			avg_rating>8 AND 
            genre='Drama' 			-- filtering actresses by drama genre and movies rating > 8
	GROUP 	BY name_id, name
	)
SELECT*
FROM 		top_3_actress
WHERE 		actress_rank<=3                -- finding top 3 actress
ORDER BY 	actress_name;

-- Sangeetha Bhat, Fatmire Sahiti and Adriana Matoshi are the top 3 actresses based on number of superhit movies





/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:
WITH director_next_date_summary AS       -- finding Director details and next date published of each director's next movie
	(
	SELECT 	d.name_id,
			name,
			d.movie_id,
			m.date_published,
			r.avg_rating,
			r.total_votes,
			m.duration,
			LEAD(date_published) OVER(PARTITION BY d.name_id ORDER BY m.date_published) AS next_date_published 
	FROM 	director_mapping d
	INNER JOIN 
			names n
	ON 
			d.name_id=n.id
	INNER JOIN 
			movie m
	ON 
			d.movie_id=m.id
	INNER JOIN 
			ratings r
	ON 
			d.movie_id=r.movie_id
	),
difference_date AS            -- finding the date difference between date published and next date published between movies of each director in days
	(
	SELECT*,
			DATEDIFF(next_date_published,date_published) AS inter_movie_duration    
	FROM 	director_next_date_summary
	),
director_summary AS           -- ranking all the directors based on the number of movies produced
	(
	SELECT 	name_id AS director_id,
			name AS director_name,
			COUNT(movie_id) AS number_of_movies,
			ROUND(AVG(inter_movie_duration),2) AS avg_inter_movie_days,
			ROUND(AVG(avg_rating),2) AS avg_rating,
			SUM(total_votes) AS total_votes,
			MIN(avg_rating) AS min_rating,
			MAX(avg_rating) AS max_rating,
			SUM(duration) AS total_duration,
			ROW_NUMBER() OVER(ORDER BY COUNT(movie_id) DESC, ROUND(AVG(inter_movie_duration),2) DESC) AS row_rank 
	FROM 	difference_date
	GROUP 	BY director_id
	)
SELECT 		director_id,
			director_name,
			number_of_movies,
			avg_inter_movie_days,
			avg_rating,
			total_votes,
			min_rating,
			max_rating,
			total_duration
FROM 		director_summary
WHERE 		row_rank<=9;    -- finding top 9 Directors

-- Andrew Jones and A.L Vijay are the toppers in leaderboard





