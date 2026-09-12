-- Views in SQL
-- A View is a virtual table created using the result of a SQL query
-- A Virtual Table is a table that does not store data itself. It stroes the SQL query used to create the view
-- and whenever the view is accessed, SQL executes that query to fetch the latest data.

CREATE VIEW employee_active_status AS
    SELECT 
        *
    FROM
        employees
    WHERE
        employment_status = 'Active';

SELECT 
    *
FROM
    employee_active_status;

show tables;
show full tables;


-- Create a view to display employee name, department and salary of employees earning more than 70000
CREATE VIEW employee_record AS
    SELECT 
        employee_name, gender, department, salary
    FROM
        employees
    WHERE
        salary > 70000;

SELECT 
    *
FROM
    employee_record;


-- Create a view to display employee name along with their manager name.
CREATE VIEW employee_with_manager AS
    SELECT 
        e.employee_name AS employerName,
        m.employee_name AS managerName
    FROM
        employees AS e
            INNER JOIN
        employees AS m ON e.manager_id = m.employee_id;


SELECT 
    *
FROM
    employee_with_manager;


-- Create a view to display the total number of employees in each department.
CREATE VIEW department_count AS
    SELECT 
        department, COUNT(*) AS total_count
    FROM
        employees
    GROUP BY department;

SELECT 
    *
FROM
    department_count;
    

-- Create a view to display the highest-paid employee from each department.
CREATE VIEW highest_paid_employee AS
SELECT *
FROM (
    SELECT *,
           RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS ranking
    FROM employees
    WHERE department IS NOT NULL
) t
WHERE ranking = 1;


SELECT *
FROM highest_paid_employee;


-- Modify View
-- redefine department_count to count by city instead:
ALTER VIEW department_count AS
SELECT city, COUNT(*) AS total_city_count
FROM employees
GROUP BY city;

select * from department_count;


-- Want to delete a View
DROP VIEW view_name;
