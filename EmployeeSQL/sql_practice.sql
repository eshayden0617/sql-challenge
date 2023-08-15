--make sure there are no duplicates
DROP TABLE salaries;
DROP TABLE dept_manager;
DROP TABLE dept_emp;
DROP TABLE employees;
DROP TABLE titles;
DROP TABLE departments;

--titles table
CREATE TABLE titles(
	title_id VARCHAR(255) PRIMARY KEY NOT NULL,
	title VARCHAR(255) NOT NULL
);

--employees table
CREATE TABLE employees (
    emp_no INT UNIQUE PRIMARY KEY NOT NULL,
    emp_title_id VARCHAR(255) NOT NULL,
    birth_date DATE NOT NULL,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    sex CHAR(1),
    hire_date DATE NOT NULL,
    FOREIGN KEY (emp_title_id) REFERENCES titles(title_id)
);

--departments table
CREATE TABLE departments(
	dept_no VARCHAR(10) PRIMARY KEY UNIQUE NOT NULL,
	dept_name VARCHAR(255) NOT NULL
);

--department employee table
CREATE TABLE dept_emp(
	emp_no INT NOT NULL,
	dept_no VARCHAR(10) NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no)
);

--department manager table
CREATE TABLE dept_manager(
	dept_no VARCHAR(10) NOT NULL,
	emp_no INT NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no)
);

--salaries table
CREATE TABLE salaries(
	emp_no INT NOT NULL,
	salary INT NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES Employees(emp_no)
);

--1. List the employee number, last name, first name, sex, and salary of each employee
CREATE VIEW employee_data AS
SELECT
    e.emp_no AS "Employee Number",
    e.last_name AS "Last Name",
    e.first_name AS "First Name",
    e.sex AS "Orientation",
    s.salary AS "Salary"
FROM employees e
JOIN salaries AS s ON e.emp_no = s.emp_no;

SELECT * FROM employee_data;

--2. List the first name, last name, and hire date for the employees who were hired in 1986
CREATE VIEW employee_hired_1986 AS
SELECT first_name, last_name, hire_date
FROM employees
WHERE EXTRACT(YEAR FROM hire_date) = 1986;

SELECT * FROM employee_hired_1986;

--3. List the manager of each department along with their department number, department name, employee number, last name, and first name
CREATE VIEW manager_info AS
SELECT
	dm.dept_no AS "Department Number",
	d.dept_name AS "Department Name",
	dm.emp_no AS "Employee Number",
	e.last_name AS "Manager Last Name",
	e.first_name AS "Manager First Name"
FROM departments d
JOIN dept_manager dm ON d.dept_no = dm.dept_no
JOIN employees e ON dm.emp_no = e.emp_no;

SELECT * FROM manager_info;

--4. List the department number for each employee along witht that employee's number, last name, and department name
CREATE VIEW department_employees AS
SELECT
	e.emp_no AS "Employee Number",
	e.last_name AS "Employee Last Name",
	e.first_name AS "Employee First Name",
	d.dept_no AS "Department Number",
	d.dept_name AS "Department Name"
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no;

SELECT * FROM department_employees;

--5. List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with 'B'
CREATE VIEW hercules_b AS
SELECT first_name, last_name, sex
FROM employees
WHERE first_name = 'Hercules' AND last_name LIKE 'B%';

SELECT * FROM hercules_b;

--6. List each employee in the Sales department, including employee number, last name, and first name
CREATE VIEW Sales_dept AS 
SELECT
	e.emp_no AS "Employee Number",
	e.last_name AS "Last Name",
	e.first_name AS "First Name"
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
WHERE d.dept_name = 'Sales';

SELECT * FROM Sales_dept;

--7. List each employee in the Sales and Development Departmens, including employee number, last name, first name, and department
CREATE VIEW Sales_andDev AS
SELECT
	e.emp_no AS "Employee Number",
	e.last_name AS "Last Name",
	e.first_name AS "First Name",
	d.dept_name AS "Department Name"
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
WHERE d.dept_name IN ('Sales', 'Development');

SELECT * FROM Sales_andDev;

--8. List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name)
CREATE VIEW frequency_counts AS
SELECT last_name, COUNT(*) AS frequency 
FROM employees
GROUP BY last_name
ORDER BY frequency DESC;

SELECT * FROM frequency_counts;
