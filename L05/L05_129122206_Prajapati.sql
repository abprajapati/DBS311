-- *********
-- Name: Akashkumar Bharatbhai Prajapati
-- ID: 129122206
-- Date: 07-11-2021
-- Purpose: Lab 5 DBS311
-- *********

SET SERVEROUTPUT ON;
   
/* Question 1 -- 
1.	Write a stored procedure that get an integer number and prints
The number is divisible by 2 and 3. Otherwise, it prints The number is not divisible.
*/

-- Q1 Answer --
CREATE OR REPLACE PROCEDURE div (numValue IN NUMBER) AS 
BEGIN
   IF (MOD(numValue, 3) = 0 AND MOD(numValue, 2) = 0) 
THEN
   DBMS_OUTPUT.PUT_LINE('The number is divisible by 2 and 3.');
ELSE
   DBMS_OUTPUT.PUT_LINE('The number is not divisible.');
END

IF;
EXCEPTION 
WHEN
   OTHERS 
THEN
   DBMS_OUTPUT.PUT_LINE ('error found!');
END
;
EXECUTE div(45);
EXECUTE div('&num');

/* Question 2 -- 
Create a stored procedure named find_employee. This procedure gets an employee number and prints the following employee information:
First name 
Last name 
Email
Phone 	
Job title
 */
-- Q2 Answer -- 
CREATE OR REPLACE PROCEDURE find_employee (empNumber IN NUMBER) AS fName VARCHAR2(255 BYTE);
lName VARCHAR2(255 BYTE);
emailId VARCHAR2(255 BYTE);
phoneNum VARCHAR2(180 BYTE);
jobTitle VARCHAR2(255 BYTE);
BEGIN
   SELECT first_name, last_name, email, phone, job_title 
   INTO fName, lName, emailId, phoneNum,jobTitle 
   FROM employees 
   WHERE employee_id = empNumber;
   
DBMS_OUTPUT.PUT_LINE('First name: ' || fName);
DBMS_OUTPUT.PUT_LINE('Last name: ' || lName);
DBMS_OUTPUT.PUT_LINE('Email: ' || emailId);
DBMS_OUTPUT.PUT_LINE('Phone: ' || phoneNum);
DBMS_OUTPUT.PUT_LINE('Job title: ' || jobTitle);
EXCEPTION 
WHEN
   NO_DATA_FOUND 
THEN
   DBMS_OUTPUT.PUT_LINE('Employee number not available.');
WHEN
   TOO_MANY_ROWS 
THEN
   DBMS_OUTPUT.PUT_LINE('multiple rows are there!!.');
WHEN
   OTHERS 
THEN
   DBMS_OUTPUT.PUT_LINE('error found');
END
find_employee;
EXECUTE find_employee(107);
EXECUTE find_employee('&employeeId');


/*-- Question 3 -- 
3.	Every product in the products table has IDs and other details. Create a stored procedure (and appropriate procedure call) to find out the total list prices 
for three products using the IDs. The product IDs of the products must be sent to the procedure as parameters, and the total amount of list price must be stored 
in fourth parameter “total”. The product IDs must be entered by the user at the run time (In procedure call).  Use appropriate parameter types (IN and OUT).*/

-- Q3 Answer -- 

CREATE OR REPLACE PROCEDURE t_price ( Id1 IN products.product_id % TYPE, Id2 IN products.product_id % TYPE, Id3 IN products.product_id % TYPE, total OUT NUMBER) AS 
BEGIN
   SELECT SUM(list_price) INTO total 
   FROM products 
   WHERE product_id IN 
      (
         Id1, Id2, Id3 
      );
      
DBMS_OUTPUT.PUT_LINE( total || 'is total list price');
EXCEPTION 
WHEN
   NO_DATA_FOUND 
THEN
   DBMS_OUTPUT.PUT_LINE('data has not been found');
WHEN
   OTHERS 
THEN
   DBMS_OUTPUT.PUT_LINE('error found');
END

t_price;
DECLARE amt products.list_price % TYPE;
BEGIN
   t_price('&Id1', '&Id2', '&Id3', amt);
END
;
/* Question 4 -- 

Write a procedure named product_price to show if the  company is selling cheaper products or expensive products based on the above mentioned criteria.
The procedure has no parameter. First, you need to find the average, minimum, and maximum prices (list_price) in your database and store them into varibles 
avg_price, min_price, and max_price.*/

-- Q4 Answer -- 
CREATE OR REPLACE PROCEDURE product_price AS avg_price NUMBER;
min_price NUMBER;
max_price NUMBER;
BEGIN
   SELECT
   AVG(list_price), MIN(list_price), MAX(list_price) INTO avg_price, min_price, max_price 
   FROM products;
   
IF( min_price <= 15 OR avg_price <= 900 OR max_price <= 8000) 
THEN
   DBMS_OUTPUT.PUT_LINE('Cheaper products are being sold by company');
ELSE
    DBMS_OUTPUT.PUT_LINE('Expensive products are being sold by company');
END

IF;
EXCEPTION 
WHEN
   NO_DATA_FOUND 
THEN
   DBMS_OUTPUT.PUT_LINE('no data found');
WHEN
   OTHERS 
THEN
   DBMS_OUTPUT . PUT_LINE ( 'error found' ) ;
END
product_price;
EXECUTE product_price();


/* Question 5 -- 
Create a procedure which takes one argument as productID. Use this "productID" to remove row(s) of the product table where the product_ID of the product 
table matches the parameter. If no row is deleted, output "No rows affected", if one row is deleted, output "Single row deleted". Otherwise output "Multiple 
rows deleted". Write appropriate procedure call. Use appropriate IN/OUT parameter type. */
   
-- Q5 Answer --  

CREATE TABLE new_prod AS 
SELECT * 
FROM products;

CREATE OR REPLACE PROCEDURE rows_removal (productID IN products.product_id % TYPE) AS 
BEGIN
   DELETE
   FROM new_prod WHERE product_id = productID;
   
IF SQL % ROWCOUNT = 1 
THEN
   DBMS_OUTPUT.PUT_LINE('Single row deleted.');
ELSIF SQL  % ROWCOUNT = 0 
THEN
   DBMS_OUTPUT.PUT_LINE('No rows affected.');
ELSE
   DBMS_OUTPUT.PUT_LINE('Multiple rows deleted.');
END
IF;
EXCEPTION 
WHEN
   NO_DATA_FOUND 
THEN
   DBMS_OUTPUT.PUT_LINE('no data found');
WHEN
   TOO_MANY_ROWS 
THEN
   DBMS_OUTPUT.PUT_LINE('multiple rows are there');
WHEN
   OTHERS 
THEN
   DBMS_OUTPUT . PUT_LINE ( 'error found' ) ;
END
remove_rows;
EXECUTE rows_removal(40);
EXECUTE rows_removal('&productId');