-- ==========================================================
-- Retail Sales & Customer Analytics Database
-- Author: Rakesh M
-- Database: MySQL (Optimized & Extended Version)
-- Description: Schema definition, sample dataset, and 
--              advanced production-ready analytical queries.
-- ==========================================================

-- 1. DATABASE INITIALIZATION
DROP DATABASE IF EXISTS retail_db;
CREATE DATABASE retail_db;
USE retail_db;

-- 2. TABLE CREATION
-- Table: Customers
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    city VARCHAR(50) NOT NULL,
    signup_date DATE NOT NULL
);

-- Table: Orders (with Foreign Key linking to Customers)
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    order_status VARCHAR(20) DEFAULT 'Delivered',
    CONSTRAINT fk_customer 
        FOREIGN KEY (customer_id) 
        REFERENCES customers(customer_id) 
        ON DELETE CASCADE
);

-- 3. DATA INSERTION
-- Insert mock customer records
INSERT INTO customers (customer_name, email, city, signup_date) VALUES
('Rakesh M', 'rakesh@example.com', 'Bengaluru', '2023-01-15'),
('Ananya Sharma', 'ananya.s@example.com', 'Mumbai', '2023-02-10'),
('Karthik Reddy', 'karthik.r@example.com', 'Hyderabad', '2023-03-05'),
('Pooja Patel', 'pooja.p@example.com', 'Bengaluru', '2023-04-12'),
('Vikram Singh', 'vikram.s@example.com', 'Delhi', '2023-05-20'),
('Suresh Kumar', 'suresh.k@example.com', 'Chennai', '2023-06-01');

-- Insert mock order records
INSERT INTO orders (customer_id, order_date, total_amount, order_status) VALUES
(1, '2023-06-15', 1250.00, 'Delivered'),
(1, '2023-07-20', 3400.50, 'Delivered'),
(2, '2023-07-22', 850.00, 'Delivered'),
(3, '2023-08-01', 5200.00, 'Delivered'),
(3, '2023-08-14', 1100.00, 'Cancelled'),
(4, '2023-08-25', 2150.00, 'Delivered'),
(1, '2023-09-02', 4300.00, 'Delivered'),
(5, '2023-09-10', 990.00, 'Delivered');

-- 4. BUSINESS ANALYTICAL QUERIES

-- Query 1: Total Revenue and Order Count per Customer (INNER JOIN + GROUP BY)
-- Purpose: Identifies repeat and top-spending customers.
SELECT 
    c.customer_id,
    c.customer_name,
    c.city,
    COUNT(o.order_id) AS total_orders,
    SUM(o.total_amount) AS total_spent
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_status = 'Delivered'
GROUP BY c.customer_id, c.customer_name, c.city
ORDER BY total_spent DESC;

-- Query 2: Regional Sales Breakdown (City-Level Aggregation)
-- Purpose: Identifies top-performing geographic markets.
SELECT 
    c.city,
    COUNT(o.order_id) AS orders_count,
    ROUND(SUM(o.total_amount), 2) AS city_revenue
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_status = 'Delivered'
GROUP BY c.city
ORDER BY city_revenue DESC;

-- Query 3: Churn/Inactive Analysis (LEFT JOIN + IS NULL)
-- Purpose: Pinpoints registered users who have placed 0 orders.
SELECT 
    c.customer_id,
    c.customer_name,
    c.email,
    c.city
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- Query 4: Above-Average Order Values (Subquery)
-- Purpose: Filters orders that outperform the overall business average order value.
SELECT 
    order_id,
    customer_id,
    order_date,
    total_amount
FROM orders
WHERE total_amount > (SELECT AVG(total_amount) FROM orders WHERE order_status = 'Delivered')
  AND order_status = 'Delivered'
ORDER BY total_amount DESC;

-- Query 5: Customer Lifetime Value (CLV) & Tier Segmentation (CASE WHEN)
-- Purpose: Classifies customers into strategic marketing brackets based on expenditure metrics.
SELECT 
    c.customer_id,
    c.customer_name,
    SUM(o.total_amount) AS customer_lifetime_value,
    ROUND(AVG(o.total_amount), 2) AS average_ticket_size,
    CASE 
        WHEN SUM(o.total_amount) >= 5000 THEN 'VIP / High-Tier'
        WHEN SUM(o.total_amount) BETWEEN 2000 AND 4999.99 THEN 'Mid-Tier / Frequent'
        ELSE 'Low-Tier / Occasional'
    END AS customer_segment
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_status = 'Delivered'
GROUP BY c.customer_id, c.customer_name
ORDER BY customer_lifetime_value DESC;

-- Query 6: Relative Spend Rankings within Cities (Window Functions)
-- Purpose: Ranks customer financial impact inside their specific regional city boundaries.
SELECT 
    c.city,
    c.customer_name,
    SUM(o.total_amount) AS total_spent_locally,
    RANK() OVER (PARTITION BY c.city ORDER BY SUM(o.total_amount) DESC) AS local_spend_rank
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_status = 'Delivered'
GROUP BY c.city, c.customer_id, c.customer_name;