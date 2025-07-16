-- 1. Customer segmentation by purchase behavior
WITH customer_stats AS (
    SELECT 
        c.customer_id,
        c.first_name,
        c.last_name,
        c.country,
        COUNT(i.invoice_id) as purchase_frequency,
        SUM(i.total) as total_spent,
        AVG(i.total) as avg_order_value,
        MAX(i.invoice_date) as last_purchase_date,
        DATEDIFF(CURDATE(), MAX(i.invoice_date)) as days_since_last_purchase
    FROM customer c
    JOIN invoice i ON c.customer_id = i.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name, c.country
)
SELECT 
    CASE 
        WHEN total_spent >= 40 AND purchase_frequency >= 7 THEN 'VIP Customer'
        WHEN total_spent >= 20 AND purchase_frequency >= 4 THEN 'Regular Customer'
        WHEN days_since_last_purchase > 365 THEN 'Inactive Customer'
        ELSE 'Occasional Customer'
    END as customer_segment,
    COUNT(*) as customer_count,
    ROUND(AVG(total_spent), 2) as avg_spent,
    ROUND(AVG(purchase_frequency), 1) as avg_frequency
FROM customer_stats
GROUP BY customer_segment
ORDER BY avg_spent DESC;

-- 2. Market basket analysis - frequently bought together
SELECT 
    t1.name as track1,
    t2.name as track2,
    COUNT(*) as times_bought_together
FROM invoice_line il1
JOIN invoice_line il2 ON il1.invoice_id = il2.invoice_id AND il1.track_id < il2.track_id
JOIN track t1 ON il1.track_id = t1.track_id
JOIN track t2 ON il2.track_id = t2.track_id
GROUP BY il1.track_id, il2.track_id, t1.name, t2.name
HAVING COUNT(*) >= 3
ORDER BY times_bought_together DESC
LIMIT 20;