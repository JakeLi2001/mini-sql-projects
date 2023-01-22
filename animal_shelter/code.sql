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



-- 1) What are the top 3 most common names for dog and cat per sex? 
SELECT T.animal_type, T.sex_upon_intake, T.name, T.count
FROM (SELECT animal_type, sex_upon_intake, name, COUNT(name), ROW_NUMBER() OVER (PARTITION BY animal_type, sex_upon_intake ORDER BY COUNT(name) DESC) AS name_rank
	  FROM animal_intake
	  WHERE animal_type = 'Cat' OR animal_type = 'Dog'
	  GROUP BY animal_type, name, sex_upon_intake) AS T
where name_rank <= 3 AND count >= 5
ORDER BY animal_type, sex_upon_intake, count DESC;

-- 2) What are the 3 most common breeds for stray intakes?
SELECT breed, COUNT(*)
FROM animal_intake
WHERE intake_type = 'Stray'
GROUP BY breed
ORDER BY count DESC
LIMIT 3;

-- 3) What are the top 2 common outcome (adoption, transfer, etc.) for each animal type?
SELECT T.animal_type, T.outcome_type, T.count
FROM (SELECT animal_type, outcome_type, COUNT(outcome_type), ROW_NUMBER() OVER (PARTITION BY animal_type ORDER BY COUNT(outcome_type) DESC) AS country_rank
	  FROM animal_outcome
	  GROUP BY animal_type, outcome_type) AS T
where country_rank <= 2
ORDER BY animal_type;

-- 4) Top 10 year and month that has the most intakes.
SELECT EXTRACT(YEAR FROM date) AS year, EXTRACT(MONTH FROM date) AS month, COUNT(*)
FROM animal_intake
GROUP BY year, month
ORDER BY count DESC
LIMIT 10;

-- 5) What is the average time between intake and adoption?
-- First step would be to join the two tables on 'animal_id'. However, there are duplicates in the 'animal_id' column so join would create duplicated records as well. Therefore, I will create Common Table Expressions (CTE) to store the latest unique records by date and then check for duplicates:
WITH intake_cte AS (
  SELECT *, ROW_NUMBER() OVER(PARTITION BY animal_id ORDER BY date DESC) AS rn
  FROM animal_intake), outcome_cte AS (
  SELECT *, ROW_NUMBER() OVER(PARTITION BY animal_id ORDER BY date DESC) AS rn
  FROM animal_outcome)
SELECT animal_id, name, COUNT(*)
FROM intake_cte -- Or outcome_cte
WHERE rn = 1
GROUP BY animal_id, name
HAVING COUNT(*) > 1;
-- If no record appears then it means there are no duplicates

-- Now we can calcuate the average time between intake and adoption
WITH intake_cte AS (
  SELECT *, ROW_NUMBER() OVER(PARTITION BY animal_id ORDER BY date DESC) AS rn
  FROM animal_intake), outcome_cte AS (
  SELECT *, ROW_NUMBER() OVER(PARTITION BY animal_id ORDER BY date DESC) AS rn
  FROM animal_outcome)
SELECT ROUND(AVG(EXTRACT(DAY FROM (o.date - i.date)))) AS average_days_until_adoption
FROM intake_cte AS i
JOIN outcome_cte AS o ON i.animal_id = o.animal_id
WHERE o.outcome_type = 'Adoption' AND i.rn = 1 AND o.rn = 1;