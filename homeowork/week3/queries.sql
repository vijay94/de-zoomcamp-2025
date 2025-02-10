CREATE OR REPLACE EXTERNAL TABLE `kestra-zoomcamp-449912.taxi_rides_ny.external_yellow_tripdata`
OPTIONS (
  format = 'parquet',
  uris = ['gs://kestra-zoomcamp-sample-123/yellow_tripdata_2024-*.parquet']
);

select count(VendorId) from `kestra-zoomcamp-449912.taxi_rides_ny.external_yellow_tripdata`;

CREATE OR REPLACE TABLE kestra-zoomcamp-449912.taxi_rides_ny.yellow_tripdata_non_partitioned AS
SELECT * FROM kestra-zoomcamp-449912.taxi_rides_ny.external_yellow_tripdata;

select count(distinct(PULocationID)) from `kestra-zoomcamp-449912.taxi_rides_ny.external_yellow_tripdata`;

select count(distinct(PULocationID)) from `kestra-zoomcamp-449912.taxi_rides_ny.yellow_tripdata_non_partitioned`;

select PULocationID from `kestra-zoomcamp-449912.taxi_rides_ny.yellow_tripdata_non_partitioned`;

select PULocationId, DOLocationID from `kestra-zoomcamp-449912.taxi_rides_ny.yellow_tripdata_non_partitioned`;

select count(1) from `kestra-zoomcamp-449912.taxi_rides_ny.yellow_tripdata_non_partitioned` where fare_amount = 0;

CREATE OR REPLACE TABLE kestra-zoomcamp-449912.taxi_rides_ny.yellow_tripdata_partitioned
PARTITION BY
  DATE(tpep_dropoff_datetime) AS
SELECT * FROM kestra-zoomcamp-449912.taxi_rides_ny.external_yellow_tripdata;

select count(distinct(vendorID)) from `kestra-zoomcamp-449912.taxi_rides_ny.yellow_tripdata_non_partitioned` where DATE(tpep_dropoff_datetime) BETWEEN '2024-03-01' and '2024-03-15';


select count(distinct(vendorID)) from `kestra-zoomcamp-449912.taxi_rides_ny.yellow_tripdata_partitioned` where DATE(tpep_dropoff_datetime) BETWEEN '2024-03-01' and '2024-03-15';
