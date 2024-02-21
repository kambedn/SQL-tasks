-- Refining Selections
-- DISTINCT - selecting only distinct data
SELECT DISTINCT author_lname FROM books;

SELECT released_year FROM books; -- 19 rows returned
SELECT DISTINCT released_year FROM books; -- 16 rows returned

-- The query below returns unique combinations of first and last name.
SELECT DISTINCT author_fname, author_lname FROM books; 

-- ORDER BY - sorting results
-- it sorts in ASCENDING order by default
-- to change that use DESC after the column name
-- we can sort results by column that is not selected
SELECT book_id, author_fname, author_lname
FROM books
ORDER BY author_lname;

SELECT book_id, author_fname, author_lname
FROM books
ORDER BY author_lname DESC;

-- syntax below means sort our results in descending order by the 2nd column that we select
SELECT book_id, author_fname, author_lname, pages
FROM books
ORDER BY 2 DESC;

-- We can order by multiple columns
SELECT author_lname, released_year, title 
FROM books
ORDER BY author_lname, released_year DESC;

-- We can use aliases in ORDER BY
SELECT DISTINCT CONCAT_WS(' ', author_lname, author_fname) AS author
FROM books
ORDER BY author;

-- LIMIT
-- control the number of results we get back
-- SELECT <col> FROM <table> LIMIT <number_of_results_we_get_back>;
SELECT title, released_year
FROM books
ORDER BY released_year
LIMIT 5; -- only 5 rows

-- We can also select a subset in the middle of our data
-- LIMIT <starting_row>, <count> - does not include starting_row
SELECT title, released_year
FROM books
ORDER BY released_year
LIMIT 2, 3; -- select the next 3 rows after the 2nd row (without the 2nd row) 

-- LIKE
-- Better searching/pattern searching
-- % - zero or more characters
-- _ - exactly one character
SELECT title, author_fname, author_lname
FROM books
WHERE author_fname LIKE '%da%';

SELECT title, author_fname, author_lname
FROM books
WHERE title LIKE '%:%';

-- 4-character first names
SELECT * FROM books WHERE author_fname LIKE '____';

-- use backslash \ to escape wildcards
-- searching for a title with % in it
SELECT title FROM books WHERE title LIKE '%\%%';

-- Tasks
-- Select all story collections (titles that contain 'stories')
SELECT title FROM books
WHERE title LIKE '%stories%';

-- Find the longest book
SELECT title, pages
FROM books
ORDER BY pages DESC
LIMIT 1;

-- Print a summary containing the title and year, for the 3 most recent books
-- title - realeased_year
SELECT CONCAT(title, ' - ', released_year) AS summary
FROM books
ORDER BY released_year DESC
LIMIT 3;

-- Find all books with an author_lname that contains a space
SELECT title, author_lname
FROM books
WHERE author_lname LIKE "% %";

-- Find the 3 books with the lowest stock
-- select title, year and stock
SELECT title, released_year, stock_quantity
FROM books
ORDER BY stock_quantity
LIMIT 3;

-- Print title and author_lname, sorted first by author_lname and then by title
SELECT title, author_lname
FROM books
ORDER BY author_lname, title;

-- print 'MY FAVOURITE AUTHOR IS {author full name}' for each author, sorted alphabetically by last name
SELECT UCASE(CONCAT('MY FAVOURITE AUTHOR IS ', author_fname, ' ', author_lname,'!')) AS yell
FROM books
ORDER BY author_lname;