USE lendingclub_analysis;

/*
How do loan purposes differ in bad-loan rates and financial exposure?
*/

WITH loan_purpose_analysis AS 
(
SELECT
      purpose,
      COUNT(*) AS known_loans,
      SUM( CASE WHEN loan_status IN("Fully Paid",  
					  "Does not meet the credit policy. Status:Fully Paid")
				 THEN 1
                 ELSE 0
			END
          ) AS Good_loans,
      SUM( CASE WHEN loan_status IN("Default", "Charged Off", 
					  "Does not meet the credit policy. Status:Charged Off")
					 THEN 1
					 ELSE 0
				END) AS Bad_loans,
		SUM(funded_amnt) AS TotalFundedAmount,
        SUM( CASE WHEN loan_status IN("Default", "Charged Off", 
					  "Does not meet the credit policy. Status:Charged Off")
				 THEN funded_amnt
                 ELSE 0
			END
          ) AS Bad_loan_funded_amount
FROM loan_data
WHERE loan_status IN ("Fully Paid", "Does not meet the credit policy. Status:Fully Paid",
					"Default", "Does not meet the credit policy. Status:Charged Off", "Charged Off")
GROUP BY purpose
)

, purpose_rate_analysis AS
(
SELECT *,
       ROUND((Bad_loans/known_loans)*100, 2) AS bad_loan_rate,
       ROUND((Bad_loan_funded_amount/TotalFundedAmount)* 100, 2) AS bad_exposure_rate
FROM loan_purpose_analysis
)
SELECT * FROM purpose_rate_analysis
ORDER BY bad_exposure_rate DESC; 


