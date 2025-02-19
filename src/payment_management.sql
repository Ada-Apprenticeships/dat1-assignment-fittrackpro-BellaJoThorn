-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support

-- Payment Management Queries

-- 1. Record a payment for a membership
-- TODO: Write a query to record a payment for a membership

INSERT INTO payments (amount, payment_date, payment_method, payment_type, member_id)
VALUES ('50.00', -- Sets the payment amount to '50.00'
    STRFTIME('%Y-%m-%d %H:%M:%S', 'now'),  -- Sets the payment date to the current date and time
    'Credit Card', -- Sets the payment method to 'Credit Card'
    'Monthly membership fee', -- Sets the payment type to 'Monthly membership fee'
    11 -- Sets the member ID to 11
);

-- 2. Calculate total revenue from membership fees for each month of the last year
-- TODO: Write a query to calculate total revenue from membership fees for each month of the current year

SELECT
    STRFTIME('%Y-%m', payment_date) AS month, -- Extracts the year and month from the payment date and aliases it as "month"
    SUM(REPLACE(amount, ',', '') ) AS total_revenue -- Calculates the total revenue for each month by summing the payment amounts, removing any commas from the amount values, and aliasing it as "total_revenue"
FROM payments
WHERE payment_type = 'Monthly membership fee' -- Filters payments to include only those for "Monthly membership fee"
  AND payment_date BETWEEN DATE('now', '-1 year') AND DATE('now') -- Filters payments to include those within the last year
GROUP BY month -- Groups the results by month
ORDER BY month; -- Orders the results chronologically by month

-- 3. Find all day pass purchases
-- TODO: Write a query to find all day pass purchases

SELECT 
    payment_id, -- Selects the payment ID
    amount, -- Selects the payment amount
    payment_date, -- Selects the payment date
    payment_method -- Selects the payment method
FROM 
    payments  -- From the "payments" table
WHERE 
    payment_type = 'Day pass';  -- Filters results to only include payments with the type "Day pass"