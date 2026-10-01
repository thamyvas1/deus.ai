select invoice_id, count(*) as row_count
from {{ ref('stg_invoices') }}
group by 1
having count(*) > 1
