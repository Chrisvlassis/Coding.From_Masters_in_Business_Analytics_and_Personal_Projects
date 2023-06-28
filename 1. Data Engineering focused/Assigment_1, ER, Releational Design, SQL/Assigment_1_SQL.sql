# 2 
CREATE TABLE Prescription(
Prescription_ID INT PRIMARY KEY,
Date_Time DATETIME,
Quantity INT,
Doctor_ID INT,
Drug_ID INT,
SSN INT,
FOREIGN KEY (Doctor_ID) REFERENCES doctor(Doctor_ID),
FOREIGN KEY (Drug_ID) REFERENCES drug(Drug_ID),
FOREIGN KEY (SSN) REFERENCES patient(SSN));

CREATE TABLE Doctor(
Doctor_ID INT PRIMARY KEY,
Doctor_Name VARCHAR(40),
Specialization VARCHAR(40),
Area_ID INT,
FOREIGN KEY (Area_ID) REFERENCES areaa(Area_ID));

CREATE TABLE Areaa(
Area_ID INT PRIMARY KEY,
Area_Name VARCHAR(40),
Mean_Income INT);

CREATE TABLE Drug(
Drug_ID INT PRIMARY KEY,
Drug_Name VARCHAR(40),
Descriptionn VARCHAR(100), 
Price INT);

CREATE TABLE Patient(
SSN INT PRIMARY KEY,
Patient_Name VARCHAR(40),
Phone_Number INT,
Gender VARCHAR(40),
Date_of_Birth DATE);

# 3 
# a.
SELECT 
    p.Patient_Name,p.SSN 
FROM
    patient AS p,
    prescription AS pr
WHERE
    Gender = 'Male'
        AND DATE_FORMAT(FROM_DAYS(DATEDIFF(NOW(), date_of_Birth)),
            '%Y') + 0 > 30
        AND YEAR(Date_Time) = '2021'
        AND p.SSN = pr.SSN
GROUP BY p.SSN;

# b. 
select SSN, Total_Amount
FROM( SELECT
	 p.SSN,Quantity, Price, sum(Price*Quantity) AS Total_Amount
from prescription pr 
JOIN drug dr ON pr.Drug_ID = dr.Drug_ID
JOIN patient p ON p.SSN = pr.SSN
WHERE Gender = 'Female' AND
	year(Date_Time) = '2021'
group by p.SSN) as tableee
where Total_Amount>1000;

# c.
SELECT 
	a.Area_ID,
    a.Area_Name,
    sum(Quantity) as Total_Amount_of_Drugs
FROM areaa a 
JOIN doctor d ON d.Area_ID = a.Area_ID
JOIN prescription p ON p.Doctor_ID = d.Doctor_ID
JOIN drug dr ON dr.Drug_ID = p.Drug_ID
	group by a.Area_ID;

# d.
SELECT p.Drug_ID,EXTRACT(MONTH FROM Date_Time) as Month,COUNT(Prescription_ID) as total_amount_of_perscriptions
FROM prescription p 
JOIN drug dr ON dr.Drug_ID = p.Drug_ID
WHERE YEAR(Date_Time) = '2021'
GROUP BY EXTRACT(MONTH FROM Date_Time),p.Drug_ID;

# e.
select 
pr.Doctor_ID,
Doctor_Name,
count(Prescription_ID) as total_amount_of_perscriptions
from areaa a 
JOIN doctor dr ON dr.Area_ID = a.Area_ID
JOIN prescription pr ON pr.Doctor_ID = dr.Doctor_ID
WHERE Mean_Income BETWEEN 20000 and 30000
group by pr.Doctor_ID;

# f.
select 
Specialization,
count(Prescription_ID) as total_number_of_perscriptions
from doctor d
JOIN prescription p ON p.Doctor_ID = d.Doctor_ID
WHERE year(Date_Time) = '2021' 
group by Specialization;

# g. 
select 
	Drug_ID,
	CONCAT((count(CASE when year(Date_Time) = '2021' then 1 end) - count(CASE when year(Date_Time) = '2020' then 1 end))
    /count(CASE when year(Date_Time) = '2020' then 1 end)*100, '%') as percentage_of_Change
from prescription 
group by Drug_ID;

# h.
select 
	pr.Drug_ID,
	CASE 
		WHEN Gender = 'Male' THEN  COUNT(Prescription_ID)
	END as MALES,
    CASE 
		WHEN Gender = 'Female' THEN  COUNT(Prescription_ID)
	END as FEMALES
from patient p 
JOIN prescription pr ON p.SSN = pr.SSN
JOIN drug dr ON dr.Drug_ID = pr.Drug_ID
WHERE YEAR(Date_Time) = '2021'
GROUP BY Gender, pr.Drug_ID;

# FOR PYTHON
SELECT 
	pr.Prescription_ID,
    pr.Date_Time,
    p.Patient_Name,
    p.Phone_Number,
    dr.Doctor_Name,
    dr.Specialization,
    d.Drug_Name,
    d.Price,
    pr.Quantity
FROM patient p 
JOIN prescription pr ON p.SSN = pr.SSN
JOIN doctor dr ON dr.Doctor_ID = pr.Doctor_ID
JOIN areaa a ON dr. Area_ID = a.Area_ID
JOIN drug d ON pr.Drug_ID = d.Drug_ID;









