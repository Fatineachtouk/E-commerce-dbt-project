select *
from {{ ref('stg__users') }}
where created_at > current_date
