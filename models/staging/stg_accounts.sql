select
    cast(account_id as varchar) as account_id,
    cast(account_name as varchar) as account_name,
    cast(industry as varchar) as industry,
    cast(country as varchar) as country
from {{ ref('accounts') }}
