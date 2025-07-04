{{
    config(
        materialized = "table",
        indexes=[
            {'columns': ['user_id'], 'type': 'btree', 'unique': True},
        ]
    )
}}

WITH source AS (
    SELECT DISTINCT user_id
        FROM {{ ref('stg_event') }} AS ev
)

SELECT *
    FROM source