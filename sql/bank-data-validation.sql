CREATE DATABASE lendingclub_analysis;
USE lendingclub_analysis;

CREATE TABLE loan_data (
    id BIGINT,
    loan_amnt DECIMAL(12,2),
    funded_amnt DECIMAL(12,2),
    funded_amnt_inv DECIMAL(12,2),

    term INT,
    int_rate DECIMAL(6,2),
    installment DECIMAL(12,2),

    grade VARCHAR(5),
    sub_grade VARCHAR(5),

    emp_length INT,
    home_ownership VARCHAR(30),
    annual_inc DECIMAL(15,2),
    verification_status VARCHAR(30),

    issue_d DATE,
    loan_status VARCHAR(100),

    purpose VARCHAR(50),
    addr_state VARCHAR(5),

    dti DECIMAL(8,2),
    delinq_2yrs INT,
    fico_range_low INT,
    fico_range_high INT,
    inq_last_6mths INT,
    open_acc INT,
    pub_rec INT,
    revol_bal DECIMAL(15,2),
    revol_util DECIMAL(6,2),
    total_acc INT,

    out_prncp DECIMAL(15,2),
    total_pymnt DECIMAL(15,2),
    total_rec_prncp DECIMAL(15,2),
    total_rec_int DECIMAL(15,2),
    total_rec_late_fee DECIMAL(12,2),
    recoveries DECIMAL(15,2),

    pub_rec_bankruptcies INT
);

DESCRIBE loan_data;

SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE
'C:/Users/gajbh/Desktop/LendingClub_loan_analysis/loan_default_analysis_clean.csv'
INTO TABLE loan_data
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS; 

SELECT @@local_infile; 

SELECT * FROM loan_data; 




ALTER TABLE loan_data
    MODIFY loan_amnt DECIMAL(18,6),
    MODIFY funded_amnt DECIMAL(18,6),
    MODIFY funded_amnt_inv DECIMAL(18,6),
    MODIFY installment DECIMAL(18,6),
    MODIFY annual_inc DECIMAL(18,6),
    MODIFY revol_bal DECIMAL(18,6),
    MODIFY out_prncp DECIMAL(18,6),
    MODIFY total_pymnt DECIMAL(18,6),
    MODIFY total_rec_prncp DECIMAL(18,6),
    MODIFY total_rec_int DECIMAL(18,6),
    MODIFY total_rec_late_fee DECIMAL(18,6),
    MODIFY recoveries DECIMAL(18,6);