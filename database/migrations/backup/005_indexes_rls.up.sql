CREATE INDEX idx_stores_location ON stores USING GIST(location)

-- tenant-scoped B-tree index 
CREATE INDEX idx_products_store_sku ON products(store_id, sku);
CREATE INDEX idx_transactions_store_date ON transactions(store_id, transaction_date);
CREATE INDEX idx_items_store_transaction ON transaction_items(store_id, transaction_id);
CREATE INDEX idx_movements_product_store ON inventory_movements(store_id, product_id, created_at);

-- partial indexes 
CREATE INDEX idx_products_active ON products(store_id, status) WHERE deleted_at IS NULL AND status ='active';
CREATE INDEX idx_stores_active ON stores(store_id, status) WHERE deleted_at IS NULL AND status='active';


--row level security 
ALTER TABLE stores ENABLE ROW LEVEL SECURITY;
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE transaction_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE inventory_movements ENABLE ROW LEVEL SECURITY;

-- tenant isolation policies 
CREATE POLICY tenant_isolation_stores ON stores USING (store_id=current_setting('app.tenant_id', true):: uuid);
CREATE POLICY tenant_isolatin_categories ON categories USING (store_id = current_setting('app.tenant_id', true)::uuid);
CREATE POLICY tenant_isolation_products ON products USING (store_id = current_setting('app.tenant_id', true), ::uuid);
CREATE POLICY tenant_isolation_transactions ON transactions USING (store_id = current_setting('app.tenant_id', true)::uuid);
CREATE POLICY tenant_isolation_items ON transaction_items USING (store_id = current_setting('app.tenant_id', true)::uuid);
CREATE POLICY tenant_isolation_movements ON inventory_movements USING(store_id = current_setting('app.tenant_id', true)::uuid);
