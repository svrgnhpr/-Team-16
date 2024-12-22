insert into mart_16.fact_departure

with etl_cte1 as
(select airport_origin_dk, airport_dest_dk as airport_destination_dk, flight_dep_scheduled_ts as flight_scheduled_ts,
flight_number_reporting_airline as flight_number, flight_dep_actual_ts as flight_actual_time, 
distance, tail_number, report_airline as airline, dep_delay_minutes as dep_delay_min, cancelled,
cancellation_code, air_time, loaded_ts, 
max(loaded_ts) over (partition by flight_dep_scheduled_ts, flight_number_reporting_airline, origin_code, dest_code) as last_loaded
from dds_16.flights),

etl_cte2 as
(select airport_dk, weather_type_dk, t, max_gws, w_speed, date_start, date_end, loaded_ts, 
max(loaded_ts) over (partition by airport_dk, date_start) as last_loaded
from dds_16.airport_weather)


select airport_origin_dk, airport_destination_dk,  flight_scheduled_ts, flight_number, weather_type_dk,
flight_actual_time, distance, tail_number, airline, dep_delay_min,
cancelled, cancellation_code, t, max_gws, w_speed, air_time
from etl_cte1 t1 join etl_cte2 t2 
on (airport_origin_dk = airport_dk or airport_destination_dk = airport_dk)
and t1.flight_scheduled_ts >= t2.date_start and t1.flight_scheduled_ts < t2.date_end
where t1.loaded_ts = t1.last_loaded and t2.loaded_ts = t2.last_loaded


on conflict(airport_origin_dk, airport_destination_dk, flight_scheduled_ts, flight_number) do update
set weather_type_dk = excluded.weather_type_dk,
flight_actual_time = excluded.flight_actual_time,
distance = excluded.distance,
tail_number = excluded.tail_number,
airline = excluded.airline,
dep_delay_min = excluded.dep_delay_min,
cancelled = excluded.cancelled,
cancellation_code = excluded.cancellation_code,
t = excluded.t,
max_gws = excluded.max_gws,
w_speed = excluded.w_speed,
air_time = excluded.air_time,
loaded_ts = now()

