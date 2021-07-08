----- PHẦN 1: BIẾN VÀ CẤU TRÚC DỮ LIỆU -------

----- Câu 1 -------
DECLARE @NgaySinh DATETIME, @Tuoi INT
SET @NgaySinh = N'2000-1-17'
SET @Tuoi = YEAR(GETDATE()) - YEAR(@NgaySinh)
Print N'Tuổi là ' + cast(@Tuoi as NVARCHAR(10))

----- Câu 2 -------
DECLARE @So1 INT, @So2 INT, @Solonnhat INT
SET @So1 = 4
SET @So2 = 8
IF(@So1 >= @So2)
	SET @Solonnhat = @So1
ELSE
	SET @Solonnhat = @So2
Print N'Số lớn nhất của ' + cast(@So1 as NVARCHAR(10)) + N' và ' + cast(@So2 as NVARCHAR(10)) + N' là ' + cast(@Solonnhat as NVARCHAR(10))

----- Câu 3 -------
DECLARE @n INT, @kq INT, @i INT
SET @n = 10
SET @i = 1
SET @kq = 0
WHILE @i <= @n
BEGIN
	SET @kq = @kq + @i
	SET @i = @i + 1
END
Print N'Tổng từ 1 đến ' + cast(@n as NVARCHAR(10)) + N' là ' + cast(@kq as NVARCHAR(10))

----- Câu 4 -------
DECLARE @n INT, @kq INT, @i INT
SET @n = 10
SET @i = 1
SET @kq = 0
WHILE @i <= @n
BEGIN
	IF(@i % 2 = 0)
	BEGIN
		SET @kq = @kq + @i
		SET @i = @i + 1
	END
	ELSE
		SET @i = @i + 1
END
Print N'Tổng các số chẵn từ 1 đến ' + cast(@n as NVARCHAR(10)) + N' là ' + cast(@kq as NVARCHAR(10))

----- Câu 5 -------
DECLARE @n INT, @kq FLOAT, @i INT
SET @n = 10
SET @i = 1
SET @kq = 0
WHILE @i <= @n
BEGIN
	SET @kq = @kq + (1 / (cast(@i as FLOAT)))
	SET @i = @i + 1
END
Print N'S = ' + cast(@kq as NVARCHAR(10))


----- PHẦN 2: VIEW (KHUNG HÌNH) -------

----- Câu 1 -------
USE Northwind
GO
CREATE VIEW CustomerInfoNotBuying
AS
	SELECT c.*
	FROM Customers c
	WHERE c.CustomerID NOT IN (SELECT c1.CustomerID FROM Customers c1, Orders o
							   WHERE c1.CustomerID = o.CustomerID)
GO

--- Kiểm tra
SELECT * FROM [dbo].[CustomerInfoNotBuying]

----- Câu 2 -------
USE Northwind
GO
CREATE VIEW CustomerInfoBuying
AS
	SELECT c.*
	FROM Customers c, Orders o, Shippers s
	WHERE c.CustomerID = o.CustomerID and o.ShipVia = s.ShipperID and s.CompanyName = N'Speedy Express'
GO

--- Kiểm tra
SELECT * FROM [dbo].[CustomerInfoBuying]

----- Câu 3 -------
USE Northwind
GO
CREATE VIEW ProductInfoNotInStock
AS
	SELECT p.*
	FROM Products p
	WHERE p.UnitsInStock = 0
GO

--- Kiểm tra
SELECT * FROM [dbo].[ProductInfoNotInStock]

----- Câu 4 -------
USE Northwind
GO
CREATE VIEW ProductInfoOfGrains_Cereals
AS
	SELECT p.*, c.CategoryName
	FROM Products p, Categories c
	WHERE p.CategoryID = c.CategoryID and c.CategoryName = N'Grains/Cereals'
GO

--- Kiểm tra
SELECT * FROM [dbo].[ProductInfoOfGrains_Cereals]

----- Câu 5 -------
USE Northwind
GO
CREATE VIEW Top10InvoicesWithHighestValue
AS
	SELECT TOP(10) o.*, p.ProductName, od.Quantity, od.UnitPrice, od.Discount, od.UnitPrice * od.Quantity * (1 - od.Discount) as Total
	FROM (([Order Details] od INNER JOIN Orders o ON od.OrderID = o.OrderID)
							  INNER JOIN Products p ON od.ProductID = p.ProductID)
	ORDER BY od.Discount, od.UnitPrice * od.Quantity * (1 - od.Discount) DESC
GO

--- Kiểm tra
SELECT * FROM [dbo].[Top10InvoicesWithHighestValue]


----- PHẦN 3: VIẾT CÁC STORED PROCEDURE ĐƠN GIẢN (KHÔNG TRUY XUẤT DỮ LIỆU) -------

----- Câu 1 -------
USE master
GO
CREATE PROC TinhTongHaiSo
@a INT, @b INT
AS
BEGIN
	DECLARE @kq INT
	SET @kq = @a + @b
	Print N'Tổng 2 số ' + cast(@a as NVARCHAR(10)) + N' và ' + cast(@b as NVARCHAR(10)) + N' là: ' + cast(@kq as NVARCHAR(10))
END
GO

---- Kiểm tra
EXEC TinhTongHaiSo 5, 7

----- Câu 2 -------
USE master
GO
CREATE PROC sp_TongChanMN
@m INT, @n INT
AS
BEGIN
	DECLARE @TongChan INT, @i INT
	SET @i = @m
	SET @TongChan = 0
	WHILE @i <= @n
	BEGIN
		IF(@i % 2 = 0)
		BEGIN
			SET @TongChan = @TongChan + @i
			SET @i = @i + 1
		END
		ELSE
			SET @i = @i + 1
	END
	Print N'Tổng các số chẵn từ ' + cast(@m as NVARCHAR(10)) + N' đến ' + cast(@n as NVARCHAR(10)) + N' là: ' + cast(@TongChan as NVARCHAR(10))
END
GO
---- Kiểm tra
EXEC sp_TongChanMN 12, 67

----- Câu 3 -------
USE master
GO
CREATE PROC sp_TimUCLN
@a INT, @b INT
AS
BEGIN
	DECLARE @UCLN1 INT, @UCLN2 INT
	SET @UCLN1 = @a
	SET @UCLN2 = @b
	WHILE @UCLN1 != @UCLN2
	BEGIN
		IF(@UCLN1 > @UCLN2)
			SET @UCLN1 = @UCLN1 - @UCLN2
		ELSE
			SET @UCLN2 = @UCLN2 - @UCLN1
	END
	Print N'UCLN(' + cast(@a as NVARCHAR(10)) + N', ' + cast(@b as NVARCHAR(10)) + N') = ' + cast(@UCLN1 as NVARCHAR(10))
END
GO
---- Kiểm tra
EXEC sp_TimUCLN 12, 30


----- PHẦN 4: VIẾT CÁC STORED PROCEDURE (CÓ TRUY XUẤT DỮ LIỆU) -------

----- Câu 4 -------
USE Northwind
GO
CREATE PROC sp_DSSP_GiaNhoHon15
AS
BEGIN
	SELECT *
	FROM Products 
	WHERE UnitPrice < 15
END
GO

---- Kiểm tra
EXEC sp_DSSP_GiaNhoHon15

----- Câu 5 -------
USE Northwind
GO
CREATE PROC sp_CateDoesNotHaveProd
AS
BEGIN
	SELECT *
	FROM Categories c
	WHERE c.CategoryID NOT IN (SELECT c1.CategoryID 
							   FROM Categories c1, Products p
							   WHERE c1.CategoryID = p.CategoryID)
END
GO

---- Kiểm tra
EXEC sp_CateDoesNotHaveProd

----- Câu 6 -------
USE Northwind
GO
CREATE PROC sp_LateDeliveryOrder
AS
BEGIN
	SELECT *
	FROM Orders o
	WHERE DATEDIFF(DAY, o.RequiredDate, o.ShippedDate) > 0
END
GO

---- Kiểm tra
EXEC sp_LateDeliveryOrder

----- Câu 7 -------
USE Northwind
GO
CREATE PROC sp_ProductInfo
@MaSP INT
AS
BEGIN
	SELECT *
	FROM Products
	WHERE ProductID = @MaSP
END
GO

---- Kiểm tra
EXEC sp_ProductInfo 25

----- Câu 8 -------
USE Northwind
GO
CREATE PROC sp_ProductInfo_OfCate
@MaDM INT
AS
BEGIN
	SELECT p.*,c.CategoryID, c.CategoryName
	FROM Products p, Categories c
	WHERE p.CategoryID = c.CategoryID and c.CategoryID = @MaDM
END
GO

---- Kiểm tra
EXEC sp_ProductInfo_OfCate 6

----- Câu 9 -------
USE Northwind
GO
CREATE PROC sp_OrderInfo
@StartDate DATETIME, @EndDate DATETIME
AS
BEGIN
	SELECT *
	FROM Orders
	WHERE OrderDate BETWEEN @StartDate AND @EndDate
END
GO

---- Kiểm tra
EXEC sp_OrderInfo N'1996/7/4', N'1997/11/4'

----- Câu 10 -------
USE Northwind
GO
CREATE PROC sp_QuantityOfProductsInStock
@MaSP INT
AS
BEGIN
	SELECT p.UnitsInStock
	FROM Products p
	WHERE p.ProductID = @MaSP
END
GO

---- Kiểm tra
EXEC sp_QuantityOfProductsInStock 21

----- Câu 11 -------
USE Northwind
GO
CREATE PROC sp_AddProducts
@ID INT, @Name NVARCHAR(40), @SupID INT, @CateID INT, @QPUnit NVARCHAR(20), 
@UnitPrice MONEY,@UnitIS SMALLINT, @UnitOO SMALLINT, @RLevel SMALLINT, @Disc BIT
AS
BEGIN
	BEGIN TRY
		IF EXISTS (SELECT * FROM Products WHERE ProductID = @ID)
			Print N'Mã sản phẩm đã tồn tại'
		ELSE
			BEGIN
				INSERT INTO Products
				VALUES (@Name, @SupID, @CateID, @QPUnit, @UnitPrice, @UnitIS, @UnitOO, @RLevel, @Disc)
				print N'Thêm sản phẩm thành công'
			END
	END TRY
	BEGIN CATCH
		Print N'Lỗi hệ thống'
	END CATCH
END
GO

---- Kiểm tra
EXEC sp_AddProducts 5, N'Nước ngọt', null, null, null, null, null, null, null, 0.15
EXEC sp_AddProducts null, N'Nước ngọt', null, null, null, null, null, null, null, 0.15 

----- Câu 12 -------
USE Northwind
GO
CREATE PROC sp_UnitPriceOfProducts
@MaSP INT
AS
BEGIN
	BEGIN TRY
		IF NOT EXISTS (SELECT * FROM Products WHERE ProductID = @MaSP)
			Print N'Sản phẩm không tồn tại'
		ELSE 
			BEGIN
				SELECT UnitPrice
				FROM Products
				WHERE ProductID = @MaSP
			END
	END TRY
	BEGIN CATCH
		Print N'Lỗi hệ thống'
	END CATCH
END
GO

---- Kiểm tra
EXEC sp_UnitPriceOfProducts 78
EXEC sp_UnitPriceOfProducts 7

----- Câu 13 -------
USE Northwind
GO
CREATE PROC sp_DeleteProductInfo
@MaSP INT
AS
BEGIN
	BEGIN TRY
		IF NOT EXISTS (SELECT * FROM Products WHERE ProductID = @MaSP)
			Print N'Sản phẩm không tồn tại'
		ELSE IF EXISTS (SELECT * FROM [Order Details] od WHERE od.ProductID = @MaSP)
			Print N'Sản phẩm đang bị tham chiếu'
		ELSE 
			BEGIN
				DELETE FROM Products
				WHERE ProductID = @MaSP
				Print N'Xóa sản phẩm thành công'
			END
	END TRY
	BEGIN CATCH
		Print N'Lỗi hệ thống'
	END CATCH
END
GO

---- Kiểm tra
EXEC sp_DeleteProductInfo 78
EXEC sp_DeleteProductInfo 1078
EXEC sp_DeleteProductInfo 7


----- PHẦN 5: VIẾT HÀM (FUNCTION) -------

----- Câu 26 -------
USE master
GO
CREATE FUNCTION fn_CalculateAge
(
	@NamSinh INT
)
RETURNS INT
AS
BEGIN
	DECLARE @Tuoi INT
	SET @Tuoi = YEAR(GETDATE()) - @NamSinh
	RETURN @Tuoi
END
GO

----- Kiểm tra
SELECT dbo.fn_CalculateAge(2000)

----- Câu 27 -------
USE master
GO
CREATE FUNCTION fn_TotalElement(@n INT)
RETURNS INT
AS
BEGIN
	DECLARE @i INT, @j INT, @Tong INT, @sus INT
	SET @i = 2; SET @Tong = 0
	WHILE @i <= @n
	BEGIN
		SET @sus = 0
		SET @j = 1
		WHILE @j <= @i
		BEGIN
			IF (@i % @j = 0)
				SET @sus = @sus + 1
			SET @j = @j + 1
		END
		IF (@sus = 2)
			SET @Tong = @Tong + @i
		SET @i = @i + 1
	END 
	RETURN @Tong	
END
GO

----- Kiểm tra
SELECT dbo.fn_TotalElement(20)

----- Câu 28 -------
USE Northwind
GO
CREATE FUNCTION fn_Customer_Order
(
	@MaKH NCHAR(5)
)
RETURNS TABLE
AS
RETURN
(
	SELECT c.*, o.OrderID, o.OrderDate
	FROM Customers c, Orders o
	WHERE c.CustomerID = o.CustomerID and c.CustomerID = @MaKH
)
GO

----- Kiểm tra
SELECT * FROM dbo.fn_Customer_Order(N'ALFKI')

----- Câu 29 -------
USE Northwind
GO
CREATE FUNCTION fn_OrderInfo
(
	@MaKH NCHAR(5)
)
RETURNS TABLE
AS
RETURN
(
	SELECT c.CustomerID, o.OrderID, Quantity * UnitPrice * (1 - Discount) as Total
	FROM Customers c, Orders o, [Order Details] od
	WHERE c.CustomerID = o.CustomerID and o.OrderID = od.OrderID and c.CustomerID = @MaKH
)
GO
----- Kiểm tra
SELECT * FROM dbo.fn_OrderInfo(N'ALFKI')

----- Câu 30 -------
USE Northwind
GO
CREATE FUNCTION fn_UnitPriceOfProduct
(
	@MaSP INT
)
RETURNS TABLE
AS
RETURN
(
	SELECT UnitPrice
	FROM Products
	WHERE ProductID = @MaSP
)
GO
----- Kiểm tra
SELECT * FROM dbo.fn_UnitPriceOfProduct(10)

----- Câu 31 -------
USE Northwind
GO
CREATE FUNCTION fn_OrderDetailInfo
(
	@MaKH NCHAR(5)
)
RETURNS TABLE
AS
RETURN
(
	SELECT o.OrderID, o.CustomerID, o.EmployeeID, o.OrderDate, o.ShipAddress,
			Quantity * UnitPrice * (1 - Discount) as Total
	FROM Orders o, [Order Details] od
	WHERE o.CustomerID = @MaKH and o.OrderID = od.OrderID
)
GO
----- Kiểm tra
SELECT * FROM dbo.fn_OrderDetailInfo(N'ALFKI')


----- PHẦN 6: CÀI ĐẶT CÁC TRIGGER -------

----- Câu 34 -------
USE Northwind
GO
CREATE TRIGGER tg_CheckOrderDate
ON Orders
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @OrderDate DATETIME
	SELECT @OrderDate = OrderDate FROM inserted
	IF DATEDIFF(DAY, GETDATE(), @OrderDate) > 0
	BEGIN
		Raiserror(N'Ngày đặt hàng không được lớn hơn ngày hiện tại', 16, 1)
		ROLLBACK TRANSACTION
	END
END

---- Kiểm tra
INSERT INTO Orders(OrderDate)
VALUES(N'2021/7/8')
SELECT @@IDENTITY

----- Câu 35 -------
USE Northwind
GO
CREATE TRIGGER tg_CheckOrders 
ON [Order Details]
FOR INSERT, UPDATE
AS 
IF UPDATE(productid)
BEGIN
	IF EXISTS (SELECT * FROM inserted i, Products p 
			   WHERE i.ProductID = p.ProductID and p.UnitsInStock = 0)
	BEGIN
		Raiserror (N'Không thể đặt hàng vì mặt hàng này không còn trong kho!', 16, 1)
		ROLLBACK TRANSACTION
	END
END

---- Kiểm tra
INSERT INTO [Order Details]
VALUES(10248, 5, 21.35, 5, 0.1)
SELECT @@IDENTITY

----- Câu 36 -------
USE Northwind
GO
CREATE TRIGGER tg_CkeckOrderQuantity 
ON [Order Details]
FOR INSERT, UPDATE
AS 
IF UPDATE(quantity)
BEGIN
	IF EXISTS (SELECT * FROM inserted i, Products p 
			   WHERE i.ProductID = p.ProductID and i.Quantity >= p.UnitsInStock)
	BEGIN
		Raiserror (N'Số lượng đặt hàng phải nhỏ hơn số lượng tồn hiện có!', 16, 1)
		ROLLBACK TRANSACTION
	END
END

---- Kiểm tra
INSERT INTO [Order Details]
VALUES(10248, 8, 40.00, 5, 0.1)
SELECT @@IDENTITY