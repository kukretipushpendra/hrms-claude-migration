IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DowntownData]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DowntownData](
    [Id] [bigint] IDENTITY(1,1) NOT NULL,
    [First_Name] [varchar](50) NOT NULL,    
    [Last_Name] [varchar](50) NULL,     
    [Photo] [varchar](100) NULL,
    [Gender] [varchar] (50) NULL,   
    [DOB] [varchar] (50) NULL,
    [Phone] [varchar](20) NULL,
    [Alternate_Phone_Number] [varchar](20) NULL,
    [Email] [varchar](100) NOT NULL,
    [Address] text NULL,
    [Country] [varchar](50) NULL,
    [Joining_date] [varchar] (50) NULL,
    [Branch_title] [varchar] (250) NULL,
    [Team_id] [bigint] NULL,
    [Team_Title] [varchar] (50)  NULL,
    [Designation] [varchar] (100) NULL,
    [Status] [varchar](50) NULL,
    [IsSynched] [bit] NULL,
    [Created_at] datetime NULL,
    [Updated_at] datetime NULL,
    [deleted_at] datetime NULL, 
 CONSTRAINT [PK_DowntownData] PRIMARY KEY CLUSTERED 
(
    [Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF  EXISTS (SELECT * FROM sys.columns WHERE Name = N'Phone' AND Object_ID = OBJECT_ID(N'[EmployeeData]'))
BEGIN
ALTER TABLE [EmployeeData] ALTER COLUMN[Phone] varchar(20) NUll;
END
GO

IF  EXISTS (SELECT * FROM sys.columns WHERE Name = N'AlternatePhone' AND Object_ID = OBJECT_ID(N'[EmployeeData]'))
BEGIN
ALTER TABLE [EmployeeData] ALTER COLUMN[AlternatePhone] varchar(20) NUll;
END
GO

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Address_City_CityId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Address]'))
ALTER TABLE Address DROP CONSTRAINT  [FK_Address_City_CityId]  
GO

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Address_State_StateId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Address]'))
ALTER TABLE Address DROP CONSTRAINT  [FK_Address_State_StateId]  
GO

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Address_Country_CountryId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Address]'))
ALTER TABLE Address DROP CONSTRAINT  [FK_Address_Country_CountryId]  
GO

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_EmploymentDetail_BranchId]') AND parent_object_id = OBJECT_ID(N'[dbo].[EmploymentDetail]'))
ALTER TABLE EmploymentDetail DROP CONSTRAINT  [FK_EmploymentDetail_BranchId]  
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'OrderNo' AND Object_ID = OBJECT_ID(N'[Menu]'))
BEGIN
ALTER TABLE [Menu] Add  OrderNo INT  NULL
END
GO 

IF EXISTS (SELECT * FROM sys.columns WHERE Name = N'DOB' AND Object_ID = OBJECT_ID(N'[DowntownData]'))
BEGIN
ALTER TABLE [DowntownData] Drop column DOB
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'DOB' AND Object_ID = OBJECT_ID(N'[DowntownData]'))
BEGIN
ALTER TABLE [DowntownData] ADD  DOB date NUll 
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'ExitDate' AND Object_ID = OBJECT_ID(N'[EmploymentDetail]'))
BEGIN
ALTER TABLE [dbo].[EmploymentDetail] ADD [ExitDate] [date] NULL
END
GO

----------------------

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeStatus]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[EmployeeStatus](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Status] [varchar](100) NOT NULL, 
	[CreatedBy] [nvarchar](250) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [nvarchar](250) NULL,
	[ModifiedOn] [datetime] NULL,
	[IsDeleted] [bit] NOT NULL,
CONSTRAINT [PK_EmployeeStatus] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] 
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Department]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Department](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Department] [varchar](100) NOT NULL, 
	[CreatedBy] [nvarchar](250) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [nvarchar](250) NULL,
	[ModifiedOn] [datetime] NULL,
	[IsDeleted] [bit] NOT NULL,
CONSTRAINT [PK_Department] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] 
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Team]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Team](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[TeamName] [varchar](100) NOT NULL, 
	[CreatedBy] [nvarchar](250) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [nvarchar](250) NULL,
	[ModifiedOn] [datetime] NULL,
	[IsDeleted] [bit] NOT NULL,
CONSTRAINT [PK_Team] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] 
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmploymentStatus]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[EmploymentStatus](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Status] [varchar](100) NOT NULL, 
	[CreatedBy] [nvarchar](250) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [nvarchar](250) NULL,
	[ModifiedOn] [datetime] NULL,
	[IsDeleted] [bit] NOT NULL,
CONSTRAINT [PK_EmploymentStatus] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] 
END

GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'IsDeleted' AND Object_ID = OBJECT_ID(N'[EventDocument]'))
BEGIN
 ALTER TABLE [EventDocument] 
 ADD [IsDeleted] bit NOT NULL DEFAULT 0;
END
GO

IF  EXISTS (SELECT * FROM sys.columns WHERE Name = N'EmergencyContactNo' AND Object_ID = OBJECT_ID(N'[EmployeeData]'))
BEGIN
ALTER TABLE [EmployeeData] Alter column  EmergencyContactNo VARCHAR(20) NULL 
END
GO

GO
IF  EXISTS (SELECT * FROM sys.columns WHERE Name = N'ContactNumber' AND Object_ID = OBJECT_ID(N'[ProfessionalReference]'))
BEGIN
    ALTER TABLE [ProfessionalReference] Alter column  ContactNumber VARCHAR(20) NULL 
END
GO

GO
IF  EXISTS (SELECT * FROM sys.columns WHERE Name = N'LinkedInUrl' AND Object_ID = OBJECT_ID(N'[EmploymentDetail]'))
BEGIN
    ALTER TABLE [EmploymentDetail] Alter column  LinkedInUrl nvarchar(250) NULL 
END
GO
GO
GO

IF EXISTS (SELECT * FROM sys.columns WHERE Name = N'NotificationTemplateTypeId' AND Object_ID = OBJECT_ID(N'[NotificationTemplate]'))
BEGIN
ALTER TABLE [NotificationTemplate] ALTER COLUMN  NotificationTemplateTypeId [int]  NULL
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmailNotification]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[EmailNotification](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[TemplateId] [bigint] NOT NULL,
	[ToEmail] [NVARCHAR](max) NOT NULL,
	[FromEmail] [NVARCHAR](150) NOT NULL,
	[Subject] [NVARCHAR](150) NOT NULL,
	[Body] [NVARCHAR](max) NOT NULL,
	[CC] [NVARCHAR](max)  NULL,
	[SentStatus] [TINYINT] NOT NULL,	
	[CreatedOn] [datetime] NOT NULL,	
	[SentOn] [datetime] NULL	
 CONSTRAINT [PK_EmailNotification] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_EmailNotification_NotificationTemplate_TemplateId]') AND parent_object_id = OBJECT_ID(N'[dbo].[EmailNotification]'))
ALTER TABLE [dbo].[EmailNotification]  WITH CHECK ADD  CONSTRAINT [FK_EmailNotification_NotificationTemplate_TemplateId] FOREIGN KEY([TemplateId])
REFERENCES [dbo].[NotificationTemplate] ([Id])
GO
IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'PANNumber' AND Object_ID = OBJECT_ID(N'[EmployeeData]'))
BEGIN
ALTER TABLE [EmployeeData] ADD [PANNumber] varchar(100) 
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'AdharNumber' AND Object_ID = OBJECT_ID(N'[EmployeeData]'))
BEGIN
ALTER TABLE [EmployeeData] ADD [AdharNumber] bigint
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'PFNumber' AND Object_ID = OBJECT_ID(N'[EmployeeData]'))
BEGIN
ALTER TABLE [EmployeeData] ADD [PFNumber] varchar(100)
END
GO
IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'ESINo' AND Object_ID = OBJECT_ID(N'[EmployeeData]'))
BEGIN
ALTER TABLE [EmployeeData] ADD [ESINo] varchar(100)
END
GO
IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'HasESI' AND Object_ID = OBJECT_ID(N'[EmployeeData]'))
BEGIN
ALTER TABLE [EmployeeData] ADD [HasESI] bit
END
GO
IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'HasPF' AND Object_ID = OBJECT_ID(N'[EmployeeData]'))
BEGIN
ALTER TABLE [EmployeeData] ADD [HasPF] bit
END
GO
IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'UANNo' AND Object_ID = OBJECT_ID(N'[EmployeeData]'))
BEGIN
ALTER TABLE [EmployeeData] ADD [UANNo] varchar(100)
END
GO
IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'PassportNo' AND Object_ID = OBJECT_ID(N'[EmployeeData]'))
BEGIN
ALTER TABLE [EmployeeData] ADD [PassportNo] varchar(100)
END
GO
IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'PassportExpiry' AND Object_ID = OBJECT_ID(N'[EmployeeData]'))
BEGIN
ALTER TABLE [EmployeeData] ADD [PassportExpiry] datetime
END
GO
IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'PFDate' AND Object_ID = OBJECT_ID(N'[EmployeeData]'))
BEGIN
ALTER TABLE [EmployeeData] ADD [PFDate] datetime
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BankDetails]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[BankDetails](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[EmployeeId] [bigint]  NOT NULL,
	[BankName] [varchar](250) NOT NULL,
	[AccountNO] [bigint] NOT NULL,
	[BranchName] [varchar](250) NOT NULL,
	[IFSCCode] [varchar] (50) NOT NULL, 
    [CreatedBy] [nvarchar] (250) NOT NULL, 
    [CreatedOn] [datetime] NOT NULL, 
    [ModifiedBy] [nvarchar] (250) NULL, 
    [Modifiedon] [datetime] NULL, 
    [IsActive] [bit] NOT NULL
 CONSTRAINT [PK_BankDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] 
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_BankDetails_EmployeeData_EmployeeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[BankDetails]'))
ALTER TABLE [dbo].[BankDetails]  WITH CHECK ADD  CONSTRAINT [FK_BankDetails_EmployeeData_EmployeeId] FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[EmployeeData]([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_BankDetails_EmployeeData_EmployeeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[BankDetails]'))
ALTER TABLE [dbo].[BankDetails] CHECK CONSTRAINT [FK_BankDetails_EmployeeData_EmployeeId]
GO

IF EXISTS (SELECT * FROM sys.columns WHERE Name = N'SUBJECT' AND Object_ID = OBJECT_ID(N'[NotificationTemplate]'))
BEGIN
ALTER TABLE [NotificationTemplate] DROP COLUMN SUBJECT
END
GO

 
  
IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'EmployeeCode' AND Object_ID = OBJECT_ID(N'[EmployeeData]'))
BEGIN
    ALTER TABLE [EmployeeData] ADD EmployeeCode BIGINT NULL; 
END
GO
 

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PermanentAddress]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PermanentAddress](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[EmployeeId] [bigint] NOT NULL, 
	[Line1] [nvarchar](250) NULL,
	[Line2] [nvarchar](250) NULL,
	[AddressType] [tinyint] NULL,
	[Pincode] [int] NULL,
	[CityId] [bigint] NULL,
	[CountryId] [bigint] NULL,
	[StateId] [bigint] NULL,
	[CreatedBy] [nvarchar](250) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [nvarchar](250) NULL,
	[ModifiedOn] [datetime] NULL,
 CONSTRAINT [PK_PermanentAddress] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PermanentAddress_EmployeeData_EmployeeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[PermanentAddress]'))
ALTER TABLE [dbo].[PermanentAddress]  WITH NOCHECK ADD  CONSTRAINT [FK_PermanentAddress_EmployeeData_EmployeeId] FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[EmployeeData] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PermanentAddress_EmployeeData_EmployeeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[PermanentAddress]'))
ALTER TABLE [dbo].[PermanentAddress] CHECK CONSTRAINT [FK_PermanentAddress_EmployeeData_EmployeeId]
GO 

IF  EXISTS (SELECT * FROM sys.columns WHERE Name = N'IFSCCode' AND Object_ID = OBJECT_ID(N'[BankDetails]'))
BEGIN
ALTER TABLE [BankDetails] Alter column IFSCCode  VARCHAR(200) NULL
END
GO
IF  EXISTS (SELECT * FROM sys.columns WHERE Name = N'BranchName' AND Object_ID = OBJECT_ID(N'[BankDetails]'))
BEGIN
ALTER TABLE [BankDetails] Alter column BranchName  VARCHAR(200) NULL
END
GO

IF  EXISTS (SELECT * FROM sys.columns WHERE Name = N'BranchName' AND Object_ID = OBJECT_ID(N'[Address]'))
BEGIN
ALTER TABLE [Address] Alter column [Pincode]  VARCHAR(20) NULL
END
GO

 IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'RoleId' AND Object_ID = OBJECT_ID(N'[EmploymentDetail]'))
BEGIN
ALTER TABLE [EmploymentDetail] ADD  RoleId int
END
GO
 IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'EmployeeStatus' AND Object_ID = OBJECT_ID(N'[EmploymentDetail]'))
BEGIN
ALTER TABLE [EmploymentDetail] ADD  EmployeeStatus int
END
GO
IF EXISTS (SELECT * FROM sys.columns WHERE Name = N'AdharNumber' AND Object_ID = OBJECT_ID(N'[EmployeeData]'))
BEGIN
ALTER TABLE [EmployeeData] ALTER COLUMN [AdharNumber] VARCHAR(255)
END
GO
IF EXISTS (SELECT * FROM sys.columns WHERE Name = N'AccountNO' AND Object_ID = OBJECT_ID(N'[BankDetails]'))
BEGIN
ALTER TABLE [BankDetails] ALTER COLUMN [AccountNO] VARCHAR(255)
END
GO
------------------------Designation--------------------
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Designation]') AND type in (N'U'))
CREATE TABLE [dbo].[Designation](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Designation] [varchar](100) NOT NULL,
	[CreatedBy] [nvarchar](250) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [nvarchar](250) NULL,
	[ModifiedOn] [datetime] NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_Designation] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
