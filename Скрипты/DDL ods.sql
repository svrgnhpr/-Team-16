CREATE TABLE ods_16.weather (
	local_datetime varchar(25) NOT NULL,
	t numeric(3, 1) NULL,
	p0 numeric(4, 1) NULL,
	p numeric(4, 1) NOT NULL,
	u int4 NULL,
	dd varchar(100) NULL,
	ff int4 NULL,
	ff10 int4 NULL,
	ww_present varchar(100) NULL,
	ww_recent varchar(50) NULL,
	c varchar(200) NOT NULL,
	vv numeric(3, 1) NOT NULL,
	td numeric(3, 1) NULL,
	processed_dttm timestamp NOT NULL DEFAULT now(),
); 


CREATE TABLE ods_16.flights (
	year int NOT NULL,
	quarter int NULL,
	month int NOT NULL,
	fl_date date NOT NULL,
	dep_time time NULL,
	crs_dep_time time NOT NULL,
	air_time float NULL,
	dep_delay_new float NULL,
	cancelled int NOT NULL,
	cancellation_code char(1) NULL,
	weather_delay float NULL,
	op_unique_carrier varchar(10) NULL,
	tail_num varchar(10) NULL,
	op_carrier_fl_num varchar(15) NOT NULL,
	distance float NULL,
	origin varchar(10) NULL,
	dest varchar(10) NULL,
	processed_dttm timestamp default(now())
);