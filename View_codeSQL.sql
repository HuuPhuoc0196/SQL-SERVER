USE Northwind
GO

CREATE VIEW KhachHang
AS
SELECT CustomerID, CompanyName, ContactName, ContactTitle, Address, Country, Phone
FROM Customers
WHERE Country = N'UK' OR Country = N'USA'
GO


