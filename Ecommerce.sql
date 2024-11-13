-- Create a new database
-- CREATE DATABASE store;

-- USE store;

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
    date_added DATE DEFAULT CURRENT_DATE
);

-- Create Orders Table with Foreign Key to Customers
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    order_status VARCHAR(20) DEFAULT 'Pending',
    total_order_amount DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Create Order Details Table with Foreign Keys to Orders and Products
CREATE TABLE order_details (
    order_detail_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity_ordered INT,
    price_per_product DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
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

-- Testing Queries

-- Retrieve all orders for a specific customer, showing only order IDs and dates
SELECT order_id, order_date 
FROM orders
WHERE customer_id = 1;

-- Retrieve all details for a specific order, showing each product’s name, quantity, and price per item
SELECT products.product_name, order_details.quantity_ordered, order_details.price_per_product
FROM order_details
JOIN products ON order_details.product_id = products.product_id
WHERE order_details.order_id = 1;
