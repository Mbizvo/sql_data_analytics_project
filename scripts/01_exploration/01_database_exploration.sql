/*
===============================================================================
Database Exploration
===============================================================================
Script Purpose:
  -To explore the database structure such the list of the tables and schemas
  -Exlpore number of columns and metadata for specific tables
Table Used:
    - INFORMATION_SCHEMA.TABLES
    - INFORMATION_SCHEMA.COLUMNS
===============================================================================
*/

SELECT * FROM INFORMATION_SCHEMA.TABLES;

SELECT * FROM INFORMATION_SCHEMA.TABLES
ORDER BY TABLE_SCHEMA;

--Overview of the columns
SELECT * FROM INFORMATION_SCHEMA.COLUMNS

SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'fact_sales';
