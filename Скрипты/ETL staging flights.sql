insert into stg_16.flights
(year, quarter, month,
flight_date, dep_time, crs_dep_time, 
air_time, dep_delay_minutes, cancelled, 
cancellation_code, weather_delay, reporting_airline,
tail_number, flight_number, distance,
origin, dest)

with etl_cte as
(select *, max(processed_dttm) over (partition by fl_date, op_carrier_fl_num, origin, dest, crs_dep_time) as last_processed from ods_16.flights)
select 
year, quarter, month,
fl_date, dep_time, crs_dep_time,
air_time, dep_delay_new, cancelled,
cancellation_code, weather_delay, op_unique_carrier,
tail_num, op_carrier_fl_num, distance,
origin, dest
from etl_cte
where processed_dttm = last_processed
on conflict(flight_date, flight_number, origin, dest, crs_dep_time) do update
set year = excluded.year,
quarter = excluded.quarter,
month = excluded.month,
flight_date = excluded.flight_date,
dep_time = excluded.dep_time,
crs_dep_time = excluded.crs_dep_time,
air_time = excluded.air_time,
dep_delay_minutes = excluded.dep_delay_minutes,
cancelled = excluded.cancelled,
cancellation_code = excluded.cancellation_code,	
weather_delay = excluded.weather_delay,
reporting_airline = excluded.reporting_airline,
tail_number = excluded.tail_number,
flight_number = excluded.flight_number,
distance = excluded.distance,
origin = excluded.origin,
dest = excluded.dest,
processed_dttm = now()

