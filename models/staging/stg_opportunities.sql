select
    cast(opportunity_id as varchar) as opportunity_id,
    cast(account_id as varchar) as account_id,
    cast(rep_id as varchar) as rep_id,
    cast(created_date as date) as created_date,
    cast(close_date as date) as close_date,
    cast(stage as varchar) as stage,
    cast(amount_eur as decimal(18,2)) as amount_eur
from {{ ref('opportunities') }}
