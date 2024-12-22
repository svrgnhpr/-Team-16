create view for_dashboard
as
select airport_origin_dk,
airport_destination_dk,
flight_scheduled_ts,
weather_type_dk,
dep_delay_min,
cancelled

from mart_16.fact_departure

