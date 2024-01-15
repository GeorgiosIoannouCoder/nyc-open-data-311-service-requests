-- ========================================================================================
-- Copyright (C) 2022 by Georgios Ioannou
--
-- FILE: GEORGIOS_IOANNOU_Project_1_Original.sql
--
-- Written by: Georgios Ioannou, 2022
-- ========================================================================================

CREATE DATABASE service_request_of_311_from_2010_to_present_unorganized;

USE service_request_of_311_from_2010_to_present_unorganized;

CREATE TABLE service_request(
	unique_key INT,
    created_date VARCHAR(200) NOT NULL,
    closed_date VARCHAR(200),
    agency VARCHAR(50) NOT NULL,
    agency_name VARCHAR(200) NOT NULL,
    complaint_type VARCHAR(500) NOT NULL,
	descriptor VARCHAR(500),
    location_type VARCHAR(50),
    incident_zip VARCHAR(15),
	incident_address VARCHAR(100),
    street_name VARCHAR(100),
    cross_street_1 VARCHAR(50),
    cross_street_2 VARCHAR(50),
    intersection_street_1 VARCHAR(50),
    intersection_street_2 VARCHAR(50),
    address_type VARCHAR(20),
	city VARCHAR(30),
	landmark VARCHAR(100),
	facility_type VARCHAR(100),
	sta_tus VARCHAR(20) NOT NULL,
	due_date VARCHAR(200),
	resolution_description VARCHAR(1000),
	resolution_action_updated_date VARCHAR(200),
	community_board VARCHAR(30),
	bbl VARCHAR(30),
	borough VARCHAR(30),
    x_coordinate_state_plane VARCHAR(30),
    y_coordinate_state_plane VARCHAR(30),
	open_data_channel_type VARCHAR(10) NOT NULL,
    park_facility_name VARCHAR(150) NOT NULL,
    park_borough VARCHAR(30),
    vehicle_type VARCHAR(20),
    taxi_company_borough VARCHAR(20),
    taxi_pickup_location VARCHAR(100),
    bridge_highway_name VARCHAR(100),
	bridge_highway_direction VARCHAR(100),
	road_ramp VARCHAR(10),
    bridge_highway_segment VARCHAR(200),
    latitude VARCHAR(30),
    longitude VARCHAR(30),
    location VARCHAR(100),
    PRIMARY KEY(unique_key)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/GEORGIOS_IOANNOU_Project_1.csv' 
INTO TABLE service_request 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 28218 ROWS;

SELECT * FROM service_request;