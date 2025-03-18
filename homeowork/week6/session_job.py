from pyflink.datastream import StreamExecutionEnvironment
from pyflink.table import EnvironmentSettings, StreamTableEnvironment

def create_events_aggregated_sink(t_env):
    table_name = 'processed_events_aggregated'
    sink_ddl = f"""
        CREATE TABLE {table_name} (
            event_hour TIMESTAMP(3),
            PULocationID INT,
            DOLocationID INT,
            num_hits BIGINT,
            PRIMARY KEY (PULocationID, DOLocationID) NOT ENFORCED
        ) WITH (
            'connector' = 'jdbc',
            'url' = 'jdbc:postgresql://localhost:5432/postgres',
            'table-name' = '{table_name}',
            'username' = 'postgres',
            'password' = 'postgres',
            'driver' = 'org.postgresql.Driver'
        );
        """
    t_env.execute_sql(sink_ddl)
    return table_name

def create_events_source_kafka(t_env):
    table_name = "events"
    pattern = "yyyy-MM-dd HH:mm:ss"
    source_ddl = f"""
        CREATE OR REPLACE TABLE {table_name} (
            lpep_pickup_datetime VARCHAR,
            lpep_dropoff_datetime VARCHAR,
            PULocationID INT,
            DOLocationID INT,
            passenger_count INT,
            trip_distance DOUBLE,
            tip_amount DOUBLE,
            event_watermark AS TO_TIMESTAMP(lpep_dropoff_datetime, '{pattern}'),
            WATERMARK FOR event_watermark AS event_watermark - INTERVAL '5' SECOND
        ) WITH (
            'connector' = 'kafka',
            'properties.bootstrap.servers' = 'localhost:9092',
            'topic' = 'taxi-trips',
            'scan.startup.mode' = 'earliest-offset',
            'properties.auto.offset.reset' = 'earliest',
            'format' = 'json'
        );
        """
    t_env.get_config().set("pipeline.jars", "file:///Users/vijays/Downloads/flink-sql-connector-kafka-3.3.0-1.20.jar;file:///Users/vijays/Downloads/flink-connector-jdbc-3.2.0-1.19.jar")
    t_env.execute_sql(source_ddl)
    return table_name


def log_aggregation():
    # Set up the execution environment
    env = StreamExecutionEnvironment.get_execution_environment()
    env.enable_checkpointing(10 * 1000)
    env.set_parallelism(3)

    # test the connection

    # Set up the table environment
    settings = EnvironmentSettings.new_instance().in_streaming_mode().build()
    t_env = StreamTableEnvironment.create(env, environment_settings=settings)
    t_env.execute_sql("SELECT now()").print()

    print("Creating Kafka table and writing to JDBC sink...")
    try:
        # Create Kafka table
        source_table = create_events_source_kafka(t_env)
        print("Source table created")
        aggregated_table = create_events_aggregated_sink(t_env)
        print("Sink table created")
        t_env.execute_sql(f"""
          INSERT INTO {aggregated_table}
          SELECT
              window_start as event_hour,
              PULocationID,
              DOLocationID,
              COUNT(*) AS num_hits
          FROM TABLE(
              TUMBLE(TABLE {source_table}, DESCRIPTOR(event_watermark), INTERVAL '5' MINUTE)
          )
          GROUP BY window_start, PULocationID, DOLocationID;
        """).print()
        print("Records written from Kafka to JDBC successfully")

    except Exception as e:
        print("Writing records from Kafka to JDBC failed:", str(e))


if __name__ == '__main__':
    log_aggregation()
