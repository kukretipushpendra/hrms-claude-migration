--------------------------------ITAsset------------------------
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ITAsset]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[ITAsset] (
        [Id] [bigint] IDENTITY(1,1) NOT NULL,
        [DeviceName] NVARCHAR(100) NOT NULL,
        [DeviceCode] NVARCHAR(100) NULL,
        [SerialNumber] NVARCHAR(100) NULL,
        [InvoiceNumber] NVARCHAR(100) NULL,
        [Manufacturer] NVARCHAR(100) NULL,
        [Model] NVARCHAR(100) NULL,
        [AssetType] TINYINT NOT NULL,
        [Status] TINYINT NOT NULL,
        [Branch] TINYINT NULL,
        [PurchaseDate] DATE NOT NULL,
        [WarrantyExpires] DATE NULL,
        [Comments] NVARCHAR(100) NULL,
        [CreatedBy] NVARCHAR(100) NOT NULL,
        [CreatedOn] DATETIME NOT NULL,
        [ModifiedBy] NVARCHAR(100) NULL,
        [ModifiedOn] DATETIME NULL,
        [Specification] NVARCHAR(MAX) NULL,
        [AssetCondition] TINYINT NULL,    
        CONSTRAINT [PK_ITAsset] PRIMARY KEY CLUSTERED ([Id] ASC)
    ) ON [PRIMARY]
END
GO
------------------------EmployeeAsset---------------------------
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeAsset]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[EmployeeAsset] (
        [Id] [int] IDENTITY(1,1) NOT NULL,
        [EmployeeId] [bigint] NOT NULL,
        [AssetId] [bigint] NOT NULL,
        [AssignedOn] [date] NOT NULL,
        [IsActive] [bit] NOT NULL,
        [CreatedBy] [nvarchar](100) NOT NULL,
        [CreatedOn] [datetime] NOT NULL,
        [ModifiedBy] [nvarchar](100) NULL,
        [ModifiedOn] [datetime] NULL,
        CONSTRAINT [PK_EmployeeAsset] PRIMARY KEY CLUSTERED ([Id] ASC)
    ) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_EmployeeAsset_EmployeeData_EmployeeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[EmployeeAsset]'))
BEGIN
    ALTER TABLE [dbo].[EmployeeAsset] WITH CHECK 
    ADD CONSTRAINT [FK_EmployeeAsset_EmployeeData_EmployeeId] FOREIGN KEY ([EmployeeId]) 
    REFERENCES [dbo].[EmployeeData] ([Id])
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_EmployeeAsset_ITAsset_AssetId]') AND parent_object_id = OBJECT_ID(N'[dbo].[EmployeeAsset]'))
BEGIN
    ALTER TABLE [dbo].[EmployeeAsset] WITH CHECK 
    ADD CONSTRAINT [FK_EmployeeAsset_ITAsset_AssetId] FOREIGN KEY ([AssetId]) 
    REFERENCES [dbo].[ITAsset] ([Id])
END
GO

-- Alter Statement for EmployeeAsset (ReturnDate Column)

IF NOT EXISTS (
    SELECT * 
    FROM sys.columns 
    WHERE Name = N'ReturnDate'
      AND Object_ID = Object_ID(N'[dbo].[EmployeeAsset]')
)
BEGIN
    ALTER TABLE [dbo].[EmployeeAsset]
    ADD [ReturnDate] [date] NULL;
END
GO

IF NOT EXISTS (
    SELECT * 
    FROM sys.columns 
    WHERE Name = N'ReturnCondition'
      AND Object_ID = Object_ID(N'[dbo].[EmployeeAsset]')
)
BEGIN
    ALTER TABLE [dbo].[EmployeeAsset]
    ADD [ReturnCondition] [tinyInt] NULL;
END
GO




--------------------------------ITAssetHistory------------------------------------
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ITAssetHistory]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[ITAssetHistory] (
        [Id] [int] IDENTITY(1,1) NOT NULL,
        [AssetId] [bigint] NOT NULL,
        [EmployeeId] [bigint] NOT NULL,
        [Status] [tinyint] NOT NULL,      
        [AssetCondition] [tinyint] NOT NULL,    
        [Note] [nvarchar](255) NULL,
        [CreatedBy] [nvarchar](100) NOT NULL,
        [CreatedOn] [datetime] NOT NULL,
        CONSTRAINT [PK_ITAssetHistory] PRIMARY KEY CLUSTERED ([Id] ASC)
    ) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ITAssetHistory_ITAsset]') AND parent_object_id = OBJECT_ID(N'[dbo].[ITAssetHistory]'))
BEGIN
    ALTER TABLE [dbo].[ITAssetHistory] WITH CHECK 
    ADD CONSTRAINT [FK_ITAssetHistory_ITAsset] FOREIGN KEY ([AssetId]) 
    REFERENCES [dbo].[ITAsset] ([Id])
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ITAssetHistory_EmployeeData]') AND parent_object_id = OBJECT_ID(N'[dbo].[ITAssetHistory]'))
BEGIN
    ALTER TABLE [dbo].[ITAssetHistory] WITH CHECK 
    ADD CONSTRAINT [FK_ITAssetHistory_EmployeeData] FOREIGN KEY ([EmployeeId]) 
    REFERENCES [dbo].[EmployeeData] ([Id])
END
GO

-----Alter--
-- Add IssueDate column if not exists
IF NOT EXISTS (
    SELECT * 
    FROM sys.columns 
    WHERE Name = N'IssueDate' 
      AND Object_ID = OBJECT_ID(N'[dbo].[ITAssetHistory]')
)
BEGIN
    ALTER TABLE [dbo].[ITAssetHistory]
    ADD [IssueDate] DATE NULL;
END
GO

-- Add ReturnDate column if not exists
IF NOT EXISTS (
    SELECT * 
    FROM sys.columns 
    WHERE Name = N'ReturnDate' 
      AND Object_ID = OBJECT_ID(N'[dbo].[ITAssetHistory]')
)
BEGIN
    ALTER TABLE [dbo].[ITAssetHistory]
    ADD [ReturnDate] DATE NULL;
END
GO
---------isReportingManager----------
IF NOT EXISTS (
    SELECT * 
    FROM sys.columns 
    WHERE Name = N'IsReportingManager' 
      AND Object_ID = OBJECT_ID(N'[dbo].[EmploymentDetail]')
)
BEGIN
    ALTER TABLE [dbo].[EmploymentDetail]
    ADD [IsReportingManager] BIT NULL;
END
GO



---------------------Swap and CompOff Table ----------------
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CompOffAndSwapHolidayDetail]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CompOffAndSwapHolidayDetail](
    [Id] [bigint] IDENTITY(1,1) NOT NULL,
    [EmployeeId] [bigint] NOT NULL,
    [WorkingDate] [date] NOT NULL,
    [LeaveDate] [date] NULL,
    [LeaveDateLabel] [nvarchar](100) NULL,
    [WorkingDateLabel] [nvarchar](100) NULL,
    [Reason] [nvarchar](max) NULL,
    [Status] [tinyint] NOT NULL,
    [RejectReason] [nvarchar](max) NULL,
    [RequestType] [tinyint] NOT NULL,
    [NumberOfDays] [decimal](5,2) NULL,
    [CreatedOn] [datetime] NULL,
    [CreatedBy] [nvarchar](100) NULL,
    [ModifiedBy] [nvarchar](100) NULL,
    [ModifiedOn] [datetime] NULL,
    [IsDeleted] [bit] NOT NULL DEFAULT 0,
CONSTRAINT [PK_CompOffAndSwapHolidayDetail] PRIMARY KEY CLUSTERED 
(
    [Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CompOffAndSwapHolidayDetail_EmployeeData_EmployeeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[CompOffAndSwapHolidayDetail]'))
BEGIN
ALTER TABLE [dbo].[CompOffAndSwapHolidayDetail] WITH CHECK ADD CONSTRAINT [FK_CompOffAndSwapHolidayDetail_EmployeeData_EmployeeId] FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[EmployeeData] ([Id])
END
GO
-----------ITAsset------------------
-- Add ProductFileOriginalName column if not exists
IF NOT EXISTS (
    SELECT * 
    FROM sys.columns 
    WHERE Name = N'ProductFileOriginalName' 
      AND Object_ID = OBJECT_ID(N'[dbo].[ITAsset]')
)
BEGIN
    ALTER TABLE [dbo].[ITAsset]
    ADD [ProductFileOriginalName] NVARCHAR(255) NULL;
END
GO

-- Add ProductFileName column if not exists
IF NOT EXISTS (
    SELECT * 
    FROM sys.columns 
    WHERE Name = N'ProductFileName' 
      AND Object_ID = OBJECT_ID(N'[dbo].[ITAsset]')
)
BEGIN
    ALTER TABLE [dbo].[ITAsset]
    ADD [ProductFileName] NVARCHAR(255) NULL;
END
GO

-- Add SignatureFileOriginalName column if not exists
IF NOT EXISTS (
    SELECT * 
    FROM sys.columns 
    WHERE Name = N'SignatureFileOriginalName' 
      AND Object_ID = OBJECT_ID(N'[dbo].[ITAsset]')
)
BEGIN
    ALTER TABLE [dbo].[ITAsset]
    ADD [SignatureFileOriginalName] NVARCHAR(255) NULL;
END
GO

-- Add SignatureFileName column if not exists
IF NOT EXISTS (
    SELECT * 
    FROM sys.columns 
    WHERE Name = N'SignatureFileName' 
      AND Object_ID = OBJECT_ID(N'[dbo].[ITAsset]')
)
BEGIN
    ALTER TABLE [dbo].[ITAsset]
    ADD [SignatureFileName] NVARCHAR(255) NULL;
END
GO
-----------
IF EXISTS (
    SELECT * 
    FROM sys.columns 
    WHERE Name = N'OwnerId' 
      AND Object_ID = OBJECT_ID(N'[dbo].[GrievanceRemarks]')
)
BEGIN
    ALTER TABLE [dbo].[GrievanceRemarks]
    ALTER COLUMN [OwnerId] BIGINT  NULL;
END
GO
-----------KPIDetails------------------
ALTER TABLE [dbo].[KPIDetails]
ALTER COLUMN [Q1_Rating] DECIMAL(5,2) NULL;
ALTER TABLE [dbo].[KPIDetails]
ALTER COLUMN [Q2_Rating] DECIMAL(5,2) NULL;
ALTER TABLE [dbo].[KPIDetails]
ALTER COLUMN [Q3_Rating] DECIMAL(5,2) NULL;
ALTER TABLE [dbo].[KPIDetails]
ALTER COLUMN [Q4_Rating] DECIMAL(5,2) NULL;
ALTER TABLE [dbo].[KPIDetails]
ALTER COLUMN [EmployeeRating] DECIMAL(5,2) NULL;
ALTER TABLE [dbo].[KPIDetails]
ALTER COLUMN [ManagerRating] DECIMAL(5,2) NULL;

--------------------ManagerRatingHistory----------------------
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ManagerRatingHistory]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ManagerRatingHistory](
    [Id] [bigint] IDENTITY(1,1) NOT NULL,
    [PlanId] [bigint] NOT NULL,
    [GoalId] [bigint] NOT NULL,
    [ManagerId] [bigint] NOT NULL,
    [ManagerRating] [decimal](5,2) NULL,
    [ManagerComment] [nvarchar](max) NULL,
    [CreatedBy] [nvarchar](max) NOT NULL,
    [CreatedOn] [datetime] NOT NULL,
    [IsDeleted] [bit] NOT NULL DEFAULT 0,
CONSTRAINT [PK_ManagerRatingHistory] PRIMARY KEY CLUSTERED 
(
    [Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ManagerRatingHistory_KPIPlan_PlanId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ManagerRatingHistory]'))
BEGIN
ALTER TABLE [dbo].[ManagerRatingHistory] WITH CHECK ADD CONSTRAINT [FK_ManagerRatingHistory_KPIPlan_PlanId] FOREIGN KEY([PlanId])
REFERENCES [dbo].[KPIPlan] ([Id])
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ManagerRatingHistory_KPIGoals_GoalId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ManagerRatingHistory]'))
BEGIN
ALTER TABLE [dbo].[ManagerRatingHistory] WITH CHECK ADD CONSTRAINT [FK_ManagerRatingHistory_KPIGoals_GoalId] FOREIGN KEY([GoalId])
REFERENCES [dbo].[KPIGoals] ([Id])
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ManagerRatingHistory_EmployeeData_ManagerId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ManagerRatingHistory]'))
BEGIN
ALTER TABLE [dbo].[ManagerRatingHistory] WITH CHECK ADD CONSTRAINT [FK_ManagerRatingHistory_EmployeeData_ManagerId] FOREIGN KEY([ManagerId])
REFERENCES [dbo].[EmployeeData] ([Id])
END
GO
----------------UserGuide----------------

IF NOT EXISTS (
    SELECT * FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[UserGuide]') AND type = N'U'
)
BEGIN
    CREATE TABLE [dbo].[UserGuide] (
        [Id] [int] IDENTITY(1,1) NOT NULL,
        [MenuId] [bigint] NOT NULL,
        [RoleId] [int] NULL,
        [Title] [nvarchar](500) NOT NULL,
        [Content] [nvarchar](max) NOT NULL,
        [IsDeleted] [bit]  NULL,
        [Status] [tinyInt] NOT NULL,
        [CreatedOn] [datetime] NULL,
        [CreatedBy] [nvarchar](100) NULL,
        [ModifiedBy] [nvarchar](100) NULL,
        [ModifiedOn] [datetime] NULL,
        CONSTRAINT [PK_UserGuide] PRIMARY KEY CLUSTERED ([Id] ASC)
    ) ON [PRIMARY]
END
GO

-- Foreign key from Menu table
IF NOT EXISTS (
    SELECT * FROM sys.foreign_keys 
    WHERE object_id = OBJECT_ID(N'[dbo].[FK_UserGuide_Menu_MenuId]') 
    AND parent_object_id = OBJECT_ID(N'[dbo].[UserGuide]')
)
BEGIN
    ALTER TABLE [dbo].[UserGuide] WITH CHECK 
    ADD CONSTRAINT [FK_UserGuide_Menu_MenuId] 
    FOREIGN KEY ([MenuId]) REFERENCES [dbo].[Menu] ([Id])
END
GO

BEGIN
    ALTER TABLE [dbo].[UserGuide] WITH CHECK 
    ADD CONSTRAINT [FK_UserGuide_Department_DepartmentId] 
    FOREIGN KEY ([DepartmentId]) REFERENCES [dbo].[Department] ([Id])
END
GO

-- Foreign key from Role table
IF NOT EXISTS (
    SELECT * FROM sys.foreign_keys 
    WHERE object_id = OBJECT_ID(N'[dbo].[FK_UserGuide_Role_RoleId]') 
    AND parent_object_id = OBJECT_ID(N'[dbo].[UserGuide]')
)
BEGIN
    ALTER TABLE [dbo].[UserGuide] WITH CHECK 
    ADD CONSTRAINT [FK_UserGuide_Role_RoleId] 
    FOREIGN KEY ([RoleId]) REFERENCES [dbo].[Role] ([Id])
END
GO


----------------Feedback-------------------------
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Feedback]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Feedback](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[EmployeeId] [bigint] NOT NULL,
	[TicketStatus] [tinyint] NOT NULL,
	[FeedbackType] [tinyint] NOT NULL,
	[Subject] [varchar](max) NOT NULL,
	[Description] [varchar](max) NOT NULL,
	[AdminComment] [varchar](max) NULL,
	[AttachmentPath] [varchar](max) NULL,
	[FileOriginalName] [varchar](max) NULL,
	[CreatedBy] [nvarchar](250) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [nvarchar](250) NULL,
	[ModifiedOn] [datetime] NULL,
    [IsDeleted] [bit] NOT NULL DEFAULT 0,
 CONSTRAINT [PK_Feedback] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Feedback_EmployeeData_EmployeeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Feedback]'))
ALTER TABLE [dbo].[Feedback] WITH CHECK ADD CONSTRAINT [FK_Feedback_EmployeeData_EmployeeId] FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[EmployeeData]([Id])
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Feedback_EmployeeData_EmployeeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Feedback]'))
ALTER TABLE [dbo].[Feedback] CHECK CONSTRAINT [FK_Feedback_EmployeeData_EmployeeId]
GO