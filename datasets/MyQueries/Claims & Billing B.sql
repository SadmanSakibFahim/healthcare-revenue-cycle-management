-- How many claims were submitted in the past month?
SELECT *
FROM hospital_b_claims
WHERE MONTH(ClaimDate) = MONTH(now())-1 
AND YEAR(ClaimDate) = YEAR(now())-1;

-- What is the total billed amount vs. total reimbursed amount?
SELECT SUM(ClaimAmount) AS Total_Billed_Amount, SUM(PaidAmount) AS Total_Reimbursed_Amount
FROM hospital_b_claims;

-- Which claims are still unpaid or pending?
SELECT *
FROM hospital_b_claims
WHERE NOT ClaimStatus = 'Paid';
	
-- What is the average time to receive payment after claim submission?
WITH cte1 AS (SELECT tb.TransactionID, tb.EncounterID, tb.ClaimID, tb.PayorID, cb.ClaimDate, tb.PaidDate, DATEDIFF(tb.PaidDate, cb.ClaimDate) AS TimeForPayment
FROM hospital_b_claims as cb
JOIN transactions_b as tb
	ON cb.EncounterID = tb.EncounterID
    AND cb.ServiceDate < cb.ClaimDate AND cb.ClaimDate < tb.PaidDate)
SELECT AVG(TimeForPayment) AS AverageTimeForPayment
FROM cte1; 

-- What percentage of claims were denied, and why?

SELECT 
(
SELECT COUNT(1) AS NumPaidClaims
FROM hospital_b_claims 
WHERE ClaimStatus = 'Paid'
)/(
SELECT COUNT(1) AS NumTotalClaims
FROM hospital_b_claims)*100 AS PctPaidClaims
FROM hospital_b_claims
LIMIT 1;
 
-- How many claims had to be resubmitted or appealed?
WITH cte2 AS 
(SELECT EncounterID, COUNT(1) AS ClaimCount 
FROM hospital_b_claims
GROUP BY EncounterID)
SELECT COUNT(1) AS NumRepeatedClaims
FROM cte2;