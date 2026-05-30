-- 1. Checking row counts in created tables for csv import accuracy 

SELECT COUNT(*) AS total_rows FROM orders;

SELECT COUNT(*) AS total_rows FROM order_items;

SELECT COUNT(*) AS total_rows FROM customers;

SELECT COUNT(*) AS total_rows FROM products;

SELECT COUNT(*) AS total_rows FROM sellers;

SELECT COUNT(*) AS total_rows FROM order_payments;

SELECT COUNT(*) AS total_rows FROM order_reviews;



-- 2. Checking for duplicates in values that should be unique - needed for establishing primary and foregin keys
-- Expected query results: 0 rows

-- order_id duplicate checks
SELECT
	order_id,
    COUNT(*) AS rows_count
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;

-- customer_id duplicate checks
SELECT
	customer_id,
    COUNT(*) AS rows_count
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- order_id + order_item_id duplicate checks
SELECT
	order_id,
    order_item_id,
    COUNT(*) AS rows_count
FROM order_items
GROUP BY order_id, order_item_id
HAVING COUNT(*) > 1;

-- order_id + payment_sequential duplicate checks
SELECT
	order_id,
    payment_sequential,
    COUNT(*) AS rows_count
FROM order_payments
GROUP BY order_id, payment_sequential
HAVING COUNT(*) > 1;

-- review_id duplicate checks
SELECT
	review_id,
    COUNT(*) AS rows_count
FROM order_reviews
GROUP BY review_id
HAVING COUNT(*) > 1;

-- product_category_name duplicate checks
SELECT
	product_category_name,
    COUNT(*) AS rows_count
FROM product_category_name_translation
GROUP BY product_category_name
HAVING COUNT(*) > 1;

-- product_id duplicate checks
SELECT
	product_id,
    COUNT(*) AS rows_count
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;

-- seller_id duplicate checks
SELECT
	seller_id,
    COUNT(*) AS rows_count
FROM sellers
GROUP BY seller_id
HAVING COUNT(*) > 1;


-- 3. Checking for NULL values in columns
-- Expected query results: 0 rows

-- customer_id in customers table NULL check
SELECT customer_id FROM customers  		
WHERE customer_id IS NULL;


-- order_id in order_items table NULL check
SELECT order_id FROM order_items		
WHERE order_id IS NULL;


-- order_item_id in order_items table NULL check
SELECT order_item_id FROM order_items		
WHERE order_item_id IS NULL;


-- order_id in order_payments table NULL check
SELECT order_id FROM order_payments		
WHERE order_id IS NULL;


-- payment_sequential in order_payments table NULL check
SELECT payment_sequential FROM order_payments	
WHERE payment_sequential IS NULL;


-- review_id in order_reviews table NULL check
SELECT review_id FROM order_reviews		
WHERE review_id IS NULL;


-- order_id in orders table NULL check
SELECT order_id FROM orders			
WHERE order_id IS NULL;


-- product_category_name in product_category_name_translation table NULL check
SELECT product_category_name 			
FROM product_category_name_translation	
WHERE product_category_name IS NULL;


-- product_id in products table NULL check
SELECT product_id FROM products			
WHERE product_id IS NULL;


-- seller_id in sellers table NULL check
SELECT seller_id FROM sellers			
WHERE seller_id IS NULL;


-- 4. Checking for orphaned FKs 
-- Expected query results: 0 rows

-- order_items.order_id → orders.order_id
SELECT COUNT(*) AS unmatched_rows
FROM order_items i
LEFT JOIN orders o 
    ON i.order_id = o.order_id
WHERE o.order_id IS NULL;

-- orders.customer_id → customers.customer_id
SELECT COUNT(*) AS unmatched_rows
FROM orders o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- order_items.product_id → products.product_id
SELECT COUNT(*) AS unmatched_rows
FROM order_items i
LEFT JOIN products p
    ON i.product_id = p.product_id
WHERE p.product_id IS NULL;

-- order_items.seller_id → sellers.seller_id
SELECT COUNT(*) AS unmatched_rows
FROM order_items i
LEFT JOIN sellers s
    ON i.seller_id = s.seller_id
WHERE s.seller_id IS NULL;

-- order_payments.order_id → orders.order_id
SELECT COUNT(*) AS unmatched_rows
FROM order_payments p
LEFT JOIN orders o
    ON p.order_id = o.order_id
WHERE o.order_id IS NULL;

-- order_reviews.order_id → orders.order_id
SELECT 
	COUNT(*) AS unmatched_rows
FROM order_reviews r
LEFT JOIN orders o
    ON r.order_id = o.order_id
WHERE o.order_id IS NULL;

-- 5. Additional checks

-- Checking order status counts 
SELECT 
    order_status,
    COUNT(*) AS orders_count
FROM orders
GROUP BY order_status
ORDER BY orders_count DESC;
-- decided  to only use "delivered" orders for metrics calculation based on the result

-- Anomalies check: price value 
SELECT 
	order_id,
    product_id
FROM order_items
WHERE price < 0;

-- Anomalies check: payment value 
SELECT 
	order_id,
    payment_value
FROM order_payments
WHERE payment_value < 0; 

-- Anomalies check: review scores
SELECT
	review_id,
    review_score
FROM order_reviews
WHERE review_score NOT IN (1, 2, 3, 4, 5);

-- Anomalies check: delivery dates
SELECT
	order_id,
    order_purchase_timestamp,
    order_delivered_customer_date,
    order_delivered_carrier_date
FROM orders
WHERE 
	DATE(order_purchase_timestamp) > DATE(order_delivered_customer_date)
OR
    DATE(order_purchase_timestamp) > DATE(order_delivered_carrier_date)
;
