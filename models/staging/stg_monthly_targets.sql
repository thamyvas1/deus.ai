select
    cast(month as varchar) as month,
    cast(team as varchar) as team,
    cast(target_revenue_eur as decimal(18,2)) as target_revenue_eur
from {{ ref('monthly_targets') }}
