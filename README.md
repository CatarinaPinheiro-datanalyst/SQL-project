# SQL-project

# 📊 SQL Sales Analysis

## 📌 About the Project
This project performs an **SQL**-based analysis of sales data from the `df_orders` table. It includes revenue insights, top-performing products, regional sales distribution, and year-over-year growth trends.

## 📂 Queries Overview

1. **Retrieve All Orders**:
   ```sql
   SELECT * FROM df_orders;
   ```

2. **Top 10 Highest Revenue-Generating Products**:
   ```sql
   SELECT product_id, SUM(sale_price) AS sales
   FROM df_orders
   GROUP BY product_id
   ORDER BY sales DESC
   LIMIT 10;
   ```

3. **Top 5 Highest Selling Products in Each Region**:
   ```sql
   SELECT product_id, region, SUM(sale_price) AS sales
   FROM df_orders
   WHERE region = 'Central'
   GROUP BY product_id, region
   ORDER BY sales DESC
   LIMIT 5;
   ```
   *(Repeat for other regions: East, South, West)*

4. **Month-over-Month Growth Comparison for 2022 vs 2023**:
   ```sql
   WITH cte AS (
       SELECT YEAR(order_date) AS order_year, MONTH(order_date) AS order_month, SUM(sale_price) AS sales
       FROM df_orders
       GROUP BY YEAR(order_date), MONTH(order_date)
   )
   SELECT order_month,
          SUM(CASE WHEN order_year=2022 THEN sales ELSE 0 END) AS sales_2022,
          SUM(CASE WHEN order_year=2023 THEN sales ELSE 0 END) AS sales_2023
   FROM cte
   GROUP BY order_month
   ORDER BY order_month;
   ```

5. **Month with Highest Sales per Category**:
   ```sql
   WITH cte AS (
       SELECT category, DATE_FORMAT(order_date, '%Y-%m') AS order_year_month, SUM(sale_price) AS sales
       FROM df_orders
       GROUP BY category, DATE_FORMAT(order_date, '%Y-%m')
   )
   SELECT * FROM (
       SELECT *, ROW_NUMBER() OVER(PARTITION BY category ORDER BY sales DESC) AS rn
       FROM cte
   ) a WHERE rn=1;
   ```

6. **Sub-Category with Highest Growth in 2023 Compared to 2022**:
   ```sql
   WITH cte AS (
       SELECT sub_category, YEAR(order_date) AS order_year, SUM(sale_price) AS sales
       FROM df_orders
       GROUP BY sub_category, YEAR(order_date)
   ), cte2 AS (
       SELECT sub_category,
              SUM(CASE WHEN order_year=2022 THEN sales ELSE 0 END) AS sales_2022,
              SUM(CASE WHEN order_year=2023 THEN sales ELSE 0 END) AS sales_2023
       FROM cte
       GROUP BY sub_category
   )
   SELECT *, (sales_2023 - sales_2022) AS profit_2023
   FROM cte2
   ORDER BY profit_2023 DESC;
   ```

## 🛠 How to Use
1. Ensure you have access to a SQL database engine (MySQL, PostgreSQL, etc.).
2. Import your dataset into the database.
3. Run the provided SQL queries to extract insights.

## 📎 Repository Files
- `df_orders_SQL.sql` - SQL script containing the queries.
- `README.md` - This document describing the project.

## 📢 Contributions
Feel free to fork this repository, submit issues, or open a pull request with improvements.

## 📧 Contact
For questions or suggestions, reach out via [email](catarinafvp@gmail.com) or [LinkedIn]: (linkedin.com/in/catarina-pinheiro-a1b987186).

