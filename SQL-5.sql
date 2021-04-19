--Bài 1

create proc TaoPhanManh_NXB
as
begin
	select * into NXB_TuNhan
	from NhaXuatBan
	where LoaiHinh = N'Tư nhân'

	select * into NXB_NhaNuoc
	from NhaXuatBan
	where LoaiHinh = N'Nhà nước'
end
go

create proc TaoPhanManh_Sach
as
begin
	select * into Sach_TuNhan
	from Sach
	where MaNXB in (select MaNXB from NXB_TuNhan)

	select * into Sach_NhaNuoc
	from Sach
	where MaNXB in (select MaNXB from NXB_NhaNuoc)
end
go

exec TaoPhanManh_NXB
exec TaoPhanManh_Sach

--Bài 2

create proc DSSachMuc1
@TenNXB nvarchar(50)
as
begin
	if (@TenNXB is null)
		print N'Không có giá trị Tên NXB'
	else if exists (select * from NhaXuatBan where TenNXB = @TenNXB)
		begin 
			select s.*, n.TenNXB
			from Sach s, NhaXuatBan n
			where TenNXB = @TenNXB and s.MaNXB = n.MaNXB
		end
	else
		print N'Không tìm thấy tên NXB'
end
go


create proc DSSachMuc2
@TenNXB nvarchar(50)
as
begin
	if (@TenNXB is null)
		print N'Không có giá trị Tên NXB'
	else if exists (select * from NXB_TuNhan where TenNXB = @TenNXB
					union
					select * from NXB_NhaNuoc where TenNXB = @TenNXB)
		begin 
			select st.*, nt.TenNXB
			from Sach_TuNhan st, NXB_TuNhan nt
			where TenNXB = @TenNXB and st.MaNXB = nt.MaNXB 
			union
			select sn.*, nn.TenNXB
			from Sach_NhaNuoc sn, NXB_NhaNuoc nn
			where TenNXB = @TenNXB and sn.MaNXB = nn.MaNXB 
		end
	else
		print N'Không tìm thấy tên NXB'
end
go

exec DSSachMuc1 N'Sự thật'
exec DSSachMuc2 N'Sự thật'

--Bài 3

create proc ThemNXBMuc1
@MaNXB nvarchar(10)
, @TenNXB nvarchar(50)
, @LoaiHinh nvarchar(50)
as
begin
	if (@MaNXB is null)
		print N'Không thêm được NXB vì không có giá trị Mã NXB'
	else if (@TenNXB is null)
		print N'Không thêm được NXB vì không có giá trị Tên NXB'
	else if (@LoaiHinh is null)
		print N'Không thêm được NXB vì không có giá trị Loại hình NXB'
	else if exists (select * from NhaXuatBan where MaNXB = @MaNXB)
		print N'Không thêm được NXB vì bị trùng mã NXB trong CSDL'
	else if (@LoaiHinh not in (N'Tư nhân', N'Nhà nước'))
		print N'Không thêm được NXB vì giá trị loại hình NXB không hợp lệ'
	else
		begin
			insert into NhaXuatBan
			values (@MaNXB, @TenNXB, @LoaiHinh)

			print N'Thêm dữ liệu NXB thành công'
		end
end
go


create proc ThemNXBMuc2
@MaNXB nvarchar(10)
, @TenNXB nvarchar(50)
, @LoaiHinh nvarchar(50)
as
begin
	if (@MaNXB is null)
		print N'Không thêm được NXB vì không có giá trị Mã NXB'
	else if (@TenNXB is null)
		print N'Không thêm được NXB vì không có giá trị Tên NXB'
	else if (@LoaiHinh is null)
		print N'Không thêm được NXB vì không có giá trị Loại hình NXB'
	else if exists (select * from NXB_TuNhan where MaNXB = @MaNXB 
					union
					select * from NXB_NhaNuoc where MaNXB = @MaNXB)
		print N'Không thêm được NXB vì bị trùng mã NXB trong CSDL'
	else if (@LoaiHinh not in (N'Tư nhân', N'Nhà nước'))
		print N'Không thêm được NXB vì giá trị loại hình NXB không hợp lệ'
	else if (@LoaiHinh = N'Tư nhân')
		begin
			insert into NXB_TuNhan
			values (@MaNXB, @TenNXB, @LoaiHinh)

			print N'Thêm dữ liệu NXB thành công vào phân mảnh NXB_TuNhan'
		end
	else
		begin
			insert into NXB_NhaNuoc
			values (@MaNXB, @TenNXB, @LoaiHinh)

			print N'Thêm dữ liệu NXB thành công vào phân mảnh NXB_NhaNuoc'
		end
end
go

exec ThemNXBMuc1 N'NXB10', N'Tương lai', N'Tư nhân'
exec ThemNXBMuc1 N'NXB11', N'Giáo dục', N'Nhà nước'

exec ThemNXBMuc2 N'NXB10', N'Tương lai', N'Tư nhân'
exec ThemNXBMuc2 N'NXB11', N'Giáo dục', N'Nhà nước'


--Bài 4

create proc SuaNXBMuc1
@MaNXB nvarchar(10)
, @TenNXB nvarchar(50)
, @LoaiHinh nvarchar(50)
as
begin
	if (@MaNXB is null)
		print N'Không sua được NXB vì không có giá trị Mã NXB'
	else if (@TenNXB is null)
		print N'Không sua được NXB vì không có giá trị Tên NXB'
	else if (@LoaiHinh is null)
		print N'Không sua được NXB vì không có giá trị Loại hình NXB'
	else if not exists (select * from NhaXuatBan where MaNXB = @MaNXB)
		print N'Không sua được NXB vì bị trùng mã NXB trong CSDL'
	else if (@LoaiHinh not in (N'Tư nhân', N'Nhà nước'))
		print N'Không sua được NXB vì giá trị loại hình NXB không hợp lệ'
	else
		begin
			update NhaXuatBan
			set TenNXB = @TenNXB, LoaiHinh = @LoaiHinh
			where MaNXB = @MaNXB

			print N'Sửa dữ liệu NXB thành công'
		end
end
go


create proc SuaNXBMuc2
@MaNXB nvarchar(10)
, @TenNXB nvarchar(50)
, @LoaiHinh nvarchar(50)
as
begin
	if (@MaNXB is null)
		print N'Không sua được NXB vì không có giá trị Mã NXB'
	else if (@TenNXB is null)
		print N'Không sua được NXB vì không có giá trị Tên NXB'
	else if (@LoaiHinh is null)
		print N'Không sua được NXB vì không có giá trị Loại hình NXB'
	else if not exists (select * from NXB_TuNhan where MaNXB = @MaNXB 
						union
						select * from NXB_NhaNuoc where MaNXB = @MaNXB)
		print N'Không sua được NXB vì không tìm thấy mã NXB trong CSDL'
	else if (@LoaiHinh not in (N'Tư nhân', N'Nhà nước'))
		print N'Không sua được NXB vì giá trị loại hình NXB không hợp lệ'
	else
		begin
			update NhaXuatBan
			set TenNXB = @TenNXB, LoaiHinh = @LoaiHinh
			where MaNXB = @MaNXB

			if (@LoaiHinh = N'Tư nhân')
				begin
					insert into NXB_TuNhan
					select * from NXB_NhaNuoc
					where MaNXB = @MaNXB 

					insert into Sach_TuNhan
					select * from Sach_NhaNuoc
					where MaNXB = @MaNXB 

					delete NXB_NhaNuoc
					where MaNXB = @MaNXB

					delete Sach_NhaNuoc
					where MaNXB = @MaNXB

					print N'Đã sửa thành công NXB. Đã chuyển dữ liệu NXB từ phân mảnh NXB_NhaNuoc sáng NXB_TuNhan. Đã chuyển dữ liệu sách từ phân mảnh Sach_NhaNuoc sang Sach_TuNhan'
				end
			else
				begin
					insert into NXB_NhaNuoc
					select * from NXB_TuNhan
					where MaNXB = @MaNXB 

					insert into Sach_NhaNuoc
					select * from Sach_TuNhan
					where MaNXB = @MaNXB 

					delete NXB_TuNhan
					where MaNXB = @MaNXB

					delete Sach_TuNhan
					where MaNXB = @MaNXB

					print N'Đã sửa thành công NXB. Đã chuyển dữ liệu NXB từ phân mảnh NXB_TuNhan sáng NXB_NhaNuoc. Đã chuyển dữ liệu sách từ phân mảnh Sach_TuNhan sang Sach_NhaNuoc'
				end
		end
end
go

exec SuaNXBMuc1 N'NXB10', N'Thành công', N'Nhà nước'
exec SuaNXBMuc2 N'NXB11', N'Đất việt', N'Tư nhân'

--Bài 5

create proc XoaSachMuc1
@MaSach nvarchar(10)
as
begin
	if (@MaSach is null)
		print N'Không xoa được Sách vì không có giá trị Mã Sách'
	else if not exists (select * from Sach where MaSach = @MaSach)
		print N'không xóa được Sách vì không tìm thấy mã sách trong CSDL'
	else
		begin
			delete Sach
			where MaSach = @MaSach

			print N'Xóa Sách thành công'
		end
end
go

create proc XoaSachMuc2
@MaSach nvarchar(10)
as
begin
	if (@MaSach is null)
		print N'Không xoa được Sách vì không có giá trị Mã Sách'
	else if exists (select * from Sach where MaSach = @MaSach)
		begin
			delete Sach
			where MaSach = @MaSach

			if exists (select * from Sach_TuNhan where MaSach = @MaSach)
				begin
					delete Sach_TuNhan
					where MaSach = @MaSach

					print N'Xoa sách thành công ở phân mảnh Sach_TuNhan'
				end
			else
				begin
					delete Sach_NhaNuoc
					where MaSach = @MaSach

					print N'Xoa sách thành công ở phân mảnh Sach_NhaNuoc'
				end
		end
	else
		print N'không xóa được Sách vì không tìm thấy mã sách trong CSDL'
end
go

exec XoaSachMuc1 N'S004'
exec XoaSachMuc1 N'S005'

exec XoaSachMuc2 N'S006'
exec XoaSachMuc2 N'S007'