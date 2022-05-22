# Cyclistic bike-share case study

## Scenario: 
I am a junior data analyst working in the marketing analyst team at Cyclistic, a bike-share company in Chicago. The director of marketing believes the company’s future success depends on maximizing the number of annual memberships. Therefore, our team wants to understand how casual riders and annual members use Cyclistic bikes differently. From these insights, our team will design a new marketing strategy to convert casual riders into annual members. But first, Cyclistic executives must approve your recommendations, so they must be backed up with compelling data insights and professional data
visualizations.

## Problem Statements 
1. How do annual members and casual riders use Cyclistic bikes differently? 
2. Why would casual riders buy Cyclistic annual memberships? 
3. How can Cyclistic use digital media to influence casual riders to become members?

## Preparing of Data for Analysis
For the purpose of this exercise I will be using Cyclistic’s historical trip data to analyze and identify trends. The data has been made available by Motivate International Inc. under this license.) This is public data that has been hosted on Amazon Web Services. The dataset consists of 12 .CSV files for data from May 2021 to April 2022.

Each table consist of 13 columns and varying number of rows depending on each month’s rides data. 

For the purpose of this exercise, I will be using PostgreSQL to process the dataset. Visualisations will be done via Tableau.

```TSQL
-- Creating table to store the monthly data

CREATE TABLE may21_tripdata
(
    ride_id VARCHAR,
    rideable_type VARCHAR,
    started_at TIMESTAMP,
    ended_at TIMESTAMP,
    start_station_name VARCHAR,
    start_station_id VARCHAR,
    end_station_name VARCHAR,
    end_station_id VARCHAR,
    start_lat DOUBLE PRECISION,
    start_lng DOUBLE PRECISION,
    end_lat VARCHAR,
    end_lng VARCHAR,
    member_casual VARCHAR
)

-- Duplicating the dataframe for all the other months 

create table jun21_tripdata as (select * from may21_tripdata) with no data;
create table jul21_tripdata as (select * from may21_tripdata) with no data;
create table aug21_tripdata as (select * from may21_tripdata) with no data;
create table sep21_tripdata as (select * from may21_tripdata) with no data;
create table oct21_tripdata as (select * from may21_tripdata) with no data;
create table nov21_tripdata as (select * from may21_tripdata) with no data;
create table dec21_tripdata as (select * from may21_tripdata) with no data;
create table jan22_tripdata as (select * from may21_tripdata) with no data;
create table feb22_tripdata as (select * from may21_tripdata) with no data;
create table mar22_tripdata as (select * from may21_tripdata) with no data;
create table apr22_tripdata as (select * from may21_tripdata) with no data;
```

```TSQL
-- Importing data to the tables created 

COPY may21_tripdata
FROM '/Users/xxxx/Desktop/Divvy/CSV/202105-divvy-tripdata.csv' 
DELIMITER ',' 
CSV HEADER; 

COPY jun21_tripdata
FROM '/Users/xxxx/Desktop/Divvy/CSV/202105-divvy-tripdata.csv' 
DELIMITER ',' 
CSV HEADER; 

COPY jul21_tripdata
FROM '/Users/xxxx/Desktop/Divvy/CSV/202105-divvy-tripdata.csv' 
DELIMITER ',' 
CSV HEADER; 

COPY aug21_tripdata
FROM '/Users/xxxx/Desktop/Divvy/CSV/202105-divvy-tripdata.csv' 
DELIMITER ',' 
CSV HEADER; 

COPY sep21_tripdata
FROM '/Users/xxxx/Desktop/Divvy/CSV/202105-divvy-tripdata.csv' 
DELIMITER ',' 
CSV HEADER; 

COPY oct21_tripdata
FROM '/Users/xxxx/Desktop/Divvy/CSV/202105-divvy-tripdata.csv' 
DELIMITER ',' 
CSV HEADER; 

COPY nov21_tripdata
FROM '/Users/xxxx/Desktop/Divvy/CSV/202105-divvy-tripdata.csv' 
DELIMITER ',' 
CSV HEADER; 

COPY dec21_tripdata
FROM '/Users/xxxx/Desktop/Divvy/CSV/202105-divvy-tripdata.csv' 
DELIMITER ',' 
CSV HEADER;

COPY jan22_tripdata
FROM '/Users/xxxx/Desktop/Divvy/CSV/202105-divvy-tripdata.csv' 
DELIMITER ',' 
CSV HEADER;

COPY feb22_tripdata
FROM '/Users/xxxx/Desktop/Divvy/CSV/202105-divvy-tripdata.csv' 
DELIMITER ',' 
CSV HEADER; 

COPY mar22_tripdata
FROM '/Users/xxxx/Desktop/Divvy/CSV/202105-divvy-tripdata.csv' 
DELIMITER ',' 
CSV HEADER;

COPY apr22_tripdata
FROM '/Users/xxxx/Desktop/Divvy/CSV/202105-divvy-tripdata.csv' 
DELIMITER ',' 
CSV HEADER; 
```

```TSQL
-- Creating a new table to merge all the monthly data into one table 

CREATE TABLE all_trips
(
    ride_id character varying,
    rideable_type character varying,
    started_at timestamp without time zone,
    ended_at timestamp without time zone,
    start_station_name character varying COLLATE pg_catalog."default",
    start_station_id character varying COLLATE pg_catalog."default",
    end_station_name character varying COLLATE pg_catalog."default",
    end_station_id character varying COLLATE pg_catalog."default",
    start_lat double precision,
    start_lng double precision,
    end_lat double precision,
    end_lng double precision,
    member_casual character varying COLLATE pg_catalog."default"
)

-- combine data into one table 
INSERT INTO all_trips (
	SELECT *
	FROM may21_tripdata
	
	UNION ALL 
	
	SELECT *
	from jun21_tripdata
	
	UNION ALL 
	
	SELECT *
	from jul21_tripdata
	
	UNION ALL 
	
	SELECT *
	from aug21_tripdata
	
	UNION ALL 
	
	SELECT *
	from sep21_tripdata
	
	UNION ALL 
	
	SELECT *
	from oct21_tripdata
	
	UNION ALL 
	
	SELECT *
	from nov21_tripdata
	
	UNION ALL 
	
	SELECT *
	from dec21_tripdata
	
	UNION ALL 
	
	SELECT *
	from jan22_tripdata
	UNION ALL 
	
	SELECT *
	from feb22_tripdata
	
	UNION ALL 
	
	SELECT *
	from mar22_tripdata
	
	UNION ALL 
	
	SELECT *
	from apr22_tripdata
	)
	
```


## Processing of Data

I will be adding columns to calculate additional information including ride length and day of week for each individual ride. 

```TSQL
-- adding a new column to calculate the ride length in minutes
ALTER TABLE all_trips 
ADD ride_length int

UPDATE all_trips
SET ride_length = DATE_PART('minute', ended_at - started_at)

-- extracting the day from when journey is started
ALTER TABLE all_trips
ADD day_of_week varchar

UPDATE all_trips
SET day_of_week = TO_CHAR(started_at, 'Day')

```

I will be cleaning the data by removing rows consisting of NULL values 

```TSQL
-- cleaning up data with NULL values
DELETE FROM all_trips
WHERE ride_id IS NULL OR
start_station_name IS NULL OR
member_casual IS NULL OR
ride_length IS NULL OR
ride_length = 0

```
## Analyzing of Data

```TSQL
-- To find out how many members vs casual rider are there
SELECT member_casual,
	COUNT(*) as membership,
	ROUND(COUNT(*) * 100/ (SELECT COUNT(*) FROM all_trips),2) as percentage_of_membership
FROM all_trips
GROUP BY member_casual 
```
Result:
| member_casual | membership | percentage_of_membership |
|---------------|------------|--------------------------|
| "casual"      | 2161152    | 44                       |
| "member"      | 2730555    | 55                       |
