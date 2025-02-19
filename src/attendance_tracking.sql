-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support

-- Attendance Tracking Queries

-- 1. Record a member's gym visit
-- TODO: Write a query to record a member's gym visit

INSERT INTO attendance (check_in_time, check_out_time, member_id, location_id)
VALUES (
    CURRENT_TIMESTAMP,  -- Set check-in time to the current timestamp
    NULL,              -- Check-out time is NULL as the member is currently checked in
    7,                 -- Member ID
    1                  -- Location ID
); 

-- 2. Retrieve a member's attendance history
-- TODO: Write a query to retrieve a member's attendance history

SELECT 
    DATE(check_in_time) AS visit_date,  -- Extracts the date from the check_in_time column and aliases it as visit_date
    STRFTIME('%H:%M:%S', check_in_time) AS check_in_time, -- Formats the check-in time as HH:MM:SS
    STRFTIME('%H:%M:%S', check_out_time) AS check_out_time  -- Formats the check-out time as HH:MM:SS
FROM 
    attendance
WHERE 
    member_id = 5; -- Filters the results to only include records for member ID 5

-- 3. Find the busiest day of the week based on gym visits
-- TODO: Write a query to find the busiest day of the week based on gym visits

SELECT 
    CASE CAST(STRFTIME('%w', check_in_time) AS INTEGER) -- Extracts the day of the week (0 for Sunday, 1 for Monday, etc.) from the check_in_time column
        WHEN 0 THEN 'Sunday'
        WHEN 1 THEN 'Monday'
        WHEN 2 THEN 'Tuesday'
        WHEN 3 THEN 'Wednesday'
        WHEN 4 THEN 'Thursday'
        WHEN 5 THEN 'Friday'
        ELSE 'Saturday'
    END AS day_of_week, -- Assigns a name to the day of the week
    COUNT(*) AS visit_count -- Counts the number of visits for each day of the week
FROM attendance
GROUP BY day_of_week  -- Groups the results by day of the week
ORDER BY visit_count DESC -- Orders the results in descending order of visit count
LIMIT 1; -- Limits the results to the top 1 row, which represents the day with the most visits


-- 4. Calculate the average daily attendance for each location
-- TODO: Write a query to calculate the average daily attendance for each location

SELECT 
    l.location_name,  -- Selects the name of the location
    CAST(COUNT(a.attendance_id) AS REAL) / COUNT(DISTINCT DATE(a.check_in_time)) AS avg_daily_attendance -- Calculates the average daily attendance by dividing the total attendance count by the number of distinct visit dates
FROM locations l
LEFT JOIN attendance a ON l.location_id = a.location_id  -- Performs a left join between the locations and attendance tables based on the location ID
GROUP BY l.location_id, l.location_name; -- Groups the results by location ID and name to calculate the average for each location
