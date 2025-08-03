-- ============================================
-- E-COMMERCE SCHEMA + SEED DATA + DEMO QUERIES
-- ============================================

-- 1. Clean up previous runs (for development)
create database eccommerse_data;
uses eccommerse_data;
-- 2. Schema creation

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    user_role ENUM('customer','admin','support') DEFAULT 'customer',
    last_login DATETIME NULL
);

CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL,
    sku VARCHAR(50) UNIQUE NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50) NOT NULL DEFAULT 'pending',
    total_amount DECIMAL(12,2) NOT NULL,
    shipping_address VARCHAR(255),
    payment_method VARCHAR(100),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(12,2) AS (quantity * unit_price) STORED,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id)
);

CREATE TABLE reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    user_id INT NOT NULL,
    rating TINYINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    is_verified_purchase BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 3. Seed data (≥10 rows each)

-- USERS
INSERT INTO users (full_name, email, password_hash, user_role, last_login) VALUES
  ('Leta Kasahun', 'leta@example.com', 'hash1', 'customer', NOW() - INTERVAL 2 DAY),
  ('Sara John', 'sara@example.com', 'hash2', 'customer', NOW() - INTERVAL 1 DAY),
  ('Mark Joe', 'mark@example.com', 'hash3', 'customer', NULL),
  ('Alice Smith', 'alice@example.com', 'hash4', 'customer', NOW() - INTERVAL 5 HOUR),
  ('Bob Brown', 'bob@example.com', 'hash5', 'customer', NOW() - INTERVAL 10 HOUR),
  ('Charlie King', 'charlie@example.com', 'hash6', 'support', NOW() - INTERVAL 3 DAY),
  ('Dana White', 'dana@example.com', 'hash7', 'customer', NOW() - INTERVAL 7 DAY),
  ('Eve Green', 'eve@example.com', 'hash8', 'customer', NOW() - INTERVAL 30 MINUTE),
  ('Frank Black', 'frank@example.com', 'hash9', 'customer', NULL),
  ('Grace Lee', 'grace@example.com', 'hash10', 'admin', NOW());

-- PRODUCTS
INSERT INTO products (name, description, price, stock, sku) VALUES
  ('Wireless Mouse', 'Ergonomic wireless mouse with USB receiver', 25.99, 150, 'WM-001'),
  ('Mechanical Keyboard', 'RGB backlit mechanical keyboard, blue switches', 89.50, 80, 'MK-002'),
  ('USB-C Hub', 'Multiport adapter with HDMI, USB-A, Ethernet', 49.99, 200, 'HUB-003'),
  ('27\" Monitor', '4K UHD IPS monitor with HDR support', 329.99, 40, 'MN-004'),
  ('External SSD 1TB', 'Portable NVMe SSD, USB 3.2', 119.00, 60, 'SSD-005'),
  ('Noise-Cancelling Headphones', 'Over-ear wireless with active noise cancellation', 199.99, 35, 'HP-006'),
  ('Webcam 1080p', 'Full HD webcam with built-in microphone', 59.95, 120, 'WC-007'),
  ('Laptop Stand', 'Adjustable aluminum laptop stand', 35.00, 250, 'LS-008'),
  ('Wireless Charger', 'Fast Qi wireless charging pad', 29.99, 180, 'WC-009'),
  ('Smart Speaker', 'Voice-controlled smart home speaker', 79.99, 90, 'SS-010');

-- ORDERS
INSERT INTO orders (user_id, status, total_amount, shipping_address, payment_method) VALUES
  (1, 'completed', 115.48, '123 Addis St, Addis Ababa', 'Credit Card'),
  (2, 'pending', 329.99, '456 Bole Rd, Addis Ababa', 'PayPal'),
  (3, 'shipped', 25.99, '789 Sar Bet, Addis Ababa', 'Credit Card'),
  (4, 'completed', 239.49, '12 Merkato Ln, Addis Ababa', 'Debit Card'),
  (5, 'cancelled', 89.50, '34 Africa Ave, Addis Ababa', 'Credit Card'),
  (1, 'completed', 59.95, '123 Addis St, Addis Ababa', 'Credit Card'),
  (6, 'pending', 199.99, '77 Piazza, Addis Ababa', 'Credit Card'),
  (7, 'completed', 149.99, '88 Unity Pl, Addis Ababa', 'PayPal'),
  (8, 'processing', 329.99, '99 Liberty St, Addis Ababa', 'Credit Card'),
  (9, 'completed', 25.99, '11 Sunrise Rd, Addis Ababa', 'Debit Card');

-- ORDER_ITEMS
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
  (1, 1, 2, 25.99),
  (1, 9, 1, 29.99),
  (2, 4, 1, 329.99),
  (3, 1, 1, 25.99),
  (4, 2, 1, 89.50),
  (4, 6, 1, 199.99),
  (5, 2, 1, 89.50),
  (6, 7, 1, 59.95),
  (7, 6, 1, 199.99),
  (8, 4, 1, 329.99),
  (9, 1, 1, 25.99),
  (10,1, 1, 25.99);

-- REVIEWS
INSERT INTO reviews (product_id, user_id, rating, comment, is_verified_purchase) VALUES
  (1, 1, 5, 'Excellent mouse, very responsive.', TRUE),
  (2, 4, 4, 'Keyboard is loud but solid build.', TRUE),
  (4, 2, 5, 'Display color accuracy is great.', TRUE),
  (6, 7, 3, 'Noise cancellation is okay, expected better.', FALSE),
  (1, 3, 5, 'Comfortable and reliable for daily use.', TRUE),
  (9, 5, 4, 'Charges quickly, no issues so far.', TRUE),
  (7, 8, 5, 'Perfect for video calls.', TRUE),
  (10,9,4, 'Good sound quality for the price.', FALSE),
  (5, 1, 5, 'Super fast SSD, dramatically improved boot time.', TRUE),
  (3, 2, 3, 'Hub works but gets warm after prolonged use.', TRUE),
  (8, 4, 4, 'Sturdy and adjustable.', TRUE),
  (2, 5, 5, 'Loving the RGB effects!', TRUE);

-- 4. Example useful queries

-- a) Top 5 customers by total completed order amount
SELECT 
  u.full_name,
  SUM(o.total_amount) AS total_spent
FROM users u
JOIN orders o ON u.id = o.user_id
WHERE o.status = 'completed'
GROUP BY u.id
ORDER BY total_spent DESC
LIMIT 5;

-- b) Recent reviews with product name and reviewer
SELECT 
  r.rating,
  r.comment,
  p.name AS product,
  u.full_name AS reviewer,
  r.created_at
FROM reviews r
JOIN products p ON r.product_id = p.id
JOIN users u ON r.user_id = u.id
ORDER BY r.created_at DESC
LIMIT 10;



