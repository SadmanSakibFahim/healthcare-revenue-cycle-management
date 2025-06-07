-- 🏥 3. Patient and Visit-Level Insights
-- How many patient encounters resulted in a billable claim?
SELECT COUNT(1) AS NumBillableClaims
FROM hospital_a_claims
WHERE NOT ClaimStatus = 'Denied'
	AND NOT ClaimStatus = 'Rejected';

-- Which procedures or CPT codes generate the most revenue?
SELECT ea.ProcedureCode, cpt.ProcedureCodeDescription, SUM(PaidAmount+Deductible+Copay+Coinsurance) AS Revenue
FROM encounters_a AS ea
JOIN hospital_a_claims AS ca
	ON ea.EncounterID = ca.EncounterID
JOIN cptcodes AS cpt
	ON ea.ProcedureCode = cpt.CPTCodes
GROUP BY ProcedureCode, ProcedureCodeDescription
LIMIT 10;
    

-- What is the average revenue per visit or per procedure?
SELECT AVG(PaidAmount + Deductible + Copay + Coinsurance) AS AverageRevenue
FROM hospital_a_claims;
SELECT ea.ProcedureCode, AVG(PaidAmount + Deductible + Copay + Coinsurance) AS AverageRevenuePerProcedure
FROM hospital_a_claims AS ca
JOIN encounters_a AS ea
	ON ca.EncounterID = ea.EncounterID
GROUP BY ea.ProcedureCode;

-- Which providers have the highest or lowest reimbursement rates?
SELECT ca.ProviderID, ca.DeptID,  
		SUM(ca.PaidAmount + ca.Deductible + ca.Copay + ca.Coinsurance)/SUM(ca.ClaimAmount)*100 AS ReimbursementRate
FROM hospital_a_claims AS ca
LEFT JOIN providers_a AS pra
	ON 'H1-'+ ca.ProviderID = pra.ProviderID
    AND ca.DeptID = pra.DeptID
GROUP BY ca.providerID, ca.DeptID
ORDER BY ReimbursementRate DESC
LIMIT 100;