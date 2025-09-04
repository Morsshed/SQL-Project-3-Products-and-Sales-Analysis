SELECT * FROM sales_data.sales_data;
SELECT * FROM SALES_DATA;

-- Customer Analysis
-- Question-1: 

SELECT  max(str_to_date(orderdate, '%d/%m/%y')) FROM SALES_DATA;  -- '2020-12-17' {Last Business Day}
SELECT  min(str_to_date(orderdate, '%d/%m/%y')) FROM SALES_DATA;  -- '2020-01-02'

SELECT 
	CUSTOMERNAME,
    ROUND(SUM(SALES),0) AS CLV,
    count( DISTINCT ORDERNUMBER) AS FREQUENCY,
    SUM(QUANTITYORDERED) AS TOTAL_QANITITY,
    max(str_to_date(orderdate, '%d/%m/%y')) as customer_last_transaction_date,
    datediff((SELECT  max(str_to_date(orderdate, '%d/%m/%y')) FROM SALES_DATA), max(str_to_date(orderdate, '%d/%m/%y'))) as recency
FROM sales_data
GROUP BY CUSTOMERNAME;

-- RFM Segmentation
-- Question-2: (i MADE 3 CTEs in the name of CLV, RFM_SCORE, RFM COMBINATION) ( THEN I CREATED VIEW)

CREATE VIEW RFM_ANALYSIS AS
WITH CLV AS(
SELECT 
	CUSTOMERNAME,
    max(str_to_date(orderdate, '%d/%m/%y')) as customer_last_transaction_date,
    datediff((SELECT  max(str_to_date(orderdate, '%d/%m/%y')) FROM SALES_DATA), max(str_to_date(orderdate, '%d/%m/%y'))) as Recency,
    count( DISTINCT ORDERNUMBER) AS Frequency,
	ROUND(SUM(SALES),0) AS Monetary,
    SUM(QUANTITYORDERED) AS TOTAL_QANITITY
    
FROM sales_data
GROUP BY CUSTOMERNAME),


RFM_Score as(
SELECT 
*,
NTILE(5) OVER (ORDER BY Recency 	desc) 	as R_Score,
NTILE(5) OVER (ORDER BY Frequency 	    ) 	as F_Score,
NTILE(5) OVER (ORDER BY Monetary 	    ) 	as M_Score
    
FROM CLV),

RFM_COMBINATION AS(

select 
*,
concat_ws('',R_SCORE,F_SCORE,M_SCORE ) AS RFM_COMBINATION

from RFM_SCORE)

SELECT 
	*,
     CASE
		WHEN RFM_COMBINATION IN (455, 515, 542, 544, 552, 553, 452, 545, 554, 555) THEN "Champions"
        WHEN RFM_COMBINATION IN (344, 345, 353, 354, 355, 443, 451, 342, 351, 352, 441, 442, 444, 445, 453, 454, 541, 543, 515, 551) THEN 'Loyal Customers'
        WHEN RFM_COMBINATION IN (513, 413, 511, 411, 512, 341, 412, 343, 514) THEN 'Potential Loyalists'
        WHEN RFM_COMBINATION IN (414, 415, 214, 211, 212, 213, 241, 251, 312, 314, 311, 313, 315, 243, 245, 252, 253, 255, 242, 244, 254) THEN 'Promising Customers'
        WHEN RFM_COMBINATION IN (141, 142,143,144,151,152,155,145,153,154,215) THEN 'Needs Attention'
        WHEN RFM_COMBINATION IN (113, 111, 112, 114, 115) THEN 'About to Sleep'
        ELSE "Other"
        END AS CUSTOMER_SEGMENT
FROM RFM_COMBINATION;

SELECT * FROM RFM_ANALYSIS;
explain
SELECT 
	CUSTOMER_SEGMENT,
	SUM(MONETARY) AS TOTAL_SPENDING,
	ROUND(AVG(MONETARY),0) AS AVERAGE_SPENDING,
    SUM(FREQUENCY) AS TOTAL_ORDER
    -- SUM(TOTAL_QUANTITY) AS TOTAL_QTY_ORDERED
FROM 
rfm_analysis
GROUP BY CUSTOMER_SEGMENT;

-- ----------------
-- Stored Procedure


-- stored procedure is not possible directly from view!


DROP PROCEDURE IF EXISTS customer_analysis;
DROP PROCEDURE IF EXISTS customer_analytics;
DROP PROCEDURE IF EXISTS customer_analytik;
DROP PROCEDURE IF EXISTS customer_ank;
DROP PROCEDURE IF EXISTS customer_lv;

delimiter $$
create procedure Customer_LV( in customername varchar(50), out CLV int)
begin
		SELECT 
			ROUND(SUM(SALES),0) into CLV
		FROM sales_data
		where CUSTOMERNAME = 'Cruz & Sons Co.';
end $$
delimiter ;

call Customer_LV ('Cruz & Sons Co.', @CLV);
select @CLV;

-- 

-- Trigger (sajib)

SELECT
	Customername,
	max(str_to_date(orderdate, '%d/%m/%y')) as last_purchase_date
FROM SALES_DATA
	group by customername;



