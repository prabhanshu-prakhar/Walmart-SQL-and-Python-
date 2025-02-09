create database wallmart_db;
use wallmart_db;
SELECT 
    *
FROM
    wallmart;
SELECT 
    COUNT(*)
FROM
    wallmartl;
SELECT 
    payment_method, COUNT(*)
FROM
    wallmart
GROUP BY payment_method;

SELECT 
    COUNT(DISTINCT Branch)
FROM
    wallmart;
SELECT 
    payment_method, COUNT(*), SUM(quantity)
FROM
    wallmart
GROUP BY payment_method;

SELECT *
FROM (
    SELECT 
        branch,
        category,
        AVG(rating) AS avg_rating,
        RANK() OVER (PARTITION BY branch ORDER BY AVG(rating) DESC) AS rank_no
    FROM wallmart
    GROUP BY branch, category
) AS subquery
WHERE rank_no = 1;


SELECT *
FROM (
    SELECT 
        branch,
        DATE_FORMAT(STR_TO_DATE(`date`, '%d/%m/%y'), '%W') AS day_name, 
        COUNT(*) AS no_of_transactions,
        RANK() OVER (PARTITION BY branch ORDER BY COUNT(*) DESC) AS rank_no
    FROM wallmart
    GROUP BY branch, day_name
) AS subquery
WHERE rank_no = 1;

SELECT 
    city, category, AVG(rating), MIN(rating), MAX(rating)
FROM
    wallmart
GROUP BY city , category;

select * from wallmart;
SELECT 
    category, SUM(total + profit_margin) AS profit
FROM
    wallmart
GROUP BY category;



with cte as 
(select branch, payment_method , count(*) as transactio_total , rank() over(partition by branch order by count(*) desc) as rank_no from wallmart group by branch, payment_method) 
select * from cte where rank_no = 1;

SELECT 
    branch,
    CASE
        WHEN (HOUR(time) < 12) THEN 'Morning'
        WHEN (HOUR(time) BETWEEN 12 AND 18) THEN 'Afternoon'
        WHEN (HOUR(time) > 18) THEN 'Evening'
    END AS day_time,
    COUNT(*) AS transaction_count
FROM
    wallmart
GROUP BY day_time , branch;


select * from wallmart;
 
SELECT TIME(time) AS time_only
FROM wallmart;


SELECT 
    branch, SUM(total) AS revenue
FROM
    wallmart
GROUP BY branch;


WITH revenue_22 AS (
    SELECT branch, SUM(total) AS revenue
    FROM wallmart
    WHERE YEAR(STR_TO_DATE(date, '%d/%m/%Y')) = 2022
    GROUP BY branch
),
revenue_23 AS (
    SELECT branch, SUM(total) AS revenue
    FROM wallmart
    WHERE YEAR(STR_TO_DATE(date, '%d/%m/%Y')) = 2023
    GROUP BY branch
)
SELECT 
    ls.branch,ls.revenue as last_year_revenue, cs.revenue as current_year_revenue,
    round((ls.revenue-cs.revenue) / ls.revenue * 100 ,2) as rev_dec_ration
FROM revenue_22 as ls
JOIN revenue_23 as cs
    ON ls.branch = cs.branch
where ls.revenue > cs.revenue
order by rev_dec_ration desc
limit 5;