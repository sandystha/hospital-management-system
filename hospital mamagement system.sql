-- Patients Table
CREATE TABLE Patients (
    Patient_ID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100),
    Age INT,
    Gender CHAR(1),  -- 'M' for male, 'F' for female
    Admission_Date DATE,
    Discharge_Date DATE,
    Doctor_ID INT,
    FOREIGN KEY (Doctor_ID) REFERENCES Doctors(Doctor_ID)
);

-- Doctors Table
CREATE TABLE Doctors (
    Doctor_ID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100),
    Specialty VARCHAR(100),
    Experience_Years INT
);

-- Treatments Table
CREATE TABLE Treatments (
    Treatment_ID INT PRIMARY KEY AUTO_INCREMENT,
    Patient_ID INT,
    Doctor_ID INT,
    Treatment_Type VARCHAR(100),
    Start_Date DATE,
    End_Date DATE,
    Success BOOLEAN,  -- '1' for Yes, '0' for No
    FOREIGN KEY (Patient_ID) REFERENCES Patients(Patient_ID),
    FOREIGN KEY (Doctor_ID) REFERENCES Doctors(Doctor_ID)
);

-- Medications Table
CREATE TABLE Medications (
    Medication_ID INT PRIMARY KEY AUTO_INCREMENT,
    Patient_ID INT,
    Doctor_ID INT,
    Medication_Name VARCHAR(100),
    Dosage VARCHAR(50),
    Start_Date DATE,
    End_Date DATE,
    FOREIGN KEY (Patient_ID) REFERENCES Patients(Patient_ID),
    FOREIGN KEY (Doctor_ID) REFERENCES Doctors(Doctor_ID)
);

drop table hospital_resources;
-- Hospital Resources Table
CREATE TABLE Hospital_Resources (
    Resource_ID INT PRIMARY KEY AUTO_INCREMENT,
    Resource_Type VARCHAR(100),
    Total_Available INT,
    Currently_In_Use INT
);

-- Insert Doctors
INSERT INTO Doctors (Name, Specialty, Experience_Years) VALUES
('Dr. John Doe', 'Cardiology', 15),
('Dr. Jane Smith', 'Neurology', 12),
('Dr. Alex Johnson', 'Orthopedics', 8);

-- Insert Patients
INSERT INTO Patients (Name, Age, Gender, Admission_Date, Discharge_Date, Doctor_ID) VALUES
('Alice Brown', 45, 'F', '2024-09-01', '2024-09-10', 1),
('Bob White', 56, 'M', '2024-09-05', '2024-09-12', 2),
('Charlie Green', 34, 'M', '2024-09-07', NULL, 3);

-- Insert Treatments
INSERT INTO Treatments (Patient_ID, Doctor_ID, Treatment_Type, Start_Date, End_Date, Success) VALUES
(1, 1, 'Heart Surgery', '2024-09-02', '2024-09-08', 1),
(2, 2, 'Brain Surgery', '2024-09-06', '2024-09-10', 1),
(3, 3, 'Knee Surgery', '2024-09-08', NULL, 0);

-- Insert Medications
INSERT INTO Medications (Patient_ID, Doctor_ID, Medication_Name, Dosage, Start_Date, End_Date) VALUES
(1, 1, 'Aspirin', '500mg', '2024-09-02', '2024-09-09'),
(2, 2, 'Paracetamol', '1g', '2024-09-06', '2024-09-11'),
(3, 3, 'Ibuprofen', '400mg', '2024-09-08', NULL);

-- Insert Resources
INSERT INTO Hospital_Resources (Resource_Type, Total_Available, Currently_In_Use) VALUES
('Beds', 100, 80),
('MRI Machine', 5, 3),
('Ventilators', 20, 10);

 # Q 1 Patient Admission and Discharge Trends
 
 -- Monthly admission trends
SELECT name,admission_date,
    EXTRACT(MONTH FROM Admission_Date) AS Month, 
    COUNT(Patient_ID) AS Total_Admissions
FROM Patients
GROUP BY EXTRACT(MONTH FROM Admission_Date),name,admission_date
ORDER BY Month;

 -- monthly discharge 
 select name,admission_date,Discharge_Date,
 count(Patient_ID) as total_discharge,
 extract(month from Discharge_Date ) as month
 from patients 
 group by name,admission_date,Discharge_Date,
 extract(month from Discharge_Date )
 having month is not null
 order by month;
 

-- Doctor Performance

 # Q1 Number of patients treated by each doctor

SELECT 
    D.Name AS Doctor_Name,D.Specialty,p.name as patient_name,t.Treatment_Type as treatment,
    COUNT(P.Patient_ID) AS Patients_Treated
FROM Doctors D
JOIN Patients P ON D.Doctor_ID = P.Doctor_ID
join treatments  t on D.Doctor_ID=t.Doctor_ID
GROUP BY D.Name,p.name,D.Specialty,t.treatment_Type
ORDER BY Patients_Treated DESC;

- -- Q 2 Treatment success rate per doctor
SELECT 
    D.Name AS Doctor_Name, 
    COUNT(T.Treatment_ID) AS Total_Treatments,
    SUM(CASE WHEN T.Success = 1 THEN 1 ELSE 0 END) AS Successful_Treatments,
    (SUM(CASE WHEN T.Success = 1 THEN 1 ELSE 0 END) / COUNT(T.Treatment_ID)) * 100 AS Success_Rate
FROM Doctors D
JOIN Treatments T ON D.Doctor_ID = T.Doctor_ID
GROUP BY D.Name
ORDER BY Success_Rate DESC;


-- Resource usage report
SELECT 
    Resource_Type, 
    Total_Available, 
    Currently_In_Use, 
    (Currently_In_Use / Total_Available) * 100 AS Utilization_Rate
FROM hospital_resources
ORDER BY Utilization_Rate DESC;



-- Most prescribed medications
SELECT 
    Medication_Name, 
    COUNT(Medication_ID) AS Prescription_Count
FROM Medications
GROUP BY Medication_Name
ORDER BY Prescription_Count DESC;


-- Average duration of treatments
SELECT 
    Treatment_Type, 
    AVG(DATEDIFF(End_Date, Start_Date)) AS Avg_Treatment_Duration
FROM Treatments
GROUP BY Treatment_Type
having Avg_Treatment_Duration is not null;


-- Analyze medications associated with successful treatments
SELECT 
    M.Medication_Name, 
    COUNT(T.Treatment_ID) AS Successful_Treatments
FROM Medications M
JOIN Treatments T ON M.Patient_ID = T.Patient_ID
WHERE T.Success = 1
GROUP BY M.Medication_Name
ORDER BY Successful_Treatments DESC;


