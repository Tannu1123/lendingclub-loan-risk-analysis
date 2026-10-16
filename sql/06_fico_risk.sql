USE lendingclub_analysis;

/*
How does borrower credit score relate to bad-loan rates? 
*/

WITH fico_scores AS
(
SELECT id,
       loan_status,
       fico_range_low,
       fico_range_high,
      ((fico_range_low + fico_range_high) / 2) AS fico_score
FROM loan_data
WHERE loan_status IN ("Fully Paid", "Does not meet the credit policy. Status:Fully Paid",
						"Default", "Does not meet the credit policy. Status:Charged Off", "Charged Off")
)
, fico_bands AS
(
SELECT *,
       (CASE WHEN fico_score < 660 THEN 'Below 660'
            WHEN fico_score < 700 THEN '660-699'
            WHEN fico_score < 740 THEN '700-739'
            WHEN fico_score < 780 THEN '740-779'
            WHEN fico_score >= 780 THEN '780+'
		END) AS fico_band
FROM fico_scores
) 
, fico_analysis AS
(
SELECT fico_band,
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
			END
          ) AS Bad_loans
FROM fico_bands
GROUP BY fico_band
)
SELECT *,
       ROUND((Bad_loans / known_loans)* 100, 2) AS bad_loan_rate
FROM fico_analysis;

