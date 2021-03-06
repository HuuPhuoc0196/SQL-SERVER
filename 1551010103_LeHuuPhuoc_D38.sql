--Số máy tính: D38
--Mã số sinh viên: 1551010103
--Họ tên sinh viên: Lê Hữu Phước
		
--Chú ý: cuối giờ nộp đúng 1 file .sql này (SoMay_MSSV_HoTenKhongDau.sql) vào ổ Z:\
--SV nộp không được thì nhờ GV hỗ trợ nộp, nếu GV không có bài để chấm thì SV nhận 0 diểm, không được khiếu nại

USE QLNhanVien
GO
--Câu 1: 2 điểm

--		Tạo Stored procedure phân mảnh bảng PhongBan:
CREATE PROC createPhongBan
AS
SELECT * INTO PB1 FROM PhongBan
WHERE ChiNhanh = N'Sài gòn' 

SELECT * INTO PB2 FROM PhongBan
WHERE ChiNhanh = N'Hà nội' 
GO

--		Exec Stored procedure phân mảnh bảng PhongBan:

exec createPhongBan


--		Tạo Stored procedure phân mảnh bảng NhanVien:

CREATE PROC createNhanVien
AS
SELECT * INTO NV1 FROM NhanVien
WHERE MaPB in (
	SELECT MaPB FROM dbo.PB1
)

SELECT * INTO NV2 FROM NhanVien
WHERE MaPB in (
	SELECT MaPB FROM dbo.PB2
)
GO

--		Exec Stored procedure phân mảnh bảng NhanVien:

exec createNhanVien

--Sinh viên hãy tạo 2 Stored procedure cho mỗi câu sau đây ở mức 1 mức 2:

--Câu 2: 2 điểm

--		Tạo Stored procedure DSNhanVienMuc1:
CREATE PROC DSNhanVienMuc1(@tenPB nvarchar(50))
AS
	if(@tenPB = '' OR @tenPB IS NULL)
	BEGIN
		PRINT N'Không nhập tên phòng ban!'
		RETURN
	END
	IF NOT EXISTS(SELECT MaPB FROM PhongBan WHERE TenPB = @tenPB)
	BEGIN
		PRINT N'Không tìm thấy tên phòng ban!'
		RETURN
	END
	SELECT NV.MaNV, Ho, Ten, PB.MaPB, TenPB, ChiNhanh FROM NhanVien AS NV, PhongBan AS PB
	where NV.MaPB = PB.MaPB
	AND TenPB = @tenPB
GO

--		Exec Stored procedure DSNhanVienMuc1:

exec DSNhanVienMuc1 N'Kế toán'


--		Tạo Stored procedure DSNhanVienMuc2:

CREATE PROC DSNhanVienMuc2(@tenPB nvarchar(50))
AS
	DECLARE @temp int = 1;
	if(@tenPB = '' OR @tenPB IS NULL)
	BEGIN
		PRINT N'Không nhập tên phòng ban!'
		RETURN
	END
	IF EXISTS(SELECT MaPB FROM PB1 WHERE TenPB = @tenPB)
	BEGIN
		SET @temp = 0;
	END
	ELSE IF EXISTS(SELECT MaPB FROM PB2 WHERE TenPB = @tenPB)
	BEGIN
		SET @temp = 0;
	END
	IF(@temp = 0)
	BEGIN
		SELECT NV.MaNV, Ho, Ten, PB.MaPB, TenPB, ChiNhanh FROM NV1 AS NV, PB1 AS PB
		where NV.MaPB = PB.MaPB
		AND TenPB = @tenPB
		UNION
		SELECT NV.MaNV, Ho, Ten, PB.MaPB, TenPB, ChiNhanh FROM NV2 AS NV, PB2 AS PB
		where NV.MaPB = PB.MaPB
		AND TenPB = @tenPB
	END
	ELSE
		PRINT N'Không tìm thấy tên phòng ban!'
GO

--		Exec Stored procedure DSNhanVienMuc2:

exec DSNhanVienMuc2 N'Kế toán'

--Câu 3: 3 điểm


--		Tạo Stored procedure ThemPhongBanMuc1:

CREATE PROC ThemPhongBanMuc1 (
	@MaPB nvarchar(10),
	@TenPB nvarchar(50),
	@ChiNhanh nvarchar(50)
)
AS
	IF(@MaPB = '' OR @MaPB IS NULL)
	BEGIN
		PRINT N'Không thêm dữ liệu được vì không có giá trị mã PB!'
		RETURN
	END
	ELSE IF EXISTS(SELECT MaPB FROM PhongBan WHERE MaPB = @MaPB)
	BEGIN
		PRINT N'Không thêm dữ liệu được vì trùng mã phòng ban!'
		RETURN
	END
	ELSE IF(@ChiNhanh != N'Sài gòn' AND @ChiNhanh != N'Hà nội')
	BEGIN 
		PRINT N'Không thêm được PB vì chi nhánh không hợp lệ!'
		RETURN
	END
	ELSE
	BEGIN
		INSERT INTO PhongBan VALUES(@MaPB, @TenPB, @ChiNhanh)
		PRINT N'Thêm dữ liệu thành công!'
	END
GO

--		Exec Stored procedure ThemPhongBanMuc1:

exec ThemPhongBanMuc1 NULL,N'Bảo hành',N'Sài gòn'
exec ThemPhongBanMuc1 N'PB07', N'Bảo hành',N'Sài gòn'
exec ThemPhongBanMuc1 N'PB08',N'Tư vấn',N'Hà nội'
exec ThemPhongBanMuc1 N'PB01',N'Kho vận',N'Hà nội'
exec ThemPhongBanMuc1 N'PB09',N'Nghiên cứu',N'Cần thơ'

--		Tạo Stored procedure ThemPhongBanMuc2:

CREATE PROC ThemPhongBanMuc2 (
	@MaPB nvarchar(10),
	@TenPB nvarchar(50),
	@ChiNhanh nvarchar(50)
)
AS
	IF(@MaPB = '' OR @MaPB IS NULL)
	BEGIN
		PRINT N'Không thêm dữ liệu được vì không có giá trị mã PB!'
		RETURN
	END
	ELSE IF EXISTS(SELECT MaPB FROM PB1 WHERE MaPB = @MaPB)
	BEGIN
		PRINT N'Không thêm dữ liệu được vì trùng mã phòng ban!'
		RETURN
	END
	ELSE IF EXISTS(SELECT MaPB FROM PB2 WHERE MaPB = @MaPB)
	BEGIN
		PRINT N'Không thêm dữ liệu được vì trùng mã phòng ban!'
		RETURN
	END
	ELSE IF(@ChiNhanh = N'Sài gòn')
	BEGIN 
		INSERT INTO PB1 VALUES(@MaPB, @TenPB, @ChiNhanh)
		PRINT N'Thêm dữ liệu thành công!'
		RETURN
	END
	ELSE IF(@ChiNhanh = N'Hà nội')
	BEGIN
		INSERT INTO PB2 VALUES(@MaPB, @TenPB, @ChiNhanh)
		PRINT N'Thêm dữ liệu thành công!'
	END
GO


--		Exec Stored procedure ThemPhongBanMuc2:

exec ThemPhongBanMuc2 NULL,N'Bảo hành',N'Sài gòn'
exec ThemPhongBanMuc2 N'PB07', N'Bảo hành',N'Sài gòn'
exec ThemPhongBanMuc2 N'PB08',N'Tư vấn',N'Hà nội'
exec ThemPhongBanMuc2 N'PB01',N'Kho vận',N'Hà nội'
exec ThemPhongBanMuc2 N'PB09',N'Nghiên cứu',N'Cần thơ'


--Câu 4: 3 điểm


--		Tạo Stored procedure SuaPhongBanMuc1:
ALTER PROC SuaPhongBanMuc1 (
	@MaPB nvarchar(10),
	@TenPB nvarchar(50),
	@ChiNhanh nvarchar(50)
)
AS
	IF(@MaPB = '' OR @MaPB IS NULL)
	BEGIN
		PRINT N'Không sửa dữ liệu được vì không có giá trị mã phòng ban!'
		RETURN
	END
	ELSE IF(@ChiNhanh = '' OR @ChiNhanh IS NULL)
	BEGIN
		PRINT N'Không sửa dữ liệu được vì không có giá trị chi nhánh!'
		RETURN
	END
	ELSE IF(@ChiNhanh != N'Sài gòn' AND @ChiNhanh != N'Hà nội')
	BEGIN 
		PRINT N'Không sửa dữ liệu được vì giá trị chi nhánh không hợp lệ!'
		RETURN
	END
	ELSE IF NOT EXISTS(SELECT MaPB FROM PhongBan WHERE MaPB = @MaPB)
	BEGIN 
		PRINT N'Không sửa dữ liệu được vì không tìm thấy có giá trị mã phòng ban!'
		RETURN
	END
	ELSE
	BEGIN 
		UPDATE PhongBan SET TenPB = @TenPB, ChiNhanh = @ChiNhanh WHERE MaPB = @MaPB
		PRINT N'Sửa thành công Phòng Ban có mã PB là: ' + @MaPB
	END
GO

--		Exec Stored procedure SuaPhongBanMuc1:

exec SuaPhongBanMuc1 NULL, N'Thiết kế',N'Sài gòn'
exec SuaPhongBanMuc1 N'PB01', N'Nghiên cứu', NULL
exec SuaPhongBanMuc1 N'PB01', N'Nghiên cứu', N'Cần thơ'
exec SuaPhongBanMuc1 N'PB01',N'Nghiên cứu', N'Sài gòn'
exec SuaPhongBanMuc1 N'PB02',N'Phát triển',N'Hà nội'
exec SuaPhongBanMuc1 N'PB06',N'Tài chánh',N'Sài gòn'
exec SuaPhongBanMuc1 N'PB09',N'Kỹ thuật',N'Sài gòn'
--		Tạo Stored procedure SuaPhongBanMuc2:
CREATE PROC SuaPhongBanMuc2 (
	@MaPB nvarchar(10),
	@TenPB nvarchar(50),
	@ChiNhanh nvarchar(50)
)
AS
	IF(@MaPB = '' OR @MaPB IS NULL)
	BEGIN
		PRINT N'Không sửa dữ liệu được vì không có giá trị mã phòng ban!'
		RETURN
	END
	ELSE IF(@ChiNhanh = '' OR @ChiNhanh IS NULL)
	BEGIN
		PRINT N'Không sửa dữ liệu được vì không có giá trị chi nhánh!'
		RETURN
	END
	ELSE IF(@ChiNhanh != N'Sài gòn' AND @ChiNhanh != N'Hà nội')
	BEGIN 
		PRINT N'Không sửa dữ liệu được vì giá trị chi nhánh không hợp lệ!'
		RETURN
	END
	ELSE IF EXISTS(SELECT MaPB FROM PB1 WHERE MaPB = @MaPB)
	BEGIN 
		UPDATE PB1 SET TenPB = @TenPB, ChiNhanh = @ChiNhanh WHERE MaPB = @MaPB
		PRINT N'Sửa thành công Phòng Ban có mã PB là: ' + @MaPB
		RETURN
	END
	ELSE IF EXISTS(SELECT MaPB FROM PB2 WHERE MaPB = @MaPB)
	BEGIN 
		UPDATE PB2 SET TenPB = @TenPB, ChiNhanh = @ChiNhanh WHERE MaPB = @MaPB
		PRINT N'Sửa thành công Phòng Ban có mã PB là: ' + @MaPB
		RETURN
	END
	ELSE 
	BEGIN 
		UPDATE PB2 SET TenPB = @TenPB, ChiNhanh = @ChiNhanh WHERE MaPB = @MaPB
		PRINT N'Không sửa dữ liệu được vì không tìm thấy có giá trị mã phòng ban!'
	END
GO

--		Exec Stored procedure SuaPhongBanMuc2:

exec SuaPhongBanMuc2 NULL, N'Thiết kế',N'Sài gòn'
exec SuaPhongBanMuc2 N'PB01', N'Nghiên cứu', NULL
exec SuaPhongBanMuc2 N'PB01', N'Nghiên cứu', N'Cần thơ'
exec SuaPhongBanMuc2 N'PB01',N'Nghiên cứu', N'Sài gòn'
exec SuaPhongBanMuc2 N'PB02',N'Phát triển',N'Hà nội'
exec SuaPhongBanMuc2 N'PB06',N'Tài chánh',N'Sài gòn'
exec SuaPhongBanMuc2 N'PB09',N'Kỹ thuật',N'Sài gòn'



--Cuối bài: nộp file .sql này (SoMay_MSSV_HoTenKhongDau.sql) vào ổ Z:\
-- HẾT ---------------------------------------------------------------------------------------------------
