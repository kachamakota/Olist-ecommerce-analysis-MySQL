CREATE OR REPLACE VIEW vw_delivery_time_stats AS
SELECT 
	customer_state,
    COUNT(DISTINCT o.order_id) AS orders_count,
	DATE(DATE_FORMAT(order_purchase_timestamp, '%Y-%m-01')) AS order_month,
    AVG(
		TIMESTAMPDIFF(
		DAY,
		order_purchase_timestamp,
		order_delivered_customer_date
        )
	) AS avg_delivery_days,  -- Average actual number of days needed for delivery, calculated for each state, each month
    AVG(
		TIMESTAMPDIFF(
		DAY,
		order_purchase_timestamp,
		order_estimated_delivery_date
        )
	) AS avg_estimated_delivery_days, -- Average number of days estimated for delivery
     AVG(
		TIMESTAMPDIFF(
		DAY,
		order_estimated_delivery_date,
		order_delivered_customer_date
        )
	) AS avg_delivery_gap_days, -- Average delay in days
    SUM(
        CASE 
            WHEN DATE(o.order_delivered_customer_date) > DATE(o.order_estimated_delivery_date)
            THEN 1 
            ELSE 0 
        END
    ) AS late_orders,  -- counting late orders
     ROUND(
        SUM(
            CASE 
                WHEN DATE(o.order_delivered_customer_date) > DATE(o.order_estimated_delivery_date)
                THEN 1 
                ELSE 0 
            END
        ) / COUNT(DISTINCT o.order_id),
        4) AS late_pct, -- comparing late orders to total orders amount
    ROUND(
        AVG(
            CASE 
                WHEN DATE(o.order_delivered_customer_date) > DATE(o.order_estimated_delivery_date)
                THEN TIMESTAMPDIFF(
                    DAY,
                    o.order_estimated_delivery_date,
                    o.order_delivered_customer_date
                )
            END
        ), 2) AS avg_delay_late_orders_only
FROM orders o
JOIN customers c 
    ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
GROUP BY customer_state, order_month
ORDER BY customer_state, order_month;

-- SELECT * FROM vw_delivery_time_stats;
