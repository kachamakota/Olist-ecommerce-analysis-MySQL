-- Validating data completeness and quality 


-- Products without assigned category - check before creating TOP CATEGORIES views
SELECT
    COUNT(*) AS products_without_category
FROM products
WHERE product_category_name IS NULL;
-- result: 610  -> these products will be excluded from Top Categories analysis


-- Product categories without Portugese to English translations
SELECT
    p.product_category_name,
    COUNT(*) AS product_count
FROM products p
LEFT JOIN product_category_name_translation tr
    ON p.product_category_name = tr.product_category_name
WHERE p.product_category_name IS NOT NULL
  AND tr.product_category_name_english IS NULL
GROUP BY p.product_category_name
ORDER BY product_count DESC;
-- result: 13 products total  -> these products will be excluded from Top Categories analysis


-- Order items without seller_id check before creating TOP SELLERS views
SELECT
    COUNT(*) AS no_seller
FROM order_items
WHERE seller_id IS NULL;
-- result: 0 -> check ok, no adjustments needed

-- Delivered orders without customer delivery date 
SELECT
    COUNT(*) AS no_del_date
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NULL;
-- result: 8 -> these orders will be excluded from delivery quality analysis

-- Delivered orders without estimated delivery date
SELECT
    COUNT(*) AS no_est_date
FROM orders
WHERE order_status = 'delivered'
  AND order_estimated_delivery_date IS NULL;
-- result: 0 


-- checking order structure for repeating customers and orders per customer etc. calculations:
WITH cte1 AS(
	SELECT 
		customer_unique_id,
		order_id,
		order_purchase_timestamp,
		LAG(order_purchase_timestamp) OVER (
		PARTITION BY customer_unique_id 
		ORDER BY order_purchase_timestamp
		) AS prev_cust_order_date,
		ROW_NUMBER() OVER (
		PARTITION BY customer_unique_id 
		ORDER BY order_purchase_timestamp
		) AS order_cust_no
	FROM orders
    WHERE order_status = 'delivered'
	),
cte2 AS (
	SELECT
		customer_unique_id,
		order_id,
		order_purchase_timestamp,
		prev_cust_order_date,
		DATEDIFF(order_purchase_timestamp, prev_cust_order_date) AS days_since_previous_order
		FROM cte1
	WHERE order_cust_no > 1 AND TIMESTAMPDIFF(SECOND, order_purchase_timestamp, prev_cust_order_date) < 59
    )
SELECT 
	COUNT(*)
FROM cte2;
-- result: 3120 this indicates splitting orders using marketplace/order processing logic.
-- however for this project, the original Olist order_id grain was preserved.