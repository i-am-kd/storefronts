DROP TRIGGER IF EXISTS trg_sync_item_store_id ON transaction_items;
DROP TRIGGER IF EXISTS trg_transactions_updated_at ON transactions;
DROP TRIGGER IF EXISTS trg_products_updated_at ON products;
DROP TRIGGER IF EXISTS trg_categories_updated_at ON categories;
DROP TRIGGER IF EXISTS trg_stores_updated_at ON stores;
DROP FUNCTION IF EXISTS sync_transaction_item_store_id();
DROP FUNCTION IF EXISTS update_updated_at_column();