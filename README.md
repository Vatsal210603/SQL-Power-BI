# SQL-Power-BI
Overview
This repository contains the SQL scripts and Power BI files used for analyzing and visualizing data from the Coffee Store Database. The database consists of several tables that track ingredients, inventory, items, orders, recipes, work rota, shifts, and staff details.

Database Schema
The Coffee Store Database includes the following tables:

Ingredients

Columns: ing_id, ing_name, ing_weight, ing_measure_unit, ing_price
Inventory

Columns: inv_id, ing_id, quantity
Items

Columns: item_id, sku, item_name, item_category, item_size, item_price
Orders

Columns: row_id, order_id, created_at, item_id, quantity, cust_name, in_or_out
Recipe

Columns: row_id, recipe_id, ing_id, quantity
Rota

Columns: row_id, rota_id, date, shift_id, staff_id
Shift

Columns: shift_id, day_of_week, start_time, end_time
Staff

Columns: staff_id, first_name, last_name, position, sal_per_hour
Data Analysis
The data analysis was performed using MySQL, leveraging advanced SQL concepts such as:

Subqueries: Used to isolate specific data for detailed examination.
Common Table Expressions (CTEs): Simplified complex queries and improved readability.
Window Functions: Applied for running totals, ranking, and moving averages.
Joins: Combined data across multiple tables to derive meaningful insights.
Aggregate Functions: Summarized data using functions like SUM, AVG, MAX, and MIN.
Data Visualization
The insights derived from the data analysis were visualized using Power BI. The visualizations include:

Sales trends and patterns
Inventory levels and turnover
Staff scheduling and shift analysis
Customer order preferences
These visualizations provide a comprehensive view of the Coffee Store's operations, enabling data-driven decision-making.

Repository Structure
SQL Scripts: Contains all SQL queries used for data extraction and analysis.
Power BI Files: Includes the Power BI dashboard and reports for data visualization.
