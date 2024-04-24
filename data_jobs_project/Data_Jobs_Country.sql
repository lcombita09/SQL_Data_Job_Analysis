-- Analyzing the distribution of job postings by country.
SELECT
    job_country AS country,
    COUNT(*) AS total_jobs_postings
FROM job_postings_fact    
GROUP BY
    job_country
ORDER BY
    total_jobs_postings DESC;

/* The USA leads with the highest number of job postings in 2023, followed by India.
   The large gap of over 150,000 fewer postings in India compared to the USA highlights
   significant geographic disparities in job availability. */

-- Exploring average annual salary information by country.
SELECT
    job_country AS country,
    COUNT(*) AS total_jobs_postings,
    AVG(salary_year_avg) AS yearly_average_salary
FROM job_postings_fact
GROUP BY
    job_country
HAVING
    AVG(salary_year_avg) IS NOT NULL
ORDER BY
    yearly_average_salary DESC,
    total_jobs_postings DESC;

/* This analysis reveals high average salaries in countries like Belarus, Russia, and the Bahamas.
   Such figures indicate that salaries are likely reported in local currencies, which can distort
   comparisons without currency conversion and economic context. */

-- Detailed analysis of job demand and average salaries by country and position, focusing on the top 10 job markets.
SELECT
    job_country AS country,
    job_title_short AS position,
    COUNT(*) AS total_jobs_postings,
    AVG(salary_year_avg) AS yearly_average_salary
FROM job_postings_fact
GROUP BY
    job_country, job_title_short
ORDER BY
    total_jobs_postings DESC
LIMIT 10;

/* The Data Analyst role in the United States dominates with over 67,000 postings,
   boasting an average annual salary exceeding $94,000 USD. This highlights the high
   demand and lucrative opportunities for Data Analysts in the U.S. job market. */

