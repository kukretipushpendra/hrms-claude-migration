
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GroupUserMapping]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[GroupUserMapping](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[GroupId] [bigint]  NOT NULL,
	[EmployeeId] [bigint]  NULL,
	[CreatedBy] [nvarchar](250) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [nvarchar](250) NULL,
	[ModifiedOn] [datetime] NULL,
	[IsDeleted] [bit] NOT NULL, 
 CONSTRAINT [PK_GroupMapping] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
End
GO
 
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GroupUserMapping_EmployeeData_EmployeeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[GroupUserMapping]'))
ALTER TABLE [dbo].[GroupUserMapping]  WITH CHECK ADD  CONSTRAINT [FK_GroupUserMapping_EmployeeData_EmployeeId] FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[EmployeeData] ([Id])
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GroupUserMapping_Group_EmployeeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[GroupUserMapping]'))
ALTER TABLE [dbo].[GroupUserMapping]  WITH CHECK ADD  CONSTRAINT [FK_GroupUserMapping_Group_EmployeeId] FOREIGN KEY([GroupId])
REFERENCES [dbo].[Group] ([Id])
GO


 -----------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'DesignationId' AND Object_ID = OBJECT_ID(N'[EmploymentDetail]'))
BEGIN
    ALTER TABLE [EmploymentDetail] ADD DesignationId BIGINT NULL; 
END
GO
IF  EXISTS (SELECT * FROM sys.columns WHERE Name = N'EmployeeCode' AND Object_ID = OBJECT_ID(N'[EmployeeData]'))
BEGIN
    ALTER TABLE [EmployeeData] ALTER COLUMN EmployeeCode VARCHAR(20) NULL; 
END
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Resignation]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Resignation](
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [EmployeeId] [bigint] NOT NULL,
    [DepartmentID] [bigint] NOT NULL,
	[ReportingManagerId] [bigint]  NULL,
    [LastWorkingDay] [date]  NULL,
    [Reason] [varchar](500) NOT NULL,
    [ExitDiscussion] [bit]  NULL,
    [Status] [tinyInt]  NULL,
    [Process] [varchar](50) NULL,
    [ProcessedBy] [bigint] NULL,
    [ProcessedAt] [datetime] NULL,
    [SettlementStatus] [varchar](50) NULL,
    [SettlementDate] [datetime] NULL,
    [IsActive][bit] Null,
    [EarlyReleaseDate][datetime] Null,
    [EarlyReleaseStatus] [tinyint] NULL  ,
    [ModifiedOn] [datetime] NULL,
    [ModifiedBy] [varchar](100) NULL,
    [CreatedOn] [datetime] NOT NULL,
    [CreatedBy] [varchar](100) NOT NULL,
	 
CONSTRAINT [PK_Resignation] PRIMARY KEY CLUSTERED 
(   [Id] ASC 
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Resignation_EmployeeData_EmployeeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Resignation]'))
ALTER TABLE [dbo].[Resignation] WITH CHECK ADD CONSTRAINT [FK_Resignation_EmployeeData_EmployeeId] FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[EmployeeData] (Id)
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Resignation_Department_DepartmentID]') AND parent_object_id = OBJECT_ID(N'[dbo].[Resignation]'))
ALTER TABLE [dbo].[Resignation] WITH CHECK ADD CONSTRAINT [FK_Resignation_Department_DepartmentID] FOREIGN KEY([DepartmentID])
REFERENCES [dbo].[Department] (Id)
 
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ResignationHistory]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[ResignationHistory](
        [Id] [BIGINT] IDENTITY(1,1) NOT NULL,
        [ResignationId] [int] NULL,
        [CreatedOn] [datetime] NOT NULL,
        [CreatedBy] [varchar](100) NOT NULL,
        [ResignationStatus] [tinyInt] NOT NULL ,
    [EarlyReleaseStatus] [tinyint] NULL  
        
 CONSTRAINT [PK_ResignationHistory] PRIMARY KEY CLUSTERED 
( 
    [Id] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ResignationHistory_Resignation_ResignationId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ResignationHistory]'))
ALTER TABLE [dbo].[ResignationHistory] WITH CHECK ADD CONSTRAINT [FK_ResignationHistory_Resignation_ResignationId] FOREIGN KEY([ResignationId])
REFERENCES [dbo].[Resignation] (Id)
GO
