CREATE DATABASE QLSinhVien
Go

USE QLSinhVien
Go

CREATE TABLE SinhVien(
	MaSV nchar(10) PRIMARY KEY ,
	HoSV nvarchar(20) NOT NULL,
	TenSV nvarchar(50) NOT NULL,
	GioiTinh nvarchar(10),
	NgaySinh date,
	QueQuan nvarchar(50),
	MaLop nchar(8))
GO

CREATE TABLE Lop(
	MaLop nchar(8) PRIMARY KEY ,
	TenLop nvarchar(50) NOT NULL,
	GVCN nvarchar(50))
GO

CREATE TABLE MonHoc(
	MaMH nchar(10) PRIMARY KEY ,
	TenMH nvarchar(50) NOT NULL,
	SoTinChi tinyint)
GO

CREATE TABLE Hoc(
	MaMH nchar(10),
	MaSV nchar(10),
	NgayDangKy date,
	Diem decimal(4,2)
	PRIMARY KEY(MaMH, MaSV, NgayDangKy))
GO

ALTER TABLE SinhVien
ADD CONSTRAINT FK_SinhVien_Lop FOREIGN KEY (MaLop) REFERENCES Lop(MaLop)
GO

ALTER TABLE Hoc
ADD CONSTRAINT FK_Hoc_SinhVien FOREIGN KEY (MaSV) REFERENCES SinhVien(MaSV)
GO

ALTER TABLE Hoc
ADD CONSTRAINT FK_Hoc_MonHoc FOREIGN KEY (MaMH) REFERENCES MonHoc(MaMH)
GO

INSERT Lop
VALUES('ML01', N'Lớp Toán', 'Lê Văn A')
INSERT Lop
VALUES('ML02', N'Lớp Tin', 'Lê Văn B')
INSERT Lop
VALUES('ML03', N'Lớp Văn', 'Lê Văn C')
INSERT Lop
VALUES('ML04', N'Lớp Hóa', 'Lê Văn D')
INSERT Lop
VALUES('ML05', N'Lớp Sử', 'Lê Văn E')
INSERT Lop
VALUES('ML06', N'Lớp Ngoai Ngữ', 'Lê Văn F')
INSERT Lop
VALUES('ML07', N'Lớp Bổ Túc', 'Lê Văn G')
INSERT Lop
VALUES('ML08', N'Lớp Chuyên Cần', 'Lê Văn H')
INSERT Lop
VALUES('ML09', N'Lớp Đồng Hóa', 'Lê Văn K')
INSERT Lop
VALUES('ML10', N'Lớp Cơ Sở', 'Lê Văn Q')
GO

INSERT SinhVien
VALUES('SV01', N'Nguyễn', 'Văn A', 'Nam', '19960102', 'TP.HCM', 'ML01')
INSERT SinhVien
VALUES('SV02', N'Nguyễn', 'Văn B', 'Nam', '19950506', N'Hà Nội', 'ML02')
INSERT SinhVien
VALUES('SV03', N'Nguyễn', 'Văn C', N'Nữ', '19980506', 'TP.HCM', 'ML05')
INSERT SinhVien
VALUES('SV04', N'Nguyễn', 'Văn D',  N'Nữ', '19971217', N'Quảng Nam', 'ML03')
INSERT SinhVien
VALUES('SV05', N'Nguyễn', 'Văn E', 'Nam', '19971220', N'Quảng Ngãi', 'ML06')
INSERT SinhVien
VALUES('SV06', N'Nguyễn', 'Văn F',  N'Nữ', '19970504', N'Bình Định', 'ML04')
INSERT SinhVien
VALUES('SV07', N'Nguyễn', 'Văn G', 'Nam', '19960102', N'Phú Yên', 'ML01')
INSERT SinhVien
VALUES('SV08', N'Nguyễn', 'Văn H', 'Nam', '19950506', N'Huế', 'ML06')
INSERT SinhVien
VALUES('SV09', N'Nguyễn', 'Văn K', N'Nữ', '19980506', N'TP.HCM', 'ML10')
INSERT SinhVien
VALUES('SV10', N'Nguyễn', 'Văn M',  N'Nữ', '19971217', N'Đồng Nai', 'ML08')
INSERT SinhVien
VALUES('SV11', N'Nguyễn', 'Văn L', 'Nam', '19971220', N'Ninh Bình', 'ML09')
INSERT SinhVien
VALUES('SV12', N'Nguyễn', 'Văn Q',  N'Nữ', '19970504', N'Hà Tiên', 'ML04')
GO

INSERT MonHoc
VALUES('MH1', N'Lớp Toán', 3)
INSERT MonHoc
VALUES('MH2', N'Lớp Ly', 2)
INSERT MonHoc
VALUES('MH3', N'Lớp Hóa', 3)
INSERT MonHoc
VALUES('MH4', N'Lớp Văn', 5)
INSERT MonHoc
VALUES('MH5', N'Lớp Sinh', 1)
INSERT MonHoc
VALUES('MH6', N'Lớp Sử', 2)
INSERT MonHoc
VALUES('MH7', N'Lớp Nghĩa Tình', 3)
INSERT MonHoc
VALUES('MH8', N'Lớp Nhân Ái', 2)
INSERT MonHoc
VALUES('MH9', N'Lớp Đồng Loại', 3)
INSERT MonHoc
VALUES('MH10', N'Lớp Thân Yêu', 5)
INSERT MonHoc
VALUES('MH11', N'Lớp Quý Mến', 1)
INSERT MonHoc
VALUES('MH12', N'Lớp Con Trai', 2)
GO

INSERT Hoc
VALUES('MH1', 'SV01', GETDATE(), 7)
INSERT Hoc
VALUES('MH2', 'SV02', GETDATE(), 9)
INSERT Hoc
VALUES('MH3', 'SV03', GETDATE(), 8)
INSERT Hoc
VALUES('MH4', 'SV04', GETDATE(), 10)
INSERT Hoc
VALUES('MH5', 'SV05', GETDATE(), 5)
INSERT Hoc
VALUES('MH6', 'SV06', GETDATE(), 7)
INSERT Hoc
VALUES('MH5', 'SV02', GETDATE(), 7)
INSERT Hoc
VALUES('MH3', 'SV05', GETDATE(), 9)
INSERT Hoc
VALUES('MH4', 'SV01', GETDATE(), 8)
INSERT Hoc
VALUES('MH6', 'SV02', GETDATE(), 10)
INSERT Hoc
VALUES('MH8', 'SV03', GETDATE(), 5)
INSERT Hoc
VALUES('MH2', 'SV03', GETDATE(), 7)
Go



