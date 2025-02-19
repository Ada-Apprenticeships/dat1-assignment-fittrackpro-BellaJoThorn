-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support

-- Personal Training Queries

-- 1. List all personal training sessions for a specific trainer
-- TODO: Write a query to list all personal training sessions for a specific trainer

SELECT 
    pts.session_id,  -- Selects the session ID
    m.first_name || ' ' || m.last_name AS member_name, -- Concatenates the member's first and last names and aliases it as "member_name"
    pts.session_date,  -- Selects the session date
    pts.start_time,  -- Selects the session start time
    pts.end_time  -- Selects the session end time
FROM 
    personal_training_sessions pts -- Starts with the "personal_training_sessions" table
JOIN 
    members m ON pts.member_id = m.member_id -- Joins with the "members" table based on the member ID
JOIN 
    staff s ON pts.staff_id = s.staff_id -- Joins with the "staff" table based on the staff ID
WHERE 
    s.first_name = 'Ivy' AND s.last_name = 'Irwin'; -- Filters results to sessions scheduled with the trainer named "Ivy Irwin"
