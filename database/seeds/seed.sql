CREATE EXTENSION IF NOT EXISTS pgcrypto;
-- enable RLS bypass for seeding (superuser or bypassrls role required)

-- Remove: SET session_replication_role = 'replica';
-- SET session_replication_role = 'replica';

-- Seed stores
INSERT INTO stores (store_id, name, email, location, timezone, status, password_hash) VALUES
('550e8400-e29b-41d4-a716-446655440000', 'Main Store', 'main@store.com', 'POINT(116.4074 39.9042)', 'Asia/Shanghai', 'active',crypt('AdminPass123!', gen_salt('bf'))),
('550e8400-e29b-41d4-a716-446655440001', 'Branch Store', 'branch@store.com', 'POINT(121.4737 31.2304)', 'Asia/Shanghai', 'active',crypt('AdminPass123!', gen_salt('bf')));

-- Seed categories
INSERT INTO categories (category_id, store_id, name) VALUES
('660e8400-e29b-41d4-a716-446655440000', '550e8400-e29b-41d4-a716-446655440000', 'Electronics'),
('660e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440000', 'Clothing');

-- Seed products
INSERT INTO products (product_id, store_id, category_id, sku, name, price, stock_count, status) VALUES
('770e8400-e29b-41d4-a716-446655440000', '550e8400-e29b-41d4-a716-446655440000', '660e8400-e29b-41d4-a716-446655440000', 'IPHONE15-001', 'iPhone 15', 999.00, 50, 'active'),
('770e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440000', '660e8400-e29b-41d4-a716-446655440000', 'MACBOOK-001', 'MacBook Pro', 1999.00, 20, 'active');

-- Seed transactions
INSERT INTO transactions (transaction_id, store_id, customer_name, customer_email, total_amount, status) VALUES
('880e8400-e29b-41d4-a716-446655440000', '550e8400-e29b-41d4-a716-446655440000', 'John Doe', 'john@example.com', 999.00, 'completed');

-- Seed transaction items
INSERT INTO transaction_items (item_id, transaction_id, product_id, store_id, quantity, unit_price) VALUES
('990e8400-e29b-41d4-a716-446655440000', '880e8400-e29b-41d4-a716-446655440000', '770e8400-e29b-41d4-a716-446655440000', '550e8400-e29b-41d4-a716-446655440000', 1, 999.00);

-- Remove: SET session_replication_role = 'origin';
-- SET session_replication_role = 'origin';

-- UPDATE stores 
-- SET password_hash = crypt('AdminPass123!', gen_salt('bf'))
-- WHERE email ='admin@downtown.store';