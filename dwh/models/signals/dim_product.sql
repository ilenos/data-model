{{
    config(
        materialized = "table"
    )
}}

WITH source AS (
    SELECT DISTINCT {{ dbt_utils.generate_surrogate_key(['stg_event.product']) }} AS product_key,
        product AS description
        FROM {{ ref('stg_event') }}
)

SELECT *
    FROM source