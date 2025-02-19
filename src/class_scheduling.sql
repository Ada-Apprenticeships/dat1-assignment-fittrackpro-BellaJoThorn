-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support

-- Class Scheduling Queries

-- 1. List all classes with their instructors
-- TODO: Write a query to list all classes with their instructors

SELECT 
    c.class_id,  -- Selects the class ID from the classes table
    c.class_name, -- Selects the class name from the classes table
    s.first_name || ' ' || s.last_name AS instructor_name -- Concatenates the first and last names of the instructor from the staff table and aliases it as instructor_name
FROM 
    classes c
JOIN 
    class_schedule cs ON c.class_id = cs.class_id -- Joins the classes table with the class_schedule table based on the class ID
JOIN 
    staff s ON cs.staff_id = s.staff_id; -- Joins the class_schedule table with the staff table based on the staff ID

-- 2. Find available classes for a specific date
-- TODO: Write a query to find available classes for a specific date

SELECT 
 c.class_id,  -- Selects the class ID
 c.class_name AS name, -- Selects the class name and aliases it as "name"
    cs.start_time,  -- Selects the class start time
    cs.end_time,  -- Selects the class end time
    c.capacity - COUNT(ca.member_id) AS available_spots -- Calculates the number of available spots by subtracting the count of attending members from the class capacity
FROM
    classes c  -- Starts with the "classes" table
JOIN 
    class_schedule cs ON c.class_id = cs.class_id -- Joins with the "class_schedule" table based on the class ID
LEFT JOIN 
    class_attendance ca ON cs.schedule_id = ca.schedule_id -- Left joins with the "class_attendance" table based on the schedule ID
WHERE 
    STRFTIME('%Y-%m-%d', cs.start_time) = '2025-02-01'  -- Filters results to classes on a specific date
GROUP BY 
    c.class_id, c.class_name, cs.start_time, cs.end_time -- Groups the results by class ID, name, start time, and end time
HAVING 
    available_spots > 0; -- Filters the grouped results to only include classes with available spots

-- 3. Register a member for a class
-- TODO: Write a query to register a member for a class

INSERT INTO class_attendance (attendance_status, schedule_id, member_id)
VALUES (
    'Registered',  -- Sets the attendance status to 'Registered'
    (
        SELECT schedule_id -- Subquery to retrieve the schedule ID
        FROM class_schedule 
        WHERE class_id = 3 -- Filters by class ID
          AND STRFTIME('%Y-%m-%d', start_time) = '2025-02-01' -- Filters by date
    ), 
    11  -- Sets the member ID to 11
);

-- 4. Cancel a class registration
-- TODO: Write a query to cancel a class registration

DELETE FROM class_attendance
WHERE schedule_id = 7 -- Specifies the schedule ID
  AND member_id = 2; -- Specifies the member ID

-- 5. List top 5 most popular classes
-- TODO: Write a query to list top 5 most popular classes

SELECT 
    c.class_id, -- Selects the class ID
    c.class_name,  -- Selects the class name
    COUNT(ca.member_id) AS registration_count  -- Calculates the number of registrations for each class and aliases it as "registration_count"
FROM 
    classes c -- Starts with the "classes" table
LEFT JOIN 
    class_schedule cs ON c.class_id = cs.class_id  -- Left joins with the "class_schedule" table based on the class ID
LEFT JOIN 
    class_attendance ca ON cs.schedule_id = ca.schedule_id -- Left joins with the "class_attendance" table based on the schedule ID
GROUP BY 
    c.class_id, c.class_name -- Groups the results by class ID and name
ORDER BY 
    registration_count DESC -- Orders the results in descending order of registration count
LIMIT 
    5;  -- Limits the results to the top 5 rows

-- 6. Calculate average number of classes per member
-- TODO: Write a query to calculate average number of classes per member

SELECT
 CAST((SELECT COUNT(DISTINCT schedule_id) FROM class_attendance) AS REAL) / -- Count of distinct classes (converted to REAL for decimal division)
  (SELECT COUNT(*) FROM members) AS average_classes_per_member;  -- Total number of members