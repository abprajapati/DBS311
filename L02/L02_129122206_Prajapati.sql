-- ***********************
-- Name: Akashkumar Bharatbhai Prajapati
-- ID: 129122206
-- Date: 26-09-2021
-- Purpose: Lab 02 DBS311
-- ***********************

-- Q1 Solution --
SELECT job_Title, COUNT(*) AS "EMPLOYEES" FROM employees
GROUP BY job_Title ORDER BY "EMPLOYEES";


-- Q2 Solution –
SELECT MAX(credit_Limit) AS "HIGH", MIN (credit_Limit) AS "LOW", ROUND(AVG(credit_Limit),2) AS "AVERAGE",MAX(credit_Limit) - MIN(credit_Limit) AS "High Low Difference"
FROM customers;

-- Q3 Solution --
SELECT order_Id, SUM(quantity) AS "TOTAL_ITEMS", SUM(unit_Price * quantity) AS "TOTAL_AMOUNT" FROM order_Items
GROUP BY order_Id HAVING SUM(unit_Price * quantity) > 1000000
ORDER BY "TOTAL_AMOUNT" DESC;

-- Q4 Solution --
SELECT war.warehouse_Id, war.warehouse_Name, SUM(inv.quantity) AS "TOTAL_PRODUCTS" FROM warehouses war 
INNER JOIN inventories inv ON war.warehouse_Id = inv.warehouse_Id
GROUP BY war.warehouse_Id, war.warehouse_Name ORDER BY war.warehouse_Id;

-- Q5 Solution --
SELECT cus.customer_Id AS "CUSTOMER_ID", cus.name AS "customer name", NVL(COUNT(ord.order_Id),'0') AS "total number OF orders"
FROM customers cus LEFT JOIN orders ord ON cus.customer_Id = ord.customer_Id
WHERE cus.name LIKE 'O%e%' OR cus.name LIKE '%t'
GROUP BY cus.customer_Id, cus.name ORDER BY "total number OF orders" DESC;

-- Q6 Solution --
SELECT pro.category_Id, SUM(ord.quantity * ord.unit_Price) AS "TOTAL_AMOUNT", ROUND(AVG(ord.quantity * ord.unit_Price),2) AS "AVERAGE_AMOUNT" FROM products  pro 
INNER JOIN order_items ord ON pro.product_Id = ord.product_Id 
GROUP BY pro.category_Id;
