select *
from {{ ref('stg__products') }}
where cost >= retail_price



