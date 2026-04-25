-- ============================================
-- DATABASE SETUP
-- ============================================

-- Create Database
CREATE DATABASE pet_food_subscription_db;

-- Use Database
USE pet_food_subscription_db;

-- ============================================
-- TABLE CREATION
-- ============================================

-- Customers Table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    pet_type VARCHAR(10),
    signup_date DATE
);

-- Orders Table
CREATE TABLE orders (
    order_id VARCHAR(20) PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    quantity INT,
    recipe_type VARCHAR(20),
    price_per_unit NUMERIC,
    total_amount NUMERIC,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- ============================================
-- BASIC CHECKS
-- ============================================

-- Customer Count
SELECT COUNT(*) FROM customers;

-- Order Count
SELECT COUNT(*) FROM orders;

-- ============================================
-- CUSTOMER SUMMARY TABLE
-- ============================================

-- Aggregates order-level data into customer-level metrics
CREATE TABLE customer_summary AS
SELECT 
    c.customer_id,
    c.pet_type,
    COUNT(o.order_id) AS total_orders,
    COALESCE(SUM(o.total_amount), 0) AS total_spent,
    MAX(o.order_date) AS last_order_date
FROM customers c
LEFT JOIN orders o 
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.pet_type;

-- ============================================
-- CHURN TABLE
-- ============================================

-- Identify churn based on inactivity (60 days)
DROP TABLE IF EXISTS churn_data;

CREATE TABLE churn_data AS
WITH max_date AS (
    SELECT MAX(order_date) AS ref_date FROM orders
)
SELECT 
    cs.*,
    CASE 
        WHEN (SELECT ref_date FROM max_date) - cs.last_order_date > 60 
        THEN 'Churned'
        ELSE 'Active'
    END AS churn_status
FROM customer_summary cs;

-- ============================================
-- CORE BUSINESS QUESTIONS
-- ============================================

-- Q1: Overall Churn Rate
SELECT 
    ROUND(
        COUNT(CASE WHEN churn_status = 'Churned' THEN 1 END) * 100.0 
        / COUNT(*), 2
    ) AS churn_rate
FROM churn_data;

-- Q2: Customer Drop-off Pattern
SELECT 
    total_orders,
    COUNT(*) AS customers
FROM customer_summary
GROUP BY total_orders
ORDER BY total_orders;

-- Q3: Active vs Churned Customers
SELECT 
    churn_status,
    COUNT(*) AS customers
FROM churn_data
GROUP BY churn_status;

-- Q4: Total Revenue
SELECT SUM(total_amount) AS revenue_total
FROM orders;

-- Q5: Revenue Lost Due to Churn
SELECT  
    pet_type,
    SUM(total_spent) AS revenue_lost_due_to_churn
FROM churn_data
WHERE churn_status = 'Churned'
GROUP BY pet_type;

-- ============================================
-- CUSTOMER BEHAVIOR ANALYSIS
-- ============================================

-- Q6: Average Orders per Customer
SELECT 
    ROUND(COUNT(*) * 1.0 / COUNT(DISTINCT customer_id), 0) AS average_orders
FROM orders;

-- Q7: Early vs Late Churn
SELECT 
    CASE 
        WHEN total_orders <= 2 THEN 'Early (1-2 Orders)'
        ELSE 'Later (>2 Orders)'
    END AS order_stage,
    churn_status,
    COUNT(*) AS customers
FROM churn_data
GROUP BY order_stage, churn_status
ORDER BY order_stage;

-- Q8: Average Spending (Active vs Churned)
SELECT  
    churn_status, 
    AVG(total_spent) AS average_spent
FROM churn_data
GROUP BY churn_status;

-- Q9: Top High-Value Customers
SELECT  
    customer_id, 
    SUM(total_amount) AS total_spent
FROM orders
GROUP BY customer_id 
ORDER BY total_spent DESC
LIMIT 10;

-- ============================================
-- PRODUCT ANALYSIS
-- ============================================

-- Q10: Recipe with Highest Churn
SELECT  
    o.recipe_type,
    COUNT(CASE WHEN c.churn_status = 'Churned' THEN o.customer_id END) AS churned_customers
FROM orders o
JOIN churn_data c 
    ON o.customer_id = c.customer_id
GROUP BY o.recipe_type
ORDER BY churned_customers DESC;

-- Q11: Revenue by Recipe
SELECT 
    recipe_type, 
    SUM(total_amount) AS total_revenue
FROM orders
GROUP BY recipe_type
ORDER BY total_revenue DESC;

-- Q12: Low Retention Recipes
SELECT  
    o.recipe_type,
    COUNT(DISTINCT CASE 
        WHEN c.churn_status = 'Active' THEN o.customer_id 
    END) AS active_customers
FROM orders o
JOIN churn_data c 
    ON o.customer_id = c.customer_id
GROUP BY o.recipe_type
ORDER BY active_customers ASC;

-- ============================================
-- QUANTITY & PRICING ANALYSIS
-- ============================================

-- Q13: Quantity Impact on Churn
SELECT  
    o.quantity,
    COUNT(DISTINCT o.customer_id) AS total_customers,
    COUNT(DISTINCT CASE 
        WHEN c.churn_status = 'Churned' THEN o.customer_id 
    END) AS churned_customers,
    COUNT(DISTINCT CASE 
        WHEN c.churn_status = 'Churned' THEN o.customer_id 
    END) * 100.0 
    / COUNT(DISTINCT o.customer_id) AS churn_rate
FROM orders o
JOIN churn_data c 
    ON o.customer_id = c.customer_id
GROUP BY o.quantity
ORDER BY o.quantity;

-- Q14: Do High Spenders Churn Less?
SELECT 
    CASE 
        WHEN total_spent > 7000 THEN 'High Spender'
        WHEN total_spent BETWEEN 3000 AND 7000 THEN 'Medium Spender'
        ELSE 'Low Spender'
    END AS spending_segment,
    COUNT(*) AS customers,
    COUNT(CASE WHEN churn_status = 'Churned' THEN 1 END) AS churned_customers,
    COUNT(CASE WHEN churn_status = 'Churned' THEN 1 END) * 100.0 
    / COUNT(*) AS churn_rate
FROM churn_data
GROUP BY spending_segment
ORDER BY churn_rate DESC;

-- Q15: Average Order Value
SELECT 
    SUM(total_amount) / COUNT(order_id) AS avg_order_value
FROM orders;

-- ============================================
-- CUSTOMER SEGMENTATION
-- ============================================

-- Q16: Segment Customers + Churn
WITH segment AS (
    SELECT 
        customer_id,
        total_spent,
        churn_status,
        CASE 
            WHEN total_spent > 7000 THEN 'High Value'
            WHEN total_spent BETWEEN 3000 AND 7000 THEN 'Medium Value'
            ELSE 'Low Value'
        END AS customer_segment
    FROM churn_data
)
SELECT 
    customer_segment,
    churn_status,
    COUNT(*) AS customers
FROM segment
GROUP BY customer_segment, churn_status;

-- Q17: Revenue by Segment
WITH segment AS (
    SELECT 
        customer_id,
        CASE 
            WHEN total_spent > 7000 THEN 'High Value'
            WHEN total_spent BETWEEN 3000 AND 7000 THEN 'Medium Value'
            ELSE 'Low Value'
        END AS customer_segment
    FROM customer_summary
)
SELECT 
    s.customer_segment,
    SUM(o.total_amount) AS revenue
FROM segment s
JOIN orders o 
    ON o.customer_id = s.customer_id
GROUP BY s.customer_segment
ORDER BY revenue DESC;
