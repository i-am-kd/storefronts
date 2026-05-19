CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
        NEW.updated_at = NOW();
        RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_stores_updated_at BEFORE UPDATE ON stores FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER trg_categories_updated_at BEFORE UPDATE ON categories FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER trg_products_updated_at BEFORE UPDATE ON products FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER trg_transactions_updated_at BEFORE UPDATE ON transactions FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

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

CREATE TRIGGER trg_sync_item_store_id BEFORE INSERT ON transaction_items
FOR EARCH ROW EXECUTE FUNCTION sync_transaction_item_store_id();
