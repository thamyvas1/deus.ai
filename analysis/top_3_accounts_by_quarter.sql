select *
from {{ ref('mart_quarterly_top_accounts') }}
order by quarter_start, revenue_rank;
