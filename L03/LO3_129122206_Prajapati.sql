
-- ***********************
-- Name: Akashkumar Bharatbhai Prajapati
-- ID: 129122206
-- Date: 10/10/2021
-- Purpose: Lab 04 DBS311
-- ***********************


-- Q1 Solution --
SELECT city FROM locations 
WHERE location_id 
IN (SELECT location_id FROM locations 
     MINUS SELECT location_id FROM warehouses) ORDER BY 1;
     
-- Q2 SOLUTION --
SELECT categ.category_id, categ.category_name, 
COUNT(*) FROM products pro
FULL OUTER JOIN product_categories categ
ON categ.category_id = pro.category_id
WHERE categ.category_id = 5
GROUP BY categ.category_id, categ.category_name
UNION ALL 
SELECT categ.category_id, categ.category_name, 
COUNT(*) FROM products pro
FULL OUTER JOIN product_categories categ
ON categ.category_id = pro.category_id
WHERE categ.category_id = 1
GROUP BY categ.category_id, categ.category_name
UNION ALL
SELECT categ.category_id, categ.category_name, 
COUNT(*) FROM products pro
FULL OUTER JOIN product_categories categ
ON pro.category_id = categ.category_id  
WHERE categ.category_id = 2
GROUP BY categ.category_id, categ.category_name;

-- Q3 SOLUTION --
SELECT first_name
FROM employees
INTERSECT 
SELECT first_name
FROM contacts;

-- Q4 Solution --
SELECT warehouse_name, state
FROM warehouses INNER JOIN locations
ON locations.location_id = warehouses.location_id
UNION SELECT warehouse_name, state
FROM warehouses RIGHT JOIN locations
ON locations.location_id = warehouses.location_id;