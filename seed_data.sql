-- Drop tables if they exist (order matters due to foreign keys)
DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

-- =====================================
-- Create customers table
-- =====================================
CREATE TABLE customers (
                           id INT AUTO_INCREMENT PRIMARY KEY,
                           name VARCHAR(100) NOT NULL,
                           email VARCHAR(100) NOT NULL UNIQUE,
                           phone VARCHAR(20),
                           created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- =====================================
-- Create products table
-- =====================================
CREATE TABLE products (
                          id INT AUTO_INCREMENT PRIMARY KEY,
                          name VARCHAR(100) NOT NULL,
                          description TEXT,
                          price DECIMAL(10,2) NOT NULL,
                          stock INT NOT NULL DEFAULT 0,
                          last_purchased TIMESTAMP NULL,
                          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- =====================================
-- Create orders table
-- =====================================
CREATE TABLE orders (
                        id INT AUTO_INCREMENT PRIMARY KEY,
                        customer_id INT NOT NULL,
                        order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                        status VARCHAR(50) NOT NULL DEFAULT 'pending',
                        FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- =====================================
-- Create order_items table
-- =====================================
CREATE TABLE order_items (
                             id INT AUTO_INCREMENT PRIMARY KEY,
                             order_id INT NOT NULL,
                             product_id INT NOT NULL,
                             quantity INT NOT NULL,
                             price DECIMAL(10,2) NOT NULL,
                             FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
                             FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- =====================================
-- Create reviews table
-- =====================================
CREATE TABLE reviews (
                         id INT AUTO_INCREMENT PRIMARY KEY,
                         product_id INT NOT NULL,
                         customer_id INT NOT NULL,
                         rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
                         review_text TEXT,
                         review_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                         FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
                         FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- =====================================
-- Insert seed data for customers
-- =====================================
INSERT INTO customers (name, email, phone) VALUES
                                               ('Alice Johnson', 'alice@example.com', '123-456-7890'),
                                               ('Bob Smith', 'bob@example.com', '234-567-8901'),
                                               ('Carol White', 'carol@example.com', '345-678-9012'),
                                               ('David Brown', 'david@example.com', '456-789-0123'),
                                               ('Eve Davis', 'eve@example.com', '567-890-1234'),
                                               ('Frank Miller', 'frank@example.com', '678-901-2345'),
                                               ('Grace Lee', 'grace@example.com', '789-012-3456'),
                                               ('Henry Wilson', 'henry@example.com', '890-123-4567'),
                                               ('Ivy Martinez', 'ivy@example.com', '901-234-5678'),
                                               ('Jack Taylor', 'jack@example.com', '012-345-6789');

-- =====================================
-- Insert seed data for products
-- =====================================
INSERT INTO products (name, description, price, stock) VALUES
                                                           ('Laptop', 'High performance laptop', 999.99, 50),
                                                           ('Smartphone', 'Latest smartphone model', 699.99, 100),
                                                           ('Headphones', 'Noise cancelling headphones', 199.99, 150),
                                                           ('Monitor', '24-inch LED monitor', 149.99, 75),
                                                           ('Keyboard', 'Mechanical keyboard', 89.99, 120),
                                                           ('Mouse', 'Wireless mouse', 49.99, 200),
                                                           ('Printer', 'All-in-one printer', 129.99, 30),
                                                           ('Tablet', '10-inch tablet device', 299.99, 80),
                                                           ('Smartwatch', 'Feature-rich smartwatch', 249.99, 60),
                                                           ('Camera', 'Digital SLR camera', 549.99, 40);

-- =====================================
-- Insert seed data for orders
-- =====================================
INSERT INTO orders (customer_id, order_date, status) VALUES
                                                         (1, '2025-02-20 10:30:00', 'completed'),
                                                         (2, '2025-02-22 14:45:00', 'completed'),
                                                         (3, '2025-03-01 09:15:00', 'pending'),
                                                         (4, '2025-03-02 16:00:00', 'completed'),
                                                         (5, '2025-03-03 11:20:00', 'pending'),
                                                         (6, '2025-02-25 13:30:00', 'completed');

-- =====================================
-- Insert seed data for order_items
-- =====================================
INSERT INTO order_items (order_id, product_id, quantity, price) VALUES
                                                                    (1, 1, 1, 999.99),
                                                                    (1, 3, 2, 199.99),
                                                                    (2, 2, 1, 699.99),
                                                                    (2, 5, 1, 89.99),
                                                                    (3, 4, 2, 149.99),
                                                                    (3, 6, 3, 49.99),
                                                                    (4, 7, 1, 129.99),
                                                                    (4, 2, 2, 699.99),
                                                                    (5, 8, 1, 299.99),
                                                                    (5, 9, 1, 249.99),
                                                                    (6, 10, 1, 549.99),
                                                                    (6, 1, 1, 999.99);

-- =====================================
-- Insert seed data for reviews
-- =====================================
INSERT INTO reviews (product_id, customer_id, rating, review_text) VALUES
                                                                       (1, 1, 5, 'Excellent laptop, very fast and reliable.'),
                                                                       (2, 2, 4, 'Good smartphone but battery life could be better.'),
                                                                       (3, 3, 5, 'Amazing headphones with great noise cancellation.'),
                                                                       (4, 4, 4, 'Decent monitor for everyday use.'),
                                                                       (5, 5, 3, 'Keyboard is okay, but keys feel a bit stiff.'),
                                                                       (6, 6, 4, 'Mouse works well and is very responsive.'),
                                                                       (7, 7, 2, 'Printer has frequent paper jams.'),
                                                                       (8, 8, 5, 'Tablet is very responsive and has a crisp display.'),
                                                                       (9, 9, 4, 'Smartwatch is feature-rich and user-friendly.'),
                                                                       (10, 10, 5, 'Camera takes stunning photos.');
