-- Nettoyage et standardisation des données InfoClimat
{{ config(
    materialized='view',
    schema='staging'
) }}

WITH source_data AS (
    SELECT
        datetime,
        'Bergues' AS station_name,
        'InfoClimat' AS source,
        temperature,
        humidity,
        pressure,
        CURRENT_TIMESTAMP AS loaded_at
    FROM {{ source('airbyte_raw', 'infoclimat_bergues') }}
    
    UNION ALL
    
    SELECT
        datetime,
        'Hazebrouck' AS station_name,
        'InfoClimat' AS source,
        temperature,
        humidity,
        pressure,
        CURRENT_TIMESTAMP AS loaded_at
    FROM {{ source('airbyte_raw', 'infoclimat_hazebrouck') }}
)

SELECT
    *,
    ROW_NUMBER() OVER (PARTITION BY station_name ORDER BY datetime) AS rn
FROM source_data
WHERE temperature IS NOT NULL
