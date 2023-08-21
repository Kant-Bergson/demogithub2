select * from adidas_vs_nike;

ALTER TABLE adidas_vs_nike ADD COLUMN Price_difference int ; -- thêm cột Price_difference vào database
ALTER TABLE adidas_vs_nike drop COLUMN Price_difference;
ALTER TABLE adidas_vs_nike ADD COLUMN Sex text; -- thêm cột Sex vào database
ALTER TABLE adidas_vs_nike_new_1 ADD COLUMN Catetory_Production text; -- thêm cột catetory_production vào database



create temporary table adidas_vs_nike_new_1 -- tạo 1 bảng tạm thời và đặt tên nó là adidas_vs_nike_new_1
( 
Product_Name text ,
Sex text, 
Product_ID text,
Listing_Price int,
Sale_Price int,
Discount int, 
Brand text, 
Catetory_Production text,
Rating double,
Reviews int, 
Sale_difference int ); 



INSERT INTO adidas_vs_nike_new_1 -- ĐƯA DỮ LIỆU CỘT VÀO BẢNG MỚI "adidas_vs_nike_new_1" ĐÃ TẠO 
(Product_Name, Sex, Product_ID, Listing_Price, Sale_Price, 
Discount, Brand, Rating, Reviews, Sale_difference)
SELECT 
Product_Name, Sex, Product_ID, Listing_Price, Sale_Price, 
Discount, Brand, Rating, Reviews, Sale_difference 
FROM adidas_vs_nike;

select newtable.* from ( SELECT Product_Name,
case -- LẤY RA NỘI DUNG TỪ CỐT PRODUCT NẾU LÀ WOMEN THÌ GÌ VÀO CỘT SEX LÀ FEMALE, VÀ NGƯỢC LẠI 
when Product_Name like "M%" then "Male"
when Product_Name like "W%" then "Female"
else "Both"
end as Sex,
case
when Listing_Price > Sale_Price then Listing_Price
when Listing_Price = Sale_Price or Listing_Price < Sale_Price then Sale_Price
end as Listing_Price,
 Sale_Price, 
CASE -- TẠI DỮ LIỆU CỘT PRICE_DIFFERENCE = CỘT Listing_Price - CỘT Sale_Price. NẾU CỘT Listing_Price < Sale_Price THÌ PRICE_DIFFERENCE = 0 
WHEN Listing_Price < Sale_Price THEN 0
else Listing_Price - Sale_Price
END AS Price_Difference, Discount, Brand, Catetory_Production, Rating, Reviews
FROM adidas_vs_nike_new_1 ) as newtable ;




-- LẤY BẢNG DỮ LIỆU HOÀN THIỆN THEO NHU CẦU

select newtable.* from ( SELECT Product_Name,
case -- PHÂN BIỆT GIỚI TÍNH DỰA TRÊN SẢN PHẨM
when Product_Name like "M%" then "Male"
when Product_Name like "W%" then "Female"
else "Both"
end as Sex,
case -- CHỈNH SỬ LẠI lISTING_PRICE ĐẾ TRÁNH NHỮNG GIÁ TRỊ LISTING_PRICE BẰNG 0
when Listing_Price > Sale_Price then Listing_Price
when Listing_Price = Sale_Price or Listing_Price < Sale_Price then Sale_Price
end as Listing_Price,
 Sale_Price, 
CASE -- TẠI DỮ LIỆU CỘT PRICE_DIFFERENCE = CỘT Listing_Price - CỘT Sale_Price. NẾU CỘT Listing_Price < Sale_Price THÌ PRICE_DIFFERENCE = 0 
WHEN Listing_Price < Sale_Price THEN 0
else Listing_Price - Sale_Price
END AS Price_Difference, 
case -- ĐƯA CÁC GIÁ TRỊ TRỞ THÀNH PHẦN TRĂM
when Discount is not null then  CONCAT(Discount, '%')
else null end as Discount, 
case  -- RÚT GỌN TÊN CỦA CÁC BRAND 
when Brand like "Adidas%%" then "ADIDAS"
else "NIKE"
end as Brand,
case -- PHÂN LOẠI CÁC DÒNG SẢN PHẨM CỦA CÁC THƯƠNG HIỆU 
when Brand like "%ORIGINAL%" THEN "ADIDAS ORIGINALS"
WHEN Brand LIKE "%CORE%" THEN "ADIDAS CORE/NEO"
WHEN Brand LIKE "%SPORT%" THEN "ADIDAS SPORT PERFORMANCE"
ELSE "NIKE"
END AS 	Catetory_Production, 
Rating, Reviews
FROM adidas_vs_nike_new_1 ) as newtable; 










