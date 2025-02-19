-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support

-- Equipment Management Queries

-- 1. Find equipment due for maintenance
-- TODO: Write a query to find equipment due for maintenance

SELECT 
    equipment_id, -- Selects the equipment ID
    equipment_name AS name, -- Selects the equipment name and aliases it as "name"
    next_maintenance_date -- Selects the next maintenance date
FROM 
    equipment -- From the "equipment" table
WHERE 
    next_maintenance_date BETWEEN DATE('now') AND DATE('now', '+30 days'); -- Filters results to equipment with a next maintenance date within the next 30 days

-- 2. Count equipment types in stock
-- TODO: Write a query to count equipment types in stock

SELECT 
    equipment_type, -- Selects the equipment type
    COUNT(*) AS count -- Counts the occurrences of each equipment type and aliases it as "count"
FROM 
    equipment -- From the "equipment" table
GROUP BY 
    equipment_type; -- Groups the results by equipment type

-- 3. Calculate average age of equipment by type (in days)
-- TODO: Write a query to calculate average age of equipment by type (in days)

SELECT 
    equipment_type, -- Selects the equipment type
    CAST(AVG(JULIANDAY('now') - JULIANDAY(purchase_date)) AS INTEGER) AS avg_age_days -- Calculates the average age in days by subtracting the day of the purchase date from the current day, averaging the result, and casting it to an integer. This result is then aliased as "avg_age_days"
FROM 
    equipment -- From the "equipment" table
GROUP BY 
    equipment_type; -- Groups the results by equipment type