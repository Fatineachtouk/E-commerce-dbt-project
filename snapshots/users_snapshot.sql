{%
  snapshot users_snapshot %}

{{
  config(
    target_schema='snapshots',
    unique_key='id',
    strategy='check',
    check_cols=['email',
                'state', 
                'street_address', 
                'postal_code', 
                'city', 
                'country', 
                'latitude', 
                'longitude']
  )
}}

SELECT * FROM {{ source('dev', 'users') }}

{% endsnapshot %}