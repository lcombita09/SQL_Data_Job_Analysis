-- Ejercicio 1
SELECT    
    top_skills.skill_id,
    skills_dim.skills,
    top_skills.times_skill_in_jobs   
FROM
    skills_dim
INNER JOIN(
        SELECT
            skill_id,
            COUNT(job_id) AS times_skill_in_jobs
        FROM
            skills_job_dim
        GROUP BY
            skill_id
        ORDER BY
            times_skill_in_jobs DESC
        LIMIT
            5) AS top_skills ON skills_dim.skill_id = top_skills.skill_id;
    
-- Ejercicio 2
SELECT
    *,
    CASE
        WHEN total_job_postings > 50 THEN 'LARGE'
        WHEN total_job_postings BETWEEN 10 AND 50 THEN 'MEDIUM'
        ELSE 'SMALL'
    END AS company_size
FROM 
    (SELECT
        jp.company_id,
        c.name,
        COUNT(jp.job_id) AS total_job_postings
    FROM
        job_postings_fact AS jp
        LEFT JOIN company_dim AS c ON jp.company_id = c.company_id
    GROUP BY
        jp.company_id,
        c.name
    ORDER BY
        jp.company_id) AS jobs_per_company;

-- Ejercicio 3
SELECT
    jp.company_id,
    c.name,
    AVG(jp.salary_year_avg) AS yearly_avg_salary
FROM
    job_postings_fact AS jp
    LEFT JOIN company_dim AS c ON jp.company_id = c.company_id
GROUP BY
    jp.company_id,
    c.name
HAVING
    AVG(jp.salary_year_avg) > (SELECT AVG(salary_year_avg) FROM job_postings_fact)
ORDER BY
    jp.company_id;

-- Segunda Opcion de Query
SELECT
    company_dim.name,
    salary_by_company.yearly_avg_salary
FROM
    company_dim
LEFT JOIN(SELECT
            company_id,
            AVG(salary_year_avg) AS yearly_avg_salary
        FROM
            job_postings_fact
        GROUP BY
            company_id
) AS salary_by_company ON company_dim.company_id = salary_by_company.company_id
WHERE
    salary_by_company.yearly_avg_salary > (SELECT AVG(salary_year_avg) FROM job_postings_fact);


-- Ejercicio 4
WITH jobs_per_company AS(
    SELECT
        company_id,
        COUNT(DISTINCT job_title) AS n_jobs_titles
    FROM
        job_postings_fact
    GROUP BY
        company_id
    )
SELECT
    j.company_id,
    c.name,
    j.n_jobs_titles
FROM
    jobs_per_company AS j
LEFT JOIN
    company_dim AS c ON j.company_id= c.company_id
ORDER BY
    j.n_jobs_titles DESC
LIMIT 10;

-- Ejercicio 5
WITH avg_salary_country AS(
    SELECT
        job_country,
        AVG(salary_year_avg) AS salary_avg_country
    FROM
        job_postings_fact
    GROUP BY
        job_country
)
SELECT
    jp.job_id,
    jp.job_title,
    c.name,
    jp.salary_year_avg,
    CASE
        WHEN jp.salary_year_avg >= ac.salary_avg_country THEN 'Above Average'
        ELSE 'Below Average'
    END AS salary_category,
    EXTRACT(MONTH FROM jp.job_posted_date) AS month
FROM
    job_postings_fact AS jp
INNER JOIN
    company_dim AS c ON jp.company_id = c.company_id
INNER JOIN
    avg_salary_country AS ac ON jp.job_country = ac.job_country
ORDER BY
    month DESC;

-- Ejercicio 6

WITH skills_per_job AS(
    SELECT
        jp.company_id,
        COUNT(DISTINCT s.skill_id) AS total_unique_skills
    FROM
        skills_job_dim as s
    LEFT JOIN job_postings_fact AS jp ON s.job_id = jp.job_id
    GROUP BY
    jp.company_id
),
max_salary AS(
    SELECT
        jp.company_id,
        c.name AS company_name,
        MAX(jp.salary_year_avg) AS max_salary
    FROM
        job_postings_fact AS jp
    LEFT JOIN company_dim AS c ON jp.company_id = c.company_id
    GROUP BY
    jp.company_id,
    c.name
    ORDER BY
    jp.company_id
)
SELECT
    ms.company_name,
    ms.max_salary,
    spj.total_unique_skills
FROM
    max_salary AS ms
LEFT JOIN skills_per_job spj ON ms.company_id = spj.company_id
ORDER BY
    ms.company_name;



