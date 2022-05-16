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

```TSQL

