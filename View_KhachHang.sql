USE Northwind
GO

CREATE VIEW KhachHang
AS
SELECT CustomerID, CompanyName, ContactName, ContactTitle, Address, Country, Phone
FROM Customers
WHERE Country = N'UK' OR Country = N'USA'
GO

CREATE VIEW DSKhachHangVip
AS
SELECT *
FROM Customers
WHERE ContactTitle = N'Sales Manager' OR ContactTitle = N'Owner'
GO


