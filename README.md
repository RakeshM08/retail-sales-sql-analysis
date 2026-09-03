# Retail Sales & Customer Analytics (MySQL)

A relational database project demonstrating schema design, data normalization, primary/foreign key relationships, and business queries using MySQL.

## Database Schema
- **customers:** `customer_id` (PK), `customer_name`, `email`, `city`, `signup_date`
- **orders:** `order_id` (PK), `customer_id` (FK referencing `customers.customer_id`), `order_date`, `total_amount`, `order_status`

## Core SQL Skills Demonstrated
- **Schema & Constraints:** Table creation with `AUTO_INCREMENT`, `PRIMARY KEY`, `FOREIGN KEY`, and `ON DELETE CASCADE`.
- **Joins:** `INNER JOIN` for cross-table transaction mapping and `LEFT JOIN` for identifying churned/inactive customers.
- **Aggregations:** `COUNT()`, `SUM()`, `ROUND()`, along with `GROUP BY` and `ORDER BY` clauses.
- **Subqueries:** Filtering orders above average order values.

## Key Business Insights & Queries
- **Customer Lifetime Value:** Aggregates order counts and total spend per individual.
- **Regional Sales Distribution:** Analyzes order volume and total revenue across cities.
- **Inactive Accounts Detection:** Identifies registered users who haven't placed an order.
