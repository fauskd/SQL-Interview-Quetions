-- A subqury is a query written inside another query.
-- Rules
-- Use join when you want to combine data from multiple tables
-- use a subquery when you want the result of one query to act as input to another query



-- find employees whose salary is greater than the average salary of the company.
SELECT 
    employee_name, salary
FROM
    employees
WHERE
    salary > (SELECT 
            AVG(salary) AS average_salary
        FROM
            employees);


-- find employees earning the highest salary in the company.
SELECT 
    employee_name, salary
FROM
    employees
WHERE
    salary = (SELECT 
            MAX(salary) AS highest_salary
        FROM
            employees);

-- find employees who work in the same department as 'Aarav Sharma'
SELECT 
    *
FROM
    employees
WHERE
    department IN (SELECT 
            department
        FROM
            employees
        WHERE
            employee_name = 'Aarav Sharma');
            
-- Find employees whose salary is greater than all employees in the Support department
SELECT 
    *
FROM
    employees
WHERE
    salary > ALL (SELECT 
            salary
        FROM
            employees
        WHERE
            department = 'Support');
-- Find employees working in departments where at least one employee is currently on leave
SELECT 
    *
FROM
    employees
WHERE
    department IN (SELECT 
            department
        FROM
            employees
        WHERE
            employment_status = 'on leave');
-- Find employees who have received bonuses
-- We can use JOIN
SELECT 
    e.employee_name, b.bonus_amount
FROM
    employees AS e
        INNER JOIN
    bonuses AS b ON e.employee_id = b.employee_id;

-- Find employees who have received bonuses using subquery
SELECT 
    *
FROM
    employees
WHERE
    employee_id IN (SELECT DISTINCT
            employee_id
        FROM
            bonuses);


-- Find employees who never received any bonus
SELECT 
    *
FROM
    employees
WHERE
    employee_id NOT IN (SELECT DISTINCT
            employee_id
        FROM
            bonuses);
-- Find employees whose salary is greater than the average salary of their own department
SELECT 
    department, AVG(salary)
FROM
    employees
GROUP BY department;

SELECT 
    *
FROM
    employees
WHERE
    salary > ALL (SELECT 
            AVG(salary)
        FROM
            employees
        GROUP BY department);

-- Find employees who are assigned to at least one project
SELECT 
    *
FROM
    employees AS e
WHERE
    EXISTS( SELECT 
            employee_id
        FROM
            employee_projects AS ep
        WHERE
            e.employee_id = ep.employee_id);
            
            
-- using JOIN
SELECT DISTINCT
    e.employee_id, ep.project_id
FROM
    employees AS e
        INNER JOIN
    employee_projects AS ep ON e.employee_id = ep.employee_id;


-- Find employees who earn more than their manager
SELECT 
    *
FROM
    employees e
WHERE
    salary > (SELECT 
            m.salary
        FROM
            employees m
        WHERE
            m.employee_id = e.manager_id);
            
-- Exists vs insert