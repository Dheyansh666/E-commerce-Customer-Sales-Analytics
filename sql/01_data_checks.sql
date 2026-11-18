-- =====================================================================
-- 01_data_checks.sql  –  data quality checks after loading the CSVs
-- Database: olist (MySQL 8)
-- =====================================================================
USE olist;

-- 1. How many orders per status?
SELECT order_status, COUNT(*) AS orders
FROM orders
GROUP BY order_status
ORDER BY orders DESC;

-- 2. Any duplicate order ids?
SELECT order_id, COUNT(*) AS c
FROM orders
GROUP BY order_id
HAVING c > 1;

-- 3. Delivered orders with no delivery date (bad rows)
SELECT COUNT(*) AS delivered_without_date
FROM orders
WHERE order_status = 'delivered' AND order_delivered_customer_date IS NULL;

-- 4. Products with no category
SELECT COUNT(*) AS products_without_category
FROM products
WHERE product_category_name IS NULL;

-- 5. Real customers vs customer ids (Olist creates a new customer_id for every order)
SELECT COUNT(DISTINCT customer_id)        AS customer_ids,
       COUNT(DISTINCT customer_unique_id) AS real_customers
FROM customers;

-- 6. Categories with no English translation
SELECT COUNT(DISTINCT p.product_category_name) AS untranslated_categories
FROM products p
LEFT JOIN category_translation t ON p.product_category_name = t.product_category_name
WHERE p.product_category_name IS NOT NULL AND t.product_category_name IS NULL;

-- 7. Date range of the data
SELECT MIN(order_purchase_timestamp) AS first_order,
       MAX(order_purchase_timestamp) AS last_order
FROM orders;
