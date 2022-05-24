-- ***********************
-- Name: Akashkumar Bharatbhai Prajapati
-- ID: 129122206
-- Date: 19-09-21
-- Purpose: Lab 01 DBS311
-- ***********************

-- Q1 Solution --
SELECT TO_CHAR(sysdate + 1,'Month DD"th of year "YYYY ') As "Tomorrow"
FROM dual;

-- Q2 Solution –
SELECT product_Id AS"Product ID",product_Name AS "Product Name",
list_Price,ROUND(list_Price + (list_Price * (2/100))) AS "New Price", ROUND(list_Price + (list_Price * (2/100))) - list_Price   AS "Price Difference"
FROM products 
WHERE category_Id IN (2,3,5)
ORDER BY category_Id, product_Id;

-- Q3 Solution --
SELECT emp.employee_Id, ord.salesman_Id, ord.customer_Id, CONCAT(CONCAT(emp.last_Name, ', '), emp.first_Name) || ' is a ' || emp.job_Title AS "Employee Information"
FROM employees emp JOIN orders ord
ON emp.employee_Id = ord.salesman_Id
ORDER BY emp.employee_Id;

--Q4 Solution --
SELECT last_Name AS "Employee Name", hire_Date  AS "Hire Date", ROUND((sysdate-hire_Date)/30) AS "Number of months Employed"
FROM employees
ORDER BY hire_Date, "Number of months Employed";

-- Q5 Solution--
SELECT cus.name, cus.address, ord.order_Id
FROM customers cus
INNER JOIN orders ord
ON cus.customer_Id = ord.customer_Id
WHERE UPPER(name) =UPPER('&name');

-- Q6 Solution --
SELECT war.warehouse_Id, war.warehouse_Name , 
REPLACE (loc.city, 'Bombay', 'Pune') AS "City", NVL(loc.state,'unknown') AS "State"
FROM warehouses war
INNER JOIN locations loc
ON war.location_Id = loc.location_Id
ORDER BY war.warehouse_Id;

-- Q7 Solution --
SELECT employee_Id, first_Name, last_Name, TO_CHAR(hire_Date, 'MM/YY') AS "Month and Year hired"
FROM employees
WHERE first_Name LIKE '%a' AND last_Name LIKE 'H%';