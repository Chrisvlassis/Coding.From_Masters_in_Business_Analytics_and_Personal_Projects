/* Here i create the date dimension.
First i have created the 4 Date_Dimension. Then i populate them with the data.*/
insert into Transaction_Date_Dim(Transaction_Date) select distinct [TXN_DATE_TIME] from AA_Staging_Table 
insert into Loss_Date_Dim(Loss_Date) select distinct [LOSS_DT] from AA_Staging_Table 
insert into Policy_Date_Dim(Policy_Eff_Date) select distinct [POLICY_EFF_DT] from AA_Staging_Table 
insert into Report_Date_Dim(Reported_Date) select distinct [REPORT_DT] from AA_Staging_Table 

/* Here i create the date_dim which is used for keeping the date_keys. For now this table is gonna be populated with dates.
I will later join to bring the keys from the 4 small date table and delete this table*/
insert into Date_Dim(Transaction_Date,Policy_Date,Loss_Date,Reported_Date)
select distinct  [TXN_DATE_TIME],  [POLICY_EFF_DT], [LOSS_DT], [REPORT_DT] from AA_Staging_Table

/* here i bring the keys from the smaller date tables to the main date table */
SELECT DISTINCT 
	Time_Key,
	P_Date_Key,
	R_Date_Key,
	T_Date_Key,
	Loss_Date_Key
INTO Main_Date_Dim 
FROM Date_Dim DD
join Policy_Date_Dim PDD on PDD.Policy_Eff_Date = DD.Policy_Date
join Report_Date_dim RD on RD.Reported_Date = DD.Reported_Date
join Loss_Date_Dim LS on LS.Loss_Date = DD.Loss_Date
join Transaction_Date_Dim TD on TD.Transaction_Date  = DD.Transaction_Date

/* finally i remove the first date_dim table because it doesnt have any use, anymore. */
DROP TABLE Date_Dim

/* populating the policy_dim  */
insert into Policy_Dim(Policy_Number,Tenure,Insurance_Type)
select distinct 
	POLICY_NUMBER,
	TENURE,
	INSURANCE_TYPE
from AA_Staging_Table

/* populating the transaction_dim */
insert into [dbo].[Transaction_dim]([Transaction_ID],[Claim_Status])
select distinct 
	[TRANSACTION_ID],
	CLAIM_STATUS
from AA_Staging_Table

/* populating the 1st vendor dimensions  */
select distinct 
	[VENDOR_ID],
	[Vendor_City],
	[Vendor_State]
INTO Vendors_1
from [AA_Staging_Table]

/* populating the vendor location dimension  */
insert into [dbo].[Vendor_Location_Dimension]([Vendor_City],[Vendor_State]) select distinct Vendor_City, Vendor_State from [dbo].[Vendors_1]




/* creating the main vendor dimension */
insert into [dbo].[Vendor_Dimension]([Vendor_ID],[Vendor_Location_Key])
select distinct 
	Vendor_Id,		
	Vendor_Location_Key
from [Vendors_1] V
join [Vendor_Location_Dimension] VLD on VLD.Vendor_City = V.Vendor_City and VLD.Vendor_State = V.Vendor_State

/* deleting the vendor_1, we dont need it anymore */
DROP TABLE Vendors_1

/* creating the customer 1st dimension */
SELECT DISTINCT
	[CUSTOMER_ID],
	[AGE],
	[CITY],
	[STATE],
	[MARITAL_STATUS],
	[SOCIAL_CLASS],
	[CUSTOMER_EDUCATION_LEVEL],
	[EMPLOYMENT_STATUS]
INTO Customer_Dim1
FROM AA_Staging_Table

/* populating the customer dimension, we use the UI to create the customer location key */
SELECT DISTINCT 
	[CITY],
	[STATE]
INTO Customer_Dim_Location
FROM [dbo].[Customer_Dim]

/* populating the customer profile dimension, we use the UI to create the customer key */
SELECT DISTINCT 
	MARITAL_STATUS,
	SOCIAL_CLASS,
	CUSTOMER_EDUCATION_LEVEL,
	EMPLOYMENT_STATUS
INTO Customer_Profile_Dim
FROM [master].[dbo].[Customer_Dim]

/* populating the main customer dimension */
SELECT DISTINCT 
	  Customer_Key,
	  Customer_Profile_Key,
	  Customer_ID,
	  Age,
	  C_Location_Key
  INTO Main_Customer_Dim
  FROM [master].[dbo].[Customer_Dim_Location] CDL
  JOIN [master].[dbo].[Customer_Dim] CD ON CDL.CITY = CD.CITY AND CDL.STATE = CD.STATE
  JOIN [dbo].[Customer_Profile_Dim] CPD 
  ON CPD.[MARITAL_STATUS] = CD.[MARITAL_STATUS] 
  AND CPD.SOCIAL_CLASS = CD.SOCIAL_CLASS 
  AND CPD.CUSTOMER_EDUCATION_LEVEL = CD.CUSTOMER_EDUCATION_LEVEL 
  AND CPD.EMPLOYMENT_STATUS = CD.EMPLOYMENT_STATUS 

  /*  deleting the 1st customer dimension */
  DROP TABLE Customer_Dim

  
/* Creating the first agent(employee) dimension  */
SELECT DISTINCT 
	[AGENT_ID],
	[Employee_City],
	[Employee_State]
INTO Agent_Dimension_111111111
FROM [dbo].[AA_Staging_Table]

/*  Populating the agent(employee) location dimension, i use the UI to create the A_Location_Key  */
SELECT DISTINCT 
	[Employee_City],
	[Employee_State]
INTO Agent_Location_Dimension
FROM [master].[dbo].[Agent_Dimension_111111111]

/*  Populating the main agent(employee) dimension  */
SELECT DISTINCT 
	Agent_Key,
	Agent_ID,
	A_Location_Key
INTO Main_Agent_Dimension
FROM Agent_Dimension_111111111 AD
JOIN Agent_Location_Dimension ADL ON AD.[Employee_City] = ADL.[Employee_City] AND AD.[Employee_State] = ADL.[Employee_State]

/*  deleting the first agent(employee) dimension, we do not need it anymore  */
  DROP TABLE Agent_Dimension_111111111

  /* Creating the first incident report dimension */
SELECT DISTINCT 
	[INCIDENT_HOUR_OF_THE_DAY],
	[CLAIM_STATUS],
	[INCIDENT_SEVERITY],
	[AUTHORITY_CONTACTED],
	[ANY_INJURY],
	[POLICE_REPORT_AVAILABLE],
	[INCIDENT_CITY],
	[INCIDENT_STATE]
INTO Incident_Report_Dim111111111
FROM AA_Staging_Table

/* creating the incident report dimension, we use the UI to create the incident location key */
SELECT DISTINCT
	[INCIDENT_CITY],
	[INCIDENT_STATE]
INTO Incident_Location_Dim
FROM [dbo].[Incident_Report_Dim111111111]

/*  creting the main report dimension */
SELECT DISTINCT
	   I_Location_Key
	  ,[INCIDENT_HOUR_OF_THE_DAY]
      ,[CLAIM_STATUS]
      ,[INCIDENT_SEVERITY]
      ,[AUTHORITY_CONTACTED]
      ,[ANY_INJURY]
      ,[POLICE_REPORT_AVAILABLE]
INTO Main_Incident_Report_Dim
FROM Incident_Location_Dim ILD
JOIN Incident_Report_Dim111111111 IRD 
ON ILD.[INCIDENT_CITY] =IRD.[INCIDENT_CITY]  
AND ILD.[INCIDENT_STATE] = IRD.[INCIDENT_STATE]

/* deleting the first incident report dimension, we dont need it anymore*/
DROP TABLE [dbo].[Incident_Report_Dim111111111]


/* we are making some changes to the date dimensions. I am adding the day, month and year columns */

alter table Transaction_Date_Dim add day_T int, month_T int, year_T int
update Transaction_Date_Dim
	set day_T = day(Transaction_Date), month_T = MONTH(Transaction_Date), year_T = year(Transaction_Date)

alter table Report_Date_dim add day_R int, month_R int, year_R int
update Report_Date_dim
	set day_R = day(Reported_Date), month_R = MONTH(Reported_Date), year_R = year(Reported_Date)

alter table Policy_Date_Dim add day_P int, month_P int, year_P int
update Policy_Date_Dim
	set day_P = day(Policy_Eff_Date), month_P = MONTH(Policy_Eff_Date), year_P = year(Policy_Eff_Date)

alter table Loss_Date_Dim add day_L int, month_L int, year_L int
update Loss_Date_Dim
	set day_L = day(Loss_Date), month_L = MONTH(Loss_Date), year_L = year(Loss_Date)