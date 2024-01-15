-- ========================================================================================
-- Copyright (C) 2022 by Georgios Ioannou
--
-- FILE: GEORGIOS_IOANNOU_Project_1_Organized.sql
--
-- Written by: Georgios Ioannou, 2022
-- ========================================================================================

CREATE DATABASE service_request_of_311_from_2010_to_present_organized;

USE service_request_of_311_from_2010_to_present_organized;

CREATE TABLE agency(
	agency_id SMALLINT UNSIGNED,
    acronym   VARCHAR(50) NOT NULL,
    na_me     VARCHAR(200) NOT NULL,
    PRIMARY KEY(agency_id)
);

CREATE TABLE complaint(
	complaint_id           INT UNSIGNED,
    ty_pe                  VARCHAR(500) NOT NULL,
    descriptor             VARCHAR(500),
    due_date               DATETIME,
    open_data_channel_type VARCHAR(10) NOT NULL,
    PRIMARY KEY(complaint_id)
);

CREATE TABLE resolution(
	resolution_id MEDIUMINT UNSIGNED,
    updated_date  DATETIME,
    descri_ption  VARCHAR(1000),
    sta_tus       VARCHAR(20) NOT NULL,
    PRIMARY KEY(resolution_id)
);

CREATE TABLE incident(
	incident_id INT UNSIGNED,
    zip         VARCHAR(15),
    address     VARCHAR(100),
    street_name VARCHAR(100),
    PRIMARY KEY(incident_id)
);

CREATE TABLE cross_street(
	cross_street_id INT UNSIGNED,
    cross_street_1  VARCHAR(50),
    cross_street_2  VARCHAR(50),
    PRIMARY KEY(cross_street_id)
);

CREATE TABLE intersection_street(
	intersection_street_id INT UNSIGNED,
    intersection_street_1  VARCHAR(100),
    intersection_street_2  VARCHAR(100),
    PRIMARY KEY(intersection_street_id)
);

CREATE TABLE community_district(
	community_district_id INT UNSIGNED,
    borough               VARCHAR(30),
    community_board       VARCHAR(30),
    city                  VARCHAR(30),
    PRIMARY KEY(community_district_id)
);

CREATE TABLE park(
	park_id                  MEDIUMINT UNSIGNED,
    facility_name            VARCHAR(150) NOT NULL,
    in_community_district_id INT UNSIGNED,
    PRIMARY KEY(park_id),
    FOREIGN KEY(in_community_district_id) REFERENCES community_district(community_district_id)
);

CREATE TABLE scene(
	scene_id             INT UNSIGNED,
    location_type        VARCHAR(50),
    address_type         VARCHAR(20),
    facility_type        VARCHAR(100),
    landmark             VARCHAR(100),
    bbl                  VARCHAR(30),
    description_park_id  MEDIUMINT UNSIGNED,
    PRIMARY KEY(scene_id),
    FOREIGN KEY(description_park_id) REFERENCES park(park_id)
);

-- The State Plane Coordinate System is always positive inside each zone.
CREATE TABLE coordinate_state_plane(
	coordinate_state_plane_id INT UNSIGNED,
    x_coordinate_state_plane  INT UNSIGNED,
    y_coordinate_state_plane  INT UNSIGNED,
    PRIMARY KEY(coordinate_state_plane_id)
);

CREATE TABLE coordinate_location(
	coordinate_location_id INT UNSIGNED,
    lattitude              DOUBLE,
    longitude              DOUBLE,
    lat_lng                POINT,
    PRIMARY KEY(coordinate_location_id)
);

CREATE TABLE address(
	address_id                         INT UNSIGNED,
    location_incident_id               INT UNSIGNED,
    location_cross_street_id           INT UNSIGNED,
    location_intersection_street_id    INT UNSIGNED,
    description_scene_id               INT UNSIGNED,
    in_community_district_id           INT UNSIGNED,
    location_coordinate_state_plane_id INT UNSIGNED,
    location_coordinate_location_id    INT UNSIGNED,
    PRIMARY KEY(address_id),
    FOREIGN KEY(location_incident_id)               REFERENCES incident(incident_id),
    FOREIGN KEY(location_cross_street_id)           REFERENCES cross_street(cross_street_id),
    FOREIGN KEY(location_intersection_street_id)    REFERENCES intersection_street(intersection_street_id),
    FOREIGN KEY(description_scene_id)               REFERENCES scene(scene_id),
    FOREIGN KEY(in_community_district_id)           REFERENCES community_district(community_district_id),
    FOREIGN KEY(location_coordinate_state_plane_id) REFERENCES coordinate_state_plane(coordinate_state_plane_id),
    FOREIGN KEY(location_coordinate_location_id)    REFERENCES coordinate_location(coordinate_location_id)
);

CREATE TABLE taxi(
	taxi_id         INT UNSIGNED,
    vehicle_type    VARCHAR(20),
    company_borough VARCHAR(20),
    pickup_location VARCHAR(100),
    PRIMARY KEY(taxi_id)
);

CREATE TABLE bridge_highway(
	bridge_highway_id INT UNSIGNED,
    na_me             VARCHAR(100),
    direction         VARCHAR(100),
    road_ramp         VARCHAR(10),
    segment           VARCHAR(200),
    PRIMARY KEY(bridge_highway_id)
);

CREATE TABLE service_request(
	unique_key                       INT UNSIGNED,
    created_date                     DATETIME NOT NULL,
    closed_date                      DATETIME,
    assigned_agency_id               SMALLINT UNSIGNED NOT NULL,
    description_complaint_id         INT UNSIGNED NOT NULL,
    resolved_resolution_id           MEDIUMINT UNSIGNED,
    location_address_id              INT UNSIGNED NOT NULL,
    identification_taxi_id           INT UNSIGNED,
    identification_bridge_highway_id INT UNSIGNED,
    PRIMARY KEY(unique_key),
    FOREIGN KEY(assigned_agency_id)               REFERENCES agency(agency_id),
    FOREIGN KEY(description_complaint_id)         REFERENCES complaint(complaint_id),
    FOREIGN KEY(resolved_resolution_id)           REFERENCES resolution(resolution_id),
	FOREIGN KEY(location_address_id)              REFERENCES address(address_id),
    FOREIGN KEY(identification_taxi_id)           REFERENCES taxi(taxi_id),
	FOREIGN KEY(identification_bridge_highway_id) REFERENCES bridge_highway(bridge_highway_id)
);

INSERT INTO agency
VALUES (1, 'DEP', 'Department of Environmental Protection'),
       (2, 'DOB', 'Department of Buildings'),
       (3, 'DOHMH', 'Department of Health and Mental Hygiene'),
       (4, 'DOITT', 'Department of Information Technology and Telecommunications'),
       (5, 'DOT', 'Department of Transportation'),
       (6, 'DPR', 'Department of Parks and Recreation'),
       (7, 'DSNY', 'Department of Sanitation'),
       (8, 'HPD', 'Department of Housing Preservation and Development'),
       (9, 'MAYOR\'S OFFICE OF SPECIAL ENFORCEMENT', 'Mayor\'s Office of Special Enforcement' ),
       (10, 'NYPD', 'New York City Police Department');

INSERT INTO complaint
VALUES (1, 'Sidewalk Condition', 'Broken Sidewalk', NULL, 'MOBILE'),
	   (2, 'Sidewalk Condition', 'Sidewalk Violation', NULL, 'ONLINE'),
       (3, 'NonCompliance with Phased Reopening', 'Business not in compliance', NULL, 'PHONE'),
       (4, 'Noise - Residential', 'Loud Music/Party', NULL, 'ONLINE'),
       (5, 'Industrial Waste', 'Wastewater Into Catch Basin (IEB)', NULL, 'PHONE'),
       (6, 'Homeless Street Condition', 'N/A', NULL, 'ONLINE'),
       (7, 'HEAT/HOT WATER', 'APARTMENT ONLY', NULL, 'PHONE'),
       (8, 'Missed Collection (All Materials)', '1R Missed Recycling-All Materials', NULL, 'ONLINE'),
       (9, 'Public Payphone Complaint', 'Graffiti/Litter on Phone', NULL, 'ONLINE'),
       (10, 'Derelict Vehicles', 'Derelict Vehicles', NULL, 'ONLINE'),
       (11, 'Derelict Vehicles', 'Derelict Vehicles', NULL, 'PHONE');

INSERT INTO resolution
VALUES (1, '2020-11-02 10:56:00', 'The request submitted did not have sufficient information for the Department of Transportation to respond.', 'Closed'),
       (2, '2020-11-06 06:56:00', 'A sidewalk dismissal inspection (work done by owner) has been scheduled. Department of Transportation is in direct contact with the responsible party.', 'Closed'),
       (3, '2020-10-30 18:20:00', 'The Department of Sanitation picked up the items and determined that the missed collection complaint was not warranted.', 'Closed'),
       (4, '2020-10-29 23:29:00', 'The Police Department responded to the complaint and with the information available observed no evidence of the violation at that time.', 'Closed'),
       (5, '2020-07-10 10:21:00', 'The Police Department responded to the complaint and determined that police action was not necessary.', 'Closed'),
       (6, '2021-01-03 12:11:00', 'The Police Department responded to the complaint but officers were unable to gain entry into the premises.', 'Closed'),
       (7, '2021-12-10 19:10:00', 'The Department of Transportation inspected this complaint and repaired the problem.', 'Pending'),
       (8, '2022-01-19 03:10:00', 'NYC Parks has inspected the location and will perform work to correct the condition.   Under NYC Parks Tree Risk Management Program, all trees under the agency\'s jurisdiction are assessed for risk, and work is prioritized to address the conditions with the highest risk first.  For more information about the program, visit the NYC Urban Forest page on the NYC Parks website at nyc.gov/parks/trees.   To learn more about the trees in your neighborhood, view the NYC Tree Map at nyc.gov/parks/treemap.', 'In Progress'),
       (9, '2021-12-30 09:50:00', 'NYC Parks reviewed this request and will visit the location to investigate the condition.  Under NYC Parks Tree Risk Management Program, all trees under the agency\'s jurisdiction are assessed for risk, and work is prioritized to address the conditions with the highest risk first.  For more information about the Tree Risk Management Program, visit the NYC Urban Forest page on the NYC Parks website at nyc.gov/parks/trees.   To learn more about the trees in your neighborhood, visit the NYC Tree Map at nyc.gov/parks/treemap.', 'In Progress'),
       (10, '2022-03-19 07:10:00', 'The Department of Health and Mental Hygiene has sent official written documentation to the Owner/Landlord warning them of potential violations and instructing them to correct the situation. If the situation persists 21 days after your initial complaint, please log another complaint.', 'In Progress');

INSERT INTO incident
VALUES (1, '10002', '106 RIVINGTON STREET', 'RIVINGTON STREET'),
       (2, '12313', '3083 WEBSTER AVENUE', 'WEBSTER AVENUE'),
       (3, '11921', '110 25 STREET', '25 STREET'),
       (4, '10201', '672 ST NICHOLAS AVENUE', 'ST NICHOLAS AVENUE'),
       (5, '15421', '43-17 48 STREET', '48 STREET'),
       (6, '10312', '700 WEST  175 STREET', 'WEST  175 STREET'),
       (7, '13485', '534 WEST   47 STREET', 'WEST   47 STREET'),
       (8, '15361', '1890 JEROME AVENUE', 'JEROME AVENUE'),
       (9, '12863', '3801 REVIEW PLACE', 'REVIEW PLACE'),
       (10, '10393', '225 WEST   44 STREET', 'WEST   44 STREET');

INSERT INTO cross_street
VALUES (1, 'LUDLOW STREET', 'ESSEX STREET'),
       (2, 'EAST  202 STREET', 'EAST  203 STREET'),
       (3, NULL, '3 AVENUE'),
       (4, NULL, NULL),
       (5, 'WEST  141 STREET', 'WEST  145 STREET'),
       (6, 'AMTRAK-NORTHEAST LINE', '11 AVENUE'),
       (7, 'SHUBERT ALLEY', '8 AVENUE'),
       (8, '75 STREET', '78 AVENUE'),
       (9, 'ATLANTIC OCEAN', 'BEACH 110 ST'),
       (10, 'LINCOLN AVENUE', 'GREELEY AVENUE');

INSERT INTO intersection_street
VALUES (1, 'LUDLOW STREET', 'ESSEX STREET'),
       (2, 'EAST  202 STREET', 'EAST  203 STREET'),
       (3, 'DEAD END', '3 AVENUE'),
       (4, NULL, NULL),
       (5, 'WEST  141 STREET', 'WEST  145 STREET'),
       (6, 'AMTRAK-NORTHEAST LINE', '11 AVENUE'),
       (7, 'SHUBERT ALLEY', '8 AVENUE'),
       (8, '75 STREET', '78 AVENUE'),
       (9, NULL, NULL),
       (10, NULL, NULL);

INSERT INTO community_district
VALUES (1, 'MANHATTAN', '03 MANHATTAN', 'NEW YORK'),
       (2, 'BRONX', '07 BRONX', 'BRONX'),
       (3, 'BROOKLYN', '07 BROOKLYN', 'BROOKLYN'),
       (4, 'QUEENS', '09 QUEENS', 'WOODHAVEN'),
       (5, 'QUEENS', '05 QUEENS', 'SUNNYSIDE'),
       (6, 'MANHATTAN', '09 MANHATTAN', 'NEW YORK'),
       (7, NULL, NULL, NULL),
       (8, 'STATEN ISLAND', '03 STATEN ISLAND', 'STATEN ISLAND'),
       (9, 'Unspecified', '0 Unspecified', NULL),
       (10, 'QUEENS', '07 QUEENS', 'FLUSHING');

INSERT INTO park
VALUES (1, 'Unspecified', 1),
       (2, 'Unspecified', 1),
       (3, 'Unspecified', 1),
       (4, 'Unspecified', 7),
       (5, 'Police Officer Nicholas Demutiis Park', 4),
       (6, 'Juniper Valley Park', 5),
       (7, 'Luther Gulick Park', 1),
       (8, 'Unspecified', 10),
       (9, 'Unspecified', 9),
       (10, 'Unspecified', 7);

INSERT INTO scene
VALUES (1, 'Sidewalk', NULL, 'DSNY Garage', 'RIVINGTON STREET', '1004110072', NULL),
       (2, 'Sidewalk', NULL, 'DSNY Garage', 'WEBSTER AVENUE', '2033310057', NULL),
       (3, 'RESIDENTIAL BUILDING', 'ADDRESS', NULL, '25 STREET', '1020510039', NULL),
       (4, '3+ Family Apt. Building', 'ADDRESS', NULL, 'ST NICHOLAS AVENUE', '4001390011', NULL),
       (5, NULL, 'BLOCKFACE', NULL, '48 STREET', '1021420237', NULL),
       (6, 'RESIDENTIAL BUILDING', 'ADDRESS', NULL, 'WEST  175 STREET', '1010750049', NULL),
       (7, 'Sidewalk', 'INTERSECTION', NULL, 'WILSON AVENUE', '2028520009', NULL),
       (8, NULL, NULL, NULL, 'NEWBURG STREET', NULL, 5),
       (9, NULL, NULL, NULL, 'NORTH   12 STREET', NULL, 7),
       (10, 'Street', 'ADDRESS', 'DSNY Garage', 'LEXINGTON AVENUE', '2046880028', NULL);

INSERT INTO coordinate_state_plane
VALUES (1, 987580, 201583),
       (2, 1018024, 256467),
       (3, 984129, 180430),
       (4, 999417, 239154),
       (5, 1007369, 210445),
       (6, 1001211, 247589),
       (7, 985786, 217382),
       (8, 1008932, 248922),
       (9, 1011998, 261701),
       (10, 987721, 215423);

INSERT INTO coordinate_location
VALUES (1, 40.71997487, -73.98798692, Point(40.71997487, -73.98798692)),
       (2, 40.87055254, -73.87788324, Point(40.87055254, -73.87788324)),
       (3, 40.66191539, -74.00043613, Point(40.66191539, -74.00043613)),
       (4, 40.82308505, -73.94519976, Point(40.82308505, -73.94519976)),
       (5, 40.74426929, -73.91656702, Point(40.74426929, -73.91656702)),
       (6, 40.84623342, -73.93869649, Point(40.84623342, -73.93869649)),
       (7, 40.76333968, -73.99445522, Point(40.76333968, -73.99445522)),
       (8, 40.8498739, -73.91078497, Point(40.8498739, -73.91078497)),
       (9, 40.88493924, -73.89964977, Point(40.88493924, -73.89964977)),
       (10, 40.75796218, -73.98747111, Point(40.75796218, -73.98747111));

INSERT INTO address
VALUES (1, 1, 1, 1, 1, 1, 1, 1),
       (2, 2, 2, 2, 2, 2, 2, 2),
       (3, 3, 3, 3, 3, 3, 3, 3),
       (4, 4, 4, 4, 4, 4, 4, 4),
       (5, 5, 5, 5, 5, 5, 5, 5),
       (6, 6, 6, 6, 6, 6, 6, 6),
       (7, 7, 7, 7, 7, 7, 7, 7),
       (8, 8, 8, 8, 8, 8, 8, 8),
       (9, 9, 9, 9, 9, 9, 9, 9),
       (10, 10, 10, 10, 10, 10, 10, 10);

INSERT INTO taxi
VALUES (1, NULL, NULL, '3912 9 AVENUE BROOKLYN'),
       (2, NULL, NULL, '331 EAST HOUSTON STREET MANHATTAN'),
       (3, NULL, 'MANHATTAN', '61 MACDOUGAL STREET BROOKLYN'),
       (4, NULL, 'QUEENS', '21 STREET AND 44 DRIVE'),
       (5, NULL, 'BROOKLYN', '213 HESTER STREET MANHATTAN'),
       (6, 'Car Service', NULL, NULL),
       (7, 'Car Service', 'BRONX', '2 PENN PLAZA, MANHATTAN (NEW YORK), NY, 10121'),
       (8, 'Car Service', NULL, '405 EAST   56 STREET, MANHATTAN (NEW YORK), NY, 10022'),
       (9, 'Car Service', 'STATEN ISLAND', '73 GORDON STREET, STATEN IS (STATEN ISLAND), NY, 10304'),
       (10, NULL, 'MANHATTAN', '35-34 29 STREET QUEENS');

INSERT INTO bridge_highway
VALUES (1, 'BQE/Gowanus Expwy', 'East/Bronx Bound', 'Ramp', 'Eastern Long Is Riverhead (Exit 35E)'),
       (2, 'FDR Dr', 'Northbound/Uptown', 'Roadway', 'E 96 St (Exit 14) - RFK Bridge Bruckner Expwy Grand Central Pkwy (Exit 17)'),
       (3, 'BQE/Gowanus Expwy', 'East/Queens Bound', 'Roadway', 'Williamsburg Br / Metropolitan Ave (Exit 32) - McGuinness Blvd / Humboldt St (Exit 33)'),
       (4, 'Harlem River Dr', 'North/Bronx Bound', 'Roadway', 'W. 155th St 8th Ave. (Exit 23) - Amsterdam Ave. W. 179th St. (Exit 24)'),
       (5, 'FDR Southbound', 'South Bound', 'N/A', 'N/A'),
       (6, 'Henry Hudson Pkwy/Rt 9A', 'South/Downtown', 'Roadway', 'W 79 St (Exit 10) - W 57 St'),
       (7, NULL, NULL, NULL, '1-1-1724395713'),
       (8, 'Belt Pkwy', 'West/Staten Island Bound', 'Ramp', 'Rockaway Pkwy (Exit 13)'),
       (9, 'Cross Bronx Expwy', 'North/Westbound (To GW Br)', 'Roadwa', 'Whitestone Br (I-678) (Exit 6A) - Cross Bronx Expwy Extension (I-295) (Exit 6B)'),
       (10, 'Staten Island Expwy', 'Westbound/To Goethals Br', 'Roadway', 'Bradley Ave (Exit 11) - Victory Blvd (Exit 10)');

INSERT INTO service_request
VALUES (48015282, '2020-11-02 09:56:00', '2020-11-02 10:56:00', 5, 1, 1, 1, NULL, NULL),
       (48015298, '2020-11-06 03:56:00', '2020-11-06 06:56:00', 5, 2, 2, 2, NULL, NULL),
       (48015307, '2020-10-30 17:10:00', '2020-10-30 18:20:00', 10, 3, 3, 3, NULL, NULL),
       (48015316, '2020-10-29 23:20:00', '2020-10-29 23:29:00', 9, 4, 4, 4, NULL, 9),
       (48015318, '2020-07-10 05:21:00', '2020-07-10 10:21:00', 6, 5, 5, 5, NULL, NULL),
       (48015319, '2021-01-03 12:00:00', '2021-01-03 12:11:00', 6, 6, 6, 6, NULL, NULL),
       (48015320, '2021-12-10 19:00:00', NULL, 6, 7, NULL, 7, 1, NULL),
       (48015322, '2022-01-19 02:07:00', NULL, 1, 8, NULL, 8, 7, NULL),
       (48015345, '2021-12-30 09:30:00', NULL, 7, 11, NULL, 9, NULL, 1),
       (48015481, '2022-03-19 07:03:00', NULL, 9, 10, NULL, 10, NULL, 3);

SELECT * FROM agency;
SELECT * FROM complaint;
SELECT * FROM resolution;
SELECT * FROM incident;
SELECT * FROM cross_street;
SELECT * FROM intersection_street;
SELECT * FROM community_district;
SELECT * FROM park;
SELECT * FROM scene;
SELECT * FROM coordinate_state_plane;
SELECT * FROM coordinate_location;
SELECT * FROM address;
SELECT * FROM taxi;
SELECT * FROM bridge_highway;
SELECT * FROM service_request;