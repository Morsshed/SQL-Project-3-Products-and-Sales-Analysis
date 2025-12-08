# SQL-Project-3-Products-and-Sales-Analysis
SQL projects analysing products and sales performance with KPIs, trends, and insights.

## Question-1: show the productwise total sales of 'delivered' items without discount

                    select
                    	  quantity,
                        unit_price,
                        discount,
                        status,
                    	  round(sum(quantity * unit_price),0) total_sales
                    from order_items
                      left join orders 
                      on orders.order_id=order_items.order_id
                      where status = "Delivered"
                    group by 
                    	  quantity,
                        unit_price,
                        discount,
                        status;
  ### Output:    
![Advanced DB SQL1 Screenshot](https://github.com/Morsshed/SQL-Project-3-Products-and-Sales-Analysis/blob/main/Advanced%20DB%20SQL1.png?raw=true)

  ### Description
This query calculates total sales revenue for only delivered items by multiplying quantity × unit_price, excluding discount impact. Orders are joined with order details using order_id, filtered by status "Delivered", and grouped to get aggregated sales output. This helps in understanding actual revenue generated from completed orders.

## Question-2: Please show the total sales of 'delivered' products without discount

                    select
                    	sum(quantity* unit_price) total_sales
                    from order_items
                      left join orders 
                        on orders.order_id=order_items.order_id
                        where status = "Delivered";
 ### Output:
![Advanced DB SQL 2 Screenshot](https://github.com/Morsshed/SQL-Project-3-Products-and-Sales-Analysis/blob/main/QueryImages/Advanced%20DB%20SQL%202.png?raw=true)
 ### Description
This query calculates the total revenue generated from delivered orders by summing quantity × unit_price without considering discounts. It joins orders and order_items tables and filters only "Delivered" status records to return final sales value.

## Question-3: what is the average price of the products?
                      
                      select
                      	round(avg(unit_price),0) as AVG_Price
                      from order_items;
  ### Output:    
![SQL Query Screenshot](https://raw.githubusercontent.com/Morsshed/SQL-Project-3-Products-and-Sales-Analysis/main/QueryImages/SQL3.png)

  ### Description                         
Calculates the average unit price from the order_items table and rounds it to the nearest whole number.

## Question-4: Please show the products with their unit_prices which have exceeded the average price of the products (SUB-QUERY AND JOINS)    

                       SELECT 
                    distinct(product_name) as Product_Name,
                    order_items.unit_price
                FROM
                    products
                    LEFT JOIN order_items
                        ON products.product_id = order_items.product_id
                WHERE
                    order_items.unit_price > (
                        SELECT ROUND(AVG(unit_price), 0)
                        FROM order_items
                    )
                ORDER BY
                    order_items.unit_price DESC;
 ### Output:    
![SQL Query Screenshot](https://raw.githubusercontent.com/Morsshed/SQL-Project-3-Products-and-Sales-Analysis/main/QueryImages/SQL%204.png)

  ### Description  
Retrieves unique products with a unit price higher than the average price across all orders, sorted from highest to lowest.

## Question-5: find employees whose salary is higher than average salary (HR Salary)

  ##### Step-1: Average of Salary

                     select round(avg(salary),0) from employees;

  ##### Step-2: Sub-Query
                     
                     select 
                           *
                     from employees
                         where salary > (select round(avg(salary),0) from employees)
                         order by salary desc;
  ### Output:    
![SQL Query Screenshot](https://raw.githubusercontent.com/Morsshed/SQL-Project-3-Products-and-Sales-Analysis/main/QueryImages/SQL%205.png)
  ### Description  
 Counts how many orders were placed per customer and displays the result sorted by total orders in descending order.
 
 ## Question-6: find the employees whose salary is higher than his/her department's average salary (HR Salary)
 
  ##### step-1: employees and departments table
                                          
                        select * from employees;
                        select * from departments;

  ##### step 2: joins
                                          
                                select 
                                	  employees.employee_id,
                                    employees.department_id,
                                    departments.department_name,
                                    employees.salary
                                    from employees
                                left join departments
                                   ON employees.department_id = departments.department_id
                                ;
                                
##### step 3: departments' average salary
                                
                                select 
                                	  -- employees.employee_id,
                                    -- employees.department_id,
                                    departments.department_name,
                                    round(avg(employees.salary),0) as avg_salary
                                from employees
                                    left join departments
                                         ON employees.department_id = departments.department_id
                                    group by departments.department_name;

##### step-4: Combined Query
                            
                              select 
                              distinct(concat(employees.first_name, " ", employees.last_name)) as Full_name,
                              round(employees.salary) as employee_salary,
                              round(base_table.AVG_salary) as avg_alary,
                              departments.department_name
                              from(
                              select
                              	*,
                              	avg(salary) over (partition by department_id) AVG_salary
                                  from employees) as base_table
                                  left join employees
                                  on employees.department_id=base_table.department_id
                                  left join departments
                                  on departments.department_id=base_table.department_id
                              where AVG_salary > employees.salary;
 ### Output:    
![SQL Query Screenshot](https://raw.githubusercontent.com/Morsshed/SQL-Project-3-Products-and-Sales-Analysis/main/QueryImages/SQL%206.png)
  ### Description  

## Question-7 : find the employees whose salary is higher than his/her department's average salary (Repeated-5) with COMMON TABLE EXPRESSION (CTEs)
                            
                               with CTE1 as(
                              select 
                              	concat(employees.first_name, " ", employees.last_name) as Full_name,
                              	round(employees.salary) as salary,
                              	departments.department_name,
                              	round(avg(salary) over (partition by employees.department_id)) as AVG_salary
                              from employees
                                  left join departments
                                  on employees.department_id= departments.department_id)
                                  
                                  select * from CTE1
                                  where salary > AVG_salary;
                                  
 ### Output:    

  ### Description  
  
## Question- 8: top selling product category in each month

                      select * from products;
                      select * from categories;
                      select * from orders;
                      select * from order_items;
                      
                      with monthly_sales as(
                      select 
                      	  -- products.product_id,
                      	  -- categories.category_id,
                          year(orders.order_date) as order_year,
                          month(orders.order_date) as order_month,
                          categories.category_name,
                      	  sum(quantity) as total_sales
                      from order_items
                          left join products on products.product_id=order_items.product_id
                          left join categories on products.category_id=categories.category_id
                          left join orders on orders.order_id=order_items.order_id
                              group by 
                      		    -- products.product_id,
                              -- categories.category_id,
                      		    order_year,
                      		    order_month,
                      		    categories.category_name
                            order by 
                              order_year,
                      			  order_month),
                         
                         ranking_month as (         
                      	  select 
                                *,
                                rank() over (partition by order_year, order_month order by total_sales desc) as category_rank
                          from Monthly_sales)
                                select * from ranking_month
                              where category_rank = 1;   
                          

## Question-9: Calculate the running total of delivered items (monthly total orders and total sales)
    

                      select
                      	  year(orders.order_date) as order_year,
                          month(orders.order_date) as order_month,
                      	  count(distinct order_items.order_id) as total_orders,
                          round(sum((order_items.unit_price * order_items.quantity) * (1-order_items.discount)),0) as total_sales,
                          sum(round(sum((order_items.unit_price * order_items.quantity) * (1-order_items.discount)),0)) 
                      		  over(
                      			  partition by year(orders.order_date)
                      			  order by     month(orders.order_date)
                      						rows between unbounded preceding and current row) as running_total
                      from order_items
                      	left join orders
                      		on orders.order_id=order_items.order_id
                      where status= "Delivered"
                      group by 
                      	order_year,
                      	order_month
                      order by
                      	order_year,
                      	order_month
                      ;
  ### Output:    

  ### Description  
  
## Question-10: Calculate the running total (3 months moving average)

                    select
                    	  year(orders.order_date) as order_year,
                        month(orders.order_date) as order_month,
                    	  count(distinct order_items.order_id) as total_orders,
                        round(sum((order_items.unit_price * order_items.quantity) * (1-order_items.discount)),0) as total_sales,
                        avg(round(sum((order_items.unit_price * order_items.quantity) * (1-order_items.discount)),0)) 
                    		  over(
                    			  -- partition by year(orders.order_date)
                    			     order by     month(orders.order_date), year(orders.order_date)
                    						   rows between 2 preceding and current row) as 3Months_moving_average
                    from order_items
                    	left join orders
                    		on orders.order_id=order_items.order_id
                    where status= "Delivered"
                    group by 
                    	order_year,
                    	order_month
                    order by
                    	order_year,
                    	order_month
                    ;
 ### Output:    


  ### Description  
  
## Question-11: compare before vs after total orders, total sales and 3 months moving average and where cutoff date is '2023-01-01'
                    
                    select 
                    	  categories.category_name,
                    	  products.product_id,
                        products.product_name,
                    	  -- sum(quantity) as total_quantity,
                        round(sum((order_items.unit_price * order_items.quantity) * (1-order_items.discount)),0) as total_sales,
                        round(sum(case
                    		           when orders.order_date < '2023-01-01' then ((order_items.unit_price * order_items.quantity) * (1-order_items.discount))
                                   else 0
                                   end ),0) as sales_before_cutoff_date,
                    	 round(sum(case
                    		          when orders.order_date >= '2023-01-01' then ((order_items.unit_price * order_items.quantity) * (1-order_items.discount))
                                  else 0
                                  end ),0) as sales_after_cutoff_date,
                            
                    	 count(distinct(case
                    		         when orders.order_date < '2023-01-01' then orders.order_id
                                 else null
                                 end )) as Total_orders_before_cutoff_date,
                                 
                    	 count(distinct(case
                    		        when orders.order_date >= '2023-01-01' then orders.order_id
                                else null
                                end )) as Total_orders_after_cutoff_date   
                        from order_items
                              left join products on products.product_id=order_items.product_id
                              left join categories on products.category_id=categories.category_id
                              left join orders on orders.order_id=order_items.order_id
                          group by 
                    			    categories.category_name,
                    			    products.product_id,
                    			    products.product_name
                          order by 
                            		categories.category_name,
                    				    products.product_id,
                    				    products.product_name;
                
 ### Output:    

  ### Description  
  
## Question-12: Running total with percentage of total sales
                    
                    select
                    	  year(orders.order_date) as order_year,
                        month(orders.order_date) as order_month,
                    	  count(distinct order_items.order_id) as total_orders,
                        round(sum((order_items.unit_price * order_items.quantity) * (1-order_items.discount)),0) as total_sales,
                        sum(round(sum((order_items.unit_price * order_items.quantity) * (1-order_items.discount)),0)) 
                    		    over(
                    			      partition by year(orders.order_date)
                    			      order by     month(orders.order_date)
                    						    rows between unbounded preceding and current row) as running_total,
                                            
                      sum(sum((order_items.unit_price * order_items.quantity) * (1-order_items.discount))) 
                            over(partition by year(orders.order_date)) as annual_total,
                        
                      round((sum(round(sum((order_items.unit_price * order_items.quantity) * (1-order_items.discount)),0)) 
                    		    over(
                    			      partition by year(orders.order_date)
                    			      order by     month(orders.order_date)
                    						    rows between unbounded preceding and current row)) /
                                            (sum(sum((order_items.unit_price * order_items.quantity) * (1-order_items.discount))) 
                    							over(partition by year(orders.order_date))) * 100,2) as percentage_of_total
                    from order_items
                    	    left join orders
                    		        on orders.order_id=order_items.order_id
                    -- where status= "Delivered"
                    group by 
                    	    year(orders.order_date),
                    	    month(orders.order_date)
                    order by
                    	    year(orders.order_date)
                    	    -- order_month
                    ;
 ### Output:    

  ### Description  
  
## Question-13: Compare actual sales against targets with running total
                     
                    SELECT 
                        st.target_year AS year,
                        st.target_month AS month,
                        r.region_name,
                        st.target_amount,
                        COALESCE(actual_sales.monthly_sales, 0) AS actual_sales,
                        SUM(st.target_amount) OVER (
                            PARTITION BY st.region_id, st.target_year
                            ORDER BY st.target_month
                            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
                        ) AS cumulative_target,
                        SUM(COALESCE(actual_sales.monthly_sales, 0)) OVER (
                            PARTITION BY st.region_id, st.target_year
                            ORDER BY st.target_month
                            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
                        ) AS cumulative_actual,
                        SUM(COALESCE(actual_sales.monthly_sales, 0)) OVER (
                            PARTITION BY st.region_id, st.target_year
                            ORDER BY st.target_month
                            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
                        ) - 
                        SUM(st.target_amount) OVER (
                            PARTITION BY st.region_id, st.target_year
                            ORDER BY st.target_month
                            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
                        ) AS cumulative_variance
                    FROM 
                        sales_targets st
                    JOIN 
                        regions r ON st.region_id = r.region_id
                    LEFT JOIN (
                        SELECT 
                            c.region_id,
                            YEAR(o.order_date) AS sales_year,
                            MONTH(o.order_date) AS sales_month,
                            SUM(oi.unit_price * oi.quantity * (1 - oi.discount)) AS monthly_sales
                        FROM 
                            orders o
                        JOIN 
                            customers c ON o.customer_id = c.customer_id
                        JOIN 
                            order_items oi ON o.order_id = oi.order_id
                        WHERE 
                            o.status = 'Delivered'
                        GROUP BY 
                            c.region_id, YEAR(o.order_date), MONTH(o.order_date)
                    	ORDER BY c.region_id, YEAR(o.order_date), MONTH(o.order_date)
                    ) AS actual_sales ON st.region_id = actual_sales.region_id 
                                      AND st.target_year = actual_sales.sales_year 
                                      AND st.target_month = actual_sales.sales_month
                    WHERE 
                        st.target_year = 2023 
                    	-- AND st.region_id = 1
                    ORDER BY 
                    	r.region_name,
                        year, 
                        month;
 ### Output:    

  ### Description
  
## Question-14: Month over Month (Mom) growth rate in sales

                    SELECT 
                        YEAR(o.order_date) AS year,
                        MONTH(o.order_date) AS month,
                        SUM(oi.unit_price * oi.quantity * (1 - oi.discount)) AS monthly_sales,
                        LAG(SUM(oi.unit_price * oi.quantity * (1 - oi.discount))) OVER (
                            ORDER BY YEAR(o.order_date), MONTH(o.order_date)
                        ) AS previous_month_sales,
                        SUM(oi.unit_price * oi.quantity * (1 - oi.discount)) - 
                        LAG(SUM(oi.unit_price * oi.quantity * (1 - oi.discount))) OVER (
                            ORDER BY YEAR(o.order_date), MONTH(o.order_date)
                        ) AS sales_change,
                        CASE 
                            WHEN LAG(SUM(oi.unit_price * oi.quantity * (1 - oi.discount))) OVER (
                                ORDER BY YEAR(o.order_date), MONTH(o.order_date)
                            ) = 0 THEN NULL
                            ELSE ROUND(
                                (SUM(oi.unit_price * oi.quantity * (1 - oi.discount)) - 
                                 LAG(SUM(oi.unit_price * oi.quantity * (1 - oi.discount))) OVER (
                                    ORDER BY YEAR(o.order_date), MONTH(o.order_date)
                                 )) / 
                                LAG(SUM(oi.unit_price * oi.quantity * (1 - oi.discount))) OVER (
                                    ORDER BY YEAR(o.order_date), MONTH(o.order_date)
                                ) * 100,
                                2
                            )
                        END AS growth_rate_percent
                    FROM 
                        orders o
                    JOIN 
                        order_items oi ON o.order_id = oi.order_id
                    WHERE 
                        o.status = 'Delivered'
                    GROUP BY 
                        YEAR(o.order_date), MONTH(o.order_date)
                    ORDER BY 
                        year, month;
                        
 ### Output:    

  ### Description    

## Question-15: Ranking Functions

                    SELECT 
                        p.product_id,
                        p.product_name,
                        c.category_name,
                        p.unit_price,
                        ROW_NUMBER() OVER(PARTITION BY p.category_id ORDER BY p.unit_price DESC) AS row_num,
                        RANK() OVER(PARTITION BY p.category_id ORDER BY p.unit_price DESC) AS price_rank,
                        DENSE_RANK() OVER(PARTITION BY p.category_id ORDER BY p.unit_price DESC) AS dense_ranks
                    FROM 
                        products p
                    JOIN 
                        categories c ON p.category_id = c.category_id
                    ORDER BY 
                        c.category_name, p.unit_price DESC;
                        
 ### Output:    

  ### Description
  
## Question-16: Customer Segmentation

                                                SELECT 
                                                    c.customer_id,
                                                    c.company_name,
                                                    SUM(oi.unit_price * oi.quantity * (1 - oi.discount)) AS total_spent,
                                                    NTILE(4) OVER(ORDER BY SUM(oi.unit_price * oi.quantity * (1 - oi.discount)) DESC) AS spending_quartile
                                                FROM 
                                                    customers c
                                                JOIN 
                                                    orders o ON c.customer_id = o.customer_id
                                                JOIN 
                                                    order_items oi ON o.order_id = oi.order_id
                                                GROUP BY 
                                                    c.customer_id, c.company_name
                                                ORDER BY 
                                                    total_spent DESC;

 ### Output:    

  ### Description
  
