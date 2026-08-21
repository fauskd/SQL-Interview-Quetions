-- Find the total employees and how many employees have a manager assigned.
select count(*) as total_employees,
count(manager_id) as manager_assigned
from employees;

-- Understanding COUNT(*) vs COUNT(column) vs COUNT(1)
select count(*) as total_employees,
count(1),
count(manager_id)
from employees;

-- Find the total salary expense, average salary, the highest and lowest salary of the company.
select sum(salary)as total_salary,
avg(salary) as avg_salary,
max(salary) as highest_salary,
min(salary) as lowest_salary
from employees;

-- Group by
-- Find the total number of employees in each department.
select department, 
count(*) as department_employees
from employees
where department is not null
group by department;


-- Find the average salary of employees in each city.
select city, 
avg(salary) as avg_salary
from employees
group by city;

-- Find the total number of Active employees in each department.
select department,
count(*) as active_department_employees
from employees
where employment_status = 'Active'
group by department;


-- Find the total salary expense of employees working in Mumbai for each department.
select department, sum(salary) as total_salary
from employees
where city = 'Mumbai'
group by department;

-- Find departments having more than 5 employees.
select department, 
count(*) as department_employees
from employees
group by department
having department_employees > 5;

-- Find cities whose average salary is greater than ₹70,000.
select city, avg(salary) as avg_salary
from employees
group by city
having avg_salary > 70000;

-- Find departments whose average salary lies between ₹60,000 and ₹80,000.
select department, avg(salary) as avg_salary
from employees
group by department
having avg_salary between 60000 and 80000;

-- Find departments having at least 4 employees who are currently Active.
select department, count(*) as active_employees
from employees
where employment_status = 'Active'
group by department
having active_employees >= 4; 

-- Find Duplicate Records By Email
select email, count(*) as duplicate_email
from employees
group by email
having duplicate_email > 1;
