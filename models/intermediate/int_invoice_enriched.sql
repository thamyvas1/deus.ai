select
    i.invoice_id,
    i.invoice_date,
    date_trunc('month', i.invoice_date)::date as month_start,
    date_trunc('quarter', i.invoice_date)::date as quarter_start,
    i.account_id,
    a.account_name,
    i.opportunity_id,
    o.rep_id,
    r.rep_name,
    coalesce(r.team, 'Unassigned') as team,
    o.stage as opportunity_stage,
    i.line_type,
    i.amount_eur as revenue_eur,
    i.cost_eur,
    case when i.cost_eur is not null then i.amount_eur - i.cost_eur else null end as margin_eur,
    case when i.opportunity_id is null or o.opportunity_id is null then true else false end as is_unattributed,
    case when i.cost_eur is null then true else false end as is_missing_cost
from {{ ref('stg_invoices') }} i
left join {{ ref('stg_accounts') }} a using (account_id)
left join {{ ref('stg_opportunities') }} o using (opportunity_id)
left join {{ ref('stg_sales_reps') }} r using (rep_id)
