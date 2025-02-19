-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support

-- Staff Management Queries

-- 1. List all staff members by role
-- TODO: Write a query to list all staff members by role

SELECT 
    staff_id, -- Selects the staff ID
    first_name, -- Selects the staff member's first name
    last_name, -- Selects the staff member's last name
    position AS role -- Selects the staff member's position and aliases it as "role"
FROM 
    staff -- From the "staff" table
ORDER BY 
    role; -- Orders the results alphabetically by role

-- 2. Find trainers with one or more personal training session in the next 30 days
-- TODO: Write a query to find trainers with one or more personal training session in the next 30 days

SELECT 
 s.staff_id AS trainer_id, -- Selects the staff ID and aliases it as "trainer_id"
 s.first_name || ' ' || s.last_name AS trainer_name, -- Concatenates the staff member's first and last names and aliases it as "trainer_name"
    COUNT(DISTINCT pts.session_id) AS session_count  -- Counts the number of distinct training sessions for each trainer and aliases it as "session_count"
FROM 
    staff s -- Starts with the "staff" table
JOIN 
    personal_training_sessions pts ON s.staff_id = pts.staff_id -- Joins with the "personal_training_sessions" table based on the staff ID
WHERE 
    s.position = 'Trainer'  -- Filters results to only include staff members whose position is "Trainer"
    AND pts.session_date BETWEEN DATE('now') AND DATE('now', '+30 days') -- Filters results to sessions scheduled within the next 30 days
GROUP BY 
    trainer_id -- Groups the results by trainer ID
HAVING 
    session_count >= 1; -- Filters the grouped results to only include trainers with at least one session scheduled