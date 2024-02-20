-- CRUD exercise
-- Creating
CREATE DATABASE shirts_db;
USE shirts_db;
CREATE TABLE shirts
(
	shirt_id INT AUTO_INCREMENT,
    article VARCHAR(50) NOT NULL,
    color VARCHAR(50) NOT NULL,
    shirt_size VARCHAR(5) NOT NULL,
    last_worn INT NOT NULL DEFAULT 0,
    PRIMARY KEY (shirt_id)
);
DESC shirts;

INSERT INTO shirts (article, color, shirt_size, last_worn)
VALUES
	('t-shirt', 'white', 'S', 10),
	('t-shirt', 'green', 'S', 200),
	('polo shirt', 'black', 'M', 10),
	('tank top', 'blue', 'S', 50),
	('t-shirt', 'pink', 'S', 0),
	('polo shirt', 'red', 'M', 5),
	('tank top', 'white', 'S', 200),
	('tank top', 'blue', 'M', 15);
    
SELECT * FROM shirts;

-- Adding a new purple polo shirt, size M, last worn 50 days ago
INSERT INTO shirts (article, color, shirt_size, last_worn)
VALUES ('polo shirt', 'purple', 'M', 50);
SELECT * FROM shirts;

-- Reading
-- Select all shirts but only print out article nad color
SELECT article, color FROM shirts;

-- Select all medium shirts but print out everything but shirt_id
SELECT article, color, shirt_size, last_worn
FROM shirts
WHERE shirt_size = 'M';

-- Updating
-- Update all polo shirts by changing their size to L
UPDATE shirts SET shirt_size = 'L' WHERE article='polo shirt';
SELECT * FROM shirts WHERE shirt_size = 'L';

-- Update the shirt last worn 15 days ago by changing last_worn to 0
-- SELECT * FROM shirts WHERE last_worn = 15;
UPDATE shirts SET last_worn=0
WHERE last_worn=15;
SELECT * FROM shirts WHERE shirt_id = 8;

-- Update all white shirts by changing size to XS and color to 'off white'
-- SELECT * FROM shirts WHERE color='white';
UPDATE shirts SET shirt_size='XS', color='off white'
WHERE color='white';
SELECT * FROM shirts WHERE color='off white';

-- Delete
-- Delete all old shirts last worn 200 days ago
SELECT * FROM shirts WHERE last_worn=200;
DELETE FROM shirts WHERE last_worn=200;
SELECT * FROM shirts;

-- Delete all tank tops
-- SELECT * FROM shirts WHERE article='tank top';
DELETE FROM shirts WHERE article='tank top';
SELECT * FROM shirts;

-- Delete all shirts
DELETE FROM shirts;
SELECT * FROM shirts;

-- Drop the entire shirts table
DROP TABLE shirts;