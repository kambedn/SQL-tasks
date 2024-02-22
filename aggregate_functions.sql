-- Aggregate functions
-- COUNT returns the number of rows
SELECT COUNT(*) FROM books; -- returns the number of rows in our table

-- Counts every value that is present in column author_fname
INSERT INTO books () VALUES (); -- adding NULL - 21 rows in total
SELECT COUNT(author_fname) FROM books; -- returns 19, it does not count NULLs

SELECT COUNT(DISTINCT author_fname) FROM books;

SELECT COUNT(DISTINCT released_year) FROM books;

-- How many titles contain "the"?
SELECT COUNT(*) AS titles_with_the
FROM books
WHERE title LIKE '%the%';

SELECT DISTINCT title FROM books;

-- GROUP BY
-- It summarizes or aggregates identical data into single rows
SELECT author_lname FROM books
GROUP BY author_lname;

-- COUNT how many books each author has written
-- counting records for each group
SELECT author_lname, COUNT(title) AS books_written
FROM books
GROUP BY author_lname
ORDER BY books_written DESC;

-- COUNT books by realeased year
-- we cannot select a column that is not used in GROUP BY
-- and any aggregate function is not performed on.
SELECT released_year, COUNT(title) AS books_released -- we cannot select title - error
FROM books
GROUP BY released_year
ORDER BY books_released DESC;

-- MIN and MAX
-- return minimum and maximum value respectively
-- work both with numbers and text
SELECT MIN(released_year) AS min_year, MAX(released_year) AS max_year
FROM books;

-- What if I want the title of the longest book?
-- We can use ORDER BY pages DESC and LIMIT 1
SELECT 
    title, pages
FROM
    books
ORDER BY pages DESC
LIMIT 1;
SELECT MAX(pages) FROM books;

-- We can also use subquery
-- Subquery is a query inside another query, it is in ()
-- If there are many rows containing the maximum value
-- The solution with subquery will return all these records
-- and the one with ORDER BY and LIMIT will return only one.
SELECT 
    title, pages
FROM
    books
WHERE
    pages = (SELECT 
            MAX(pages)
        FROM
            books);
            
-- Find the book that was realeased the earliest
SELECT 
    title, released_year
FROM
    books
WHERE
    released_year = (SELECT 
            MIN(released_year)
        FROM
            books);
            
-- We can GROUP BY multiple columns
SELECT author_lname, author_fname, COUNT(title) AS books_written
FROM books
GROUP BY author_lname, author_fname
ORDER BY books_written DESC;

-- In MySQL we can use aliases from SELECT in GROUP BY
SELECT CONCAT(author_fname, ' ', author_lname) AS author, COUNT(title) AS books_written
FROM books
GROUP BY author;

-- Find the year each author published their first book, 
-- their latest book and count how many books they have written
SELECT 
    CONCAT(author_fname, ' ', author_lname) AS author,
    MIN(released_year) AS earliest_release,
    MAX(released_year) AS latest_release,
    COUNT(title) AS books_written
FROM
    books
GROUP BY author;

SELECT CONCAT(author_fname, ' ', author_lname) AS author, MAX(pages) AS max_pages
FROM books
GROUP BY author;

-- SUM
-- sums values together
SELECT SUM(pages) AS all_pages FROM books;

-- Sum pages by authors
SELECT author_lname, author_fname, SUM(pages) AS pages_written
FROM books
GROUP by author_lname, author_fname
ORDER BY pages_written DESC;

-- AVG
-- calculates the average
SELECT AVG(released_year) FROM books;
SELECT AVG(pages) FROM books;

-- Calculate the average stock quantity for books released in the same year
SELECT released_year, ROUND(AVG(stock_quantity), 0) AS avg_stock
FROM books
GROUP BY released_year;

-- STD
-- calculates the standard deviation
SELECT STD(pages) FROM books;

-- Print the number of books in the database
SELECT COUNT(title) AS number_of_books FROM books;

-- Print out how many books were released in each year
SELECT released_year, COUNT(title) AS books_released
FROM books
GROUP BY released_year;

-- Print out the total number of books in stock
SELECT SUM(stock_quantity) AS books_in_stock FROM books;

-- Find the average released_year for each author
SELECT 
    CONCAT(author_fname, ' ', author_lname) AS author,
    AVG(released_year) AS average_release_year
FROM
    books
GROUP BY author;

-- Find the full name of the author who wrote the longest book
SELECT CONCAT(author_fname, ' ', author_lname) AS author
FROM books
WHERE pages = (SELECT MAX(pages) FROM books);

-- For reach released_year print the number of books and the average number of pages, order by year
SELECT released_year AS year, 
		COUNT(title) AS '#_books', 
        AVG(pages) AS avg_pages
FROM books
GROUP BY year
ORDER BY year;