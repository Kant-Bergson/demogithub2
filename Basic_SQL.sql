# lấy thông tin cơ bản từ kahcsh hàng 
select * from customer; 


# thông tin thành phố và quốc gia ( join của 2 bảng ) 
 select  city.city, city.city_id, country.country, country.country_id , country.last_update
 from city join country on city.country_id = country.country_id; 
    


# lấy dữ liệu từ 2 bảng khác nhau 
 SELECT  
	 customer.store_id, customer.customer_id, customer.first_name , customer.last_name, address_id,
     payment.customer_id,  payment.amount
FROM customer join payment on payment.customer_id = customer.customer_id;
   
   
# lấy dữ liệu từ 3  bảng khác nhau và tính tổng số tiền mà khác hàng đã trả 
SELECT A.* , address.address FROM  address JOIN 
    (SELECT
    c.customer_id, c.first_name, c.last_name, 
    SUM(p.amount) AS total_amount, c.address_id
FROM customer c JOIN payment p ON p.customer_id = c.customer_id
GROUP BY
    c.customer_id, c.first_name, c.last_name ) AS A ON A.address_id = address.address_id ; 
    
    
    
# lấy thông tin đơn hàng của khách hàng gồm tên, địa chỉ , số tiền, SĐT, thành phố , quôc gia 
# từ 5 bảng khác nhau
SELECT Table3.* , country.country 
FROM ( SELECT *  FROM
	( SELECT c.customer_id, c.first_name, c.last_name, c.address_id AS c_address_id,  -- Đặt lại tên cột
             p.payment_id, p.amount
        FROM customer c JOIN payment p ON c.customer_id = p.customer_id 
    ) AS Table1  # đặt là bảng Table1
    JOIN 
    ( SELECT address.address , address.phone, address.postal_code, address.address_id AS a_address_id, -- Đặt lại tên cột
             city.city, city.country_id 
        FROM address JOIN city ON address.city_id = city.city_id
    ) AS Table2   # đặt là bảng Table2 
    ON Table1.c_address_id = Table2.a_address_id
) AS Table3 # Table1 + Table2 
JOIN country ON Table3.country_id = country.country_id;

























    
