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
