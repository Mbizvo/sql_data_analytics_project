/*
=================================================================
Product Report
=================================================================
Purpose:
	This script consolidates key product metrics and behavior

Highlights:
1. Gather essentila fields such as product_name, category, subcategory, and cost
2. Segment products by total_revenue to identify High-perfomers, Mid-Range, and Low-perfomers
3. Aggregate product-level metrics
	- total_orders
	- total sales
	- total quantity sold
	- total customers
	- lifespan in months
4. Calculate valuable KPIs
	-recency(months since last order)
	-average order revenue (AOR)
	-average monthly revenue
*/

/*---------------------------------------------------------------------------
1) Base Query: Retrieves core columns from fact_sales and dim_products
---------------------------------------------------------------------------*/
WITH base_query AS(
SELECT 
	f.customer_key,
	f.order_number,
	f.order_date,
	f.sales_amount,
	f.quantity,
	f.price,
	p.product_key,
	p.product_name,
	p.category,
	p.cost
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
WHERE f.order_date IS NOT NULL
)
, products_aggregations AS(
/*---------------------------------------------------------------------------
2) Product Aggregations: Summarizes key metrics at the product level
---------------------------------------------------------------------------*/
SELECT 
	COUNT(customer_key) AS total_customers,
	product_key,
	product_name,
	category,
	SUM(cost) AS total_cost,
	COUNT(DISTINCT order_number) AS total_orders,
	MIN(order_date) AS first_order,
	MAX(order_date) AS last_order,
	DATEDIFF(MONTH, MIN(order_date),MAX(order_date)) AS lifespan,
	SUM(sales_amount) AS total_sales,
	SUM(quantity) AS total_quantity,
	AVG(price) AS avg_selling_price
FROM base_query
GROUP BY 
	product_key,
	product_name,
	category
)
/*---------------------------------------------------------------------------
  3) Final Query: Combines all product results into one output
---------------------------------------------------------------------------*/
SELECT
	total_customers,
	product_key,
	product_name,
	category,
	total_cost,
	total_orders,
	last_order,
	DATEDIFF(MONTH,last_order,DATEADD(YEAR,-11, GETDATE())) AS recency, 
	lifespan,
	total_sales,
	CASE 
		WHEN total_sales > 500000 THEN 'High-Perfomers'
		WHEN total_sales > 225000 THEN 'Mid-Range'
		ELSE 'Low-Perfomers'
	END AS products_segmentation,
	avg_selling_price,
	--Computing Average Order Reenue(AOR)
	CASE 
		WHEN total_sales = 0 THEN 0
		ELSE total_sales/total_orders
	END AS avg_order_revenue,
	--Computing the average monthly revenue
	CASE 
		WHEN lifespan = 0 THEN total_sales
		ELSE total_sales/lifespan 
	END AS avg_monthly_revenue
FROM products_aggregations;
