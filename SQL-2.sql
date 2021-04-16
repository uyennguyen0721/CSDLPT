--Bài 1

create proc TaoPM_Ngang_PB
as
begin
	select * into PhongBanSG
	from PhongBan
	where ChiNhanh = N'Sài gòn'

	select * into PhongBanHN
	from PhongBan
	where ChiNhanh = N'Hà nội'
end
go

exec TaoPM_Ngang_PB

create proc TaoPM_Ngang_NhanVien
as
begin
	select * into NhanVienSG
	from NhanVien
	where MaPB in (select MaPB from PhongBanSG)

	select * into NhanVienHN
	from NhanVien
	where MaPB in (select MaPB from PhongBanHN)
end
go

exec TaoPM_Ngang_NhanVien


--Bài 2

create proc ThemPB
@MaPB nvarchar(10)
, @TenPB nvarchar(50)
, @ChiNhanh nvarchar(50)
as
begin
	if (@MaPB is null)
		print N'Không thêm được phòng ban vì không có dữ liệu mã PB'
	else if (@TenPB is null)
		print N'Không thêm được phòng ban vì không có dữ liệu tên PB'
	else if (@ChiNhanh is null)
		print N'Không thêm được phòng ban vì không có dữ liệu chi nhánh PB'
	else if (@ChiNhanh not in (N'Sài gòn', N'Hà nội'))
		print N'Không thêm được phòng ban vì giá trị chi nhánh không hợp lệ'
	else if exists (select * from PhongBan where MaPB = @MaPB)
		print N'Không thêm được phòng ban vì bị trùng mã PB'
	else if (@ChiNhanh = N'Sài gòn')
		begin
			insert into PhongBanSG
			values (@MaPB, @TenPB, @ChiNhanh)
			print N'Thêm phòng ban thành công vào phân mảnh PhongBanSG'
		end
	else
		begin
			insert into PhongBanHN
			values (@MaPB, @TenPB, @ChiNhanh)
			print N'Thêm phòng ban thành công vào phân mảnh PhongBanHN'
		end
end
go


exec ThemPB null, N'Thiết kế', N'Sài gòn'
exec ThemPB N'PB07', null, N'Hà nội'
exec ThemPB N'PB07', 'Bán hàng', null
exec ThemPB N'PB07', N'Kinh doanh', N'Cần thơ'
exec ThemPB N'PB05', N'Sale', 'Sài gòn'
exec ThemPB N'PB07', N'Tiếp thị', N'Sài gòn'
exec ThemPB N'PB08', N'Nghiên cứu TT', N'Hà nội'


--Bài 3

create proc SuaPB
@MaPB nvarchar(10)
, @TenPB nvarchar(50)
, @ChiNhanh nvarchar(50)
as
begin
	if (@MaPB is null)
		print N'Không sửa được phòng ban vì không có dữ liệu mã PB'
	else if (@TenPB is null)
		print N'Không sửa được phòng ban vì không có dữ liệu tên PB'
	else if (@ChiNhanh is null)
		print N'Không sửa được phòng ban vì không có dữ liệu chi nhánh PB'
	else if (@ChiNhanh not in (N'Sài gòn', N'Hà nội'))
		print N'Không sửa được phòng ban vì giá trị chi nhánh không hợp lệ'
	else if exists (select * from PhongBan where MaPB = @MaPB)
		begin
			update PhongBan
			set TenPB = @TenPB, ChiNhanh = @ChiNhanh
			where MaPB = @MaPB
			if (@ChiNhanh = N'Sài gòn')
				begin
					insert into PhongBanSG
					select * from PhongBanHN where MaPB = @MaPB

					delete PhongBanHN
					where MaPB = @MaPB

					print N'Dữ liệu đã được sửa thành công và chuyển từ phân mảnh PhongBanHN sang PhongBanSG'

				end
			else
				begin
					insert into PhongBanHN
					select * from PhongBanSG where MaPB = @MaPB

					delete PhongBanSG
					where MaPB = @MaPB

					print N'Dữ liệu đã được sửa thành công và chuyển từ phân mảnh PhongBanSG sang PhongBanHN'

				end
		end
	else
		print N'Không tìm thấy mã PB để sửa dữ liệu'
end
go


exec SuaPB null, N'Thiết kế', N'Sài gòn'
exec SuaPB N'PB07', null, N'Hà nội'
exec SuaPB N'PB07', 'Bán hàng', null
exec SuaPB N'PB09', N'Thiết kế', N'Sài gòn'
exec SuaPB N'PB07', N'Kinh doanh', N'Cần thơ'
exec SuaPB N'PB05', N'Bán hàng', N'Sài gòn'
exec SuaPB N'PB03', N'Thiết kế', N'Hà nội'

select * from PhongBan


--Bài 4
create proc TaoPM_Doc_PB
as
begin
	select p.MaPB, p.TenPB into PhongBanDoc1
	from PhongBan p

	select p.MaPB, p.ChiNhanh into PhongBanDoc2
	from PhongBan p
end
go

exec TaoPM_Doc_PB

select * from PhongBanDoc1
select * from PhongBanDoc2

--Bài 5
create proc XemPB_Doc
as
begin
	select d1.*, d2.ChiNhanh
	from PhongBanDoc1 d1, PhongBanDoc2 d2
	where d1.MaPB = d2.MaPB
end
go

exec XemPB_Doc

--Bài 6
create proc SuaPB_Doc
@MaPB nvarchar(10)
, @TenPB nvarchar(50)
, @ChiNhanh nvarchar(50)
as
begin
	if (@MaPB is null)
		print N'Không sửa được phòng ban vì không có dữ liệu mã PB'
	else if (@TenPB is null)
		print N'Không sửa được phòng ban vì không có dữ liệu tên PB'
	else if (@ChiNhanh is null)
		print N'Không sửa được phòng ban vì không có dữ liệu chi nhánh PB'
	else if (@ChiNhanh not in (N'Sài gòn', N'Hà nội'))
		print N'Không sửa được phòng ban vì giá trị chi nhánh không hợp lệ'
	else if exists (select * from PhongBan where MaPB = @MaPB)
		begin
			update PhongBan
			set TenPB = @TenPB, ChiNhanh = @ChiNhanh
			where MaPB = @MaPB

			update PhongBanDoc1
			set TenPB = @TenPB
			where maPB = @MaPB

			update PhongBanDoc2
			set ChiNhanh = @ChiNhanh
			where MaPB = @MaPB

			print N'Sửa dữ liệu thành công'
		end
	else
		print N'Không tìm thấy mã PB để sửa dữ liệu'
end
go

exec SuaPB_Doc null, N'Thiết kế', N'Sài gòn'
exec SuaPB_Doc N'PB07', null, N'Hà nội'
exec SuaPB_Doc N'PB07', 'Bán hàng', null
exec SuaPB_Doc N'PB09', N'Thiết kế', N'Sài gòn'
exec SuaPB_Doc N'PB07', N'Kinh doanh', N'Cần thơ'
exec SuaPB_Doc N'PB02', N'Kinh doanh', N'Hà nội'
exec SuaPB_Doc N'PB03', N'Bán hàng', N'Sài gòn'