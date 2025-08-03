USE eccommerse_data;

-- ===================================
-- Stored Procedure: place_order
-- Inserts a new order for a user and uses transaction
-- ===================================
DELIMITER $$

CREATE PROCEDURE place_order(
    IN p_user_id INT,
    IN p_total_amount DECIMAL(10,2)
)
BEGIN
    DECLARE new_order_id INT;

    START TRANSACTION;
    
    INSERT INTO orders (user_id, order_date, total_amount)
    VALUES (p_user_id, NOW(), p_total_amount);
    
    SET new_order_id = LAST_INSERT_ID();
    
    -- Example insert into order_items (add items for this order)
    -- You can expand to accept array-like inputs or call more procedures
    
    COMMIT;
END$$

DELIMITER ;

-- ===================================
-- Trigger: update_product_stock
-- Decreases product stock after new order_item insert
-- ===================================
DELIMITER $$

CREATE TRIGGER trg_after_order_item_insert
AFTER INSERT ON order_items
FOR EACH ROW
BEGIN
    UPDATE products
    SET stock_quantity = stock_quantity - NEW.quantity
    WHERE product_id = NEW.product_id;
END$$

DELIMITER ;

-- ===================================
-- Trigger: prevent_negative_stock
-- Prevents stock_quantity from going negative on product update
-- ===================================
DELIMITER $$

CREATE TRIGGER trg_before_product_update
BEFORE UPDATE ON products
FOR EACH ROW
BEGIN
    IF NEW.stock_quantity < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stock quantity cannot be negative';
    END IF;
END$$

DELIMITER ;

-- ===================================
-- Example of using a transaction explicitly
-- ===================================
START TRANSACTION;

-- Update user email
UPDATE users SET email = 'newemail@example.com' WHERE user_id = 1;

-- Insert a review for product_id=2 by user_id=1
INSERT INTO reviews (product_id, user_id, rating, comment)
VALUES (2, 1, 5, 'Excellent product!');

-- If both succeed, commit changes
COMMIT;

-- If something goes wrong, use ROLLBACK;
-- ROLLBACK;
