from pathlib import Path
import pandas as pd

PROJECT_ROOT = Path(__file__).resolve().parent.parent

input_file = PROJECT_ROOT / "data" / "accepted_2007_to_2018Q4.csv"
output_file = PROJECT_ROOT / "data" / "loan_default_analysis_clean.csv"
 
columns_to_keep = [ 
    "id", 
    "loan_amnt", 
    "funded_amnt", 
    "funded_amnt_inv", 
    "term", 
    "int_rate", 
    "installment", 
    "grade", 
    "sub_grade", 
    "emp_length", 
    "home_ownership", 
    "annual_inc", 
    "verification_status", 
    "issue_d", 
    "loan_status", 
    "purpose", 
    "addr_state", 
    "dti", 
    "delinq_2yrs", 
    "fico_range_low", 
    "fico_range_high", 
    "inq_last_6mths", 
    "open_acc", 
    "pub_rec", 
    "revol_bal", 
    "revol_util", 
    "total_acc", 
    "out_prncp", 
    "total_pymnt", 
    "total_rec_prncp", 
    "total_rec_int", 
    "total_rec_late_fee", 
    "recoveries", 
    "pub_rec_bankruptcies" 
] 

integer_cols = [
    "term",
    "emp_length",
    "delinq_2yrs",
    "fico_range_low",
    "fico_range_high",
    "inq_last_6mths",
    "open_acc",
    "pub_rec",
    "total_acc",
    "pub_rec_bankruptcies"
]

money_cols = [
    "loan_amnt",
    "funded_amnt",
    "funded_amnt_inv",
    "installment",
    "annual_inc",
    "revol_bal",
    "out_prncp",
    "total_pymnt",
    "total_rec_prncp",
    "total_rec_int",
    "total_rec_late_fee",
    "recoveries"
]
 
first_chunk = True 
 
for chunk in pd.read_csv( 
    input_file, 
    usecols=columns_to_keep, 
    chunksize=100_000, 
    low_memory=False 
):

    chunk = chunk[pd.to_numeric(chunk["id"], errors="coerce").notna()]

    # Clean term
    chunk["term"] = (
        chunk["term"]
        .str.replace(" months", "", regex=False)
        .astype(float)
    )

    # Clean employment length
    chunk["emp_length"] = (
        chunk["emp_length"]
        .str.replace("< 1 year", "0", regex=False)
        .str.replace("10+ years", "10", regex=False)
        .str.replace(" years", "", regex=False)
        .str.replace(" year", "", regex=False)
        .astype(float)
    )

    # Convert issue date
    chunk["issue_d"] = pd.to_datetime(
        chunk["issue_d"],
        format="%b-%Y",
        errors="coerce"
    )

    for col in integer_cols:
      chunk[col] = chunk[col].astype("Int64")

    for col in money_cols:
      chunk[col] = chunk[col].round(6)
 
    chunk.to_csv( 
        output_file, 
        mode="w" if first_chunk else "a", 
        header=first_chunk, 
        index=False 
    ) 
 
    first_chunk = False 
 
    print(f"Processed {len(chunk):,} rows") 
 
print("Done!")


