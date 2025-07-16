-- Create KPI views for easy dashboard creation
CREATE VIEW monthly_kpis AS
SELECT 
    YEAR(invoice_date) as year,
    MONTH(invoice_date) as month,
    COUNT(DISTINCT customer_id) as active_customers,
    COUNT(invoice_id) as total_orders,
    SUM(total) as total_revenue,
    ROUND(AVG(total), 2) as avg_order_value,
    COUNT(DISTINCT customer_id) as new_customers
FROM invoice
GROUP BY YEAR(invoice_date), MONTH(invoice_date)
ORDER BY year, month;

-- Top performers view
CREATE VIEW top_performers AS
SELECT 
    'Track' as category,
    t.name as item_name,
    ar.name as additional_info,
    SUM(il.quantity) as units_sold,
    SUM(il.unit_price * il.quantity) as revenue
FROM track t
JOIN invoice_line il ON t.track_id = il.track_id
JOIN album al ON t.album_id = al.album_id
JOIN artist ar ON al.artist_id = ar.artist_id
GROUP BY t.track_id, t.name, ar.name
ORDER BY revenue DESC
LIMIT 10;
