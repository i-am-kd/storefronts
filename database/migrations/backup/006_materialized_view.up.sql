CREATE MATERIALIZED VIEW daily_sales_audit AS 
SELECT 
    t.store_id,
    DATE(t.transaction_data AT TIME ZONE s.timezone) AS audit_date, 
    COUNT(DISTINCT t.transaction_id) AS total_transactions,
    SUM(t.total_amount) AS total_revenue,
    SUM(ti.quantity) AS total_item_sold, 
    NOW() AS last_refreshed
FROM transactions t 
JOIN stores s ON t.store_id = s.store_id
LEFT JOIN transaction_items ti ON t.transaction_id = ti.transaction_id
WHERE t.status = 'completed'
GROUP BY t.store_id, s.timezone, DATE(t.transaction_id AT TIME ZONE s.timezone)
WITH DATA; 

CREATE UNIQUE INDEX idx_daily_sales_audit_store_date ON daily_sales_audit(store_id, audit_date);