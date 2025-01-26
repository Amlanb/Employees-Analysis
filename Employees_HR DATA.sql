CREATE TABLE employees (
    id VARCHAR(10) PRIMARY KEY,           
    first_name VARCHAR(20),               
    last_name VARCHAR(25),                
    birthdate DATE,                       
    gender VARCHAR(15),                   
    race VARCHAR(50),                    
    department VARCHAR(25),              
    jobtitle VARCHAR(40),                
    location VARCHAR(12),                
    hire_date DATE,                      
    termdate DATE,                       
    location_city VARCHAR(20),           
    location_state VARCHAR(15)           
);

SELECT * FROM employees

-- Questions

-- 1. What is the gender breakdown of employees in the company?

SELECT
	gender,
	COUNT(id) as total_employees
FROM employees
WHERE EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate)) >= 18
GROUP BY 1	


-- 2. What is the race/ethnicity breakdown of employees in the company?

SELECT
	race,
	COUNT(id) as total_employees
FROM employees
WHERE EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate)) >= 18
GROUP BY 1
ORDER BY 2 DESC;

-- 3. What is the age distribution of employees in the company?

SELECT
	CASE
	WHEN age >= 18 AND age <= 24 THEN '18-24'
	WHEN age >= 25 AND age <= 34 THEN '25-34'
	WHEN age >= 35 AND age <= 44 THEN '35-44'
	WHEN age >= 45 AND age <= 54 THEN '45-54'
	WHEN age >= 55 AND age <= 64 THEN '55-64'
	ELSE '65+'
	END as age_group,
	gender,
	COUNT(id) as total_employees
FROM (
	SELECT *, EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate)) as age
	FROM employees
) as subquery
GROUP BY age_group, gender
ORDER BY 1;

-- 4. How many employees work at headquarters versus remote locations?

SELECT 
	location,
	count (id) as total_employees
FROM employees
WHERE EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate)) >= 18
GROUP BY 1;

-- 5. What is the average length of employment for employees who have been terminated?

SELECT 
	ROUND(AVG(EXTRACT(YEAR FROM AGE(termdate, hire_date))), 0) as Average_length_of_employee
FROM employees
	WHERE termdate <= CURRENT_DATE 
	AND termdate IS NOT NULL 
	AND EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate)) >= 18

-- 6. How does the gender distribution vary across departments and job titles--?

SELECT
	department,
	gender,
	COUNT(gender) as gender_counts
FROM employees
WHERE EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate)) >= 18
	AND termdate is NULL
GROUP BY 1,2
ORDER BY 1;

-- 7. What is the distribution of job titles across the company?

SELECT 
	jobtitle,
	COUNT (jobtitle) as count_of_jobtitle
FROM employees
GROUP BY 1
ORDER BY 2 DESC;

-- 8. Which department has the highest turnover rate?

WITH department_counts AS (
    SELECT 
        department, 
        COUNT(*) AS total_employees,
        COUNT(CASE WHEN termdate IS NOT NULL THEN 1 END) AS employees_left
    FROM employees
    WHERE EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate)) >= 18
    GROUP BY department
),
turnover_rates AS (
    SELECT
        department, 
        total_employees,
        employees_left,
        (CAST(employees_left AS FLOAT) / total_employees) * 100 AS turnover_rate
    FROM department_counts
)
SELECT 
    department, 
    total_employees,
    employees_left,
    ROUND(turnover_rate::numeric, 2) AS turnover_rate
FROM turnover_rates
ORDER BY turnover_rate DESC;

-- 9. What is the distribution of employees across locations by state?

SELECT 
	location_state,
	location,
	COUNT(id) as employee_count
FROM employees
WHERE EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate)) >= 18 AND termdate IS NULL
GROUP BY 1, 2
ORDER BY 3 DESC;

-- 10. How has the company's employee count changed over time based on hire and term dates?

WITH hires AS (
    SELECT 
        EXTRACT(YEAR FROM hire_date) AS year, 
        COUNT(id) AS hires
    FROM employees
    WHERE EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate)) >= 18
    GROUP BY 1
),
terminations AS (
    SELECT 
        EXTRACT(YEAR FROM termdate) AS year, 
        COUNT(id) AS terminations
    FROM employees
    WHERE termdate IS NOT NULL AND EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate)) >= 18
    GROUP BY 1
)
SELECT 
    COALESCE(h.year, t.year) AS year,
    COALESCE(h.hires, 0) AS hires,
    COALESCE(t.terminations, 0) AS terminations,
    ROUND((COALESCE(h.hires, 0) - COALESCE(t.terminations, 0))::numeric, 2) AS net_change,
    CASE 
        WHEN COALESCE(h.hires, 0) = 0 THEN 0
        ELSE ROUND(((COALESCE(h.hires, 0) - COALESCE(t.terminations, 0))::numeric / h.hires) * 100, 2)
    END AS net_percent_change
FROM hires h
FULL OUTER JOIN terminations t ON h.year = t.year
WHERE COALESCE(h.year, t.year) <= 2020
ORDER BY 1 ASC;

-- 11. What is the tenure distribution for each department?

SELECT 
	department,
	ROUND(AVG(EXTRACT(YEAR FROM AGE(termdate, hire_date))), 0) AS avg_tenure
FROM employees
WHERE termdate <= CURRENT_DATE 
		AND termdate IS NOT NULL 
		AND EXTRACT(YEAR FROM AGE(birthdate)) >= 18
GROUP BY 1
ORDER BY 2 DESC;

	