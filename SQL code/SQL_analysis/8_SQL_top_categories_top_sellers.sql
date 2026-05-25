-- Creating a TOP CATEGORIES view

CREATE OR REPLACE VIEW vw_top_categories AS
WITH cte1 AS(
	SELECT 
		o.order_purchase_timestamp,
		i.price,
		product_category_name_english
	FROM orders o 
	JOIN order_items i ON o.order_id = i.order_id
	JOIN products p ON i.product_id = p.product_id
	JOIN product_category_name_translation tr ON p.product_category_name = tr.product_category_name
    WHERE order_status = 'delivered'
)
,
cte2 AS(
	SELECT
		YEAR(order_purchase_timestamp) AS sales_year,
        product_category_name_english AS category,
        SUM(price) AS revenue
	FROM cte1
    GROUP BY 1,2
)
,
cte3 AS(
	SELECT
		sales_year,
		category,
        revenue,
		ROW_NUMBER() OVER (PARTITION BY sales_year ORDER BY revenue DESC) AS ranking
	FROM cte2
)
SELECT
		sales_year,
		category,
        ROUND(revenue, 0) AS revenue,
		ranking
	FROM cte3
    WHERE ranking <= 10  			
    ORDER BY sales_year, ranking
;

SELECT * FROM vw_top_categories;


-- Creating a TOP SELLERS view

CREATE OR REPLACE VIEW vw_top_sellers AS
    SELECT 
        seller_id,
        SUM(price) AS seller_revenue,
        COUNT(DISTINCT (i.order_id)) AS order_count
    FROM
        order_items i
            JOIN
        orders o ON i.order_id = o.order_id
    WHERE
        o.order_status = 'delivered'
    GROUP BY seller_id
    ORDER BY order_count DESC
;
