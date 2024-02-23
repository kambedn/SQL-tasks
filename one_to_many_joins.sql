-- Real world data is messy and interrelated
-- Relationships Basics
-- 1. One to One relationship
-- 2. One to Many relationship
-- 3. Many to Many relationship

-- One to One relationships are not that common
-- for example, we have two tables reviews and customers (only one product e.g. course)
-- each customer can give only one review about the product, so
-- one row from customers table is associated with only one row from reviews table

-- One to Many relationship is the most common
-- for example, we have two tables reviews and books
-- one book is associated with many rows from reviews tables

-- Many to Many relationship is relatively common
-- for example, we have two tables books and authors
-- one book can have many authors and one author can write many books

-- 1:MANY 
-- example Customers and Orders
-- customers have many orders, one order has only one customer

-- We want to store:
-- a customer's first and last name
-- a customer's email
-- the date of the pruchase
-- the price of the order
-- NOT A GOOD IDEA:
-- using one table results in many duplicated date, what's more if a customer has not order anything yet,
-- columns regarding the order will contain NULL

-- Good approach
-- We make two tables Customers and Orders
-- Customers has customer_id and so does Orders, thanks to that we have connection between the tables;
-- We don't duplicate data and there are no NULLs
-- Primary keys: customer_id na order_id

-- Foreign keys are references from one table to another table
-- In this example, customer_id in Orders table is a foreign key
CREATE DATABASE joins;
USE joins;

CREATE TABLE customers(
	id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE orders(
	id INT PRIMARY KEY AUTO_INCREMENT,
    order_date DATE NOT NULL,
    amount DECIMAL(8,2) NOT NULL CHECK(amount > 0),
    customer_id INT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(id) -- customer_id must exist in customers table
);

INSERT INTO customers (first_name, last_name, email) 
VALUES ('Boy', 'George', 'george@gmail.com'),
       ('George', 'Michael', 'gm@gmail.com'),
       ('David', 'Bowie', 'david@gmail.com'),
       ('Blue', 'Steele', 'blue@gmail.com'),
       ('Bette', 'Davis', 'bette@aol.com');
       
SELECT * FROM customers;
       
INSERT INTO orders (order_date, amount, customer_id)
VALUES ('2016-02-10', 99.99, 1),
       ('2017-11-11', 35.50, 1),
       ('2014-12-12', 800.67, 2),
       ('2015-01-03', 12.50, 2),
       ('1999-04-11', 450.25, 5);

SELECT * FROM orders;

INSERT INTO orders( order_date, amount, customer_id)
VALUES (CURDATE(), 49.99, 10); -- does not work, a customer with 10 does not exist in customers table

INSERT INTO orders( order_date, amount, customer_id)
VALUES (CURDATE(), -49.99, 1); -- does not work, price has to be positive

-- Select all orders made by Boy George
SELECT * FROM orders
WHERE customer_id = (
		SELECT id FROM customers WHERE last_name = 'George' AND first_name = 'Boy'
	);
    
-- CROSS JOIN / Cartisean jon
-- Combines each row from one table with all rows from another table
-- Not useful
SELECT * FROM customers, orders;

SELECT customers.id, customers.first_name, orders.order_date
FROM customers
CROSS JOIN orders;

-- INNER JOIN 
-- Select all records from A and B where the join condition is met
-- INNER keyword is optional
SELECT * FROM customers
JOIN orders
	ON customers.id = orders.customer_id;
    
SELECT first_name, last_name, order_date, amount
FROM customers
JOIN orders
	ON customers.id = orders.customer_id;

-- if we swap the tables, the sequence of output columns changes
SELECT * FROM orders
JOIN customers
	ON customers.id = orders.customer_id;

-- Find the total amount each customer spend
SELECT first_name, last_name, SUM(amount) AS total_spent
FROM customers
JOIN orders
	ON customers.id = orders.customer_id
GROUP BY first_name, last_name
ORDER BY total_spent DESC;

-- LEFT JOIN
-- Select everything from A, along with any matching records in B
-- The sequence of tables is important here!!!
SELECT first_name, last_name, order_date, amount
FROM customers
LEFT JOIN orders
	ON customers.id = orders.customer_id;
  
-- find all customers who have never placed an order
SELECT first_name, last_name
FROM customers
LEFT JOIN orders
	ON customers.id = orders.customer_id
WHERE amount IS NULL;

-- IFNULL(expr, value) - if expr IS NULL, then value is set in the output
SELECT first_name, last_name, IFNULL(SUM(amount), 0) AS total FROM customers
LEFT JOIN orders ON customers.id = orders.customer_id
GROUP BY first_name, last_name
ORDER BY total DESC;

-- RIGHT JOIN
-- Select everything from B, along with any matching records in A
-- not that common, it can be rewritten to a LEFT JOIN
-- Here each ID has customer_id so the result will be the same as INNER JOIN
SELECT first_name, last_name, amount, order_date
FROM customers
RIGHT JOIN orders ON customers.id = orders.customer_id;

-- What should happen if we delete a customer from a database?
-- Now we can't delete, it will raise a constraint error
-- To take care of this we can by ON DELETE CASCADE
-- If we delete a customer, all orders made by him or her will be deleted
DROP TABLE orders;

CREATE TABLE orders(
	id INT PRIMARY KEY AUTO_INCREMENT,
    order_date DATE NOT NULL,
    amount DECIMAL(8,2) NOT NULL CHECK(amount > 0),
    customer_id INT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE
);

SELECT * FROM orders; -- 5 rows

DELETE FROM customers WHERE last_name = 'George'; -- ok

SELECT * FROM orders; -- 3 rows

CREATE TABLE students(
	id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(40) NOT NULL
);

CREATE TABLE papers(
	title VARCHAR(70) NOT NULL,
    grade TINYINT UNSIGNED NOT NULL,
    student_id INT NOT NULL,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE
);

INSERT INTO students (first_name) VALUES 
('Caleb'), ('Samantha'), ('Raj'), ('Carlos'), ('Lisa');
 
INSERT INTO papers (student_id, title, grade ) VALUES
(1, 'My First Book Report', 60),
(1, 'My Second Book Report', 75),
(2, 'Russian Lit Through The Ages', 94),
(2, 'De Montaigne and The Art of The Essay', 98),
(4, 'Borges and Magical Realism', 89);

SELECT * FROM students;
SELECT * FROM papers;

-- Print first_name, title, grade
SELECT first_name, title, grade
FROM students
JOIN papers
	ON students.id = papers.student_id;
    
-- Print first_name, title, grade and students who did not write any paper
SELECT first_name, title, grade
FROM students
LEFT JOIN papers
	ON students.id = papers.student_id;
    
-- Print first_name, title, grade and students who did not write any paper
-- but if title IS NULL then set MISSING, if grade is NULL then 0
SELECT first_name, IFNULL(title, 'MISSING') AS title, IFNULL(grade, 0) AS grade
FROM students
LEFT JOIN papers
	ON students.id = papers.student_id;

-- for each student print his or her average grade, order by average
SELECT first_name, AVG(IFNULL(grade, 0)) AS average
FROM students
LEFT JOIN papers
	ON students.id = papers.student_id
GROUP BY first_name
ORDER BY average DESC;

-- same as above, but add column passing_status, PASSING if avg >= 70 else FAILING
SELECT first_name, AVG(IFNULL(grade, 0)) AS average,
        CASE
			WHEN AVG(IFNULL(grade, 0)) >= 70 THEN 'PASSING'
            ELSE 'FAILING'
		END AS passing_status
FROM students
LEFT JOIN papers
	ON students.id = papers.student_id
GROUP BY first_name
ORDER BY average DESC;