/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    - To group data into meaningful categories for targeted insights.
    - For customer segmentation, product categorization, or regional analysis.

SQL Functions Used:
    - CASE: Defines custom segmentation logic.
    - GROUP BY: Groups data into segments.
===============================================================================
*/
--segment products into cost ranges and count how many products fall into each range

WITH products_cost_segment AS(
SELECT 
product_key,
product_number,
product_name,
CASE
WHEN cost < 500 THEN 'Below 500'
WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
WHEN cost BETWEEN 1000 AND 1500 THEN '1000-1500'
WHEN cost BETWEEN 1500 AND 2000 THEN '1500-2000'
ELSE 'Above 2000'
END AS products_cost_range
FROM gold.dim_products
)
SELECT 
products_cost_range,
COUNT(product_key) AS total_products
FROM products_cost_segment
GROUP BY
products_cost_range
ORDER BY total_products DESC

--Segment customers into 3 categories based on their spending and behaviour
--VIP: at least 12 months of history and spending of more than 500
--Regular: at least 12 months of history and spending of 500 or less
--New: less than 12 months of history
WITH customers_spending_history AS(
SELECT
c.customer_key,
MIN(f.order_date) AS first_order,
MAX(f.order_date) AS last_order,
DATEDIFF(MONTH, MIN(f.order_date), MAX(f.order_date)) AS lifespan,
SUM(f.sales_amount) AS total_spending
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON f.customer_key = c.customer_key
WHERE f.order_date IS NOT NULL
GROUP BY 
c.customer_key
)
SELECT 
customer_key,
lifespan,
total_spending,
CASE 
	WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
	WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
	ELSE 'New'
END AS customer_segment
FROM customers_spending_history
ORDER BY total_spending DESC



--Segment customers into 3 categories based on their spending and behaviour, and also count customers in each category
--VIP: at least 12 months of history and spending of more than 500
--Regular: at least 12 months of history and spending of 500 or less
--New: less than 12 months of history
WITH customer_spending_history AS(
SELECT
c.customer_key,
MIN(f.order_date) AS first_order,
MAX(f.order_date) AS last_order,
DATEDIFF(MONTH, MIN(f.order_date), MAX(f.order_date)) AS lifespan,
SUM(f.sales_amount) AS total_spending
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON f.customer_key = c.customer_key
WHERE f.order_date IS NOT NULL
GROUP BY 
c.customer_key
)
SELECT DISTINCT customer_segment,
SUM(customer_key) OVER(PARTITION BY customer_segment) AS total_customers
FROM(
SELECT 
customer_key,
lifespan,
total_spending,
CASE 
	WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
	WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
	ELSE 'New'
END AS customer_segment
FROM customer_spending_history
)t
GROUP BY
customer_key,
customer_segment
