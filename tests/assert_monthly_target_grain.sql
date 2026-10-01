select month_start, team, count(*) as row_count
from {{ ref('mart_monthly_sales_report') }}
group by 1,2
having count(*) <> 1
