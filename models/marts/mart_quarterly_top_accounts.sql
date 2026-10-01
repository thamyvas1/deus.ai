with quarterly as (
    select
        date_trunc('quarter', invoice_date)::date as quarter_start,
        account_id,
        max(account_name) as account_name,
        sum(revenue_eur) as revenue_eur,
        sum(margin_eur) as margin_eur,
        count(distinct invoice_id) as invoice_count
    from {{ ref('fct_revenue') }}
    where invoice_date >= date '2025-01-01' and invoice_date < date '2026-01-01'
    group by 1,2
), ranked as (
    select *, row_number() over (
        partition by quarter_start order by revenue_eur desc, account_id
    ) as revenue_rank
    from quarterly
)
select *
from ranked
where revenue_rank <= 3
order by quarter_start, revenue_rank
