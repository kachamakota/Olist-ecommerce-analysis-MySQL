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

## Power BI Dashboard

The Power BI dashboard was created using selected SQL views prepared in MySQL.  
Most calculations were performed directly in SQL, while Power BI was used mainly for visualization and interactive exploration.

The dashboard consists of four pages:

### Page 1: General Performance Overview

The first dashboard page provides a high-level overview of the dataset and selected business metrics.

It includes KPI cards for:

- Total revenue
- Total orders
- Total customers
- Total sellers
- Total products sold

This page also includes monthly trend visuals comparing actual monthly values with rolling 3-month averages.

#### Monthly Orders with Rolling 3-Month Average

This visual compares the actual number of monthly orders with the rolling 3-month average of orders.

The goal of this chart is to smooth short-term monthly fluctuations and make the general order trend easier to interpret.

#### Monthly Revenue with Rolling 3-Month Average

This visual compares actual monthly revenue with the rolling 3-month average revenue.

The rolling average helps show the broader revenue trend across the available time period, especially where individual months may fluctuate.

#### Average Monthly Revenue vs. Average Monthly Orders

This visual compares yearly average monthly revenue with yearly average monthly order volume.

The comparison shows that revenue movement is strongly connected to order volume. As the number of orders increases, revenue generally increases as well.

#### Average Revenue per Customer vs. Orders per Customer

This visual compares average revenue per customer with the average number of orders per customer by year.

The average number of orders per customer is very close to 1, which suggests that repeat purchasing is limited in this dataset. This is important context when interpreting customer behavior and revenue growth.

---

### Page 2: YoY and YTD Revenue Analysis

This page focuses on revenue comparisons over time.

It includes monthly year-over-year analysis and cumulative year-to-date performance.

#### Monthly Revenue with YoY Comparison

This visual compares monthly revenue with revenue from the same month in the previous year.

The page also includes metric cards that update based on the selected month. These cards show:

- Current period revenue
- Previous year revenue
- YoY percentage change

This allows individual months to be reviewed in more detail.

#### Year-to-Date vs. Prior-Year-to-Date Revenue

This visual compares cumulative year-to-date revenue with the equivalent prior-year-to-date value.

The supporting metric cards show:

- YTD revenue for the selected month
- PYTD revenue for the selected month
- Percentage change between YTD and PYTD

This page helps evaluate whether revenue performance in the current year is ahead of or behind the comparable period from the previous year.

Because the dataset contains only partial data for 2016 and 2018, YoY and YTD comparisons should be interpreted with caution. The strongest full-year baseline in the dataset is 2017.

---

### Page 3: Product Categories and Sellers

This page focuses on product category performance and seller performance.

#### Top Product Categories by Annual Revenue

This section includes separate bar charts for the top product categories by revenue in:

- 2016
- 2017
- 2018

The purpose of this layout is to make annual category performance easier to compare, while keeping the partial-year nature of 2016 and 2018 visible.

#### Top Sellers by Revenue

This visual shows the sellers with the highest total revenue.

Seller names are not available in the dataset, so sellers are displayed using anonymized seller IDs.

#### Top Sellers by Number of Orders

This visual shows the sellers with the highest number of orders.

Comparing top sellers by revenue and by order count helps identify whether the highest-revenue sellers are also the sellers with the highest order volume.

---

### Page 4: Delivery Performance

The last page of the dashboard focuses on delivery performance across Brazilian states.

The analysis is limited to the top 5 states by order volume to keep the visuals readable and focused on the most relevant regions.

#### Percentage of Delayed Orders by Month for Top 5 States

This visual shows the monthly percentage of delayed orders for the five states with the highest number of orders.

An order is treated as delayed when the actual customer delivery date is later than the estimated delivery date.

This chart helps compare how delay rates changed over time across the highest-volume states.

#### Average Delivery Days by Month for Top 5 States

This visual shows the average number of delivery days by month for the same top 5 states.

Delivery time is calculated as the difference between the purchase date and the actual customer delivery date.

When compared with the delayed order percentage visual, this chart provides additional context. For example, RJ, which represents Rio de Janeiro, appears to have both a relatively high percentage of delayed orders and longer average delivery times compared with other high-volume states.

---

