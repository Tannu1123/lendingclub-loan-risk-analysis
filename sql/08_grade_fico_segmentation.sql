USE lendingclub_analysis;

/*
QUESTION 8 
Which combinations of borrower and loan characteristics are associated with 
both high bad-loan rates and meaningful financial exposure?
*/
WITH loan_analysis AS
(
SELECT grade,
       loan_status,
       funded_amnt,
       fico_range_low,
       fico_range_high,
       ((fico_range_low + fico_range_high) /2 ) AS fico_score
FROM loan_data
WHERE loan_status IN ("Fully Paid", "Does not meet the credit policy. Status:Fully Paid",
					"Default", "Does not meet the credit policy. Status:Charged Off", "Charged Off")
)
, fico_score_bands AS
(
SELECT  *,
       (CASE WHEN fico_score < 660 THEN 'Below 660'
            WHEN fico_score < 700 THEN '660-699'
            WHEN fico_score < 740 THEN '700-739'
            WHEN fico_score < 780 THEN '740-779'
            ELSE '780+'
	  END) AS fico_band
FROM loan_analysis
)

, fico_and_grade_analysis AS
(
SELECT grade,
       fico_band,
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
		SUM(funded_amnt) AS Total_Funded_Amount,
        SUM( CASE WHEN loan_status IN("Default", "Charged Off", 
					  "Does not meet the credit policy. Status:Charged Off")
				 THEN funded_amnt
                 ELSE 0
			END
          ) AS Bad_loan_funded_amount
FROM fico_score_bands
GROUP BY grade, fico_band
)

, rate_analysis AS
(
SELECT *,
       ROUND((Bad_loans / known_loans)* 100, 2) AS bad_loan_rate,
       ROUND((Bad_loan_funded_amount / Total_Funded_Amount)* 100, 2) AS bad_exposure_rate
FROM fico_and_grade_analysis
)

SELECT *
FROM rate_analysis
WHERE bad_loan_rate > 19.98
AND known_loans >= 10000
ORDER BY Bad_loan_funded_amount DESC;
       
