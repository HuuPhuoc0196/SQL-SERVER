USE QLSinhVien
GO

-- truy vấn đơn giản
SELECT * FROM SinhVien
SELECT * FROM Lop
SELECT * FROM MonHoc
SELECT * FROM Hoc
GO

-- xuất ra MaSV, HoSV, TenSV, Tên Lớp của sinh viên đó
SELECT SV.MaSV, SV.HoSV, SV.TenSV, L.TenLop FROM SinhVien AS SV, Lop AS L
WHERE SV.MaLop = L.MaLop
GO

-- xuất ra MaSV, HoSV, TenSV, TenMH của sinh viên đó
SELECT SV.MaSV, SV.HoSV, SV.TenSV, MH.TenMH
FROM SinhVien AS SV, Hoc AS H, MonHoc AS MH
WHERE H.MaSV = SV.MaSV AND H.MaMH = MH.MaMH





