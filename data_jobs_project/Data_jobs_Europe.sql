-- Creating a view to filter job postings from major European countries and remote jobs.
CREATE VIEW european_job_postings AS
SELECT *
FROM job_postings_fact
WHERE 
    job_country IN ('UK', 'Portugal', 'France', 'Switzerland', 'Germany', 
                    'Spain', 'Italy', 'Netherlands', 'Ireland', 'Belgium', 
                    'Sweden', 'Norway', 'Denmark', 'Austria', 'Poland')
    OR
    job_location = 'Anywhere';

-- Analyzing the distribution of remote jobs along with their average salaries.
SELECT
    job_title_short AS job_title,
    COUNT(*) AS total_remote_jobs,
    AVG(salary_year_avg) AS avg_yearly_salary
FROM european_job_postings
WHERE
    job_location = 'Anywhere'
GROUP BY
    job_title_short
ORDER BY
    total_remote_jobs DESC;

/* The most sought-after remote position is Data Engineer, showing both high demand
   and competitive salaries, with Data Scientists not far behind in salary levels. */

-- Analyzing job postings within Europe to identify top job positions.
SELECT
    job_title_short AS job_title,
    COUNT(*) AS total_jobs,
    AVG(salary_year_avg) AS avg_yearly_salary
FROM european_job_postings
WHERE
    job_location != 'Anywhere'
GROUP BY
    job_title_short
ORDER BY
    total_jobs DESC;

/* Data Analyst tops the chart as the most demanded position in Europe, indicating
   strong analytical skills are in high demand across various industries. */

-- Detailed analysis of job postings by country within Europe.
WITH jobs_by_country_and_role AS (
    SELECT
        job_country AS country,
        job_title_short AS job_title,
        COUNT(*) AS total_jobs    
    FROM european_job_postings
    WHERE
        job_location != 'Anywhere'
    GROUP BY
        job_country, job_title_short
), 
total_jobs_by_country AS (
    SELECT
        job_country AS country,
        COUNT(*) AS total_country_jobs    
    FROM european_job_postings
    WHERE
        job_location != 'Anywhere'
    GROUP BY
        job_country
)

SELECT
    jobs_by_country_and_role.country,
    jobs_by_country_and_role.job_title,
    jobs_by_country_and_role.total_jobs
FROM jobs_by_country_and_role
LEFT JOIN total_jobs_by_country
ON jobs_by_country_and_role.country = total_jobs_by_country.country
ORDER BY
    total_jobs_by_country.total_country_jobs DESC,
    jobs_by_country_and_role.total_jobs DESC;


/* France leads with significant demand for Data Analysts, Engineers, and Scientists,
   highlighting the country's thriving tech sector. Considering learning French could
   provide a competitive edge in the European job market. */

-- Examining job postings by company within Europe to identify major employers.
SELECT
    c.name AS company_name,
    COUNT(jp.job_id) AS total_jobs,
    AVG(jp.salary_year_avg) AS yearly_salary_avg
FROM european_job_postings AS jp
INNER JOIN company_dim AS c ON jp.company_id = c.company_id
WHERE
    job_location != 'Anywhere'
GROUP BY
    company_name
ORDER BY
    total_jobs DESC;

/* Notable tech giants such as Capgemini, Randstad, and Accenture dominate, with 'Confidenziale'
   showing high privacy in job listings, possibly indicating sensitive or high-profile positions. */

-- Analysis of the average number of skills demanded by job title.
SELECT
    jp.job_title_short AS title,
    ROUND(AVG(s.total_skills), 0) AS avg_skills_demanded,
    AVG(jp.salary_year_avg) AS yearly_salary_avg
FROM european_job_postings AS jp
INNER JOIN (
    SELECT
        job_id,
        COUNT(skill_id) AS total_skills
    FROM skills_job_dim
    GROUP BY job_id
) AS s ON jp.job_id = s.job_id
GROUP BY
    jp.job_title_short;

/* Senior Data Engineer positions require a high level of expertise, averaging around 7 skills,
   underscoring the technical complexity and responsibility associated with this role. */

-- Analyzing the top skills demanded for Data Analysts in Europe.
WITH top_data_analyst_skills AS (
    SELECT
        s.skills AS skill,
        COUNT(jp.job_id) AS jobs_demanded_skill
    FROM european_job_postings AS jp
    INNER JOIN skills_job_dim AS sj ON jp.job_id = sj.job_id
    INNER JOIN skills_dim AS s ON sj.skill_id = s.skill_id
    WHERE
        jp.job_title_short = 'Data Analyst'
    GROUP BY
        s.skills
),
total_jobs AS (
    SELECT COUNT(*) AS total_jobs
    FROM european_job_postings
    WHERE job_title_short = 'Data Analyst'
)
SELECT
    t.skill,
    t.jobs_demanded_skill,
    ROUND((t.jobs_demanded_skill * 100.0 / total.total_jobs), 2) AS percentage_of_jobs
FROM top_data_analyst_skills AS t, total_jobs AS total
ORDER BY
    t.jobs_demanded_skill DESC
LIMIT 5;

/* SQL, Python, and Excel are critical for Data Analysts, indicating foundational tools for
   data manipulation and analysis are essential in this role. Choosing between Power BI or Tableau
   could further enhance your analytical capabilities. */


WITH top_data_scientist_skills AS (
    SELECT
        s.skills AS skill,
        COUNT(jp.job_id) AS jobs_demanded_skill
    FROM european_job_postings AS jp
    INNER JOIN skills_job_dim AS sj ON jp.job_id = sj.job_id
    INNER JOIN skills_dim AS s ON sj.skill_id = s.skill_id
    WHERE
        jp.job_title_short = 'Data Scientist'
    GROUP BY
        s.skills
),

total_jobs AS (
    SELECT COUNT(*) AS total_jobs
    FROM european_job_postings
    WHERE job_title_short = 'Data Scientist'
)

SELECT
    t.skill,
    t.jobs_demanded_skill,
    ROUND((t.jobs_demanded_skill * 100.0 / total.total_jobs), 2) AS percentage_of_jobs
FROM top_data_scientist_skills t, total_jobs total
ORDER BY
    t.jobs_demanded_skill DESC
LIMIT 5;


WITH top_data_engineer_skills AS (
    SELECT
        s.skills AS skill,
        COUNT(jp.job_id) AS jobs_demanded_skill
    FROM european_job_postings AS jp
    INNER JOIN skills_job_dim AS sj ON jp.job_id = sj.job_id
    INNER JOIN skills_dim AS s ON sj.skill_id = s.skill_id
    WHERE
        jp.job_title_short = 'Data Engineer'
    GROUP BY
        s.skills
),

total_jobs AS (
    SELECT COUNT(*) AS total_jobs
    FROM european_job_postings
    WHERE job_title_short = 'Data Engineer'
)

SELECT
    t.skill,
    t.jobs_demanded_skill,
    ROUND((t.jobs_demanded_skill * 100.0 / total.total_jobs), 2) AS percentage_of_jobs
FROM top_data_engineer_skills t, total_jobs total
ORDER BY
    t.jobs_demanded_skill DESC
LIMIT 5;

-- Similar queries for Data Scientist and Data Engineer roles elucidate that Python and SQL
-- are foundational, with cloud technologies and specific tools like Spark also critical for
-- advanced data processing roles.

/* The findings emphasize the importance of mastering Python and SQL across all major data roles,
   suggesting these should be the initial focus for anyone aiming to enter the data science field in Europe. */