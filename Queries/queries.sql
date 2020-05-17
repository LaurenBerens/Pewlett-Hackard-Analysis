-- Number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Retirement eligibility
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Need to add emp_no to this table...
DROP TABLE retirement_info;

-- Reitrement eligibility with emp_no
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM retirement_info;

-- Joining departments and dept_manager tables
SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;

-- Joining retirement_info (ri) and dept_emp (de) tables
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	de.to_date
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no;

-- Creating a table where current employees are listed
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
INTO retirement_by_dept
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

-- inquiring on columns in salary for comparison
SELECT * FROM salaries
ORDER BY to_date DESC;

-- create table to include emp_no, first, last, gender, employed to_date, salary
SELECT e.emp_no, 
	   e.first_name, 
	   e.last_name, 
	   e.gender, 
	   s.salary, 
	   de.to_date
INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND (de.to_date = '9999-01-01');

-- List of managers per department
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no);

--current_emp, departments, and dept_emp
SELECT ce.emp_no,
	ce.first_name,
	ce.last_name,
	d.dept_name
INTO dept_info
FROM current_emp AS ce
INNER JOIN dept_emp AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no);

--Skill Drill for mentor program: Sales and Development teams only--> Emp_no, first, last, dept name
SELECT ce.emp_no,
	ce.first_name,
	ce.last_name,
	d.dept_name
INTO skill_drill_dept_info
FROM current_emp AS ce
INNER JOIN dept_emp AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no)
WHERE d.dept_name IN ('Sales', 'Development');

-- retirement age employees- with dups sorted by title
SELECT e.emp_no, 
	e.first_name, 
	e.last_name, 
	t.title, 
	t.from_date,
	s.salary
INTO challenge_dups
FROM employees AS e
INNER JOIN salaries AS s
ON (e.emp_no = s.emp_no)
INNER JOIN titles AS t
ON (e.emp_no = t.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
ORDER BY t.title;

-- Drop dups on retirement ready employees
SELECT emp_no, 
	first_name, 
	last_name, 
	title, 
	from_date,
	salary
INTO final_retirement
FROM 
(SELECT emp_no, first_name, last_name, title, from_date, salary, ROW_NUMBER() OVER 
(PARTITION BY (emp_no)
ORDER BY from_date DESC) rn
FROM challenge_dups
) tmp WHERE rn = 1
ORDER BY title;


-- Deliverable #2 Mentorship eligibility (Dups here too)
SELECT e.emp_no, 
	e.first_name, 
	e.last_name, 
	t.title, 
	t.from_date,
	t.to_date
INTO initial_mentor_program
FROM employees AS e
INNER JOIN salaries AS s
ON (e.emp_no = s.emp_no)
INNER JOIN titles AS t
ON (e.emp_no = t.emp_no)
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31');

--final deliverable #2 without dups
SELECT emp_no, 
	first_name, 
	last_name, 
	title, 
	from_date,
	to_date
INTO final_mentor_program
FROM 
(SELECT emp_no, first_name, last_name, title, from_date, to_date, ROW_NUMBER() OVER 
(PARTITION BY (emp_no)
ORDER BY from_date DESC) rn
FROM initial_mentor_program
) tmp WHERE rn = 1
ORDER BY emp_no;

-- Retiring employee count by title
SELECT COUNT(emp_no), title
INTO final_retirement_count_title
FROM final_mentor_program
GROUP BY title;

--count employees with each title with dups
SELECT ce.emp_no, t.title, t.from_date
INTO current_title_count_dups
FROM current_emp as ce
INNER JOIN titles as t
ON (ce.emp_no = t.emp_no);

-- count employees with each title no dups
SELECT emp_no, title, from_date
INTO current_title_count_drop_dups
FROM 
(SELECT emp_no, title, from_date, ROW_NUMBER() OVER 
(PARTITION BY (emp_no)
ORDER BY from_date DESC) rn
FROM current_title_count_dups
) tmp WHERE rn = 1;

--Final title COUNT
SELECT COUNT(emp_no), title
INTO final_title_count
FROM current_title_count_drop_dups
GROUP BY current_title_count_drop_dups.title;