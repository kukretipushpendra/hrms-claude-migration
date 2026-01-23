-------------------------------KPIGoals-----------------------------------------

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[KPIGoals]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[KPIGoals](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](max) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[DepartmentId] [bigint] NOT NULL,
	[CreatedBy] [nvarchar](255) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [nvarchar](255) NULL,
	[ModifiedOn] [datetime] NULL,
	[IsDeleted] [bit] NOT NULL DEFAULT (0),
 CONSTRAINT [PK_KPIGoals] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_KPIGoals_Department_DepartmentId]') AND parent_object_id = OBJECT_ID(N'[dbo].[KPIGoals]'))
ALTER TABLE [dbo].[KPIGoals] CHECK CONSTRAINT [FK_KPIGoals_Department_DepartmentId]
GO

----------------------------------------KPIPlan--------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[KPIPlan]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[KPIPlan](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[EmployeeId] [bigint] NOT NULL,
	[AppraisalCycle] [nvarchar](50) NULL,
	[AppraisalDate] [date] NULL,
	[IsReviewed] [bit] NULL,
	[ReviewDate] [date] NULL,
	[OverallProgress] [nvarchar](max) NULL,
	[AppraisalNote] [nvarchar](max) NULL,
	[AppraisalAttachment] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](255) NOT NULL,
	[CreatedOn] [datetime] NOT NULL DEFAULT (GETDATE()),
	[ModifiedBy] [nvarchar](255) NULL,
	[ModifiedOn] [datetime] NULL DEFAULT (CURRENT_TIMESTAMP),
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_KPIPlan] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_KPIPlan_EmployeeData_EmployeeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[KPIPlan]'))
ALTER TABLE [dbo].[KPIPlan] CHECK CONSTRAINT [FK_KPIPlan_EmployeeData_EmployeeId]
GO

-------------------------------KPIDetails----------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[KPIDetails]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[KPIDetails](
	  [Id] [bigint] IDENTITY(1,1) NOT NULL,
	  [PlanId] [bigint] NOT NULL,
	  [GoalId] [bigint] NOT NULL,
	  [Q1_Rating] [float] NULL,
	  [Q2_Rating] [float] NULL,
	  [Q3_Rating] [float] NULL,
	  [Q4_Rating] [float] NULL,
	  [Q1_Note] [nvarchar](max) NULL,
	  [Q2_Note] [nvarchar](max) NULL,
	  [Q3_Note] [nvarchar](max) NULL,
	  [Q4_Note] [nvarchar](max) NULL,
	  [Status] [bit] NULL,
	  [AllowedQuarter] [nvarchar](100) NULL,
	  [TargetExpected] [nvarchar](max) NULL,
	  [EmployeeRating] [float] NULL,
	  [ManagerRating] [float] NULL,
	  [EmployeeNote] [nvarchar](max) NULL,
	  [ManagerNote] [nvarchar](max) NULL,
	  [CreatedBy] [nvarchar](250) NOT NULL,
	  [CreatedOn] [datetime] NOT NULL,
	  [ModifiedBy] [nvarchar](250) NULL,
	  [ModifiedOn] [datetime] NULL,
	  [IsDeleted] [bit] NULL,
CONSTRAINT [PK_KPIDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_KPIDetails_KPIPlan_PlanID]') AND parent_object_id = OBJECT_ID(N'[dbo].[KPIDetails]'))
ALTER TABLE [dbo].[KPIDetails] CHECK CONSTRAINT [FK_KPIDetails_KPIPlan_PlanID]
GO

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_KPIDetails_KPIGoals_GoalID]') AND parent_object_id = OBJECT_ID(N'[dbo].[KPIDetails]'))
ALTER TABLE [dbo].[KPIDetails] CHECK CONSTRAINT [FK_KPIDetails_KPIGoals_GoalID]
GO
GO
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

--------------------------------ITAssetHistory------------------------------------
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ITAssetHistory]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[ITAssetHistory] (
        [Id] [int] IDENTITY(1,1) NOT NULL,
        [AssetId] [bigint] NOT NULL,
        [EmployeeId] [bigint] NULL,
        [Status] [tinyint] NOT NULL,      
        [AssetCondition] [tinyint] NOT NULL,    
        [Note] [nvarchar](255) NULL,
        [CreatedBy] [nvarchar](100) NOT NULL,
        [CreatedOn] [datetime] NOT NULL,
        [ModifiedBy] [nvarchar](100) NULL,
        [ModifiedOn] [datetime] NULL,
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
-------EmploymentDetail Column Added-----------
-- Step 1: Add the new column if it doesn't exist
IF COL_LENGTH('dbo.EmploymentDetail', 'ImmediateManager') IS NULL
BEGIN
    ALTER TABLE [dbo].[EmploymentDetail]
    ADD ImmediateManager BIGINT NULL;
END
GO

-- Step 2: Create the FK constraint (to EmployeeData.Id) if not exists
IF NOT EXISTS (
    SELECT * FROM sys.foreign_keys 
    WHERE object_id = OBJECT_ID(N'[dbo].[FK_EmploymentDetail_EmployeeData_ImmediateManager]') 
      AND parent_object_id = OBJECT_ID(N'[dbo].[EmploymentDetail]')
)
BEGIN
    ALTER TABLE [dbo].[EmploymentDetail]  WITH CHECK 
    ADD CONSTRAINT [FK_EmploymentDetail_EmployeeData_ImmediateManager] 
    FOREIGN KEY([ImmediateManager]) REFERENCES [dbo].[EmployeeData] ([Id]);
END
GO

-- Step 3: Enable the constraint if it exists
IF EXISTS (
    SELECT * FROM sys.foreign_keys 
    WHERE object_id = OBJECT_ID(N'[dbo].[FK_EmploymentDetail_EmployeeData_ImmediateManager]') 
      AND parent_object_id = OBJECT_ID(N'[dbo].[EmploymentDetail]')
)
BEGIN
    ALTER TABLE [dbo].[EmploymentDetail] 
    CHECK CONSTRAINT [FK_EmploymentDetail_EmployeeData_ImmediateManager];
END
GO

IF NOT EXISTS (SELECT ID FROM Menu WHERE [NAME] = 'Cron Jobs') BEGIN
	INSERT INTO Menu ([Name], ApiEndPoint, ParentMenuId, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn, IsDeleted, OrderNo) 
	VALUES
	('Cron Jobs', '/api/', 25, 'admin', GETDATE(), NULL, NULL, 0, NULL)
END


-------------------------------CronJobLog----------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CronJobLog]') AND type in (N'U'))
BEGIN
CREATE TABLE CronJobLog (
	Id BIGINT PRIMARY KEY IDENTITY(1,1),
	TypeId INT NULL,
	RequestId VARCHAR(128) NULL,
	StartedAt DATETIME NULL, 
	CompletedAt DATETIME NULL, 
	Payload VARCHAR(1024) NULL,
	[CreatedBy] [nvarchar](250) NOT NULL,
	[CreatedOn] [datetime] NOT NULL DEFAULT GETDATE(),
	[ModifiedBy] [nvarchar](250) NULL,
	[ModifiedOn] [datetime] NULL
)
END
GO
--------------------------------Grievance---------------------------------------

------------------------------ GrievanceTypeTable ------------------------------

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GrievanceType]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[GrievanceType] (
        [Id] BIGINT IDENTITY(1,1) NOT NULL,
        [GrievanceName] NVARCHAR(255) NOT NULL,
        [L1TatHours] INT NOT NULL,
        [L2TatHours] INT NOT NULL,
        [L3TatDays] INT NOT NULL,
        [Description] NVARCHAR(250) NULL,
        [IsActive] BIT NOT NULL,
        [CreatedBy] NVARCHAR(100) NOT NULL,
        [CreatedOn] DATETIME NOT NULL,
        [ModifiedBy] NVARCHAR(100) NULL,
        [ModifiedOn] DATETIME NULL,
		[IsAutoEscalation] bit
        CONSTRAINT [PK_GrievanceType] PRIMARY KEY CLUSTERED ([Id] ASC)
    ) ON [PRIMARY]
END
GO

------------------------------ GrievanceOwner Table ------------------------------

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GrievanceOwner]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[GrievanceOwner] (
        [Id] BIGINT IDENTITY(1,1) NOT NULL,
        [GrievanceTypeId] BIGINT NOT NULL,
        [Level] TINYINT NOT NULL,
        [OwnerID] BIGINT NOT NULL,
        [CreatedBy] NVARCHAR(100) NOT NULL,
        [CreatedOn] DATETIME NOT NULL,
        [ModifiedBy] NVARCHAR(100) NULL,
        [ModifiedOn] DATETIME NULL,
        [IsDeleted] BIT NOT NULL
        CONSTRAINT [PK_GrievanceOwner] PRIMARY KEY CLUSTERED ([Id] ASC)
    ) ON [PRIMARY]
END
GO

IF NOT EXISTS (
    SELECT * FROM sys.foreign_keys 
    WHERE name = N'FK_GrievanceOwner_GrievanceType'
)
BEGIN
    ALTER TABLE [dbo].[GrievanceOwner] WITH CHECK
    ADD CONSTRAINT FK_GrievanceOwner_GrievanceType
    FOREIGN KEY ([GrievanceTypeId]) REFERENCES [dbo].[GrievanceType]([Id])
END
GO

IF NOT EXISTS (
    SELECT * FROM sys.foreign_keys 
    WHERE name = N'FK_GrievanceOwner_EmployeeData'
)
BEGIN
    ALTER TABLE [dbo].[GrievanceOwner] WITH CHECK
    ADD CONSTRAINT FK_GrievanceOwner_EmployeeData
    FOREIGN KEY ([OwnerID]) REFERENCES [dbo].[EmployeeData]([Id])
END
GO

------------------------------ EmployeeGrievance Table ------------------------------

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeGrievance]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[EmployeeGrievance] (
        [Id] BIGINT IDENTITY(1,1) NOT NULL,
        [TicketNo] NVARCHAR(50) NOT NULL UNIQUE,
        [GrievanceTypeId] BIGINT NOT NULL,
        [Level] TINYINT NOT NULL,
        [EmployeeId] BIGINT NOT NULL,
        [Title] NVARCHAR(255) NOT NULL,
        [Description] NVARCHAR(MAX) NOT NULL,
        [AttachmentPath] NVARCHAR(500) NULL,
        [FileOriginalName] NVARCHAR(255) NULL,
        [Status] TINYINT NOT NULL,
        [TatStatus] TINYINT NOT NULL,
        [ResolvedBy] BIGINT NULL,
        [ResolvedDate] DATETIME NULL,
        [CreatedBy] NVARCHAR(100) NOT NULL,
        [CreatedOn] DATETIME NOT NULL,
        [ModifiedBy] NVARCHAR(100) NULL,
        [ModifiedOn] DATETIME NULL,
        CONSTRAINT [PK_EmployeeGrievance] PRIMARY KEY CLUSTERED ([Id] ASC)
    ) ON [PRIMARY]
END
GO

IF NOT EXISTS (
    SELECT * FROM sys.foreign_keys 
    WHERE name = N'FK_EmployeeGrievance_EmployeeData'
)
BEGIN
    ALTER TABLE [dbo].[EmployeeGrievance] WITH CHECK
    ADD CONSTRAINT FK_EmployeeGrievance_EmployeeData
    FOREIGN KEY ([EmployeeId]) REFERENCES [dbo].[EmployeeData]([Id])
END
GO

IF NOT EXISTS (
    SELECT * FROM sys.foreign_keys 
    WHERE name = N'FK_EmployeeGrievance_GrievanceType'
)
BEGIN
    ALTER TABLE [dbo].[EmployeeGrievance] WITH CHECK
    ADD CONSTRAINT FK_EmployeeGrievance_GrievanceType
    FOREIGN KEY ([GrievanceTypeId]) REFERENCES [dbo].[GrievanceType]([Id])
END
GO

IF NOT EXISTS (
    SELECT * FROM sys.foreign_keys 
    WHERE name = N'FK_EmployeeGrievance_ResolvedBy'
)
BEGIN
    ALTER TABLE [dbo].[EmployeeGrievance] WITH CHECK
    ADD CONSTRAINT FK_EmployeeGrievance_ResolvedBy
    FOREIGN KEY ([ResolvedBy]) REFERENCES [dbo].[EmployeeData]([Id])
END
GO
------------Grievance Remarks Table------------------------------------
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GrievanceRemarks]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[GrievanceRemarks] (
        [Id] BIGINT IDENTITY(1,1) NOT NULL,
        [TicketId] BIGINT NOT NULL,                          -- FK to EmployeeGrievance(Id)
        [OwnerId] BIGINT NOT NULL,                           -- FK to EmployeeData(Id)
        [Remarks] NVARCHAR(MAX) NOT NULL,                    -- The actual remark content
        [AttachmentPath] NVARCHAR(500) NULL,                 -- Path to any attachment
        [FileOriginalName] NVARCHAR(255) NULL,               -- Original filename
        [Status] TINYINT NOT NULL, 
        [CreatedBy] NVARCHAR(100) NOT NULL,                  -- Creator details
        [CreatedOn] DATETIME NOT NULL,
        [ModifiedBy] NVARCHAR(100) NULL,
        [ModifiedOn] DATETIME NULL,
        CONSTRAINT [PK_GrievanceRemarks] PRIMARY KEY CLUSTERED ([Id] ASC)
    ) ON [PRIMARY]
END
GO

-- Foreign key to EmployeeGrievance
IF NOT EXISTS (
    SELECT * FROM sys.foreign_keys 
    WHERE name = N'FK_GrievanceRemarks_EmployeeGrievance'
)
BEGIN
    ALTER TABLE [dbo].[GrievanceRemarks] WITH CHECK
    ADD CONSTRAINT FK_GrievanceRemarks_EmployeeGrievance
    FOREIGN KEY ([TicketId]) REFERENCES [dbo].[EmployeeGrievance]([Id])
END
GO

-- Foreign key to EmployeeData for Owner
IF NOT EXISTS (
    SELECT * FROM sys.foreign_keys 
    WHERE name = N'FK_GrievanceRemarks_EmployeeData'
)
BEGIN
    ALTER TABLE [dbo].[GrievanceRemarks] WITH CHECK
    ADD CONSTRAINT FK_GrievanceRemarks_EmployeeData
    FOREIGN KEY ([OwnerId]) REFERENCES [dbo].[EmployeeData]([Id])
END
GO
