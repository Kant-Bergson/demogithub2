# Truy vấn nâng cao


# dựng lên môt bảng tạm thời product_summary để tính toán đơn hàng, trả hàng dự vào số liệu bảng sale_2016
With product_summary (ProductKey, TerritoryKey, order_number, return_number, return_qty) 
as
(
select 
	order_groupby.*,
	r.return_number,
	case  when r.return_number > 0 then r.return_number else 0 end as return_qty # những giá trị null được thay bằng 0 
from (	
	select sale.ProductKey, sale.TerritoryKey, SUM(sale.OrderQuantity) as order_number # lấy số lượng đơn hàng theo ProductKey
	from 
    ( select * from sale_16 union select * from sale_17) as sale group by sale.ProductKey, sale.TerritoryKey ) 
    as order_groupby
left join 
	( select re.ProductKey, re.TerritoryKey, SUM(re.ReturnQuantity) as return_number # lấy số lượng hàng hoàn thê ProductKey 
	from 
	return_table re group by re.ProductKey, re.TerritoryKey ) 
    as r on order_groupby.ProductKey = r.ProductKey and order_groupby.TerritoryKey = r.TerritoryKey
)

select ps.ProductKey, ps.order_number, ps.return_qty,  
		(return_qty/order_number)*100 as return_rate, # tỉ lệ hàng hoàn 
		p.ProductSKU, p.ProductName, p.ModelName, p.ProductCost, p.ProductPrice
	from product_summary ps
	left join product p
		on ps.ProductKey = p.ProductKey
	order by 4 desc;
    
    
    
    
-- CREATE TEMP TABLE
Drop table if exists #Tổng_hợp_đặt_trả_của_sản_phẩm
Create Table Summary_order_return_of_product
(product_key numeric, # numeric lưu trữ giá trị số 
terri_key numeric,
order_qty numeric,
return_number numeric,
return_qty numeric
)
insert into #Tổng_hợp_đặt_trả_của_sản_phẩm
select 
	order_groupby.*,
	r.return_number,
	case  when r.return_number > 0 then r.return_number else 0 end as return_qty # thay thế Null bằng 0
from (	
	select sale.ProductKey, sale.TerritoryKey, SUM(sale.OrderQuantity) as order_number # lấy số lượng đơn hang theo Produckey
	from (
		select * from sale_16
		union
		select * from sale_17) as sale
	group by sale.ProductKey, sale.TerritoryKey
	) as order_groupby
left join (
			select re.ProductKey, re.TerritoryKey, SUM(re.ReturnQuantity) as return_number -#Tổng_hợp_đặt_trả_của_sản_phẩmS
			from return_table re
			group by re.ProductKey, re.TerritoryKey ) as r
		on order_groupby.ProductKey = r.ProductKey
		and order_groupby.TerritoryKey = r.TerritoryKey
select * from Summary_order_return_of_product