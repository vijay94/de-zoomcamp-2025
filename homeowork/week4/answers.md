## Question 1

select * from myproject.raw_nyc_tripdata.ext_green_taxi

## Question 2

Update the WHERE clause to pickup_datetime >= CURRENT_DATE - INTERVAL '{{ var("days_back", env_var("DAYS_BACK", "30")) }}' DAY

## Question 3

dbt run --select +models/core/

## Question 4

Setting a value for DBT_BIGQUERY_TARGET_DATASET env var is mandatory, or it'll fail to compile

When using core, it materializes in the dataset defined in DBT_BIGQUERY_TARGET_DATASET

When using stg, it materializes in the dataset defined in DBT_BIGQUERY_STAGING_DATASET, or defaults to DBT_BIGQUERY_TARGET_DATASET

When using staging, it materializes in the dataset defined in DBT_BIGQUERY_STAGING_DATASET, or defaults to DBT_BIGQUERY_TARGET_DATASET

## Question 5

green: {best: 2020/Q1, worst: 2020/Q2}, yellow: {best: 2020/Q1, worst: 2020/Q2}


## Question 6


green: {p97: 55.0, p95: 45.0, p90: 26.5}, yellow: {p97: 31.5, p95: 25.5, p90: 19.0}


## Question 7

LaGuardia Airport, Chinatown, Garment District
