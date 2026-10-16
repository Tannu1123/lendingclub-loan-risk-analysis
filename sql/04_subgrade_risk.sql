USE lendingclub_analysis;

/*
Which loan sub-grades show elevated bad-loan rates with meaningful loan volume? 
*/


SELECT grade,
       sub_grade,
       known_outcome_count,
       Good_loan_count,
       Bad_loan_count,
       Default_rate_by_SubGrade
FROM (
SELECT grade,
       sub_grade,
       known_outcome_count,
       Good_loan_count,
       Bad_loan_count,
       ROUND((Bad_loan_count / known_outcome_count) * 100, 2) AS Default_rate_by_SubGrade
FROM(
	SELECT grade,
		   sub_grade,
		   COUNT(*) AS known_outcome_count,
		   SUM( CASE WHEN loan_status IN("Fully Paid", 
					  "Does not meet the credit policy. Status:Fully Paid")
					 THEN 1
					 ELSE 0
				END) AS Good_loan_count,
			SUM( CASE WHEN loan_status IN("Default", "Charged Off", 
					  "Does not meet the credit policy. Status:Charged Off")
					 THEN 1
					 ELSE 0
				END) AS Bad_loan_count
	FROM loan_data
	WHERE loan_status IN ("Fully Paid", "Does not meet the credit policy. Status:Fully Paid",
						"Default", "Does not meet the credit policy. Status:Charged Off", "Charged Off")
	GROUP BY grade, sub_grade
) l ) LS
WHERE known_outcome_count > 10000
AND Default_rate_by_SubGrade > 19.98
ORDER BY Default_rate_by_SubGrade DESC;