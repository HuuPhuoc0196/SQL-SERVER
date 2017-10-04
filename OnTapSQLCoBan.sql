USE ONLINE_SHOP
GO

/*
	Tạo view hiển thị thông tin khách hàng có tình trạng là đang dùng
*/
CREATE VIEW ThongTinKhachHang AS
SELECT * FROM KHACHHANG WHERE TinhTrang = N'đang dùng'
GO

/*
	Tạo view hiển thị thông tin khách hàng có tình trạng là đang chờ giao hàng
*/
CREATE VIEW ThongTinKhachHangDangChoGiao AS
SELECT KHACHHANG.* FROM KHACHHANG, PHIEUDATHANG
WHERE KHACHHANG.MaKhachHang = PHIEUDATHANG.MaKhachHang
AND PHIEUDATHANG.TinhTrang = N'Đang chờ giao'

SELECT * FROM PHIEUDATHANG
SELECT * FROM KHACHHANG