# sql_data_analytics_project
## 📖 Project Overview
This project showcases advanced SQL analytics and reporting techniques for exploring, analyzing, and extracting insights from relational databases. It demonstrates how raw data can be transformed into business-ready insights that support decision-making and performance analysis.
## Key Features
* Data exploration and quality assessment
* Creation of business metrics and KPIs
* Time-based trend analysis (MoM, YoY, rolling averages)
* Cumulative and historical analytics
* Customer and data segmentation
* Use of advanced SQL constructs (CTEs, window functions, aggregations)

### Tools & Technologies
* Relational Databases (SQL Server / PostgreSQL-compatible)
* Analytical queries for reporting and BI use cases

### Business Value
The project demonstrates the ability to:
* Analyze complex datasets efficiently
* Build meaningful metrics for reporting
* Apply SQL best practices in real-world analytics scenarios
* Support data-driven business and operational decisions

### 📂 Repository Structure
```
sql_data_analytics_project/
│
├── datasets/
│   └── gold/
│       ├── dim_customers.csv
│       ├── dim_products.csv
│       └── fact_sales.csv
│
├── scripts/
│   ├── 00_setup/
│   │   └── 00_init_database.sql
│   │
│   ├── 01_exploration/
│   │   ├── 01_database_exploration.sql
│   │   ├── 02_dimension_exploration.sql
│   │   └── 03_date_exploration.sql
│   │
│   ├── 02_metrics_and_analysis/
│   │   ├── 04_measures_exploration.sql
│   │   ├── 05_magnitude_analysis.sql
│   │   ├── 06_ranking_analysis.sql
│   │   ├── 07_change_over_time_analysis.sql
│   │   ├── 08_cumulative_analysis.sql
│   │   ├── 09_performance_analysis.sql
│   │   └── 10_part_to_whole.sql
│   │
│   ├── 03_segmentation/
│   │   └── 11_data_segmentation.sql
│   │
│   ├── 04_reporting/
│   │   ├── 12_customer_report.sql
│   │   └── 13_products_report.sql
│   │
│   └── README.md
│
├── documentation/
│   ├── data_model.md
│   └── analysis_summary.md
│
├── README.md
└── LICENSE
```
### 🛡️ License
This project is licensed under the MIT License. You are free to use, modify, and share this project with proper attribution.

### About Me
Hi there! I'm Brendon Mbizvo, a Data Scientist passionate about transforming raw data into actionable insights.
