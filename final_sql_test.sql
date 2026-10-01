CREATE DATABASE company_sql_test;
USE company_sql_test;

CREATE TABLE department (
department_id INT PRIMARY KEY,
department_name VARCHAR(100) NOT NULL,
location VARCHAR(100) NOT NULL
);

CREATE TABLE employeee (
employee_id INT PRIMARY KEY,
employee_name VARCHAR(100) NOT NULL,
department_id INT NOT NULL,
salary DECIMAL(10,2) NOT NULL,
hire_date DATE NOT NULL,
FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

INSERT INTO department
(department_id, department_name, location)
VALUES
(1, 'Human Resources', 'Pune'),
(2, 'IT', 'Mumbai'),
(3, 'Finance', 'Pune'),
(4, 'MCA', 'Bangalore'),
(5, 'MBA', 'Hyderabad');

INSERT INTO employeee
(employee_id, employee_name, department_id, salary, hire_date)
VALUES
(101, 'mini', 1, 65000, '2022-01-15'),
(102, 'tanvi', 1, 72000, '2021-06-20'),
(103, 'poorva', 2, 85000, '2020-03-10'),
(104, 'parth', 2, 90000, '2019-08-25'),
(105, 'atharv', 2, 75000, '2023-02-14'),
(106, 'radha', 3, 68000, '2022-09-05'),
(107, 'siddhi', 3, 80000, '2021-11-18'),
(108, 'Neha', 4, 55000, '2023-05-12'),
(109, 'kriti', 4, 60000, '2022-07-30'),
(110, 'riya', 4, 60000, '2024-01-10');

SELECT * from employeee;
SELECT * from department;


ALTER TABLE employeee
ADD COLUMN email VARCHAR(150);

UPDATE employeee
SET email = 'aarav.sharma@company.com'
WHERE employee_id = 101;

UPDATE employeee
SET email = 'priya.patil@company.com'
WHERE employee_id = 102;

UPDATE employeee
SET email = 'rohan.mehta@company.com'
WHERE employee_id = 103;

UPDATE employeee
SET email = 'ananya.joshi@company.com'
WHERE employee_id = 104;

UPDATE employeee
SET email = 'rahul.verma@company.com'
WHERE employee_id = 105;

UPDATE employeee
SET email = 'sneha.kulkarni@company.com'
WHERE employee_id = 106;

UPDATE employeee
SET email = 'arjun.desai@company.com'
WHERE employee_id = 107;

UPDATE employeee
SET email = 'neha.shah@company.com'
WHERE employee_id = 108;

UPDATE employeee
SET email = 'karan.rao@company.com'
WHERE employee_id = 109;

UPDATE employeee
SET email = 'aditi.more@company.com'
WHERE employee_id = 110;

ALTER TABLE employeee
ADD COLUMN status VARCHAR(20) NOT NULL DEFAULT 'Active';

UPDATE employeee
SET status = 'Inactive'
WHERE employee_id = 105;

SELECT
employee_id,
employee_name,
salary
FROM employeee
WHERE salary BETWEEN 50000 AND 90000
ORDER BY salary DESC;


SELECT
employee_id,
employee_name,
salary
FROM employeee
WHERE employee_name LIKE 'A%';

SELECT
employee_id,
employee_name,
salary
FROM employeee
WHERE employee_name LIKE '%r%';

SELECT
d.department_name,
COUNT(e.employee_id) AS employee_count
FROM department d
LEFT JOIN employeee e
ON d.department_id = e.department_id
GROUP BY
d.department_id,
d.department_name
ORDER BY d.department_id;

SELECT
d.department_name,
AVG(e.salary) AS average_salary
FROM department d
INNER JOIN employeee e
ON d.department_id = e.department_id
GROUP BY
d.department_id,
d.department_name
HAVING AVG(e.salary) > 70000;

SELECT
e.employee_name,
d.department_name,
d.location,
e.salary
FROM employeee e
INNER JOIN department d
ON e.department_id = d.department_id;

SELECT
employee_id,
employee_name,
salary
FROM employee
WHERE salary > (
SELECT AVG(salary)
FROM employee
);

SELECT
e.employee_id,
e.employee_name,
e.department_id,
e.salary
FROM employeee e
WHERE e.salary > (
SELECT AVG(e2.salary)
FROM employeee e2
WHERE e2.department_id = e.department_id
);

SELECT
d.department_id,
d.department_name,
d.location
FROM department d
WHERE EXISTS (
SELECT 1
FROM employeee e
WHERE e.department_id = d.department_id
);

SELECT
d.department_id,
d.department_name,
d.location
FROM department d
WHERE NOT EXISTS (
SELECT 1
FROM employeee e
WHERE e.department_id = d.department_id
);

SELECT
employee_id,
employee_name,
department_id,
salary,
DENSE_RANK() OVER (
PARTITION BY department_id
ORDER BY salary DESC
) AS salary_rank
FROM employees;

WITH ranked_employees AS (
SELECT
employee_id,
employee_name,
department_id,
salary,
ROW_NUMBER() OVER (
PARTITION BY department_id
ORDER BY salary DESC
) AS salary_rank
FROM employeee
)

SELECT
employee_id,
employee_name,
department_id,
salary,
salary_rank
FROM ranked_employees
WHERE salary_rank <= 2
ORDER BY department_id, salary DESC;


WITH department_average AS (
SELECT
department_id,
AVG(salary) AS average_salary
FROM employeee
GROUP BY department_id
)

SELECT
e.employee_id,
e.employee_name,
e.department_id,
e.salary,
da.average_salary
FROM employeee e
INNER JOIN department_average da
ON e.department_id = da.department_id
WHERE e.salary > da.average_salary;

CREATE VIEW employee_department_report AS
SELECT
e.employee_name,
d.department_name,
e.salary,
d.location
FROM employeee e
INNER JOIN department d
ON e.department_id = d.department_id;

SELECT *
FROM employee_department_report;