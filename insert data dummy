USE DataWarehouse;
GO

/*
==================================================================================
 File Name    : insert_dummy_data.sql
 Description  : Sample Dummy Data to populate source tables for testing 
                dbo.sp_CalculateMonthlyPerformance Stored Procedure.
==================================================================================
*/

-- 1. Insert Master Asset
INSERT INTO CoreDB.dbo.AssetMaster (AssetCode, AssetName, Category) VALUES
('AST-001', 'Honda Vario 160', 'Motorcycle'),
('AST-002', 'Toyota Avanza 1.5', 'Car'),
('AST-003', 'Mitsubishi Fuso Truck', 'Commercial Vehicle');

-- 2. Insert Agreement / Header Kontrak
INSERT INTO CoreDB.dbo.Agreement 
(BranchID, ApplicationID, CustomerID, ContractStatus, DefaultStatus, OutstandingPrincipal, GoLiveDate, NextInstallmentDate, MaturityDate, PreviousAgreementID) 
VALUES
('BR-001', 'APP-2026-001', 'CUST-101', 'Live', 'Normal', 15000000.00, '2026-01-10', '2026-10-10', '2028-01-10', NULL),
('BR-001', 'APP-2026-002', 'CUST-102', 'Live', 'Normal', 120000000.00, '2026-02-15', '2026-10-15', '2029-02-15', NULL),
('BR-002', 'APP-2026-003', 'CUST-103', 'Live', 'Normal', 250000000.00, '2026-03-01', '2026-10-01', '2030-03-01', NULL),
('BR-002', 'APP-2026-004', 'CUST-104', 'Live', 'Normal', 18000000.00, '2026-03-20', '2026-10-20', '2028-03-20', NULL);

-- 3. Insert Agreement Asset Detail
INSERT INTO CoreDB.dbo.AgreementAsset (BranchID, ApplicationID, AssetCode, AssetCondition, AssetTypeID) VALUES
('BR-001', 'APP-2026-001', 'AST-001', 'New',  'MTR'),
('BR-001', 'APP-2026-002', 'AST-002', 'Used', 'CAR'),
('BR-002', 'APP-2026-003', 'AST-003', 'New',  'TRK'),
('BR-002', 'APP-2026-004', 'AST-001', 'Used', 'MTR');

-- 4. Insert Sales Transactions (Year 2026)
INSERT INTO CoreDB.dbo.Sales (BranchID, ApplicationID, SalesDate, NetFinanceAmount, IsCaptive) VALUES
('BR-001', 'APP-2026-001', '2026-01-10', 15000000.00, 0), -- Retail New
('BR-001', 'APP-2026-002', '2026-02-15', 120000000.00, 0), -- Multiguna Used
('BR-002', 'APP-2026-003', '2026-03-01', 250000000.00, 1), -- Captive Sales
('BR-002', 'APP-2026-004', '2026-03-20', 18000000.00, 0);  -- Multiguna Used

-- 5. Insert Daily Aging Snapshots (Snapshot Bulan September 2026)
INSERT INTO Staging.dbo.DailyAging 
(AgingDate, BranchID, ApplicationID, DaysOverdue, CollectibilityScore, TotalOSPrincipal, DefaultStatus, DailyMonthlyFlag) 
VALUES
('2026-09-30', 'BR-001', 'APP-2026-001', 0,   1, 15000000.00,  'Normal', 'M'), -- Lancar / Kol 1
('2026-09-30', 'BR-001', 'APP-2026-002', 45,  2, 120000000.00, 'Normal', 'M'), -- Overdue / Kol 2 (1-90 hari)
('2026-09-30', 'BR-002', 'APP-2026-003', 105, 3, 250000000.00, 'Normal', 'M'), -- NPL / Kol 3 (>90 hari)
('2026-09-30', 'BR-002', 'APP-2026-004', 5,   2, 18000000.00,  'Normal', 'M'); -- Overdue / Kol 2

-- 6. Insert Recovery Log Transactions
INSERT INTO CoreDB.dbo.RecoveryTransaction (BranchID, ApplicationID, PostingDate, RecoveryAmount) VALUES
('BR-002', 'APP-2026-003', '2026-09-15', 5000000.00),
('BR-001', 'APP-2026-002', '2026-09-20', 2500000.00);

-- 7. Insert Financial Target
INSERT INTO CoreDB.dbo.FinancialTarget (BranchID, TargetDescription, TargetDate, TargetAmount) VALUES
('HEAD_OFFICE', 'PAA', '2026-09-01', 5000000000.00);
GO
