CREATE TABLE claim_data(
	Claim_ID VARCHAR(40),
    Provider_ID DOUBLE,
	Patient_ID VARCHAR(40),	
    Date_of_Service VARCHAR(40),	
    Billed_Amount DOUBLE,
    Procedure_Code INT(32),
    Diagnosis_Code VARCHAR(40),
	Allowed_Amount DOUBLE,
	Paid_Amount DOUBLE, 
	Insurance_Type VARCHAR(40),
	Claim_Status VARCHAR(40),	
    Reason_Code VARCHAR(80), 
    Follow_up_Required VARCHAR(40), 
    AR_Status VARCHAR(40),	
    Outcome VARCHAR(40)
    )
    
