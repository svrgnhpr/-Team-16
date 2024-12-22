create table mart_16.fact_departure (
    airport_origin_dk int not null,
    airport_destination_dk int not null,
    flight_scheduled_ts timestamp not null,
    flight_number varchar(15) not null,
    weather_type_dk char(6) not null,
    flight_actual_time timestamp null,
    distance float null,
    tail_number varchar(10) not null,
    airline varchar(10) not null,
    dep_delay_min float null,
    cancelled int not null,
    cancellation_code char(1) null,
    t int null,
    max_gws int null,
    w_speed int null,
    air_time float null,
    loaded_ts timestamp default now(),
    primary key (airport_origin_dk, airport_destination_dk, flight_scheduled_ts, flight_number)
);

