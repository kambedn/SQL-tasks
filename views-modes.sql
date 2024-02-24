-- Views
-- Views are stored queries that wehn invoked produce a result set
-- A view acts as a virtual table.
USE reviews_app;

SELECT title, released_year, genre, rating, first_name, last_name
FROM reviews
JOIN series 
	ON series.id = reviews.series_id
JOIN reviewers
	ON reviewers.id = reviews.reviewer_id;

CREATE VIEW full_reviews AS
SELECT title, released_year, genre, rating, first_name, last_name
FROM reviews
JOIN series 
	ON series.id = reviews.series_id
JOIN reviewers
	ON reviewers.id = reviews.reviewer_id;
    
SHOW TABLES; -- full_reviews is here
SELECT * FROM full_reviews;

SELECT * FROM full_reviews
WHERE genre = 'Animation';

SELECT genre, AVG(rating) AS avg_rating
FROM full_reviews
GROUP BY genre;

-- Only small portion of views are updatable and insertable
-- full_reviews is not updatable

-- but this one is
CREATE VIEW ordered_series AS
SELECT * FROM series ORDER BY released_year;

SELECT * FROM ordered_series;
INSERT INTO ordered_series(title, released_year, genre)
VALUES ('The Great', 2020, 'Comedy'); -- ok

SELECT * FROM series; -- the row is also inserted into series

DELETE FROM ordered_series WHERE title = 'The Great'; -- ok

-- Altering/Replacing Views
CREATE OR REPLACE VIEW ordered_series AS
SELECT * FROM series ORDER BY released_year DESC;

SELECT * FROM ordered_series;

ALTER VIEW ordered_series AS
SELECT * FROM series ORDER BY released_year;

SELECT * FROM ordered_series;

-- Droping a view
DROP VIEW ordered_series; -- does not delete the data, only the view


-- HAVING - filtering groups
-- We want to select only these titles that have more than one review
SELECT title, AVG(rating) AS avg_rating FROM full_reviews
GROUP BY title HAVING COUNT(rating) > 1;

-- Select only these reviewers who avg_rating is more than 8
SELECT CONCAT(first_name, ' ', last_name) AS reviewer,
	AVG(rating) AS avg_rating
FROM full_reviews
GROUP BY reviewer HAVING avg_rating > 8;

-- WITH ROLLUP
SELECT title, AVG(rating) FROM full_reviews
GROUP BY title WITH ROLLUP; 
-- at the end of the result table we have 
-- NULL - 8.02553 - it is the average rating for the whole table

SELECT title, COUNT(rating) FROM full_reviews
GROUP BY title WITH ROLLUP; -- in the last row we have count of all ratings

-- if we group by two things we get two level statistics
-- we get an average for each released_year
-- and at the end we get an average for all ratings
SELECT released_year, genre, AVG(rating) AS avg_rating
FROM full_reviews
GROUP BY released_year, genre WITH ROLLUP;


-- MODES
-- Setting that we can turn on/off to change the behavior and the validations of MySQL
-- Viewing Modes
SELECT @@GLOBAL.sql_mode; -- global settings
SELECT @@SESSION.sql_mode; -- for the current session

-- SET GLOBAL sql_mode = 'modes'; -- global modes
-- SET SESSION sql_mode = 'modes';
SELECT 3/0;
SHOW WARNINGS; -- warning by default

-- we disable ERROR_FOR_DIVISION_BY_ZERO
SET SESSION sql_mode = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION';

SELECT 3/0;
SHOW WARNINGS; -- no warning now

-- STRICT_TRANS_TABLES - enabled by default
-- Strict mode controls how MySQL handles invalid or missing values in data-change statements
-- such as INSERT or UPDATE
-- If we disable strict mode, then when we try to insert a string to a numeric column
-- we get only a warning and 0 is set as the value

-- ONLY_FULL_GROUP_BY
-- it allows to only select columns that are used in GROUP BY statement
-- or in aggregate function
SELECT title, AVG(rating) FROM series
JOIN reviews ON reviews.series_id = series.id
GROUP BY title;

-- NO_ZERO_IN_DATE, NO_ZERO_DATE
-- we can't use e.g. '2010-00-01', '2010-10-00', '0000-00-00'

-- mysql -u root -p  -- to log in from terminal