insert into stg_16.weather
(icao_code,
local_datetime,
t_air_temperature,
p0_sea_lvl,
p_station_lvl,
u_humidity,
dd_wind_direction,
ff_wind_speed,
ff10_max_gust_value,
ww_present,
ww_recent,
c_total_clouds,
vv_horizontal_visibility,
td_temperature_dewpoint)

with etl_cte as
(select *, max(processed_dttm) over (partition by local_datetime) as last_processed from ods_16.weather)
select 'KEYW',
local_datetime, t, p0, p, u, dd, ff, ff10, ww_present, ww_recent, c, vv, td
from etl_cte
where processed_dttm = last_processed

on conflict(icao_code, local_datetime) do update
set t_air_temperature = excluded.t_air_temperature,
p0_sea_lvl = excluded.p0_sea_lvl,
p_station_lvl = excluded.p_station_lvl,
u_humidity = excluded.u_humidity,
dd_wind_direction = excluded.dd_wind_direction,
ff_wind_speed = excluded.ff_wind_speed,
ff10_max_gust_value = excluded.ff10_max_gust_value,
ww_present = excluded.ww_present,
ww_recent = excluded.ww_recent,
c_total_clouds = excluded.c_total_clouds,
vv_horizontal_visibility = excluded.vv_horizontal_visibility,
td_temperature_dewpoint = excluded.td_temperature_dewpoint,
processed_dttm = now()


