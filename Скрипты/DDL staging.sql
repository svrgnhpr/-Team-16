CREATE TABLE stg_16.weather (
	icao_code varchar(10) NOT NULL,
	local_datetime timestamp NOT NULL,
	t_air_temperature numeric(3, 1) NULL,
	p0_sea_lvl numeric(4, 1) NULL,
	p_station_lvl numeric(4, 1) NOT NULL,
	u_humidity int4 NULL,
	dd_wind_direction varchar(100) NULL,
	ff_wind_speed int4 NULL,
	ff10_max_gust_value int4 NULL,
	ww_present varchar(100) NULL,
	ww_recent varchar(50) NULL,
	c_total_clouds varchar(200) NOT NULL,
	vv_horizontal_visibility numeric(3, 1) NOT NULL,
	td_temperature_dewpoint numeric(3, 1) NULL,
	processed_dttm timestamp NOT NULL DEFAULT now(),
	PRIMARY KEY (icao_code, local_datetime)
); 


CREATE TABLE stg_16.flights (
	year int NOT NULL,
	quarter int NULL,
	month int NOT NULL,
	flight_date date NOT NULL,
	dep_time time NULL,
	crs_dep_time time NOT NULL,
	air_time float NULL,
	dep_delay_minutes float NULL,
	cancelled int NOT NULL,
	cancellation_code char(1) NULL,
	weather_delay float NULL,
	reporting_airline varchar(10) NULL,
	tail_number varchar(10) NULL,
	flight_number varchar(15) NOT NULL,
	distance float NULL,
	origin varchar(10) NULL,
	dest varchar(10) NULL,
	processed_dttm timestamp default(now()),
	CONSTRAINT flights_pkey PRIMARY KEY (flight_date, flight_number, origin, dest, crs_dep_time)
);