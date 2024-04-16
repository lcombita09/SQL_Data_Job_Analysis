-- Ejercicio 1
SELECT
    job_schedule_type,
    AVG(salary_year_avg) AS yearly_avg,
    AVG(salary_hour_avg ) AS hourly_avg
FROM
    job_postings_fact
WHERE
    job_posted_date::DATE > '2023-06-01'
GROUP BY
    job_schedule_type
ORDER BY
    job_schedule_type;

-- Ejercicio 2
SELECT
    EXTRACT(MONTH FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York') AS month,
    COUNT(job_id)
FROM
    job_postings_fact
GROUP BY
    month
ORDER BY
    month;

-- Ejericio 3
SELECT
    c.name AS company,
    COUNT(jp.job_id) AS posting_count
FROM
    job_postings_fact AS jp
LEFT JOIN
    company_dim AS c ON jp.company_id = c.company_id
WHERE
    EXTRACT(QUARTER FROM jp.job_posted_date) = 2
    AND
    jp.job_health_insurance = 'TRUE'
GROUP BY
    c.name
HAVING
    COUNT(jp.job_id) > 0
ORDER BY
    posting_count DESC;

-- Ejercicio 4

-- January
CREATE TABLE january_jobs AS
    SELECT *
    FROM
        job_postings_fact
    WHERE
        EXTRACT(MONTH FROM job_posted_date) = 1;

-- February
CREATE TABLE february_jobs AS
    SELECT *
    FROM
        job_postings_fact
    WHERE
        EXTRACT(MONTH FROM job_posted_date) = 2;

-- March
CREATE TABLE march_jobs AS
    SELECT *
    FROM
        job_postings_fact
    WHERE
        EXTRACT(MONTH FROM job_posted_date) = 3;
    
