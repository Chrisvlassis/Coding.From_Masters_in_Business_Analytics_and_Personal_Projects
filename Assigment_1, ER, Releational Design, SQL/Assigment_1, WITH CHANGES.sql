
# c.
SELECT 
	a.Area_ID,
    a.Area_Name,
    sum(Price*Quantity) as Total_Amount_of_Money
FROM areaa a 
JOIN doctor d ON d.Area_ID = a.Area_ID
JOIN prescription p ON p.Doctor_ID = d.Doctor_ID
JOIN drug dr ON dr.Drug_ID = p.Drug_ID
	group by a.Area_ID;
    
# d.
SELECT 
	p.Drug_ID,
	EXTRACT(MONTH FROM Date_Time) as Month,
    sum(Price*Quantity) as Total_Amount_of_Money
FROM prescription p 
JOIN drug dr ON dr.Drug_ID = p.Drug_ID
WHERE YEAR(Date_Time) = '2021'
GROUP BY EXTRACT(MONTH FROM Date_Time),p.Drug_ID;

# e.
select 
	pr.Doctor_ID,
	Doctor_Name,
    sum(Price*Quantity) as Total_Amount_of_Money
from areaa a 
JOIN doctor dr ON dr.Area_ID = a.Area_ID
JOIN prescription pr ON pr.Doctor_ID = dr.Doctor_ID
JOIN drug drg ON drg.Drug_ID = pr.Drug_ID
WHERE Mean_Income BETWEEN 20000 and 30000
group by pr.Doctor_ID;



# g. 
select 
	pr.Drug_ID,
	concat((SUM(CASE when year(Date_Time) = '2021' then Price*Quantity end) - SUM(CASE when year(Date_Time) = '2020' then Price*Quantity end))
    /
    SUM(CASE when year(Date_Time) = '2020' then Price*Quantity end)*100, '%') as Total_Amount_of_Money
from prescription pr
JOIN drug dr ON dr.Drug_ID = pr.Drug_ID
group by Drug_ID;


# h. 
select 
	pr.Drug_ID,
	sum(CASE 
		WHEN Gender = 'Male' THEN  Price*Quantity
	END) as MALES,
    sum(CASE 
		WHEN Gender = 'Female' THEN  Price*Quantity
	END) as FEMALES
from patient p 
JOIN prescription pr ON p.SSN = pr.SSN
JOIN drug dr ON dr.Drug_ID = pr.Drug_ID
WHERE YEAR(Date_Time) = '2021'
GROUP BY Gender, pr.Drug_ID;

























    
