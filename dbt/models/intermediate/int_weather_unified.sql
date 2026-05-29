-- Unification de toutes les sources météorologiques
{{ config(
    materialized='table',
    schema='intermediate'
) }}

WITH all_stations AS (
    SELECT * FROM {{ ref('stg_infoclimat') }}
    UNION ALL
    SELECT * FROM {{ ref('stg_weather_underground') }}
)

SELECT
    datetime,
    station_name,
    source,
    temperature,
    humidity,
    pressure,
    loaded_at,
    CASE
        WHEN temperature < -50 OR temperature > 60 THEN 'invalid'
        WHEN humidity < 0 OR humidity > 100 THEN 'invalid'
        ELSE 'valid'
    END AS data_quality_flag
FROM all_stations
ORDER BY datetime, station_name
