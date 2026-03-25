-- HR ATTRITION ANALYSIS USING SQL

-- 1. Gender breakdown of active employees
SELECT 
    gender, 
    COUNT(*) AS employee_count
FROM human_resources
WHERE termination_date IS NULL
GROUP BY gender;

-- 2. Race distribution of active employees
SELECT 
    race, 
    COUNT(*) AS employee_count
FROM human_resources
WHERE termination_date IS NULL
GROUP BY race;

-- 3. Age distribution of active employees
SELECT 
    CASE 
        WHEN age BETWEEN 18 AND 24 THEN '18-24'
        WHEN age BETWEEN 25 AND 34 THEN '25-34'
        WHEN age BETWEEN 35 AND 44 THEN '35-44'
        WHEN age BETWEEN 45 AND 54 THEN '45-54'
        WHEN age BETWEEN 55 AND 64 THEN '55-64'
        ELSE '65+'
    END AS age_group,
    COUNT(*) AS employee_count
FROM human_resources
WHERE termination_date IS NULL
GROUP BY age_group
ORDER BY age_group;

-- 4. Work location distribution
SELECT 
    work_location, 
    COUNT(*) AS employee_count
FROM human_resources
WHERE termination_date IS NULL
GROUP BY work_location;

-- 5. Average tenure of terminated employees
SELECT 
    ROUND(AVG(TIMESTAMPDIFF(YEAR, hire_date, termination_date)), 2) AS avg_tenure
FROM human_resources
WHERE termination_date IS NOT NULL
AND termination_date <= CURDATE();

-- 6. Job title distribution
SELECT 
    job_title, 
    COUNT(*) AS employee_count
FROM human_resources
WHERE termination_date IS NULL
GROUP BY job_title
ORDER BY employee_count DESC;

-- 7. Department-wise attrition rate
SELECT 
    department,
    COUNT(*) AS total_employees,
    COUNT(CASE 
        WHEN termination_date IS NOT NULL 
        AND termination_date <= CURDATE() 
        THEN 1 
    END) AS terminated_employees,
    ROUND(
        COUNT(CASE 
            WHEN termination_date IS NOT NULL 
            AND termination_date <= CURDATE() 
            THEN 1 
        END) * 100.0 / COUNT(*), 
    2) AS attrition_rate
FROM human_resources
GROUP BY department
ORDER BY attrition_rate DESC;

-- 8. Employee distribution by city
SELECT 
    city, 
    COUNT(*) AS employee_count
FROM human_resources
WHERE termination_date IS NULL
GROUP BY city
ORDER BY employee_count DESC;

-- 9. Hiring vs termination trend over time
SELECT 
    YEAR(hire_date) AS year,
    COUNT(*) AS hires,
    SUM(CASE 
        WHEN termination_date IS NOT NULL 
        AND termination_date <= CURDATE() 
        THEN 1 ELSE 0 
    END) AS terminations,
    COUNT(*) - SUM(CASE 
        WHEN termination_date IS NOT NULL 
        AND termination_date <= CURDATE() 
        THEN 1 ELSE 0 
    END) AS net_change
FROM human_resources
GROUP BY YEAR(hire_date)
ORDER BY year;

-- 10. Average tenure by department
SELECT 
    department, 
    ROUND(AVG(DATEDIFF(termination_date, hire_date)/365), 2) AS avg_tenure
FROM human_resources
WHERE termination_date IS NOT NULL 
AND termination_date <= CURDATE()
GROUP BY department
ORDER BY avg_tenure DESC;
