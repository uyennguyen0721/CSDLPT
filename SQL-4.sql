--Bài 1

create proc TaoPM_Ngang_PhongBan
as
begin
	select * into PB_SG
	from PhongBan
	where ChiNhanh = N'Sài gòn'

	select * into PB_HN
	from PhongBan
	where ChiNhanh = N'Sài gòn'
end
go


exec TaoPM_Ngang_PhongBan


create proc TaoPM_Ngang_NhanVien
as
begin
	select * into NV_SG
	from NhanVien
	where MaPB in (select MaPB from PB_SG)

	select * into NV_HN
	from NhanVien
	where MaPB in (select MaPB from PB_HN)
end
go


exec TaoPM_Ngang_NhanVien


--Bài 2

create proc SuaPB_Ngang
	@MaPB nvarchar(10)
	, @TenPB nvarchar(50)
	, @ChiNhanh nvarchar(50)
as
begin
	if (@MaPB is null)
		print N'Không thể sửa dữ liệu vì không có giá trị mã PB'
	else if (@TenPB is null)
		print N'Không thể sửa dữ liệu vì không có giá trị tên PB'
	else if (@ChiNhanh is null)
		print N'Không thể sửa dữ liệu vì không có giá trị chi nhánh PB'
	else if not exists (select * from PB_SG where MaPB = @MaPB
						union
						select * from PB_HN where MaPB = @MaPB)
		print N'Không thể sửa dữ liệu vì không tìm thấy mã PB'
	else if (@ChiNhanh not in (N'Sài gòn', N'Hà nội'))
		print N'Không thể sửa dữ liệu vì giá trị chi nhánh không hợp lệ'
	else
		begin
			update PhongBan
			set TenPB = @TenPB, ChiNhanh = @ChiNhanh
			where MaPB = @MaPB

			if (@ChiNhanh = N'Sài gòn')
				begin
					insert into PB_SG
					select * from PB_HN
					where MaPB = @MaPB

					insert into NV_SG
					select * from NV_HN
					where MaPB = @MaPB

					delete PB_HN
					where MaPB = @MaPB

					delete NV_HN
					where MaPB = @MaPB

					print N'Sửa dữ liệu thành công và dữ liệu đã được chuyển từ phân mảnh PB_HN sang PB_SG'
				end
			else
				begin
					insert into PB_HN
					select * from PB_SG
					where MaPB = @MaPB

					insert into NV_HN
					select * from NV_SG
					where MaPB = @MaPB

					delete PB_SG
					where MaPB = @MaPB

					delete NV_SG
					where MaPB = @MaPB

					print N'Sửa dữ liệu thành công và dữ liệu đã được chuyển từ phân mảnh PB_SG sang PB_HN'
				end

		end
end
go

exec SuaPB_Ngang null, N'Thiết kế', N'Sài gòn'
exec SuaPB_Ngang N'PB01', null, N'Sài gòn'
exec SuaPB_Ngang N'PB01', N'Thiết kế', null
exec SuaPB_Ngang N'PB01', N'Thiết kế', N'Cần thơ'
exec SuaPB_Ngang N'PB03', N'Nghiên cứu TT', N'Hà nội'
exec SuaPB_Ngang N'PB04', N'Bán hàng', N'Sài gòn'

select * from PhongBan


--Bài 3

create proc TaoPM_Doc_PhongBan
as
begin
	select MaPB, TenPB into PB_D1
	from PhongBan

	select MaPB, ChiNhanh into PB_D2
	from PhongBan
end
go

exec TaoPM_Doc_PhongBan

--Bài 4

create proc XemPB_Doc
as
begin
	select d1.*, d2.ChiNhanh
	from PB_D1 d1, PB_D2 d2
	where d1.MaPB = d2.MaPB and (TenPB = N'Thiết kế' or TenPB = N'Kế toán')
end
go

exec XemPB_Doc

select * from PB_D2

--Bài 5

create proc ThemPB_Doc
	@MaPB nvarchar(10)
	, @TenPB nvarchar(50)
	, @ChiNhanh nvarchar(50)
as
begin
	if (@MaPB is null)
		print N'Không thể thêm dữ liệu vì không có giá trị mã PB'
	else if (@TenPB is null)
		print N'Không thể thêm dữ liệu vì không có giá trị tên PB'
	else if (@ChiNhanh is null)
		print N'Không thể thêm dữ liệu vì không có giá trị chi nhánh PB'
	else if exists (select * from PB_D1 where MaPB = @MaPB)
		print N'Không thể thêm dữ liệu vì mã PB bị trùng'
	else if (@ChiNhanh not in (N'Sài gòn', N'Hà nội'))
		print N'Không thể thêm dữ liệu vì giá trị chi nhánh không hợp lệ'
	else
		begin
			insert into Phongban
			values (@MaPB, @TenPB, @ChiNhanh)

			insert into PB_D1
			values (@MaPB, @TenPB)

			insert into PB_D2
			values (@MaPB, @ChiNhanh)

			print N'Thêm dữ liệu thành công'
		end
		
end
go

exec ThemPB_Doc null, N'Thiết kế', N'Sài gòn'
exec ThemPB_Doc N'PB10', null, N'Sài gòn'
exec ThemPB_Doc N'PB10', N'Thiết kế', null
exec ThemPB_Doc N'PB04', N'Thiết kế', N'Sài gòn'
exec ThemPB_Doc N'PB10', N'Thiết kế', N'Sài gòn'
exec ThemPB_Doc N'PB11', N'Tiếp thị', N'Hà nội'

--Bài 6

create view DanhSachTatCaPB_HH
as

	select h1.*, h2.ChiNhanh
	from PhongBan_HH1 h1, PhongBan_HH2 h2
	where h1.MaPB = h2.MaPB
	union
	select h3.*, h4.ChiNhanh
	from PhongBan_HH3 h3, PhongBan_HH4 h4
	where h3.MaPB = h4.MaPB
go

select * from DanhSachTatCaPB_HH


--Câu 7

create proc ThemPB_HH
	@MaPB nvarchar(10)
	, @TenPB nvarchar(50)
	, @ChiNhanh nvarchar(50)
as
begin
	if (@MaPB is null)
		print N'Không thể thêm dữ liệu vì không có giá trị mã PB'
	else if (@TenPB is null)
		print N'Không thể thêm dữ liệu vì không có giá trị tên PB'
	else if (@ChiNhanh is null)
		print N'Không thể thêm dữ liệu vì không có giá trị chi nhánh PB'
	else if exists (select * from PhongBan_HH1 where MaPB = @MaPB
					union
					select * from PhongBan_HH3 where MaPB = @MaPB)
		print N'Không thể thêm dữ liệu vì mã PB bị trùng'
	else if (@ChiNhanh not in (N'Sài gòn', N'Hà nội'))
		print N'Không thể thêm dữ liệu vì giá trị chi nhánh không hợp lệ'
	else
		begin
			insert into Phongban
			values (@MaPB, @TenPB, @ChiNhanh)

			if (@ChiNhanh = N'Sài gòn')
				begin
					insert into PhongBan_HH1
					values (@MaPB, @TenPB)

					insert into PhongBan_HH2
					values (@MaPB, @ChiNhanh)

					print N'Thêm dữ liệu thành công vào các phân mảnh hỗn hợp của chi nhánh Sài gòn'
				end
			else
				begin
					insert into PhongBan_HH3
					values (@MaPB, @TenPB)

					insert into PhongBan_HH4
					values (@MaPB, @ChiNhanh)

					print N'Thêm dữ liệu thành công vào các phân mảnh hỗn hợp của chi nhánh Hà nội'
				end

		end
		
end
go

exec ThemPB_HH null, N'Thiết kế', N'Sài gòn'
exec ThemPB_HH N'PB10', null, N'Sài gòn'
exec ThemPB_HH N'PB10', N'Thiết kế', null
exec ThemPB_HH N'PB04', N'Thiết kế', N'Sài gòn'
exec ThemPB_HH N'PB12', N'Thiết kế', N'Sài gòn'
exec ThemPB_HH N'PB13', N'Tiếp thị', N'Hà nội'