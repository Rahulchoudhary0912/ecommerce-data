-- ============================================================================
-- Advanced Analytics Queries for E-commerce Database
-- ============================================================================
-- Database: database/ecommerce.db
-- Execute with: sqlite3 database/ecommerce.db ".read sql/queries.sql"
-- ============================================================================

-- ============================================================================
-- Query 1: Top 10 customers by lifetime spend (sum of completed orders)
-- ============================================================================
SELECT
    c.customer_id,
    c.name AS customer_name,
    c.email,
    ROUND(SUM(o.total), 2) AS lifetime_spend,
    COUNT(o.order_id) AS completed_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.status = 'completed'
GROUP BY c.customer_id, c.name, c.email
ORDER BY lifetime_spend DESC
LIMIT 10;

-- ============================================================================
-- Query 2: Top 10 products by revenue and units sold
-- ============================================================================
SELECT
    p.product_id,
    p.name AS product_name,
    p.category,
    SUM(oi.quantity) AS units_sold,
    ROUND(SUM(oi.line_total), 2) AS total_revenue,
    ROUND(AVG(p.price), 2) AS avg_price
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_id, p.name, p.category
ORDER BY total_revenue DESC, units_sold DESC
LIMIT 10;

-- ============================================================================
-- Query 3: Monthly revenue trends for the last 12 months
-- ============================================================================
WITH monthly_revenue AS (
    SELECT
        strftime('%Y-%m', o.order_date) AS order_month,
        SUM(o.total) AS revenue,
        COUNT(o.order_id) AS order_count
    FROM orders o
    WHERE o.status = 'completed'
    GROUP BY order_month
)
SELECT 
    order_month,
    ROUND(revenue, 2) AS revenue,
    order_count,
    ROUND(revenue / order_count, 2) AS avg_order_value
FROM monthly_revenue
WHERE order_month >= strftime('%Y-%m', DATE('now', '-11 months'))
ORDER BY order_month;

-- ============================================================================
-- Query 4: Top 20 customers by average review rating (minimum 3 reviews)
-- ============================================================================
SELECT
    c.customer_id,
    c.name AS customer_name,
    c.email,
    ROUND(AVG(r.rating), 2) AS avg_rating,
    COUNT(r.review_id) AS review_count,
    MIN(r.rating) AS min_rating,
    MAX(r.rating) AS max_rating
FROM customers c
JOIN reviews r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.name, c.email
HAVING COUNT(r.review_id) >= 3
ORDER BY avg_rating DESC, review_count DESC
LIMIT 20;

-- ============================================================================
-- Query 5: Revenue contribution by product category
-- ============================================================================
SELECT
    p.category,
    ROUND(SUM(oi.line_total), 2) AS category_revenue,
    SUM(oi.quantity) AS total_units_sold,
    COUNT(DISTINCT p.product_id) AS product_count,
    ROUND(
        SUM(oi.line_total) * 100.0 / (
            SELECT SUM(oi2.line_total) 
            FROM order_items oi2
        ),
        2
    ) AS revenue_percentage
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY category_revenue DESC;

-- ============================================================================
-- Query 6: Customer lifetime value (spending, order count, average order, last order date)
-- ============================================================================
SELECT
    c.customer_id,
    c.name AS customer_name,
    c.email,
    COUNT(o.order_id) AS order_count,
    ROUND(SUM(o.total), 2) AS total_spend,
    ROUND(AVG(o.total), 2) AS avg_order_value,
    MIN(o.order_date) AS first_order_date,
    MAX(o.order_date) AS last_order_date,
    COUNT(CASE WHEN o.status = 'completed' THEN 1 END) AS completed_orders,
    COUNT(CASE WHEN o.status = 'cancelled' THEN 1 END) AS cancelled_orders
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name, c.email
HAVING COUNT(o.order_id) > 0
ORDER BY total_spend DESC;

-- ============================================================================
-- Additional Analytics Queries
-- ============================================================================

-- Query 7: Product performance by category (revenue, units, avg rating)
SELECT
    p.category,
    COUNT(DISTINCT p.product_id) AS product_count,
    ROUND(SUM(oi.line_total), 2) AS total_revenue,
    SUM(oi.quantity) AS total_units_sold,
    ROUND(AVG(r.rating), 2) AS avg_rating,
    COUNT(r.review_id) AS review_count
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
LEFT JOIN reviews r ON p.product_id = r.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;

-- Query 8: Customer acquisition and retention (by signup month)
-- Note: This assumes customers table has signup_date, otherwise uses first order
WITH customer_first_order AS (
    SELECT 
        c.customer_id,
        MIN(o.order_date) AS first_order_date
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id
)
SELECT
    strftime('%Y-%m', cfo.first_order_date) AS acquisition_month,
    COUNT(DISTINCT cfo.customer_id) AS new_customers,
    ROUND(SUM(o.total), 2) AS total_revenue,
    ROUND(AVG(o.total), 2) AS avg_first_order_value
FROM customer_first_order cfo
JOIN orders o ON cfo.customer_id = o.customer_id 
    AND cfo.first_order_date = o.order_date
GROUP BY acquisition_month
ORDER BY acquisition_month DESC
LIMIT 12;

-- Query 9: Order status distribution
SELECT
    status,
    COUNT(*) AS order_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM orders), 2) AS percentage,
    ROUND(SUM(total), 2) AS total_revenue
FROM orders
GROUP BY status
ORDER BY order_count DESC;

-- Query 10: Products with highest review ratings (minimum 5 reviews)
SELECT
    p.product_id,
    p.name AS product_name,
    p.category,
    p.price,
    ROUND(AVG(r.rating), 2) AS avg_rating,
    COUNT(r.review_id) AS review_count,
    ROUND(SUM(oi.line_total), 2) AS total_revenue,
    SUM(oi.quantity) AS units_sold
FROM products p
JOIN reviews r ON p.product_id = r.product_id
LEFT JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.name, p.category, p.price
HAVING COUNT(r.review_id) >= 5
ORDER BY avg_rating DESC, review_count DESC
LIMIT 20;
