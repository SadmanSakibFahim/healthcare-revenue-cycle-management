SELECT * FROM hospital_b_claims;

-- How much was collected in patient payments vs. insurance payments?
SELECT SUM(Deductible + Coinsurance + Copay) AS PtPayments
FROM hospital_b_claims;
SELECT SUM(PaidAmount) AS InsPayments
FROM hospital_b_claims
WHERE NOT PayorType = 'Self-Pay';

-- What is the total accounts receivable (AR)?
WITH cte1 AS (SELECT (ClaimAmount - (PaidAmount + Copay + Coinsurance + Deductible)) AS BalanceDue
FROM hospital_b_claims
WHERE ClaimAmount > (PaidAmount + Copay + Coinsurance + Deductible) 
)
SELECT SUM(BalanceDue) AS AccountsReceiveable
FROM cte1;

-- What is the aging of AR (0–30, 31–60, 61–90, 90+ days)?
/*CREATE TABLE ARAge (SELECT 
	CASE
		WHEN DATEDIFF('2024-12-31', ClaimDate) <= 30 THEN '0-30'
        WHEN DATEDIFF('2024-12-31', ClaimDate) <= 60 THEN '30-60'
        WHEN DATEDIFF('2024-12-31', ClaimDate) <= 90 THEN '60-90'
		ELSE '90+'
		END AS Age, SUM(ClaimAmount - (PaidAmount + Copay + Coinsurance + Deductible)) AS TotalReceiveable
    FROM hospital_a_claims
    WHERE (ClaimAmount - (PaidAmount + Copay + Coinsurance + Deductible)) > 0
    GROUP BY Age);*/

-- Which payers are the slowest to pay or most often underpay?
SELECT pb.PatientID, pb.F_Name, pb.L_Name, pb.M_Name, COUNT(1) AS PaymentsDue
FROM patients_b as pb
JOIN hospital_b_claims as cb
	ON pb.PatientID = cb.PatientID
JOIN ageofaccountsreceiveable as age
	ON cb.patientID = age.PatientID
WHERE Age = '90+'
GROUP BY pb.PatientID, pb.FirstName, pb.LastName, pb.MiddleName;

-- What is the patient responsibility portion vs. insurance?

SELECT ClaimID, (Deductible + Coinsurance + Copay) AS PatientPay, (Deductible + Coinsurance + Copay)/ClaimAmount*100 AS PctPtResp, (ClaimAmount-(Deductible + Coinsurance + Copay)) AS InsurancePay, (ClaimAmount-(Deductible + Coinsurance + Copay))/ClaimAmount*100 AS PctInsPay
FROM hospital_b_claims
WHERE NOT PayorType = 'Self-Pay';