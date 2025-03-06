SELECT * FROM hr;


-- QUESTIONS

-- 1. What is the gender breakdown of employees in the company?
SELECT gender, count(*)
FROM hr
WHERE age >= 20 AND termdate = '0000-00-00'
GROUP BY gender;

-- 2. What is the race/ethnicity breakdown of employees in the company?
SELECT race, COUNT(*) AS count
FROM hr
WHERE age >= 20 AND termdate = '0000-00-00'
GROUP BY race
ORDER BY count(*) DESC;

-- 3. What is the age distribution of employees in the company?
SELECT MIN(age) AS youngest, MAX(age) AS oldest
FROM hr
WHERE age >= 20 AND termdate = '0000-00-00';
		
SELECT 
	CASE WHEN age>= 20 AND age <= 26 THEN '20-26'
		 WHEN age>= 27 AND age <= 36 THEN '27-36'
         WHEN age>= 37 AND age <= 46 THEN '37-46'
         WHEN age>= 47 AND age <= 56 THEN '47-56'
         WHEN age>= 57 AND age <= 66 THEN '57-66'
         ELSE '67+'
	END AS age_group, count(*) AS count
FROM hr
WHERE age >= 20 AND termdate = '0000-00-00'
GROUP BY age_group
ORDER BY age_group;

SELECT 
	CASE WHEN age>= 20 AND age <= 26 THEN '20-26'
		 WHEN age>= 27 AND age <= 36 THEN '27-36'
         WHEN age>= 37 AND age <= 46 THEN '37-46'
         WHEN age>= 47 AND age <= 56 THEN '47-56'
         WHEN age>= 57 AND age <= 66 THEN '57-66'
         ELSE '67+'
	END AS age_group, gender, count(*) AS count
FROM hr
WHERE age >= 20 AND termdate = '0000-00-00'
GROUP BY age_group, gender
ORDER BY age_group, gender;

-- 4. How many employees work at headquarters versus remote locations?
SELECT location, count(*) AS count
FROM hr
WHERE age >= 20 AND termdate = '0000-00-00'
GROUP BY location;

-- 5. What is the average length of employment for employees who have been terminated?
SELECT 
	round(avg(datediff(termdate, hire_date))/365,0) AS avg_length_employment
FROM hr
WHERE termdate <=curdate() AND 	termdate <> '0000-00-00' AND age >= 20;

-- 6. How does the gender distribution vary across departments and job titles?
SELECT department, gender, count(*) AS count
FROM hr
WHERE age >= 20 AND termdate = '0000-00-00'
GROUP BY department, gender
ORDER BY department;

-- 7. What is the distribution of job titles across the company?
SELECT jobtitle, count(*) AS count
FROM hr
WHERE age >= 20 AND termdate = '0000-00-00'
GROUP BY jobtitle
ORDER BY jobtitle DESC;

-- 8. Which department has the highest turnover rate?
SELECT department, total_count, terminated_count, terminated_count/total_count AS termination_rate
FROM (
	SELECT department, 
    count(*) AS total_count,
    sum(CASE WHEN termdate <> '0000-00-00' AND termdate <= curdate() THEN 1 ELSE 0 END) AS terminated_count
FROM hr
WHERE age >= 20
GROUP BY department
) AS subquery
ORDER BY termination_rate DESC;
    
-- 9. What is the distribution of employees across locations by city and state?
SELECT location_state, count(*) AS count
FROM hr
WHERE age >= 20 AND termdate = '0000-00-00'
GROUP BY location_state
ORDER BY count DESC; 

-- 10. How has the company's employee count changed over time based on hire and term dates?
SELECT year, hires, terminations, hires-terminations AS net_change,
	round((hires-terminations)/hires * 100,2) AS net_change_percent
FROM (
	  SELECT 
		year(hire_date) AS year,
		count(*) AS hires, 
        sum(CASE WHEN termdate <> '0000-00-00' AND termdate <= curdate() THEN 1 ELSE 0 END) AS terminations
FROM hr
WHERE age >=20
GROUP BY year(hire_date)  
) AS subquery
ORDER BY year ASC;

-- 11. What is the tenure distribution for each department?
SELECT department, round(avg(datediff(termdate, hire_date)/365),0) AS avg_tenure
FROM hr
WHERE termdate <= curdate() AND termdate <> '0000-00-00' AND age >= 20
GROUP BY department;