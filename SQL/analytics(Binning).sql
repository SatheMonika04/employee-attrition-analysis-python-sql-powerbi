/* 
Project: HR Attrition Analytics � Data Modeling Layer
Author: Monika
Purpose:
This script creates a structured analytical view with engineered features
(AgeGroup, IncomeBand, TenureBand, AttritionFlag)
to support dashboard-level KPI calculations in Power BI.

Design Principles:
- No raw data pushed to dashboard
- All segmentation logic handled in SQL
- Consistent banding with no logical gaps
- Income quartiles based on relative ranking (NTILE)
*/

-- creating Database
CREATE DATABASE  HR_db ;

USE HR_db ;
-- Imported Cleaned Csv Using UI 

-- Viewing All Data
SELECT * FROM dbo.hr_analytics ; 


---------------------------------------------------------------------------

-- Creating View with selecting required columns with Age binning and SalaryBand and TenureBand
DROP VIEW IF EXISTS Analytical;
GO

CREATE VIEW Analytical AS
-- CTE: BaseData
-- Adds IncomeQuartile using NTILE(4) to segment employees into relative income groups
-- Quartiles are calculated across entire dataset (not department-wise)
WITH BaseData AS (
    SELECT 
        Attrition,
        Age,
        MonthlyIncome,
        YearsAtCompany,
        Department,
        JobRole,
        OverTime,
        JobSatisfaction,
        JobLevel,
        TotalWorkingYears,

        -- Create Income Quartile (1 = lowest income, 4 = highest income)
        NTILE(4) OVER (ORDER BY MonthlyIncome) AS IncomeQuartile

    FROM dbo.hr_analytics
)

SELECT 
    Attrition,

    -- Numeric Flag for easier rate calculation
    CASE 
        WHEN Attrition = 'Yes' THEN 1
        ELSE 0
    END AS AttritionFlag,

    -- Age Group
    CASE 
        WHEN Age BETWEEN 18 AND 25 THEN '18-25'
        WHEN Age BETWEEN 26 AND 35 THEN '26-35'
        WHEN Age BETWEEN 36 AND 45 THEN '36-45'
        ELSE '46+'
    END AS AgeGroup,

    -- Income Label
    CASE 
        WHEN IncomeQuartile = 1 THEN 'Q1(Lowest)'
        WHEN IncomeQuartile = 2 THEN 'Q2'
        WHEN IncomeQuartile = 3 THEN 'Q3'
        WHEN IncomeQuartile = 4 THEN 'Q4(Highest)'
    END AS IncomeBand,

    -- Tenure Band (No Gaps)
    CASE 
        WHEN YearsAtCompany BETWEEN 0 AND 5 THEN 'Early Tenure'
        WHEN YearsAtCompany BETWEEN 6 AND 10 THEN 'Developing'
        WHEN YearsAtCompany BETWEEN 11 AND 15 THEN 'Established'
        ELSE 'Long Term'
    END AS TenureBand,

    Department,
    JobRole,
    OverTime,
    MonthlyIncome,
    YearsAtCompany,
    JobSatisfaction,
    JobLevel,
    TotalWorkingYears

FROM BaseData;

-- 
SELECT * FROM Analytical ; 

----------------------------------------------------------------------------------------

-- Calculating Attrition Rate
SELECT 
    AVG(CAST(AttritionFlag AS FLOAT)) * 100 AS attrition_rate
FROM Analytical;

-- Got a Attrition Rate approx 16.1224 % 

-------------------------------------------------------------------------------------------


-- Attrition Rate By Department
-- No Of Employees By Department 
-- No Of Leavers By Department 

SELECT 
      Department  , 
      COUNT(*) No_Of_Employees , 
      SUM(AttritionFlag) AS No_Of_Leavers ,
      AVG(CAST(AttritionFlag AS FLOAT)) * 100 AS attrition_rate , 
      RANK() OVER 
             (ORDER BY AVG(CAST(AttritionFlag AS FLOAT)) * 100 DESC ) AS attrition_rank -- Rank by attrition rate
FROM Analytical 
GROUP BY Department
ORDER BY attrition_rate DESC;

-- Attrition Rate By Age Group 
SELECT
     AgeGroup , 
     AVG(CAST(AttritionFlag AS FLOAT)) * 100 AS attrition_rate 
FROM Analytical
GROUP BY AgeGroup
ORDER BY attrition_rate DESC ; 
-- early age --> Highest attrition (this follows the patter of python mean comparison which we have done)


-- Attrition Rate by Income Band
SELECT
     IncomeBand , 
     AVG(CAST(AttritionFlag AS FLOAT)) * 100 AS attrition_rate 
FROM Analytical
GROUP BY IncomeBand
ORDER BY attrition_rate DESC ; 
-- Low Income Group has highest attrition and High Income Group has lowest attrition


--Attrition By Tenure Band
SELECT
     TenureBand , 
     AVG(CAST(AttritionFlag AS FLOAT)) * 100 AS attrition_rate 
FROM Analytical
GROUP BY TenureBand
ORDER BY attrition_rate DESC ; 
-- Early Tenure shows highest attrition → onboarding/early retention issue

--Attrition Rate By OverTime 
SELECT
     OverTime , 
     AVG(CAST(AttritionFlag AS FLOAT)) * 100 AS attrition_rate 
FROM Analytical
GROUP BY OverTime
ORDER BY attrition_rate DESC ; 
-- OverTime increases attrition

-------------------------------------------------------------------------------------
--- Cross Structural Interaction 

-- AgeGroup + IncomeBand vs Attrition

SELECT 
    AgeGroup,
    IncomeBand,
    COUNT(*) AS TotalEmployees,
    SUM(AttritionFlag) AS Leavers,
    AVG(CAST(AttritionFlag AS FLOAT)) * 100 AS attrition_rate 
FROM Analytical
GROUP BY AgeGroup, IncomeBand
ORDER BY AgeGroup, attrition_rate DESC;
-- Attrition in young employees with lowest income is highest than any other 


-- Department + TenureBand vs Attrition
SELECT 
      Department ,
      TenureBand,
      COUNT(*) AS TotalEmployees,
    SUM(AttritionFlag) AS Leavers,
    AVG(CAST(AttritionFlag AS FLOAT)) * 100 AS attrition_rate 
FROM Analytical
GROUP BY Department, TenureBand
ORDER BY  attrition_rate DESC;
-- Human Resources and Sales department with early tenure has more attrition rate


-- OVER TIME AND INCOME

SELECT 
    IncomeBand,
    OverTime,
    COUNT(*) AS TotalEmployees,
    SUM(AttritionFlag) AS Leavers,
     AVG(CAST(AttritionFlag AS FLOAT)) * 100 AS attrition_rate 
FROM Analytical
GROUP BY IncomeBand, OverTime
ORDER BY IncomeBand, OverTime;
--employees in all income band face to overtime but attrition among low income employees having overtime is highest.

-----------------------------------------------------------------------------------

-- Correlation Support Check
-- comaprison with pyhton correlation matrix
SELECT 
    JobLevel,
    AVG(MonthlyIncome) as avgIncome,
    COUNT(*) AS TotalEmployees,
    SUM(AttritionFlag) AS Leavers,
     AVG(CAST(AttritionFlag AS FLOAT)) * 100 AS attrition_rate 
FROM Analytical
GROUP BY JobLevel
ORDER BY JobLevel;
-- JobLevel perfectly correlated with monthly income bigger job levl have high income


SELECT 
    JobLevel,
    ROUND(AVG(YearsAtCompany), 2) AS AvgTenure,
    ROUND(AVG(TotalWorkingYears), 2) AS AvgTotalExperience
FROM Analytical
GROUP BY JobLevel
ORDER BY JobLevel;
-- AvgTenure Increases With the Job Level Highly Correlated

--------------------------------------------------------------------
--Creating Final Analytical Table for Power BI
-- Create aggregated table
DROP TABLE IF EXISTS hr_dashboard_metrics ;
SELECT
    Department,
    AgeGroup,
    IncomeBand,
    TenureBand,
    OverTime,
    COUNT(*) AS TotalEmployees,
    SUM(AttritionFlag) AS Leavers,
    ROUND(AVG(AttritionFlag) * 100, 2) AS AttritionRate
INTO hr_dashboard_metrics
FROM Analytical
GROUP BY 
    Department,
    AgeGroup,
    IncomeBand,
    TenureBand,
    OverTime;

-- Final Checklists
SELECT IncomeBand, COUNT(*) 
FROM Analytical
GROUP BY IncomeBand;

SELECT SUM(TotalEmployees) FROM hr_dashboard_metrics; --1470
SELECT COUNT(*) FROM Analytical; --1470