Financial Portfolio & Risk Analytics Data Warehouse (T-SQL)

An enterprise-grade Data Warehousing & Automated ETL Solution built using T-SQL (MS SQL Server). This project simulates an End-of-Day (EOD) data pipeline designed to aggregate monthly sales performance, active portfolio metrics, credit risk classification (Days Overdue / Asset Quality), and recovery tracking for national-level financial reporting.

* Project Overview
In the multifinance and banking sectors, executive leadership requires timely and consolidated metrics to track business growth alongside risk management. This solution automates the processing of transactional data from core banking/leasing systems (CoreDB) and operational staging environments (Staging) into a structured Data Warehouse Fact Table (Fact_NationalPerformanceSummary).

* Key Objectives:
  - Automate Monthly KPIs: Consolidate Sales Volume (Retail, Multiguna, Captive), Active Outstanding Principal, and Account Counts.
  - Credit Quality & NPL Tracking: Classify loan portfolios into overdue buckets (Collectibility 2 for 1–90 days OD and Collectibility 3+ for NPL >90 days OD).
  - Recovery & Profit Analytics: Aggregate recovery collection entries and map actual financial targets against Profit Before Tax (PBT).

* Data Architecture & Pipeline
The pipeline follows a classic Staging → Core Operational DB → Data Warehouse Fact Model architecture:

        [ CoreDB Systems ]          [ Staging Layer ]

        ├── Sales Data               └── Daily Aging Snapshots
        
        ├── Agreement Headers

        └── Recovery Logs 
           │                          │
           └──────────┬───────────────┘
                      ▼
         [ Stored Procedure Layer ]
         sp_CalculateMonthlyPerformance
                      │
                      ▼
         [ Data Warehouse Layer ]
     Fact_NationalPerformanceSummary

* Data Schema Overview:
1. CoreDB.dbo.Sales: Transactional records for new application approvals and financing disbursements.
2. CoreDB.dbo.Agreement & AgreementAsset: Active contract headers, customer mappings, and collateral asset conditions (New / Used).
3. Staging.dbo.DailyAging: Daily snapshot data tracking Days Overdue (OD), contract status, and outstanding principal.
4. CoreDB.dbo.RecoveryTransaction: Log of bad-debt recovery payments.
5. dbo.Fact_NationalPerformanceSummary: Target fact table storing pre-aggregated monthly KPIs.

* Key Features
  - Set-Based Data Processing: Built using optimized set-based SQL operations (UPDATE ... FROM JOIN / CROSS JOIN) rather than cursor loops for high performance on large datasets.
  - Idempotent EOD Execution: Designed to safely re-run for any business date by clearing and re-inserting the targeted monthly period (DELETE + INSERT strategy).
  - Dynamic Date Normalization: Automatically handles YTD calculation bounds, month-end aging cutoffs, and calendar boundaries based on a single input @BusinessDate.
  - Zero-Division Safe Logic: Employs NULLIF() across all percentage/ratio calculations (e.g., NPL ratio) to prevent runtime division-by-zero errors.


* Quickstart & Execution Guide
Follow these simple steps to set up and run the environment locally using SQL Server Management Studio (SSMS) or Azure Data Studio:

1. Provision Database Schemas & Tables
    Run create tables.sql to initialize the database and create all required tables:
2. Populate Sample Operational Data
    Run insert_dummy_data.sql to populate sample
3. Deploy the Stored Procedure
    Run sp_CalculateMonthlyPerformance.sql to register the stored procedure.
4. Execute & Verify Pipeline
    Execute the procedure for a target business date (e.g., September 30, 2026):

      -- Execute EOD Pipeline Process

      EXEC dbo.sp_CalculateMonthlyPerformance @BusinessDate = '2026-09-30';

      -- Inspect Results in Data Warehouse Fact Table

      SELECT * FROM dbo.Fact_NationalPerformanceSummary;

* Tech Stack & Tools
  
    - Language: T-SQL (Transact-SQL)

    - Database Engine: Microsoft SQL Server 2019 / 2022

    - Database Tools: SQL Server Management Studio (SSMS) / Azure Data Studio

Created as part of a Data Engineering & Database Architecture Portfolio.
