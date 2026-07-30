WITH product_info AS(
    SELECT 
     id AS product_id,
     name AS product_name,
     category AS product_category,
     department AS product_department
    FROM {{ ref('stg__products') }}
)

, inventory_items as(
    SELECT 
     product_id,
     SUM(CASE WHEN sold_at IS NOT NULL THEN cost END) as cogs
    FROM {{ ref('stg__inventory_items') }}
    GROUP BY 1
)

, order_items AS(
    SELECT
     product_id,
     SUM(sale_price) AS sales_amount
    FROM {{ ref('stg__order_items') }}
    GROUP BY 1
)

SELECT 
   pi.product_id,
   pi.product_name,
   pi.product_category,
   pi.product_department,
   ii.cogs,
   oi.sales_amount,
   oi.sales_amount-ii.cogs AS profit
FROM product_info pi

LEFT JOIN inventory_items ii 
ON pi.product_id = ii.product_id

LEFT JOIN order_items oi
ON pi.product_id = oi.product_id