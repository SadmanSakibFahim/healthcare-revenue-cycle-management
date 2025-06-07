-- 🔍 Claim Performance & Outcomes
-- What percentage of claims are approved, denied, or under review?
SELECT 
	Claim_Status, 
	ROUND(COUNT(*) * 100/(SELECT COUNT(*) FROM claim_data), 2) AS percentage
FROM claim_data
GROUP BY Claim_Status;

-- What is the average paid amount by insurance type?
SELECT 
    Insurance_Type,
    ROUND(AVG(Paid_Amount), 2) AS average_paid_amount
FROM claim_data
GROUP BY Insurance_Type;

-- What is the denial rate by procedure or diagnosis code?
-- By Procedure Code
SELECT 
	Procedure_Code, 
    ROUND(
    SUM((CASE WHEN Claim_Status = 'Denied' THEN 1 ELSE 0 END)) * 100/COUNT(*) , 2) AS Denial_Rate
FROM claim_data
GROUP BY Procedure_Code;
-- By Diagnosis_Code
SELECT 
	Diagnosis_Code, 
    ROUND(
    SUM((CASE WHEN Claim_Status = 'Denied' THEN 1 ELSE 0 END)) * 100/COUNT(*) , 2) AS Denial_Rate
FROM claim_data
GROUP BY Diagnosis_Code;

-- How often do claims require follow-up, and what's the typical outcome?
SELECT Follow_up_Required, Outcome, COUNT(*) AS Claim_Count
FROM claim_data
WHERE Follow_up_Required = 'Yes'
GROUP BY Follow_up_Required, Outcome
ORDER BY Claim_Count DESC
LIMIT 1;

-- 💰 Financial Analysis
-- What is the total billed vs. allowed vs. paid amount?
SELECT 
	SUM(Billed_Amount) AS Total_Billed,
    SUM(Allowed_Amount) AS Total_Allowed,
    SUM(Paid_Amount) AS Total_Paid
FROM claim_data;

-- What is the average payment per claim by insurance type?
SELECT
	Insurance_Type,
    ROUND(AVG(Paid_Amount), 2) AS Average_Payment_Per_Claim
FROM claim_data
GROUP BY Insurance_Type
ORDER BY Average_Payment_Per_Claim;

-- Which providers generate the highest or lowest payment ratios?
SELECT 
	Provider_ID,
    ROUND (SUM(Paid_Amount) * 100/SUM(Billed_Amount),2) AS Payment_Ratio
FROM claim_data
GROUP BY Provider_ID
ORDER BY SUM(Paid_Amount)/SUM(Billed_Amount) DESC; 

-- 📅 Time-Based Trends
-- Are there patterns in claim outcomes over time?
SELECT
	DATE_FORMAT(Date_of_Service, '%Y-%m') AS service_month,
    Claim_Status,
    COUNT(*) AS Claim_Count
FROM claim_data
GROUP BY service_month, Claim_Status
ORDER BY service_month, Claim_Status;

-- Are certain months associated with higher denials?
SELECT
	DATE_FORMAT(Date_of_Service, '%Y-%m') AS service_month,
    Claim_Status,
    COUNT(*) AS Claim_Count
FROM claim_data
WHERE Claim_Status = 'Denied'
GROUP BY service_month, Claim_Status
ORDER BY Claim_Count DESC
LIMIT 1;

-- 🧾 Code & Insurance Insights
-- Which diagnosis or procedure codes are most frequently denied?
SELECT 
	Procedure_Code,
    COUNT(*) AS Denied_Claim_Count
FROM claim_data
WHERE Claim_Status = 'Denied'
GROUP BY Procedure_Code
ORDER BY Denied_Claim_Count DESC
LIMIT 3;
SELECT 
	Diagnosis_Code,
    COUNT(*) AS Denied_Claim_Count
FROM claim_data
WHERE Claim_Status = 'Denied'
GROUP BY Diagnosis_Code
ORDER BY Denied_Claim_Count DESC
LIMIT 3;

-- What are the top reasons for denials or partial payments?
SELECT 
	Reason_Code,
    COUNT(*) AS Reason_Count
FROM claim_data
WHERE 
	(Claim_Status = 'Denied' OR Claim_Status = 'Under Review') AND
    (Outcome = 'Denied' OR 
    AR_Status = 'Denied' OR
	AR_Status = 'Partially paid' OR 
    Outcome = 'Partially paid' AND
    NOT Outcome = 'Paid')
GROUP BY Reason_Code
ORDER BY Reason_Count DESC;

-- How do outcomes differ between insurance types?
SELECT 
	Insurance_Type,
    Outcome,
    COUNT(*) AS outcome_count
FROM claim_data
GROUP BY Insurance_Type, Outcome
ORDER BY Insurance_Type;

-- 📊 Operational Efficiency
-- How many claims are stuck in "Pending" or "On Hold" AR status?
SELECT
	AR_Status,
    COUNT(*) AS Claim_Count
FROM claim_data
WHERE AR_Status = 'Pending' OR AR_Status = 'On Hold'
GROUP BY AR_Status;

-- Is there a relationship between “Follow-up Required” and claim denial?
SELECT 
    Follow_up_Required,
    COUNT(*) AS total_claims,
    SUM(CASE WHEN Claim_Status = 'Denied' THEN 1 ELSE 0 END) AS denied_claims,
    ROUND(
        SUM(CASE WHEN Claim_Status = 'Denied' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2
    ) AS denial_rate_percent
FROM claim_data
GROUP BY Follow_up_Required;

