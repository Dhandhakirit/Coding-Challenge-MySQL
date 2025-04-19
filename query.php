Question 1: Total Sales Revenue by Product
SELECT 
    products.id,
    products.name,
    SUM(quantity * products.price) AS total_revenue
FROM products
JOIN order_items ON products.id = order_items.product_id
GROUP BY products.id
ORDER BY total_revenue DESC;

Question 2: Top Customers by Spending

SELECT 
    customers.id,
    customers.name,
    SUM(order_items.quantity * order_items.price) AS total_spending
FROM customers
JOIN orders ON customers.id = orders.customer_id
JOIN order_items ON orders.id = order_items.order_id
GROUP BY customers.name
ORDER BY total_spending DESC
LIMIT 5;


Question 3: Average Order Value per Customer
SELECT 
    customers.id,
    customers.name,
    SUM(order_items.quantity * order_items.price) / COUNT(DISTINCT orders.id) AS average_order_value
FROM customers
JOIN orders ON customers.id = orders.customer_id
JOIN order_items ON orders.id = order_items.order_id
GROUP BY customers.id, customers.name
ORDER BY average_order_value DESC;


Question 4: Recent Orders
SELECT 
    orders.id AS order_id,
    customers.name AS customer_name,
    orders.order_date,
    orders.status
FROM orders
JOIN customers ON orders.customer_id = customers.id
WHERE orders.order_date >= NOW() - INTERVAL 30 DAY;


Question 5: Running Total of Customer Spending
WITH order_totals AS (
    SELECT 
        orders.id AS order_id,
        orders.customer_id,
        orders.order_date,
        SUM(order_items.quantity * order_items.price) AS order_total
    FROM orders
    JOIN order_items ON orders.id = order_items.order_id
    GROUP BY orders.id, orders.customer_id, orders.order_date
)
SELECT 
    customer_id,
    order_id,
    order_date,
    order_total,
    SUM(order_total) OVER (PARTITION BY customer_id ORDER BY order_date) AS running_total
FROM order_totals;


Question 6: Product Review Summary
SELECT 
    products.id,
    products.name,
    AVG(reviews.rating) AS average_rating,
    COUNT(reviews.id) AS total_reviews
FROM products
LEFT JOIN reviews ON products.id = reviews.product_id
GROUP BY products.id, products.name
ORDER BY average_rating DESC, total_reviews DESC;


Question 7: Customers Without Orders
SELECT 
    customers.id,
    customers.name
FROM customers
LEFT JOIN orders ON customers.id = orders.customer_id
WHERE orders.id IS NULL;


Question 8: Update Last Purchased Date
UPDATE products
JOIN (
    SELECT 
        order_items.product_id,
        MAX(orders.order_date) AS last_purchased_date
    FROM order_items
    JOIN orders ON order_items.order_id = orders.id
    GROUP BY order_items.product_id
) latest_order ON products.id = latest_order.product_id
SET products.last_purchased = latest_order.last_purchased_date;

Question 9: Transaction Scenario
START TRANSACTION;

-- Example for product_id = 1, quantity = 3
UPDATE products
SET stock = stock - 3
WHERE id = 1;

INSERT INTO orders (customer_id, order_date, status)
VALUES (1, NOW(), 'confirmed');

SET @order_id = LAST_INSERT_ID();

INSERT INTO order_items (order_id, product_id, quantity, price)
VALUES (@order_id, 1, 3, 199.99);

UPDATE products
SET last_purchased = NOW()
WHERE id = 1;

COMMIT;


Question 10: Query Optimization and Indexing (Short Answer)
EXPLAIN SELECT 
    customers.id,
    customers.name,
    SUM(order_items.quantity * order_items.price)
FROM customers
JOIN orders ON customers.id = orders.customer_id
JOIN order_items ON orders.id = order_items.order_id
GROUP BY customers.id;


Question 11: Query Optimization Challenge
SELECT 
    c.id AS customer_id, 
    c.name,
    (
        SELECT SUM(oi.quantity * oi.price)
        FROM orders o
        JOIN order_items oi ON o.id = oi.order_id
        WHERE o.customer_id = c.id
    ) AS total_spent
FROM customers c
WHERE EXISTS (
    SELECT 1 FROM orders o WHERE o.customer_id = c.id
)
ORDER BY total_spent DESC;


