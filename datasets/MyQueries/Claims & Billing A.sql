-- How many claims were submitted in the past month?
SELECT *
FROM hospital_a_claims
WHERE MONTH(ClaimDate) = MONTH(now())-1 
AND YEAR(ClaimDate) = YEAR(now())-1;

-- What is the total billed amount vs. total reimbursed amount?
SELECT SUM(ClaimAmount) AS Total_Billed_Amount, SUM(PaidAmount) AS Total_Reimbursed_Amount
FROM hospital_a_claims;

-- Which claims are still unpaid or pending?
SELECT *
FROM hospital_a_claims
WHERE NOT ClaimStatus = 'Paid';
	
-- What is the average time to receive payment after claim submission?
WITH cte1 AS (
	SELECT ta.TransactionID, ta.EncounterID, ta.ClaimID, ta.PayorID, ca.ClaimDate, ta.PaidDate, 
	DATEDIFF(ta.PaidDate, ca.ClaimDate) AS TimeForPayment
	)
FROM hospital_a_claims as ca
JOIN transactions_a as ta
	ON ca.EncounterID = ta.EncounterID
    AND ca.ServiceDate < ca.ClaimDate AND ca.ClaimDate < ta.PaidDate)
SELECT AVG(TimeForPayment) AS AverageTimeForPayment
FROM cte1; 

-- What percentage of claims were denied, and why?

SELECT 
(
SELECT COUNT(1) AS NumPaidClaims
FROM hospital_a_claims 
WHERE ClaimStatus = 'Paid'
)/(
SELECT COUNT(1) AS NumTotalClaims
FROM hospital_a_claims)*100 AS PctPaidClaims
FROM hospital_a_claims
LIMIT 1;
 
-- How many claims had to be resubmitted or appealed?
WITH cte2 AS 
(SELECT EncounterID, COUNT(1) AS ClaimCount 
FROM hospital_a_claims
GROUP BY EncounterID)
SELECT COUNT(1) AS NumRepeatedClaims
FROM cte2;
