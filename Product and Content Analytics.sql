-- 1. Top revenue-generating tracks
SELECT 
    t.track_id,
    t.name as track_name,
    ar.name as artist_name,
    al.title as album_title,
    SUM(il.unit_price * il.quantity) as total_revenue,
    SUM(il.quantity) as total_sold
FROM track t
JOIN invoice_line il ON t.track_id = il.track_id
JOIN album al ON t.album_id = al.album_id
JOIN artist ar ON al.artist_id = ar.artist_id
GROUP BY t.track_id, t.name, ar.name, al.title
ORDER BY total_revenue DESC
LIMIT 20;

-- 2. Most popular genres by sales
SELECT 
    g.name as genre,
    COUNT(il.track_id) as tracks_sold,
    SUM(il.unit_price * il.quantity) as total_revenue,
    ROUND(AVG(il.unit_price), 2) as avg_price_per_track
FROM genre g
JOIN track t ON g.genre_id = t.genre_id
JOIN invoice_line il ON t.track_id = il.track_id
GROUP BY g.genre_id, g.name
ORDER BY total_revenue DESC;

-- 3. Tracks that have never been purchased
SELECT 
    t.track_id,
    t.name as track_name,
    ar.name as artist_name,
    al.title as album_title
FROM track t
LEFT JOIN invoice_line il ON t.track_id = il.track_id
JOIN album al ON t.album_id = al.album_id
JOIN artist ar ON al.artist_id = ar.artist_id
WHERE il.track_id IS NULL
ORDER BY ar.name, al.title, t.name;