USE ASSIGNMENT;
SET SQL_SAFE_UPDATES=0;

# TABLE BACKUPS
Create Table PRICES as SELECT * from wfp_food_prices_pakistan;
ALTER TABLE commodity RENAME as commodity_backup;
CREATE TABLE commodity as SELECT * from commodity_backup;
# TEXT TO DATE FORMAT
UPDATE prices set date = str_to_date(date, "%m/%Y/%d");
# TEXT TO DATE FORMAT
ALTER TABLE prices MODIFY date date;

# 1--  Select dates and commodities for cities Quetta, Karachi, and Peshawar where price was less than or equal
   -- 50 PKR--

SELECT date, cmname, mktname, price from prices
where price<=50.00 and mktname in ("Quetta","Karachi","Peshawar");

# 2-- Query to check number of observations against each market/city in PK

Select mktname as City, count(mktname) as Observations from prices
group by 1
order by 2 desc;

# 3-- Show number of distinct cities
SELECT Count(DISTINCT mktname) as No_of_Cities from prices;

# 4-- List down/show the names of cities in the table
SELECT DISTINCT mktname as Cities from prices;

# 5-- List down/show the names of commodities in the table
SELECT DISTINCT cmname as commodities from prices;

# 6-- List Average Prices for Wheat flour - Retail in EACH city separately over the entire period.

Select cmname as commodity, mktname as City, round(avg(price),2) as average_prices
from prices
group by 1,2
having cmname="Wheat flour - Retail";

# 7-- Calculate summary stats (avg price, max price) for each city separately for all cities except Karachi
#  -- and sort alphabetically the city names, commodity names where commodity is Wheat
#  -- (does not matter which one) with separate rows for each commodity
Select mktname as City,cmname as commodity, round(avg(price),2) as avg_price, max(price) as max_price
from prices
group by 1,2
having cmname like "%Wheat%" and City <> "KARACHI"
order by 1;

#8 -- Calculate Avg_prices for each city for Wheat Retail and show only those avg_prices which
   -- are less than 30
Select mktname as City,cmname as commodity, round(avg(price),2) as avg_price
from prices
group by 1,2
having cmname like "%Wheat - Retail%" and avg_price<30
order by 1;

#9 -- Prepare a table where you categorize prices based on a logic
   -- (price < 30 is LOW, price > 250 is HIGH, in between are FAIR)
Select
	distinct price,
	CASE
		WHEN price<30 then "LOW"
        WHEN price>250 then "HIGH"
        ELSE "FAIR"
	END AS Price_status
from prices;

#10-- Create a query showing date, cmname, category, city, price, city_category where Logic for city category
-- is: Karachi and Lahore are 'Big City', Multan and Peshawar are 'Medium-sized city', Quetta is 'Small City'

select date, cmname, category, mktname as city, price,
	CASE
		WHEN mktname in ("KARACHI","LAHORE") THEN "Big City"
        WHEN mktname in ("MULTAN","PESHAWAR") THEN "Medium-sized city"
        ELSE "Small City"
	END AS city_category
From prices;
        
#11 -- Create a query to show date, cmname, city, price. Create new column price_fairness through CASE
    -- showing price is fair if less than 100, unfair if more than or equal to 100, if > 300 then 'Speculative' 
 
 select date, cmname, mktname as city, price,
	CASE
		WHEN price<100 THEN "FAIR"
        WHEN price>=100 and price<300 then "UNFAIR"
        ELSE "SPECULATIVE"
	END AS price_fairness
From prices;

#12 -- Join the food prices and commodities table with a left join.
Select * from prices
left join commodity
on prices.cmname=commodity.cmname;


#13 -- Join the food prices and commodities table with an inner join
Select * from prices
inner join commodity
on prices.cmname=commodity.cmname;

SELECT * from COMMODITY;
SELECT * from prices;
