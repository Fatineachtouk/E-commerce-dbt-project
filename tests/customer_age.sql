select *
from {{ ref('users') }}
where age < 0
   or age > 110