-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support

-- User Management Queries

-- 1. Retrieve all members
-- TODO: Write a query to retrieve all members

SELECT 
    member_id, -- Selects the member ID
    first_name, -- Selects the member's first name
    last_name, -- Selects the member's last name
    email, -- Selects the member's email address
    join_date -- Selects the member's join date
FROM 
    members; -- From the "members" table

-- 2. Update a member's contact information
-- TODO: Write a query to update a member's contact information

UPDATE members -- Updates the "members" table
SET phone_number = '555-9876', -- Sets the phone number to '555-9876'
    email = 'emily.jones.updated@email.com' -- Sets the email address to 'emily.jones.updated@email.com'
WHERE member_id = 5; -- Specifies the member ID for the update

-- 3. Count total number of members
-- TODO: Write a query to count the total number of members

SELECT COUNT(*) AS total_members -- Counts all rows in the "members" table and aliases the result as "total_members"
FROM members; -- From the "members" table

-- 4. Find member with the most class registrations
-- TODO: Write a query to find the member with the most class registrations

SELECT 
    m.member_id, -- Selects the member ID
    m.first_name, -- Selects the member's first name
    m.last_name, -- Selects the member's last name
    COUNT(ca.class_attendance_id) AS registration_count -- Counts the number of class registrations for each member and aliases it as "registration_count"
FROM 
    members m -- Starts with the "members" table
LEFT JOIN 
    class_attendance ca ON m.member_id = ca.member_id -- Left joins with the "class_attendance" table based on the member ID
GROUP BY 
    m.member_id, m.first_name, m.last_name -- Groups the results by member ID, first name, and last name
ORDER BY 
    registration_count DESC -- Orders the results in descending order of registration count
LIMIT 
    1; -- Limits the results to the top row, which represents the member with the highest registration count

-- 5. Find member with the least class registrations
-- TODO: Write a query to find the member with the least class registrations

SELECT 
    m.member_id, -- Selects the member ID
    m.first_name,  -- Selects the member's first name
    m.last_name, -- Selects the member's last name
    COUNT(ca.class_attendance_id) AS registration_count -- Counts the number of class registrations for each member and aliases it as "registration_count"
FROM 
    members m -- Starts with the "members" table
LEFT JOIN 
    class_attendance ca ON m.member_id = ca.member_id -- Left joins with the "class_attendance" table based on the member ID
GROUP BY 
    m.member_id, m.first_name, m.last_name -- Groups the results by member ID, first name, and last name
ORDER BY 
    registration_count ASC -- Orders the results in ascending order of registration count
LIMIT 
    1; -- Limits the results to the top row, which represents the member with the lowest registration count

-- 6. Calculate the percentage of members who have attended at least one class
-- TODO: Write a query to calculate the percentage of members who have attended at least one class

SELECT CAST(COUNT(DISTINCT T1.member_id) AS REAL) * 100 / (SELECT COUNT(*) FROM members) AS percentage_attended  -- Calculate the percentage of members who have attended at least one class
FROM class_attendance AS T1 -- Alias the 'class_attendance' table as 'T1' for brevity
WHERE T1.attendance_status = 'Attended'; -- Filter for class attendances where the status is 'Attended'