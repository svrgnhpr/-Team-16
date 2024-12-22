insert into dds_16.airport_weather

with etl_cte as (select air.id as airport_dk,
case when t_air_temperature < 0 then 1 else 0 end as cold,
case when lower(w.ww_present) like '%rain%' or lower(ww_recent) like '%rain%' then 1 else 0 end as rain,
case when lower(ww_present) like '%snow%' or lower(ww_recent) like '%snow%' then 1 else 0 end as snow,
case when lower(ww_present) like '%thunderstorm%' or lower(ww_recent) like '%thunderstorm%' then 1 else 0 end as thunderstorm,
case when lower(ww_present) like '%drizzle%' or lower(ww_recent) like '%drizzle%' then 1 else 0 end as drizzle,
case when lower(ww_present) like '%fog%' or lower(ww_recent) like '%fog%' or
lower(ww_present) like '%mist%' or lower(ww_recent) like '%mist%' then 1 else 0 end as fog_mist, 
t_air_temperature, ff10_max_gust_value, ff_wind_speed,
w.local_datetime as date_start, lead(local_datetime) over () as date_end, processed_dttm,
max(w.processed_dttm) over (partition by w.icao_code, w.local_datetime) as last_processed

from dds_16.airports air join stg_16.weather w on air.ident = w.icao_code)

select airport_dk, 
concat(cold, rain, snow, thunderstorm, drizzle, fog_mist) as weather_type_dk,
cold, rain, snow, 
thunderstorm, drizzle, fog_mist, 
t_air_temperature as t, 
ff10_max_gust_value as max_gws, 
ff_wind_speed as w_speed, 
date_start, coalesce(date_end, '2022-05-01')
from etl_cte
where processed_dttm = last_processed

on conflict(airport_dk, date_start) do update
set weather_type_dk = excluded.weather_type_dk,
cold = excluded.cold,
rain = excluded.rain,
snow = excluded.snow,
thunderstorm = excluded.thunderstorm,
drizzle = excluded.drizzle,
fog_mist = excluded.fog_mist,
t = excluded.t,
max_gws = excluded.max_gws,
w_speed = excluded.w_speed,
date_end = excluded.date_end,
loaded_ts = now()

