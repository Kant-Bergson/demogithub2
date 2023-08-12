# tạo cột mới ( Month ) 
ALTER TABLE total_sale_2019 ADD COLUMN Month INT;

# trích xuất dữ liệu từ cột Order Date, lấy ra giá trị tháng và gán giá trị tháng vào trong cột Month
UPDATE total_sale_2019 SET Month = MONTH(STR_TO_DATE(`Order Date`, '%m/%d/%y %H:%i'));

# tạo ra cột Sale
ALTER TABLE total_sale_2019 ADD COLUMN Sales INT;

# gán giá trị cho cột Sales bằng giá trị của 2 cột Quantity Ordered và Price Each để tìm ra giá đơn hàng đấy
UPDATE total_sale_2019 SET Sales = `Quantity Ordered` * `Price Each`;



# lấy và tính tổng doanh thu theo từng tháng 
SELECT MONTH(`Order Date`) AS Month, ROUND(SUM(`Quantity Ordered` * `Price Each`), 2) AS Total_Revenue
FROM total_sale_2019
GROUP BY MONTH(`Order Date`)
ORDER BY MONTH(`Order Date`) ASC;


# xóa các dòng trong cột Month có giá trị là Null
DELETE FROM total_sale_2019
WHERE `Month` IS NULL;

# lấy ra và sắp xếp các theo thứ tự các sản phẩm được mua nhiều lần nhất 
SELECT Product, COUNT(*) AS number_order
FROM total_sale_2019
GROUP BY Product
ORDER BY number_order DESC;

SELECT SUBSTRING_INDEX(SUBSTRING_INDEX('Purchase Address', ',', -2), ',', 1) AS City
FROM total_sale_2019;

# lọc ra các tên thành phố từ cột Purchase Address và gán nó váo cột mới City 
SELECT Sales, SUBSTRING_INDEX(SUBSTRING_INDEX(`Purchase Address`, ',', -2), ',', 1) AS City
FROM total_sale_2019;

# chọn cột City và tính tổng sales theo từng thành phố 
select City, sum(Sales) as total_sales_city 
from ( SELECT Sales, SUBSTRING_INDEX(SUBSTRING_INDEX(`Purchase Address`, ',', -2), ',', 1) AS City
FROM total_sale_2019 ) as new_table
group by City;

# lọc giá trị sale theo từng này 
SELECT DAY(STR_TO_DATE(`Order Date`, '%m/%d/%y %H:%i')) AS OrderDay, Sales
FROM total_sale_2019;

# lấy doanh thu trung bình tính theo này của cả năm 2019
select OrderDay, avg(Sales) as avg_sale_day
from (SELECT DAY(STR_TO_DATE(`Order Date`, '%m/%d/%y %H:%i')) AS OrderDay, Sales
FROM total_sale_2019) as new_table
group by OrderDay 
order by OrderDay asc; 

# Khoảng thời gian nào thì khách hàng thường đặt hàng nhất ( tính theo doanh thu ) 
select OrderHour, sum(Sales) as sum_sale_hour 
from(
SELECT DATE_FORMAT(STR_TO_DATE(`Order Date`, '%m/%d/%y %H:%i'), '%H') AS OrderHour, Sales
FROM total_sale_2019) as new_table
group by OrderHour
order by sum_sale_hour desc;