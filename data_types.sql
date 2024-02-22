-- More about data types
-- Documentation:
-- https://dev.mysql.com/doc/refman/8.0/en/data-types.html

-- Text storage
-- VARCHAR
-- allows us to specify maximum length
-- it is optimized to store texts of various sizes
-- more flexible
-- error when a string exceeds the limit (standard)

-- CHAR
-- has a fixed length passed while creating a table
-- each string will be stored using this fixed length
-- we can store something smaller than this length, but white spaces will be added to it on the right
-- when CHAR values are tetrieved, trailing spaces are removed
-- the length can be any value from 0 to 255
-- faster for fixed length text (e.g. flags (Y/N), abbreviations, zip codes)
-- error when a string exceeds the limit (standard)

-- 'o' takes 4 bytes here
-- but if the colum abbr was of type VARCHAR(4) it would take only 2
CREATE TABLE tab1(
	abbr CHAR(4)
);
INSERT INTO tab1(abbr) VALUES ('CAAA'), ('NYWW'), ('MI'), ('o');
SELECT * FROM tab1;
DROP TABLE tab1;


-- Numbers storage
-- WHOLE NUMBERS
-- INT/Integer - 4 bytes, max signed value is 2^31-1
-- TINYINT - 1 byte, max signed value 127 (2^7-1)
-- BIGINT - 8 bytes, max signed value is 2^63-1
-- We can enforce only using unsigned values by using UNSIGNED 
-- floating values will be rounded while inserting
CREATE TABLE tab2(
	col1 TINYINT UNSIGNED
);
INSERT INTO tab2 VALUES (1), (255);
INSERT INTO tab2 VALUES (-1); -- error
DROP TABLE tab2;

-- DECIMAL NUMBERS
-- DECIMAL(m,n) - the most precise, m is the total number of digits for a given number
-- n is the number of digits after decimal
-- DECIMAL(5,2) - 5 digits, 2 after decimal, max number is 999.99
CREATE TABLE products (price DECIMAL(5,2));
INSERT INTO products (price) VALUES (4.50); -- ok
INSERT INTO products (price) VALUES (456.99); -- ok
INSERT INTO products (price) VALUES (5091.1); -- error, only 5-2=3 before the decimal
INSERT INTO products (price) VALUES (5.026); -- warning, the values gets truncated
SHOW WARNINGS; 
SELECT * FROM products;
DROP TABLE products;

-- FLOAT and DOUBLE
-- storing larger numbers using less space but it comes at the cost of precision
-- FLOAT - 4 bytes - precision issues are present after approx. 7 digits
-- DOUBLE - 8 bytes - precision issues are presnt after approx. 15 digits
CREATE TABLE nums( x FLOAT, y DOUBLE);
INSERT INTO nums (x, y) VALUES (1.12345678, 1.12345678);
SELECT * FROM nums;
-- float is 1.12346, doulbe is 1.12345678
INSERT INTO nums (x, y) VALUES (1.12345678, 1.1234567856565656565656767);
SELECT * FROM nums; -- we lose precision even using DOUBLE
DROP TABLE nums;


-- Storing dates and times
-- DATE - values with a date but not time 'YYYY-MM-DD' format
-- TIME - values with a time but no date 'HH:MM:SS' format
-- DATETIME - values with a date and time 'YYYY-MM-DD HH:MM:SS' format
CREATE TABLE people(
	name VARCHAR(100),
    birthdate DATE,
    birthtime TIME,
    birthdt DATETIME
);
DESC people;

INSERT INTO people (name, birthdate, birthtime, birthdt)
VALUES 
	('Elton', '2000-12-25', '11:00:00', '2000-12-25 11:00:00'),
	('Lulu', '1985-04-11', '9:35:10', '1985-04-11 9:35:10'),
	('Juan', '2020-08-15', '23:59:00', '2020-08-15 23:59:00');

SELECT * FROM people;

-- CURTIME returns current time
SELECT CURTIME();
-- CURDATE returns current date
SELECT CURDATE();
-- NOW returns current date and time
SELECT NOW();

INSERT INTO people (name, birthdate, birthtime, birthdt)
VALUES ('Hazel', CURDATE(), CURTIME(), NOW());
SELECT * FROM people;

-- Date functions
-- DAY() - returns the day of the month of the date
SELECT birthdate, DAY(birthdate) FROM people;
-- DAYOFWEEK() - returns the day of the week 
SELECT birthdate, DAYOFWEEK(birthdate) FROM people;
-- DAYOFYEAR() - returns the day of the year
SELECT birthdate, DAYOFYEAR(birthdate) FROM people;
-- MONTHNAME() - returns the name of the month
SELECT birthdate, MONTHNAME(birthdate) FROM people;
-- YEAR() - returns the year
SELECT birthdt, YEAR(birthdt) FROM people; -- works okay

-- Time functions
-- HOUR() - returns the hour
SELECT name, birthtime, HOUR(birthtime) FROM people;
-- MINUTE() - returns the minutes
SELECT name, birthtime, MINUTE(birthtime) FROM people;
-- SECOND() - returns the seconds
SELECT name, birthdt, SECOND(birthdt) FROM people;

-- both and time functions work well with DATETIME 
-- we can use DATE() and TIME() functions to extract date/time from DATETIME type
SELECT birthdt, DATE(birthdt) FROM people;
SELECT birthdt, TIME(birthdt) FROM people;

-- Formatting dates
-- DATE_FORMAT(date, format)
-- https://dev.mysql.com/doc/refman/8.0/en/date-and-time-functions.html#function_date-format
SELECT birthdate, DATE_FORMAT(birthdate, '%a, %M %D') AS formatted_date FROM people;

SELECT birthdt, DATE_FORMAT(birthdt, 'Born on: %r') AS statement FROM people;

-- Date math
-- DATEDIFF(date1, date2) - calculates the date difference between date1 and date2 in days
-- works also with DATETIME
SELECT DATEDIFF(CURDATE(), birthdate) FROM people;

-- DATE_ADD/DATE_SUB - allows us to do date arithmetic with interval using INTERVAL
-- also works with DATETIME
SELECT DATE_ADD(CURDATE(), INTERVAL 1 YEAR);
SELECT DATE_ADD(CURDATE(), INTERVAL 2 MONTH);
SELECT DATE_SUB(CURDATE(), INTERVAL 10 YEAR);
SELECT birthdate, DATE_ADD(birthdate, INTERVAL 18 YEAR) AS voting_eligble_date FROM people;

-- For TIME we have TIMEDIFF
SELECT TIMEDIFF(CURTIME(), '09:17:10') AS time_not_in_bed;

-- We can also perform maths using + and - operators
SELECT NOW() - INTERVAL 18 YEAR;

SELECT name, birthdate, YEAR(birthdate + INTERVAL 21 YEAR) AS drinking_year_us FROM people;

-- TIMESTAMP
-- it combines date and time, looks exactly like DATETIME
-- it takes less storage than DATETIME, it supports smaller range of dates (1970-2038),
-- while DATETIME has range 1000-9999 [years A.C.]
-- TIMESTAMP is definetly better when e.g. saving update time on a webpage 
-- TIMESTAMPADD(), TIMESTAMPDIFF()

-- We can use CURRENT_TIMESTAMP to set column value on default
-- when a new row is added, its created_at value is current timestamp (date+time)
-- it also works with DATETIME
CREATE TABLE captions(
	text VARCHAR(150),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO captions(text) VALUES('aaaa');
INSERT INTO captions(text) VALUES('bbbb');
SELECT * FROM captions;

-- We can use ON UPDATE CURRENT_TIMESTAMP to automatically update timestamp each time
-- a value in a row is changed
CREATE TABLE captions2(
	text VARCHAR(150),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
INSERT INTO captions2(text) VALUES('aaaa');
INSERT INTO captions2(text) VALUES('bbbb');
SELECT * FROM captions2;
UPDATE captions2 SET text='ccc' WHERE text = 'aaaa';
SELECT * FROM captions2;

DROP TABLE captions;
DROP TABLE captions2;

-- Create a table inventory, that has fields item_name, price, quantity, price is always smaller
-- than a million
CREATE TABLE inventory(
	item_name VARCHAR(100) NOT NULL,
    price DECIMAL(8,2) NOT NULL,
    quantity INT UNSIGNED NOT NULL DEFAULT 0
);
DESC inventory;
DROP TABLE inventory;

-- Print out the current time
SELECT CURTIME();

-- Print out the current date
SELECT CURDATE();

-- Print out the current day of the week (the number)
SELECT DAYOFWEEK(CURDATE());

-- Print out the current day of the week (the day name)
SELECT DAYNAME(CURDATE());

-- Print out the current day and time using format mm/dd/yyyy
SELECT DATE_FORMAT(NOW(), '%m/%d/%Y') AS today;

-- Print out the current day and time using format 'January 2nd at 3:15'
SELECT DATE_FORMAT(NOW(), '%M %D at %k:%i') AS today;

-- Create a tweets table that stores
-- the tweet content, a username, time it was created
CREATE TABLE tweets(
	content VARCHAR(240) NOT NULL,
    username VARCHAR(30) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
DESC tweets;
DROP TABLE tweets;

DROP TABLE people;