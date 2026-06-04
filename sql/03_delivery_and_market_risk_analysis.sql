-- =====================================================
-- Tech Delivery and Brazillian Market Analysis
-- Eniac & Magist Business Case Study
-- =====================================================
--
-- This file analyzes delivery reliability for tech-related products,
-- delivery performance during high-demand periods, and São Paulo's
-- importance as a regional market for Magist.
--
-- Main focus:
-- - Tech product delivery performance
-- - Delivery delays by price tier
-- - High-demand month performance
-- - São Paulo delivery rate
-- - Regional order distribution
-- =====================================================

USE magist;

-- -----------------------------------------------------
-- 1. Delivery performance for tech-related products
-- Purpose:
-- Calculates the percentage of tech-related orders that were delivered on time,
-- delivered late, or not delivered.
-- -----------------------------------------------------

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


-- -----------------------------------------------------
-- 2. Average delivery time for tech-related products
-- Purpose:
-- Measures the average number of days between purchase date and customer delivery
-- for tech-related products.
-- -----------------------------------------------------

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


-- -----------------------------------------------------
-- 3. Average delivery time by product price tier
-- Purpose:
-- Compares delivery speed for cheap, medium, and premium tech products.
-- This helps evaluate whether premium products receive reliable delivery service.
-- -----------------------------------------------------

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


-- -----------------------------------------------------
-- 4. Late delivery percentage by product price tier
-- Purpose:
-- Checks whether expensive tech products have higher or lower delivery delay risk.
-- This is important for Eniac because its brand depends on premium customer experience.
-- -----------------------------------------------------

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


-- -----------------------------------------------------
-- 5. Delivery performance for tech products during high-demand months
-- Purpose:
-- Measures on-time, late, and undelivered tech orders during November and December.
-- These months are treated as high-demand months.
-- -----------------------------------------------------

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


-- -----------------------------------------------------
-- 6. Overall delivery performance during high-demand months
-- Purpose:
-- Compares general marketplace delivery performance in November and December,
-- not only tech products.
-- -----------------------------------------------------

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


-- -----------------------------------------------------
-- 7. Average delivery time during high-demand months
-- Purpose:
-- Measures average delivery time across all delivered orders in November and December.
-- -----------------------------------------------------

SELECT 
    ROUND(AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)), 2) 
        AS avg_delivery_days_high_demand
FROM orders
WHERE MONTH(order_purchase_timestamp) IN (11, 12)
  AND order_delivered_customer_date IS NOT NULL;


-- -----------------------------------------------------
-- 8. Average delivery time in the top two tech sales months
-- Purpose:
-- Finds the two months with the highest number of tech orders and calculates
-- their average delivery time.
-- -----------------------------------------------------

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

-- -----------------------------------------------------
-- 9. Monthly average delivery time for tech orders
-- Purpose:
-- Tracks delivery performance for tech orders by year and month.
-- This helps identify seasonal or operational delivery issues.
-- -----------------------------------------------------

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


-- -----------------------------------------------------
-- 10. Monthly average delivery time for all orders
-- Purpose:
-- Tracks overall marketplace delivery performance by year and month.
-- This can be compared with tech-specific delivery performance.
-- -----------------------------------------------------

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


-- -----------------------------------------------------
-- 11. Delivery rate in São Paulo
-- Purpose:
-- Calculates the delivery success rate for orders from São Paulo.
-- São Paulo is important because it represents a major commercial and tech hub.
-- -----------------------------------------------------

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


-- -----------------------------------------------------
-- 12. São Paulo delivery rate as a percentage
-- Purpose:
-- Shows the São Paulo delivery success rate in percentage format.
-- This is a cleaner version of the previous São Paulo delivery query.
-- -----------------------------------------------------

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


-- -----------------------------------------------------
-- 13. Share of total orders from São Paulo
-- Purpose:
-- Calculates what percentage of all orders come from São Paulo.
-- This helps evaluate how important São Paulo is in Magist's marketplace.
-- -----------------------------------------------------

SELECT 
    (COUNT(CASE WHEN g.state = 'SP' THEN 1 END) * 100.0 
        / COUNT(*)) AS sp_order_percentage
FROM orders o
JOIN customers c 
    ON o.customer_id = c.customer_id
JOIN geo g 
    ON c.customer_zip_code_prefix = g.zip_code_prefix;

-- -----------------------------------------------------
-- 14. Order distribution by Brazilian state
-- Purpose:
-- Shows which Brazilian states generate the most orders.
-- This helps identify Magist's strongest regional markets.
-- -----------------------------------------------------

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


