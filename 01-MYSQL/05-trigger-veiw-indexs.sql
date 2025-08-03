USE eccommerse_data;

-- 1. Create a view for summarized order info
CREATE OR REPLACE VIEW order_summary AS
SELECT
  o.id AS order_id,
  o.user_id,
  o.status,
  o.order_date,
  COUNT(oi.product_id) AS total_items,
  SUM(oi.quantity * oi.price) AS total_price
FROM orders o
JOIN order_items oi ON o.id = oi.order_id
GROUP BY o.id, o.user_id, o.status, o.order_date;

-- 2. Create indexes on frequently queried columns
CREATE INDEX idx_user_id ON orders(user_id);
CREATE INDEX idx_product_id ON order_items(product_id);
CREATE INDEX idx_order_status ON orders(status);

-- 3. Create a trigger to update product stock after inserting an order item
DELIMITER $$
CREATE TRIGGER after_order_item_insert
AFTER INSERT ON order_items
FOR EACH ROW
BEGIN
  UPDATE products
  SET stock_quantity = stock_quantity - NEW.quantity
  WHERE id = NEW.product_id;
END$$
DELIMITER ;
