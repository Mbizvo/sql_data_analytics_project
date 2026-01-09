/*
===============================================================================
Dimensions Exploration
===============================================================================
Purpose:
    - To explore the structure of dimension tables.
	
SQL Functions Used:
    - DISTINCT
    - GROUP BY
    - ORDER BY
===============================================================================
*/

--exploring dim_products View
SELECT * FROM gold.dim_products;

SELECT DISTINCT product_name
FROM gold.dim_products;

SELECT DISTINCT product_line 
FROM gold.dim_products;

SELECT DISTINCT product_name, product_line 
FROM gold.dim_products;

SELECT DISTINCT category,subcategory, product_name
FROM gold.dim_products
ORDER BY 1,2,3;

SELECT DISTINCT subcategory
FROM gold.dim_products;

SELECT DISTINCT category, subcategory, COUNT(*) AS num_products
FROM gold.dim_products
GROUP BY category, subcategory
HAVING category IS NOT NULL  AND subcategory IS NOT NULL
ORDER BY category;

--exploring dim_customers View
SELECT * FROM gold.dim_customers;
--Undersanding the geographical spread of the data
SELECT DISTINCT country 
FROM gold.dim_customers;

SELECT DISTINCT marital_status 
FROM gold.dim_customers;
