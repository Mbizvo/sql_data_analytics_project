/*
================================================================================
Customer Report
================================================================================
Purpose of the script:
 -This script consolidates key customer metrics and behavior

Highlights:
1. Gather essential fields such as customer names, ages, and transactional details
2. Segment customers into categories( VIP, Regular, NEW), and age
3. Aggreagate customer level metrics
	-total orders
	-total sales
	-total quantiy purchased
	- total products
	- lifespan in months
4. Calculate valuabe KPIs
	-revency( months since last_order)
	-average order value
	average months spend
*/
CREATE OR ALTER VIEW gold.customer_report AS
/*---------------------------------------------------------------------------
1) Base Query: Retrieves core columns from tables
---------------------------------------------------------------------------*/
WITH base_query AS(
SELECT 
	c.customer_key,
	c.customer_number,
	CONCAT(c.first_name,' ', c.last_name) AS customer_name,
	DATEDIFF(YEAR, c.birthdate,GETDATE()) AS age,
	f.order_number,
	f.product_key,
	f.order_date,
	f.sales_amount,
	f.quantity
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_customers c
	ON f.customer_key = c.customer_key
	WHERE f.order_date IS NOT NULL
)
, customer_aggregations AS(
/*---------------------------------------------------------------------------
2) Customer Aggregations: Summarizes key metrics at the customer level
---------------------------------------------------------------------------*/
SELECT 
	customer_key,
	customer_number,
	customer_name,
	age,
	COUNT(DISTINCT order_number) AS total_orders,
	COUNT(DISTINCT product_key) AS total_products,
	MIN(order_date) AS first_order_date,
	MAX(order_date) AS last_order_date,
	DATEDIFF(MONTH,MIN(order_date), MAX(order_date)) AS lifespan,
	SUM(sales_amount) AS total_sales,
	SUM(quantity) AS total_quantity
FROM base_query
GROUP BY 
	customer_key,
	customer_number,
	customer_name,
	age

)
SELECT 
	customer_key,
	customer_number,
	customer_name,
	age,
	CASE 
		WHEN age BETWEEN 39 AND 49 THEN '39-49'
		WHEN age BETWEEN 50 AND 59 THEN '50-59'
		WHEN age BETWEEN 60 AND 69 THEN '60-69'
		ELSE 'Over 70'
	END AS age_group,
	lifespan,
	CASE 
		WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
		WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
		ELSE 'New'
	END AS customer_segment,
	last_order_date,
	DATEDIFF(MONTH, last_order_date, DATEADD(YEAR,-12, GETDATE())) AS recency,
	total_orders,
	total_products,
	total_sales,
	total_quantity,
	--Computing the average order value
	CASE 
		WHEN total_sales = 0 THEN 0
		ELSE total_sales/ total_orders 
	END AS avg_order_value,
	--Computing the average montly spend
	CASE 
		WHEN lifespan = 0 THEN total_sales
		ELSE total_sales/ lifespan 
	END AS avg_monthly_spend
FROM customer_aggregations;
