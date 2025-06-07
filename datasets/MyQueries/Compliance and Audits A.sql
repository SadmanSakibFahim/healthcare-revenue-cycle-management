-- 🛑 5. Compliance & Audits
-- Are there duplicate or fraudulent billing patterns?
SELECT
  ca.PatientID,
  ca.ServiceDate,
  pra.NPI,
  ea.ProcedureCode,
  COUNT(*) AS claim_count
FROM hospital_a_claims AS ca
JOIN providers_a AS pra	
	ON 'H1-' + ca.ProviderID = pra.ProviderID
    AND ca.DeptID = pra.DeptID
JOIN encounters_a AS ea
	ON ca.EncounterID = ea.EncounterID
JOIN cptcodes AS cpt
	ON ea.ProcedureCode = cpt.CPTCodes
GROUP BY ca.PatientID,
  ca.ServiceDate,
  pra.NPI,
  ea.ProcedureCode
HAVING COUNT(*) > 1;

-- Which claims were denied due to coding errors or missing documents?
-- info unavailable

-- How many appeals were successful?
-- info unavailable