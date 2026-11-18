-- =====================================================================
-- analysis.sql  –  business questions answered with SQL (MySQL 8)
-- Every query starts from the clean `sales` view (02_indexes_and_view.sql)
-- =====================================================================
USE olist;

-- Q0. Headline numbers
SELECT COUNT(DISTINCT order_id)           AS delivered_orders,
       COUNT(DISTINCT customer_unique_id) AS customers,
       ROUND(SUM(price), 0)               AS revenue,
       ROUND(SUM(freight_value), 0)       AS freight,
       ROUND(SUM(price) / COUNT(DISTINCT order_id), 2) AS avg_order_value
FROM sales;

-- Q1. Monthly revenue, orders and average order value
SELECT month,
       ROUND(SUM(price), 0)                            AS revenue,
       COUNT(DISTINCT order_id)                        AS orders,
       ROUND(SUM(price) / COUNT(DISTINCT order_id), 2) AS avg_order_value
FROM sales
GROUP BY month
ORDER BY month;

-- Q2. Month-over-month growth (window function LAG)
--     2016 has only a few test orders and Sep/Oct 2018 are incomplete, so only full months are used
WITH m AS (
    SELECT month, SUM(price) AS revenue
    FROM sales
    WHERE month BETWEEN '2017-01' AND '2018-08'
    GROUP BY month
)
SELECT month,
       ROUND(revenue, 0) AS revenue,
       ROUND(100 * (revenue - LAG(revenue) OVER (ORDER BY month))
                 / LAG(revenue) OVER (ORDER BY month), 1) AS growth_pct
FROM m
ORDER BY month;

-- Q3. Top 10 categories by revenue, with share of total
SELECT category,
       ROUND(SUM(price), 0) AS revenue,
       ROUND(100 * SUM(price) / SUM(SUM(price)) OVER (), 1) AS pct_of_total
FROM sales
GROUP BY category
ORDER BY revenue DESC
LIMIT 10;

-- Q4. Revenue and customers by state
SELECT customer_state,
       ROUND(SUM(price), 0) AS revenue,
       ROUND(100 * SUM(price) / SUM(SUM(price)) OVER (), 1) AS pct_of_total,
       COUNT(DISTINCT customer_unique_id) AS customers
FROM sales
GROUP BY customer_state
ORDER BY revenue DESC;

-- Q5. Delivery performance
SELECT ROUND(AVG(delivery_days), 1) AS avg_delivery_days,
       ROUND(100 * AVG(is_late), 1) AS pct_late
FROM (SELECT DISTINCT order_id, delivery_days, is_late FROM sales) d;

-- Q6. Do late deliveries get worse reviews?
SELECT CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date
            THEN 'late' ELSE 'on time' END AS delivery,
       ROUND(AVG(r.review_score), 2) AS avg_review,
       COUNT(*) AS orders
FROM orders o
JOIN order_reviews r ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY delivery;

-- Q7. Top 3 sellers in each state (window function RANK)
WITH s AS (
    SELECT se.seller_state,
           i.seller_id,
           ROUND(SUM(i.price), 0) AS revenue,
           RANK() OVER (PARTITION BY se.seller_state ORDER BY SUM(i.price) DESC) AS rnk
    FROM order_items i
    JOIN orders o   ON i.order_id = o.order_id AND o.order_status = 'delivered'
    JOIN sellers se ON i.seller_id = se.seller_id
    GROUP BY se.seller_state, i.seller_id
)
SELECT *
FROM s
WHERE rnk <= 3
ORDER BY seller_state, rnk;

-- Q8. How many customers ordered more than once?
SELECT ROUND(100 * AVG(n > 1), 2) AS pct_repeat_customers
FROM (SELECT customer_unique_id, COUNT(DISTINCT order_id) AS n
      FROM sales
      GROUP BY customer_unique_id) x;

-- Q9. Payment methods (share of payment value)
SELECT p.payment_type,
       COUNT(DISTINCT p.order_id)                                   AS orders,
       ROUND(100 * SUM(p.payment_value) / SUM(SUM(p.payment_value)) OVER (), 1) AS pct_of_value,
       ROUND(AVG(p.payment_installments), 1)                        AS avg_installments
FROM order_payments p
JOIN orders o ON p.order_id = o.order_id AND o.order_status = 'delivered'
GROUP BY p.payment_type
ORDER BY pct_of_value DESC;

-- Q10. Delivery time and late % by customer state (slowest first)
SELECT customer_state,
       COUNT(*)                      AS orders,
       ROUND(AVG(delivery_days), 1)  AS avg_delivery_days,
       ROUND(100 * AVG(is_late), 1)  AS pct_late
FROM (SELECT DISTINCT order_id, customer_state, delivery_days, is_late FROM sales) d
GROUP BY customer_state
HAVING COUNT(*) >= 100
ORDER BY avg_delivery_days DESC;
