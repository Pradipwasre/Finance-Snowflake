import snowflake.connector
import pandas as pd
import getpass

# ------------------------------------------------------------
# STEP 1: Connect to Snowflake (username + password login)
# ------------------------------------------------------------
password = getpass.getpass("Enter your Snowflake password: ")

conn = snowflake.connector.connect(
    account="EJVGHYR-CH39687",
    user="PRADIPBUILDS",
    password=password,
    role="ACCOUNTADMIN",
    warehouse="FINANCE_ML_WH",
    database="FINANCE_ML_DB",
    schema="FINANCE_PROJECTS"
)

print("Connected to Snowflake successfully.")

# ------------------------------------------------------------
# STEP 2: Fetch data
# ------------------------------------------------------------
query = """
    SELECT *
    FROM FINANCE_ML_DB.FINANCE_PROJECTS.FINANCE_PROJECTS_ML_DATA
"""

df = pd.read_sql(query, conn)

print(f"Data fetched. Shape: {df.shape}")

# ------------------------------------------------------------
# STEP 3: Quick check
# ------------------------------------------------------------
print(df.head(10))

# ------------------------------------------------------------
# STEP 4: Close connection
# ------------------------------------------------------------
conn.close()
print("Connection closed.")