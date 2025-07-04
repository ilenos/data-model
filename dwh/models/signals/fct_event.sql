{{
    config(
        materialized = "table",
        indexes=[
            {'columns': ['date_day'], 'type': 'hash', 'unique': False},
        ]
    )
}}

WITH source AS (
    SELECT ev.id,
        ev.user_id,
        v.verb_key,
        o.object_key,
        p.product_key,
        ev.event_ts::date AS date_day,
        ev.event_ts
        FROM {{ ref('stg_event') }} AS ev
        LEFT JOIN {{ ref('dim_verb') }} AS v
            ON ev.verb = v.description
        LEFT JOIN {{ ref('dim_object') }} AS o
            ON ev.object = o.description
        LEFT JOIN {{ ref('dim_product') }} AS p
            ON ev.product = p.description
)

SELECT *
    FROM source