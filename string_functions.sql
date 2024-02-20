-- STRING FUNCTION
-- CONCAT - combine data for cleaner output
-- CONCAT(x,y,z,...)
SELECT CONCAT('h', 'e', 'l');

SELECT CONCAT(author_fname, ' ', author_lname) AS author_full_name
FROM books;

-- CONCAT_WS - CONCAT with seperator
-- CONCAT_WS('<seperator>', x,y,z,..)
SELECT CONCAT_WS('!', 'x', 'y','z');

SELECT CONCAT_WS(' ', author_fname, author_lname)
FROM books;

-- SUBSTRING - returns a smaller piece out of a larger string
-- SUBSTRING('<string>', starting_position, length_of_substring)
-- SUBSTRING('Hello', 1, 4) returns 'Hell'
-- if we don't provide the length_of_substring then it will go to the end
-- SUBSTRING('Hello World!', 7) returns 'World!'
SELECT SUBSTRING('Hello World!', 7);
-- we can also use negative indexing like in python
SELECT SUBSTRING('Hello World!', -5); -- returns 'orld!'
-- SUBSTR = SUBSTRING
SELECT SUBSTR(title, 1, 15)
FROM books;

SELECT SUBSTR(author_fname, 1, 1) AS initial, author_lname
FROM books;

-- combining CONCAT and SUBSTR
SELECT CONCAT(SUBSTR(title, 1, 10), '...') AS short_title
FROM books; 

SELECT 
    CONCAT(SUBSTR(author_fname, 1, 1),
            '.',
            SUBSTR(author_lname, 1, 1),
            '.') AS author_initials
FROM
    books;
    
-- REPLACE - replacing parts of strings (in output)
-- REPLACE(str, from_str, to_str) case-sensitive!!!
SELECT REPLACE(title, ' ', '-')
FROM books;

-- REVERSE - returns a reversed string
SELECT REVERSE(title) FROM books;

SELECT CONCAT(author_fname, REVERSE(author_fname))
FROM books;

-- CHAR_LENGTH - returns number of characters in a given string
-- LENGTH - returns lenght of a string measured in bytes!!
SELECT CHAR_LENGTH(title) AS title_length, title
FROM books;

-- UPPER and LOWER - change casing of a given string
-- UCASE = UPPER, LCASE = LOWER
SELECT UPPER(title) FROM books;

-- 'I LOVE <title-upper> !!!'
SELECT CONCAT_WS(' ', 'I LOVE', UPPER(title), '!!!') AS opinion
FROM books;

-- LEFT(str, len)
-- Returns the leftmost len characters from the string str, or NULL if any argument is NULLL
-- RIGHT(str, len)
-- Returns the rightmost len characters from the string str, or NULL if any argument is NULL.
SELECT CONCAT(LEFT(author_fname, 1), '.', LEFT(author_lname, 1), '.') AS author_initials
FROM books;

-- INSERT(str,pos,len,newstr)
-- Returns the string str, with the substring beginning at position 
-- pos and len characters long replaced by the string newstr
SELECT INSERT('Hello Bobby', 6, 0, ' There'); 
SELECT INSERT('Hello Bobby', 6, 2, ' There'); 
SELECT INSERT('World', 1, 2, 'Temp');

-- REPEAT(str,count)
-- Returns a string consisting of the string str repeated count times. 
-- If count is less than 1, returns an empty string. Returns NULL if str or count is NULL
SELECT REPEAT('ha', 6);

-- TRIM([{BOTH | LEADING | TRAILING} [remstr] FROM] str), TRIM([remstr FROM] str)
-- Returns the string str with all remstr prefixes or suffixes removed. If none of the specifiers BOTH, 
-- LEADING, or TRAILING is given, BOTH is assumed. remstr is optional and, if not specified, 
-- spaces are removed.
SELECT TRIM('    text  '); -- trimming leading and trailing spaces
SELECT TRIM(LEADING 'x' FROM 'xxxbarxxx'); -- trimming leading 'x'
SELECT TRIM(BOTH 'x' FROM 'xxxbarxxx'); -- trimming both leading and trailing 'x'
SELECT TRIM(TRAILING 'xyz' FROM 'barxxyz'); -- trimming trailing 'xyz'

-- Reverse and Uppercase the sentence
-- Why does my cat look at me with such hatred?
SELECT REVERSE(UCASE('Why does my cat look at me with such hatred?'));

-- Replace spaces in titles with '->'
SELECT REPLACE(title, ' ', '->') AS title
FROM books;

-- Select lasts name of the authors and the backwards of them
SELECT author_lname AS forwards, REVERSE(author_lname) AS backwards
FROM books;

-- Select authors' full names in uppercase
SELECT UCASE(CONCAT_WS(' ', author_fname, author_lname)) AS full_name_in_caps
FROM books;

-- title + was released in + year of publication
SELECT CONCAT_WS(' ', title, 'was released in', released_year) AS blurb
FROM books;

-- Print book titles and the length of each title
SELECT title, CHAR_LENGTH(title) AS character_count
FROM books;

-- Print 
-- short title (10 characters of the title + '...'
-- author as: <last_name>,<first_name>
-- quantity: <quantity> in stock
SELECT 
    CONCAT(LEFT(title, 10), '...') AS short_title,
    CONCAT_WS(',', author_lname, author_fname) AS author,
    CONCAT(stock_quantity, ' in stock') AS quantity
FROM
    books;
