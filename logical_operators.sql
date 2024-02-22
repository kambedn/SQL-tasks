-- Logical Operators
-- != not equal

-- Select all books which were not released in 2017
SELECT * FROM books WHERE released_year != 2017;

-- Select all books not written by Gaiman
SELECT * FROM books WHERE author_lname != 'Gaiman';

-- = equal
-- Select all books which were released in 2017
SELECT * FROM books WHERE released_year = 2017;

-- NOT LIKE - does not match pattern
-- Select all books which title does not have any spaces
SELECT title FROM books
WHERE title NOT LIKE '% %';

SELECT title, author_fname, author_lname
FROM books
WHERE author_fname NOT LIKE 'da%';

SELECT title FROM books WHERE title NOT LIKE '%e%';

--  > GREATER THAN
--  < LESS THAN
SELECT * FROM books WHERE released_year > 2000;

SELECT * FROM books WHERE pages < 400;

SELECT 99 > 1; -- True, it will return 1
SELECT 0 = 1; -- False, it will return 0
SELECT 1 > NULL; -- it will return NULL

-- >= GREATER THAN OR EQUAL TO
-- <= GREATER THAN OR EQUAL TO
SELECT title, pages FROM books WHERE pages <= 198;

SELECT title, released_year FROM books
WHERE released_year >= 2010
ORDER BY released_year DESC;

SELECT title, released_year FROM books
WHERE released_year <= 2012
ORDER BY released_year DESC;

-- AND - True if all statments are true
-- Select books written by Dave Eggers, published after the year 2010 with 'novel' in the title
SELECT title, author_lname, author_fname, released_year
FROM books
WHERE author_lname = 'Eggers' AND
		author_fname = 'Dave' AND
        released_year > 2010 AND
        title LIKE '%novel%';
        
SELECT 1 = 0 AND 2 > 1;

-- Select all books which title has at least 15 characters and at least 400 pages
SELECT title, pages
FROM books
WHERE CHAR_LENGTH(title) >= 15 AND
		pages >= 400;
        
-- OR
-- True if at least one statement is True
SELECT title, pages
FROM books
WHERE CHAR_LENGTH(title) >= 15 OR
		pages >= 400;
        
-- Select books with less than 250 pages or stories collections
SELECT title, pages
FROM books
WHERE title LIKE '%stories%' OR
		pages < 250;
        
-- BETWEEN - inclusive on both ends
SELECT title, released_year FROM books
WHERE released_year BETWEEN 2004 AND 2015;

SELECT title, pages FROM books
WHERE pages BETWEEN 200 AND 300;

-- NOT BETWEEN - inclusive on both ends
SELECT title, pages FROM books
WHERE pages NOT BETWEEN 200 AND 300;

-- Comparing Dates/Times
-- we can use less/greater than operators
SELECT CAST('2002-10-10' AS DATE) < CURDATE(); -- returns 1

-- We can use CAST(val AS <datatype>) to produce a result value of a <datatype>
SELECT CAST('9:00:10' AS TIME) > CURTIME(); -- returns 0

-- IN - True if a value is in a specified set of values
SELECT title, author_lname
FROM books
WHERE author_lname IN ('Carver', 'Lahiri', 'Smith');

-- NOT IN - True if a value is not in a specified set of values
SELECT title, author_lname
FROM books
WHERE author_lname NOT IN ('Carver', 'Lahiri', 'Smith');

-- % - modulo
-- Select all books released in odd years
SELECT title, released_year
FROM books
WHERE released_year % 2 = 1
ORDER BY released_year;

-- CASE statements
-- are used to make decisions about the output values
SELECT title, released_year,
	CASE
		WHEN released_year >= 2000 THEN 'Modern Lit'
        ELSE '20th century Lit' 
	END AS genre
FROM books;

SELECT title, stock_quantity,
	CASE
		WHEN stock_quantity <= 50 THEN '*'
        WHEN stock_quantity <= 100 THEN '**'
        ELSE '***'
    END AS stock
FROM books
ORDER BY stock DESC, stock_quantity DESC;

-- IS NULL - True if a value is NULL
SELECT * FROM books WHERE author_lname = NULL; -- does not work
SELECT * FROM books WHERE author_lname IS NULL;
SELECT * FROM books WHERE author_lname IS NOT NULL;
DELETE FROM books WHERE title IS NULL;

-- Select all books written before 1980
SELECT title, released_year
FROM books
WHERE released_year < 1980;
SELECT * FROM books;

-- Select all books written by Eggers or Chabon
SELECT title, author_lname
FROM books
WHERE author_lname IN ('Eggers', 'Chabon');

-- Select all books written by Lahiri, published after 2000
SELECT title, author_lname, released_year
FROM books
WHERE author_lname = 'Lahiri' AND
		released_year > 2000;
        
-- Select all books with page counts between 100 and 200
SELECT title, pages
FROM books
WHERE pages BETWEEN 100 AND 200;

-- Select all books where author_lname starts with a 'C' or an 'S'
SELECT title, author_lname
FROM books
WHERE SUBSTR(author_lname, 1, 1) IN ('C', 'S');
        
-- Select title, author_lname and type, where type:
-- if title contains 'stories' -> Short Stories
-- 'Just Kids' and 'A Heartbreaking Work' -> Memoir
-- everything else -> Novel
SELECT 
    title,
    author_lname,
    CASE
        WHEN title LIKE '%stories%' THEN 'Short Stories'
        WHEN title IN ('Just Kids' , 'A Heartbreaking Work') THEN 'Memoir'
        ELSE 'Novel'
    END AS type
FROM
    books;

-- Select author_fname, author_lname and count, where count is
-- <books written by an author> book(s)
SELECT 
    author_fname,
    author_lname,
    CONCAT(COUNT(title),
            ' ',
            CASE
                WHEN COUNT(title) = 1 THEN 'book'
                ELSE 'books'
            END) AS books_count
FROM
    books
WHERE
    author_lname IS NOT NULL
GROUP BY author_fname , author_lname;