-- Here we use employees, bonuses, attendance, projects, employee_projects, salary_history, leaves_data, clients, orders_data Tables

-- What are Joins: A JOIN clause is used to combine rows from two or more tables based on a related column between 
-- them. Instead of storing all data in one giant table, relational databases split data into logical tables 
-- and use JOINs to stitch them back together at query time.

-- Inner Join: Returns only matching values from both tables.

-- Display Employee Name, Bonus Amount & Bonus Date
select e.employee_name, b.bonus_amount, b.bonus_date 
from employees as e
inner join bonuses as b
on e.employee_id = b.employee_id;

-- Same thing with left join. It will return null values.
-- Left Join: Returns all the rows from letf + matched values from Right Table (Returns nulls if no matched)
-- select e.employee_name, b.bonus_amount, b.bonus_date 
-- from employees as e
-- left join bonuses as b
-- on e.employee_id = b.employee_id;


-- Display employee names, project names and role in the projects.
select e.employee_name, p.project_name, ep.`role`
from employees as e
inner join employee_projects as ep
on e.employee_id = ep.employee_id
inner join projects as p
on ep.project_id = p.project_id;


-- Display eployee id, name who received a bonus greater than 10000.
select e.employee_id, e.employee_name, b.bonus_amount
from employees as e
inner join bonuses b
on e.employee_id = b.employee_id
where b.bonus_amount > 10000;


-- Display employees whor are currently on leave along with their manager names.
select e.employee_name as emp_name,
m.employee_name as manger_name,
e.employment_status
from employees e
inner join employees m
on m.employee_id = e.manager_id
where e.employment_status = 'On Leave';



-- Now Left join
-- Display employees who never received any bonus
select e.employee_name, b.bonus_amount
from employees e
left join bonuses as b
on e.employee_id = b.employee_id
where b.bonus_amount is null;


-- Display employees working on more than one project.
select e.employee_name emp_name,
 count(ep.project_id) total_projects
from employees as e
inner join employee_projects as ep
on e.employee_id = ep.employee_id
group by e.employee_id
having count(ep.project_id) > 1;


-- Display employees who are not assigned any project
select e.employee_name as emp_name,
ep.project_id 
from employees as e
left join employee_projects as ep
on e.employee_id = ep.employee_id
where ep.project_id is null;


-- find projects that currently have no emmployees
select * from employees;
select * from employee_projects;

select e.employee_name, 
ep.project_id
from employees as e
left join employee_projects as ep
on e.employee_id = ep.employee_id
where ep.project_id is null;


-- find client names along with the total number of orders placed
select * from clients;
select * from orders_data;


select c.client_name, count(od.order_id) total_orders
from clients as c
left join orders_data as od
on c.client_id = od.client_id
group by c.client_name;
