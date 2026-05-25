CREATE OR REPLACE VIEW vw_3M_metrics AS
WITH cte1 AS
(SELECT 
    o.order_id,
    DATE(DATE_FORMAT(order_purchase_timestamp, '%Y-%m-01')) AS month_date,
	SUM(price) AS rev
FROM orders o
JOIN order_items i ON o.order_id = i.order_id
WHERE o.order_status = 'delivered'
GROUP BY o.order_id
),
cte2 AS
(SELECT 
	month_date,
    SUM(rev) AS monthly_rev,
    COUNT(*) AS no_orders,
    SUM(rev)/COUNT(*) AS aov
FROM cte1
GROUP BY month_date
)
SELECT
	calendar_month,
    ROUND(COALESCE(monthly_rev, 0), 2) AS monthly_rev,
	ROUND(AVG(COALESCE(monthly_rev,0)) OVER (ORDER BY calendar_month
    ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2) AS ravg_rev_3m,
    COALESCE(no_orders, 0) AS monthly_orders,
    AVG(COALESCE(no_orders, 0)) OVER (ORDER BY calendar_month
    ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS ravg_orders_3m
FROM calendar c
LEFT JOIN cte2
	ON c.calendar_month = cte2.month_date
WHERE c.calendar_month BETWEEN '2016-01-01' AND '2018-08-01'
ORDER BY c.calendar_month ASC
;

SELECT * FROM vw_3m_metrics;

    