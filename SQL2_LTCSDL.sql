----- PHẦN 1: VIEW -------

----- Câu 1 -------
USE HRDatabase
GO
CREATE VIEW EmployeesInfo
AS
	SELECT e.first_name, e.last_name, j.job_title, e.salary, d.department_name
	FROM ((hr.employees e INNER JOIN hr.jobs j ON e.job_id = j.job_id)
						  INNER JOIN hr.departments d ON e.department_id = d.department_id)
	WHERE e.salary < 9000 and (d.department_name = N'Marketing' or d.department_name = N'Administration')
GO

--- Kiểm tra
SELECT * FROM dbo.EmployeesInfo

----- Câu 2 -------
USE HRDatabase
GO
CREATE VIEW ManagerInfo
AS
	SELECT TOP(100) manager_id, COUNT(*) as N'Number Of Employees'
	FROM hr.employees
	GROUP BY manager_id
	ORDER BY COUNT(*) 
GO

--- Kiểm tra
SELECT * FROM dbo.ManagerInfo

----- Câu 3 -------
USE HRDatabase
GO
CREATE VIEW Top20_EmployeesInfo
AS
	SELECT TOP(20) e.first_name, e.last_name, j.start_date, e.salary, d.department_name
	FROM ((hr.employees e INNER JOIN hr.job_history j ON e.job_id = j.job_id)
						  INNER JOIN hr.departments d ON e.department_id = d.department_id)
	WHERE e.last_name NOT LIKE '%M%'
	ORDER BY  d.department_name
GO

--- Kiểm tra
SELECT * FROM Top20_EmployeesInfo

----- Câu 4 -------
USE HRDatabase
GO
CREATE VIEW EmployeesInfos
AS
	SELECT e.first_name + N' - ' + e.last_name + N' - ' + e.phone_number + N' - ' + e.email as N'Informations',
			 e.hire_date, e.salary, d.department_id, e.commission_pct
	FROM ((hr.employees e INNER JOIN hr.job_history j ON e.job_id = j.job_id)
						  INNER JOIN hr.departments d ON e.department_id = d.department_id)
	WHERE (e.salary >= 8000 and e.salary <= 12000 and e.commission_pct IS NOT NULL)
		  or (d.department_id NOT IN (40, 120, 70) and e.hire_date <= N'1987-6-5')
GO

--- Kiểm tra
SELECT * FROM EmployeesInfos

----- Câu 5 -------
USE HRDatabase
GO
CREATE VIEW Employees_Info
AS
	SELECT e.first_name + N' - ' + e.last_name as N'Full_Name',
			e.phone_number + N' - ' + e.email + N' - ' + j.job_title as N'Contact_Details',
			e.salary as N'Remuneration'
	FROM hr.employees e INNER JOIN hr.jobs j ON e.job_id = j.job_id
	WHERE e.salary >= 9000 and e.salary <= 17000
GO

--- Kiểm tra
SELECT * FROM Employees_Info

----- Câu 6 -------
USE HRDatabase
GO
CREATE VIEW Employees_Infos
AS
	SELECT TOP(100) e.first_name + N' - ' + e.last_name as N'Full_Name', e.salary, j.job_title, e.manager_id
	FROM hr.employees e INNER JOIN hr.jobs j ON e.job_id = j.job_id
	WHERE e.salary < 7000 or e.salary > 15000
	ORDER BY e.first_name + N' - ' + e.last_name
GO

--- Kiểm tra
SELECT * FROM Employees_Infos

----- Câu 7 -------
USE HRDatabase
GO
CREATE VIEW EmployeesInfor
AS
	SELECT e.first_name + N' ' + e.last_name as N'Full_Name', j.job_title, e.salary, h.start_date
	FROM ((hr.employees e INNER JOIN hr.jobs j ON e.job_id = j.job_id)
						  INNER JOIN hr.job_history h ON e.job_id = h.job_id)
	WHERE h.start_date BETWEEN N'2007-11-5' AND N'2009-7-5'
GO

--- Kiểm tra
SELECT * FROM dbo.EmployeesInfor

----- Câu 8 -------
USE HRDatabase
GO
CREATE VIEW Employees_Infor
AS
	SELECT TOP(100) e.first_name + N' - ' + e.last_name as N'Full_Name',
			e.phone_number + N' - ' + e.email + N' - ' + j.job_title as N'Contact_Details',
			e.salary as N'Remuneration', h.start_date
	FROM ((hr.employees e INNER JOIN hr.jobs j ON e.job_id = j.job_id)
						  INNER JOIN hr.job_history h ON e.job_id = h.job_id)
	WHERE e.salary > 11000 or SUBSTRING(e.phone_number, 7, 1) = N'3'
	ORDER BY e.first_name
GO

--- Kiểm tra
SELECT * FROM dbo.Employees_Infor

----- Câu 9 -------
USE HRDatabase
GO
CREATE VIEW EmployeesWorking2_Or_MoreJobs
AS
	SELECT *
	FROM hr.employees e
	WHERE e.employee_id IN (SELECT h.employee_id
							FROM hr.job_history h
							GROUP BY employee_id
							HAVING COUNT(*) >= 2)
GO

--- Kiểm tra
SELECT * FROM EmployeesWorking2_Or_MoreJobs

----- Câu 10 -------
USE HRDatabase
GO
CREATE VIEW WorkingMore300Days
AS
	SELECT j.job_title, DATEDIFF(DAY, h.start_date, h.end_date) as N'WorkingDay Numbers'
	FROM hr.jobs j, hr.job_history h
	WHERE DATEDIFF(DAY, h.start_date, h.end_date) > 300
GO

--- Kiểm tra
SELECT * FROM WorkingMore300Days


----- PHẦN 2: STORED PROCEDURE -------

----- Câu 1 -------
USE HRDatabase
GO
CREATE PROC sp_DepartmentInTheCity
@city NVARCHAR(30)
AS
BEGIN
	SELECT TOP(100) d.*, l.city
	FROM hr.departments d, hr.locations l 
	WHERE d.location_id = l.location_id and l.city = @city
	ORDER BY d.department_name
END
GO

---- Kiểm tra
EXEC sp_DepartmentInTheCity N'Seattle'

----- Câu 2 -------
USE HRDatabase
GO
CREATE PROC sp_EmployeesWorkingJob
@Work NVARCHAR(30)
AS
BEGIN
	SELECT e.first_name + N' ' + e.last_name as N'Full_Name', e.hire_date, j.job_title
	FROM hr.employees e, hr.jobs j
	WHERE e.job_id = j.job_id and j.job_title = @Work
	ORDER BY e.first_name + N' ' + e.last_name
END
GO

---- Kiểm tra
EXEC sp_EmployeesWorkingJob N'Programmer'

----- Câu 3 -------
USE HRDatabase
GO
CREATE PROC sp_AverageSalary_GetCommission
AS
BEGIN
	SELECT d.department_id, AVG(e.salary) as N'Average Salary'
	FROM hr.employees e, hr.departments d
	WHERE e.department_id = d.department_id and e.commission_pct IS NOT NULL
	GROUP BY d.department_id
END
GO

---- Kiểm tra
EXEC sp_AverageSalary_GetCommission

----- Câu 4 -------
USE HRDatabase
GO
CREATE PROC sp_Department_AnyMan_4Employees
AS
BEGIN
	SELECT h.manager_id, h.department_name, l.street_address, l.state_province, l.city, l.postal_code
	FROM ((hr.departments h INNER JOIN hr.employees e ON e.department_id = h.department_id)
							INNER JOIN hr.locations l ON h.location_id = l.location_id)
	WHERE e.employee_id IN (SELECT h1.manager_id
						    FROM hr.departments h1, hr.employees e1
						    WHERE h1.manager_id = e1.manager_id
						    GROUP BY h1.manager_id
						    HAVING COUNT(*) >= 4)
END
GO
---- Kiểm tra
EXEC sp_Department_AnyMan_4Employees

----- Câu 5 -------
USE HRDatabase
GO
CREATE PROC sp_DepartmentMore10_Commission
AS
BEGIN
	SELECT h.*
	FROM hr.departments h
	WHERE h.manager_id IN (	SELECT h1.manager_id
							FROM hr.departments h1, hr.employees e1
							WHERE h1.manager_id = e1.manager_id
							GROUP BY h1.manager_id
							HAVING COUNT(*) >= 10 )
END
GO
---- Kiểm tra
EXEC sp_DepartmentMore10_Commission

----- Câu 6 -------
USE HRDatabase
GO
CREATE PROC sp_Employees_JobHistory
AS
BEGIN
	SELECT e.first_name + N' ' + e.last_name as N'Full_Name', j.job_id, j.end_date
	FROM hr.employees e INNER JOIN hr.job_history j ON e.employee_id = j.employee_id
END
GO
---- Kiểm tra
EXEC sp_Employees_JobHistory

----- Câu 7 -------
USE HRDatabase
GO
CREATE PROC sp_SalaryOfEmployees
AS
BEGIN
	SELECT job_id, COUNT(*) as Number_Of_Employees, SUM(salary) as Sum_Of_Salary, 
			MAX(salary) - MIN(salary) AS Salary_Difference 
	FROM hr.employees 
	GROUP BY job_id;
END
GO
---- Kiểm tra
EXEC sp_SalaryOfEmployees

----- Câu 8 -------
USE HRDatabase
GO
CREATE PROC sp_EmployeesInfo
@MaPB BIGINT
AS
BEGIN
	SELECT e.*
	FROM hr.employees e
	WHERE e.commission_pct IS NULL and (e.salary >= 7000 and e.salary <= 12000)
			and e.department_id = @MaPB
END
GO

---- Kiểm tra
EXEC sp_EmployeesInfo 100

----- Câu 9 -------
USE HRDatabase
GO
CREATE PROC sp_EmployeesInformation
@Date DATE
AS
BEGIN
	SELECT e.*
	FROM hr.employees e
	WHERE e.hire_date >= @Date
	ORDER BY e.hire_date
END
GO

---- Kiểm tra
EXEC sp_EmployeesInformation N'1999-2-7'