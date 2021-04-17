--Bài 1

create proc TaoPhanManhNXB
as
begin
	select * into NXBTuNhan
	from NhaXuatBan
	where LoaiHinh = N'Tư nhân'

	select * into NXBNhaNuoc
	from NhaXuatBan
	where LoaiHinh = N'Nhà nước'
end
go

exec TaoPhanManhNXB


create proc TaoPhanManhSach
as
begin
	select * into SachTuNhan
	from Sach
	where MaNXB in (select MaNXB from NXBTuNhan)

	select * into SachNhaNuoc
	from Sach
	where MaNXB in (select MaNXB from NXBNhaNuoc)
end
go

exec TaoPhanManhSach


--Bài 2

create proc XemSachMuc2
@TenNXB nvarchar(50)
as
begin
	if (@TenNXB is null)
		print N'Không nhập tên NXB'
	else if not exists (select * from NhaXuatBan where TenNXB = @TenNXB)
		print N'Không tìm thấy giá trị Tên NXB trong CSDL'
	else
		begin
			select s.*, n.TenNXB
			from  SachNhaNuoc s, NXBNhaNuoc n
			where s.MaNXB = n.MaNXB and TenNXB = @TenNXB
			union	
			select s.*, n.TenNXB
			from  SachTuNhan s, NXBTuNhan n
			where s.MaNXB = n.MaNXB and TenNXB = @TenNXB
		end
end
go

exec XemSachMuc2 null
exec XemSachMuc2 N'Sự thật'
exec XemSachMuc2 N'Mỹ thuật'
exec XemSachMuc2 N'Công nghệ'


--Bài 3

create proc ThemNXBMuc2
@MaNXB nvarchar(10)
, @TenNXB nvarchar(50)
, @LoaiHinh nvarchar(50)
as
begin
	if (@MaNXB is null)
		print N'Không có giá trị mã NXB'
	else if (@TenNXB is null)
		print N'Không có giá trị tên NXB'
	else if (@LoaiHinh is null)
		print N'Không có giá trị loại hình NXB'
	else if exists (select * from NhaXuatBan where MaNXB = @MaNXB)
		print N'Bị trùng mã NXB'
	else if (@LoaiHinh in (N'Nhà nước', N'Tư nhân'))
		begin
			insert into NhaXuatBan
			values (@MaNXB, @TenNXB, @LoaiHinh)

			if (@LoaiHinh = N'Nhà nước')
				begin
					insert into NXBNhaNuoc
					values (@MaNXB, @TenNXB, @LoaiHinh)
					print N'Đã thêm thành công NXB vào phân mảnh NXBNhaNuoc'
				end
			else 
				begin
					insert into NXBTuNhan
					values (@MaNXB, @TenNXB, @LoaiHinh)
					print N'Đã thêm thành công NXB vào phân mảnh NXBTuNhan'
				end
		end
	else
		print N'Giá trị loại hình NXB không hợp lệ'
	
end
go

exec ThemNXBMuc2 NULL, N'Tương lai', N'Tư nhân'
exec ThemNXBMuc2 N'NXB10', NULL, N'Tư nhân'
exec ThemNXBMuc2 N'NXB10', N'Tương lai', NULL
exec ThemNXBMuc2 N'NXB10', N'Tương lai', N'Tư nhân'
exec ThemNXBMuc2 N'NXB11', N'Giáo dục', N'Nhà nước'
exec ThemNXBMuc2 N'NXB1', N'Thiếu niên', N'Nhà nước'
exec ThemNXBMuc2 N'NXB2', N'Thanh niên', N'Nhà nước'

--Bài 4

create proc SuaNXBMuc2
@MaNXB nvarchar(10)
, @TenNXB nvarchar(50)
, @LoaiHinh nvarchar(50)
as
begin
	if (@MaNXB is null)
		print N'Không có giá trị mã NXB'
	else if (@TenNXB is null)
		print N'Không có giá trị tên NXB'
	else if (@LoaiHinh is null)
		print N'Không có giá trị loại hình NXB'
	else if not exists (select * from NhaXuatBan where MaNXB = @MaNXB)
		print N'Không tìm thấy giá trị mã NXB để sửa'
	else if (@LoaiHinh in (N'Nhà nước', N'Tư nhân'))
		begin
			update NhaXuatBan
			set TenNXB = @TenNXB, LoaiHinh = @LoaiHinh
			where MaNXB = @MaNXB

			if (@LoaiHinh = N'Nhà nước')
				begin
					insert into NXBNhaNuoc
					select * from NXBTuNhan where MaNXB = @MaNXB 

					delete NXBTuNhan
					where MaNXB = @MaNXB 

					insert into SachNhaNuoc
					select * from SachTuNhan where MaNXB = @MaNXB

					delete SachTuNhan
					where MaNXB = @MaNXB

					print N'Đã sửa và có đổi loại hình sách.
							Đã dời NXB mã ... từ phân mảnh NXBTuNhan sang phân mảnh NXBNhaNuoc
							Đã dời sách của NXB mã … từ phân mảnh SachTuNhan sang phân mảnh SachNhaNuoc'

				end
			else
				begin
					insert into NXBTuNhan
					select * from NXBNhaNuoc where MaNXB = @MaNXB 

					delete NXBNhaNuoc
					where MaNXB = @MaNXB 

					insert into SachTuNhan
					select * from SachNhaNuoc where MaNXB = @MaNXB

					delete SachNhaNuoc
					where MaNXB = @MaNXB

					print N'Đã sửa và có đổi loại hình sách.
							Đã dời NXB mã ... từ phân mảnh NXBNhaNuoc sang phân mảnh NXBTuNhan
							Đã dời sách của NXB mã … từ phân mảnh SachNhaNuoc sang phân mảnh SachTuNhan'
				end
		end
	else
		print N'Giá trị loại hình NXB không hợp lệ'
	
end
go

exec SuaNXBMuc2 NULL,N'Sáng tạo mới',N'Tư nhân'
exec SuaNXBMuc2 N'NXB111',N'Kỹ thuật',N'Tư nhân'
exec SuaNXBMuc2 N'NXB111',N'Kỹ thuật',NULL
exec SuaNXBMuc2 N'NXB111',N'Kỹ thuật',N'Nhập khẩu'
exec SuaNXBMuc2 N'NXB1',N'Sáng tạo mới',N'Tư nhân'
exec SuaNXBMuc2 N'NXB3',N'Thành công',N'Nhà nước'
exec SuaNXBMuc2 N'NXB6',N'Đất Việt',N'Tư nhân'

--Bài 5

create proc TaoPM_Doc_NXB
as
begin
	select MaNXB, TenNXB into NXBDoc1
	from NhaXuatBan

	select MaNXB, LoaiHinh into NXBDoc2
	from NhaXuatBan
end
go

exec TaoPM_Doc_NXB

--Bài 6
create proc XemNXB_Doc
as
begin
	select d1.*, d2.LoaiHinh
	from NXBDoc1 d1, NXBDoc2 d2
	where d1.MaNXB = d2.MaNXB
end
go

exec XemNXB_Doc