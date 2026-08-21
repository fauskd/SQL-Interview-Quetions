-- Basics check of the data 

-- Retrieve all employee details
select * from employees;

-- Retrieve name, department and salary only
select employee_name, department, salary
from employees;

-- Find all unique departments (how many unique departments are in the dataset)
select distinct department
from employees
where department is not null;

-- Simple filtering with 'where'

--- Find employees in the IT department
select * from employees
where department = 'IT';

-- Find employees who earning more than 80,000
select * from employees
where salary > 80000;

-- Find IT employees who earning more than 80000
select * from employees
where salary > 80000 and department = 'IT';

-- Employees in IT or Finance
-- Using 'or' after 'where'
select * from employees
where department = 'IT' or department= 'Finance';

-- Using 'in' after 'where'
select * from employees
where department in ('IT','Finance');

-- Find employees who are not active
-- Using 'not equal ' after where
select employee_name, employment_status
from employees
where employment_status <> 'Active';

-- Using 'not' after where
select employee_name, employment_status
from employees
where not employment_status = 'Active';

-- Employees with salary between 50000 and 80000
-- using 'between'
select * from employees
where salary between 50000 and 80000;

-- Using comparison operators
select * from employees
where salary >= 50000 and salary <= 80000;

-- Pattern Matching with 'like'
-- employees whose name starts with 'A'
select * from employees
where employee_name like 'A%';


-- Employees with a Gmail address
select * from employees
where email like '%@gmail.com';

-- Active employees whose name starts with 'S'
select * from employees
where employment_status = 'Active' and employee_name like 'S%';


-- Null checks
-- Employees with no manager assigned and email not available

select * from employees
where manager_id is null and email is null;

-- Top 3 highest paid IT or Finance Employees earning 70000-100000
select * from employees 
where department in ('IT', 'Finance')
and salary between 70000 and 100000
order by salary desc
limit 3;
