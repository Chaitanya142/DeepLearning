USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/





-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT table_name,
       table_rows
FROM   information_schema.tables
WHERE  table_schema = 'imdb'; 
    
-- Findings
/*
1. The names table has the maximum rows listing people who worked on movies. 
2. Number of rows in movie table is less than the genre table's, indicating each movie can belong to multiple genres.
3. The ratings table has 7,927 rows, fewer than the movie table, showing only some movies have ratings. 
4. Number of rows in director_mapping table is less than role_mapping, indicating multiple people worked in the same
   role across different movies.

*/


-- Q2. Which columns in the movie table have null values?
-- Type your code below:



SELECT Count(*) - Count(NULLIF(id, NULL)) AS id,
       Count(*) - Count(NULLIF(title, NULL)) AS title,
       Count(*) - Count(NULLIF(year, NULL))  AS year,
       Count(*) - Count(NULLIF(date_published, NULL))  AS date_published,
       Count(*) - Count(NULLIF(duration, NULL)) AS duration,
       Count(*) - Count(NULLIF(country, NULL)) AS country,
       Count(*) - Count(NULLIF(worlwide_gross_income, NULL)) AS worlwide_gross_income,
       Count(*) - Count(NULLIF(languages, NULL)) AS languages,
       Count(*) - Count(NULLIF(production_company, NULL)) AS production_company
FROM   movie; 

-- Findings
/* 
  1. ID, title, year, date published, and duration have no null values.
  2. financial data (worldwide gross income) and production details(production company) are frequently missing.
*/

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

-- First part
SELECT year AS Year,
       Count(id) AS number_of_movies
FROM   movie
GROUP  BY year; 


-- Second part
SELECT Month(date_published) AS month_num,
       Count(DISTINCT id)    AS number_of_movies
FROM   movie
GROUP  BY month_num
ORDER  BY month_num; 

-- Findings
/*
1. In 2017, 3052 movies were released, which is higher than the number released in 2018 and 2019.
2. The number of movies released decreased significantly from 3052 in 2017 to 2944 in 2018 and 2001 in 2019.
3. Number of movies released in March is the highest.
*/



/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT year,
       Count(id) AS total_movies_count_in_USA_and_India
FROM   movie
WHERE  ( country LIKE '%USA%'
          OR country LIKE '%India%' )
       AND year = 2019;
        
-- Findings
/* In 2019, a total of 1059 movies were released either in the USA or India, 
which is more than half of the movies released worldwide that year.*/


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT genre
FROM genre; 
    
-- FIndings
/*The unique genres are Drama, Fantasy, Thriller, Comedy, Horror, Family, Romance, Adventure, Action, Sci-Fi, Crime, Mystery, and Others */




/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT genre,
       Count(movie_id) AS No_of_movies
FROM   genre
GROUP  BY genre
ORDER  BY no_of_movies DESC
LIMIT  1; 
   
-- Findings
-- Drama is the genre with the most movies produced, with a total of 4,285.



/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH movies_having_one_genre
     AS (SELECT movie_id,
                Count(genre) AS number_of_genre
         FROM   genre
         GROUP  BY movie_id
         HAVING number_of_genre = 1)
SELECT Count(*) AS movie_belong_to_one_genre
FROM   movies_having_one_genre; 

-- Findings
/* A total of 3,289 movies are listed under only one genre, 
   such as "The Other Side of the Wind," "Ankur," and "Kiss Daddy Goodbye*/



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

SELECT genre,
       Round(Avg(duration), 2) AS avg_duration
FROM   movie M
       INNER JOIN genre G
               ON M.id = G.movie_id
GROUP  BY genre
ORDER  BY genre ASC; 


-- Findings
/*Action movies are the longest at 112.88 minutes, and Horror movies are the shortest at 92.72 minutes.
 Most other genres are between 100 and 110 minutes long.*/





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

WITH genre_rank
     AS (SELECT genre,
                Count(movie_id)  AS movie_count,
                Rank()
                  OVER(
                    ORDER BY Count(movie_id) DESC) AS genre_rank
         FROM   genre
         GROUP  BY genre)
SELECT *
FROM   genre_rank
WHERE  genre = 'Thriller';  

-- Findings
--  The thriller genre ranks 3rd with 1,484 movies produced.





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

SELECT Min(Avg_rating)    'min_avg_rating',
       Max(Avg_rating)    'max_avg_rating',
       Min(Total_votes)   'min_total_votes',
       Max(Total_votes)   'max_total_votes',
       Min(Median_rating) 'min_median_rating',
       Max(Median_rating) 'max_median_rating'
FROM   ratings; 

-- We can see Average Rating value and Median Rating value ranges from 1 to 10 which is expected value.
    

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
-- It's ok if RANK() or DENSE_RANK() is used too

-- Used dense rank instead to differentiate movie having same rating as 1/2/3. 

SELECT     title,
           avg_rating,
           Dense_rank() OVER(ORDER BY avg_rating DESC) AS movie_rank
FROM       movie AS mov
INNER JOIN ratings AS rt
ON         rt.movie_id = mov.id limit 10;

-- Findings:-
-- We cam see movie 'Kirket' and 'Love in Kilnerry' are top two ranking movies based on its highest average rank.
-- Also, can find movie 'Fan'in top 10 movie rank with an average rating of 9.6


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

SELECT median_rating   'median_rating',
       Count(movie_id) 'movie_count'
FROM   ratings
GROUP  BY median_rating
ORDER  BY movie_count DESC; 

-- We can see movies with median rating 7 are highest in count(2257 movie count) and movies having median rating 1 are lowest in count(94 movie count).


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

-- CTE to get ranking of production house and then select query to get production company having highest rank.
-- Used rank function to check most number of hit movies.

WITH prod_comp_rank
     AS (SELECT production_company,
                Count(id)  AS no_of_movies,
                Dense_rank()
                  OVER(
                    ORDER BY Count(id) DESC) prod_company_rank
         FROM   movie m
                INNER JOIN ratings r
                        ON m.id = r.movie_id
         WHERE  r.avg_rating > 8
                AND m.production_company IS NOT NULL
         GROUP  BY m.production_company)
SELECT *
FROM   prod_comp_rank
WHERE  prod_company_rank = 1; 

-- Findings:
-- Dream Warrior Pictures and National Theatre Live have highest rank(1) in terms of producing the most number of hit movies (average rating > 8).

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

/* In above question, there are below four conditions to check to find genre and its movie count.
	1. Year = 2017 
    2. Month = March(3)
    3. Country in USA
    4. Total votes is greater than 1000 
*/

SELECT g.genre AS 'genre',
       Count(m.id) AS 'movie_count'
FROM   movie m
       INNER JOIN genre g
               ON m.id = g.movie_id
       INNER JOIN ratings r
               ON m.id = r.movie_id
WHERE  m.year = 2017
       AND m.country LIKE '%USA%'
       AND Month(m.date_published) = 3
       AND r.total_votes > 1000
GROUP  BY g.genre
ORDER  BY Count(m.id) DESC; 

-- Drama has highest total movie count of 24 in March 2017 in USA that had votes greater than 1000. 
-- Family has least total movie count of 1 in March 2017 in USA that had votes greater than 1000. 

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
-- Code with average rating

SELECT m.title  'title',
       r.avg_rating 'avg_rating',
       g.genre   'genre'
FROM   movie m
       INNER JOIN genre g
               ON m.id = g.movie_id
       INNER JOIN ratings r
               ON m.id = r.movie_id
WHERE  m.title LIKE 'The%'
       AND r.avg_rating > 8.0
ORDER  BY r.avg_rating DESC; 

-- Findings:-
-- 1. Movie 'The Brighton Miracle' have highest average rating of 9.5 follwed by movie 'The Colour of Darkness' with 9.1 avg rating.
-- 2. 'Drama' genre have maximum number of movies (total 6) with title begining with word 'The' that have average rating greater than 8.
-- 3. 'Crime' genre have second highest number of movies (total 3) with title begining with word 'The' that have average rating greater than 8.
-- 4. There are total 8 unique movies with title begining with word 'The' that have average rating greater than 8. 
	

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.

-- Code with median rating
SELECT m.title  'title',
       r.median_rating 'median_rating',
       g.genre   'genre'
FROM   movie m
       INNER JOIN genre g
               ON m.id = g.movie_id
       INNER JOIN ratings r
               ON m.id = r.movie_id
WHERE  m.title LIKE 'The%'
       AND r.median_rating > 8
ORDER  BY r.median_rating DESC; 

-- Findings:-
-- 1. Movie 'The Blue Elephant 2' have highest median rating of 10.
-- 2. Total 29 unique movies with title begining with word 'The' have median rating 10. 
-- 3. 'Drama' genre have maximum number of movies (total 31) with title begining with word 'The' that have median rating greater than 8.
-- 4. 'Horror' genre have second highest number of movies (total 15) with title begining with word 'The' that have median rating greater than 8.
-- 5. There are total 52 unique movies with title begining with word 'The' that have median rating greater than 8. 
	
-- Can see there is one difference in findings related to genre type where Crime is secoind highest when average rating >8 and Horror is second highest when median rating >8.



-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

-- Used select query to find total movie count for all median rating value to get more insight.

SELECT Count(m.id) 'Movie_count',
       r.median_rating 'median_rating'
FROM   movie m
       INNER JOIN ratings r
               ON m.id = r.movie_id
WHERE  ( m.date_published BETWEEN '2018-04-01' AND '2019-04-01' )
GROUP  BY r.median_rating
ORDER  BY r.median_rating DESC; 

-- Findings :-
-- 1. Total 361 movies released between 1 April 2018 and 1 April 2019 had median rating of 8.
-- 2. Movies released between 1 April 2018 and 1 April 2019 with median rating of 7 have highest number of total movie count 787. 
-- 3. Interestingly, movies released between 1 April 2018 and 1 April 2019 who have got highest median rating of 10 have fourth 
--    least number of total count 138.

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

-- Query to find total votes of movies released in Germany and in Italy.

SELECT m.country 'Country',
       Sum(r.total_votes) 'Total_Votes'
FROM   movie m
       INNER JOIN ratings r
               ON m.id = r.movie_id
WHERE  m.country = 'Germany'
        OR m.country = 'Italy'
GROUP  BY m.country; 


-- We can see movies released only in Germany have more total votes as compared to moves released only in Italy.


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

-- Null values for Name are 0, height are 17335, for date of birth are 13431 and known for movies are 15226


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

WITH top_3_gen_mov_dir AS
(
           SELECT     genre,
                      Dense_rank() OVER(ORDER BY Count(mov.id) DESC) AS genre_rank
           FROM       movie  AS mov
           INNER JOIN genre  AS gen
           ON         gen.movie_id = mov.id
           INNER JOIN ratings AS rat
           ON         rat.movie_id = mov.id
           WHERE      avg_rating > 8
           GROUP BY   genre limit 3 )
SELECT     n.NAME  AS director_name ,
           Count(dir_map.movie_id) AS movie_count
FROM       director_mapping AS dir_map
INNER JOIN genre gen
using      (movie_id)
INNER JOIN names AS n
ON         n.id = dir_map.name_id
INNER JOIN top_3_gen_mov_dir
using      (genre)
INNER JOIN ratings
using      (movie_id)
WHERE      avg_rating > 8
GROUP BY   NAME
ORDER BY   movie_count DESC limit 3 ;

-- Findings:-
-- 1. Top 3 gener having avg rating more than 8 are Drama, Action and Comedy
-- 2. Top 3 directors are James Mangold, Anthony Russo, Soubin Shahir with movie count having avg rating more than 8 are 4,3,3 resp.



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

WITH actor_movie_rank
     AS (SELECT n.NAME  AS actor_name,
                Count(rm.movie_id) AS movie_count,
                Dense_rank()
                  OVER (
                    ORDER BY Count(rm.movie_id) DESC) 'actor_rank'
         FROM   role_mapping rm
                INNER JOIN names n
                        ON n.id = rm.name_id
                INNER JOIN ratings rt
                        ON rt.movie_id = rm.movie_id
         WHERE  category = "actor"
                AND rt.median_rating >= 8
         GROUP  BY n.NAME
         ORDER  BY movie_count DESC)
SELECT actor_name,
       movie_count
FROM   actor_movie_rank
WHERE  actor_rank <= 2; 

-- Finding: 
-- Top 2 actors are Mammootty(8 movies) and Mohanlal(5 movies)




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


SELECT     mov.production_company,
           Sum(total_votes) AS total_vote_count,
           Dense_rank() OVER(ORDER BY Sum(total_votes) DESC) AS production_comp_rank
FROM       movie mov
INNER JOIN ratings rt
ON         mov.id = rt.movie_id
GROUP BY   mov.production_company
ORDER BY   total_vote_count DESC limit 3;

-- Finding:
-- Top 3 production houses are Marvel Studios(2656967 votes),Twentieth Century Fox(2411163 votes),Warner Bros.(2396057 votes)





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

WITH rank_actors
     AS (SELECT NAME  AS actor_name,
                Sum(total_votes) AS total_votes,
                Count(rm.movie_id) AS movie_count,
                Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) AS actor_avg_rating
         FROM   role_mapping rm
                INNER JOIN names n
                        ON rm.name_id = n.id
                INNER JOIN ratings r
                        ON rm.movie_id = r.movie_id
                INNER JOIN movie mov
                        ON rm.movie_id = mov.id
         WHERE  category = 'actor'
                AND country LIKE '%India%'
         GROUP  BY name_id,
                   NAME
         HAVING Count(DISTINCT rm.movie_id) >= 5)
SELECT *,
       Dense_rank()
         OVER (
           ORDER BY actor_avg_rating DESC, total_votes DESC) AS actor_rank
FROM   rank_actors; 

-- Finding:-
-- Top actor is Vijay Sethupathi with total votes 23114, movies 5 and rating 8.42


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



WITH rank_actresses AS
(
           SELECT     NAME  AS actress_name ,
                      Sum(total_votes)  AS total_votes,
                      Count(rm.movie_id)  AS movie_count,
                      Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) AS actress_avg_rating
           FROM       role_mapping rm
           INNER JOIN names n
           ON         rm.name_id = n.id
           INNER JOIN ratings r
           ON         rm.movie_id = r.movie_id
           INNER JOIN movie mov
           ON         rm.movie_id = mov.id
           WHERE      category = 'actress'
           AND        country LIKE '%India%'
           AND        mov.languages LIKE "%Hindi%"
           GROUP BY   name_id,
                      NAME
           HAVING     Count(DISTINCT rm.movie_id) >= 3 )
SELECT   *,
         Dense_rank() OVER ( ORDER BY actress_avg_rating DESC, total_votes DESC) AS actress_rank
FROM     rank_actresses Limit 5 ;

-- Finding:-
-- Top 5 actress are Taapsee Pannu,Kriti Sanon,Divya Dutta,Shraddha Kapoor,Kriti Kharbanda



/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:


SELECT title AS movie_name,
       avg_rating,
       CASE
         WHEN avg_rating > 8 THEN "superhit movies"
         WHEN avg_rating BETWEEN 7 AND 8 THEN "hit movies"
         WHEN avg_rating BETWEEN 5 AND 7 THEN "one-time-watch movies"
         ELSE "flop movies"
       END   AS avg_rating_category
FROM   movie AS mov
       INNER JOIN genre AS gen
               ON mov.id = gen.movie_id
       INNER JOIN ratings rt
               ON rt.movie_id = mov.id
WHERE  genre = "thriller"; 

-- Finding:-
-- Safe is the best superhit movie in thriller genre



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

-- CTE created to list average duration of each genre type.
-- Select query on CTE to find running total and moving average of 2 preceding rows and 2 following rows on movie average duration.


-- Check
WITH genre_avg_duration AS
(
           SELECT     g.genre,
                      Round(Avg(m.duration),2) 'avg_duration'
           FROM       movie m
           INNER JOIN genre g
           ON         m.id=g.movie_id
           GROUP BY   g.genre )
SELECT   *,
         round(sum(avg_duration) OVER w1,2) 'running_total_duration',
         round(avg(avg_duration) OVER w2,2) 'moving_avg_duration'
FROM     genre_avg_duration window w1 AS (ORDER BY genre rows UNBOUNDED PRECEDING),
							       w2 AS (ORDER BY genre rows BETWEEN 2 PRECEDING AND 2 following)
ORDER BY genre;


-- Findings:-
-- Total duration of all genre type is 1239.45 mins.
-- Moving average of each genre type movie duraton ranges from 101 to 105 mins.




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

  -- Used current conversion rate from INR to USD as of todays date(27th July : 1 INR = 0.012 USD) to standadrdise gross income variable. 
  
WITH top_3_gen AS
(
         SELECT   genre,
                  Count(movie_id) AS movie_count,
                  Rank() OVER(ORDER BY Count(movie_id) DESC) AS genre_rank
         FROM     genre
         GROUP BY genre limit 3 ), m_rank AS
(
           SELECT     genre,
                      year,
                      title AS movie_name,
                      worlwide_gross_income,
                      CASE
							WHEN worlwide_gross_income LIKE 'INR%' THEN Concat('$ ',Replace(worlwide_gross_income,'INR','')*0.012)
						    ELSE worlwide_gross_income
                      END 'worlwide_gross_income_std',
                      Rank() OVER(ORDER BY Cast(Trim(Replace(worlwide_gross_income_std ,'$','')) AS DECIMAL) DESC) AS movie_rank
           FROM       movie  AS mov
           INNER JOIN genre  AS gen
           ON         mov.id=gen.movie_id
           WHERE      genre IN
                      (
                             SELECT genre
                             FROM   top_3_gen) )
SELECT genre,
       year,
       movie_name,
       worlwide_gross_income,
       movie_rank
FROM   m_rank
WHERE  movie_rank<=5;



-- Findings:-
-- Movie 'Avengers: Endgame' was highest grossing movie in 2019 which is a Drama genre movie.
-- Movie 'The Lion King' was second highest grossing movie in 2019 which is also a Drama genre movie.


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

WITH prod_comp_rank
     AS (SELECT production_company,
                Count(id) AS movie_count,
                Dense_rank()
                  OVER(
                    ORDER BY Count(id) DESC) AS prod_comp_rank
         FROM   movie mov
                INNER JOIN ratings rt
                        ON mov.id = rt.movie_id
         WHERE  median_rating >= 8
                AND production_company IS NOT NULL
                AND Locate (',', languages) > 0
         GROUP  BY production_company)
SELECT *
FROM   prod_comp_rank
WHERE  prod_comp_rank <= 2; 

/*  Finding:-
    We can see Star Cinema and Twentieth Century Fox are top two production company that have produced the highest number 
    of hits among multilingual movies. */






-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- used row_number() function to get top three ranking actress.
WITH actress_mov_rank
     AS (SELECT n.NAME 'actress_name',
                Sum(r.total_votes) 'total_votes',
                Count(r.movie_id) 'movie_count',
                Round(Avg(avg_rating), 2) 'actress_avg_rating',
                Row_number()
                  OVER (
                    ORDER BY Count(r.movie_id) DESC) 'actress_rank'
         FROM   ratings r
                INNER JOIN role_mapping rm
                        ON r.movie_id = rm.movie_id
                INNER JOIN names n
                        ON rm.name_id = n.id
                INNER JOIN genre g
                        ON g.movie_id = r.movie_id
         WHERE  rm.category = 'actress'
                AND g.genre = 'Drama'
                AND r.avg_rating >= 8
         GROUP  BY n.NAME)
SELECT *
FROM   actress_mov_rank
WHERE  actress_rank <= 3; 


/* 
Finding:-
Parvathy Thiruvothu, Susan Brown and Amanda Lawrence are top three actress 
based on number of Super Hit movies (average rating >8) in drama genre.
*/






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
-- used row_number() to find top 9 rank director.

WITH director_movie_details
     AS (SELECT dm.name_id  'director_id',
                n.NAME  'director_name',
                m.id  'movie_id',
                m.date_published  'date_published',
                Lead(m.date_published, 1, m.date_published)
                  OVER (
                    partition BY n.NAME
                    ORDER BY m.date_published DESC) 'next_movie_release_date',
                Datediff (m.date_published,
                Lead(m.date_published, 1, m.date_published)
                  OVER (
                    partition BY n.NAME
                    ORDER BY m.date_published DESC)) 'release_day_difference',
                r.avg_rating 'avg_rating',
                r.total_votes 'total_votes',
                m.duration 'duration'
         FROM   movie m
                INNER JOIN director_mapping dm
                        ON m.id = dm.movie_id
                INNER JOIN ratings r
                        ON m.id = r.movie_id
                INNER JOIN names n
                        ON dm.name_id = n.id
         ORDER  BY n.NAME),
     director_movie_rank
     AS (SELECT director_id,
                director_name,
                Count(movie_id) 'number_of_movies',
                Round(Avg(release_day_difference)) 'avg_inter_movie_days',
                Round(Avg(avg_rating), 2) 'avg_rating',
                Sum(total_votes) 'total_votes',
                Min(avg_rating) 'min_rating',
                Max(avg_rating) 'max_rating',
                Sum(duration)  'total_duration',
                Row_number()
                  OVER (
                    ORDER BY Count(movie_id) DESC) 'director_ranking'
         FROM   director_movie_details
         GROUP  BY director_id,
                   director_name
         ORDER  BY director_name)
SELECT director_id,
       director_name,
       number_of_movies,
       avg_inter_movie_days,
       avg_rating,
       total_votes,
       min_rating,
       max_rating,
       total_duration
FROM   director_movie_rank
WHERE  director_ranking <= 9; 

/*
Findings:
1. A.L. Vijay is top most director name with maximum count of movies (count=5).
2. Director Özgür Bakar released movies in short interval of days with average inter movie days = 84 days with an avg rating of 3.75. 
3. Director 'Sion Sono' released movies with more interval of days with an average inter movie days = 248 days with an avg rating of 6.
*/