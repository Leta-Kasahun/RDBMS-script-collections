-- File: 03_crud_operations.sql

-- EMPLOYEES CRUD

-- Create (with RETURNING)
DECLARE
  v_emp_id NUMBER;
BEGIN
  INSERT INTO employees (first_name, last_name, email, phone_number, hire_date, job_id, salary, manager_id, department_id)
  VALUES ('Anna', 'Lee', 'anna.lee@example.com', '555-1234', SYSDATE, 'DEV', 88000, NULL, 2)
  RETURNING employee_id INTO v_emp_id;
END;
/

-- Read
SELECT * FROM employees WHERE employee_id = 1;
SELECT first_name || ' ' || last_name AS full_name, email FROM employees WHERE department_id = 2;

-- Update
UPDATE employees
SET salary = salary * 1.05
WHERE employee_id = 1;

-- Delete
DELETE FROM employees WHERE employee_id = 999; -- no-op if not exists

-- DEPARTMENTS CRUD

-- Create
INSERT INTO departments (department_name, location) VALUES ('Customer Success', 'Los Angeles');

-- Read
SELECT * FROM departments;
SELECT department_name FROM departments WHERE location = 'Seattle';

-- Update
UPDATE departments SET location = 'San Jose' WHERE department_name = 'IT';

-- Delete
DELETE FROM departments WHERE department_name = 'Admin';

-- JOBS CRUD

-- Create
INSERT INTO jobs (job_id, job_title, min_salary, max_salary) VALUES ('QA', 'Quality Analyst', 45000, 90000);

-- Read
SELECT * FROM jobs WHERE job_title LIKE '%Manager%';

-- Update
UPDATE jobs SET max_salary = 95000 WHERE job_id = 'MKT';

-- Delete
DELETE FROM jobs WHERE job_id = 'ADM';

-- JOB_HISTORY CRUD

-- Create
INSERT INTO job_history (employee_id, start_date, end_date, job_id, department_id)
VALUES (1, TO_DATE('2022-01-01','YYYY-MM-DD'), TO_DATE('2022-12-31','YYYY-MM-DD'), 'DEV', 2);

-- Read
SELECT * FROM job_history WHERE employee_id = 1;

-- Update
UPDATE job_history
SET end_date = TO_DATE('2023-01-15','YYYY-MM-DD')
WHERE employee_id = 1 AND start_date = TO_DATE('2022-01-01','YYYY-MM-DD');

-- Delete
DELETE FROM job_history WHERE employee_id = 1 AND start_date = TO_DATE('2022-01-01','YYYY-MM-DD');

-- LOCATIONS CRUD

-- Create
INSERT INTO locations (street_address, postal_code, city, state_province, country_id)
VALUES ('999 New Blvd', '90001', 'Los Angeles', 'CA', 'US');

-- Read
SELECT city, state_province FROM locations WHERE country_id = 'US';

-- Update
UPDATE locations SET city = 'San Diego' WHERE street_address = '999 New Blvd';

-- Delete
DELETE FROM locations WHERE street_address = '999 New Blvd';

-- Transaction example with savepoint
BEGIN
  SAVEPOINT sp1;
  UPDATE employees SET salary = salary + 1000 WHERE employee_id = 1;
  SAVEPOINT sp2;
  UPDATE departments SET location = 'Phoenix' WHERE department_name = 'Marketing';
  -- Roll back to sp2 or sp1 if needed
  -- ROLLBACK TO sp1;
  COMMIT;
END;
/
