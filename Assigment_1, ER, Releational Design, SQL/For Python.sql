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