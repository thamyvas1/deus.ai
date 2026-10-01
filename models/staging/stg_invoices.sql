with typed as (
    select
        cast(invoice_id as varchar) as invoice_id,
        cast(invoice_date as date) as invoice_date,
        cast(account_id as varchar) as account_id,
        nullif(cast(opportunity_id as varchar), '') as opportunity_id,
        cast(line_type as varchar) as line_type,
        cast(amount_eur as decimal(18,2)) as amount_eur,
        cast(cost_eur as decimal(18,2)) as cost_eur
    from {{ ref('invoices') }}
), ranked as (
    select *, row_number() over (
        partition by invoice_id order by invoice_date, opportunity_id nulls last
    ) as row_num
    from typed
)
select * exclude (row_num)
from ranked
where row_num = 1
