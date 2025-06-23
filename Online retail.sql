Create database project3;
use project3;
select * from `online_retail[1]`;

-- Find the total quantity.
select sum(quantity) as total_units from `online_retail[1]`;

-- Find the total_revenue of online retail shop.
with totalprice as (
select (UnitPrice*Quantity) as total_price from `online_retail[1]`
)
select sum(total_price) as total_revenue
 from totalprice;
 
 -- Add a permanent column of total price
 set SQL_SAFE_UPDATES=0;
 Alter table `online_retail[1]` add TotalPrice decimal(10,2);
 update `online_retail[1]` set TotalPrice=(UnitPrice*Quantity)  ;
 set SQL_SAFE_UPDATES=1;
 
 -- Find out the totalprice per country.
 select country,sum(totalprice) from `online_retail[1]` group by country order by sum(totalprice) desc;
 
 -- Find the top 10 products by quantity.
 select `description`, sum(quantity) from `online_retail[1]` group by description order by sum(quantity) desc limit 10;
 
 -- Find the top customerid who are repeating most of the time.
 select count(customerid),customerid from `online_retail[1]` group by customerid order by count(customerid) desc limit 10;
 
 -- Drop the null values from the dataset.
 select `index` from `online_retail[1]` where customerid is  null;
 
 -- Top 10 customers by revenue.
 select customerID ,sum(TotalPrice) as Totalrevenue from `online_retail[1]` where customerID is not null group by customerid order by Totalrevenue desc limit 10;
 
 -- yearly revenue trend
 select date_format(STR_TO_Date(InvoiceDate,'%m/%d/%Y %H:%i'), '%Y') as year , sum(Totalprice) from `online_retail[1]` group by date_format(STR_TO_Date(InvoiceDate,'%m/%d/%Y %H:%i'), '%Y');
  
  -- Montly revenue trend
   select date_format(STR_TO_Date(InvoiceDate,'%m/%d/%Y %H:%i'), '%M') as month , sum(Totalprice) from `online_retail[1]` group by date_format(STR_TO_Date(InvoiceDate,'%m/%d/%Y %H:%i'), '%M');

-- Most sold products.
select `description`, sum(quantity) as totalquantity from `online_retail[1]` group by description order by totalquantity desc;

-- cancellation rate per country
select country , count(case when invoiceno like 'C%' then 1 end)*100/count(*) as cancellationpercantage from `online_retail[1]` group by country order by cancellationpercantage desc;

-- Top products with high return rate.
with productsales as (
select description, sum(case when invoiceno like 'C%' then quantity else 0 end) as returnedQty,sum(case when invoiceno not like 'C%' then quantity else 0 end) as soldQty from 
`online_retail[1]` group by description
)
select description, round((returnedQty*100)/ nullif(soldQty,0),2) as returnrate from productsales where soldQty>50 order by returnrate desc limit 10;

-- Rank customers by spending within their country 
with customer_sales as (select customerid, country , sum(totalprice) as totalprices from `online_retail[1]` 
where customerid is not null group by customerid, country)
select customerid, country, totalprices,rank() over (partition by country order by totalprices desc) as spendingrank from customer_sales ;

-- Find the customers who purchased only once 
select customerid, count(distinct invoiceno) as numpurchase from `online_retail[1]` group by customerid having numpurchase=1;

-- Most returned products by country.
select country, description, sum(quantity) from `online_retail[1]` where invoiceno like 'C%' group by country, description order by sum(quantity) desc;








