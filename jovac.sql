--Project Task 01: Data Transformation & Modelling


--Method 1: Transformation and Aggregation
-- Join promo_metric_data with engagement data to extract engagement within promo plan period
SELECT 
    e.User_Id,
    p.Promo_Plan_Name,
    SUM(e.Total_Badge_Received) AS Total_Badges,
    COUNT(e.Badge_Earn_Date) AS Badge_Days
FROM 
    promo_metric_data p
JOIN 
    engagement e 
    ON p.User_Id = e.User_Id
WHERE 
    e.Badge_Earn_Date BETWEEN p.Redemption_Date AND p.Active_to_Date
GROUP BY 
    e.User_Id, p.Promo_Plan_Name;

-- Similar queries can be written for viewership and merchandise tables.

   
   
--   Method 2: Creating a Binary Flag
   -- Create a binary flag for engagement
SELECT 
    e.User_Id,
    CASE 
        WHEN e.Badge_Earn_Date BETWEEN p.Redemption_Date AND p.Active_to_Date 
        THEN 1 ELSE 0 END AS pp_flag
FROM 
    promo_metric_data p
JOIN 
    engagement e 
    ON p.User_Id = e.User_Id;

-- Similar queries can be written for viewership and merchandise tables.

   
   
   
   
--   Project Task 02: BI Dashboard
   
   
--   Promo Effectiveness Assessment (Conversion Rate):
   SELECT 
    p.Promo_Plan_Name,
    SUM(CASE WHEN c.Purchase_Date IS NOT NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(c.User_Id) AS Conversion_Rate
FROM 
    promo_metric_data p
LEFT JOIN 
    conversion c ON p.User_Id = c.User_Id
GROUP BY 
    p.Promo_Plan_Name;

   
   
--   Second Highest Revenue per User in Merchandise:
   SELECT 
    p.Promo_Plan_Name,
    AVG(m.Total_Revenue) AS Avg_Revenue
FROM 
    promo_metric_data p
JOIN 
    merchandise m ON p.User_Id = m.User_Id
GROUP BY 
    p.Promo_Plan_Name
ORDER BY 
    Avg_Revenue DESC
LIMIT 1 OFFSET 1;




--Month with Highest Promo Plan Opt-ins:
SELECT 
    EXTRACT(MONTH FROM p.Redemption_Date) AS Month,
    COUNT(p.User_Id) AS Opt_Ins
FROM 
    promo_metric_data p
GROUP BY 
    Month
ORDER BY 
    Opt_Ins DESC
LIMIT 1;




--Promo Plan with Second Highest Average Viewership per User:
SELECT 
    p.Promo_Plan_Name,
    AVG(v.Total_Viewership) AS Avg_Viewership
FROM 
    promo_metric_data p
JOIN 
    viewership v ON p.User_Id = v.User_Id
GROUP BY 
    p.Promo_Plan_Name
ORDER BY 
    Avg_Viewership DESC
LIMIT 1 OFFSET 1;



--Promo Plan with Highest New Users:
SELECT 
    p.Promo_Plan_Name,
    COUNT(r.User_Id) AS New_Users
FROM 
    promo_metric_data p
JOIN 
    registration r ON p.User_Id = r.User_Id
WHERE 
    DATEDIFF(r.Registration_Date, p.Redemption_Date) <= 7
GROUP BY 
    p.Promo_Plan_Name
ORDER BY 
    New_Users DESC;

   
   
--Promo Plan More Popular Among Females:
SELECT 
    p.Promo_Plan_Name,
    COUNT(r.User_Id) AS Female_Users
FROM 
    promo_metric_data p
JOIN 
    registration r ON p.User_Id = r.User_Id
WHERE 
    r.Gender = 'Female'
GROUP BY 
    p.Promo_Plan_Name
ORDER BY 
    Female_Users DESC;

   
--Month with Minimum Number of Badges:
SELECT 
    EXTRACT(MONTH FROM e.Badge_Earn_Date) AS Month,
    SUM(e.Total_Badge_Received) AS Total_Badges
FROM 
    engagement e
GROUP BY 
    Month
ORDER BY 
    Total_Badges ASC
LIMIT 1;



