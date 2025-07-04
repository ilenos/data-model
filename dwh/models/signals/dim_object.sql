{{
    config(
        materialized = "table",
        indexes=[
            {'columns': ['object_key'], 'type': 'btree', 'unique': True},
        ]
    )
}}

WITH source AS (
    SELECT DISTINCT {{ dbt_utils.generate_surrogate_key(['stg_event.object']) }} AS object_key,
        object AS description
        FROM {{ ref('stg_event') }}
)

SELECT *
    FROM source