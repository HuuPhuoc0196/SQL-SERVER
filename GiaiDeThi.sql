USE QLNhanVien
GO

CREATE PROC TaoPhanManhPB 
AS
	SELECT * INTO PhongBanSG
	FROM PhongBan
	WHERE ChiNhanh = N'Sài gòn'
	
	SELECT * INTO PhongBanHN
	FROM PhongBan
	WHERE ChiNhanh = N'Hà nội'
GO

exec TaoPhanManhPB
GO

SELECT * FROM PhongBanSG
SELECT * FROM PhongBanHN

CREATE PROC TaoPhanManhNV 
AS
	SELECT * INTO NhanVienSG
	FROM NhanVien
	WHERE MaPB in (SELECT MaPB FROM PhongBanSG)
	
	SELECT * INTO NhanVienHN
	FROM NhanVien
	WHERE MaPB in (SELECT MaPB FROM PhongBanHN)
GO

exec TaoPhanManhNV

SELECT * FROM NhanVienSG
SELECT * FROM NhanVienHN


CREATE PROC DSNhanVienMuc1(@TenPB nvarchar(50))
AS
	IF(@TenPB = '' OR @TenPB IS NULL)
		PRINT N'Tên phòng ban rỗng!'
	ELSE IF NOT EXISTS (SELECT * FROM PhongBan WHERE TenPB = @TenPB)
		PRINT N'Không tìm thấy tên phòng ban'
	ELSE
	BEGIN
		SELECT nv.MaNV, Ho, Ten, pb.MaPB, TenPB, ChiNhanh
		FROM NhanVien AS nv, PhongBan AS pb
		WHERE nv.MaPB = pb.MaPB
		AND pb.TenPB = @TenPB
	END
GO

exec DSNhanVienMuc1 ''
exec DSNhanVienMuc1 null
exec DSNhanVienMuc1 N'Thiết kế'
exec DSNhanVienMuc1 'Kế toán'
exec DSNhanVienMuc1 'Kinh tế'


CREATE PROC DSNhanVienMuc2(@TenPB nvarchar(50))
AS
	IF(@TenPB = '' OR @TenPB IS NULL)
		PRINT N'Tên phòng ban rỗng!'
	ELSE IF NOT EXISTS (SELECT * FROM PhongBanSG WHERE TenPB = @TenPB) AND 
			NOT EXISTS (SELECT * FROM PhongBanHN WHERE TenPB = @TenPB)
		PRINT N'Không tìm thấy tên phòng ban'
	ELSE
	BEGIN
		SELECT nv.MaNV, Ho, Ten, pb.MaPB, TenPB, ChiNhanh
		FROM NhanVienSG AS nv, PhongBanSG AS pb
		WHERE nv.MaPB = pb.MaPB
		AND pb.TenPB = @TenPB
		UNION
		SELECT nv.MaNV, Ho, Ten, pb.MaPB, TenPB, ChiNhanh
		FROM NhanVienHN AS nv, PhongBanHN AS pb
		WHERE nv.MaPB = pb.MaPB
		AND pb.TenPB = @TenPB
	END
GO

exec DSNhanVienMuc2 ''
exec DSNhanVienMuc2 null
exec DSNhanVienMuc2 N'Thiết kế'
exec DSNhanVienMuc2 'Kế toán'
exec DSNhanVienMuc2 'Kinh tế'

CREATE PROC ThemPhongBanMuc1(@MaPB nvarchar(10), @TenPB nvarchar(50), @ChiNhanh nvarchar(50))
AS
	IF(@MaPB = '' OR @MaPB IS NULL)
		PRINT N'Mã phòng ban rỗng!'
	ELSE IF(@TenPB = '' OR @TenPB IS NULL)
		PRINT N'tên phòng ban rỗng!'
	ELSE IF(@ChiNhanh = '' OR @ChiNhanh IS NULL)
		PRINT N'Chi nhánh rỗng!'
	ELSE IF (@ChiNhanh <> N'Sài gòn' AND @ChiNhanh <> N'Hà nội')
		PRINT N'Chi nhánh không hợp lệ!'
	ELSE IF EXISTS (SELECT MaPB FROM PhongBan WHERE MaPB = @MaPB)
		PRINT N'Mã phòng ban đã tồn tại!'
	ELSE IF EXISTS (SELECT MaPB FROM PhongBan WHERE TenPB = @TenPB AND ChiNhanh = @ChiNhanh)
		PRINT N'Dữ liệu đã tồn tại'
	ELSE
	BEGIN
		INSERT INTO PhongBan VALUES(@MaPB, @TenPB, @ChiNhanh)
		PRINT N'Thêm thành công'
	END
GO

exec ThemPhongBanMuc1 NULL,N'Bảo hành',N'Sài gòn'
exec ThemPhongBanMuc1 N'PB1000',N'',N''
exec ThemPhongBanMuc1 N'PB07', N'Bảo hành',N'Sài gòn'
exec ThemPhongBanMuc1 N'PB08', N'Bảo hành',N'Sài gòn'
exec ThemPhongBanMuc1 N'PB08',N'Tư vấn',N'Hà nội'
exec ThemPhongBanMuc1 N'PB08',N'Tư vấn',N'Hà nội'
exec ThemPhongBanMuc1 N'PB09',N'',N''
exec ThemPhongBanMuc1 N'PB10',N'Nghiên cứu',N'Cần thơ'


ALTER PROC ThemPhongBanMuc2(@MaPB nvarchar(10), @TenPB nvarchar(50), @ChiNhanh nvarchar(50))
AS
	IF(@MaPB = '' OR @MaPB IS NULL)
		PRINT N'Mã phòng ban rỗng!'
	ELSE IF(@TenPB = '' OR @TenPB IS NULL)
		PRINT N'tên phòng ban rỗng!'
	ELSE IF(@ChiNhanh = '' OR @ChiNhanh IS NULL)
		PRINT N'Chi nhánh rỗng!'
	ELSE IF EXISTS (SELECT MaPB FROM PhongBanSG WHERE TenPB = @TenPB AND ChiNhanh = @ChiNhanh) OR
			EXISTS (SELECT MaPB FROM PhongBanHN WHERE TenPB = @TenPB AND ChiNhanh = @ChiNhanh)
		PRINT N'Dữ liệu đã tồn tại'
	ELSE IF EXISTS (SELECT MaPB FROM PhongBanSG WHERE MaPB = @MaPB) OR
			EXISTS (SELECT MaPB FROM PhongBanHN WHERE MaPB = @MaPB)
		PRINT N'Mã phòng ban đã tồn tại!'
	ELSE IF(@ChiNhanh = N'Sài gòn')
	BEGIN
		INSERT INTO PhongBanSG VALUES( @MaPB, @TenPB, @ChiNhanh)
		PRINT N'Thêm thành công'
	END
	ELSE IF(@ChiNhanh = N'Hà nội')
	BEGIN
		INSERT INTO PhongBanHN VALUES( @MaPB, @TenPB, @ChiNhanh)
		PRINT N'Thêm thành công'
	END
	ELSE
		PRINT N'Chi nhánh không hợp lệ!'
GO

exec ThemPhongBanMuc2 NULL,N'Bảo hành',N'Sài gòn'
exec ThemPhongBanMuc2 N'PB1000',N'',N''
exec ThemPhongBanMuc2 N'PB07', N'Bảo hành',N'Sài gòn'
SELECT * FROM PhongBanSG
exec ThemPhongBanMuc2 N'PB08', N'Bảo hành',N'Sài gòn'
exec ThemPhongBanMuc2 N'PB08',N'Tư vấn',N'Hà nội'
SELECT * FROM PhongBanHN
exec ThemPhongBanMuc2 N'PB08',N'Tư vấn',N'Hà nội'
exec ThemPhongBanMuc2 N'PB08',N'Kế hoạch',N'Hà nội'
exec ThemPhongBanMuc2 N'PB09',N'',N''
exec ThemPhongBanMuc2 N'PB10',N'Nghiên cứu',N'Cần thơ'


ALTER PROC SuaPhongBanMuc1(@MaPB nvarchar(10), @TenPB nvarchar(50), @ChiNhanh nvarchar(50))
AS
	IF(@MaPB = '' OR @MaPB IS NULL)
		PRINT N'Mã phòng ban rỗng!'
	ELSE IF(@TenPB = '' OR @TenPB IS NULL)
		PRINT N'tên phòng ban rỗng!'
	ELSE IF(@ChiNhanh = '' OR @ChiNhanh IS NULL)
		PRINT N'Chi nhánh rỗng!'
	ELSE IF (@ChiNhanh <> N'Sài gòn' AND @ChiNhanh <> N'Hà nội')
		PRINT N'Chi nhánh không hợp lệ!'
	ELSE IF NOT EXISTS (SELECT MaPB FROM PhongBan WHERE MaPB = @MaPB)
		PRINT N'Không tìm thấy mã phòng ban!'
	ELSE IF EXISTS (SELECT MaPB FROM PhongBan WHERE TenPB = @TenPB AND ChiNhanh = @ChiNhanh AND MaPB != @MaPB)
		PRINT N'Không sửa dữ liệu được vì dữ liệu đã tồn tại'
	ELSE
	BEGIN
		UPDATE PhongBan SET TenPB = @TenPB, ChiNhanh = @ChiNhanh WHERE MaPB = @MaPB
		PRINT N'Sửa thành công'
	END
GO

exec SuaPhongBanMuc1 NULL, N'Thiết kế',N'Sài gòn'
exec SuaPhongBanMuc1 N'PB01', N'Nghiên cứu', NULL
exec SuaPhongBanMuc1 N'PB01', N'', NULL
exec SuaPhongBanMuc1 N'PB01', N'Nghiên cứu', ''
exec SuaPhongBanMuc1 N'PB01', N'Nghiên cứu', N'Cần thơ'
exec SuaPhongBanMuc1 N'PB01',N'Nghiên cứu', N'Sài gòn'
exec SuaPhongBanMuc1 N'PB02',N'Nghiên cứu', N'Sài gòn'
exec SuaPhongBanMuc1 N'PB02',N'Phát triển',N'Hà nội'
exec SuaPhongBanMuc1 N'PB06',N'Tài chánh',N'Sài gòn'
exec SuaPhongBanMuc1 N'PB09',N'Kỹ thuật',N'Sài gòn'

