create database shankar;

SELECT * FROM employee_attrition LIMIT 10;


CREATE TABLE dim_department (
    DepartmentID INT PRIMARY KEY AUTO_INCREMENT,
    DepartmentName VARCHAR(50)
);

INSERT INTO dim_department (DepartmentName)
SELECT DISTINCT Department
FROM employee_attrition;


CREATE TABLE dim_job (
    JobID INT PRIMARY KEY AUTO_INCREMENT,
    JobRole VARCHAR(50)
);

INSERT INTO dim_job (JobRole)
SELECT DISTINCT JobRole
FROM employee_attrition;

select* from fact_employee_attrition;
CREATE TABLE dim_employee (
    EmployeeID INT PRIMARY KEY,
    Age INT,
    Gender VARCHAR(10)
);

INSERT INTO dim_employee (EmployeeID, Age, Gender)
SELECT DISTINCT EmployeeNumber, Age, Gender
FROM employee_attrition;


CREATE TABLE fact_employee_attrition (
    FactID INT PRIMARY KEY AUTO_INCREMENT,
    EmployeeID INT,
    DepartmentID INT,
    JobID INT,
    AttritionFlag INT,
    MonthlyIncome INT,
    YearsAtCompany INT,
    JobSatisfaction INT,
    WorkLifeBalance INT,
    FOREIGN KEY (EmployeeID) REFERENCES dim_employee(EmployeeID),
    FOREIGN KEY (DepartmentID) REFERENCES dim_department(DepartmentID),
    FOREIGN KEY (JobID) REFERENCES dim_job(JobID)
);


INSERT INTO fact_employee_attrition (EmployeeID, DepartmentID, JobID, AttritionFlag, MonthlyIncome, YearsAtCompany, JobSatisfaction, WorkLifeBalance)
SELECT 
    e.EmployeeNumber,
    d.DepartmentID,
    j.JobID,
    CASE WHEN e.Attrition = 'Yes' THEN 1 ELSE 0 END,
    e.MonthlyIncome,
    e.YearsAtCompany,
    e.JobSatisfaction,
    e.WorkLifeBalance
FROM employee_attrition e
JOIN dim_department d ON e.Department = d.DepartmentName
JOIN dim_job j ON e.JobRole = j.JobRole;


-- Fact table
SELECT * FROM fact_employee_attrition LIMIT 10;

-- Join fact and dimensions
SELECT f.FactID, e.Age, e.Gender, d.DepartmentName, j.JobRole, f.AttritionFlag
FROM fact_employee_attrition f
JOIN dim_employee e ON f.EmployeeID = e.EmployeeID
JOIN dim_department d ON f.DepartmentID = d.DepartmentID
JOIN dim_job j ON f.JobID = j.JobID
LIMIT 10;


select* from fact_employee_attrition;
select * from dim_department;
select * from dim_employee;
select*from dim_job;

ALTER TABLE fact_employee_attrition
ADD Gender VARCHAR(10);

UPDATE fact_employee_attrition f
JOIN dim_employee e ON f.EmployeeID = e.EmployeeID
SET f.Gender = e.Gender;

SELECT EmployeeID, Gender, AttritionFlag, DepartmentID, JobID
FROM fact_employee_attrition
LIMIT 10;



SELECT 
DepartmentID,
d.DepartmentName,
       SUM(f.AttritionFlag) AS AttritionCount
FROM fact_employee_attrition f
JOIN dim_department d ON f.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentID

ORDER BY AttritionCount DESC;




       
       select*from dim_department;
       select* from dim_employee;
       select*from dim_job;
       select*from fact_employee_attrition;
       
       
        SELECT
    f.DepartmentID,
    d.DepartmentName,
    SUM(f.AttritionFlag) AS AttritionCount
FROM fact_employee_attrition f
JOIN dim_department d
    ON f.DepartmentID = d.DepartmentID
GROUP BY
    f.DepartmentID,
    d.DepartmentName
ORDER BY DepartmentID DESC;