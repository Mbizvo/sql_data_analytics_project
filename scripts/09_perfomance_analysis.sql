/*
===============================================================================
Performance Analysis (Year-over-Year, Month-over-Month)
===============================================================================
Purpose:
    - To measure the performance of products, customers, or regions over time.
    - For benchmarking and identifying high-performing entities.
    - To track yearly trends and growth.

SQL Functions Used:
    - LAG(): Accesses data from previous rows.
    - AVG() OVER(): Computes average values within partitions.
    - CASE: Defines conditional logic for trend analysis.
===============================================================================
*/
--Analyze the yearly perfomance of products by comparing each products sales
--by its average sales and its previous years sales
WITH yearly_product_sales AS(
SELECT 
YEAR(s.order_date) AS yearly_orders,
p.product_name,
SUM(s.sales_amount) AS current_sales
FROM gold.fact_sales s LEFT JOIN gold.dim_products p
ON s.product_key = p.product_key
WHERE YEAR(s.order_date) IS NOT NULL
GROUP BY p.product_name, 
YEAR(s.order_date)
)
SELECT 
yearly_orders,
product_name,
current_sales,
AVG(current_sales) OVER(PARTITION BY product_name) AS avg_sales,
current_sales - AVG(current_sales) OVER(PARTITION BY product_name) diff_in_avg,
CASE 
	WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) > 0 THEN 'Above_Avg'
	WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) < 0 THEN 'Below_Avg'
	ELSE 'Avg'
END AS avg_change,
LAG(current_sales) OVER(PARTITION BY product_name ORDER BY yearly_orders) AS prev_yr_sales,
current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY yearly_orders) AS diff_prev_yr,
CASE 
	WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY yearly_orders) > 0 THEN 'Increased'
	WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY yearly_orders) < 0 THEN 'Decreased'
	ELSE 'No_Change'
END AS avg_change
FROM yearly_product_sales
GROUP BY 
yearly_orders,
product_name,
current_sales;
