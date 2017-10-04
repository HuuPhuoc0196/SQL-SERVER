USE Northwind
GO

/* 
	Tạo View tên DSKhachHangMyAnh: tạo danh sách khách hàng từ 2 nước Mỹ và Anh,
	gồm các cột: CustomerID, CompanyName, Country, Address, City, Phone, Fax. 
	Danh sách sắp tăng dần theo cột CustomerID. 
*/

CREATE VIEW DSKhachHangMyAnh AS
SELECT TOP 100 CustomerID, CompanyName, Country, Address, City, Phone, fax 
FROM Customers
ORDER BY CustomerID ASC

/*
		Tạo View tên DSDonHangCuaKhachHangMyAnh: danh sách đơn hàng của các khách hàng từ nước Anh và Mỹ, 
		danh sách gồm tất cả các cột của bảng Orders và cột Country của bảng Customers. 
		Sinh viên thực hiện 2 cách: bằng công cụ và bằng code sql, và có chạy thử kiểm tra kết quả của view đã tạo
*/

CREATE VIEW DSDonHangCuaKhachHangMyAnh AS
SELECT Orders.*, Customers.Country
FROM Orders, Customers
WHERE Orders.CustomerID = Customers.CustomerID
AND Country = 'UK' OR Country = 'USA'

/*
	Tạo View tên DSKhachHangLaVIP: danh sách gồm tất cả các cột của bảng Customers, 
	chỉ lấy các khách hàng có chức danh là giám đốc hay là chủ 
	(trong field ContactTitle có từ “manager” hay là “Owner”).
*/

CREATE VIEW DSKhachHangLaVIP AS
SELECT * FROM Customers WHERE ContactTitle = 'Owner' OR ContactTitle LIKE '%Manager%'

/*
	Tạo View tên DSDonHang: danh sách gồm các cột OrderID, OrderDate, TongTienDonHang. 
	Trong đó cột  TongTienDonHang tính bằng SUM(UnitPrice*Quantity*(1-Discount)).
*/

CREATE VIEW DSDonHang AS
SELECT Orders.OrderID, OrderDate, SUM(UnitPrice*Quantity*(1-Discount)) AS TongTienDonHang
FROM Orders, [Order Details]
GROUP BY Orders.OrderID, OrderDate

/*
	Tạo View tên DSThongKeTheoQGKhachHang: 
	danh sách nhóm theo Country gồm các cột Country, SLKhachHang, SLDonHang, TongTienMuaHang.
*/

----- sai gì đó----
CREATE VIEW DSThongKeTheoQGKhachHang AS
SELECT Country, COUNT(Customers.CustomerID) AS SLKhachHang, COUNT(OrderID) AS SLDonHang, SUM(ShipVia * Freight) AS TongTienMuaHang
FROM Customers, Orders
WHERE Customers.CustomerID = Orders.CustomerID
GROUP BY Country

/*
	 Tạo Stored procedure tên DSKhachHang có một tham số vào là tên của một quốc gia,
	 kết quả là tạo một danh sách các khách hàng của quốc gia đó, 
	 danh sách gồm tất cả các cột của bảng Customers.
*/

CREATE PROC DSKhachHang @TenQuocGia nvarchar(15) AS
BEGIN
	SELECT * FROM Customers WHERE Country = @TenQuocGia
END

DECLARE @tenQuocGia nvarchar(15) = 'Mexico'
EXEC DSKhachHang @tenQuocGia

/*
	 Tạo Stored procedure tên DSDonHangTungQuocGia có một tham số vào là tên quốc gia của khách hàng,
	 kết quả là danh sách các đơn hàng do các khách hàng của quốc gia đó mua, 
	 danh sách gồm tất cả các cột của bảng Orders và cột Country của bảng Customers
*/

CREATE PROC DSDonHangTungQuocGia @TenQuocGia nvarchar(15) AS
BEGIN
	SELECT Orders.*, Country FROM Orders, Customers
	WHERE Orders.CustomerID = Customers.CustomerID
	AND Country = @TenQuocGia
END

DECLARE @tenQuocGia nvarchar(15) = 'Germany'
EXEC DSDonHangTungQuocGia @tenQuocGia

/*
	Tạo Stored procedure tên SLKhachHangTungQuocGia có một tham số vào là tên quốc gia của khách hàng, 
	kết quả là số lượng khách hàng thuộc quốc gia đó.
*/

CREATE PROC SLKhachHangTungQuocGia @TenQuocGia nvarchar(15) AS
BEGIN
	SELECT Country, COUNT(CustomerID) AS SLKhachHang FROM Customers
	WHERE Country = @TenQuocGia
	GROUP BY Country
END

DECLARE @tenQuocGia nvarchar(15) = 'Brazil'
EXEC SLKhachHangTungQuocGia @tenQuocGia

/*
	Tạo Stored procedure tên SLKhachHangTungQuocGia2 có một tham số vào là tên quốc gia của khách hàng,
	một tham số ra (integer) là số lượng khách hàng thuộc quốc gia đó.
*/

CREATE PROC SLKhachHangTungQuocGia2 @TenQuocGia nvarchar(15), @SLKhachHang int out AS
BEGIN
	 SELECT @SLKhachHang = COUNT(CustomerID) FROM Customers
END

DECLARE @tenQuocGia nvarchar(15) = 'UK', @SLKhachHang int
EXEC SLKhachHangTungQuocGia2 @tenQuocGia, @SLKhachHang out
PRINT N'Số lượng khách hàng thuộc quốc gia ' + @tenQuocGia + N' là: ' + CAST(@SLKhachHang AS nvarchar)

/*
	Tạo Stored procedure tên SLKhachHangTungQuocGia3 có một tham số vào là tên quốc gia của khách hàng, 
	một tham số ra (integer) là số lượng khách hàng thuộc quốc gia đó. 
	Nếu không nhập tham số vào (tên quốc gia), sẽ in ra số lượng tất cả khách hàng.
*/

CREATE PROC SLKhachHangTungQuocGia3 @TenQuocGia nvarchar(15), @SLKhachHang int out AS
BEGIN
	IF(@TenQuocGia IS NULL)
		SELECT @SLKhachHang = COUNT(CustomerID) FROM Customers
	ELSE
		SELECT @SLKhachHang = COUNT(CustomerID) FROM Customers WHERE Country = @TenQuocGia
END

DECLARE @tenQuocGia nvarchar(15) = 'USA', @SLKhachHang int
EXEC SLKhachHangTungQuocGia3 @tenQuocGia, @SLKhachHang out
PRINT N'Số lượng khách hàng thuộc quốc gia ' + @tenQuocGia + N' là: ' + CAST(@SLKhachHang AS nvarchar)

DECLARE @tenQuocGia nvarchar(15), @SLKhachHang int
EXEC SLKhachHangTungQuocGia3 @tenQuocGia, @SLKhachHang out
PRINT N'Số lượng khách hàng' +  N' là: ' + CAST(@SLKhachHang AS nvarchar)

/*
	Tạo Stored procedure tên SLKhachHangTungQuocGia4 có một tham số vào là tên quốc gia của khách hàng, 
	một tham số ra (integer) là số lượng khách hàng thuộc quốc gia đó. 
	Nếu không nhập tham số vào (tên quốc gia), sẽ in ra số lượng tất cả khách hang của quốc gia “France”
*/

CREATE PROC SLKhachHangTungQuocGia4 @TenQuocGia nvarchar(15), @SLKhachHang int out AS
BEGIN
	IF(@TenQuocGia IS NULL)
		SELECT @SLKhachHang = COUNT(CustomerID) FROM Customers WHERE Country = 'France'
	ELSE
		SELECT @SLKhachHang = COUNT(CustomerID) FROM Customers WHERE Country = @TenQuocGia
END

DECLARE @tenQuocGia nvarchar(15) = 'USA', @SLKhachHang int
EXEC SLKhachHangTungQuocGia4 @tenQuocGia, @SLKhachHang out
PRINT N'Số lượng khách hàng thuộc quốc gia ' + @tenQuocGia + N' là: ' + CAST(@SLKhachHang AS nvarchar)

DECLARE @tenQuocGia nvarchar(15), @SLKhachHang int
EXEC SLKhachHangTungQuocGia4 @tenQuocGia, @SLKhachHang out
PRINT N'Số lượng khách hàng' +  N' là: ' + CAST(@SLKhachHang AS nvarchar)

/*
	Tạo Stored procedure tên DSDonHangTungNhanVien có một tham số vào là mã của nhân viên bán hàng (EmployeeID), 
	kết quả là danh sách các đơn hàng do nhân viên đó bán, danh sách gồm các cột OrderID, 
	OrderDate, EmployeeID , TongTienDonHang. Trong đó cột  
	TongTienDonHang tính bằng SUM(UnitPrice*Quantity*(1-Discount)).
*/

CREATE PROC DSDonHangTungNhanVien @EmployeeID int AS
BEGIN
	SELECT Orders.OrderID, OrderDate, Employees.EmployeeID, SUM(UnitPrice*Quantity*(1-Discount)) AS TongTienDonHang
	FROM Employees, Orders, [Order Details]
	WHERE Employees.EmployeeID = Orders.EmployeeID
	AND Orders.OrderID = [Order Details].OrderID
	AND Employees.EmployeeID = @EmployeeID
	GROUP BY Orders.OrderID, OrderDate, Employees.EmployeeID
END

DECLARE @EmployeeID int = 1
EXEC DSDonHangTungNhanVien @EmployeeID

/*
	Tạo Stored procedure tên DSDonHangTungNhanVien2 có một tham số vào là mã của nhân viên bán hàng (EmployeeID), 
	kết quả là danh sách các đơn hàng do nhân viên đó bán, danh sách gồm các cột OrderID, 
	OrderDate, EmployeeID , TongTienDonHang. Trong đó cột  
	TongTienDonHang tính bằng SUM(UnitPrice*Quantity*(1-Discount)) 
	trên bảng [Order Details]. Nếu không truyền tham số mã nhân viên vào, 
	kết quả là danh sách tất cả các đơn hàng
*/

CREATE PROC DSDonHangTungNhanVien2 @EmployeeID int AS
BEGIN
	IF(@EmployeeID IS NOT NULL)
	BEGIN
		SELECT Orders.OrderID, OrderDate, Employees.EmployeeID, SUM(UnitPrice*Quantity*(1-Discount)) AS TongTienDonHang
		FROM Employees, Orders, [Order Details]
		WHERE Employees.EmployeeID = Orders.EmployeeID
		AND Orders.OrderID = [Order Details].OrderID
		AND Employees.EmployeeID = @EmployeeID
		GROUP BY Orders.OrderID, OrderDate, Employees.EmployeeID
	END
	ELSE
	BEGIN
		SELECT Orders.OrderID, OrderDate, Employees.EmployeeID, SUM(UnitPrice*Quantity*(1-Discount)) AS TongTienDonHang
		FROM Employees, Orders, [Order Details]
		WHERE Employees.EmployeeID = Orders.EmployeeID
		AND Orders.OrderID = [Order Details].OrderID
		GROUP BY Orders.OrderID, OrderDate, Employees.EmployeeID
	END
END

DECLARE @EmployeeID int = 2
EXEC DSDonHangTungNhanVien2 @EmployeeID

DECLARE @EmployeeID int 
EXEC DSDonHangTungNhanVien2 @EmployeeID

/*
	Tạo Stored procedure tên GiaiPhuongTrinhBacNhat có hai tham số vào là hai hệ số A và B (số thực float), 
	một tham số ra là chuỗi (nvarchar(100)) miêu tả kết quả  sau khi giải phương trình bậc nhất Ax+B=0.
*/

CREATE PROC GiaiPhuongTrinhBacNhat @a float, @b float, @kq nvarchar(100) out AS
BEGIN
	SET @kq = N'Kết quả giải phương trình bậc nhất là: ' + CAST((-@b / @a) AS nvarchar)
END

DECLARE @a float = 2, @b float = 4, @kq nvarchar(100)
EXEC GiaiPhuongTrinhBacNhat @a, @b, @kq out
PRINT @kq