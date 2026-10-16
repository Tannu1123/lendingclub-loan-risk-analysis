USE lendingclub_analysis;

/* 
How are loans distributed across different loan statuses?
*/
SELECT loan_status,
       loan_count,
       ROUND((loan_count/total_loan_count) * 100, 2) AS percentage
FROM (
	SELECT loan_status,
		   COUNT(*) AS loan_count,
		   SUM(COUNT(*)) OVER() AS total_loan_count
	FROM loan_data
	GROUP BY loan_status)
L ; 
