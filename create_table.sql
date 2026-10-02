CREATE TABLE CoreDB.dbo.Sales (
    SalesID             BIGINT IDENTITY(1,1) NOT NULL,
    BranchID            VARCHAR(10)          NOT NULL,
    ApplicationID       VARCHAR(30)          NOT NULL,
    SalesDate           DATE                 NOT NULL,
    NetFinanceAmount    NUMERIC(18,2)        NOT NULL,
    IsCaptive           BIT                  NOT NULL,
    CreatedDate         DATETIME             NOT NULL,
    CONSTRAINT PK_Sales PRIMARY KEY CLUSTERED (BranchID ASC, ApplicationID ASC)
);

CREATE TABLE CoreDB.dbo.Agreement (
    BranchID              VARCHAR(10)          NOT NULL,
    ApplicationID         VARCHAR(30)          NOT NULL,
    CustomerID            VARCHAR(30)          NOT NULL,
    ContractStatus        VARCHAR(10)          NOT NULL,
    DefaultStatus         VARCHAR(10)          NOT NULL,
    OutstandingPrincipal  NUMERIC(18,2)        NOT NULL,
    GoLiveDate            DATE                 NOT NULL,
    NextInstallmentDate   DATE                 NULL,
    MaturityDate          DATE                 NULL,
    PreviousAgreementID   VARCHAR(30)          NULL,
    CreatedDate           DATETIME             NOT NULL,
    CONSTRAINT PK_Agreement PRIMARY KEY CLUSTERED (BranchID ASC, ApplicationID ASC)
);

CREATE TABLE CoreDB.dbo.AgreementAsset (
    BranchID            VARCHAR(10)          NOT NULL,
    ApplicationID       VARCHAR(30)          NOT NULL,
    AssetCode           VARCHAR(20)          NOT NULL,
    AssetCondition      VARCHAR(10)          NOT NULL, -- 'New', 'Used'
    AssetTypeID         VARCHAR(10)          NOT NULL,

    CONSTRAINT PK_AgreementAsset PRIMARY KEY CLUSTERED (BranchID ASC, ApplicationID ASC)
);

CREATE TABLE CoreDB.dbo.AssetMaster (
    AssetCode           VARCHAR(20)          NOT NULL,
    AssetName           VARCHAR(100)         NOT NULL,
    Category            VARCHAR(50)          NOT NULL,
    CONSTRAINT PK_AssetMaster PRIMARY KEY CLUSTERED (AssetCode ASC)
);

CREATE TABLE Staging.dbo.DailyAging (
    AgingDate           DATE                 NOT NULL,
    BranchID            VARCHAR(10)          NOT NULL,
    ApplicationID       VARCHAR(30)          NOT NULL,
    DaysOverdue         INT                  NOT NULL,
    CollectibilityScore INT                  NOT NULL,
    TotalOSPrincipal    NUMERIC(18,2)        NOT NULL,
    DefaultStatus       VARCHAR(10)          NOT NULL,
    DailyMonthlyFlag    CHAR(1)              NOT NULL,
    CONSTRAINT PK_DailyAging PRIMARY KEY CLUSTERED (AgingDate ASC, BranchID ASC, ApplicationID ASC)
);

CREATE TABLE CoreDB.dbo.DailyAgingMirror (
    AgingDate           DATE                 NOT NULL,
    ApplicationID       VARCHAR(30)          NOT NULL,
    TotalOSPrincipal    NUMERIC(18,2)        NOT NULL,
    DailyMonthlyFlag    CHAR(1)              NOT NULL,
    CONSTRAINT PK_DailyAgingMirror PRIMARY KEY CLUSTERED (AgingDate ASC, ApplicationID ASC)
);

CREATE TABLE CoreDB.dbo.RecoveryTransaction (
    RecoveryID          BIGINT IDENTITY(1,1) NOT NULL,
    BranchID            VARCHAR(10)          NOT NULL,
    ApplicationID       VARCHAR(30)          NOT NULL,
    PostingDate         DATE                 NOT NULL,
    RecoveryAmount      NUMERIC(18,2)        NOT NULL,
    CONSTRAINT PK_RecoveryTransaction PRIMARY KEY CLUSTERED (RecoveryID ASC)
);

CREATE VIEW CoreDB.dbo.vw_RecoveryLog AS
SELECT BranchID, ApplicationID, PostingDate, RecoveryAmount
FROM CoreDB.dbo.RecoveryTransaction;
GO

CREATE TABLE CoreDB.dbo.FinancialTarget (
    TargetID            INT IDENTITY(1,1)    NOT NULL,
    BranchID            VARCHAR(10)          NOT NULL,
    TargetDescription   VARCHAR(20)          NOT NULL,
    TargetDate          DATE                 NOT NULL,
    TargetAmount        NUMERIC(18,2)        NOT NULL,
    CONSTRAINT PK_FinancialTarget PRIMARY KEY CLUSTERED (TargetID ASC)
);

CREATE TABLE dbo.Fact_NationalPerformanceSummary (
    YearlyPeriod            INT             NOT NULL,
    MonthlyPeriod           INT             NOT NULL,
    SalesRegRetail          NUMERIC(18,2)   NOT NULL,
    SalesRegMultiguna       NUMERIC(18,2)   NOT NULL,
    SalesCaptive            NUMERIC(18,2)   NOT NULL,
    SalesCompany            NUMERIC(5,2)    NOT NULL, 
    SalesAccountRegular     INT             NOT NULL,
    SalesAccountMultiguna   INT             NOT NULL,
    SalesAccountCaptive     INT             NOT NULL,
    Kol2NJF                 NUMERIC(5,2)    NOT NULL,
    Kol2JF                  NUMERIC(5,2)    NOT NULL,
    Kol3UpNJF               NUMERIC(5,2)    NOT NULL,
    Kol3UpJF                NUMERIC(5,2)    NOT NULL,
    EPD                     NUMERIC(5,2)    NOT NULL,
    RECOVERY                NUMERIC(18,2)   NOT NULL,
    TOTALPRPAVG             NUMERIC(18,2)   NOT NULL,
    TotalOSPrincipal        NUMERIC(18,2)   NOT NULL,
    TotalAccount            INT             NOT NULL,
    PBT                     NUMERIC(18,2)   NOT NULL,
    CreatedDate             DATETIME        NOT NULL,
    UpdatedDate             DATETIME        NULL,
    CONSTRAINT PK_Fact_NationalPerformanceSummary 
        PRIMARY KEY CLUSTERED (YearlyPeriod ASC, MonthlyPeriod ASC)
)

