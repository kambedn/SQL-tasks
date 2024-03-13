-- Triggers are SQL statements that are
-- AUTOMATICALLY RUN when a specific table is changed
-- CREATE TRIGGER name
-- trigger_time trigger_event ON table_name FOR EACH ROW
-- BEGIN
-- ...
-- END;

-- trigger_time
-- BEFORE or AFTER (the code is run before/after an insert/update/delete)

-- trigger_event
-- INSERT/UPDATE/DELETE

-- Triggers are used for validating data and enforcing specific things on it
-- To validate change we run code before inserting a row
DROP DATABASE IF EXISTS triggers_demo;
CREATE DATABASE triggers_demo;
USE triggers_demo;

CREATE TABLE users (
	username VARCHAR(100),
    age TINYINT
);

INSERT INTO users(username, age)
VALUES ('bobby', 23);

SELECT * FROM users;

-- 45000 - a generic state representing unhandled user-defined exception
-- we have to change delimiter because we need it in writing a trigger
-- that's why we change it to $$ and then to ; again
DELIMITER $$

CREATE TRIGGER must_be_adult
	BEFORE INSERT ON users FOR EACH ROW
    BEGIN
		IF NEW.age < 18
        THEN
			SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = 'Must be an adult!';
		END IF;
    END;
$$

DELIMITER ;

INSERT INTO users(username, age)
VALUES ('JJ', 12); -- Error Code: 1644. Must be an adult!

-- Listing triggers
SHOW TRIGGERS;

-- Removing triggers
-- DROP TRIGGER <trigger_name>;

-- Triggers can make debugging hard!
-- Hidden things happen behind the scenes.
