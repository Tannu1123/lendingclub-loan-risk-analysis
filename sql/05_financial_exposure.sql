USE lendingclub_analysis;

/*
Question 5: Which grades and sub-grades have the largest
financial exposure to bad loan outcomes?
*/

WITH subgrade_analysis AS (
    SELECT
        grade,
        sub_grade,

        COUNT(*) AS known_outcome_count,

        SUM(
            CASE
                WHEN loan_status IN (
                    'Fully Paid',
                    'Does not meet the credit policy. Status:Fully Paid'
                )
                THEN 1
                ELSE 0
            END
        ) AS good_loan_count,

        SUM(
            CASE
                WHEN loan_status IN (
                    'Charged Off',
                    'Default',
                    'Does not meet the credit policy. Status:Charged Off'
                )
                THEN 1
                ELSE 0
            END
        ) AS bad_loan_count,

        SUM(funded_amnt) AS known_outcome_funded_amount,

        SUM(
            CASE
                WHEN loan_status IN (
                    'Charged Off',
                    'Default',
                    'Does not meet the credit policy. Status:Charged Off'
                )
                THEN funded_amnt
                ELSE 0
            END
        ) AS bad_funded_amount

    FROM loan_data

    WHERE loan_status IN (
        'Fully Paid',
        'Does not meet the credit policy. Status:Fully Paid',
        'Charged Off',
        'Default',
        'Does not meet the credit policy. Status:Charged Off'
    )

    GROUP BY grade, sub_grade
),

exposure_analysis AS (
    SELECT
        *,

        ROUND(
            100.0 * bad_loan_count
            / NULLIF(known_outcome_count, 0),
            2
        ) AS bad_loan_rate,

        ROUND(
            100.0 * bad_funded_amount
            / NULLIF(known_outcome_funded_amount, 0),
            2
        ) AS bad_exposure_rate,
        
        ROUND(
    100.0 * SUM(bad_funded_amount) OVER (PARTITION BY grade)
    / NULLIF(
        SUM(known_outcome_funded_amount) OVER (PARTITION BY grade),
        0
    ),
    2
) AS bad_exposure_rate_by_grade,

        SUM(bad_funded_amount) OVER ()
            AS total_bad_loan_funded_amount,

        SUM(known_outcome_funded_amount) OVER ()
            AS total_known_outcome_funded_amount

    FROM subgrade_analysis
)

SELECT
    *,

    ROUND(
        100.0 * total_bad_loan_funded_amount
        / NULLIF(total_known_outcome_funded_amount, 0),
        2
    ) AS overall_financial_exposure_rate

FROM exposure_analysis

ORDER BY bad_funded_amount DESC;