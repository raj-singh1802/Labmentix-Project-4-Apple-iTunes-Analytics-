-- Executive summary query with separated most popular genre
SELECT 
    'Total Revenue' as metric,
    CONCAT('$', FORMAT(SUM(total), 2)) as value
FROM invoice
UNION ALL
SELECT 
    'Total Customers',
    COUNT(DISTINCT customer_id)
FROM customer
UNION ALL
SELECT 
    'Average Customer Value',
    CONCAT('$', FORMAT(AVG(customer_total), 2))
FROM (
    SELECT customer_id, SUM(total) as customer_total
    FROM invoice
    GROUP BY customer_id
) customer_totals
UNION ALL
SELECT 
    'Most Popular Genre',
    (
        SELECT g.name
        FROM genre g
        JOIN track t ON g.genre_id = t.genre_id
        JOIN invoice_line il ON t.track_id = il.track_id
        GROUP BY g.genre_id, g.name
        ORDER BY SUM(il.quantity) DESC
        LIMIT 1
    );
