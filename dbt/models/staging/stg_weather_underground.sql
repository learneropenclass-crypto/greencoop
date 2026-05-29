-- Nettoyage et standardisation des données Weather Underground
{{ config(
    materialized='view',
    schema='staging'
) }}

WITH source_data AS (
    SELECT
        datetime,
        'Ichtegem' AS station_name,
        'Weather Underground' AS source,
        temperature,
        humidity,
        pressure,
        CURRENT_TIMESTAMP AS loaded_at
    FROM {{ source('airbyte_raw', 'weather_underground_ichtegem') }}
    
    UNION ALL
    
    SELECT
        datetime,
        'La Madeleine' AS station_name,
        'Weather Underground' AS source,
        temperature,
        humidity,
        pressure,
        CURRENT_TIMESTAMP AS loaded_at
    FROM {{ source('airbyte_raw', 'weather_underground_la_madeleine') }}
)

SELECT *
FROM source_data
WHERE temperature IS NOT NULL
