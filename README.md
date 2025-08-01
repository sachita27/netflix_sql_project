# Netflix Movies and TV Shows Data Analysis using SQL

![Netflix Logo](https://github.com/sachita27/netflix_sql_project/blob/main/netflix-logo-png-.jpg)

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objective
- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Dataset
The dataset for  this project is sourced from the Kaggle dataset:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Schema

```sql
DROP TABLE IF EXISTS NETFLIX;
CREATE TABLE NETFLIX
(
show_id         VARCHAR(6),
type	        VARCHAR(10),
title	        VARCHAR(150),
director        VARCHAR(208),
casts	        VARCHAR(1000),
country	        VARCHAR(150),
date_added    	VARCHAR(50),
release_year	INT,
rating	        VARCHAR(10),
duration	   VARCHAR(15),
listed_in    	VARCHAR(100),
description     VARCHAR(250)
);
```
## Business Problems and Solutions

### 1. Count the number of Movies vs TV Shows

```sql
SELECT TYPE, COUNT(*) AS total_content
FROM NETFLIX
GROUP BY TYPE
```
### 2. Find the most common rating for movies and TV Shows

```sql
SELECT TYPE, RATING 
FROM
(SELECT TYPE, 
RATING, 
COUNT(*), 
RANK() OVER(PARTITION BY TYPE ORDER BY COUNT(*) DESC) AS RANKING
FROM NETFLIX
GROUP BY 1,2) AS T1
WHERE RANKING = 1
```
