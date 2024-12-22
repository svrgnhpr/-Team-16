insert into dds_16.flights
with etl_cte1 as (
select year, quarter, month, flight_date,
(date_add(flight_date + crs_dep_time, dep_delay_minutes * interval '1 minute'))::date as flight_actual_date,
flight_date + crs_dep_time as flight_dep_scheduled_ts,
date_add(flight_date + crs_dep_time, dep_delay_minutes * interval '1 minute') as flight_dep_actual_ts,
reporting_airline, tail_number, flight_number, 
origin, dest, dep_delay_minutes, 
cancelled, cancellation_code, weather_delay, 
air_time, distance, processed_dttm,
max(processed_dttm) over (partition by flight_date, flight_number, origin, dest, crs_dep_time) as last_processed
from stg_16.flights f
where origin = 'EYW' or dest = 'EYW'),
etl_cte2 as (select iata_code, id as airport_dk from dds_16.airports air
group by 1,2)
select year, quarter, month, 
flight_date as flight_scheduled_date,
flight_actual_date, flight_dep_scheduled_ts,
flight_dep_actual_ts,
reporting_airline as report_airline, 
tail_number, 
flight_number as flight_number_reporting_airline,
t2.airport_dk as airport_origin_dk, 
origin as origin_code, 
t3.airport_dk as airport_dest_dk, 
dest as dest_code, 
dep_delay_minutes, cancelled, cancellation_code,
weather_delay, air_time, distance
from etl_cte1 t1 join etl_cte2 t2 on t1.origin = t2.iata_code
join etl_cte2 t3 on t1.dest = t3.iata_code
where processed_dttm = last_processed 

on conflict(flight_dep_scheduled_ts, flight_number_reporting_airline, origin_code, dest_code) do update
set year = excluded.year, quarter = excluded.quarter, month = excluded.month,
flight_scheduled_date = excluded.flight_scheduled_date,
flight_actual_date = excluded.flight_actual_date,
flight_dep_actual_ts = excluded.flight_dep_actual_ts,
report_airline = excluded.report_airline, tail_number = excluded.tail_number,
airport_origin_dk = excluded.airport_origin_dk, airport_dest_dk = excluded.airport_dest_dk,
dep_delay_minutes = excluded.dep_delay_minutes, cancelled = excluded.cancelled,
cancellation_code = excluded.cancellation_code, weather_delay = excluded.weather_delay,
air_time = excluded.air_time, distance = excluded.distance,
loaded_ts = now()
