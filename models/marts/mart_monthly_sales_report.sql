with months as (
    select distinct strptime(month, '%Y-%m')::date as month_start
    from {{ ref('stg_monthly_targets') }}
), target_teams as (
    select distinct team from {{ ref('stg_monthly_targets') }}
), actual_teams as (
    select distinct team from {{ ref('fct_revenue') }}
    where invoice_date >= date '2025-01-01' and invoice_date < date '2026-01-01'
), teams as (
    select team from target_teams
    union
    select team from actual_teams
), grid as (
    select m.month_start, t.team from months m cross join teams t
), actuals as (
    select
        date_trunc('month', invoice_date)::date as month_start,
        team,
        sum(revenue_eur) as revenue_eur,
        sum(margin_eur) as margin_eur,
        count(distinct invoice_id) as invoice_count,
        count(distinct account_id) as account_count,
        sum(case when is_unattributed then revenue_eur else 0 end) as unattributed_revenue_eur,
        sum(case when is_missing_cost then revenue_eur else 0 end) as revenue_with_missing_cost_eur
    from {{ ref('fct_revenue') }}
    where invoice_date >= date '2025-01-01' and invoice_date < date '2026-01-01'
    group by 1,2
), joined as (
    select
        g.month_start,
        g.team,
        coalesce(a.revenue_eur, 0) as revenue_eur,
        coalesce(a.margin_eur, 0) as margin_eur,
        coalesce(a.invoice_count, 0) as invoice_count,
        coalesce(a.account_count, 0) as account_count,
        coalesce(a.unattributed_revenue_eur, 0) as unattributed_revenue_eur,
        coalesce(a.revenue_with_missing_cost_eur, 0) as revenue_with_missing_cost_eur,
        t.target_revenue_eur
    from grid g
    left join actuals a using (month_start, team)
    left join {{ ref('stg_monthly_targets') }} t
      on t.month = strftime(g.month_start, '%Y-%m') and t.team = g.team
)
select
    month_start,
    team,
    revenue_eur,
    margin_eur,
    case when revenue_eur <> 0 then margin_eur / revenue_eur else null end as margin_pct,
    target_revenue_eur,
    case when target_revenue_eur is not null then revenue_eur - target_revenue_eur else null end as variance_to_target_eur,
    case when target_revenue_eur <> 0 then revenue_eur / target_revenue_eur else null end as target_attainment_pct,
    sum(revenue_eur) over (partition by team order by month_start rows between 2 preceding and current row) as rolling_3m_revenue_eur,
    invoice_count,
    account_count,
    unattributed_revenue_eur,
    revenue_with_missing_cost_eur
from joined
order by team, month_start
