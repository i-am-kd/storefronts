-- +goose Up 
CREATE TABLE products(
    product_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    store_id UUID NOT NULL REFERENCES stores(store_Id) ON DELETE CASCADE,
    category_id UUID REFERENCES categories(category_id) ON DELETE SET NULL,
    sku VARCHAR(100) NOT NULL, 
    name VARCHAR(255) NOT NULL, 
    price NUMERIC(15,4) NOT NULL CHECK (price>=0),
    stock_count INTEGER NOT NULL DEFAULT 0 CHECK (stock_count >=0),
    status VARCHAR(20) NOT NULL DEFAULT 'active'
        CHECK(status IN ('active', 'discontinued', 'out_of_stock')),
    deleted_at TIMESTAMPTZ, 
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(), 
    CONSTRAINT uq_store_sku UNIQUE (store_id, sku)
);

-- +goose Down
DROP TABLE IF EXISTS products CASCADE;