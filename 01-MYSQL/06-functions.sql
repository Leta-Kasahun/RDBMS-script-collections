USE eccommerse_data;

-- ========== Aggregate Functions ==========
SELECT COUNT(*) AS total_users FROM users;
SELECT SUM(total_amount) AS total_sales FROM orders;
SELECT AVG(price) AS avg_price FROM products;
SELECT MAX(total_amount) AS max_order, MIN(total_amount) AS min_order FROM orders;
SELECT COUNT(DISTINCT user_id) AS unique_customers FROM orders;

-- ========== String Functions ==========
SELECT CONCAT(first_name, ' ', last_name) AS full_name FROM users;
SELECT SUBSTRING(name, 1, 5) AS short_name FROM products;
SELECT LOWER(email) FROM users;
SELECT LENGTH(comment) AS comment_length FROM reviews;
SELECT REPLACE(comment, 'good', 'great') FROM reviews;

-- ========== Date and Time Functions ==========
SELECT NOW() AS current_datetime;
SELECT YEAR(order_date) AS order_year FROM orders;
SELECT MONTHNAME(order_date) AS order_month FROM orders;
SELECT DATEDIFF(NOW(), order_date) AS days_since_order FROM orders;
SELECT DATE_FORMAT(order_date, '%d %M %Y') AS formatted_date FROM orders;

-- ========== Mathematical Functions ==========
SELECT ROUND(price) AS rounded_price FROM products;
SELECT ABS(price - 100) AS price_diff FROM products;
SELECT CEIL(price) AS ceil_price, FLOOR(price) AS floor_price FROM products;
SELECT POWER(price, 2) AS price_squared, SQRT(price) AS price_sqrt FROM products;

-- ========== Control Flow Functions ==========
SELECT name,
  CASE 
    WHEN price > 1000 THEN 'High Price'
    WHEN price BETWEEN 500 AND 1000 THEN 'Medium Price'
    ELSE 'Low Price'
  END AS price_category
FROM products;

SELECT rating,
  IF(rating >= 4, 'Good', 'Average or Poor') AS rating_quality
FROM reviews;

-- ========== User-defined Function ==========
DELIMITER $$
CREATE FUNCTION discounted_price(original_price DECIMAL(10,2), discount_percent INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
  RETURN original_price - (original_price * discount_percent / 100);
END$$
DELIMITER ;

-- Example usage of the user-defined function
SELECT name, price, discounted_price(price, 10) AS price_after_discount FROM products;
