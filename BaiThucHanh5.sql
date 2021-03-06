/*
2.	Tạo View để thống kê số lượng khách hàng của từng quốc gia của khách hàng đã mua ở 2 mức trong suốt, 
	view gồm có 2 cột: Quốc gia và Số lượng khách hàng, đặt tên view như sau:
- ViewThongKeSLKHTheoQGMuc1 trên Northwind
- ViewThongKeSLKHTheoQGMuc2 trên Northwind1

*/
USE Northwind
GO
CREATE VIEW ViewThongKeSLKHTheoQGMuc1 AS
	SELECT Country, COUNT(CustomerID) AS SoLuong
	FROM Customers
	GROUP BY Country
GO

USE Northwind1
GO
CREATE VIEW ViewThongKeSLKHTheoQGMuc2 AS
	SELECT Country, COUNT(KH1.CustomerID) AS SoLuong
	FROM KH1
	GROUP BY Country
	UNION 
	SELECT Country, COUNT(KH2.CustomerID) AS SoLuong
	FROM KH2
	GROUP BY Country
GO
/*
3.	Tạo View để thống kê số lượng đơn hàng của từng quốc gia của khách hàng đã mua ở 2 mức trong suốt, 
	view gồm có 2 cột: Quốc gia và Số lượng đơn hàng, đặt tên view như sau:
- ViewThongKeSLDHTheoQGMuc1 trên Northwind
- ViewThongKeSLDHTheoQGMuc2 trên Northwind1 
*/
USE Northwind
GO
CREATE VIEW ViewThongKeSLDHTheoQGMuc1 AS
	SELECT Country, COUNT(OrderID) AS SoLuong
	FROM Orders, Customers
	WHERE Orders.CustomerID = Customers.CustomerID
	GROUP BY Country
	ORDER BY Country DESC
GO

USE Northwind1
GO
CREATE VIEW ViewThongKeSLDHTheoQGMuc2 AS
	SELECT Country, COUNT(DH1.OrderID) AS SoLuong
	FROM KH1,DH1
	WHERE DH1.CustomerID = KH1.CustomerID
	GROUP BY Country
	UNION
	SELECT Country, COUNT(DH2.OrderID) AS SoLuong
	FROM KH2, DH2
	WHERE DH2.CustomerID = KH2.CustomerID
	GROUP BY Country
GO


/*
4.	Tạo Procedure để in danh sách khách hàng chưa mua đơn hàng nào. 
	Procedure này  không có tham số, đặt tên Proc này ở 2 mức là:
- ProcKHChuaMuaHangMuc1 trên trên Northwind
- ProcKHChuaMuaHangMuc2 trên trên Northwind1
Chạy 2 Proc này ở 2 CSDL để thêm xem kết quả có giống nhau không.

*/

USE Northwind
GO
CREATE PROC ProcKHChuaMuaHangMuc1
AS
	SELECT * FROM Customers
	WHERE CustomerID NOT IN(
		SELECT Customers.CustomerID 
		FROM Customers, Orders
		WHERE Customers.CustomerID = Orders.CustomerID)
GO
EXEC ProcKHChuaMuaHangMuc1
GO

USE Northwind1
GO
CREATE PROC ProcKHChuaMuaHangMuc2
AS
	SELECT * FROM KH1
	WHERE CustomerID NOT IN(
		SELECT KH1.CustomerID 
		FROM KH1, DH1
		WHERE KH1.CustomerID = DH1.CustomerID)
	UNION
	SELECT * FROM KH2
	WHERE CustomerID NOT IN(
		SELECT KH2.CustomerID 
		FROM KH2, DH2
		WHERE KH2.CustomerID = DH2.CustomerID )
GO
EXEC ProcKHChuaMuaHangMuc2
GO

/*
5.	Tạo Procedure để thêm dữ liệu khách hàng. Procedure này có 4 tham số vào là: 
	- Mã khách hàng (MaKH hay CustomerID)
	- Tên công ty (TenCongTy hay CompanyName)
	- Thành phố (ThanhPho hay City)
	- Quốc gia (QuocGia hay Country)
Đặt tên Proc này ở 2 mức là:
	- ProcThemKHMuc1 trên trên Northwind
	- ProcThemKHMuc2 trên trên Northwind1
Chạy 2 Proc này ở 2 CSDL để thêm 2 hàng dữ liệu sau:
	Khách hàng 1
	- CustomerID: KH001
	- CompanyName: Công ty 001
	- City: HCMC
	- Country: Vietnam
	Khách hàng 2
	- CustomerID: KH002
	- CompanyName: Công ty 002
	- City: London
	- Country: UK
	Kiểm tra dữ liệu (Select) ở các bảng, phân mảnh đã thêm xem có chính xác không. 

*/

USE Northwind
GO
CREATE PROC ProcThemKHMuc1(@CustomerID nchar(5), @CompanyName nvarchar(40), @City nvarchar(15), @Country nvarchar(15))
AS
	IF(@CustomerID IS NULL OR @CustomerID = '')
		BEGIN
			PRINT N'Mã Khách hàng không được trống Error'
			RETURN 
		END
	IF EXISTS (SELECT CustomerID FROM Customers WHERE CustomerID = @CustomerID)
		BEGIN
			PRINT N'Mã Khách hàng đã tồn tại'
			RETURN 
		END
	INSERT INTO Customers(CustomerID, CompanyName, City, Country)
	VALUES(@CustomerID, @CompanyName, @City, @Country)
	PRINT N'Đã thêm thành công một khách hàng'
GO

EXEC ProcThemKHMuc1 'KH001', N'Công ty 001', 'HCMC', 'Vietnam'
GO
EXEC ProcThemKHMuc1 'KH002', N'Công ty 002', 'London', 'UK'
GO

USE Northwind1
GO
ALTER PROC ProcThemKHMuc2(@CustomerID nchar(5), @CompanyName nvarchar(40), @City nvarchar(15), @Country nvarchar(15))
AS  -- cách náy k hay
	IF(@CustomerID IS NULL OR @CustomerID = '')
		BEGIN
			PRINT N'Mã Khách hàng không được trống Error'
			RETURN
		END
	IF((@Country = N'USA') OR (@Country = N'UK'))
		BEGIN
			IF(@CustomerID IN (SELECT CustomerID FROM KH2))
				BEGIN
					PRINT N'Mã khách hàng đã tồn tại' 
					RETURN
				END
			IF(@CustomerID IN (SELECT CustomerID FROM KH1))
				BEGIN
					PRINT N'Mã khách hàng đã tồn tại' 
					RETURN
				END
			INSERT INTO KH1(CustomerID, CompanyName, City, Country)
			VALUES(@CustomerID, @CompanyName, @City, @Country)
			PRINT N'Đã thêm thành công một khách hàng vào KH1'
		END
	ELSE
		BEGIN
			IF(@CustomerID IN (SELECT CustomerID FROM KH1))
				BEGIN
					PRINT N'Mã khách hàng đã tồn tại' 
					RETURN
				END
			IF(@CustomerID IN (SELECT CustomerID FROM KH2))
				BEGIN
					PRINT N'Mã khách hàng đã tồn tại' 
					RETURN
				END
			INSERT INTO KH2(CustomerID, CompanyName, City, Country)
			VALUES(@CustomerID, @CompanyName, @City, @Country)
			PRINT N'Đã thêm thành công một khách hàng vào KH2'
		END
GO

EXEC ProcThemKHMuc2 'KH001', N'Công ty 001', 'HCMC', 'Vietnam'
GO
EXEC ProcThemKHMuc2 'KH002', N'Công ty 002', 'London', 'UK'
GO

/*
6. Tạo Procedure để sửa dữ liệu về địa điểm của công ty khách hàng.
Procedure này có 3 tham số vào là:
- Mã khách hàng (MaKH hay CustomerID)
- Thành phố (ThanhPho hay City)
- Quốc gia (QuocGia hay Country)
Đặt tên Proc này ở 2 mức là:
- ProcSuaKHMuc1 trên trên Northwind
- ProcSuaKHMuc2 trên trên Northwind1
Chạy 2 Proc này ở 2 CSDL để sửa City và Country của 2 hàng dữ liệu sau:

Khách hàng 1 Khách hàng 2

- CustomerID: KH001
- CompanyName: Công ty 001
- City: HCMC sửa thành “San Francisco”
- Country: Vietnam sửa thành “USA”

- CustomerID: KH002
- CompanyName: Công ty 002
- City: London sửa thành “Hanoi”
- Country: UK sửa thành “Vietnam”

Kiểm tra dữ liệu (Select) ở các bảng, phân mảnh đã sửa xem có chính xác
không.
*/

USE Northwind
GO
CREATE PROC ProcSuaKHMuc1 (@CustomerID nchar(5), @City nvarchar(15), @Country nvarchar(15))
AS
	IF NOT EXISTS (SELECT CustomerID FROM Customers WHERE CustomerID = @CustomerID)
		BEGIN
			PRINT N'Mã khách hàng không tồn tại'
			RETURN
		END
	UPDATE Customers SET City = @City, Country = @Country
	WHERE CustomerID = @CustomerID
	PRINT N'Đã sữa thành công môt khách hàng'
GO

EXEC ProcSuaKHMuc1 'ALFKI', N'Hanoi', N'Vietnam'
GO

USE Northwind1
GO
CREATE PROC ProcSuaKHMuc2 (@CustomerID nchar(5), @City nvarchar(15), @Country nvarchar(15))
AS
	IF EXISTS (SELECT CustomerID FROM KH1 WHERE CustomerID = @CustomerID)
		BEGIN
			IF(@Country = 'UK' OR @Country = 'USA')
				BEGIN
					UPDATE KH1 SET City = @City, Country = @Country
					WHERE CustomerID = @CustomerID
					PRINT N'Sửa thành công một khách hàng của Phân Mãnh KH1'
				END
			ELSE
				BEGIN
					-- sửa dữ liệu
					UPDATE KH1 SET City = @City, Country = @Country
					WHERE CustomerID = @CustomerID
					-- dời khách hàng
					INSERT INTO KH2 SELECT * FROM KH1 WHERE CustomerID = @CustomerID
					DELETE FROM KH1 WHERE CustomerID = @CustomerID
					-- dời đơn hàng
					INSERT INTO DH2 SELECT * FROM DH1 WHERE CustomerID = @CustomerID
					DELETE FROM DH1 WHERE CustomerID = @CustomerID
					-- báo thành công
					PRINT N'Sửa thành công 1 khách hàng ở Phân mãnh KH1 và chuyển sang lưu ở PM KH2, đồng thời chuyển DH từ DH1 sang DH2'
				END
		END
	ELSE IF EXISTS (SELECT CustomerID FROM KH2 WHERE CustomerID = @CustomerID)
		BEGIN
			IF(@Country <> 'UK' AND @Country <> 'USA')
				BEGIN 
					UPDATE KH2 SET City = @City, Country = @Country
					WHERE CustomerID = @CustomerID
					PRINT N'Đã sửa thành công một khách hàng ở PM KH2'
				END
			ELSE
				BEGIN
					-- sửa dữ liệu
					UPDATE KH2 SET City = @City, Country = @Country
					WHERE CustomerID = @CustomerID
					-- dời khách hàng
					INSERT INTO KH1 SELECT * FROM KH2 WHERE CustomerID = @CustomerID
					DELETE FROM KH2 WHERE CustomerID = @CustomerID
					-- dời đơn hàng
					INSERT INTO DH1 SELECT * FROM DH2 WHERE CustomerID = @CustomerID
					DELETE FROM DH2 WHERE CustomerID = @CustomerID
					-- báo thành công
					PRINT N'Sửa thành công 1 khách hàng ở Phân mãnh KH2 và chuyển sang lưu ở PM KH1, đồng thời chuyển DH từ DH2 sang DH1'
				END
		END
	ELSE
		BEGIN
			PRINT N'Không tìm thấy mã khách hàng cần sửa'
		END
	
GO

EXEC ProcSuaKHMuc2 'ALFKI', N'Hanoi', N'Vietnam'
GO

/*
7. Tạo Procedure để xóa dữ liệu khách hàng. Procedure này có 1 tham số
vào là:
- Mã khách hàng (MaKH hay CustomerID)
Đặt tên Proc này ở 2 mức là:
- ProcXoaKHMuc1 trên trên Northwind
- ProcXoaKHMuc2 trên trên Northwind1
Chạy 2 Proc này ở 2 CSDL để xóa 2 hàng dữ liệu sau:
Khách hàng 1 Khách hàng 2
- CustomerID: KH001 - CustomerID: KH002

Kiểm tra dữ liệu (Select) ở các bảng, phân mảnh đã xóa xem có chính xác
không.
*/

USE Northwind
GO
CREATE PROC ProcXoaKHMuc1(@CustomerID nchar(5))
AS
	IF NOT EXISTS (SELECT CustomerID FROM Customers WHERE CustomerID = @CustomerID)
		BEGIN
			PRINT N'Không tìm thấy mã khách hàng cần xóa!'
			RETURN
		END
	DELETE FROM [Order Details] WHERE [Order Details].OrderID IN (
			SELECT OrderID FROM Orders WHERE Orders.CustomerID = @CustomerID)
	DELETE FROM Orders WHERE Orders.CustomerID = @CustomerID
	DELETE FROM Customers WHERE CustomerID = @CustomerID
	PRINT N'Xóa thành công một khách hàng có mã ' + @CustomerID 
	PRINT N'Đồng thời xóa các CTDH và DH có liên quan'
GO

EXEC ProcXoaKHMuc1 'ALFKI'
GO

USE Northwind1
GO
CREATE PROC ProcXoaKHMuc2(@CustomerID nchar(5))
AS
	IF(@CustomerID IS NULL)
		PRINT N'Mã khách hàng không được phép null!'
	ELSE IF EXISTS(SELECT CustomerID FROM KH1 WHERE CustomerID = @CustomerID)
		BEGIN
			DECLARE @SLDH int
			SELECT @SLDH = COUNT(DH1.OrderID) FROM DH1 WHERE DH1.CustomerID = @CustomerID
			DELETE FROM DH1 WHERE DH1.CustomerID = @CustomerID
			PRINT N'Xóa thành công ' + CAST(@SLDH AS varchar) + N' DH có Mã khách hàng là: ' + @CustomerID + N' trong PM DH1'
			DELETE FROM KH1 WHERE CustomerID = @CustomerID
			PRINT N'Xóa thành công một khách hàng có Mã khách hàng là: ' + @CustomerID + N' trong PM KH1'
		END
	ELSE IF EXISTS(SELECT CustomerID FROM KH2 WHERE CustomerID = @CustomerID)
		BEGIN
			SELECT @SLDH = COUNT(DH2.OrderID) FROM DH2 WHERE DH2.CustomerID = @CustomerID
			DELETE FROM DH2 WHERE DH2.CustomerID = @CustomerID
			PRINT N'Xóa thành công ' + CAST(@SLDH AS varchar) + N' DH có Mã khách hàng là: ' + @CustomerID + N' trong PM DH2'
			DELETE FROM KH2 WHERE CustomerID = @CustomerID
			PRINT N'Xóa thành công một khách hàng có Mã khách hàng là: ' + @CustomerID + N' trong PM KH2'
		END
	ELSE
		PRINT N'Mã khách hàng: ' + @CustomerID + N' không tồn tại!'
GO

EXEC ProcXoaKHMuc2 'ALFKI'
GO

/*
8. Tạo Function để tính số lượng đơn hàng của khách hàng. Function này
có 1 tham số vào là:
- Quốc gia (QuocGia hay Country)
Đặt tên Function này ở 2 mức là:
- FuncSLDHMuc1 trên trên Northwind
- FuncSLDHMuc2 trên trên Northwind1
- xữ lý thêm: nếu @Country truyền váo null thì tính tất cả các đơn hàng
*/

USE Northwind
GO
CREATE FUNCTION FuncSLDHMuc1 ( @Country nvarchar(15))
RETURNS int 
AS
	BEGIN
		DECLARE @SLDH int
		IF(@Country IS NULL)
			BEGIN
				SELECT @SLDH = COUNT(OrderID) FROM Customers, Orders
				WHERE Customers.CustomerID = Orders.CustomerID
			END
		ELSE
			BEGIN
				SELECT @SLDH = COUNT(OrderID) FROM Customers, Orders
				WHERE Customers.CustomerID = Orders.CustomerID
				AND Country = @Country
			END
		RETURN @SLDH
	END
GO

PRINT dbo.FuncSLDHMuc1(N'UK')
GO

USE Northwind1
GO
CREATE FUNCTION FuncSLDHMuc2 ( @Country nvarchar(15))
RETURNS int 
AS
	BEGIN
		DECLARE @SLDH int
		IF(@Country IS NULL)
			BEGIN
				DECLARE @SLDH1 int, @SLDH2 int
				SELECT @SLDH1 = COUNT(OrderID) FROM KH1, DH1
				WHERE KH1.CustomerID = DH1.CustomerID
				SELECT @SLDH2 = COUNT(OrderID) FROM KH2, DH2
				WHERE KH2.CustomerID = DH2.CustomerID
				SET @SLDH = @SLDH1 + @SLDH2
			END
		ELSE IF(@Country = N'UK' OR @Country = N'USA')
			BEGIN
				SELECT @SLDH = COUNT(OrderID) FROM KH1, DH1
				WHERE KH1.CustomerID = DH1.CustomerID
				AND Country = @Country
			END
		ELSE
			BEGIN
				SELECT @SLDH = COUNT(OrderID) FROM KH2, DH2
				WHERE KH2.CustomerID = DH2.CustomerID
				AND Country = @Country
			END
		RETURN @SLDH
	END
GO

PRINT dbo.FuncSLDHMuc2(N'USA')
GO
/*
9. Tạo Function để lấy danh sách đơn hàng của khách hàng. Function này
có 1 tham số vào là:
- Quốc gia (QuocGia hay Country)
Đặt tên Function này ở 2 mức là:
- FuncDSDHMuc1 trên trên Northwind
- FuncDSDHMuc2 trên trên Northwind1
Chạy 2 Function này ở 2 CSDL để biết danh sách đơn hàng của các khách
hàng ở các quốc gia sau:
*/

USE Northwind
GO
CREATE FUNCTION FuncDSDHMuc1 ( @Country nvarchar(15))
RETURNS TABLE
AS
	RETURN
	(
		SELECT Orders.* FROM Orders, Customers
		WHERE Customers.CustomerID = Orders.CustomerID
				AND Country = @Country
	)
GO

SELECT * FROM FuncDSDHMuc1(N'UK')
GO
/* Cách 1
USE Northwind1
GO
CREATE FUNCTION FuncDSDHMuc2 ( @Country nvarchar(15))
RETURNS TABLE
AS
	RETURN
	(
		SELECT DH1.* FROM DH1, KH1
		WHERE KH1.CustomerID = DH1.CustomerID
				AND Country = @Country
		UNION 
		SELECT DH2.* FROM DH2, KH2
		WHERE KH2.CustomerID = DH2.CustomerID
				AND Country = @Country
	)
GO

SELECT * FROM FuncDSDHMuc2(N'Brazil')
GO

*/


USE Northwind1
GO
CREATE FUNCTION FuncDSDHMuc2 ( @Country nvarchar(15))
RETURNS @KQ TABLE
(
	[OrderID] [int] PRIMARY KEY,
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
AS
BEGIN
	IF(@Country IS NULL)
		BEGIN 
			INSERT INTO @KQ
			SELECT DH1.*
			FROM DH1
			INSERT INTO @KQ
			SELECT DH2.*
			FROM DH2
		END
	ELSE IF(@Country = 'UK' OR @Country = 'USA')
		BEGIN
			INSERT INTO @KQ
			SELECT DH1.*
			FROM DH1, KH1
			WHERE KH1.CustomerID = DH1.CustomerID
				AND Country = @Country
		END
	ELSE
		BEGIN
			INSERT INTO @KQ
			SELECT DH2.*
			FROM DH2, KH2
			WHERE KH2.CustomerID = DH2.CustomerID
				AND Country = @Country
		END
	RETURN
END

SELECT * FROM FuncDSDHMuc2(NULL)
GO