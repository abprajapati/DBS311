
-- ***********************
-- Student Name: Akashkumar Bharatbhai Prajapati
-- Student1 ID: 129122206
-- Date: 18-10-2021
-- Purpose: Assignment 1 - DBS311
-- ***********************

-- Question 1 - Display the employee number, full employee name, job title, and hire date of all employees hired in September with the most recently hired employees displayed first.
-- SOLUTION 1 -- 
SELECT employee_id AS "Employee Number", last_name || ','|| ' ' || first_name AS "Full Name",
job_title AS "Job Title", TO_CHAR(hire_date,'Month mmth" of "YYYY ') AS "Start Date"
FROM employees
WHERE TO_CHAR( hire_date,'Month') = 'September'
ORDER BY hire_date DESC;

-- Question 2 - The company wants to see the total sale amount per sales person (salesman) for all orders. Assume that online orders do not have any sales representative. For online orders (orders with no salesman ID), consider the salesman ID as 0. Display the salesman ID and the total sale amount for each employee. 
-- Sort the result according to employee number.
-- SOLUTION 2 --
SELECT NVL(ord.salesman_id,0) AS "Employee Number",
TO_CHAR(SUM(oItem.quantity*oItem.unit_price),'$99,999,999.99') AS "Total Sale"
FROM employees emp 
LEFT OUTER JOIN orders ord ON emp.employee_id = ord.salesman_id
FULL OUTER JOIN order_items oItem ON ord.order_id = oItem.order_id
GROUP BY ord.salesman_id 
ORDER BY ord.salesman_id NULLS FIRST ;

-- Question 3 - Display customer Id, customer name and total number of orders for customers that the value of their customer ID is in values from 35 to 45. Include the customers with no orders in your report if their customer ID falls in the range 35 and 45.  
--Sort the result by the value of total orders. 
-- SOLUTION 3 -- 
SELECT cus.customer_id AS "Customer Id", cus.name AS "Name", COUNT(ord.order_id) AS "Total Orders"
FROM customers cus 
FULL OUTER JOIN orders ord ON ord.customer_id = cus.customer_id 
WHERE ((cus.customer_id >= 35) AND (cus.customer_id <= 45) )
GROUP BY cus.customer_id, cus.name
ORDER BY "Total Orders"; 

-- Question 4 - Display customer ID, customer name, and the order ID and the order date of all orders for customer whose ID is 44.
-- a.	Show also the total quantity and the total amount of each customer’s order.
-- b.	Sort the result from the highest to lowest total order amount.
-- SOLUTION 4 --
SELECT cus.customer_id AS "Customer Id", cus.name AS "Name" , ord.order_id AS "Order Id", 
ord.order_date AS "Order Date",SUM(oItem.quantity) AS "Total Items",TO_CHAR(SUM(oItem.quantity*oItem.unit_price),'$99,999,999.99')  AS "Total Amount" 
FROM customers cus 
JOIN orders ord ON ord.customer_id = cus.customer_id 
INNER JOIN order_items oItem ON ord.order_id = oItem.order_id 
WHERE cus.customer_id = 44
GROUP BY cus.customer_id, cus.name, ord.order_id, ord.order_date
ORDER BY "Total Amount" DESC;

--Question 5 - Display customer Id, name, total number of orders, the total number of items ordered, and the total order amount for customers who have more than 30 orders. Sort the result based on the total number of orders.
-- SOLUTION 5 --
SELECT cus.customer_id AS "Customer Id", cus.name AS "Name" , COUNT(ord.order_id) AS "Total Number of Orders",
SUM(oItem.quantity) AS "Total Items",TO_CHAR(SUM(oItem.quantity*oItem.unit_price),'$99,999,999.99')  AS "Total Amount" 
FROM customers cus 
FULL OUTER JOIN orders ord ON  ord.customer_id = cus.customer_id
FULL OUTER JOIN order_items oItem ON ord.order_id = oItem.order_id
GROUP BY cus.customer_id, cus.name
HAVING COUNT (ord.order_id) > 30 ORDER BY "Total Number of Orders";

-- Question 6 - Display Warehouse Id, warehouse name, product category Id, product category name, and the lowest product standard cost for this combination.
-- •	In your result, include the rows that the lowest standard cost is less then $200.
-- •	Also, include the rows that the lowest cost is more than $500.
-- Sort the output according to Warehouse Id, warehouse name and then product category Id, and product category name.
-- SOLUTION 6 --
SELECT wHouse.warehouse_id AS "Warehouse ID", wHouse.warehouse_name AS "Warehouse Name", pCateg.category_id AS "Category ID", pCateg.category_name AS "Category Name", TO_CHAR(MIN(pro.standard_cost), '$999,999,999.99') AS "Lowest Cost"
FROM warehouses wHouse
JOIN inventories inven ON inven.warehouse_id = wHouse.warehouse_id  
JOIN products pro ON inven.product_id = pro.product_id  
JOIN product_categories pCateg ON pro.category_id = pCateg.category_id  
GROUP BY wHouse.warehouse_id, wHouse.warehouse_name, pCateg.category_id, pCateg.category_name
HAVING MIN (pro.standard_cost) < 200 OR  MIN(pro.standard_cost) > 500
ORDER BY wHouse.warehouse_id, wHouse.warehouse_name, pCateg.category_id, pCateg.category_name;

-- Question 7 - Display the total number of orders per month. Sort the result from January to December. 
-- SOLUTION 7 --
SELECT TO_CHAR(TO_DATE("m", 'mm'), 'Month') AS "Month", "o" AS "Number of Orders"
FROM (SELECT TO_CHAR(order_date, 'mm') AS "m", COUNT(order_id) AS "o"
      FROM orders GROUP BY TO_CHAR(order_date, 'mm'))
ORDER BY "m";

-- Question 8 - Display product Id, product name for products that their list price is more than any highest product standard cost per warehouse outside Americas regions.
--(You need to find the highest standard cost for each warehouse that is located outside the Americas regions. Then you need to return all products that their list price is higher than any highest standard cost of those warehouses.)
--Sort the result according to list price from highest value to the lowest.
-- SOLUTION 8 --
SELECT prod.product_id AS "Product ID", prod.product_name AS "Product Name", TO_CHAR(prod.list_price,'$999,999,999.99') AS "Price"
FROM products prod
WHERE prod.list_price > ANY(SELECT MAX(pro.standard_cost)
                            FROM products pro 
                            FULL OUTER JOIN inventories inven ON pro.product_id = inven.product_id
                            FULL OUTER JOIN warehouses wHouse ON wHouse.warehouse_id = inven.warehouse_id
                            FULL OUTER JOIN locations loc ON loc.location_id = wHouse.location_id  
                            FULL OUTER JOIN countries cou ON cou.country_id = loc.country_id 
                            FULL OUTER JOIN regions reg ON reg.region_id = cou.region_id  
                            WHERE LOWER (reg.region_name) != 'americas'
                            GROUP BY wHouse.warehouse_id) 
                            ORDER BY "Price" DESC;

-- Question 9 - Write a SQL statement to display the most expensive and the cheapest product (list price). Display product ID, product name, and the list price.
-- SOLUTION 9 --
SELECT product_id AS "Product ID", product_name AS "Product Name", TO_CHAR(list_price,'$999,999,999.99') AS "Price"
FROM products
WHERE list_price = (SELECT MAX(list_price) FROM products)
UNION  
SELECT product_id AS "Product ID", product_name AS "Product Name", TO_CHAR(list_price,'$999,999,999.99') AS "Price"
FROM products
WHERE list_price = (SELECT MIN(list_price) FROM products);
                    
-- Question 10 - Write a SQL query to display the number of customers with total order amount over the average amount of all orders, the number of customers with total order amount under the average amount of all orders, number of customers with no orders, and the total number of customers.
-- SOLUTION 10 --
SELECT "Customer Report"
FROM (SELECT  'Number of customers with total purchase amount over average: ' || COUNT(*) AS "Customer Report"
      FROM (SELECT cus.customer_id, SUM(oItem.quantity * oItem.unit_price) AS "amount over average:"
            FROM customers cus
            FULL OUTER JOIN orders ord ON ord.customer_id = cus.customer_id 
            FULL OUTER JOIN order_items oItem ON oItem.order_id = ord.order_id  
            GROUP BY cus.customer_id)
            WHERE "amount over average:" > (SELECT AVG(quantity * unit_price)
            FROM order_items))           
UNION ALL
SELECT "Customer Report"
FROM (SELECT 'Number of customers with total purchase amount below average: ' || COUNT(*) AS "Customer Report"
      FROM (SELECT cus.customer_id, SUM(oItem.quantity * oItem.unit_price) AS "amount below average"
            FROM customers cus
            FULL OUTER JOIN orders ord ON ord.customer_id = cus.customer_id  
            FULL OUTER JOIN order_items oItem ON oItem.order_id = ord.order_id  
            GROUP BY cus.customer_id)
            WHERE "amount below average" < (SELECT AVG(quantity * unit_price)
            FROM order_items))           
UNION ALL
SELECT "Customer Report"
FROM (SELECT 'Number of customers with no orders: ' || COUNT(*) AS "Customer Report"
      FROM orders ord
      RIGHT JOIN customers cus ON cus.customer_id = ord.customer_id  
      WHERE ord.customer_id IS NULL)
UNION ALL 
SELECT "Customer Report"
FROM(SELECT 'Total number of customers: ' || COUNT(*) AS "Customer Report"
     FROM customers);

