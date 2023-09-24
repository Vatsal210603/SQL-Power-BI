select * from wines;

select count(*) as Wine_count from wines;

select round(sum(Returns),2) as net_return from wines;

select round(sum(Revenue),2) as net_revenue from wines;

select round(sum(Freight_expense),2) as net_frieght_expense from wines;

select round(avg(Margin),2) as avg_margin from wines;

select Segment, count(*) from wines 
group by Segment;

select Freight_Mode, count(*) from wines 
group by Freight_Mode;

select Priority,(count(Priority)/(select count(Priority) from wines)*100) as pct_priority, round(avg(Unit_Price),2) as Average_Price  from wines 
group by Priority;

select distinct Date_of_order ,sum(Revenue) over (partition by Date_of_order) as net_revenue ,sum(Returns) over(partition by Date_of_order) as net_returns from wines
where Date_of_order > '2012-12-31';

select distinct Wine, Segment,Sub_Segment, Unit_Price, Order_quantity, Discount,Margin from wines
where Margin > (select avg(Margin) from wines)
 and Order_quantity > (select avg(Order_quantity) from wines) 
 and Unit_Price > (select avg(Unit_Price) from wines)
order by Unit_Price desc;


select distinct City as CITY,sum(Returns) as net_return from wines 
group by CITY
order by net_return desc;


select distinct Segment as Variety,City,round(sum(Revenue),2) as net_revenue from wines 
group by Variety,City
order by net_revenue desc;


select city,
   sum(case when Delivery_Days <=1 then 1 else 0 end) as "Very Fast Delivery",
   sum(case when Delivery_Days <=3 then 1 else 0 end) as "Fast Delivery",
   sum(case when Delivery_Days <=5 then 1 else 0 end) as "Normal Delivery",
   sum(case when Delivery_Days >=6 then 1 else 0 end) as "Slow  Delivery"
from wines group by City;


update wines
set Date_of_order = str_to_date(Date_of_order,'%d-%m-%Y');
select distinct month(Date_of_order) as Month_no, monthname(Date_of_order) as Order_Month, year(Date_of_order) as order_Year,
count(*) over(partition by monthname(Date_of_order),year(Date_of_order)) as Total_sale from wines
order by Month_no;

















