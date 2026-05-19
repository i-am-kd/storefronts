CREATE TABLE transactions (
    transaction_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    store_id UUI NOT NULL REFERENCES stores(store_id) NO DELETE RESTRICT,
    customer_name VARCHAR(255) NOT NULL,
    customer_email VARCHAR(255),
    total_amound NUMERIC(15, 4) NOT NULL CHECK (total_amound>=0),
    status VARCHAR(20) NOT NULL DEFAULT 'completed'
        CHECK(status IN ('completed', 'cancelled', 'refunded')),
    transaction_date TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW (),
    CONSTRAINT check_email_format CHECK(customer_email IS NULL OR customer_email ~*'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')
);

CREATE TABLE transaction_items (
    item_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    transaction_id UUID NOT NULL REFERENCES transactions(transaction_id) ON DELETE CASCADE,
    product_id UUID NOT NULL REFERENCES products(product_id) ON DELETE RESTRICT,
    store_id UUID NOT NULL REFERENCES stores(store_id) ON DELETE RESTRICT,
    quantity INTEGER NOT NULL CHECK (quantity>0),
    unit_price NUMERIC(15, 4) NOT NULL CHECK (unit_price >=0),
    subtotal NUMERIC(15, 4) NOT NULL GENERATED ALWAYS AS (quantity*unit_price) STORED,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE inventory_movements(
    movement_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id UUID NOT NULL REFERENCES products(product_id) ON DELETE RESTRICT,
    store_id UUID NOT NULL REFERENCES stores(store_id) ON DELETE RESTRICT,
    quantity_change INTEGER NOT NULL, 
    reason VARCHAR(50) NOT NULL CHECK (reason IN ('sale', 'restock', 'adjustment','return','correction')),
    reference_id UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);