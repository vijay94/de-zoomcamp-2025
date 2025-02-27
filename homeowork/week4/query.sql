CREATE OR REPLACE EXTERNAL TABLE `kestra-zoomcamp-449912.taxi_rides_ny.yellow_tripdata`
OPTIONS (
  format = 'csv',
  uris = ['gs://kestra-zoomcamp-sample-123/yellow/yellow_tripdata_*.csv']
);

select count(1) from `kestra-zoomcamp-449912.taxi_rides_ny.yellow_tripdata`;

CREATE OR REPLACE EXTERNAL TABLE `kestra-zoomcamp-449912.taxi_rides_ny.green_tripdata`
OPTIONS (
  format = 'csv',
  uris = ['gs://kestra-zoomcamp-sample-123/green/green_tripdata_*.csv']
);

select count(1) from `kestra-zoomcamp-449912.taxi_rides_ny.green_tripdata`;

CREATE OR REPLACE EXTERNAL TABLE `kestra-zoomcamp-449912.taxi_rides_ny.fhv_tripdata`
OPTIONS (
  format = 'csv',
  uris = ['gs://kestra-zoomcamp-sample-123/fhv/fhv_tripdata_*.csv']
);

select count(1) from `kestra-zoomcamp-449912.taxi_rides_ny.fhv_tripdata`;



-- select revenue_quarter, revenue_year, service_type, revenue_monthly_total_amount from `kestra-zoomcamp-449912.dbt_vs.fct_taxi_trips_quarterly_revenue` where extract(year from revenue_year) in (2019, 2020);


-- SELECT
--     revenue_year,
--     revenue_quarter,
--     service_type,
--     revenue_monthly_total_amount,
--     LAG(revenue_monthly_total_amount) OVER (
--         PARTITION BY revenue_quarter, service_type
--         ORDER BY revenue_year
--     ) AS prev_year_revenue
-- FROM `kestra-zoomcamp-449912.dbt_vs.fct_taxi_trips_quarterly_revenue` where extract(year from revenue_year) in (2019, 2020)

-- WITH revenue_with_prev AS (
--     SELECT
--         revenue_year,
--         revenue_quarter,
--         service_type,
--         revenue_monthly_total_amount,
--         LAG(revenue_monthly_total_amount) OVER (
--             PARTITION BY revenue_quarter, service_type
--             ORDER BY revenue_year
--         ) AS prev_year_revenue
--     FROM `kestra-zoomcamp-449912.dbt_vs.fct_taxi_trips_quarterly_revenue` where extract(year from revenue_year) in (2019, 2020)
-- )
-- SELECT
--     service_type,
--     revenue_quarter,
--     ROUND(
--         ((revenue_monthly_total_amount - prev_year_revenue) / prev_year_revenue) * 100, 2
--     ) AS yoy_growth_percentage
-- FROM revenue_with_prev
-- WHERE prev_year_revenue IS NOT NULL
-- ORDER BY service_type, revenue_quarter;


-- select * from `kestra-zoomcamp-449912.dbt_vs.fct_taxi_trips_monthly_fare_p95` where extract(month from revenue_month) = 4 and extract(year from revenue_year) = 2020;


-- select max_travel_time.pickup_zone, max(travel_time_outer.p90_travel_time) max_p90_travel_time from `kestra-zoomcamp-449912.dbt_vs.fct_fhv_monthly_zone_traveltime_p90` travel_time_outer inner join

-- (SELECT travel_time.pickup_locationid, travel_time.pickup_zone as pickup_zone, max(travel_time.p90_travel_time) as max_p90_travel_time  FROM
-- `kestra-zoomcamp-449912.dbt_vs.fct_fhv_monthly_zone_traveltime_p90` travel_time
--  inner join `kestra-zoomcamp-449912.dbt_vs.dim_zones` zone
--  on zone.locationid = travel_time.pickup_locationid and lower(zone.zone) in ('newark airport', 'soho', 'yorkville east')
-- where pickup_year = 2019 and pickup_month = 11 group by travel_time.pickup_locationid, travel_time.pickup_zone) as max_travel_time

-- on travel_time_outer.pickup_locationid = max_travel_time.pickup_locationid and travel_time_outer.p90_travel_time < max_travel_time.max_p90_travel_time group by travel_time_outer.pickup_locationid, max_travel_time.pickup_zone
