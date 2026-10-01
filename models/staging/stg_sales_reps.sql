select
    cast(rep_id as varchar) as rep_id,
    cast(rep_name as varchar) as rep_name,
    cast(team as varchar) as team
from {{ ref('sales_reps') }}
