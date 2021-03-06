USE Northwind
GO

------Loại hàm trả về một giá trị đơn trị (Scalar-valued function):--------------------
/*
	Viết 1 hàm loại trả về 1 giá trị đơn trị (Scalar-valued function) tên ChaoBan, 
	nhận đầu vào 1 chuỗi nvarchar(50) là tên của 1 người, đầu ra là chuỗi nvarchar(100) 
	chính là lời chào đến tên người đã nhập ở đầu vào của hàm.
*/

CREATE FUNCTION ChaoBan ( 
	@ten nvarchar(100)
) 
RETURNS nvarchar(100)
AS
BEGIN
	RETURN N'Chào bạn ' + @ten
END

PRINT dbo.ChaoBan(N'Lê Hữu Phước')
GO

SELECT dbo.ChaoBan(N'Lê Hữu Phước') AS N'Lời Chào'
GO

/*
	Viết 1 Scalar-valued function tên TenNhanVienDayDu, nhận đầu vào 1 mã nhân viên, 
	đầu ra là  tên đầy đủ của nhân viên đó. Gợi ý: dùng bảng Employees của CSDL Northwind. 
	Ví dụ đầu vào là mã nhân viên là 2, thì hàm trả về  “Andrew Fuller”.
*/

CREATE FUNCTION TenNhanVienDayDu (
	@EmployeeID int
)
RETURNS nvarchar(100)
AS
BEGIN
	DECLARE @LastName nvarchar(20), @FirstName nvarchar(10)
	SELECT @LastName = LastName, @FirstName = FirstName FROM Employees WHERE EmployeeID = @EmployeeID
	RETURN @FirstName + ' ' + @LastName
END

PRINT dbo.TenNhanVienDayDu(2)

/*
	*Viết 1 Scalar-valued function tên SLKhachHangCuaQuocGia, nhận đầu vào 1 tên quốc gia, 
	đầu ra là số lượng khách hàng của quốc gia đó. Gợi ý: dùng bảng Customers của CSDL Northwind. 
	Ví dụ đầu vào là USA hàm thì trả về 13.
*/

CREATE FUNCTION SLKhachHangCuaQuocGia ( @Country nvarchar(15) )
RETURNS int
AS
BEGIN
	DECLARE @count int
	SELECT @count = COUNT(CustomerID)FROM Customers WHERE country = @Country
	RETURN @count
END 

PRINT dbo.SLKhachHangCuaQuocGia('USA')

/*
	Viết 1 Scalar-valued function tên SLDonHangCuaKhachHang1, 
	nhận đầu vào 1 tên công ty khách hàng (CompanyName), 
	đầu ra là số lượng đơn hàng của khách hàng đó mua. 
	Ví dụ đầu vào là tên công ty khách hàng “Ernst Handel” thì hàm thì trả về 30 đơn hàng.
*/

CREATE FUNCTION SLDonHangCuaKhachHang1 (@CompanyName nvarchar(40))
RETURNS int
AS
BEGIN
	DECLARE @count int
	SELECT @count = COUNT(OrderID)
	FROM Customers, Orders
	WHERE Customers.CustomerID = Orders.CustomerID
		AND CompanyName = @CompanyName
	RETURN @count
END

PRINT dbo.SLDonHangCuaKhachHang1('Ernst Handel')

/*
	Viết 1 Scalar-valued function tên SLDonHangCuaKhachHang2, 
	nhận 2 đầu vào là quốc gia và thành phố của khách hàng, 
	đầu ra là số lượng đơn hàng của các khách hàng đó mua
*/

CREATE FUNCTION SLDonHangCuaKhachHang2( @Country nvarchar(15), @City nvarchar(15))
RETURNS int 
AS
BEGIN
	DECLARE @count int
	SELECT @count = COUNT(OrderID)
	FROM Customers, Orders
	WHERE Customers.CustomerID = Orders.CustomerID
	AND Country = @Country
	AND City = @City
	RETURN @count
END

PRINT dbo.SLDonHangCuaKhachHang2('UK','London')

/*
	Viết 1 Scalar-valued function tên SLDonHangCuaKhachHang3,
	nhận đầu vào là quốc gia của khách hàng, đầu ra là số lượng đơn hàng của các khách hàng đó mua. 
	Nếu không nhập tên quốc gia ở đầu vào hàm sẽ tính ra đầu ra là số lượng đơn hàng của tất cả khách hàng đã mua.
*/

CREATE FUNCTION SLDonHangCuaKhachHang3( @Country nvarchar(15))
RETURNS int 
AS
BEGIN
	DECLARE @count int
	IF(@Country IS NOT NULL)
	BEGIN
		SELECT @count = COUNT(OrderID)
		FROM Customers, Orders
		WHERE Customers.CustomerID = Orders.CustomerID
		AND Country = @Country
	END
	ELSE
	BEGIN
		SELECT @count = COUNT(OrderID)
		FROM Customers, Orders
		WHERE Customers.CustomerID = Orders.CustomerID
	END
	RETURN @count
END

PRINT dbo.SLDonHangCuaKhachHang3('UK')
GO
PRINT dbo.SLDonHangCuaKhachHang3(NULL)
GO

/*
	Viết 1 Scalar-valued function tên TongTienMuahangCuaKhachHang, 
	nhận đầu vào 1 mã khách hàng, đầu ra là tổng tiền mua hàng của khách hàng đó (đã trừ tiền giảm giá).
*/

CREATE FUNCTION TongTienMuahangCuaKhachHang( @CustomerID nchar(5))
RETURNS float
AS
BEGIN
	DECLARE @sum float
	SELECT @sum = SUM(UnitPrice * Quantity * (1 - Discount))
	FROM Orders, [Order Details]
	WHERE Orders.OrderID = [Order Details].OrderID
	AND CustomerID = @CustomerID
	RETURN @sum
END

PRINT dbo.TongTienMuahangCuaKhachHang('ANTON')
GO

---Loại hàm trả về một bảng dữ liệu (Table-valued function):----------------

/*
	Viết 1 Table-valued function tên DSDonHangCuaKhachHang, 
	nhận đầu vào 1 mã khách hàng, đầu ra là  một bảng danh sách các đơn hàng của khách hàng đó đã mua, 
	danh sách gồm tất cả các cột của bảng Orders.
*/

CREATE FUNCTION DSDonHangCuaKhachHang ( @CustomerID nchar(5))
RETURNS TABLE
AS RETURN
(
	SELECT * FROM Orders WHERE CustomerID = @CustomerID
)

SELECT * FROM dbo.DSDonHangCuaKhachHang('ANTON')

/*
	Viết 1 Table-valued function tên DSDonHangCuaQuocGiaKhachHang1, 
	nhận đầu vào 1 tên quốc gia của khách hàng, 
	đầu ra là  một bảng danh sách các đơn hàng của các khách hàng thuộc quốc gia đó đã mua, 
	danh sách gồm tất cả các cột của bảng Orders.
*/

CREATE FUNCTION DSDonHangCuaQuocGiaKhachHang1 ( @Country nvarchar(15))
RETURNS TABLE 
AS RETURN
(
	SELECT Orders.*
	FROM Customers, Orders
	WHERE Customers.CustomerID = Orders.CustomerID
	AND Country = @Country
)

SELECT * FROM dbo.DSDonHangCuaQuocGiaKhachHang1('UK')

/*
	Viết 1 Table-valued function tên DSDonHangCuaQuocGiaKhachHang2, 
	nhận đầu vào 1 tên quốc gia của khách hàng, 
	đầu ra là  một bảng danh sách chứa mỗi hàng là một đơn hàng của các khách hàng thuộc quốc gia đó đã mua, 
	danh sách gồm 3 cột: OrderID, OrderDate (dạng dd/MM/yyyy) và TongTienDonHangPhaiTra.
*/


CREATE FUNCTION DSDonHangCuaQuocGiaKhachHang2 ( @Country nvarchar(15))
RETURNS TABLE 
AS RETURN
(
	SELECT OrderID, CONVERT(nvarchar, OrderDate, 103) ,SUM(UnitPrice * Quantity * (1 - Discount)) AS TongTienDonHangPhaiTra
	FROM Customers, Orders, [Order Details]
	WHERE Orders.OrderID = [Order Details].OrderID
	AND Country= @Country
)