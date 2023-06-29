-- Solution using SQL (Postgresql)


-- First Step is to create the tables country_population, ca_sales, de_sales, fr_sales, and mx_sales. 
-- These tables will be used to store the data from the files provided once imported.

CREATE TABLE country_population
(
    country character varying,
    year character varying,
    population character varying
)

CREATE TABLE ca_sales
(
	productid character varying,
	date character varying,
	zip character varying,
	units character varying,
	revenue character varying,
	country character varying
);

CREATE TABLE de_sales
(
	productid character varying,
	date character varying,
	zip character varying,
	units character varying,
	revenue character varying,
	country character varying
);

CREATE TABLE fr_sales
(
	productid character varying,
	date character varying,
	zip character varying,
	units character varying,
	revenue character varying,
	country character varying
);

CREATE TABLE mx_sales
(
	productid character varying,
	date character varying,
	zip character varying,
	units character varying,
	revenue character varying,
	country character varying
);

-- after creating the tables, the data was imported from the exel/csv files provided.
-- after importing, I modified the columns of the tables to the correct data types.

alter table country_population
	alter column year type integer USING year::integer,
	alter column population type bigint USING population::bigint;
	
alter table ca_sales
	alter column productid type int USING productid::int,
	alter column date type date USING date::date,
	alter column units type int USING units::int,
	alter column revenue type double precision using revenue::double precision;

alter table de_sales
	alter column date type date USING date::date,
	alter column units type int USING units::int,
	alter column revenue type double precision using revenue::double precision;

alter table fr_sales
	alter column date type date USING date::date,
	alter column units type int USING units::int,
	alter column revenue type double precision using revenue::double precision;

alter table mx_sales
	alter column date type date USING date::date,
	alter column units type int USING units::int,
	alter column revenue type double precision using revenue::double precision;


-- after modifying the data type of the columns, I added a year column on the sales data.
-- this column will be used to connect to the country_population table in order to get the population of the country for the specified year.

alter table ca_sales
    add column year int;

alter table de_sales
    add column year int;

alter table fr_sales
    add column year int;

alter table mx_sales
    add column year int;

-- after adding the column, the year column was populated by extracting the year from the date column.

update ca_sales

set year = date_part('year',date);

update de_sales

set year = date_part('year',date);

update fr_sales

set year = date_part('year',date);

update mx_sales

set year = date_part('year',date);

-- I created a table to store the combined sales data from the 4 countries as well as its population for that year.

CREATE TABLE combined_sales
(
	productid int,
	date date,
	zip character varying,
	units int,
	revenue double precision,
	country character varying,
    year int,
    population bigint
);

-- Using the sales data from each country, I combined them together and joined it with the country_population table to get the population for the year
-- I then inserted the result to the combined_sales table. This table is now useful for analysis as it contains all the data that we need.

insert into combined_sales

select
    a.*,
    b.population
from
(
	select * from ca_sales

	union all

	select * from de_sales

	union all

	select * from fr_sales

	union all 

	select * from mx_sales
) a
left join country_population b on a.country = b.country and a.year = b.year;