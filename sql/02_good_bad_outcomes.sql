USE lendingclub_analysis;

/*
What is the overall bad-loan/default rate among loans with known outcomes?
*/
SELECT Good_loan_count,
       Bad_loan_count,
       ((Bad_loan_count / known_outcome_count) * 100) AS default_rate
FROM (
	SELECT COUNT(*) AS known_outcome_count,
			   SUM(
				  CASE 
					 WHEN loan_status = "Fully Paid" THEN 1
					 WHEN loan_status = "Does not meet the credit policy. Status:Fully Paid" THEN 1
					 ELSE 0
				  END) AS Good_loan_Count,
				  SUM(
				  CASE 
					 WHEN loan_status = "Default" THEN 1
					 WHEN loan_status = "Charged Off" THEN 1
					 WHEN loan_status = "Does not meet the credit policy. Status:Charged Off" THEN 1
					 ELSE 0
				  END) AS Bad_loan_Count
	FROM loan_data
	WHERE loan_status IN("Fully Paid", "Does not meet the credit policy. Status:Fully Paid",
						  "Default", "Does not meet the credit policy. Status:Charged Off", "Charged Off")
	) L;