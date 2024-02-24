-- MANY:MANY
-- still very common but not as 1:MANY
-- Examples:
-- Books <--> Authors
-- Blog Posts <--> Tags
-- Students <--> Classes

-- Case: TV show reviewing application
-- Series Data <--> Reviewers Data
-- they are connected through reviews data
-- Series Data ---< Reviews Data >--- Reviewers Data

CREATE DATABASE reviews_app;
USE reviews_app;

CREATE TABLE reviewers(
	id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(40) NOT NULL
);

CREATE TABLE series(
	id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL,
    released_year YEAR NOT NULL,
    genre VARCHAR(30) NOT NULL,
    CONSTRAINT genre_valid CHECK (genre IN ('Animation', 'Comedy', 'Drama'))
);

CREATE TABLE reviews(
	id INT PRIMARY KEY AUTO_INCREMENT,
    rating DECIMAL(3,1) NOT NULL,
    series_id INT NOT NULL,
    reviewer_id INT NOT NULL,
    FOREIGN KEY (series_id) REFERENCES series(id) ON DELETE CASCADE,
    FOREIGN KEY (reviewer_id) REFERENCES reviewers(id) ON DELETE CASCADE,
    CONSTRAINT rating_valid CHECK (rating BETWEEN 0 AND 10)
);

INSERT INTO series (title, released_year, genre) VALUES
    ('Archer', 2009, 'Animation'),
    ('Arrested Development', 2003, 'Comedy'),
    ("Bob's Burgers", 2011, 'Animation'),
    ('Bojack Horseman', 2014, 'Animation'),
    ("Breaking Bad", 2008, 'Drama'),
    ('Curb Your Enthusiasm', 2000, 'Comedy'),
    ("Fargo", 2014, 'Drama'),
    ('Freaks and Geeks', 1999, 'Comedy'),
    ('General Hospital', 1963, 'Drama'),
    ('Halt and Catch Fire', 2014, 'Drama'),
    ('Malcolm In The Middle', 2000, 'Comedy'),
    ('Pushing Daisies', 2007, 'Comedy'),
    ('Seinfeld', 1989, 'Comedy'),
    ('Stranger Things', 2016, 'Drama');
 
 
INSERT INTO reviewers (first_name, last_name) VALUES
    ('Thomas', 'Stoneman'),
    ('Wyatt', 'Skaggs'),
    ('Kimbra', 'Masters'),
    ('Domingo', 'Cortes'),
    ('Colt', 'Steele'),
    ('Pinkie', 'Petit'),
    ('Marlon', 'Crafford');
    
 
INSERT INTO reviews(series_id, reviewer_id, rating) VALUES
    (1,1,8.0),(1,2,7.5),(1,3,8.5),(1,4,7.7),(1,5,8.9),
    (2,1,8.1),(2,4,6.0),(2,3,8.0),(2,6,8.4),(2,5,9.9),
    (3,1,7.0),(3,6,7.5),(3,4,8.0),(3,3,7.1),(3,5,8.0),
    (4,1,7.5),(4,3,7.8),(4,4,8.3),(4,2,7.6),(4,5,8.5),
    (5,1,9.5),(5,3,9.0),(5,4,9.1),(5,2,9.3),(5,5,9.9),
    (6,2,6.5),(6,3,7.8),(6,4,8.8),(6,2,8.4),(6,5,9.1),
    (7,2,9.1),(7,5,9.7),
    (8,4,8.5),(8,2,7.8),(8,6,8.8),(8,5,9.3),
    (9,2,5.5),(9,3,6.8),(9,4,5.8),(9,6,4.3),(9,5,4.5),
    (10,5,9.9),
    (13,3,8.0),(13,4,7.2),
    (14,2,8.5),(14,3,8.9),(14,4,8.9);
    
SELECT * FROM reviewers;
SELECT * FROM series;
SELECT * FROM reviews;

-- Print title and rating for every review
SELECT title, rating 
FROM series
JOIN reviews
	ON series.id = reviews.series_id;
    
-- Print avg rating for each title
SELECT title, ROUND(AVG(rating),1) AS avg_rating
FROM series
JOIN reviews
	ON series.id = reviews.series_id
GROUP BY title
ORDER BY avg_rating DESC;

-- for each review print first_name, last_name and rating
SELECT first_name, last_name, rating
FROM reviewers
JOIN reviews
	ON reviewers.id = reviews.reviewer_id;
    
-- Print series that have no reviews
SELECT title AS unreviewed_series
FROM series
LEFT JOIN reviews
	ON series.id = reviews.series_id
WHERE rating IS NULL;

-- Print avg rating for each genre
SELECT genre, ROUND(AVG(rating), 1) AS avg_rating
FROM series
JOIN reviews
	ON series.id = reviews.series_id
GROUP BY genre
ORDER BY avg_rating DESC;

-- for each user print first_name, last_name
-- count his or her reiviews, min, max and avg rating
-- and status: if count != ACTIVE else INACTIVE
SELECT first_name,
		last_name,
		COUNT(rating) AS 'COUNT',
        IFNULL(MIN(rating), 0.0) AS 'MIN',
        IFNULL(MAX(rating), 0.0) AS 'MAX',
        IFNULL(ROUND(AVG(rating), 1), 0.0) AS 'AVG',
        CASE
			WHEN COUNT(rating) = 0 THEN 'INACTIVE'
            ELSE 'ACTIVE'
		END AS STATUS
FROM reviewers
LEFT JOIN reviews
	ON reviewers.id = reviews.reviewer_id
GROUP BY first_name, last_name
ORDER BY COUNT DESC;

-- IF(COUNT(rating) > 0, 'ACTIVE', 'INACTIVE') AS STATUS

-- For each review print title, rating and reviewer (full name)
SELECT title, rating, CONCAT(first_name, ' ', last_name) AS reviewer
FROM series
JOIN reviews
	ON series.id = reviews.series_id
JOIN reviewers
	ON reviews.reviewer_id = reviewers.id;