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

For the purpose of this exercise, I will be using PostgreSQL to process the dataset. Visualisations will be done via Tableau, [link to dashboard here](https://public.tableau.com/views/Divvy_16526959743440/DivvyDashboard?:language=en-GB&publish=yes&:display_count=n&:origin=viz_share_link).

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
Data Output:
| member_casual | membership | percentage_of_membership |
|---------------|------------|--------------------------|
| casual        | 2161152    | 44                       |
| member        | 2730555    | 55                       |

```TSQL
-- To find out the number of riders by month and membership 

SELECT month_of_ride,
		COUNT(*) as num_of_users,
		COUNT(*) FILTER (WHERE member_casual = 'member') as num_of_members,
		COUNT(*) FILTER (WHERE member_casual = 'casual') as num_of_casual
FROM all_trips 
GROUP BY month_of_ride
ORDER BY TO_DATE(month_of_ride, 'Month')
```
Data Output:
| month_of_ride | num_of_users | num_of_members | num_of_casual |
|---------------|--------------|----------------|---------------|
| January       | 86237        | 71800          | 14437         |
| February      | 95292        | 78179          | 17113         |
| March         | 232983       | 158776         | 74207         |
| April         | 295305       | 193496         | 101809        |
| May           | 470437       | 242707         | 227730        |
| June          | 639194       | 316425         | 322769        |
| July          | 723912       | 335055         | 388857        |
| August        | 705636       | 345144         | 360492        |
| September     | 653506       | 341532         | 311974        |
| October       | 515110       | 306519         | 208591        |
| November      | 280401       | 199531         | 80870         |
| December      | 193694       | 141391         | 52303         |

```TSQL
-- To find out the number of riders by day of week and membership

SELECT day_of_week, 
		COUNT(*) as num_of_users,
		COUNT(*) FILTER (WHERE member_casual = 'member') as num_of_members,
		COUNT(*) FILTER (WHERE member_casual = 'casual') as num_of_casual
FROM all_trips 
GROUP BY day_of_week
```
Data Output:
| day_of_week | num_of_users | num_of_members | num_of_casual |
|-------------|--------------|----------------|---------------|
| Friday      | 683255       | 380962         | 302293        |
| Monday      | 622004       | 378423         | 243581        |
| Saturday    | 860739       | 373438         | 487301        |
| Sunday      | 742875       | 327091         | 415784        |
| Thursday    | 661898       | 412340         | 249558        |
| Tuesday     | 649940       | 425227         | 224713        |
| Wednesday   | 670996       | 433074         | 237922        |

```TSQL
-- To find out the average length for each ride by day of week and membership

SELECT day_of_week,
		AVG(ride_length) as avg_length_users,
		AVG(ride_length) FILTER (WHERE member_casual = 'member') as avg_length_members,
		AVG(ride_length) FILTER (WHERE member_casual = 'casual') as avg_length_casual
FROM all_trips
GROUP BY day_of_week

```
Data Output:
| day_of_week | avg_length_users | avg_length_members | avg_length_casual |
|-------------|------------------|--------------------|-------------------|
| Friday      | 14.2741187       | 11.5876964         | 17.659658         |
| Monday      | 14.1831885       | 11.4688669         | 18.4001092        |
| Saturday    | 16.8758811       | 13.2005822         | 19.6924078        |
| Sunday      | 17.1786101       | 13.4127598         | 20.1411478        |
| Thursday    | 13.3232658       | 11.2764345         | 16.7052068        |
| Tuesday     | 13.0580161       | 11.1246134         | 16.7166163        |
| Wednesday   | 13.2840777       | 11.3561724         | 16.7933188        |


```TSQL

-- Top find out the most popular ride type by membership

SELECT rideable_type, 
		COUNT(*) as num_of_users,
		COUNT(*) FILTER (WHERE member_casual = 'member') as num_of_members,
		COUNT(*) FILTER (WHERE member_casual = 'casual') as num_of_casual
FROM all_trips
GROUP BY rideable_type

```
Data Output:
| rideable_type | num_of_users | num_of_members | num_of_casual |
|---------------|--------------|----------------|---------------|
| classic_bike  | 3156681      | 1938824        | 1217857       |
| docked_bike   | 287506       | 0              | 287506        |
| electric_bike | 1447520      | 791731         | 655789        |

```TSQL
-- To find out the top 10 most popular start station

SELECT start_station_name, count(*) as num_of_users
FROM all_trips 
GROUP BY start_station_name
ORDER BY count(*) DESC
LIMIT 10
```

Data Output:
| start_station_name       | num_of_users |
|--------------------------|--------------|
| Streeter Dr & Grand Ave  | 82994        |
| Wells St & Concord Ln    | 43184        |
| Michigan Ave & Oak St    | 42599        |
| Millennium Park          | 40887        |
| Clark St & Elm St        | 40323        |
| Wells St & Elm St        | 37047        |
| Kingsbury St & Kinzie St | 35192        |
| Theater on the Lake      | 34926        |
| Wabash Ave & Grand Ave   | 32694        |
| Clark St & Lincoln Ave   | 32289        |

## Visualisations on Tableau
Visualisations have been created to share my key findings in the differences in behaviour between casual and member riders. Full dashboard can be found [here](https://public.tableau.com/views/Divvy_16526959743440/DivvyDashboard?:language=en-GB&publish=yes&:display_count=n&:origin=viz_share_link)

**# of Riders by Month**

The trend for both casual and member riders are quite consistent with a peak in riders during the May to August period. While, there is a huge dip in riders during the November to January period. 

This can be caused by the change in seasonailty where most people are more willing to ride during the Summer period, hence promotion to entice any form of sign-ups should be considered during that period. 

![Monthly Riders](https://github.com/dilyswoo/cyclistic-bike-share/blob/51a9fb6db2a9c809439907bed6132b5c8602efe8/tableau-visualisations/Monthly_Riders.png)

**# of Riders by Day of Week**

There are more member riders during weekdays as compared to the weekends, while there is an inverse relationship for casual riders, as there are more riders during weekend than weekday.

This can be due to the member riders are using the bicycle to commute to work hence the decrease in activity during the weekend.

![Weekly_Riders](https://github.com/dilyswoo/cyclistic-bike-share/blob/51a9fb6db2a9c809439907bed6132b5c8602efe8/tableau-visualisations/Weekly_Riders.png)

**Average ride length by Day of Week**

Casual riders have a longer ride length than member riders through out the week. However, both member and casual riders have a longer ride during the weekend. 

![ride_length](https://github.com/dilyswoo/cyclistic-bike-share/blob/51a9fb6db2a9c809439907bed6132b5c8602efe8/tableau-visualisations/Ride_length.png)

**# of Riders by Rideable Type**

Both casual and member riders uses classic bike the most while member riders does not use docked bike at all.

![ride_length](https://github.com/dilyswoo/cyclistic-bike-share/blob/51a9fb6db2a9c809439907bed6132b5c8602efe8/tableau-visualisations/Ride_type.png)

**Top 10 station**
Streeter Dr & Grand Ave is the most popular station amongst both casual and member riders. 

![top10_station](https://github.com/dilyswoo/cyclistic-bike-share/blob/51a9fb6db2a9c809439907bed6132b5c8602efe8/tableau-visualisations/Top10_station.png)

## Conclusion

**Key Findings**
- The trend for both casual and member riders are quite consistent with a peak in riders during the May to August period. While, there is a huge dip in riders during the November to January period. 
- There are more member riders during weekdays as compared to the weekends, while there is an inverse relationship for casual riders, as there are more riders during weekend than weekday.
-Casual riders have a longer ride length than member riders through out the week. However, both member and casual riders have a longer ride during the weekend. 
-Both casual and member riders uses classic bike the most while member riders does not use docked bike at all.
-Streeter Dr & Grand Ave is the most popular station amongst both casual and member riders. 

**Key Recommendations**
Below are some recommendations to support the key objective of converting casual riders into annual members
- Summer is the most popular period for both casual and member riders, hence any marketing activities should be done during this period to encourage membership sales 
- To run special promotion during the weekday period for casual members to encourage the use the service on weekday. This will help to raise awareness for the convenience of the service and encourage sign-ups as annual members 
- Casual riders typically have a longer ride length than member riders, to provide a tier of membership that encourages longer rider length with exclusive discounts for casual members to sign up as members 
