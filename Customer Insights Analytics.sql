-- 1. Top spending customers
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    c.country,
    SUM(i.total) as total_spent
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.country
ORDER BY total_spent DESC
LIMIT 10;

-- 2. Average customer lifetime value
SELECT 
    ROUND(AVG(customer_total), 2) as avg_customer_lifetime_value
FROM (
    SELECT customer_id, SUM(total) as customer_total
    FROM invoice
    GROUP BY customer_id
) customer_totals;

-- 3. Repeat vs one-time customers
SELECT 
    CASE 
        WHEN purchase_count = 1 THEN 'One-time'
        ELSE 'Repeat'
    END as customer_type,
    COUNT(*) as customer_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(DISTINCT customer_id) FROM invoice), 2) as percentage
FROM (
    SELECT customer_id, COUNT(*) as purchase_count
    FROM invoice
    GROUP BY customer_id
) customer_purchases
GROUP BY customer_type;

-- 4. Revenue per customer by country
SELECT 
    c.country,
    COUNT(DISTINCT c.customer_id) as customer_count,
    SUM(i.total) as total_revenue,
    ROUND(SUM(i.total) / COUNT(DISTINCT c.customer_id), 2) as revenue_per_customer
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id
GROUP BY c.country
ORDER BY revenue_per_customer DESC;