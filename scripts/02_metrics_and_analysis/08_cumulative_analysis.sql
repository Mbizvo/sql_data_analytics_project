/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    - To calculate running totals or moving averages for key metrics.
    - To track performance over time cumulatively.
    - Useful for growth analysis or identifying long-term trends.

SQL Functions Used:
    - Window Functions: SUM() OVER(), AVG() OVER()
===============================================================================
*/
--Total sales per month
--Running total sales over time
SELECT
order_date,
total_sales,
SUM(total_sales) OVER(PARTITION BY order_date ORDER BY order_date) AS running_total_sales
FROM(
SELECT 
DATETRUNC(MONTH,order_date) AS order_date,
SUM(sales_amount) AS total_sales
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(MONTH,order_date)
)t;
--Total sales per year
--Running total sales over time
SELECT
order_date,
total_sales,
SUM(total_sales) OVER(ORDER BY order_date) AS running_total_sales
FROM(
SELECT 
DATETRUNC(YEAR,order_date) AS order_date,
SUM(sales_amount) AS total_sales
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(YEAR,order_date)
)t;

--Moving average price
SELECT
order_date,
total_sales,
SUM(total_sales) OVER(ORDER BY order_date) AS running_total_sales,
SUM(avg_price) OVER(ORDER BY order_date) AS moving_average_price
FROM(
SELECT 
DATETRUNC(YEAR,order_date) AS order_date,
SUM(sales_amount) AS total_sales,
AVG(price) AS avg_price
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(YEAR,order_date)
)t;
