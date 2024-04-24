-- Query to count the total number of job postings in the database.
SELECT
    COUNT(*) AS total_jobs_postings
FROM job_postings_fact;

/* Result indicates there are over 787k job postings, providing a substantial dataset
   for further analysis. */

-- Query to count the total number of companies involved in the recruitment process.
SELECT
    COUNT(*) AS total_companies
FROM company_dim;

-- There are more than 140,000 companies, reflecting a diverse and active job market.

-- Determine the range of dates during which job data was collected.
SELECT
   MIN(job_posted_date) AS first_date,
   MAX(job_posted_date) AS last_date
FROM job_postings_fact;

/* Jobs were posted between 2022-12-31 and 2023-12-31, indicating the data covers
   exactly one year. */

-- Monthly distribution of job postings to identify peak hiring periods.
SELECT
    EXTRACT(YEAR FROM job_posted_date) AS posting_year,
    EXTRACT(MONTH FROM job_posted_date) AS posting_month,
    COUNT(*) AS total_jobs_postings
FROM job_postings_fact
GROUP BY
    posting_year, posting_month
ORDER BY
    posting_year, posting_month;

/* January 2023 saw the highest number of postings, with over 92,000 jobs, suggesting
   a significant spike in hiring activity at the start of the year. */

-- Analysis of the frequency of job positions posted.
SELECT
    job_title_short AS job_title,
    COUNT(*) as total_jobs_postings
FROM job_postings_fact
GROUP BY
    job_title_short
ORDER BY
    total_jobs_postings DESC;

/* Data Analyst emerges as the most in-demand position in 2023, indicating its critical
   role in today's data-driven economy. */

-- Examining average salaries alongside the demand for different job positions.
SELECT
    job_title_short AS job_title,
    COUNT(*) as total_jobs_postings,
    AVG(salary_year_avg) AS salary_avg   
FROM job_postings_fact
GROUP BY
    job_title_short
ORDER BY
    total_jobs_postings DESC;

/* Data Scientist command the highest average salaries, particularly at senior levels,
   reflecting the high value and demand for this skill set in the job market. */

/* This concludes our initial analysis, setting the stage for more detailed exploration
   of job trends, particularly in Europe and for remote positions, aligning with current
   geographic and work preferences. */
