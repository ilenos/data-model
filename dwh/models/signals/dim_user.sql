{{
    config(
        materialized = "table"
    )
}}

WITH source AS (
    SELECT DISTINCT user_id AS id
        FROM {{ ref('stg_event') }} AS ev
)

SELECT *
    FROM source