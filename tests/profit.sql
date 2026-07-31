select *
from {{ ref('product') }}
where profit != sales_amount - cogs
