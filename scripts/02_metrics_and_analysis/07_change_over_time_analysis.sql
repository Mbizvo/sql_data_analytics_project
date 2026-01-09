/*
===============================================================================
Change Over Time Analysis
===============================================================================
Purpose:
    - To track trends, growth, and changes in key metrics over time.
    - For time-series analysis and identifying seasonality.
    - To measure growth or decline over specific periods.

SQL Functions Used:
    - Date Functions: DATEPART(), DATETRUNC(), FORMAT()
    - Aggregate Functions: SUM(), COUNT(), AVG()
===============================================================================
*/
--Sales Perfomance over time
SELECT 
DATETRUNC(YEAR,order_date) order_year,
SUM(sales_amount) total_sales,
COUNT(customer_key) AS total_customers,
SUM(quantity) AS total_quantity
FROM gold.fact_sales
GROUP BY DATETRUNC(YEAR,order_date)
HAVING DATETRUNC(YEAR,order_date) IS NOT NULL
ORDER BY DATETRUNC(YEAR,order_date);

--Sales Perfomance over the year
SELECT 
DATETRUNC(MONTH,order_date) order_year,
SUM(sales_amount) total_sales,
SUM(quantity) AS total_quantity
FROM gold.fact_sales
GROUP BY DATETRUNC(MONTH,order_date)
HAVING DATETRUNC(MONTH,order_date) IS NOT NULL
ORDER BY DATETRUNC(MONTH,order_date);


--Sales Perfomance over the year 2011
SELECT 
DATETRUNC(MONTH,order_date) order_year,
SUM(sales_amount) total_sales,
SUM(quantity) AS total_quantity
FROM gold.fact_sales
GROUP BY DATETRUNC(MONTH,order_date)
HAVING DATETRUNC(MONTH,order_date) IS NOT NULL AND DATETRUNC(MONTH,order_date) BETWEEN '2011-01-01' AND '2011-12-01'
ORDER BY DATETRUNC(MONTH,order_date);
