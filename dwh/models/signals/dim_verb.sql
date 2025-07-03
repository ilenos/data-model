{{
    config(
        materialized = "table"
    )
}}

WITH source AS (
    SELECT DISTINCT {{ dbt_utils.generate_surrogate_key(['stg_event.verb']) }} AS verb_key,
        verb AS description
        FROM {{ ref('stg_event') }}
)

SELECT *
    FROM source