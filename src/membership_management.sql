-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support

-- Membership Management Queries

-- 1. List all active memberships
-- TODO: Write a query to list all active memberships

SELECT 
    m.member_id, -- Selects the member ID
    m.first_name, -- Selects the member's first name
    m.last_name, -- Selects the member's last name
    ms.membership_type, -- Selects the member's membership type
    m.join_date -- Selects the member's join date
FROM 
    members m -- Starts with the "members" table
JOIN 
    memberships ms ON m.member_id = ms.member_id -- Joins with the "memberships" table based on the member ID
WHERE 
    ms.membership_status = 'Active'; -- Filters results to only include members with an active membership status

-- 2. Calculate the average duration of gym visits for each membership type
-- TODO: Write a query to calculate the average duration of gym visits for each membership type

SELECT 
    ms.membership_type, -- Selects the membership type
    CAST(AVG((
        STRFTIME('%s', a.check_out_time) - STRFTIME('%s', a.check_in_time)  -- Calculates the difference between check-out and check-in times in seconds
    ) / 60) AS INTEGER) AS avg_visit_duration_minutes -- Converts the average visit duration from seconds to minutes and aliases it as "avg_visit_duration_minutes"
FROM 
    memberships ms -- Starts with the "memberships" table
JOIN 
    members m ON ms.member_id = m.member_id -- Joins with the "members" table based on the member ID
JOIN 
    attendance a ON m.member_id = a.member_id -- Joins with the "attendance" table based on the member ID
GROUP BY 
    ms.membership_type; -- Groups the results by membership type

-- 3. Identify members with expiring memberships this year
-- TODO: Write a query to identify members with expiring memberships this year

SELECT
    m.member_id,      -- Selects the member's ID from the 'members' table.
    m.first_name,     -- Selects the member's first name from the 'members' table.
    m.last_name,      -- Selects the member's last name from the 'members' table.
    m.email,         -- Selects the member's email address from the 'members' table.
    ms.end_date       -- Selects the membership end date from the 'memberships' table.
FROM 
    members m         -- Starts with the 'members' table (aliased as 'm' for brevity).
JOIN 
    memberships ms ON m.member_id = ms.member_id  -- Joins with the 'memberships' table (aliased as 'ms') based on matching member IDs.
WHERE 
    STRFTIME('%Y', ms.end_date) = STRFTIME('%Y', 'now') -- Filters the results to include only memberships expiring in the current year.
;