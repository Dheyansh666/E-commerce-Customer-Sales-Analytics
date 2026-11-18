-- =====================================================================
-- 02_indexes_and_view.sql  –  indexes on join keys + one clean view
-- Run once after 01_load.ipynb has loaded the tables.
-- =====================================================================
USE olist;

-- Indexes on the columns we join and filter on (big speed-up for the view below)
CREATE INDEX idx_orders_order      ON orders (order_id);
CREATE INDEX idx_orders_customer   ON orders (customer_id);
CREATE INDEX idx_orders_status     ON orders (order_status);
CREATE INDEX idx_customers_id      ON customers (customer_id);
CREATE INDEX idx_customers_unique  ON customers (customer_unique_id);
CREATE INDEX idx_items_order       ON order_items (order_id);
CREATE INDEX idx_items_product     ON order_items (product_id);
CREATE INDEX idx_items_seller      ON order_items (seller_id);
CREATE INDEX idx_products_id       ON products (product_id);
CREATE INDEX idx_sellers_id        ON sellers (seller_id);
CREATE INDEX idx_reviews_order     ON order_reviews (order_id);
CREATE INDEX idx_payments_order    ON order_payments (order_id);
CREATE INDEX idx_translation_name  ON category_translation (product_category_name);

-- Cleaning rules (see README):
--   1. Only order_status = 'delivered' counts as revenue.
--   2. Revenue = price from order_items (product sales). Freight is reported separately.
--   3. Count real people with customer_unique_id, not customer_id.
--   4. Products with no category are shown as 'unknown'.
CREATE OR REPLACE VIEW sales AS
SELECT o.order_id,
       c.customer_unique_id,
       c.customer_state,
       o.order_purchase_timestamp                                   AS purchase_time,
       DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')             AS month,
       i.product_id,
       i.seller_id,
       i.price,
       i.freight_value,
       COALESCE(t.product_category_name_english,
                p.product_category_name, 'unknown')                 AS category,
       DATEDIFF(o.order_delivered_customer_date,
                o.order_purchase_timestamp)                         AS delivery_days,
       o.order_delivered_customer_date > o.order_estimated_delivery_date AS is_late
FROM orders o
JOIN customers c         ON o.customer_id = c.customer_id
JOIN order_items i       ON o.order_id = i.order_id
LEFT JOIN products p     ON i.product_id = p.product_id
LEFT JOIN category_translation t
                         ON p.product_category_name = t.product_category_name
WHERE o.order_status = 'delivered';
