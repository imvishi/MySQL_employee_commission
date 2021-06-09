DROP DATABASE IF EXISTS employee_commission_schema;

CREATE DATABASE employee_commission_schema;

USE employee_commission_schema;


CREATE TABLE departments (
    id int,
    name varchar(255),
    PRIMARY KEY (id)
    );
    
INSERT INTO departments VALUES ( 1, "Banking");
INSERT INTO departments VALUES ( 2, "Insurance");
INSERT INTO departments VALUES ( 3, "Services");

CREATE TABLE employees (
    id int,
    name varchar(255),
    salary float,
    department_id int,
    PRIMARY KEY (id),
    FOREIGN KEY (department_id) REFERENCES departments(id)
    );
    
INSERT INTO employees VALUES ( 1, "Chris Gayle", 1000000, 1);
INSERT INTO employees VALUES ( 2, "Michael Clarke", 800000, 2);
INSERT INTO employees VALUES ( 3, "Rahul Dravid", 700000, 1);
INSERT INTO employees VALUES ( 4, "Ricky Pointing", 600000, 2);
INSERT INTO employees VALUES ( 5, "Albie Morkel", 650000, 2);
INSERT INTO employees VALUES ( 6, "Wasim Akram", 750000, 3);

CREATE TABLE commissions (
    id int,
    employee_id int,
    commission_amount float,
    PRIMARY KEY (id),
    FOREIGN KEY (employee_id) REFERENCES employees(id)
    );
    
INSERT INTO commissions VALUES (1, 1, 5000);
INSERT INTO commissions VALUES (2, 2, 3000);
INSERT INTO commissions VALUES (3, 3, 4000);
INSERT INTO commissions VALUES (4, 1, 4000);
INSERT INTO commissions VALUES (5, 2, 3000);
INSERT INTO commissions VALUES (6, 4, 2000);
INSERT INTO commissions VALUES (7, 5, 1000);
INSERT INTO commissions VALUES (8, 6, 5000);


/*Queries*/

/*1. Find the employee who gets the highest total commission.*/


/* This query returns first row with highest total commission*/
SELECT e.id, e.name
FROM commissions as c
INNER JOIN 
employees as e
ON 
e.id = c.employee_id
GROUP BY c.employee_id
ORDER BY SUM(c.commission_amount) DESC LIMIT 1;
/* OUTPUT
id      name
1       Chris Gayle
*/

/* This query returns all row with highest total commission*/

/*view created having id, name and total commissions*/
CREATE VIEW totalCommissions AS
SELECT e.id, e.name, SUM(c.commission_amount) as totalCommission
FROM commissions as c
INNER JOIN 
employees as e
ON 
e.id = c.employee_id
GROUP BY c.employee_id
ORDER BY SUM(c.commission_amount);


SELECT "";
SELECT t.id, t.name
FROM totalCommissions as t LEFT JOIN totalCommissions as t2
ON t.totalCommission < t2.totalCommission
WHERE t2.totalCommission IS NULL;
/* OUTPUT
id      name
1       Chris Gayle
*/

/*Used empty select to print empty line between two queries result in command line to increase readability */
SELECT "";
/*2. Find employee with 4th Highest salary from employee table.*/

/*index created to optimize the query performance*/
CREATE INDEX salary ON employees(salary);

SELECT id, name
FROM employees
ORDER BY salary DESC
LIMIT 1 OFFSET 3;
/*
OUTPUT:
id      name
3       Rahul Dravid
*/

/*Used empty select to print empty line between two queries result in command line  to increase readability */
SELECT "";
/*3 Find department that is giving highest commission.*/
SELECT d.name
FROM departments as d
INNER JOIN employees as e
ON d.id = e.department_id
INNER JOIN
commissions as c
ON c.employee_id = e.id
LEFT JOIN commissions as c1
ON c.commission_amount < c1.commission_amount
WHERE c1.commission_amount IS NULL;

/*
Output
name
Banking
Services
*/

/*Used empty select to print empty line between two queries result in command line to increase readability */  
SELECT "";
/*4. Find employees getting commission more than 3000*/

SELECT CONCAT((SELECT GROUP_CONCAT(distinct e.name SEPARATOR ", ")
FROM employees as e
INNER JOIN commissions as c
ON c.employee_id = e.id
WHERE c.commission_amount > 3000), "  ",3000) as result;
/*
Output:
result
Chris Gayle, Michael Clarke, Rahul Dravid, Wasim Akram  3000
*/