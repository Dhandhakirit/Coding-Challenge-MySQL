# Coding Challenge MySQL

This repository contains a set of MySQL exercises based on an e-commerce schema. The schema includes the following tables:

- `customers`
- `products`
- `orders`
- `order_items`
- `reviews`

> **Note:** The seed data for these tables is provided in the `seed_data.sql` file. You can focus on writing queries and solving the challenges without worrying about the schema or data insertion.

## Exercise Questions

### Question 1: Total Sales Revenue by Product
**Task:**  
Write a SQL query that computes the total revenue for each product. Revenue is defined as the sum of (`quantity` × `price`) from all associated order items. Your result should include the product ID, product name, and total revenue, sorted in descending order of revenue.

---

### Question 2: Top Customers by Spending
**Task:**  
Write a SQL query to identify the top 5 customers based on total spending. Calculate each customer's total spending by summing up the value of all their orders (i.e., the sum of `quantity` × `price` for each order item). Return the customer ID, name, and total spending.

---

### Question 3: Average Order Value per Customer
**Task:**  
Write a SQL query that calculates the average order value for each customer who has placed at least one order. The average order value should be computed as the total amount for an order divided by the number of orders for that customer. Return the customer ID, name, and average order value, sorted by average order value in descending order.

---

### Question 4: Recent Orders
**Task:**  
Write a SQL query to list all orders placed within the last 30 days. For each order, return the order ID, the customer’s name, the order date, and the order status. Use an appropriate join between the `orders` and `customers` tables. You may assume the current date is given by `NOW()`.

---

### Question 5: Running Total of Customer Spending
**Task:**  
Using a Common Table Expression (CTE), write a SQL query that returns, for each customer, a list of their orders ordered by `order_date` along with a running total of spending up to each order. Your output should include:
- Customer ID  
- Order ID  
- Order Date  
- Order Total (the sum of `quantity` × `price` for that order)  
- Running Total of spending for that customer

---

### Question 6: Product Review Summary
**Task:**  
Write a SQL query to generate a summary for each product that includes:
- Product ID  
- Product Name  
- Average Review Rating  
- Total Number of Reviews  

Ensure that products without any reviews are also listed (you may display a count of 0 or NULL for the average rating). Sort the results by average rating in descending order (and then by the number of reviews if needed).

---

### Question 7: Customers Without Orders
**Task:**  
Write a SQL query to find all customers who have never placed an order. The output should include the customer ID and customer name.

---

### Question 8: Update Last Purchased Date
**Task:**  
Write a SQL statement (or a series of statements) to update the `last_purchased` column in the `products` table. For each product, set the value to the most recent order date from the orders that contain that product.  
*Hint:* You’ll need to join the `order_items` and `orders` tables to retrieve the order date.

---

### Question 9: Transaction Scenario
**Task:**  
Simulate placing an order by writing a MySQL transaction that does the following:
- Deducts the ordered quantity from a product’s stock.
- Inserts a new record in the `orders` table.
- Inserts one or more records in the `order_items` table for that order.
- Updates the product’s `last_purchased` timestamp with the order date.

Ensure that your transaction includes error handling so that if any part fails, the entire transaction is rolled back. Provide the complete SQL code for the transaction.

---

### Question 10: Query Optimization and Indexing (Short Answer)
**Task:**  
Choose one of the queries you wrote above and answer the following:
- Describe how you would use the `EXPLAIN` statement to analyze its performance.
- Suggest any indexing or query refactoring improvements that could optimize its execution.

---

### Question 11: Query Optimization Challenge
The following query is designed to calculate the total amount each customer has spent. It uses subqueries and the `IN` clause to aggregate order items, but it may not perform well on large datasets.

```sql
-- Unoptimized Query
SELECT 
    c.id AS customer_id, 
    c.name,
    (SELECT SUM(oi.quantity * oi.price)
     FROM order_items oi
     WHERE oi.order_id IN (
         SELECT o.id
         FROM orders o
         WHERE o.customer_id = c.id
     )
    ) AS total_spent
FROM customers c
WHERE c.id IN (SELECT DISTINCT customer_id FROM orders)
ORDER BY total_spent DESC;
