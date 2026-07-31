select *
from {{ ref('stg__orders') }}
where delivered_at is not null
  and shipped_at is not null
  and delivered_at < shipped_at