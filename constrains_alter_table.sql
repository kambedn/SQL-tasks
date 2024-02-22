-- Constrains 
-- UNIQUE - enforcing uniqueness of a certain column
-- PRIMARY KEY has to be unique, we don't have to specify it
CREATE TABLE contacts (
	name VARCHAR(120) NOT NULL,
    phone VARCHAR(9) NOT NULL UNIQUE
);

-- if we execute it twice, the second time it will raise an error duplicate entry
INSERT INTO contacts (name, phone)
VALUES ('Billy', '123456789'); 

SELECT * FROM contacts;

INSERT INTO contacts (name, phone)
VALUES ('Billy', '123456781'); 

DROP TABLE contacts;

-- CHECK - making sure that a value meets some requirements
CREATE TABLE parties(
	name VARCHAR(50),
    age INT CHECK (age > 18) -- if the condition is False, then we get an error
);

INSERT INTO parties(name, age)
VALUES ('Billy', 19);

INSERT INTO parties(name, age)
VALUES ('Jack', 2); -- error, check constraint is violated

DROP TABLE parties;

CREATE TABLE palindromes(
	word VARCHAR(100) CHECK( word = REVERSE(word))
);
INSERT INTO palindromes VALUES ('kajak'); -- ok
INSERT INTO palindromes VALUES ('art'); -- error, check constraint palindrome_chk_1 is violated

DROP TABLE palindromes;

-- We can name constraints, it gives more information, easier to work with
CREATE TABLE users(
	name VARCHAR(50),
    age INT,
    CONSTRAINT age_over_18 CHECK (age > 18)
);

INSERT INTO users(name, age)
VALUES ('Billy', 19);

INSERT INTO users(name, age)
VALUES ('Jack', 2); -- error, check constraintage_over_18  is violated

DROP TABLE users;

CREATE TABLE palindromes2(
	word VARCHAR(100),
    CONSTRAINT word_is_palindrome CHECK(word = REVERSE(word))
);
INSERT INTO palindromes2 VALUES ('kajak'); -- ok
INSERT INTO palindromes2 VALUES ('art'); -- error, check constraint word_is_palindrome is violated

DROP TABLE palindromes2;

-- Multi-Column Checks
-- Here the comination of name and address must be unique
CREATE TABLE companies (
	name VARCHAR(255) NOT NULL,
    address VARCHAR(255) NOT NULL,
    CONSTRAINT name_address UNIQUE(name, address)
);

INSERT INTO companies (name, address)
VALUES ('blackbird', '123 spruce'); -- ok

INSERT INTO companies (name, address)
VALUES ('luigis', '123 spruce'); -- ok

INSERT INTO companies (name, address)
VALUES ('blackbird', '123 spruce'); -- error, duplicated entry

CREATE TABLE houses (
	purchase_price INT NOT NULL,
    sale_price INT NOT NULL,
    CONSTRAINT price_valid CHECK( purchase_price < sale_price)
);

INSERT INTO houses (purchase_price, sale_price)
VALUES (100, 150); -- ok

INSERT INTO houses (purchase_price, sale_price)
VALUES (160, 150); -- error, check constraint price_valid is violated

-- ALTER TABLE - changing a table
-- It has many options
-- https://dev.mysql.com/doc/refman/8.0/en/alter-table.html
DESC companies;

-- Adding columns
-- if NOT NULL is specified, a default value will be added
-- 0 for numbers, empty string for text
-- we can also add a default value
ALTER TABLE companies
ADD COLUMN city VARCHAR(20) NOT NULL DEFAULT 'a'; -- COLUMN is optional, we can also add column constriants

SELECT * FROM companies;
DESC companies;

-- Droping columns
ALTER TABLE companies
DROP COLUMN city; -- COLUMN is optional

DESC companies;

-- Renaming tables
RENAME TABLE companies TO suppliers;
SELECT * FROM suppliers;

ALTER TABLE suppliers
RENAME TO companies;

SELECT * FROM suppliers;
SELECT * FROM companies;

-- Renaiming columns
DESC companies;

ALTER TABLE companies
RENAME COLUMN name TO company_name;

DESC companies;

-- Modyfing columns
-- Be conscious of datatype conversion
DESC houses;

-- this statement removes e.g. NOT NULL if it was set previously
ALTER TABLE houses
MODIFY purchase_price DECIMAL(8,2) DEFAULT 0;

DESC houses;

-- Renaming and modyfing columns
ALTER TABLE houses
ADD COLUMN area TINYINT UNSIGNED NOT NULL;

DESC houses;

ALTER TABLE houses
CHANGE area house_area DECIMAL(5,2) DEFAULT 10.99;

DESC houses;

-- Altering constraints
ALTER TABLE houses
ADD CONSTRAINT positive_pprice CHECK (purchase_price > 0);

INSERT INTO houses (purchase_price, sale_price)
VALUES (-1, 4); -- error check constraint positive_pprice is violated

ALTER TABLE houses
DROP CONSTRAINT positive_pprice;

INSERT INTO houses (purchase_price, sale_price)
VALUES (-1, 4); -- error check constraint positive_pprice is violated

SELECT * FROM houses;

DROP TABLE houses;
DROP TABLE companies;