-- =====================================================
-- Eniac & Magist Business Analysis
-- 01 - Initial Magist Database Exploration
-- =====================================================
--
-- Purpose:
-- This file explores the basic structure and activity of the Magist database.
-- It answers questions about orders, delivery status, user growth, products,
-- product categories, transactions, prices, and payments.
--
-- Database: magist
-- =====================================================

USE magist;

-- 1. How many orders are there in the dataset? 
SELECT 
    COUNT(*)
FROM
    orders;

SELECT 
    COUNT(distinct order_id)
FROM
    orders;

-- 2. Are orders actually delivered?
SELECT 
    order_status, COUNT(*) as num_orders
FROM
    orders
GROUP BY order_status;


-- 3. Is Magist having user growth? 
-- by orders placed
SELECT 
    YEAR(order_purchase_timestamp) `year`,
    MONTH(order_purchase_timestamp) `month`,
    COUNT(*)
FROM
    orders
GROUP BY YEAR(order_purchase_timestamp) , MONTH(order_purchase_timestamp) WITH ROLLUP
ORDER BY YEAR(order_purchase_timestamp) , MONTH(order_purchase_timestamp);


 -- by revenue
SELECT 
    YEAR(order_purchase_timestamp) `year`,
    MONTH(order_purchase_timestamp) `month`,
    SUM(price)
FROM
    order_items
        JOIN
    orders USING (order_id)
GROUP BY 
	YEAR(order_purchase_timestamp), 
	MONTH(order_purchase_timestamp) 
    WITH ROLLUP
ORDER BY 
	YEAR(order_purchase_timestamp), 
    MONTH(order_purchase_timestamp);


-- 4. How many products are there on the products table?
SELECT 
    COUNT(*)
FROM
    products;

SELECT 
    COUNT(distinct product_id)
FROM
    products;

-- 5. Which are the categories with the most products?
SELECT 
    product_category_name_english, COUNT(*) num_products
FROM
    products
		LEFT JOIN
    product_category_name_translation USING (product_category_name)
GROUP BY product_category_name_english
ORDER BY COUNT(*) DESC
LIMIT 20;


-- 6. How many of those products were present in actual transactions? 
SELECT 
    COUNT(DISTINCT product_id)
FROM
    order_items; 
    
SELECT 
    round((COUNT(DISTINCT oi.product_id) / COUNT(DISTINCT p.product_id)) * 100 , 2) AS `%_of_products_in_orders`
FROM
    products p
        LEFT JOIN
    order_items oi USING (product_id); 
    
    
-- 7. What’s the price for the most expensive and cheapest products? 
SELECT 
    MAX(price) `most expensive`, MIN(price) cheapest
FROM
    order_items;
    
    
-- 8. What are the highest and lowest payment values? 
SELECT 
    MAX(payment_value) highest, 
    MIN(payment_value) lowest
FROM
    order_payments;


-- Maximum someone has paid for an order
SELECT
    order_id, SUM(payment_value) AS highest_order
FROM
    order_payments
GROUP BY
    order_id
ORDER BY
    highest_order DESC
LIMIT
    1;