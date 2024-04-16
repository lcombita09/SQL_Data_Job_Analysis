-- Ejercicio 1
SELECT
    job_id,
    job_title,
    salary_year_avg,
    CASE
        WHEN salary_year_avg >= 100000 THEN 'High Salary'
        WHEN salary_year_avg BETWEEN 60000 AND 99000 THEN 'Standard Salary'
        ELSE 'Low Salary'
    END AS salary_category
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
    AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC;

-- Ejercicio 2
SELECT
    CASE
        WHEN job_work_from_home = TRUE THEN 'WFH'
        ELSE 'NO WFH'
    END AS work_from_home_policy,
    COUNT(DISTINCT company_id) AS count_company_that_allows_WFH
FROM
    job_postings_fact
GROUP BY
    work_from_home_policy;

-- Ejercicio 3
SELECT
    job_id,
    salary_year_avg,
    CASE
        WHEN job_title ILIKE '%Senior%' THEN 'Senior'
        WHEN job_title ILIKE '%Lead%' OR job_title ILIKE '%Manager%'  THEN 'Lead/Manager'
        WHEN job_title ILIKE '%Junior%' OR job_title ILIKE '%Entry%'  THEN 'Lead/Manager'
        ELSE 'Not Specified'
    END AS experience_level,
    CASE
        WHEN job_work_from_home = TRUE THEN 'Yes'
        ELSE 'No'
    END AS remote_option
FROM
    job_postings_fact
WHERE
    salary_year_avg IS NOT NULL
ORDER BY
    job_id;