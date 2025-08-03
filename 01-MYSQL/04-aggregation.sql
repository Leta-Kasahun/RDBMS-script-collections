USE eccommerse_data;

-- Total number of orders placed by each user
SELECT user_id, COUNT(*) AS total_orders
FROM orders
GROUP BY user_id;

-- Total revenue generated per product
SELECT product_id, SUM(quantity * price) AS total_revenue
FROM order_items
GROUP BY product_id;

-- Average rating per product from reviews
SELECT product_id, AVG(rating) AS avg_rating, COUNT(*) AS review_count
FROM reviews
GROUP BY product_id;

-- Number of products in each category
SELECT category, COUNT(*) AS product_count
FROM products
GROUP BY category;

-- Total sales amount per month (year-month)
SELECT DATE_FORMAT(order_date, '%Y-%m') AS month, SUM(total_amount) AS monthly_sales
FROM orders
GROUP BY month
ORDER BY month;
