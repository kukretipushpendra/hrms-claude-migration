GO
IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'IsManualAttendance' AND Object_ID = OBJECT_ID(N'[EmploymentDetail]'))
BEGIN
ALTER TABLE EmploymentDetail ADD  IsManualAttendance BIT NOT NULL DEFAULT 0;
END

GO
IF NOT EXISTS ( SELECT *  FROM sys.columns WHERE Name = N'RejectResignationReason'  AND Object_ID = OBJECT_ID(N'[Resignation]'))
BEGIN
 ALTER TABLE Resignation ADD RejectResignationReason TEXT;
END

GO
IF NOT EXISTS ( SELECT * FROM sys.columns WHERE Name = N'RejectEarlyReleaseReason' AND Object_ID = OBJECT_ID(N'[Resignation]'))
BEGIN
 ALTER TABLE Resignation ADD RejectEarlyReleaseReason TEXT;
END
-------------HR Clearance---------------
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HRClearance]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[HRClearance](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[ResignationId] [int] NOT NULL,
	[AdvanceBonusRecoveryAmount] [decimal](18,2) NOT NULL,
	[ServiceAgreementDetails] [Text] NULL,
	[CurrentEL] [decimal](5,2)  NULL,
	[NumberOfBuyOutDays] [decimal](5,2) NOT NULL,
	[ExitInterviewStatus] [bit]  NULL,
	[ExitInterviewDetails] [nvarchar](max)  NULL,
	[Attachment] [nvarchar](max) NOT NULL,	 
    [CreatedBy] [nvarchar](250) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [nvarchar](250) NULL,
	[ModifiedOn] [datetime] NULL,
 CONSTRAINT [PK_HRClearance] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_HRClearance_Resignation_ResignationId]') AND parent_object_id = OBJECT_ID(N'[dbo].[HRClearance]'))
ALTER TABLE [dbo].[HRClearance] WITH CHECK ADD CONSTRAINT [FK_HRClearance_Resignation_ResignationId] FOREIGN KEY([ResignationId])
REFERENCES [dbo].[Resignation] ([Id])
GO
----------Department Clearance--------
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DepartmentClearance]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DepartmentClearance](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[ResignationId] [int] NOT NULL,
	[KTStatus] [tinyInt]  NULL,
	[KTNotes] [nvarchar](max) NOT NULL,
	[Attachment] [nvarchar](max) NOT NULL,
	[KTUsers] [varchar](max) NOT NULL,
	[CreatedBy] [nvarchar](250) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [nvarchar](250) NULL,
	[ModifiedOn] [datetime] NULL,
 CONSTRAINT [PK_DepartmentClearance] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_DepartmentClearance_Resignation_ResignationId]') AND parent_object_id = OBJECT_ID(N'[dbo].[DepartmentClearance]'))
ALTER TABLE [dbo].[DepartmentClearance] WITH CHECK ADD CONSTRAINT [FK_DepartmentClearance_Resignation_ResignationId] FOREIGN KEY([ResignationId])
REFERENCES [dbo].[Resignation] ([Id])
GO

------------------AccountClearance---------------------------
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AccountClearance]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AccountClearance](
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [ResignationId] [int] NOT NULL,
    [FnFStatus] [bit] NULL,
    [FnFAmount] [decimal](18,2) NULL,
    [IssueNoDueCertificate] [bit] NULL,
    [Note] [nvarchar](max) NULL,
    [AccountAttachment] [varchar](255) NULL,
    [CreatedBy] [varchar](100) NOT NULL,
    [CreatedOn] [datetime] NOT NULL,
    [ModifiedBy] [varchar](100) NULL,
    [ModifiedOn] [datetime] NULL,
         
CONSTRAINT [PK_AccountClearance] PRIMARY KEY CLUSTERED 
(
    [Id] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_AccountClearance_Resignation]') AND parent_object_id = OBJECT_ID(N'[dbo].[AccountClearance]'))
ALTER TABLE [dbo].[AccountClearance] WITH CHECK ADD CONSTRAINT [FK_AccountClearance_Resignation] FOREIGN KEY([ResignationId])
REFERENCES [dbo].[Resignation] ([Id])
GO


--------------AssetCondition--------------

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AssetCondition]') AND type IN (N'U'))
BEGIN
    CREATE TABLE [dbo].[AssetCondition] (
        [Id] INT NOT NULL,
        [Status] NVARCHAR(50) NOT NULL,
        [CreatedBy] NVARCHAR(255) NULL,
        [CreatedOn] DATETIME NULL,
        CONSTRAINT [PK_AssetCondition] PRIMARY KEY CLUSTERED 
        (
            [Id] ASC
        ) WITH (
            PAD_INDEX = OFF, 
            STATISTICS_NORECOMPUTE = OFF, 
            IGNORE_DUP_KEY = OFF, 
            ALLOW_ROW_LOCKS = ON, 
            ALLOW_PAGE_LOCKS = ON
        ) ON [PRIMARY]
    ) ON [PRIMARY]
END
GO

---------------ITClearance------------------
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ITClearance]') AND type IN (N'U'))
BEGIN
    CREATE TABLE [dbo].[ITClearance] (
        [Id] INT IDENTITY(1,1) NOT NULL,
        [ResignationId] INT NOT NULL,
        [AccessRevoked] BIT NOT NULL DEFAULT 0,
        [AssetReturned] BIT NOT NULL DEFAULT 0,
        [AssetCondition] INT NOT NULL, 
        [AttachmentUrl] VARCHAR(255) NULL, 
        [Note] NVARCHAR(MAX) NULL,
        [ITClearanceCertification] BIT NOT NULL DEFAULT 0,
        [CreatedBy] NVARCHAR(100) NOT NULL,
        [CreatedOn] DATETIME NOT NULL DEFAULT GETUTCDATE(),        
        [ModifiedBy] VARCHAR(100) NULL,
        [ModifiedOn] DATETIME NULL,
        
        CONSTRAINT [PK_ITClearance] PRIMARY KEY CLUSTERED 
        (
            [Id] ASC
        ) WITH (
            PAD_INDEX = OFF, 
            STATISTICS_NORECOMPUTE = OFF, 
            IGNORE_DUP_KEY = OFF, 
            ALLOW_ROW_LOCKS = ON, 
            ALLOW_PAGE_LOCKS = ON
        ) ON [PRIMARY]
    ) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ITClearance_Resignation]') AND parent_object_id = OBJECT_ID(N'[dbo].[ITClearance]'))
BEGIN
    ALTER TABLE [dbo].[ITClearance] WITH CHECK ADD CONSTRAINT [FK_ITClearance_Resignation] FOREIGN KEY([ResignationId])
    REFERENCES [dbo].[Resignation] ([Id])
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ITClearance_AssetCondition]') AND parent_object_id = OBJECT_ID(N'[dbo].[ITClearance]'))
BEGIN
    ALTER TABLE [dbo].[ITClearance] WITH CHECK ADD CONSTRAINT [FK_ITClearance_AssetCondition] FOREIGN KEY([AssetCondition])
    REFERENCES [dbo].[AssetCondition] ([Id])
END
GO


IF EXISTS (SELECT * FROM sys.columns WHERE Name = N'IsEarlyRequestRelease' AND Object_ID = OBJECT_ID(N'[Resignation]'))
BEGIN
ALTER TABLE Resignation DROP COLUMN IsEarlyRequestRelease
END
IF EXISTS (SELECT * FROM sys.columns WHERE Name = N'IsEarlyRequestApproved' AND Object_ID = OBJECT_ID(N'[Resignation]'))
BEGIN
ALTER TABLE Resignation DROP COLUMN IsEarlyRequestApproved
END
IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'IsEarlyReleaseApproved' AND Object_ID = OBJECT_ID(N'[Resignation]'))
BEGIN
ALTER TABLE [Resignation]
ADD IsEarlyReleaseApproved BIT NULL;
END
IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'IsEarlyReleaseApproved' AND Object_ID = OBJECT_ID(N'[ResignationHistory]'))
BEGIN
ALTER TABLE ResignationHistory
ADD IsEarlyReleaseApproved BIT NULL;
END
GO
IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'TimeDoctorUserId' AND Object_ID = OBJECT_ID(N'[EmploymentDetail]'))
BEGIN
ALTER TABLE EmploymentDetail ADD TimeDoctorUserId VARCHAR(20) NULL DEFAULT NULL
END

 GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeLeave]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[EmployeeLeave](
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [EmployeeId] [Bigint] NOT NULL,
    [LeaveId] [int] NOT NULL,
    [OpeningBalance] [int] NOT NULL,
    [LeaveDate] [date] NOT NULL,
    [IsActive] [bit] NULL,
    [ModifiedOn] [datetime] NULL,
    [ModifiedBy] [datetime]  NULL,
    [CreatedOn] [datetime] NOT NULL,
    [CreatedBy]  [varchar](100) NOT NULL,
	 
CONSTRAINT [PK_EmployeeLeave] PRIMARY KEY CLUSTERED 
(   [Id] ASC 
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_EmployeeLeave_EmployeeData_EmployeeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[EmployeeLeave]'))
ALTER TABLE [dbo].[EmployeeLeave] WITH CHECK ADD CONSTRAINT [FK_EmployeeLeave_EmployeeData_EmployeeId] FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[EmployeeData] (Id)
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_EmployeeLeave_LeaveType_LeaveId]') AND parent_object_id = OBJECT_ID(N'[dbo].[EmployeeLeave]'))
ALTER TABLE [dbo].[EmployeeLeave] WITH CHECK ADD CONSTRAINT [FK_EmployeeLeave_LeaveType_LeaveId] FOREIGN KEY([LeaveId])
REFERENCES [dbo].[LeaveType] (Id)

 GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LeaveType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[LeaveType](
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [Title] [varchar](50) NOT NULL,
	[ShortName] [varchar](10) NOT NULL,
    [CreatedBy]  [varchar](100) NOT NULL,
    [CreatedOn] [datetime] NOT NULL,
    [ModifiedBy]  [varchar](100) NULL,
    [ModifiedOn] [datetime] NULL,
    [IsDeleted] [bit] NULL,
	 
    CONSTRAINT [PK_LeaveType] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [UQ_LeaveType_ShortName] UNIQUE ([ShortName])
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AppliedLeaves]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AppliedLeaves](
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [EmployeeId] [bigint] NOT NULL,
    [LeaveId] [int] NOT NULL,
    [ReportingManagerId] [bigint] NOT NULL,
    [Status] varchar(50) NOT NULL,
    [Reason] varchar(500) NULL,
    [AttachmentPath] Nvarchar(100) NULL,
    [CreatedOn] [datetime] NOT NULL,
    [CreatedBy]varchar(100) NOT NULL,
    [ModifiedOn][datetime] NULL,
    [ModifiedBy]varchar(50)NULL,	 
CONSTRAINT [PK_AppliedLeaves] PRIMARY KEY CLUSTERED 
(   [Id] ASC 
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_AppliedLeaves_EmployeeData_EmployeeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[AppliedLeaves]'))
ALTER TABLE [dbo].[AppliedLeaves] WITH CHECK ADD CONSTRAINT [FK_AppliedLeaves_EmployeeData_EmployeeId] FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[EmployeeData] (Id)
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_AppliedLeaves_LeaveType_LeaveId]') AND parent_object_id = OBJECT_ID(N'[dbo].[AppliedLeaves]'))
ALTER TABLE [dbo].[AppliedLeaves] WITH CHECK ADD CONSTRAINT [FK_AppliedLeaves_LeaveType_LeaveId] FOREIGN KEY([LeaveId])
REFERENCES [dbo].[LeaveType] (Id)
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_AppliedLeaves_EmploymentDetail_ReportingMangerId]') AND parent_object_id = OBJECT_ID(N'[dbo].[AppliedLeaves]'))
ALTER TABLE [dbo].[AppliedLeaves] WITH CHECK ADD CONSTRAINT [FK_AppliedLeaves_EmploymentDetail_ReportingMangerId] FOREIGN KEY([ReportingManagerId])
REFERENCES [dbo].[EmploymentDetail] (Id)
Go