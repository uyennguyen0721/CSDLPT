--Bài 1
use QLNhanVien
go
create proc TaoPhanManhPB
as
begin
	select * into PhongBanSG
	from [dbo].[PhongBan]
	where [ChiNhanh] = N'Sài gòn'

	select * into PhongBanHN
	from [dbo].[PhongBan]
	where [ChiNhanh] = N'Hà nội'
end
go

exec dbo.TaoPhanManhPB


create proc TaoPhanManhNV
as
begin
	select * into NhanVienSG
	from [dbo].[NhanVien]
	where [MaPB] in (select maPB from dbo.PhongBanSG)

	select * into NhanVienHN
	from [dbo].[NhanVien]
	where [MaPB] in (select MaPB from dbo.PhongBanHN)
end
go


exec dbo.TaoPhanManhNV


--Bài 2
create proc DSNhanVienMuc1
@TenPB nvarchar(50)
as
begin
	if (@TenPB is null)
		print N'Không nhập tên phòng ban'
	else if (not exists (select TenPB from PhongBan where TenPB = @TenPB))
		print N'Không tìm thấy tên PB'
	else
		begin
			select nv.*, pb.TenPB, pb.ChiNhanh
			from NhanVien nv, PhongBan pb
			where nv.MaPB = pb.MaPB and TenPB = @TenPB
		end
end
go

exec DSNhanVienMuc1 N'Thiết kế'
exec DSNhanVienMuc1 N'Kế toán'
exec DSNhanVienMuc1 N'Kỹ thuật'
exec DSNhanVienMuc1 Null


create proc DSNhanVienMuc2
@TenPB nvarchar(50)
as
begin
	if (@TenPB is null)
		print N'Không nhập tên phòng ban'
	else if not exists (select TenPB from PhongBan where TenPB = @TenPB)
		print N'Không tìm thấy tên PB'
	else if exists (select TenPB from PhongBanSG where TenPB = @TenPB)
		begin
			select nv.*, pb.TenPB, pb.ChiNhanh
			from NhanVienSG nv, PhongBanSG pb
			where nv.MaPB = pb.MaPB and TenPB = @TenPB
		end
	else
		begin
			select nv.*, pb.TenPB, pb.ChiNhanh
			from NhanVienHN nv, PhongBanHN pb
			where nv.MaPB = pb.MaPB and TenPB = @TenPB
		end
end
go

use QLNhanVien
go
exec DSNhanVienMuc2 N'Thiết kế'
exec DSNhanVienMuc2 N'Kế toán'
exec DSNhanVienMuc2 N'Kỹ thuật'
exec DSNhanVienMuc2 Null

--Bài 3
use QLNhanVien
go
create proc ThemPhongBanMuc1
@MaPB nvarchar(10)
, @TenPB nvarchar(50)
, @ChiNhanh nvarchar(50)
as
begin
	if (@MaPB is null)
		print N'Không thêm dữ liệu được vì không có dữ liệu mã PB'
	else if (@TenPB is null)
		print N'Không thêm dữ liệu được vì không có dữ liệu tên PB'
	else if (@ChiNhanh is null)
		print N'Không thêm dữ liệu được vì không có dữ liệu chi nhánh PB'
	else if exists (select * from PhongBan where MaPB = @MaPB)
		print N'Không thêm được dữ liệu vì trùng mã PB'
	else if (@ChiNhanh not in (N'Sài gòn', N'Hà nội'))
		print N'Không thêm được phong ban vì chi nhánh không hợp lệ'
	else
		begin
			insert into PhongBan
			values (@MaPB, @TenPB, @ChiNhanh)
			print N'Thêm dữ liệu thành công'
		end	
end
go


exec dbo.ThemPhongBanMuc1 NULL, N'Bảo hành', N'Sài gòn'
exec dbo.ThemPhongBanMuc1 N'PB07', N'Bảo hành',N'Sài gòn'
exec dbo.ThemPhongBanMuc1 N'PB08',N'Tư vấn',N'Hà nội'
exec dbo.ThemPhongBanMuc1 N'PB01',N'Kho vận',N'Hà nội'
exec dbo.ThemPhongBanMuc1 N'PB09',N'Nghiên cứu',N'Cần thơ'



create proc ThemPhongBanMuc2
@MaPB nvarchar(10)
, @TenPB nvarchar(50)
, @ChiNhanh nvarchar(50)
as
begin
	if (@MaPB is null)
		print N'Không thêm dữ liệu được vì không có dữ liệu mã PB'
	else if (@TenPB is null)
		print N'Không thêm dữ liệu được vì không có dữ liệu tên PB'
	else if (@ChiNhanh is null)
		print N'Không thêm dữ liệu được vì không có dữ liệu chi nhánh PB'
	else if exists (select * from PhongBan where MaPB = @MaPB)
		print N'Không thêm được dữ liệu vì trùng mã PB'
	else if (@ChiNhanh not in (N'Sài gòn', N'Hà nội'))
		print N'Không thêm được phong ban vì chi nhánh không hợp lệ'
	else if (@ChiNhanh = N'Sài gòn')
		begin
			insert into PhongBanSG
			values (@MaPB, @TenPB, @ChiNhanh)
			print N'Thêm dữ liệu thành công vào Phân mảnh PhongBanSG'
		end	
	else
		begin
			insert into PhongBanHN
			values (@MaPB, @TenPB, @ChiNhanh)
			print N'Thêm dữ liệu thành công vào phân mảnh PhongBanHN'
		end	
end
go


exec dbo.ThemPhongBanMuc2 NULL, N'Bảo hành', N'Sài gòn'
exec dbo.ThemPhongBanMuc2 N'PB07', N'Bảo hành',N'Sài gòn'
exec dbo.ThemPhongBanMuc2 N'PB08',N'Tư vấn',N'Hà nội'
exec dbo.ThemPhongBanMuc2 N'PB01',N'Kho vận',N'Hà nội'
exec dbo.ThemPhongBanMuc2 N'PB09',N'Nghiên cứu',N'Cần thơ'



--Bài 4
use QLNhanVien
go
create proc SuaPhongBanMuc1
@MaPB nvarchar(10)
, @TenPB nvarchar(50)
, @ChiNhanh nvarchar(50)
as
begin
	if (@MaPB is null)
		print N'Không sửa dữ liệu được vì không có dữ liệu mã PB'
	else if (@ChiNhanh is null)
		print N'Không sửa dữ liệu được vì không có dữ liệu chi nhánh PB'
	else if not exists (select * from PhongBan where MaPB = @MaPB)
		print N'Không sửa dữ liệu được vì không tìm thấy giá trị mã PB'
	else if (@ChiNhanh not in (N'Sài gòn', N'Hà nội'))
		print N'Không sửa được phong ban vì chi nhánh không hợp lệ'
	else
		begin
			update PhongBan
			set TenPB = @TenPB, ChiNhanh = @ChiNhanh
			where maPB = @MaPB
			print N'Sửa dữ liệu thành công'
		end	
end
go

exec dbo.SuaPhongBanMuc1 NULL, N'Thiết kế',N'Sài gòn'
exec dbo.SuaPhongBanMuc1 N'PB01', N'Nghiên cứu', NULL
exec dbo.SuaPhongBanMuc1 N'PB01', N'Nghiên cứu', N'Cần thơ'
exec dbo.SuaPhongBanMuc1 N'PB01',N'Nghiên cứu', N'Sài gòn'
exec dbo.SuaPhongBanMuc1 N'PB02',N'Phát triển',N'Hà nội'
exec dbo.SuaPhongBanMuc1 N'PB06',N'Tài chánh',N'Sài gòn'
exec dbo.SuaPhongBanMuc1 N'PB09',N'Kỹ thuật',N'Sài gòn'


use QLNhanVien
go
create proc SuaPhongBanMuc2
@MaPB nvarchar(10)
, @TenPB nvarchar(50)
, @ChiNhanh nvarchar(50)
as
begin
	if (@MaPB is null)
		print N'Không sửa dữ liệu được vì không có dữ liệu mã PB'
	else if (@ChiNhanh is null)
		print N'Không sửa dữ liệu được vì không có dữ liệu chi nhánh PB'
	else if (@ChiNhanh not in (N'Sài gòn', N'Hà nội'))
		print N'Không sửa được dữ liệu vì giá trị chi nhánh PB không hợp lệ'
	else if exists (select * from PhongBan where MaPB = @MaPB)
		begin
			update PhongBan
			set TenPB = @TenPB, ChiNhanh = @ChiNhanh
			where maPB = @MaPB

			if (@ChiNhanh = N'Sài gòn')
				begin
					insert into NhanVienSG
					select * from NhanVienHN where MaPB = @MaPB
					
					insert into PhongBanSG
					values (@MaPB, @TenPB, @ChiNhanh)

					delete PhongBanHN where MaPB = @MaPB
					delete NhanVienHN where MaPB = @MaPB

					print N'Sửa dữ liệu thành công và dữ liệu đã được chuyển từ chi nhánh HN sang chi nhánh SG'
				end
			else
				begin
					insert into NhanVienHN
					select * from NhanVienSG where MaPB = @MaPB
					
					insert into PhongBanHN
					values (@MaPB, @TenPB, @ChiNhanh)

					delete PhongBanSG where MaPB = @MaPB
					delete NhanVienSG where MaPB = @MaPB

					print N'Sửa dữ liệu thành công và dữ liệu đã được chuyển từ chi nhánh SG sang chi nhánh HN'
				end	
		end	
	else
		print N'Không sửa được dữ liệu vì không tìm thấy giá trị mã phòng ban'
end
go


exec dbo.SuaPhongBanMuc2 NULL, N'Thiết kế',N'Sài gòn'
exec dbo.SuaPhongBanMuc2 N'PB01', N'Nghiên cứu', NULL
exec dbo.SuaPhongBanMuc2 N'PB01', N'Nghiên cứu', N'Cần thơ'
exec dbo.SuaPhongBanMuc2 N'PB01',N'Nghiên cứu', N'Sài gòn'
exec dbo.SuaPhongBanMuc2 N'PB02',N'Phát triển',N'Hà nội'
exec dbo.SuaPhongBanMuc2 N'PB06',N'Tài chánh',N'Sài gòn'
exec dbo.SuaPhongBanMuc2 N'PB09',N'Kỹ thuật',N'Sài gòn'