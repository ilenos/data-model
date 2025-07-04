{{
    config(
        materialized = "table",
        indexes=[
            {'columns': ['date_day', "date_group_id"], 'type': 'btree', 'unique': False},
        ]
    )
}}

WITH source AS (
    SELECT dt.date_day,
        dt.date_day - INTERVAL '1 week' AS prior_week_date,
        dt.week_start_date,
        dg.id,
        dg.description
        FROM {{ ref('dim_date') }} AS dt
        CROSS JOIN {{ ref('lu_date_group') }} AS dg
),
create_start_end_dates AS (
    SELECT
        id,
        date_day,
        CASE
            WHEN id='wtd' THEN week_start_date -- Week to date
            WHEN id='mtd' THEN DATE_TRUNC('month', date_day) -- Month to date
            WHEN id='qtd' THEN DATE_TRUNC('quarter', date_day) -- Quarter to date
            WHEN id='ytd' THEN DATE_TRUNC('year', date_day) -- Year to date
            WHEN id='lw' THEN {{ dbt_date.week_start('prior_week_date') }} -- Last week
            WHEN id='lm' THEN DATE_TRUNC('month', date_day) - INTERVAL '1 month' -- Last month
            WHEN id='lq' THEN DATE_TRUNC('quarter', date_day) - INTERVAL '3 months' -- Last quarter
            WHEN id='ly' THEN DATE_TRUNC('year', date_day) - INTERVAL '1 year' -- Last year
            WHEN id='r7' THEN date_day - INTERVAL '6 days' -- Rolling 7 days
            WHEN id='r30' THEN date_day - INTERVAL '29 days' -- Rolling 30 days
        END AS start_date,
        CASE
            WHEN id='wtd' THEN date_day -- Week to date
            WHEN id='mtd' THEN date_day -- Month to date
            WHEN id='qtd' THEN date_day -- Quarter to date
            WHEN id='ytd' THEN date_day -- Year to date
            WHEN id='lw' THEN {{ dbt_date.week_end('prior_week_date') }} -- Last week
            WHEN id='lm' THEN DATE_TRUNC('month', date_day) - INTERVAL '1 day' -- Last month
            WHEN id='lq' THEN DATE_TRUNC('quarter', date_day) - INTERVAL '1 day' -- Last quarter
            WHEN id='ly' THEN DATE_TRUNC('year', date_day) - INTERVAL '1 day' -- Last year
            WHEN id='r7' THEN date_day -- Rolling 7 days
            WHEN id='r30' THEN date_day -- Rolling 30 days
        END AS end_date,
        description
        FROM source AS dt
), 

final AS (
    SELECT dt.date_day,
        csed.id AS date_group_id,
        csed.date_day AS reporting_day
        FROM create_start_end_dates AS csed
        LEFT JOIN {{ ref('dim_date') }} AS dt
            ON dt.date_day BETWEEN csed.start_date AND csed.end_date
)

SELECT *
    FROM final