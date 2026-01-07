/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - To compare performance or metrics across dimensions or time periods.
    - To evaluate differences between categories.
    - Useful for A/B testing or regional comparisons.

SQL Functions Used:
    - SUM(), AVG(): Aggregates values for comparison.
    - Window Functions: SUM() OVER() for total calculations.
===============================================================================
*/
--Which categories contribute most to the overall sales
WITH category_sales AS(
SELECT 
p.category AS category,
SUM(s.sales_amount) AS total_sales
FROM gold.fact_sales s LEFT JOIN gold.dim_products p
ON s.product_key = p.product_key
GROUP BY p.category
)
SELECT
category,
total_sales,
SUM(total_sales) OVER() AS overall_total,
CONCAT(ROUND((CAST(total_sales AS FLOAT)/SUM(total_sales) OVER())* 100, 2), '%') AS percentage_of_total
FROM category_sales
ORDER BY total_sales DESC

--Which country is contributing to the overall sales
WITH country_sales AS(
SELECT 
c.country AS country,
SUM(s.sales_amount) AS total_sales
FROM gold.fact_sales s LEFT JOIN gold.dim_customers c
ON s.customer_key = c.customer_key
GROUP BY c.country
)
SELECT
country,
total_sales,
SUM(total_sales) OVER() AS overall_total,
CONCAT(ROUND((CAST(total_sales AS FLOAT)/SUM(total_sales) OVER())* 100, 2), '%') AS percentage_of_total
FROM country_sales
ORDER BY total_sales DESC
