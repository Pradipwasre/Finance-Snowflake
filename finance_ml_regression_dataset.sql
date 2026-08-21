-- ============================================================
-- FINANCE ML REGRESSION DATASET
-- Snowflake SQL Script
-- ============================================================

-- ============================================================
-- 1. CREATE DATABASE
-- ============================================================

CREATE DATABASE IF NOT EXISTS FINANCE_ML_DB;

USE DATABASE FINANCE_ML_DB;


-- ============================================================
-- 2. CREATE WAREHOUSE
-- ============================================================

CREATE WAREHOUSE IF NOT EXISTS FINANCE_ML_WH
    WAREHOUSE_SIZE = 'XSMALL'
    AUTO_SUSPEND = 60
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE;

USE WAREHOUSE FINANCE_ML_WH;


-- ============================================================
-- 3. CREATE SCHEMA
-- ============================================================

CREATE SCHEMA IF NOT EXISTS FINANCE_PROJECTS;

USE SCHEMA FINANCE_PROJECTS;


-- ============================================================
-- 4. CREATE ONE TABLE
-- ============================================================

CREATE OR REPLACE TABLE FINANCE_PROJECTS_ML_DATA
(
    PROJECT_ID NUMBER,

    PROJECT_START_DATE DATE,

    FINANCE_DOMAIN VARCHAR(50),

    PROJECT_TYPE VARCHAR(100),

    PROJECT_PRIORITY VARCHAR(20),

    PROJECT_STATUS VARCHAR(30),

    DELIVERY_MODEL VARCHAR(30),

    TEAM_SIZE NUMBER,

    PROJECT_DURATION_MONTHS NUMBER,

    PLANNED_BUDGET NUMBER(18,2),

    ESTIMATED_REVENUE NUMBER(18,2),

    RISK_SCORE NUMBER(10,2),

    VENDOR_DEPENDENCY_RATIO NUMBER(10,4),

    SCOPE_CHANGE_RATIO NUMBER(10,4),

    RESOURCE_TURNOVER_RATIO NUMBER(10,4),

    REQUIREMENTS_VOLATILITY NUMBER(10,2),

    RISK_INCIDENTS NUMBER,

    CHANGE_REQUESTS NUMBER,

    DELAYED_MILESTONES NUMBER,

    OPEN_DEFECTS NUMBER,

    RESOURCE_UTILIZATION_RATIO NUMBER(10,4),

    INFLATION_RATE NUMBER(10,4),

    INTEREST_RATE NUMBER(10,4),

    FX_VOLATILITY NUMBER(10,4),

    PREVIOUS_PROJECT_COST NUMBER(18,2),

    PREVIOUS_PROJECT_DELAY_DAYS NUMBER,

    TEAM_PRODUCTIVITY_SCORE NUMBER(10,2),

    -- ML REGRESSION TARGET
    ACTUAL_PROJECT_COST NUMBER(18,2)
);


-- ============================================================
-- 5. GENERATE 10,000 PROJECT RECORDS
-- ============================================================

INSERT INTO FINANCE_PROJECTS_ML_DATA
WITH PROJECTS AS
(
    SELECT
        SEQ4() + 1 AS PROJECT_ID
    FROM TABLE(GENERATOR(ROWCOUNT => 10000))
),

FEATURES AS
(
    SELECT

        PROJECT_ID,

        DATEADD(
            DAY,
            MOD(PROJECT_ID * 37, 2000),
            '2021-01-01'::DATE
        ) AS PROJECT_START_DATE,


        -- --------------------------------------------
        -- Finance domain
        -- --------------------------------------------

        CASE MOD(PROJECT_ID, 6)

            WHEN 0 THEN 'BANKING'

            WHEN 1 THEN 'INSURANCE'

            WHEN 2 THEN 'PAYMENTS'

            WHEN 3 THEN 'WEALTH_MANAGEMENT'

            WHEN 4 THEN 'LENDING'

            ELSE 'CAPITAL_MARKETS'

        END AS FINANCE_DOMAIN,


        -- --------------------------------------------
        -- Project type
        -- --------------------------------------------

        CASE MOD(PROJECT_ID, 8)

            WHEN 0 THEN 'DIGITAL_TRANSFORMATION'

            WHEN 1 THEN 'FRAUD_DETECTION'

            WHEN 2 THEN 'RISK_ANALYTICS'

            WHEN 3 THEN 'CUSTOMER_ANALYTICS'

            WHEN 4 THEN 'REGULATORY_REPORTING'

            WHEN 5 THEN 'COST_OPTIMIZATION'

            WHEN 6 THEN 'CLOUD_MIGRATION'

            ELSE 'DATA_PLATFORM'

        END AS PROJECT_TYPE,


        -- --------------------------------------------
        -- Priority
        -- --------------------------------------------

        CASE MOD(PROJECT_ID, 3)

            WHEN 0 THEN 'HIGH'

            WHEN 1 THEN 'MEDIUM'

            ELSE 'LOW'

        END AS PROJECT_PRIORITY,


        -- --------------------------------------------
        -- Status
        -- --------------------------------------------

        CASE

            WHEN MOD(PROJECT_ID, 19) = 0
                THEN 'AT_RISK'

            WHEN MOD(PROJECT_ID, 23) = 0
                THEN 'DELAYED'

            ELSE 'COMPLETED'

        END AS PROJECT_STATUS,


        -- --------------------------------------------
        -- Delivery model
        -- --------------------------------------------

        CASE MOD(PROJECT_ID, 3)

            WHEN 0 THEN 'IN_HOUSE'

            WHEN 1 THEN 'VENDOR'

            ELSE 'HYBRID'

        END AS DELIVERY_MODEL,


        -- --------------------------------------------
        -- Project size
        -- --------------------------------------------

        10 + MOD(PROJECT_ID * 13, 91)
            AS TEAM_SIZE,


        3 + MOD(PROJECT_ID * 7, 34)
            AS PROJECT_DURATION_MONTHS,


        150000 + MOD(PROJECT_ID * 7919, 4850000)
            AS PLANNED_BUDGET,


        250000 + MOD(PROJECT_ID * 11939, 8500000)
            AS ESTIMATED_REVENUE,


        -- --------------------------------------------
        -- Risk
        -- --------------------------------------------

        10 + MOD(PROJECT_ID * 17, 91)
            AS RISK_SCORE,


        ROUND(
            0.10 + MOD(PROJECT_ID * 11, 81) / 100.0,
            4
        ) AS VENDOR_DEPENDENCY_RATIO,


        ROUND(
            0.05 + MOD(PROJECT_ID * 19, 71) / 100.0,
            4
        ) AS SCOPE_CHANGE_RATIO,


        ROUND(
            0.05 + MOD(PROJECT_ID * 23, 61) / 100.0,
            4
        ) AS RESOURCE_TURNOVER_RATIO,


        5 + MOD(PROJECT_ID * 29, 96)
            AS REQUIREMENTS_VOLATILITY,


        MOD(PROJECT_ID * 31, 15)
            AS RISK_INCIDENTS,


        MOD(PROJECT_ID * 43, 21)
            AS CHANGE_REQUESTS,


        MOD(PROJECT_ID * 47, 13)
            AS DELAYED_MILESTONES,


        2 + MOD(PROJECT_ID * 53, 49)
            AS OPEN_DEFECTS,


        ROUND(
            0.55 + MOD(PROJECT_ID * 59, 46) / 100.0,
            4
        ) AS RESOURCE_UTILIZATION_RATIO,


        -- --------------------------------------------
        -- Economic variables
        -- --------------------------------------------

        ROUND(
            0.02 + MOD(PROJECT_ID * 61, 81) / 1000.0,
            4
        ) AS INFLATION_RATE,


        ROUND(
            0.035 + MOD(PROJECT_ID * 67, 61) / 1000.0,
            4
        ) AS INTEREST_RATE,


        ROUND(
            0.01 + MOD(PROJECT_ID * 71, 91) / 1000.0,
            4
        ) AS FX_VOLATILITY,


        -- --------------------------------------------
        -- Historical project performance
        -- --------------------------------------------

        100000 + MOD(PROJECT_ID * 73, 3200000)
            AS PREVIOUS_PROJECT_COST,


        MOD(PROJECT_ID * 79, 121)
            AS PREVIOUS_PROJECT_DELAY_DAYS,


        55 + MOD(PROJECT_ID * 83, 46)
            AS TEAM_PRODUCTIVITY_SCORE

    FROM PROJECTS
)


SELECT

    PROJECT_ID,

    PROJECT_START_DATE,

    FINANCE_DOMAIN,

    PROJECT_TYPE,

    PROJECT_PRIORITY,

    PROJECT_STATUS,

    DELIVERY_MODEL,

    TEAM_SIZE,

    PROJECT_DURATION_MONTHS,

    ROUND(PLANNED_BUDGET, 2),

    ROUND(ESTIMATED_REVENUE, 2),

    ROUND(RISK_SCORE, 2),

    VENDOR_DEPENDENCY_RATIO,

    SCOPE_CHANGE_RATIO,

    RESOURCE_TURNOVER_RATIO,

    REQUIREMENTS_VOLATILITY,

    RISK_INCIDENTS,

    CHANGE_REQUESTS,

    DELAYED_MILESTONES,

    OPEN_DEFECTS,

    RESOURCE_UTILIZATION_RATIO,

    INFLATION_RATE,

    INTEREST_RATE,

    FX_VOLATILITY,

    PREVIOUS_PROJECT_COST,

    PREVIOUS_PROJECT_DELAY_DAYS,

    TEAM_PRODUCTIVITY_SCORE,


    -- ========================================================
    -- REGRESSION TARGET
    --
    -- ACTUAL_PROJECT_COST depends on multiple project factors.
    -- This gives ML a meaningful regression problem.
    -- ========================================================

    ROUND(

        PLANNED_BUDGET

        * (
            1

            + (0.10 * INFLATION_RATE)

            + (0.35 * VENDOR_DEPENDENCY_RATIO)

            + (0.65 * SCOPE_CHANGE_RATIO)

            + (0.25 * RESOURCE_TURNOVER_RATIO)

            + (0.003 * RISK_SCORE)
        )

        + (TEAM_SIZE * 11500)

        + (PROJECT_DURATION_MONTHS * 18500)

        + (RISK_INCIDENTS * 24000)

        + (CHANGE_REQUESTS * 13500)

        + (DELAYED_MILESTONES * 22000)

        + (OPEN_DEFECTS * 6500)

        + (REQUIREMENTS_VOLATILITY * 1800)

        + (PREVIOUS_PROJECT_COST * 0.08)

        - (TEAM_PRODUCTIVITY_SCORE * 4200)

        -- Synthetic noise
        + MOD(PROJECT_ID * 104729, 220000)
        - 110000,

        2

    ) AS ACTUAL_PROJECT_COST

FROM FEATURES;


-- ============================================================
-- 6. VERIFY DATA
-- ============================================================

SELECT COUNT(*) AS TOTAL_ROWS
FROM FINANCE_PROJECTS_ML_DATA;


-- ============================================================
-- 7. SAMPLE DATA
-- ============================================================

SELECT *
FROM FINANCE_PROJECTS_ML_DATA
LIMIT 20;


-- ============================================================
-- 8. REGRESSION TARGET STATISTICS
-- ============================================================

SELECT

    MIN(ACTUAL_PROJECT_COST) AS MIN_ACTUAL_COST,

    AVG(ACTUAL_PROJECT_COST) AS AVG_ACTUAL_COST,

    MAX(ACTUAL_PROJECT_COST) AS MAX_ACTUAL_COST,

    STDDEV(ACTUAL_PROJECT_COST) AS STDDEV_ACTUAL_COST

FROM FINANCE_PROJECTS_ML_DATA;


-- ============================================================
-- 9. BUSINESS-LEVEL DATA CHECK
-- ============================================================

SELECT

    FINANCE_DOMAIN,

    PROJECT_TYPE,

    COUNT(*) AS PROJECT_COUNT,

    ROUND(
        AVG(PLANNED_BUDGET),
        2
    ) AS AVG_PLANNED_BUDGET,

    ROUND(
        AVG(ACTUAL_PROJECT_COST),
        2
    ) AS AVG_ACTUAL_PROJECT_COST,

    ROUND(
        AVG(RISK_SCORE),
        2
    ) AS AVG_RISK_SCORE

FROM FINANCE_PROJECTS_ML_DATA

GROUP BY
    FINANCE_DOMAIN,
    PROJECT_TYPE

ORDER BY
    FINANCE_DOMAIN,
    PROJECT_TYPE;


-- ============================================================
-- FINAL ML DATASET
--
-- Features:
--   TEAM_SIZE
--   PROJECT_DURATION_MONTHS
--   PLANNED_BUDGET
--   ESTIMATED_REVENUE
--   RISK_SCORE
--   VENDOR_DEPENDENCY_RATIO
--   SCOPE_CHANGE_RATIO
--   RESOURCE_TURNOVER_RATIO
--   REQUIREMENTS_VOLATILITY
--   RISK_INCIDENTS
--   CHANGE_REQUESTS
--   DELAYED_MILESTONES
--   OPEN_DEFECTS
--   RESOURCE_UTILIZATION_RATIO
--   INFLATION_RATE
--   INTEREST_RATE
--   FX_VOLATILITY
--   PREVIOUS_PROJECT_COST
--   PREVIOUS_PROJECT_DELAY_DAYS
--   TEAM_PRODUCTIVITY_SCORE
--
-- Target:
--   ACTUAL_PROJECT_COST
--
-- Recommended model:
--   Linear Regression
--   Random Forest Regression
--   XGBoost Regression
--   Gradient Boosting Regression
-- ============================================================

SELECT

    PROJECT_START_DATE,

    FINANCE_DOMAIN,

    PROJECT_TYPE,

    PROJECT_PRIORITY,

    DELIVERY_MODEL,

    TEAM_SIZE,

    PROJECT_DURATION_MONTHS,

    PLANNED_BUDGET,

    ESTIMATED_REVENUE,

    RISK_SCORE,

    VENDOR_DEPENDENCY_RATIO,

    SCOPE_CHANGE_RATIO,

    RESOURCE_TURNOVER_RATIO,

    REQUIREMENTS_VOLATILITY,

    RISK_INCIDENTS,

    CHANGE_REQUESTS,

    DELAYED_MILESTONES,

    OPEN_DEFECTS,

    RESOURCE_UTILIZATION_RATIO,

    INFLATION_RATE,

    INTEREST_RATE,

    FX_VOLATILITY,

    PREVIOUS_PROJECT_COST,

    PREVIOUS_PROJECT_DELAY_DAYS,

    TEAM_PRODUCTIVITY_SCORE,

    ACTUAL_PROJECT_COST

FROM FINANCE_PROJECTS_ML_DATA;
