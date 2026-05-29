-- Table de faits des observations météorologiques
{{ config(
    materialized='table',
    schema='marts'
) }}

SELECT
    ROW_NUMBER() OVER (ORDER BY datetime, station_name) AS observation_id,
    datetime,
    station_name,
    source,
    temperature,
    humidity,
    pressure,
    data_quality_flag,
    loaded_at,
    CURRENT_TIMESTAMP AS updated_at
FROM {{ ref('int_weather_unified') }}
WHERE data_quality_flag = 'valid'
ORDER BY datetime DESC, station_name
