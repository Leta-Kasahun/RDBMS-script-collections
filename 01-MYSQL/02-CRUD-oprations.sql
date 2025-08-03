-- CRUD operations for eccommerse_data tables: users, products, orders, order_items, reviews

USE eccommerse_data;

-- ============ USERS ============

-- Create (Insert)
INSERT INTO users (username, email, password, first_name, last_name, created_at)
VALUES
('john_doe', 'john@example.com', 'pass123', 'John', 'Doe', NOW()),
('jane_smith', 'jane@example.com', 'pass456', 'Jane', 'Smith', NOW());

-- Read (Select)
SELECT * FROM users;
SELECT username, email FROM users WHERE id = 1;

-- Update
UPDATE users
SET email = 'john.newemail@example.com'
WHERE id = 1;

-- Delete
DELETE FROM users WHERE id = 2;

-- ============ PRODUCTS ============

-- Create (Insert)
INSERT INTO products (name, description, price, stock_quantity, category, created_at)
VALUES
('Laptop', '15 inch gaming laptop', 1200.00, 15, 'Electronics', NOW()),
('Headphones', 'Noise-cancelling headphones', 200.00, 30, 'Accessories', NOW());

-- Read (Select)
SELECT * FROM products;
SELECT name, price FROM products WHERE stock_quantity > 10;

-- Update
UPDATE products
SET stock_quantity = stock_quantity - 1
WHERE id = 1;

-- Delete
DELETE FROM products WHERE id = 2;

-- ============ ORDERS ============

-- Create (Insert)
INSERT INTO orders (user_id, total_amount, status, order_date, shipped_date, shipping_address)
VALUES
(1, 1200.00, 'Processing', NOW(), NULL, '123 Main St, City'),
(1, 200.00, 'Shipped', NOW() - INTERVAL 5 DAY, NOW(), '123 Main St, City');

-- Read (Select)
SELECT * FROM orders;
SELECT id, total_amount, status FROM orders WHERE user_id = 1;

-- Update
UPDATE orders
SET status = 'Completed', shipped_date = NOW()
WHERE id = 1;

-- Delete
DELETE FROM orders WHERE id = 2;

-- ============ ORDER_ITEMS ============

-- Create (Insert)
INSERT INTO order_items (order_id, product_id, quantity, price, discount, created_at)
VALUES
(1, 1, 1, 1200.00, 0, NOW()),
(2, 2, 1, 200.00, 10, NOW());

-- Read (Select)
SELECT * FROM order_items;
SELECT order_id, product_id, quantity FROM order_items WHERE order_id = 1;

-- Update
UPDATE order_items
SET quantity = 2
WHERE order_id = 1 AND product_id = 1;

-- Delete
DELETE FROM order_items WHERE order_id = 2;

-- ============ REVIEWS ============

-- Create (Insert)
INSERT INTO reviews (product_id, user_id, rating, comment, created_at)
VALUES
(1, 1, 5, 'Excellent product!', NOW()),
(1, 1, 4, 'Good value for money', NOW());

-- Read (Select)
SELECT * FROM reviews;
SELECT product_id, rating FROM reviews WHERE user_id = 1;

-- Update
UPDATE reviews
SET rating = 3, comment = 'Average product'
WHERE id = 2;

-- Delete
DELETE FROM reviews WHERE id = 2;
