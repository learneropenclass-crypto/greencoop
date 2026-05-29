-- Dimension des stations météorologiques
{{ config(
    materialized='table',
    schema='marts'
) }}

WITH stations AS (
    SELECT DISTINCT
        station_name,
        source,
        CASE
            WHEN station_name = 'Bergues' THEN 50.9667
            WHEN station_name = 'Hazebrouck' THEN 50.7167
            WHEN station_name = 'Armentières' THEN 50.6833
            WHEN station_name = 'Lille-Lesquin' THEN 50.5667
            WHEN station_name = 'Ichtegem' THEN 51.0333
            WHEN station_name = 'La Madeleine' THEN 50.6500
        END AS latitude,
        CASE
            WHEN station_name = 'Bergues' THEN 2.4333
            WHEN station_name = 'Hazebrouck' THEN 2.4333
            WHEN station_name = 'Armentières' THEN 2.8333
            WHEN station_name = 'Lille-Lesquin' THEN 3.0833
            WHEN station_name = 'Ichtegem' THEN 3.2333
            WHEN station_name = 'La Madeleine' THEN 3.0833
        END AS longitude,
        CASE
            WHEN station_name IN ('Bergues', 'Hazebrouck', 'Armentières', 'Lille-Lesquin') THEN 'France'
            WHEN station_name = 'Ichtegem' THEN 'Belgique'
            WHEN station_name = 'La Madeleine' THEN 'France'
        END AS country
    FROM {{ ref('int_weather_unified') }}
)

SELECT
    ROW_NUMBER() OVER (ORDER BY station_name) AS station_id,
    station_name,
    source,
    latitude,
    longitude,
    country,
    CURRENT_TIMESTAMP AS created_at
FROM stations
