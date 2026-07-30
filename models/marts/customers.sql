WITH customer_info AS(
    SELECT 
        id AS customer_id,
        first_name,
        last_name,
        country,
        gender,
        traffic_source
    FROM {{ ref('stg__users') }}
),
order_items AS(
    SELECT 
        user_id,
        SUM(sale_price) AS total_amount_spent,
        MIN(created_at) AS first_order_at,
        MAX(created_at) AS last_order_at
    FROM {{ ref('stg__order_items') }}
    GROUP BY 1
),
orders AS(
    SELECT
        user_id,
        COUNT(DISTINCT order_id) AS num_orders
        {% for state in ['Shipped', 'Complete', 'Processing', 'Cancelled', 'Returned'] %}
        , COUNT(DISTINCT CASE WHEN status = '{{ state }}' THEN order_id END) AS orders_{{ state | lower }}
        {% endfor %}
    FROM {{ ref('stg__orders') }}
    GROUP BY 1
),
events AS(
    SELECT
        user_id,
        COUNT(DISTINCT session_id) AS num_sessions
    FROM {{ ref('stg__events')}}
    GROUP BY 1             
)

SELECT
    ci.customer_id,
    ci.first_name,
    ci.last_name,
    ci.country,
    ci.gender,
    ci.traffic_source,
    oi.total_amount_spent,
    oi.first_order_at,
    oi.last_order_at,
    o.num_orders,
    o.orders_shipped,
    o.orders_complete,
    o.orders_processing,
    o.orders_cancelled,
    o.orders_returned,
    e.num_sessions
FROM customer_info ci
LEFT JOIN order_items oi ON ci.customer_id = oi.user_id
LEFT JOIN orders o ON ci.customer_id = o.user_id
LEFT JOIN events e ON ci.customer_id = e.user_id
