CREATE OR REPLACE VIEW vw_MoM_YoY AS
WITH cte1 AS(
	SELECT
		DATE(DATE_FORMAT(order_purchase_timestamp, '%Y-%m-01')) AS month_date,
		SUM(price) AS rev
	FROM orders o
	JOIN order_items i ON o.order_id = i.order_id
	WHERE o.order_status = 'delivered'
	GROUP BY month_date
	),
cte2 AS(
	SELECT
		calendar_month,
        rev
	FROM calendar c
    LEFT JOIN cte1 ON c.calendar_month = cte1.month_date
    WHERE c.calendar_month BETWEEN '2016-01-01' AND '2018-08-01'
    ),
cte3 AS(
	SELECT
		calendar_month,
		COALESCE(rev, 0) AS monthly_revenue,
		LAG(COALESCE(rev, 0)) OVER (ORDER BY calendar_month) AS previous_month_rev,
		LAG((COALESCE(rev, 0)), 12) OVER (ORDER BY calendar_month) AS previous_year_rev
	FROM cte2
    )
SELECT
	calendar_month,
    ROUND(
		monthly_revenue, 
		2) AS monthly_revenue,
    ROUND(
		previous_month_rev, 
		2) AS previous_month_rev,
    ROUND(
		(monthly_revenue - previous_month_rev) / NULLIF(previous_month_rev, 0), 
		4) AS mom_growth_pct,
	ROUND(
		previous_year_rev, 
        2) AS previous_year_rev,
   ROUND(
		(monthly_revenue - previous_year_rev) / NULLIF(previous_year_rev, 0), 
        4) AS yoy_growth_pct
FROM cte3
;

SELECT * FROM vw_MoM_YoY;