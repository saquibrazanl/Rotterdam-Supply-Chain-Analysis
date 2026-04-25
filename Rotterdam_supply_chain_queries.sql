CREATE DATABASE rotterdam_supply_chain;
USE rotterdam_supply_chain;

CREATE TABLE shipments (
    Order_ID VARCHAR(20),
    Order_Date DATE,
    Origin_City VARCHAR(50),
    Destination_City VARCHAR(50),
    Route_Type VARCHAR(30),
    Transportation_Mode VARCHAR(20),
    Product_Category VARCHAR(50),
    Base_Lead_Time_Days INT,
    Scheduled_Lead_Time_Days INT,
    Actual_Lead_Time_Days INT,
    Delay_Days INT,
    Delivery_Status VARCHAR(20),
    Disruption_Event VARCHAR(60),
    Geopolitical_Risk_Index DECIMAL(4,2),
    Weather_Severity_Index DECIMAL(4,2),
    Inflation_Rate_Pct DECIMAL(5,2),
    Shipping_Cost_USD DECIMAL(10,2),
    Order_Weight_Kg INT,
    Mitigation_Action_Taken VARCHAR(40)
);

SELECT COUNT(*) FROM shipments;

SELECT * FROM shipments LIMIT 5;

SELECT 
    Product_Category,
    COUNT(*) AS Total_Shipments
FROM shipments
GROUP BY Product_Category
ORDER BY Total_Shipments DESC;

SELECT 
    Route_Type,
    Transportation_Mode,
    COUNT(*) AS Total_Shipments
FROM shipments
GROUP BY Route_Type, Transportation_Mode
ORDER BY Total_Shipments DESC;

SELECT 
    Destination_City,
    COUNT(*) AS Total_Shipments
FROM shipments
WHERE Destination_City = 'Rotterdam, NL'
GROUP BY Destination_City;

SELECT 
    Delivery_Status,
    COUNT(*) AS Total_Shipments,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM shipments), 2) AS Percentage
FROM shipments
GROUP BY Delivery_Status;

SET SQL_SAFE_UPDATES = 0;

UPDATE shipments
SET Disruption_Event = 'No Disruption'
WHERE Disruption_Event = 'None';

SET SQL_SAFE_UPDATES = 1;

SELECT 
    Disruption_Event,
    COUNT(*) AS Count
FROM shipments
GROUP BY Disruption_Event;

-- ANALYTICAL QUERIES BEGIN

SELECT 
    Delivery_Status,
    COUNT(*) AS Total_Shipments,
    ROUND(AVG(Delay_Days), 2) AS Avg_Delay_Days,
    ROUND(AVG(Shipping_Cost_USD), 2) AS Avg_Shipping_Cost,
    ROUND(COUNT(*) * 100.0 / 
        (SELECT COUNT(*) FROM shipments 
         WHERE Destination_City = 'Rotterdam, NL'), 2) AS Percentage
FROM shipments
WHERE Destination_City = 'Rotterdam, NL'
GROUP BY Delivery_Status;

SELECT 
    Disruption_Event,
    COUNT(*) AS Total_Shipments,
    ROUND(AVG(Delay_Days), 2) AS Avg_Delay_Days,
    ROUND(AVG(Shipping_Cost_USD), 2) AS Avg_Cost_USD,
    SUM(CASE WHEN Delivery_Status = 'Late' THEN 1 ELSE 0 END) AS Late_Shipments
FROM shipments
WHERE Destination_City = 'Rotterdam, NL'
GROUP BY Disruption_Event
ORDER BY Avg_Delay_Days DESC;

SELECT 
    Mitigation_Action_Taken,
    COUNT(*) AS Total_Shipments,
    ROUND(AVG(Shipping_Cost_USD), 2) AS Avg_Cost_USD,
    ROUND(AVG(Delay_Days), 2) AS Avg_Delay_Days,
    SUM(CASE WHEN Delivery_Status = 'On Time' THEN 1 ELSE 0 END) AS OnTime_Count,
    ROUND(SUM(CASE WHEN Delivery_Status = 'On Time' THEN 1 ELSE 0 END) 
        * 100.0 / COUNT(*), 2) AS OnTime_Percentage
FROM shipments
WHERE Destination_City = 'Rotterdam, NL'
GROUP BY Mitigation_Action_Taken
ORDER BY OnTime_Percentage DESC;

SELECT 
    Transportation_Mode,
    COUNT(*) AS Total_Shipments,
    ROUND(AVG(Shipping_Cost_USD), 2) AS Avg_Cost_USD,
    ROUND(MIN(Shipping_Cost_USD), 2) AS Min_Cost,
    ROUND(MAX(Shipping_Cost_USD), 2) AS Max_Cost,
    ROUND(AVG(Actual_Lead_Time_Days), 2) AS Avg_Lead_Time
FROM shipments
WHERE Destination_City = 'Rotterdam, NL'
GROUP BY Transportation_Mode
ORDER BY Avg_Cost_USD DESC;

SELECT 
    Product_Category,
    ROUND(AVG(Base_Lead_Time_Days), 1) AS Avg_Base_Lead_Time,
    ROUND(AVG(Scheduled_Lead_Time_Days), 1) AS Avg_Scheduled,
    ROUND(AVG(Actual_Lead_Time_Days), 1) AS Avg_Actual,
    ROUND(AVG(Actual_Lead_Time_Days) - AVG(Base_Lead_Time_Days), 1) AS Variance_Days
FROM shipments
WHERE Destination_City = 'Rotterdam, NL'
GROUP BY Product_Category
ORDER BY Variance_Days DESC;

SELECT DISTINCT Disruption_Event 
FROM shipments 
WHERE Destination_City = 'Rotterdam, NL';




-- 3 VIEWS
-- View 1 — Rotterdam Disruption Summary
CREATE VIEW vw_rotterdam_disruption AS
SELECT 
    Disruption_Event,
    COUNT(*) AS Total_Shipments,
    ROUND(AVG(Delay_Days), 2) AS Avg_Delay_Days,
    ROUND(AVG(Shipping_Cost_USD), 2) AS Avg_Cost_USD,
    SUM(CASE WHEN Delivery_Status = 'Late' THEN 1 ELSE 0 END) AS Late_Shipments,
    ROUND(SUM(CASE WHEN Delivery_Status = 'Late' THEN 1 ELSE 0 END) 
        * 100.0 / COUNT(*), 2) AS Late_Percentage
FROM shipments
WHERE Destination_City = 'Rotterdam, NL'
GROUP BY Disruption_Event;

-- View 2 — Mitigation Cost Effectiveness
CREATE VIEW vw_mitigation_effectiveness AS
SELECT 
    Mitigation_Action_Taken,
    COUNT(*) AS Total_Shipments,
    ROUND(AVG(Shipping_Cost_USD), 2) AS Avg_Cost_USD,
    ROUND(AVG(Delay_Days), 2) AS Avg_Delay_Days,
    ROUND(SUM(CASE WHEN Delivery_Status = 'On Time' THEN 1 ELSE 0 END) 
        * 100.0 / COUNT(*), 2) AS OnTime_Percentage
FROM shipments
WHERE Destination_City = 'Rotterdam, NL'
GROUP BY Mitigation_Action_Taken;

-- View 3 — Product Lead Time Performance
CREATE VIEW vw_product_leadtime AS
SELECT 
    Product_Category,
    ROUND(AVG(Base_Lead_Time_Days), 1) AS Avg_Base,
    ROUND(AVG(Actual_Lead_Time_Days), 1) AS Avg_Actual,
    ROUND(AVG(Actual_Lead_Time_Days) - AVG(Base_Lead_Time_Days), 1) AS Variance_Days,
    ROUND(AVG(Shipping_Cost_USD), 2) AS Avg_Cost_USD
FROM shipments
WHERE Destination_City = 'Rotterdam, NL'
GROUP BY Product_Category
ORDER BY Variance_Days DESC;

-- CHECK ALL 3
SHOW FULL TABLES WHERE Table_type = 'VIEW';

SELECT * FROM vw_rotterdam_disruption;

-- exporting for excel
SELECT * FROM vw_rotterdam_disruption;
SELECT * FROM vw_mitigation_effectiveness;
SELECT * FROM vw_product_leadtime;