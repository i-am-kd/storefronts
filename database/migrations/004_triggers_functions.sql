-- +goose Up
-- +goose StatementBegin
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
        NEW.updated_at = NOW();
        RETURN NEW;
END;
$$ LANGUAGE plpgsql;
-- +goose StatementEnd

-- +goose StatementBegin
CREATE TRIGGER trg_stores_updated_at BEFORE UPDATE ON stores FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER trg_categories_updated_at BEFORE UPDATE ON categories FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER trg_products_updated_at BEFORE UPDATE ON products FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER trg_transactions_updated_at BEFORE UPDATE ON transactions FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
-- +goose StatementEnd 


-- +goose StatementBegin
CREATE OR REPLACE FUNCTION sync_transaction_item_store_id()
RETURNS TRIGGER AS $$
BEGIN 
    SELECT store_id INTO NEW.store_id FROM transactions WHERE transaction_id = NEW.transaction_id;
    IF NEW.store_id is NULL THEN 
        RAISE EXCEPTION 'Parent transaction not found for item%', NEW.transaction_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
-- +goose StatementEnd
-- +goose StatementBegin
CREATE TRIGGER trg_sync_item_store_id BEFORE INSERT ON transaction_items
FOR EACH ROW EXECUTE FUNCTION sync_transaction_item_store_id();
-- +goose StatementEnd


-- +goose Down
DROP TRIGGER IF EXISTS trg_sync_item_store_id ON transaction_items;
DROP TRIGGER IF EXISTS trg_transactions_updated_at ON transactions;
DROP TRIGGER IF EXISTS trg_products_updated_at ON products;
DROP TRIGGER IF EXISTS trg_categories_updated_at ON categories;
DROP TRIGGER IF EXISTS trg_stores_updated_at ON stores;
DROP FUNCTION IF EXISTS sync_transaction_item_store_id();
DROP FUNCTION IF EXISTS update_updated_at_column();