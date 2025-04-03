select * from df_orders;

#find top 10 highest revenue generating products
SELECT product_id, sum(sale_price) AS sales
FROM df_orders
GROUP BY product_id
ORDER BY sales DESC
LIMIT 10;

#find top 5 highest selling products in each region
SELECT product_id, region, SUM(sale_price) as sales
FROM df_orders
WHERE region = 'Central'
GROUP BY product_id, region
ORDER BY sales DESC
LIMIT 5;

SELECT product_id, region, SUM(sale_price) as sales
FROM df_orders
WHERE region = 'East'
GROUP BY product_id, region
ORDER BY sales DESC
LIMIT 5;

SELECT product_id, region, SUM(sale_price) as sales
FROM df_orders
WHERE region = 'South'
GROUP BY product_id, region
ORDER BY sales DESC
LIMIT 5;

SELECT product_id, region, SUM(sale_price) as sales
FROM df_orders
WHERE region = 'West'
GROUP BY product_id, region
ORDER BY sales DESC
LIMIT 5;

#find month over month growth comparison for 2022 sales eg: jan 2022 vs jan 2023
WITH cte AS (
SELECT year(order_date) AS order_year, month(order_date) AS order_month, SUM(sale_price) AS sales
FROM df_orders
GROUP BY year(order_date), month(order_date)
#ORDER BY year(order_date), month(order_date)
	)
SELECT order_month
, SUM(CASE WHEN order_year=2022 THEN sales ELSE 0 END) AS sales_2022
, SUM(CASE WHEN order_year=2023 THEN sales ELSE 0 END) AS sales_2023
FROM cte
GROUP BY order_month
ORDER BY order_month;

#for each category which month had highest sales
WITH cte AS (
SELECT category, date_format(order_date, '%Y-%m') AS order_year_month, SUM(sale_price) AS sales
FROM df_orders
GROUP BY category, date_format(order_date, '%Y-%m')
	)
SELECT * FROM (
SELECT *,
ROW_NUMBER() OVER(PARTITION BY category ORDER BY sales DESC) AS rn
FROM cte
) a
WHERE rn=1;

#which sub category had highest growth by profit in 2023 compare to 2022
WITH cte AS (
SELECT sub_category, year(order_date) AS order_year, SUM(sale_price) AS sales
FROM df_orders
GROUP BY sub_category, year(order_date)
	)
, cte2 as(
SELECT sub_category
, SUM(CASE WHEN order_year=2022 THEN sales ELSE 0 END) AS sales_2022
, SUM(CASE WHEN order_year=2023 THEN sales ELSE 0 END) AS sales_2023
FROM cte
GROUP BY sub_category
)
SELECT *
, (sales_2023-sales_2022) AS profit_2023
FROM cte2
ORDER BY (sales_2023-sales_2022) DESC;