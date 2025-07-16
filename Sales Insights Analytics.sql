-- 1. Monthly revenue trends
SELECT 
    YEAR(invoice_date) as year,
    MONTH(invoice_date) as month,
    SUM(total) as monthly_revenue,
    COUNT(*) as invoice_count
FROM invoice
GROUP BY YEAR(invoice_date), MONTH(invoice_date)
ORDER BY year, month;

-- 2. Average invoice value
SELECT 
    ROUND(AVG(total), 2) as avg_invoice_value,
    ROUND(MIN(total), 2) as min_invoice_value,
    ROUND(MAX(total), 2) as max_invoice_value
FROM invoice;

-- 3. Sales performance by employee
SELECT 
    e.employee_id,
    e.first_name,
    e.last_name,
    e.title,
    COUNT(DISTINCT c.customer_id) as customers_managed,
    COUNT(i.invoice_id) as total_sales,
    SUM(i.total) as total_revenue
FROM employee e
LEFT JOIN customer c ON e.employee_id = c.support_rep_id
LEFT JOIN invoice i ON c.customer_id = i.customer_id
WHERE e.title LIKE '%Sales%'
GROUP BY e.employee_id, e.first_name, e.last_name, e.title
ORDER BY total_revenue DESC;