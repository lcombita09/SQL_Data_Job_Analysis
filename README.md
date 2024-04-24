# Data Jobs Market Analysis

Welcome to my GitHub repository where I delve into an extensive dataset of over 787,000 job postings, spanning an entire year from December 31, 2022, to December 31, 2023. This project is designed to unearth valuable insights into the data science job market, highlighting not only the volume and frequency of job postings but also identifying key trends in job demands and salary structures across different regions and roles.

The dataset comprises information from more than 140,000 companies, reflecting a diverse and vibrant hiring landscape. An analysis of monthly trends revealed a significant spike in job postings at the start of 2023, with January alone accounting for over 92,000 jobs. This suggests a robust seasonal hiring trend in the data science industry.

Further exploration into job roles shows that Data Analyst positions are the most sought-after in 2023, underscoring their indispensable role in leveraging data for business insights. Moreover, Data Scientist enjoy the highest average salaries, especially at senior levels, indicating the industry’s recognition of the crucial technical skills they bring to the table.

For me, as an aspiring data scientist/engineer/analyst, this project is not just about understanding current market trends but also about pinpointing where the opportunities lie and what skills are most valued. Through this analysis, I aim to align my learning path with the demands of the market, enhancing my prospects and preparing myself to thrive in a competitive job environment.

![Total Job postings and salaries per role](images\job_postings_and_salaries.png)
*Bargraph displaying the total number of job postings and the average yearly salary by job title*

SQL Queries: [data_jobs_project](/data_jobs_project/)

# Background

As an aspiring data specialits, understanding the dynamics of the job market is crucial. This project was initiated to explore the demand for data roles across major European countries and remote opportunities, focusing on job availability, salary trends, and required skills.

### Main questions I wanted to answer through this project:

1. What is the most demanded position for remote jobs?

2. What is the most demanded position for jobs in Europe?

3. Which European country has the highest demand for data professionals?

4. What are the top skills required for the main data roles?

# Tools Used

- **SQL**: Employed for querying and conducting data analysis within the PostgreSQL database.
- **PostgreSQL**: Served as the robust database management system to store and manage the job postings data.
- **Visual Studio Code**: My preferred code editor for writing and executing SQL queries efficiently.
- **Git**: Utilized for version control, allowing me to manage changes to the SQL scripts throughout the project lifecycle.
- **GitHub**: Hosted the repository for this project, facilitating easy sharing and collaboration, and serving as a portfolio of my work for potential employers and collaborators.
- **Python**: Used Python and Matplotlib library to generate the charts displayed in this Readme

# Analysis

The analysis was divided into several parts, each focusing on different aspects of the job market:

- General overview of job postings and companies.
- Detailed examination of job postings by location and salary.
- Focused analysis on European job market trends and remote work opportunities.

The main focus of my analysis was answering this questions:

### 1.  What is the most demanded position for remote jobs?
To analyze the demand for various data roles in remote jobs, I first established a view called european_job_postings which encompasses job postings located in Europe or tagged as remote-friendly. Utilizing this view, I executed a query to filter for remote jobs (job_location = 'Anywhere'). This query aggregates the data to count the total postings for each job title and calculates the average yearly salary for these roles, providing a clear picture of the most demanded positions in the remote job market. 

```sql
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
```
Here is the breakdown of the most demanded position for remote jobs:

The most sought-after remote position is Data Engineer, showing both high demand and competitive salaries, with Data Scientists not far behind in salary levels

| job_title           | total_remote_jobs | avg_yearly_salary |
|---------------------|-------------------|-------------------|
| Data Engineer       | 21261             | 132363.55         |
| Data Scientist      | 14534             | 144398.25         |
| Data Analyst        | 13331             | 94769.85          |
| Senior Data Engineer| 6564              | 148245.25         |
| Senior Data Scientist| 3809             | 163798.15         |
| Software Engineer   | 2918              | 122367.07         |
| Business Analyst    | 2786              | 97113.83          |
| Senior Data Analyst | 2352              | 113335.15         |
| Machine Learning Engineer| 1480         | 148670.45         |
| Cloud Engineer      | 571               | 147111.11         |


### 2. What is the most demanded position for jobs in Europe?
To analyze the demand for various data roles in European jobs, I first established a view called european_job_postings which encompasses job postings located in Europe or tagged as remote-friendly. Utilizing this view, I executed a query to filter for remote jobs (job_location != 'Anywhere'). This query aggregates the data to count the total postings for each job title and calculates the average yearly salary for these roles, providing a clear picture of the most demanded positions in the European job market.


```sql
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
```

Here is the breakdown of the most demanded position for remote jobs:

Data Analyst tops the chart as the most demanded position in Europe, indicating strong analytical skills are in high demand across various industries

| job_title             | total_jobs | avg_yearly_salary |
|-----------------------|------------|-------------------|
| Data Analyst          | 52926      | 91167.09          |
| Data Engineer         | 51061      | 119486.14         |
| Data Scientist        | 43252      | 113050.36         |
| Software Engineer     | 13507      | 104905.44         |
| Business Analyst      | 12247      | 84925.00          |
| Senior Data Engineer  | 9814       | 128227.80         |
| Senior Data Scientist | 8367       | 134733.11         |
| Senior Data Analyst   | 5969       | 104675.28         |
| Machine Learning Engineer | 4329    | 114211.77         |
| Cloud Engineer        | 4233       | 107192.41         |


### 3. Which European country has the highest demand for data professionals?
To determine which European country shows the highest demand for data professionals, I utilized the european_job_postings view, which includes job postings from European countries and remote jobs. From this data subset, I crafted a query using two Common Table Expressions (CTEs). The first CTE, jobs_by_country_and_role, aggregates the total number of job postings by country and by job title, excluding remote jobs. The second CTE, total_jobs_by_country, calculates the total number of job postings per country. These CTEs enable a sorted display of countries with the highest job demand, alongside the most demanded roles within those countries, thus providing a clear perspective on where data professionals are most sought after.

``` sql
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
```

Here is the breakdown of countries with more demand for data professionals:

France leads with significant demand for Data Analysts, Engineers, and Scientists, highlighting the country's thriving tech sector. Considering learning French could provide a competitive edge in the European job market.

![Top 10 European Countries with more demand for data professionals](images\jobs_by_country.png)

*Bargraph of Top 10 Countries with most job postings in Europe*

### 4. What are the top skills required for the main data roles?

To uncover the top skills required for the primary data roles within the European and remote job markets, I combined information from the european_job_postings, skills_dim, and skills_job_dim tables. By using inner joins, I ensured only jobs with associated skills were included in the analysis. The query is structured around two Common Table Expressions (CTEs): the first CTE, top_data_analyst_skills, groups and counts the job postings by skill for a specified data role, in this case, 'Data Analyst'. The second CTE, total_jobs, tallies the total number of job postings for the role. With this setup, I then calculate the percentage of job postings demanding each skill, providing a clear insight into which skills are most critical for Data Analysts in the current job market. I did this, also for Data Scientis and Data Engineer roles.

```sql
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
```

Here is the breakdown of top skills required for the main data roles:

- SQL, Python, and Excel are critical for Data Analysts, indicating foundational tools for data manipulation and analysis are essential in this role. Choosing between Power BI or Tableau could further enhance your analytical capabilities

- Similar queries for Data Scientist and Data Engineer roles elucidate that Python and SQL are foundational, with cloud technologies and specific tools like Spark also critical for advanced data processing roles

- The findings emphasize the importance of mastering Python and SQL across all major data roles, suggesting these should be the initial focus for anyone aiming to enter the data science field in Europe. 


![Top Skills Per Data Role](images\top_skills_by_role.png)

*Bar graph visualizing the 5 Top Skills by the three main data roles*

### Top findings:

- The most sought-after remote position is Data Engineer, showing both high demand and competitive salaries, with Data Scientists not far behind in salary levels.

- Data Analyst tops the chart as the most demanded position in Europe, indicating strong analytical skills are in high demand across various industries.

- France leads with significant demand for Data Analysts, Engineers, and Scientists, highlighting the country's thriving tech sector. Considering learning French could provide a competitive edge in the European job market

- The findings emphasize the importance of mastering Python and SQL across all major data roles, suggesting these should be the initial focus for anyone aiming to enter the data science field in Europe. 

# What I Learned

Through this project, I enhanced my SQL querying skills, especially in complex data aggregation and cross-table analyses. I gained valuable insights into the highly demanded skills in the data jobs market and the importance of geographical considerations in job searching.

# Conclusions

### Insights

1.  **Most demanded position for remote jobs**: The most sought-after remote position is Data Engineer, showing both high demand and competitive salaries, with Data Scientists not far behind in salary levels

2. **Most demanded position for jobs in Europe**: Data Analyst tops the chart as the most demanded position in Europe, indicating strong analytical skills are in high demand across various industries

3. **European country with highest demand for data professionals**: France leads with significant demand for Data Analysts, Engineers, and Scientists, highlighting the country's thriving tech sector. Considering learning French could provide a competitive edge in the European job market.

4. **Top skills required for the main data roles**: The findings emphasize the importance of mastering Python and SQL across all major data roles, suggesting these should be the initial focus for anyone aiming to enter the data science field in Europe. 

### Final Thoughts

This project highlights significant geographic disparities in job availability and salary, emphasizing the high demand for data science skills across Europe. These findings can aid aspiring data specialists in targeting their job search and skill development. Future work could expand into predictive analytics to forecast job market trends.