-- 📈 4. Financial & Operational KPIs

-- What is the net collection rate?
SELECT SUM(PaidAmount)/SUM(Amount)*100 AS NetCollectionRate
FROM transactions_a;

-- What is the denial rate over time (trend)?
SELECT
  DATE_FORMAT(ClaimDate, '%Y-%m') AS month,
  COUNT(*) AS TotalClaims,
  SUM(CASE WHEN ClaimStatus = 'Denied' THEN 1 ELSE 0 END) AS DeniedClaims,
  ROUND(
    SUM(CASE WHEN ClaimStatus = 'denied' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2
  ) AS DenialRatePct
FROM hospital_a_claims
WHERE ClaimDate IS NOT NULL
GROUP BY DATE_FORMAT(ClaimDate, '%Y-%m')
ORDER BY month;

-- What’s the average claim value by payer or procedure?
SELECT
  PayorID,
  
  COUNT(*) AS ClaimCount,
  ROUND(AVG(ClaimAmount), 2) AS AvgClaimValue
FROM hospital_a_claims AS ca
JOIN encounters_a AS ea
	ON ca.EncounterID = ea.EncounterID
GROUP BY PayorID
ORDER BY PayorID;

SELECT
  ProcedureCode,
  COUNT(*) AS ClaimCount,
  ROUND(AVG(ClaimAmount), 2) AS AvgClaimValue
FROM hospital_a_claims AS ca
JOIN encounters_a AS ea
	ON ca.EncounterID = ea.EncounterID
GROUP BY ProcedureCode
ORDER BY ProcedureCode;

-- What percentage of revenue is being written off?
-- Writeoff information not available