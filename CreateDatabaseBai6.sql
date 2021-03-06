USE master
GO

CREATE DATABASE QLDuAn1
GO

USE QLDuAn1
GO

CREATE TABLE NguoiQuanLy1(
		[MaNQL] [nchar](10) NOT NULL PRIMARY KEY,
		[Ho] [nvarchar](50) NULL,
		[Ten] [nvarchar](30) NULL,
		[TenPhong] [nvarchar](50) NULL
	)
	GO
		
INSERT INTO NguoiQuanLy1
	SELECT * FROM QLDuAn.dbo.NguoiQuanLy 
	WHERE TenPhong = 'P1'
	GO

CREATE TABLE NguoiQuanLy2(
		[MaNQL] [nchar](10) NOT NULL PRIMARY KEY,
		[Ho] [nvarchar](50) NULL,
		[Ten] [nvarchar](30) NULL,
		[TenPhong] [nvarchar](50) NULL
	)
	GO
		
INSERT INTO NguoiQuanLy2
	SELECT * FROM QLDuAn.dbo.NguoiQuanLy 
	WHERE TenPhong = 'P2'
	GO

CREATE TABLE [dbo].[BoPhan1](
		[MaBP] [nchar](10) NOT NULL PRIMARY KEY,
		[TenBP] [nvarchar](50) NULL,
		[MaNQL] [nchar](10) NULL
	)
	GO

INSERT INTO BoPhan1
	SELECT * FROM QLDuAn.dbo.BoPhan 
	WHERE MaNQL IN(
		SELECT MaNQL FROM NguoiQuanLy1
	)
	GO

CREATE TABLE [dbo].[BoPhan2](
		[MaBP] [nchar](10) NOT NULL PRIMARY KEY,
		[TenBP] [nvarchar](50) NULL,
		[MaNQL] [nchar](10) NULL
	)
	GO

INSERT INTO BoPhan2
	SELECT * FROM QLDuAn.dbo.BoPhan 
	WHERE MaNQL IN(
		SELECT MaNQL FROM NguoiQuanLy2
	)
	GO

CREATE TABLE [dbo].[DuAn1](
		[MaDA] [nchar](10) NOT NULL PRIMARY KEY,
		[TenDA] [nvarchar](50) NULL,
		[MaNQL] [nchar](10) NULL
	)
	GO

INSERT INTO DuAn1
	SELECT * FROM QLDuAn.dbo.DuAn 
	WHERE MaNQL IN(
		SELECT MaNQL FROM NguoiQuanLy1
	)
	GO

CREATE TABLE [dbo].[DuAn2](
		[MaDA] [nchar](10) NOT NULL PRIMARY KEY,
		[TenDA] [nvarchar](50) NULL,
		[MaNQL] [nchar](10) NULL
	)
	GO

INSERT INTO DuAn2
	SELECT * FROM QLDuAn.dbo.DuAn 
	WHERE MaNQL IN(
		SELECT MaNQL FROM NguoiQuanLy2
	)
	GO


CREATE TABLE [dbo].[NhanVien1](
		[MaNV] [nchar](10) NOT NULL PRIMARY KEY,
		[Ho] [nvarchar](50) NULL,
		[Ten] [nvarchar](30) NULL,
		[MaBP] [nchar](10) NULL
	)
	GO

INSERT INTO [NhanVien1]
	SELECT * FROM QLDuAn.dbo.NhanVien 
	WHERE MaBP IN(
		SELECT MaBP FROM BoPhan1
	)
	GO

CREATE TABLE [dbo].[NhanVien2](
		[MaNV] [nchar](10) NOT NULL PRIMARY KEY,
		[Ho] [nvarchar](50) NULL,
		[Ten] [nvarchar](30) NULL,
		[MaBP] [nchar](10) NULL
	)
	GO

INSERT INTO [NhanVien2]
	SELECT * FROM QLDuAn.dbo.NhanVien 
	WHERE MaBP IN(
		SELECT MaBP FROM BoPhan2
	)
	GO

CREATE TABLE [dbo].[PhanCong1](
		[MaNV] [nchar](10) NOT NULL,
		[MaDA] [nchar](10) NOT NULL,
		 CONSTRAINT [PK_PhanCong1] PRIMARY KEY CLUSTERED 
		(
			[MaNV] ASC,
			[MaDA] ASC
		)
	)
	GO

INSERT INTO [PhanCong1]
	SELECT * FROM QLDuAn.dbo.PhanCong 
	WHERE MaNV IN(
		SELECT MaNV FROM NhanVien1
	)
	GO

CREATE TABLE [dbo].[PhanCong2](
		[MaNV] [nchar](10) NOT NULL,
		[MaDA] [nchar](10) NOT NULL,
		 CONSTRAINT [PK_PhanCong2] PRIMARY KEY CLUSTERED 
		(
			[MaNV] ASC,
			[MaDA] ASC
		)
	)
	GO

INSERT INTO [PhanCong2]
	SELECT * FROM QLDuAn.dbo.PhanCong 
	WHERE MaNV IN(
		SELECT MaNV FROM NhanVien2
	)
	GO


/*
	4.	Lập danh sách tên những dự án (TênDA) chưa có nhân viên tham gia.
*/

USE QLDuAn
GO
CREATE PROC DuAnChuaThamGia
AS
	SELECT * FROM DuAn 
	WHERE MaDA NOT IN(
		SELECT MaDA FROM PhanCong AS PC, NhanVien AS NV
		WHERE PC.MANV = NV.MaNV
	)
GO
EXEC DuAnChuaThamGia
GO


USE QLDuAn1
GO
CREATE PROC DuAnChuaThamGia1
AS
	SELECT * FROM DuAn1 
	WHERE MaDA NOT IN(
		SELECT MaDA FROM PhanCong1 AS PC, NhanVien1 AS NV
		WHERE PC.MANV = NV.MaNV
		)
	UNION
	SELECT * FROM DuAn2 
	WHERE MaDA NOT IN(
		SELECT MaDA FROM PhanCong2 AS PC, NhanVien2 AS NV
		WHERE PC.MANV = NV.MaNV
		)
GO
EXEC DuAnChuaThamGia1
GO

