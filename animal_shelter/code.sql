-- create tables
CREATE TABLE IF NOT EXISTS animal_intake (
    animal_id CHAR(7),
    name VARCHAR(30),
    date TIMESTAMP,
    monthyear TIMESTAMP,
    found_location VARCHAR(100),
    intake_type VARCHAR(20),
    intake_condition VARCHAR(30),
    animal_type VARCHAR(10),
    sex_upon_intake VARCHAR(20),
    age_upon_intake VARCHAR(20),
    breed VARCHAR(60),
    color VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS animal_outcome (
    animal_id CHAR(7),
    name VARCHAR(30),
    date TIMESTAMP,
    monthyear TIMESTAMP,
    date_of_birth DATE,
    outcome_type VARCHAR(30),
    outcome_subtype VARCHAR(30),
    animal_type VARCHAR(10),
    sex_upon_outcome VARCHAR(20),
    age_upon_outcome VARCHAR(20),
    breed VARCHAR(60),
    color VARCHAR(30)
);

-- import data
\COPY animal_intake FROM 'PATH' DELIMITER ',' CSV HEADER;
\COPY animal_outcome FROM 'PATH' DELIMITER ',' CSV HEADER;

-- remove the 'monthyear' column since it's the same as the 'date' column
ALTER TABLE animal_intake
DROP COLUMN monthyear;
ALTER TABLE animal_outcome
DROP COLUMN monthyear;

-- remove * from the 'name' column
UPDATE animal_intake
SET name = REPLACE(name, '*', '');
UPDATE animal_outcome
SET name = REPLACE(name, '*', '');

-- might be interesting
SELECT animal_id, outcome_type, COUNT(outcome_type)
FROM animal_outcome
GROUP BY animal_id, outcome_type
ORDER BY count DESC;
-- 1) What are the top 3 most common names for dog and cat? 
SELECT T.animal_type, T.name, T.count
FROM (SELECT animal_type, name, COUNT(name), ROW_NUMBER() OVER (PARTITION BY animal_type ORDER BY COUNT(name) DESC) AS name_rank
	  FROM animal_intake
	  WHERE animal_type = 'Cat' OR animal_type = 'Dog'
	  GROUP BY name, animal_type) AS T
where name_rank <= 3
ORDER BY animal_type;

-- 2) What are the 3 most common breeds for stray intakes?
SELECT breed, COUNT(*)
FROM animal_intake
WHERE intake_type = 'Stray'
GROUP BY breed
ORDER BY count DESC
LIMIT 3;

-- 3) What are the top 2 common outcome (adoption, transfer, etc.) for dog and cat?
SELECT T.animal_type, T.outcome_type, T.count
FROM (SELECT animal_type, outcome_type, COUNT(outcome_type), ROW_NUMBER() OVER (PARTITION BY animal_type ORDER BY COUNT(outcome_type) DESC) AS country_rank
	  FROM animal_outcome
	  WHERE animal_type = 'Cat' OR animal_type = 'Dog'
	  GROUP BY animal_type, outcome_type) AS T
where country_rank <= 2
ORDER BY animal_type;

-- 4) What is the average time between intake and adoption for each breed?


-- 5) What month has the most intakes?

