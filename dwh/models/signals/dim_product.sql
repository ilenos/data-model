{{
    config(
        materialized = "table",
        indexes=[
            {'columns': ['product_key'], 'type': 'btree', 'unique': True},
        ]
    )
}}

WITH source AS (
    SELECT DISTINCT {{ dbt_utils.generate_surrogate_key(['stg_event.product']) }} AS product_key,
        product AS description
        FROM {{ ref('stg_event') }}
)

SELECT *
    FROM source