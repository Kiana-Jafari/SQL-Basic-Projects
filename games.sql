-- DataCamp Project: When Was the Golden Era of Video Games?

/*
Video games are big business: the global gaming market is projected to be worth more than $300 billion by 2027 according to Mordor Intelligence. 
With so much money at stake, the major game publishers are hugely incentivized to create the next big hit. But are games getting better, or has the golden age of video games already passed?
In this project, you'll analyze video game critic and user scores as well as sales data for the top 400 video games released since 1977. 
You'll search for a golden age of video games by identifying release years that users and critics liked best, and you'll explore the business side of gaming by looking at game sales data.
Your search will involve joining datasets and comparing results with set theory. You'll also filter, group, and order data. 
The database contains two tables. Each table has been limited to 400 rows for this project, but you can find the complete dataset with over 13,000 games on Kaggle.
*/

/*
`game_sales` table
Column      | Definition                                | Data Type
------------+-------------------------------------------+------------
name        | Name of the video game                    | varchar
platform    | Gaming platform                           | varchar
publisher   | Game publisher                            | varchar
developer   | Game developer                            | varchar
games_sold  | Number of copies sold (millions)          | float
year        | Release year                              | int


`reviews` table
Column        | Definition                              | Data Type
--------------+-----------------------------------------+------------
name          | Name of the video game                  | varchar
critic_score  | Critic score according to Metacritic    | float
user_score    | User score according to Metacritic      | float


`users_avg_year_rating` table
Column         | Definition                                        | Data Type
---------------+---------------------------------------------------+------------
year           | Release year of the games reviewed                | int
num_games      | Number of games released that year                | int
avg_user_score | Average score of all the games ratings for year   | float


`critics_avg_year_rating` table
Column            | Definition                                       | Data Type
------------------+--------------------------------------------------+------------
year              | Release year of the games reviewed               | int
num_games         | Number of games released that year               | int
avg_critic_score  | Average score of all the games ratings for year  | float


------------------------------------------------------------------------------------------------------------------------------------------
*/

Explore the data in the table:
SELECT *
FROM public.critics_avg_year_rating
LIMIT 24;

/*
index| year | num_games | avg_critic_score
-----+------+-----------+-----------------
0    | 1998 | 10        | 9.32
1    | 2004 | 11        | 9.03
2    | 2002 | 9         | 8.99
3    | 1999 | 11        | 8.93
4    | 2001 | 13        | 8.82
5    | 2011 | 26        | 8.76
6    | 2016 | 13        | 8.67
7    | 2013 | 18        | 8.66
8    | 2008 | 20        | 8.63
9    | 2017 | 13        | 8.62
10   | 2012 | 12        | 8.62
11   | 2018 | 12        | 8.61
12   | 2000 | 8         | 8.58
13   | 2009 | 20        | 8.55
14   | 2006 | 16        | 8.52
15   | 2014 | 22        | 8.50
16   | 1996 | 5         | 8.50
17   | 2015 | 19        | 8.45
18   | 2010 | 23        | 8.41
19   | 2005 | 13        | 8.38
20   | 2003 | 10        | 8.36
21   | 2019 | 9         | 8.22
22   | 2007 | 24        | 8.20
23   | 1997 | 8         | 7.93
*/

-- best_selling_games
/*
Find the ten best-selling games. 
The output should contain all the columns in the game_sales table and be sorted by the games_sold column in descending order. 
Save the output as best_selling_games.
*/

SELECT *
FROM game_sales
ORDER BY games_sold DESC
LIMIT 10;

/*
index | name                                     | platform  | publisher         | developer           | games_sold  | year
------+------------------------------------------+-----------+-------------------+---------------------+-------------+------
0     | Wii Sports for Wii                       | Wii       | Nintendo          | Nintendo EAD        | 82.90       | 2006
1     | Super Mario Bros. for NES                | NES       | Nintendo          | Nintendo EAD        | 40.24       | 1985
2     | Counter-Strike: Global Offensive for PC  | PC        | Valve             | Valve Corporation   | 40.00       | 2012
3     | Mario Kart Wii for Wii                   | Wii       | Nintendo          | Nintendo EAD        | 37.32       | 2008
4     | PLAYERUNKNOWN'S BATTLEGROUNDS for PC     | PC        | PUBG Corporation  | PUBG Corporation    | 36.60       | 2017
*/

-- critics_top_ten_years
/*
Find the ten years with the highest average critic score, where at least four games were released (to ensure a good sample size). 
Return an output with the columns year, num_games released, and avg_critic_score. 
The avg_critic_score should be rounded to 2 decimal places. 
The table should be ordered by avg_critic_score in descending order. 
Save the output as critics_top_ten_years. 
NOTE: Do not use the critics_avg_year_rating table provided; this has been provided for your third query.
*/

SELECT game_sales.year, COUNT(DISTINCT game_sales.name) AS num_games, ROUND(AVG(reviews.critic_score), 2) AS avg_critic_score
FROM game_sales JOIN reviews ON game_sales.name = reviews.name
GROUP BY game_sales.year
HAVING COUNT(DISTINCT game_sales.name) >= 4
ORDER BY ROUND(AVG(reviews.critic_score), 2) DESC
LIMIT 10;

/*
index | year  | num_games  | avg_critic_score
------+-------+------------+-----------------
0     | 1998  | 10         | 9.32
1     | 2004  | 11         | 9.03
2     | 2002  | 9          | 8.99
3     | 1999  | 11         | 8.93
4     | 2001  | 13         | 8.82
*/

-- SECOND WAY: critics_top_ten_years

SELECT year, num_games, ROUND(avg_critic_score, 2) AS rounded_avg_critic_score
FROM critics_avg_year_rating
GROUP BY year
HAVING num_games >= 4
ORDER BY avg_critic_score DESC
LIMIT 10;

/*
index | year  | num_games  | avg_critic_score
------+-------+------------+-----------------
0     | 1998  | 10         | 9.32
1     | 2004  | 11         | 9.03
2     | 2002  | 9          | 8.99
3     | 1999  | 11         | 8.93
4     | 2001  | 13         | 8.82
*/

-- golden_years
/*
Find the years where critics and users broadly agreed that the games released were highly rated. 
Specifically, return the years where the average critic score was over 9 OR the average user score was over 9. 
The pre-computed average critic and user scores per year are stored in users_avg_year_rating and critics_avg_year_rating tables, respectively. 
The query should return the following columns: year, num_games, avg_critic_score, avg_user_score, and diff. 
The diff column should be the difference between the avg_critic_score and avg_user_score. 
The table should be ordered by the year in ascending order, save this as a DataFrame named golden_years.
*/

SELECT users_avg_year_rating.year, users_avg_year_rating.num_games, critics_avg_year_rating.avg_critic_score, users_avg_year_rating.avg_user_score,
	(critics_avg_year_rating.avg_critic_score - users_avg_year_rating.avg_user_score) AS diff
FROM users_avg_year_rating JOIN critics_avg_year_rating ON users_avg_year_rating.year = critics_avg_year_rating.year
WHERE (critics_avg_year_rating.avg_critic_score > 9) OR (users_avg_year_rating.avg_user_score > 9)
ORDER BY users_avg_year_rating.year ASC;

/*
index | year  | num_games  | avg_critic_score| avg_user_score | diff
------+-------+------------+-----------------+----------------+-------
0     | 1997  | 8          | 7.93            | 9.50           | -1.57
1     | 1998  | 10         | 9.32            | 9.40           | -0.08
2     | 2004  | 11         | 9.03            | 8.55           | 0.48
3     | 2008  | 20         | 8.63            | 9.03           | -0.40
4     | 2009  | 20         | 8.55            | 9.18           | -0.63
*/
