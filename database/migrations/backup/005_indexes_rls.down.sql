DROP POLICY IF EXISTS tenant_isolation_movements ON inventory_movements;
DROP POLICY IF EXISTS tenant_isolation_items ON transaction_items;
DROP POLICY IF EXISTS tenant_isolation_transactions ON transactions;
DROP POLICY IF EXISTS tenant_isolation_products ON products;
DROP POLICY IF EXISTS tenant_isolation_categories ON categories;
DROP POLICY IF EXISTS tenant_isolation_stores ON stores;

ALTER TABLE stores DISABLE ROW LEVEL SECURITY;
ALTER TABLE categories DISABLE ROW LEVEL SECURITY;
ALTER TABLE transactions DISABLE ROW LEVEL SECURITY;
ALTER TABLE transaction_items DISABLE ROW LEVEL SECURITY;
ALTER TABLE inventory_movements DISABLE ROW LEVEL SECURITY;

DROP INDEX IF EXISTS idx_store_active, idx_products_active, idx_movements_product_store, idx_items_transaction, idx_transactions_store_sku, idx_stores_location;
