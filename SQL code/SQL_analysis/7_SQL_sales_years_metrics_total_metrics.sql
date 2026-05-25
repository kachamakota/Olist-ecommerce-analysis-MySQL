-- -- Creating an annual sales metrics view for yearly performance comparison across 2016, 2017, and 2018

CREATE OR REPLACE VIEW vw_annual_metrics AS
WITH cte1 AS (
	SELECT
		YEAR(order_purchase_timestamp) AS sales_year,
        COUNT(DISTINCT(DATE_FORMAT(order_purchase_timestamp, '%Y-%m-01'))) AS active_months,
		SUM(price) AS sales_year_revenue,
		COUNT(DISTINCT(o.order_id)) AS sales_year_orders,
		COUNT(DISTINCT(customer_unique_id)) AS sales_year_customers
	FROM orders o
	JOIN order_items i ON o.order_id = i.order_id
	WHERE o.order_status = 'delivered'
	GROUP BY sales_year
)
SELECT
	sales_year,
    active_months,
    sales_year_revenue,
    sales_year_orders,
    ROUND(sales_year_revenue/NULLIF(sales_year_orders, 0), 2) AS annual_average_order_value,  			-- AOV,
	ROUND(sales_year_revenue/NULLIF(sales_year_customers, 0), 2) AS annual_average_rev_per_customer, 	-- ARPC
	ROUND(sales_year_orders/NULLIF(sales_year_customers, 0), 2) AS average_orders_per_customer, 			-- OPC
    ROUND(sales_year_revenue/active_months, 2) AS average_monthly_revenue,
	ROUND(sales_year_orders/active_months, 2) AS average_monthly_orders
FROM cte1
;

SELECT * FROM vw_annual_metrics;


-- Creating an overall sales metrics view for the full available dataset

CREATE OR REPLACE VIEW vw_total_metrics AS
SELECT
    ROUND(SUM(price), 2) AS total_revenue,  -- calculating total revenue does not include freight costs paid by customer
    COUNT(DISTINCT(o.order_id)) AS total_orders,
    COUNT(DISTINCT(customer_unique_id)) AS total_customers,
	COUNT(DISTINCT(seller_id)) AS total_sellers,
    COUNT(DISTINCT(product_id)) AS total_products,
    ROUND(SUM(price)/COUNT(DISTINCT(o.order_id)), 2) AS average_order_value,  -- AOV
    ROUND(SUM(price)/COUNT(DISTINCT(customer_unique_id)), 2) AS average_rev_per_customer -- ARPC
FROM orders o
JOIN order_items i ON o.order_id = i.order_id
WHERE o.order_status = 'delivered'   -- filtering out all orders with status other than DELIVERED
;

SELECT * FROM vw_total_metrics;
    