USE lendingclub_analysis;

/*
How does the bad-loan rate vary across credit grades?
*/

SELECT grade,
       known_outcome_loans,
       Good_loan_count,
       Bad_loan_count,
       ROUND((Bad_loan_count / known_outcome_loans) * 100, 2) AS default_rate
FROM(
	SELECT grade,
		   COUNT(*) AS known_outcome_loans,
		   SUM(
			   CASE WHEN loan_status IN ("Fully Paid", 
						 "Does not meet the credit policy. Status:Fully Paid")
				   THEN 1
				   ELSE 0
				END
		   ) AS Good_loan_count,
		   SUM(
			   CASE WHEN loan_status IN ("Default", "Charged Off",
						 "Does not meet the credit policy. Status:Charged Off")
				   THEN 1
				   ELSE 0
				END
		   ) AS Bad_loan_count       
	FROM loan_data
	WHERE loan_status IN ("Fully Paid", "Does not meet the credit policy. Status:Fully Paid",
					"Default", "Does not meet the credit policy. Status:Charged Off", "Charged Off")
	GROUP BY grade)
l; 