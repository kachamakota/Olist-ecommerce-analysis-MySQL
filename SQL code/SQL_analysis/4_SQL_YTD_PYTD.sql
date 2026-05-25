CREATE OR REPLACE VIEW vw_YTD_PYTD AS
WITH cte1 AS(
    SELECT
        DATE(DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m-01')) AS calendar_month,
        SUM(i.price) AS monthly_revenue
    FROM orders o
    JOIN order_items i
        ON o.order_id = i.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY calendar_month
),
cte2 AS(
    SELECT
        c.calendar_month,
        COALESCE(cte1.monthly_revenue, 0) AS monthly_revenue
    FROM calendar c
    LEFT JOIN cte1
        ON c.calendar_month = cte1.calendar_month
    WHERE c.calendar_month BETWEEN '2016-01-01' AND '2018-08-01'
),
cte3 AS(
    SELECT
        calendar_month,
        monthly_revenue,
        SUM(monthly_revenue)
        OVER(
            PARTITION BY YEAR(calendar_month)
            ORDER BY calendar_month
        ) AS ytd_revenue
    FROM cte2
),
cte4 AS(
    SELECT
        calendar_month,
        monthly_revenue,
        ytd_revenue,
        LAG(ytd_revenue, 12)
        OVER (ORDER BY calendar_month) AS pytd_revenue
    FROM cte3
)
SELECT
    calendar_month,
    ROUND(monthly_revenue, 2) AS monthly_revenue,
    ROUND(ytd_revenue, 2) AS ytd_revenue,
    ROUND(pytd_revenue, 2) AS pytd_revenue,
    ROUND(
        (ytd_revenue - pytd_revenue) / NULLIF(pytd_revenue, 0),
    4) AS ytd_change_pct
FROM cte4
;

SELECT * FROM vw_YTD_PYTD;