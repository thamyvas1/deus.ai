select
    month_start,
    team,
    revenue_eur,
    rolling_3m_revenue_eur
from {{ ref('mart_monthly_sales_report') }}
order by team, month_start;
