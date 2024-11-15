-- Create a new database
CREATE DATABASE store;

-- Use the database
USE store;

-- Create Customers Table
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(40) NOT NULL,
    email VARCHAR(50) UNIQUE,
    phone VARCHAR(20) UNIQUE,
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Address Table with Foreign Key to Customers
CREATE TABLE address (
    address_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    street_name VARCHAR(30),
    street_number VARCHAR(10),
    zip_code VARCHAR(9),
    state VARCHAR(50),
    city VARCHAR(50),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Create Products Table
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(50) NOT NULL,
    product_description VARCHAR(500),
    price DECIMAL(10, 2),
    product_stock_quantity INT,
    CONSTRAINT chk_price CHECK (price >= 0),
    CONSTRAINT chk_stock CHECK (product_stock_quantity >= 0)
);

-- Create Orders Table with Foreign Key to Customers
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    order_status VARCHAR(20) DEFAULT 'Pending',
    total_order_amount DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    INDEX idx_customer_date (customer_id, order_date)
);

-- Create Order Details Table with Foreign Keys to Orders and Products
CREATE TABLE order_details (
    order_detail_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity_ordered INT,
    price_per_product DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    CONSTRAINT chk_quantity CHECK (quantity_ordered > 0),
    CONSTRAINT chk_price_per_product CHECK (price_per_product >= 0)
);

-- Populate Data

-- Sample Customers
INSERT INTO customers (first_name, last_name, email, phone)
VALUES 
    ('John', 'Doe', 'john.doe@example.com', '1234567890'),
    ('Jane', 'Smith', 'jane.smith@example.com', '0987654321');

-- Sample Addresses
INSERT INTO address (customer_id, street_name, street_number, zip_code, state, city)
VALUES 
    (1, 'Main St', '123', '12345', 'PA', 'Philadelphia'),
    (2, 'Second St', '456', '67890', 'PA', 'Philadelphia');

-- Sample Products
INSERT INTO products (product_name, product_description, price, product_stock_quantity)
VALUES 
    ('HotPockets', 'YUM', 5.99, 90),
    ('Bananas', 'YUMMY', 0.99, 250),
    ('Tomatoes', 'Fresh and Juicy', 1.99, 110);

-- Sample Order for a Customer
INSERT INTO orders (customer_id, order_status, total_order_amount)
VALUES 
    (1, 'Shipped', 15.96);  -- total_order_amount can be calculated after inserting order details

-- Sample Order Details for the Order
INSERT INTO order_details (order_id, product_id, quantity_ordered, price_per_product)
VALUES 
    (1, 1, 2, 5.99),  -- 2 HotPockets at 5.99 each
    (1, 2, 3, 0.99);  -- 3 Bananas at 0.99 each

-- Update the stock in the products table based on orders
UPDATE products
SET product_stock_quantity = product_stock_quantity - 2
WHERE product_id = 1;

UPDATE products
SET product_stock_quantity = product_stock_quantity - 3
WHERE product_id = 2;

-- Queries based on instructions

-- 1. Calculate Average Order Value
SELECT 
    order_id, 
    AVG(total_order_amount) AS average_order_value
FROM orders;

-- 2. Count Orders by Status
SELECT 
    order_status AS status, 
    COUNT(*) AS order_count
FROM orders
GROUP BY order_status;

-- 3. Find Highest and Lowest Priced Products
-- Highest Priced Product
SELECT 
    product_id, 
    product_name, 
    price 
FROM products
ORDER BY price DESC
LIMIT 1;

-- Lowest Priced Product
SELECT 
    product_id, 
    product_name, 
    price 
FROM products
ORDER BY price ASC
LIMIT 1;

-- 4. Calculate Total Quantity Sold per Product
SELECT 
    p.product_id, 
    p.product_name, 
    SUM(od.quantity_ordered) AS total_quantity_sold
FROM order_details od
JOIN products p ON od.product_id = p.product_id
GROUP BY p.product_id, p.product_name;

-- 5. Calculate Total Sales Revenue per Day
SELECT 
    DATE(order_date) AS order_date, 
    SUM(total_order_amount) AS total_revenue
FROM orders
GROUP BY DATE(order_date);

-- 6. List Customers with Total Amount Spent
SELECT 
    c.customer_id, 
    c.first_name, 
    c.last_name, 
    SUM(od.price_per_product * od.quantity_ordered) AS total_spent
FROM order_details od
JOIN orders o ON od.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

-- 7. Calculate Average Order Quantity per Product
SELECT 
    p.product_id, 
    p.product_name, 
    AVG(od.quantity_ordered) AS avg_quantity
FROM order_details od
JOIN products p ON od.product_id = p.product_id
GROUP BY p.product_id, p.product_name;

-- 8. Bonus: Find Top 5 Customers by Total Spending
SELECT 
    c.customer_id, 
    c.first_name, 
    c.last_name, 
    SUM(od.price_per_product * od.quantity_ordered) AS total_spent
FROM order_details od
JOIN orders o ON od.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC
LIMIT 5;
