-- lấy thông tin cần thiết từ 3 bảng khác nhau customer, address và city
select customer_id, store_id, first_name, last_name,  address, district, city, phone
from customer 
join address 
join city on address.city_id = city.city_id;

-- Lấy ra danh sách city từ 3 bảng kết hợp với nhau và groupby danh sách với nhau
SELECT city
FROM customer
JOIN address ON customer.address_id = address.address_id
JOIN city ON address.city_id = city.city_id
GROUP BY city order by city asc;


-- nhóm số lượng city
select city from city group by city; 


-- đếm số lượng country trong bảng county
select count(country) from country;


-- lấy ra các dữ liệu cần thiết từ 2 bảng giao nhau
select amount from (
select customer.customer_id, first_name, last_name, payment_id, staff_id, rental_id, amount, payment_date 
from customer 
join payment on customer.customer_id = payment.customer_id) as New_table  
group by amount 
order by amount asc; 


-- lấy tất cả dữ liệu từ bảng rental và giao với bảng ppayment, sắp xếp theo thứ tự cột 3 và 4  
select * from rental 
join payment on rental.rental_id = payment.rental_id order by 3,4 ;











