-- Ejercicio 1

(SELECT
    job_id,
    job_title,
    'With Salary information' AS salary_info
FROM
    job_postings_fact
WHERE
    salary_year_avg is NOT NULL
    OR
    salary_hour_avg is NOT NULL)

UNION ALL

(SELECT
    job_id,
    job_title,
    'Without Salary information' AS salary_info
FROM
    job_postings_fact
WHERE
    salary_year_avg is  NULL
    AND
    salary_hour_avg is NULL)

ORDER BY
    salary_info DESC, 
	job_id; 

-- Ejercicio 2

SELECT
    jp.job_id, job_title_short, job_location, job_via, skills, type
FROM
    (SELECT
        job_id, job_title_short, job_location, job_via   
    FROM
        january_jobs
    WHERE
        salary_year_avg > 70000
    UNION ALL
    SELECT
        job_id, job_title_short, job_location, job_via 
    FROM
        february_jobs
    WHERE
        salary_year_avg > 70000
    UNION ALL
    SELECT
        job_id, job_title_short, job_location, job_via 
    FROM
        march_jobs
    WHERE
        salary_year_avg > 70000) AS jp
LEFT JOIN(SELECT
            sj.job_id,
            s.skills,
            s.type
        FROM
            skills_job_dim AS sj
        LEFT JOIN skills_dim AS s ON sj.skill_id = s.skill_id
        ORDER BY
            sj.job_id) AS s ON jp.job_id = s.job_id

-- Ejercicio 3

SELECT
    s.skills AS skill,
    EXTRACT(YEAR FROM q1.job_posted_date) AS year,
    EXTRACT(MONTH FROM q1.job_posted_date) AS month,    
    COUNT(q1.job_id) AS total_jobs
FROM
    (SELECT *
    FROM january_jobs
    UNION ALL
    SELECT *
    FROM february_jobs
    UNION ALL
    SELECT *
    FROM march_jobs) AS q1
    INNER JOIN skills_job_dim AS sj ON q1.job_id = sj.job_id
    INNER JOIN skills_dim AS s ON sj.skill_id = s.skill_id
GROUP BY
    skill, year, month
