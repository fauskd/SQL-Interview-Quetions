-- Union and Union all
-- Union and union all stack the rows of two or more select queries on top of each other into a single result set.
-- where join combines tables side by side


-- What is union?
-- Union combines the results of two or more select queries and removes duplicate rows

-- what is Union all?
-- UNION ALL combines the results of two or more SELECT queries and keeps all rows, including duplicates. 


-- Practice Questions
-- Display all employee IDs who have received either a bonus or taken a leave.
-- with UNION
SELECT employee_id AS id
FROM bonuses

UNION

SELECT employee_id
FROM leaves_data;

-- with UNION ALL
SELECT employee_id AS id
FROM bonuses

UNION ALL

SELECT employee_id
FROM leaves_data;


-- Display the names of all employees and all clients in a single result set.
SELECT employee_name AS name, 'Employee' AS type
FROM employees

UNION ALL

SELECT client_name AS name, 'Client' AS type
FROM clients;