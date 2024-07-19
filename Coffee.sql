SELECT * FROM ingredients;
SELECT * FROM inventory;
SELECT * FROM items;
SELECT * FROM orders;
SELECT * FROM recipe;
SELECT * FROM rota;
SELECT * FROM shift;
SELECT * FROM staff;

UPDATE orders
SET created_at = STR_TO_DATE(created_at, '%d-%m-%Y %H:%i');

-- 1.List all ingredients with their names and prices.

SELECT ing_name, ing_price
FROM ingredients;

-- 2.Find the total quantity of each ingredient in the inventory.

SELECT i.ing_name, SUM(iv.quantity) AS total_quantity
FROM ingredients i
JOIN inventory iv ON i.ing_id = iv.ing_id
GROUP BY i.ing_name;

-- 3.List all items with their names and categories.

SELECT item_category ,item_name
FROM items;

-- 4.Find the total number of orders created every 4-5 minutes.

SELECT created_at, COUNT(order_id) AS total_orders
FROM orders
GROUP BY created_at;

-- 5.Calculate the total sales (sum of item prices multiplied by quantity) for each item.

SELECT it.item_name, ROUND(SUM(it.item_price * o.quantity),2) AS total_sales
FROM items it
JOIN orders o ON it.item_id = o.item_id
GROUP BY it.item_name;

-- 6.List all staff members and the total hours they worked in each shift.

SELECT CONCAT(s.first_name,' ', s.last_name) as Staff_name, sh.day_of_week, sh.start_time, sh.end_time, 
       (EXTRACT(HOUR FROM sh.end_time) - EXTRACT(HOUR FROM sh.start_time)) AS hours_worked
FROM staff s
JOIN rota r ON s.staff_id = r.staff_id
JOIN shift sh ON r.shift_id = sh.shift_id;

-- 7.Find the most frequently ordered item.

SELECT it.item_name, COUNT(o.item_id) AS order_count
FROM orders o
JOIN items it ON o.item_id = it.item_id
GROUP BY it.item_name
ORDER BY order_count DESC
LIMIT 1;

-- 8.List the top 5 customers by total quantity ordered.

SELECT cust_name, SUM(quantity) AS total_quantity
FROM orders
GROUP BY cust_name
ORDER BY total_quantity DESC
LIMIT 5;

-- 9.Find the staff member with the highest total salary.

WITH total_hours AS (
    SELECT 
        r.staff_id, 
        s.first_name,
        s.last_name,
        s.sal_per_hour,
        SUM(EXTRACT(HOUR FROM sh.end_time) - EXTRACT(HOUR FROM sh.start_time)) AS hours_worked
    FROM rota r
    JOIN shift sh ON r.shift_id = sh.shift_id
    JOIN staff s ON s.staff_id = r.staff_id
    GROUP BY r.staff_id, s.first_name, s.last_name, s.sal_per_hour
)
SELECT 
    CONCAT(th.first_name, ' ', th.last_name) AS Full_name, 
    (th.hours_worked * th.sal_per_hour) AS total_salary,
    DENSE_RANK() OVER (ORDER BY (th.hours_worked * th.sal_per_hour) DESC) AS Salary_rank
FROM total_hours th
ORDER BY total_salary DESC;

-- 10.Identify the day of the week with the highest total orders.

SELECT 
    sh.day_of_week, 
    COUNT(o.order_id) AS total_orders
FROM orders o
JOIN rota r ON DATE(o.created_at) = r.date
JOIN shift sh ON r.shift_id = sh.shift_id
GROUP BY sh.day_of_week
ORDER BY total_orders DESC
LIMIT 1;

-- 11.classify the times of coffee orders into Morning, Afternoon, Evening, and Night, and determine which part of the day has the highest total coffee sales 

SELECT
    CASE
        WHEN HOUR(created_at) >= 6 AND HOUR(created_at) < 12 THEN 'Morning'
        WHEN HOUR(created_at) >= 12 AND HOUR(created_at) < 15 THEN 'Afternoon'
        ELSE 'Evening'
    END AS part_of_day,
    COUNT(o.order_id) AS total_orders,
    SUM(it.item_price * o.quantity) AS total_sales
FROM orders o
JOIN items it ON o.item_id = it.item_id
GROUP BY part_of_day
ORDER BY total_sales DESC;

-- 12.Identify the top 3 staff members by the total revenue generated from orders they handled

SELECT 
    r.staff_id,
    s.first_name,
    s.last_name,
    SUM(o.quantity * it.item_price) AS total_revenue
FROM orders o
JOIN rota r ON DATE(created_at) = r.date
JOIN staff s ON r.staff_id = s.staff_id
JOIN items it ON o.item_id = it.item_id
GROUP BY r.staff_id, s.first_name, s.last_name
ORDER BY total_revenue DESC
LIMIT 3;

-- 13.Determine the percentage contribution of each item to the total sales for each month.

WITH daily_sales AS (
    SELECT 
        DATE_FORMAT(o.created_at, '%2024-%02-%d') AS DAY,
        it.item_id,
        SUM(o.quantity * it.item_price) AS item_sales
    FROM orders o
    JOIN items it ON o.item_id = it.item_id
    GROUP BY DATE_FORMAT(o.created_at, '%2024-%02-%d'), it.item_id
),
total_daily_sales AS (
    SELECT 
        day,
        SUM(item_sales) AS total_sales
    FROM daily_sales
    GROUP BY day
)
SELECT 
    ds.day,
    it.item_name,
    ds.item_sales,
    (ds.item_sales / tds.total_sales) * 100 AS percentage_contribution
FROM daily_sales ds
JOIN total_daily_sales tds ON ds.day = tds.day
JOIN items it ON ds.item_id = it.item_id;

-- 14. Calculate the percentage of orders that are dine-in versus takeout for each day of the week.

SELECT 
    DAYNAME(o.created_at) AS day_of_week,
    o.in_or_out,
    COUNT(o.order_id) * 100.0 / SUM(COUNT(o.order_id)) OVER (PARTITION BY DAYNAME(o.created_at)) AS percentage
FROM orders o
GROUP BY DAYNAME(o.created_at), o.in_or_out;

-- 15.Calculate the average time interval between consecutive orders for each customer.

SELECT 
    cust_name,AVG(interval_hours) AS avg_interval_hours
FROM (
    SELECT 
        cust_name,
        TIMESTAMPDIFF(HOUR, LAG(created_at) OVER (PARTITION BY cust_name ORDER BY created_at), created_at) AS interval_hours
    FROM orders
) AS intervals
WHERE interval_hours IS NOT NULL  
GROUP BY cust_name;


