CREATE TABLE default.kafka_vehicle_data_in
(
    vehicle_id String,
    lat Float64,
    lon Float64,
    speed_kmh Float32,
    rpm Int32,
    oil_temp Float32,
    fuel Float32,
    timestamp UInt64
)
ENGINE = Kafka
SETTINGS
    kafka_broker_list = 'kafka:9092',
    kafka_topic_list = 'vehicle-data',
    kafka_group_name = 'vehicle-ch-consumer',
    kafka_format = 'AvroConfluent',
    format_avro_schema_registry_url  = 'http://schema-registry:8081',
    kafka_num_consumers = 1;

CREATE TABLE default.vehicle_data
(
    vehicle_id String,
    lat Float64,
    lon Float64,
    speed_kmh Float32,
    rpm Int32,
    oil_temp Float32,
    fuel Float32,
    timestamp DateTime
)
ENGINE = MergeTree()
ORDER BY (vehicle_id, timestamp);

CREATE MATERIALIZED VIEW default.vehicle_data_mv
TO default.vehicle_data
AS
SELECT
    vehicle_id,
    lat,
    lon,
    speed_kmh,
    rpm,
    oil_temp,
    fuel,
    toDateTime(timestamp) AS timestamp
FROM kafka_vehicle_data_in;
