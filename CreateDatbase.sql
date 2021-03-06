USE master
GO
CREATE DATABASE Northwind1
GO

USE Northwind1
GO
-- Cách một tạo bảng rỗng rồi insert vào bảng
CREATE TABLE KH1(
	[CustomerID] [nchar](5) PRIMARY KEY,
	[CompanyName] [nvarchar](40) NOT NULL,
	[ContactName] [nvarchar](30) NULL,
	[ContactTitle] [nvarchar](30) NULL,
	[Address] [nvarchar](60) NULL,
	[City] [nvarchar](15) NULL,
	[Region] [nvarchar](15) NULL,
	[PostalCode] [nvarchar](10) NULL,
	[Country] [nvarchar](15) NULL,
	[Phone] [nvarchar](24) NULL,
	[Fax] [nvarchar](24) NULL
)
Go

CREATE TABLE KH2(
	[CustomerID] [nchar](5) PRIMARY KEY,
	[CompanyName] [nvarchar](40) NOT NULL,
	[ContactName] [nvarchar](30) NULL,
	[ContactTitle] [nvarchar](30) NULL,
	[Address] [nvarchar](60) NULL,
	[City] [nvarchar](15) NULL,
	[Region] [nvarchar](15) NULL,
	[PostalCode] [nvarchar](10) NULL,
	[Country] [nvarchar](15) NULL,
	[Phone] [nvarchar](24) NULL,
	[Fax] [nvarchar](24) NULL
)
Go

-- insert vao bảng
INSERT INTO Northwind1.dbo.KH1
SELECT * FROM Northwind.dbo.Customers AS KH
WHERE (KH.Country = N'USA') OR (KH.Country = N'UK')
Go

INSERT INTO Northwind1.dbo.KH2
SELECT * FROM Northwind.dbo.Customers AS KH
WHERE (KH.Country <> N'USA') AND (KH.Country <> N'UK')
Go

USE Northwind1 
GO
-- tạo và lấy dữ liệu cho phân mãnh đơn hàng 1
CREATE TABLE [dbo].[DH1](
	[OrderID] int PRIMARY KEY,
	[CustomerID] [nchar](5) NULL,
	[EmployeeID] [int] NULL,
	[OrderDate] [datetime] NULL,
	[RequiredDate] [datetime] NULL,
	[ShippedDate] [datetime] NULL,
	[ShipVia] [int] NULL,
	[Freight] [money] NULL,
	[ShipName] [nvarchar](40) NULL,
	[ShipAddress] [nvarchar](60) NULL,
	[ShipCity] [nvarchar](15) NULL,
	[ShipRegion] [nvarchar](15) NULL,
	[ShipPostalCode] [nvarchar](10) NULL,
	[ShipCountry] [nvarchar](15) NULL
)
GO
INSERT INTO Northwind1.dbo.DH1
SELECT * 
FROM Northwind.dbo.Orders AS DH
WHERE DH.CustomerID IN (
		--SELECT CustomerID FROM KH1)
		-- hoặc
		
		SELECT CustomerID FROM Northwind.dbo.Customers
		WHERE Country = N'USA' OR Country = N'UK' ) 
GO

USE Northwind1 
GO
-- tạo và lấy dữ liệu cho phân mãnh đơn hàng 2
CREATE TABLE [dbo].[DH2](
	[OrderID] int PRIMARY KEY,
	[CustomerID] [nchar](5) NULL,
	[EmployeeID] [int] NULL,
	[OrderDate] [datetime] NULL,
	[RequiredDate] [datetime] NULL,
	[ShippedDate] [datetime] NULL,
	[ShipVia] [int] NULL,
	[Freight] [money] NULL,
	[ShipName] [nvarchar](40) NULL,
	[ShipAddress] [nvarchar](60) NULL,
	[ShipCity] [nvarchar](15) NULL,
	[ShipRegion] [nvarchar](15) NULL,
	[ShipPostalCode] [nvarchar](10) NULL,
	[ShipCountry] [nvarchar](15) NULL
)
GO
INSERT INTO Northwind1.dbo.DH2
SELECT *
FROM Northwind.dbo.Orders AS DH
WHERE DH.CustomerID IN (
		--SELECT CustomerID FROM KH2 )
		-- hoặc
		
		SELECT CustomerID FROM Northwind.dbo.Customers
		WHERE Country<> N'USA' AND Country <> N'UK' ) 
GO

-- Tạo và lấy dữ liệu cho phân mãnh NV2 (Nhân viên 1)
USE Northwind1
GO
CREATE TABLE [dbo].[NV1](
	[EmployeeID] [int] PRIMARY KEY,
	[LastName] [nvarchar](20) NOT NULL,
	[FirstName] [nvarchar](10) NOT NULL,
	[TitleOfCourtesy] [nvarchar](25) NULL
)
GO
INSERT INTO Northwind1.dbo.NV1
SELECT [EmployeeID], [LastName], [FirstName], [TitleOfCourtesy]
FROM Northwind.dbo.Employees
GO


-- Tạo và lấy dữ liệu cho phân mãnh NV2 (Nhân viên 2)
CREATE TABLE [dbo].[NV2](
	[EmployeeID] [int] PRIMARY KEY,
	[Title] [nvarchar](30) NULL,
	[BirthDate] [datetime] NULL,
	[HireDate] [datetime] NULL,
	[Address] [nvarchar](60) NULL,
	[City] [nvarchar](15) NULL,
	[Region] [nvarchar](15) NULL,
	[PostalCode] [nvarchar](10) NULL,
	[Country] [nvarchar](15) NULL,
	[HomePhone] [nvarchar](24) NULL,
	[Extension] [nvarchar](4) NULL,
	[Photo] [image] NULL,
	[Notes] [ntext] NULL,
	[ReportsTo] [int] NULL,
	[PhotoPath] [nvarchar](255) NULL
)
GO
INSERT INTO Northwind1.dbo.NV2
SELECT [EmployeeID],[Title],[BirthDate],[HireDate]
      ,[Address],[City],[Region],[PostalCode],[Country]
      ,[HomePhone],[Extension],[Photo],[Notes],[ReportsTo]
      ,[PhotoPath]
FROM Northwind.dbo.Employees
GO
