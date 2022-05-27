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

-- extracting the month from when journey is started
ALTER TABLE all_trips
ADD month_of_ride varchar

UPDATE all_trips
SET month_of_ride  = TO_CHAR(started_at, 'Month')

-- cleaning up data with NULL values
DELETE FROM all_trips
WHERE ride_id IS NULL OR
start_station_name IS NULL OR
member_casual IS NULL OR
ride_length IS NULL OR
ride_length = 0

-- To find out how many members vs casual rider are there
SELECT member_casual,
	COUNT(*) as membership,
	ROUND(COUNT(*) * 100/ (SELECT COUNT(*) FROM all_trips),2) as percentage_of_membership
FROM all_trips
GROUP BY member_casual 

-- To find out the number of riders by month and membership 

SELECT month_of_ride,
		COUNT(*) as num_of_users,
		COUNT(*) FILTER (WHERE member_casual = 'member') as num_of_members,
		COUNT(*) FILTER (WHERE member_casual = 'casual') as num_of_casual
FROM all_trips 
GROUP BY month_of_ride
ORDER BY TO_DATE(month_of_ride, 'Month')

-- To find out the number of riders by day of week and membership

SELECT day_of_week, 
		COUNT(*) as num_of_users,
		COUNT(*) FILTER (WHERE member_casual = 'member') as num_of_members,
		COUNT(*) FILTER (WHERE member_casual = 'casual') as num_of_casual
FROM all_trips 
GROUP BY day_of_week
ORDER BY TO_DATE(day_of_week, 'Day') ASC

-- To find out the average length for each ride by day of week and membership

SELECT day_of_week,
		AVG(ride_length) as avg_length_users,
		AVG(ride_length) FILTER (WHERE member_casual = 'member') as avg_length_members,
		AVG(ride_length) FILTER (WHERE member_casual = 'casual') as avg_length_casual
FROM all_trips
GROUP BY day_of_week

-- Top find out the most popular ride type by membership

SELECT rideable_type, 
		COUNT(*) as num_of_users,
		COUNT(*) FILTER (WHERE member_casual = 'member') as num_of_members,
		COUNT(*) FILTER (WHERE member_casual = 'casual') as num_of_casual
FROM all_trips
GROUP BY rideable_type

-- To find out the top 10 most popular start station

SELECT start_station_name, count(*) as num_of_users
FROM all_trips 
GROUP BY start_station_name
ORDER BY count(*) DESC
LIMIT 10
