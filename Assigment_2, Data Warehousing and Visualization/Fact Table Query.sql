SELECT 
	Time_Key,
	Customer_Key,
	CPD.Customer_Profile_Key,
	Agent_Key, 
	Vendor_Key, 
	Transaction_Key,
	Policy_Key,
	Incident_Report_Key,
	CLAIM_AMOUNT,
	PREMIUM_AMOUNT
INTO Fact_Table
FROM Main_Date_Dim MDD
JOIN Transaction_Date_Dim TDD ON MDD.T_Date_Key = TDD.T_Date_Key
JOIN  Policy_Date_Dim PDD ON MDD.P_Date_Key = PDD.P_Date_Key
JOIN  Loss_Date_Dim LDD ON MDD.Loss_Date_Key = LDD.Loss_Date_Key
JOIN Report_Date_dim RDD ON MDD.R_Date_Key = RDD.R_Date_Key

JOIN AA_Staging_Table ST 
ON  ST.TXN_DATE_TIME = TDD.Transaction_Date
AND ST.POLICY_EFF_DT = PDD.Policy_Eff_Date
AND ST.LOSS_DT = LDD.Loss_Date
AND ST.REPORT_DT = RDD.Reported_Date

JOIN Policy_Dim PD 
ON  ST.POLICY_NUMBER = PD.Policy_Number
AND ST.TENURE = PD.Tenure
AND ST.INSURANCE_TYPE = PD.Insurance_Type

JOIN Transaction_dim TD 
ON  TD.Transaction_ID = ST.TRANSACTION_ID
AND TD.Claim_Status = ST.CLAIM_STATUS

JOIN Main_Incident_Report_Dim MIRD
ON  MIRD.INCIDENT_HOUR_OF_THE_DAY = ST.INCIDENT_HOUR_OF_THE_DAY
AND MIRD.CLAIM_STATUS = ST.CLAIM_STATUS
AND MIRD.INCIDENT_SEVERITY = ST.INCIDENT_SEVERITY
AND MIRD.AUTHORITY_CONTACTED = ST.AUTHORITY_CONTACTED
AND MIRD.ANY_INJURY = ST.ANY_INJURY
AND MIRD.POLICE_REPORT_AVAILABLE = ST.POLICE_REPORT_AVAILABLE

JOIN Incident_Location_Dim ILD 
ON  ILD.I_Location_Key = MIRD.I_Location_Key
AND ILD.INCIDENT_CITY = ST.INCIDENT_CITY
AND ILD.INCIDENT_STATE = ST.INCIDENT_STATE

JOIN Vendor_Dimension VD ON ST.VENDOR_ID = VD.Vendor_ID

JOIN Vendor_Location_Dimension VLD
ON  VLD.Vendor_Location_Key = VD.Vendor_Location_Key
AND VLD.Vendor_City = ST.Vendor_City
AND VLD.Vendor_State = ST.Vendor_State

JOIN Main_Agent_Dimension MAD ON MAD.Agent_ID = ST.AGENT_ID

JOIN Agent_Location_Dimension ALD
ON ALD.A_Location_Key = MAD.A_Location_Key
AND ALD.Employee_City = ST.Employee_City
AND ALD.Employee_City = ST.Employee_City

JOIN Customer_Profile_Dim CPD
ON  CPD.MARITAL_STATUS = ST.MARITAL_STATUS
AND CPD.SOCIAL_CLASS = ST.SOCIAL_CLASS
AND CPD.CUSTOMER_EDUCATION_LEVEL = ST.CUSTOMER_EDUCATION_LEVEL
AND CPD.EMPLOYMENT_STATUS = ST.EMPLOYMENT_STATUS

JOIN Main_Customer_Dim MCD
ON MCD.Customer_ID = ST.CUSTOMER_ID
AND MCD.Age = ST.AGE
