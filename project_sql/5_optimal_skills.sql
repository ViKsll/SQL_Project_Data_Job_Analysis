WITH demanded_skills AS (
SELECT 
   skills_dim.skill_id,
   skills_dim.skills, 
   COUNT(skills_job_dim.job_id) AS skills_in_demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Analyst' AND job_work_from_home = 'True' AND salary_year_avg IS NOT NULL
GROUP BY skills_dim.skill_id
), average_salary AS (
SELECT 
   skills_job_dim.skill_id, 
   ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Analyst' AND job_work_from_home = 'True' AND salary_year_avg IS NOT NULL
GROUP BY skills_job_dim.skill_id
)
SELECT 
    demanded_skills.skill_id,
    demanded_skills.skills,
    skills_in_demand_count,
    avg_salary
FROM demanded_skills
INNER JOIN average_salary ON demanded_skills.skill_id = average_salary.skill_id
WHERE skills_in_demand_count > 10
ORDER BY avg_salary DESC, skills_in_demand_count DESC
LIMIT 25;