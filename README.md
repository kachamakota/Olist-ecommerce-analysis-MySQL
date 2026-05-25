# Olist E-Commerce SQL Analysis

## Project Overview

This project is a SQL-based analysis of the **Brazilian E-Commerce Public Dataset by Olist**.  
The dataset contains e-commerce order data from Brazil, including information about orders, customers, sellers, products, payments, reviews, and delivery performance.

The main goal of this project was to prepare, validate, and analyze the dataset using **MySQL**, then use the SQL output views as the basis for a Power BI dashboard.

The analysis focuses on core e-commerce metrics such as revenue, orders, customers, sellers, product categories, year-to-date performance, rolling averages, and delivery delays.

---

## Dataset

The project uses the **Brazilian E-Commerce Public Dataset by Olist**.

The original data was provided as CSV files and loaded into a MySQL database.  
The dataset covers orders from **2016 to 2018**.

Important note about the date range:

- 2016 data is partial and covers only the final months of the year.
- 2017 is the only complete full year in the dataset.
- 2018 data is partial and covers January to August.

Because of this, year-over-year comparisons should be interpreted carefully.

---

## Tools Used

- **MySQL** — data loading, validation, SQL analysis, and analytical views
- **Power BI** — dashboard creation and visualization
- **CSV files** — original source format

---

## SQL Techniques Used

The SQL part of the project includes:

- Common Table Expressions: `WITH` / CTEs
- Window functions
- Aggregations
- Subqueries
- Joins between relational tables
- Date calculations

---

## Data Quality Checks

Before creating the analytical views, I performed several validation checks to better understand the quality and structure of the data.

The checks include:

- Primary key uniqueness checks
- NULL checks for key columns
- Foreign key / orphan record checks
- Row count and distinct count checks
- Date consistency checks
- Numeric value anomaly checks
- Order status distribution checks

Examples of checked areas:

- Duplicate `order_id`, `customer_id`, `product_id`, and `seller_id` values
- Duplicate composite keys such as `order_id + order_item_id`
- Missing values in key columns used for joins
- Order items without matching orders, products, or sellers
- Orders without matching customers
- Payments or reviews without matching orders
- Products without matching product category translations
- Delivery dates occurring before purchase dates

A small number of delivery date anomalies were identified, where the carrier delivery timestamp appeared earlier than the purchase timestamp. These records were treated as data quality anomalies.

---

## Database Constraints

Primary keys and foreign keys were added to improve relational integrity and make the data model clearer.

Examples of primary keys:

- `customers.customer_id`
- `orders.order_id`
- `order_items.order_id + order_items.order_item_id`
- `order_payments.order_id + order_payments.payment_sequential`
- `products.product_id`
- `sellers.seller_id`

Examples of foreign key relationships:

- `orders.customer_id → customers.customer_id`
- `order_items.order_id → orders.order_id`
- `order_items.product_id → products.product_id`
- `order_items.seller_id → sellers.seller_id`
- `order_payments.order_id → orders.order_id`
- `order_reviews.order_id → orders.order_id`

---

## Analysis Scope

The project calculates several e-commerce performance metrics, including:

- Total revenue
- Total number of orders
- Total number of customers
- Total number of sellers
- Total number of products sold
- Average order value
- Average revenue per customer
- Average monthly revenue
- Annual revenue
- Annual number of orders
- Annual customer counts
- Year-to-date revenue and orders
- Prior-year-to-date revenue and orders
- Rolling 3-month revenue average
- Rolling 3-month order average
- Top product categories by revenue
- Top sellers by revenue
- Top sellers by number of orders
- Delayed order percentage by state
- Average delivery time by state and month

---


