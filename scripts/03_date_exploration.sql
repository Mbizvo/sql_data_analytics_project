/*
==========================================================================
Date Exploration
==========================================================================
Script Purpose:
  -To understand the range of historical data
  - determine the temporal boundaries of key data
SQL Functions used:
  MIN(), MAX(), DATEDIFF()
*/
SELECT 
	MIN(birthdate) AS oldest_customer,
	DATEDIFF(YEAR, MIN(birthdate), GETDATE()) AS oldest_age, 
	MAX(birthdate) AS youngest_customer, 
	DATEDIFF(YEAR, MAX(birthdate), GETDATE()) AS youngest_age
FROM gold.dim_customers;

SELECT 
	MIN(order_date) AS first_order, 
	MAX(order_date) AS last_order,
	DATEDIFF(YEAR, MIN(order_date), MAX(order_date)) AS years_of_sales,
	DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS months_of_Sales,
	DATEDIFF(DAY, MIN(order_date), MIN(shipping_date)) AS first_shpment_lag,
	DATEDIFF(DAY, MAX(order_date), MAX(shipping_date)) AS last_shpment_lag
FROM gold.fact_sales;

SELECT 
	MIN(shipping_date) AS first_shipment, 
	MAX(shipping_date) AS last_shipment,
	DATEDIFF(YEAR, MIN(shipping_date), MAX(shipping_date)) AS years_of_shipment,
	DATEDIFF(MONTH, MIN(shipping_date), MAX(shipping_date)) AS months_of_shipment
FROM gold.fact_sales;
