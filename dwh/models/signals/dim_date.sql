{{
    config(
        materialized = "table",
        indexes=[
            {'columns': ['date_day'], 'type': 'btree', 'unique': True},
        ]
    )
}}
with date_dimension as (
    select * from {{ ref('date') }}
),
fiscal_periods as (
    {{ dbt_date.get_fiscal_periods(ref('date'), year_end_month=1, week_start_day=1, shift_year=1) }}
)
select
    d.*,
    f.fiscal_week_of_year,
    f.fiscal_week_of_period,
    f.fiscal_period_number,
    f.fiscal_quarter_number,
    f.fiscal_period_of_quarter
from
    date_dimension d
    left join
    fiscal_periods f
        on d.date_day = f.date_day