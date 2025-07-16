-- 1. Geographic distribution and performance
SELECT 
    c.country,
    COUNT(DISTINCT c.customer_id) as total_customers,
    COUNT(i.invoice_id) as total_orders,
    SUM(i.total) as total_revenue,
    ROUND(AVG(i.total), 2) as avg_order_value,
    ROUND(SUM(i.total) / COUNT(DISTINCT c.customer_id), 2) as revenue_per_customer
FROM invoice i
JOIN customer c ON i.customer_id = c.customer_id
GROUP BY c.country
ORDER BY total_revenue DESC;

-- 2. Employee efficiency analysis
SELECT 
    e.first_name,
    e.last_name,
    e.title,
    COUNT(DISTINCT c.customer_id) as customers_assigned,
    COUNT(i.invoice_id) as total_invoices,
    SUM(i.total) as total_revenue,
    ROUND(SUM(i.total) / COUNT(DISTINCT c.customer_id), 2) as revenue_per_customer,
    ROUND(SUM(i.total) / COUNT(i.invoice_id), 2) as avg_invoice_value
FROM employee e
LEFT JOIN customer c ON e.employee_id = c.support_rep_id
LEFT JOIN invoice i ON c.customer_id = i.customer_id
WHERE e.title LIKE '%Sales%'
GROUP BY e.employee_id, e.first_name, e.last_name, e.title
ORDER BY total_revenue DESC;