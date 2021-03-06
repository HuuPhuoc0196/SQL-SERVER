USE master
GO

CREATE DATABASE Northwind1
GO
-- Xem kết qua sau khi đã insert
SELECT * FROM Northwind1.dbo.KH1 ORDER BY Country 

SELECT * FROM Northwind1.dbo.KH2 ORDER BY Country 

----------------------------------------------------

USE Northwind1 
GO

CREATE PROC DSTatCaKHMuc1
AS
SELECT * FROM Northwind.dbo.Customers
GO

EXEC DSTatCaKHMuc1
GO

-- cách 1
USE Northwind1 
GO

CREATE PROC DSTatCaKHMuc2
AS
BEGIN
	SELECT * FROM Northwind1.dbo.KH1
	UNION 
	SELECT * FROM Northwind1.dbo.KH2
END
GO

EXEC DSTatCaKHMuc2
GO

-- cách 2
USE Northwind1 
GO

CREATE PROC DSTatCaKHMuc2Cach2
AS
BEGIN
	IF EXISTS ( -- nếu đã tồn tại bảng temp thì xóa
			SELECT * 
			FROM sys.tables
			JOIN sys.schemas
			ON sys.tables.schema_id = sys.schemas.schema_id
			WHERE sys.schemas.name = 'dbo' AND sys.tables.name = 'TEMP')
			
		DROP TABLE Northwind1.dbo.TEMP
		
	-- vừa tạo bảng TEMP vừa lấy dữ liệu từ phân mãnh KH1 đổ vào bảng TEMP
	SELECT * INTO Northwind1.dbo.TEMP FROM Northwind1.dbo.KH1
	-- lấy dữ liệu từ phân mãnh KH đổ vào bảng TEMP
	INSERT INTO Northwind1.dbo.TEMP SELECT * FROM Northwind1.dbo.KH2
	-- xuất kết quả có sắp xếp từ bảng TEMP
	SELECT * FROM TEMP ORDER BY Country
END
GO


USE Northwind1 
GO

CREATE PROC DSKHBietQGMuc1( @QG nvarchar(15))
AS
	SELECT * FROM Northwind.dbo.Customers WHERE Country = @QG
GO

EXEC DSKHBietQGMuc1 N'Canada'
GO

EXEC DSKHBietQGMuc1 N'USA'
GO

-- Mức 2

USE Northwind1 
GO

CREATE PROC DSKHBietQGMuc2( @QG nvarchar(15))
AS
BEGIN
	IF(@QG = N'USA' OR @QG = N'UK')
		SELECT * FROM Northwind1.dbo.KH1 WHERE Country = @QG
	ELSE 
		SELECT * FROM Northwind1.dbo.KH2 WHERE Country = @QG
END
GO

EXEC DSKHBietQGMuc2 N'Canada'
GO

EXEC DSKHBietQGMuc2 N'USA'
GO

------------- Phân mãnh ngang dẫn xuất --------------------

/*	9.bảng Đơn hàng dẫn xuất theo phân mảnh Khách hàng
	Tạo phân mảnh DH1 (đơn hàng 1) chứa các đơn hàng do các KH Mỹ và Anh mua
	Tạo phân mảnh DH2 (đơn hàng 2) chứa các đơn hàng do các KH còn lại mua
*/

USE Northwind1 
GO

-- tạo và lấy dữ liệu cho phân mãnh đơn hàng 1
SELECT * INTO dbo.DH1
FROM Northwind.dbo.Orders AS DH
WHERE DH.CustomerID IN (
		SELECT CustomerID FROM KH1 )
		-- hoặc
		/*
		SELECT CustomerID FROM Northwind.dbo.Customer
		WHERE Country = N'USA' OR Country = N'UK' ) */
GO


SELECT * INTO dbo.DH2
FROM Northwind.dbo.Orders AS DH
WHERE DH.CustomerID IN (
		SELECT CustomerID FROM KH2 )
		-- hoặc
		/*
		SELECT CustomerID FROM Northwind.dbo.Customer
		WHERE Country<> N'USA' AND Country <> N'UK' ) */
GO

-- danh sách tất cả đơn hàng mức 1
SELECT * FROM Northwind.dbo.Orders
GO

-- danh sách tót cả đơn hàng mức 2
SELECT * FROM DH1
UNION 
SELECT * FROM DH2
GO

-- Danh sách đơn hàng biết quốc gia khách hàng mua mức 1
USE Northwind1
GO

-- Danh sách đơn hàng biết quốc gia khách hàng mua mức 1	
CREATE PROC dbo.DSDHBietQGMuc1(@QG nvarchar(15))
AS
BEGIN
	SELECT * FROM Northwind.dbo.Orders AS DH
	WHERE DH.CustomerID IN (
		SELECT CustomerID FROM Northwind.dbo.Customers WHERE Country = @QG)
END
GO

EXEC dbo.DSDHBietQGMuc1 N'USA'
GO

-- Danh sách đơn hàng biết quốc gia khách hàng mức 2

USE Northwind1 
GO

CREATE PROC dbo.DSDHBietQGMuc2(@QG nvarchar(15))
AS
BEGIN
	if(@QG = N'USA' OR @QG = N'UK')
		SELECT * FROM Northwind1.dbo.DH1 AS DHMot
		WHERE DHMot.CustomerID IN (
			SELECT KHMot.CustomerID FROM Northwind1.dbo.KH1 AS KHMot WHERE KHMot.Country = @QG)
	ELSE
		SELECT * FROM Northwind1.dbo.DH2 AS DHHai
		WHERE DHHai.CustomerID IN (
			SELECT KHHai.CustomerID FROM Northwind1.dbo.KH1 AS KHHai WHERE KHHai.Country = @QG)
END
GO

EXEC dbo.DSDHBietQGMuc2 N'USA'
GO

--------------------- Phân mảnh dọc bảng dữ liệu -----------------
/*
	14.	Phân mảnh dọc trên bảng Employees (Nhân viên, tổng cộng 18 cột):
	-Phân mảnh NV1 gồm 4 cột:[EmployeeID], [LastName], [FirstName], [TitleOfCourtesy]
	-Phân mảnh NV2 gồm 15 cột:14 cột còn lại và cột [EmployeeID]
*/

-- Tạo và lấy dữ liệu cho phân mãnh NV1(Nhân viên 1)
USE Northwind1
GO
SELECT [EmployeeID], [LastName], [FirstName], [TitleOfCourtesy] INTO dbo.NV1 
FROM Northwind.dbo.Employees
GO

-- Tạo và lấy dữ liệu cho phân mãnh NV2 (Nhân viên 2)
USE Northwind1
GO
SELECT [EmployeeID],[Title],[BirthDate],[HireDate]
      ,[Address],[City],[Region],[PostalCode],[Country]
      ,[HomePhone],[Extension],[Photo],[Notes],[ReportsTo]
      ,[PhotoPath] INTO dbo.NV2
FROM Northwind.dbo.Employees
GO

-- Danh sách tất cá nhân viên mức 1 (9 hàng, 18 cột)
SELECT * FROM Northwind.dbo.Employees

-- 16.	Danh sách tất cả nhân viên mức 2 (9 hàng, 18 cột)
USE Northwind1
GO
SELECT TB1.[EmployeeID],[Title],[BirthDate],[HireDate]
      ,[Address],[City],[Region],[PostalCode],[Country]
      ,[HomePhone],[Extension],[Photo],[Notes],[ReportsTo]
      ,[PhotoPath]
FROM Northwind1.dbo.NV1 AS TB1, Northwind1.dbo.NV2 AS TB2

WHERE TB1.[EmployeeID] = TB2.[EmployeeID]
GO

---------------------------------------------------------------------