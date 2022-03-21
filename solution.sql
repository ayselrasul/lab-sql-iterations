-- Lab | SQL Iterations

-- In this lab, we will continue working on the Sakila database of movie rentals

-- Instructions
-- Write queries to answer the following questions:
  
   use sakila;
   
-- Write a query to find what is the total business done by each store

  select i.store_id,sum(amount) as total_business
  from inventory i
  join rental r using(inventory_id)
  join payment p using (rental_id)
  group by i.store_id;


-- Convert the previous query into a stored procedure

  drop procedure if exists total_business_by_store;
  
  delimiter $$
  create procedure total_business_by_store()
  Begin
  select i.store_id,sum(amount) as total_business
  from inventory i
  join rental r using(inventory_id)
  join payment p using (rental_id)
  group by i.store_id;
  end;
  $$
  delimiter ;
 
  

-- Convert the previous query into a stored procedure that takes the input for store_id and displays the total sales for that store
  
  drop procedure if exists total_business_by_store;
  
  delimiter $$
  create procedure total_business_by_store(IN p_store_id int)
  Begin
  select sum(amount) 
  from inventory i
  join rental r using(inventory_id)
  join payment p using (rental_id)
  where i.store_id = p_store_id ;
  end;
  $$
  delimiter ;

Call total_business_by_store (1);
Call total_business_by_store (2);

-- Update the previous query. Declare a variable total_sales_value of float type, that will store the returned result (of the total 
-- sales amount for the store). Call the stored procedure and print the results

  drop procedure if exists total_business_by_store;

  delimiter $$
  create procedure total_business_by_store(IN p_store_id int,OUT total_sales float)
  Begin
  select sum(amount) into total_sales
  from inventory i
  join rental r using(inventory_id)
  join payment p using (rental_id)
  where i.store_id = p_store_id ;
  end;
  $$
  delimiter ;
  
Call total_business_by_store (1,@x);
select @x;


-- In the previous query, add another variable flag. If the total sales value for the store is over 30.000, then label it as green_flag,
-- otherwise label is as red_flag. Update the stored procedure that takes an input as the store_id and returns total sales value for
-- that store and flag value

  drop procedure if exists total_business_by_store;

  delimiter $$
  create procedure total_business_by_store(IN p_store_id int,OUT total_sales float,
										  out p_label varchar(30))
  Begin
  select sum(amount) into total_sales
  from inventory i
  join rental r using(inventory_id)
  join payment p using (rental_id)
  where i.store_id = p_store_id;
  
  if total_sales > 30000 then
	  set p_label = 'Green flag';
  else
	  set p_label = 'Red flag';
  end if;
  end;
  $$
  delimiter ;
  
Call total_business_by_store (1,@x,@y);
select @x,@y;
 
Call total_business_by_store (2,@x,@y);
select @x,@y;
  