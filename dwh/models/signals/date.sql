{{
    config(
        materialized = "table",
        indexes=[
            {'columns': ['date_day'], 'type': 'btree', 'unique': True},
        ]
    )
}}
{{ dbt_date.get_date_dimension('2021-01-01', '2025-12-31') }}