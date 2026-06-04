
SELECT
    ROUND(
        SUM(CASE WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date THEN 1 ELSE 0 END)
        / COUNT(*) * 100, 2
    ) AS pct_on_time,

    ROUND(
        SUM(CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 1 ELSE 0 END)
        / COUNT(*) * 100, 2
    ) AS pct_late,

    ROUND(
        SUM(CASE WHEN o.order_delivered_customer_date IS NULL THEN 1 ELSE 0 END)
        / COUNT(*) * 100, 2
    ) AS pct_undelivered
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON p.product_id = oi.product_id
JOIN product_category_name_translation pt 
    ON pt.product_category_name = p.product_category_name
WHERE pt.product_category_name_english IN (
    'electronics','audio','computers_accessories',
    'pc_gamer','computers','tablets_printing_image','telephony'
);


SELECT 
    ROUND(AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)), 2) AS avg_delivery_days
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON p.product_id = oi.product_id
JOIN product_category_name_translation pt 
    ON pt.product_category_name = p.product_category_name
WHERE pt.product_category_name_english IN (
    'electronics','audio','computers_accessories',
    'pc_gamer','computers','tablets_printing_image','telephony'
)
AND o.order_delivered_customer_date IS NOT NULL;


SELECT
    CASE 
        WHEN oi.price < 100 THEN 'cheap'
        WHEN oi.price BETWEEN 100 AND 500 THEN 'medium'
        ELSE 'premium'
    END AS price_tier,
    ROUND(AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)), 2) AS avg_delivery_days
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON p.product_id = oi.product_id
JOIN product_category_name_translation pt 
    ON pt.product_category_name = p.product_category_name
WHERE pt.product_category_name_english IN (
    'electronics','audio','computers_accessories',
    'pc_gamer','computers','tablets_printing_image','telephony'
)
AND o.order_delivered_customer_date IS NOT NULL
GROUP BY price_tier;

SELECT
    CASE 
        WHEN oi.price < 100 THEN 'cheap'
        WHEN oi.price BETWEEN 100 AND 500 THEN 'medium'
        ELSE 'premium'
    END AS price_tier,
    ROUND(
        SUM(CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 1 ELSE 0 END)
        / COUNT(*) * 100, 2
    ) AS pct_late
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON p.product_id = oi.product_id
JOIN product_category_name_translation pt 
    ON pt.product_category_name = p.product_category_name
WHERE pt.product_category_name_english IN (
    'electronics','audio','computers_accessories',
    'pc_gamer','computers','tablets_printing_image','telephony'
)
GROUP BY price_tier;


SELECT
    ROUND(
        SUM(CASE WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date THEN 1 ELSE 0 END)
        / COUNT(*) * 100, 2
    ) AS pct_on_time,

    ROUND(
        SUM(CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 1 ELSE 0 END)
        / COUNT(*) * 100, 2
    ) AS pct_late,

    ROUND(
        SUM(CASE WHEN o.order_delivered_customer_date IS NULL THEN 1 ELSE 0 END)
        / COUNT(*) * 100, 2
    ) AS pct_undelivered
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON p.product_id = oi.product_id
JOIN product_category_name_translation pt 
    ON pt.product_category_name = p.product_category_name
WHERE pt.product_category_name_english IN (
        'electronics','audio','computers_accessories',
        'pc_gamer','computers','tablets_printing_image','telephony'
      )
  AND MONTH(o.order_purchase_timestamp) IN (11, 12);   -- high demand months

SELECT
    ROUND(
        SUM(CASE WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date THEN 1 ELSE 0 END)
        / COUNT(*) * 100, 2
    ) AS pct_on_time,
    ROUND(
        SUM(CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 1 ELSE 0 END)
        / COUNT(*) * 100, 2
    ) AS pct_late,
    ROUND(
        SUM(CASE WHEN o.order_delivered_customer_date IS NULL THEN 1 ELSE 0 END)
        / COUNT(*) * 100, 2
    ) AS pct_undelivered
FROM orders o
WHERE MONTH(o.order_purchase_timestamp) IN (11, 12);


SELECT 
    ROUND(AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)), 2) 
        AS avg_delivery_days_high_demand
FROM orders
WHERE MONTH(order_purchase_timestamp) IN (11, 12)
  AND order_delivered_customer_date IS NOT NULL;



SELECT 
    t.sales_year,
    t.sales_month,
    ROUND(
        AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)),
        2
    ) AS avg_delivery_days_high_demand
FROM (
    SELECT 
        YEAR(o.order_purchase_timestamp) AS sales_year,
        MONTH(o.order_purchase_timestamp) AS sales_month,
        COUNT(*) AS tech_orders
    FROM orders o
    JOIN order_items oi 
        ON o.order_id = oi.order_id
    JOIN products p 
        ON p.product_id = oi.product_id
    JOIN product_category_name_translation pt 
        ON pt.product_category_name = p.product_category_name
    WHERE pt.product_category_name_english IN (
            'electronics','audio','computers_accessories',
            'pc_gamer','computers','tablets_printing_image','telephony'
          )
    GROUP BY 
        YEAR(o.order_purchase_timestamp),
        MONTH(o.order_purchase_timestamp)
    ORDER BY tech_orders DESC
    LIMIT 2
) AS t
JOIN orders o
    ON YEAR(o.order_purchase_timestamp) = t.sales_year
   AND MONTH(o.order_purchase_timestamp) = t.sales_month
JOIN order_items oi 
    ON o.order_id = oi.order_id
JOIN products p 
    ON p.product_id = oi.product_id
JOIN product_category_name_translation pt 
    ON pt.product_category_name = p.product_category_name
WHERE pt.product_category_name_english IN (
        'electronics','audio','computers_accessories',
        'pc_gamer','computers','tablets_printing_image','telephony'
      )
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY 
    t.sales_year,
    t.sales_month
ORDER BY 
    t.sales_year,
    t.sales_month;



SELECT 
    t.sales_year,
    t.sales_month,
    ROUND(
        AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)),
        2
    ) AS avg_delivery_days
FROM (
    SELECT 
        YEAR(o.order_purchase_timestamp) AS sales_year,
        MONTH(o.order_purchase_timestamp) AS sales_month,
        COUNT(*) AS tech_orders
    FROM orders o
    JOIN order_items oi 
        ON o.order_id = oi.order_id
    JOIN products p 
        ON p.product_id = oi.product_id
    JOIN product_category_name_translation pt 
        ON pt.product_category_name = p.product_category_name
    WHERE pt.product_category_name_english IN (
            'electronics','audio','computers_accessories',
            'pc_gamer','computers','tablets_printing_image','telephony'
          )
    GROUP BY 
        YEAR(o.order_purchase_timestamp),
        MONTH(o.order_purchase_timestamp)
) AS t
JOIN orders o
    ON YEAR(o.order_purchase_timestamp) = t.sales_year
   AND MONTH(o.order_purchase_timestamp) = t.sales_month
JOIN order_items oi 
    ON o.order_id = oi.order_id
JOIN products p 
    ON p.product_id = oi.product_id
JOIN product_category_name_translation pt 
    ON pt.product_category_name = p.product_category_name
WHERE pt.product_category_name_english IN (
        'electronics','audio','computers_accessories',
        'pc_gamer','computers','tablets_printing_image','telephony'
      )
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY 
    t.sales_year,
    t.sales_month
ORDER BY 
    t.sales_year,
    t.sales_month;



SELECT 
    t.sales_year,
    t.sales_month,
    t.total_orders,
    ROUND(
        AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)),
        2
    ) AS avg_delivery_days
FROM (
    SELECT 
        YEAR(order_purchase_timestamp) AS sales_year,
        MONTH(order_purchase_timestamp) AS sales_month,
        COUNT(*) AS total_orders
    FROM orders
    GROUP BY 
        YEAR(order_purchase_timestamp),
        MONTH(order_purchase_timestamp)
) AS t
JOIN orders o
    ON YEAR(o.order_purchase_timestamp) = t.sales_year
   AND MONTH(o.order_purchase_timestamp) = t.sales_month
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY 
    t.sales_year,
    t.sales_month,
    t.total_orders
ORDER BY 
    t.sales_year,
    t.sales_month;


SELECT 
    g.state,
    COUNT(CASE WHEN o.order_status = 'delivered' THEN 1 END) * 1.0 
        / COUNT(*) AS delivery_rate
FROM orders o
JOIN customers c 
    ON o.customer_id = c.customer_id
JOIN geo g 
    ON c.customer_zip_code_prefix = g.zip_code_prefix
WHERE g.state = 'SP'
GROUP BY g.state;


SELECT 
    g.state,
    (COUNT(CASE WHEN o.order_status = 'delivered' THEN 1 END) * 100.0 
        / COUNT(*)) AS delivery_rate_percentage
FROM orders o
JOIN customers c 
    ON o.customer_id = c.customer_id
JOIN geo g 
    ON c.customer_zip_code_prefix = g.zip_code_prefix
WHERE g.state = 'SP'
GROUP BY g.state;


SELECT 
    (COUNT(CASE WHEN g.state = 'SP' THEN 1 END) * 100.0 
        / COUNT(*)) AS sp_order_percentage
FROM orders o
JOIN customers c 
    ON o.customer_id = c.customer_id
JOIN geo g 
    ON c.customer_zip_code_prefix = g.zip_code_prefix;


SELECT 
    g.state,
    COUNT(o.order_id) AS order_count,
    ROUND(
        COUNT(o.order_id) * 100.0 /
        (SELECT COUNT(order_id) FROM order_items),
    2) AS order_percentage
FROM order_items oi
JOIN orders o 
    ON oi.order_id = o.order_id
JOIN customers c 
    ON o.customer_id = c.customer_id
JOIN geo g 
    ON c.customer_zip_code_prefix = g.zip_code_prefix
GROUP BY g.state
ORDER BY order_count DESC
LIMIT 6;



SELECT COUNT(DISTINCT order_id) FROM order_items;

SHOW TABLES;
DESCRIBE order_items;
SELECT COUNT(*) FROM order_items;

SELECT COUNT(DISTINCT order_id) FROM order_items;


SELECT order_id
FROM order_items
LIMIT 20;


SELECT order_id
FROM order_items
LIMIT 20;

SELECT COUNT(DISTINCT order_id) FROM order_items;
