GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Branch]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Branch](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NOT NULL, 
	[CreatedBy] [nvarchar](250) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [nvarchar](250) NULL,
	[ModifiedOn] [datetime] NULL,
	[IsDeleted] [bit] NOT NULL,
CONSTRAINT [PK_Branch] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] 
END
GO
IF EXISTS (SELECT * FROM sys.columns WHERE Name = N'IsActive' AND Object_ID = OBJECT_ID(N'[Qualification]'))
BEGIN
ALTER TABLE [Qualification] Drop Column IsActive
END
GO
Go
IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'DegreeName' AND Object_ID = OBJECT_ID(N'[UserQualificationInfo]'))
BEGIN
ALTER TABLE [UserQualificationInfo] ADD  DegreeName VARCHAR(255) 
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'StartYear' AND Object_ID = OBJECT_ID(N'[UserQualificationInfo]'))
BEGIN
ALTER TABLE [UserQualificationInfo] ADD  StartYear VARCHAR(7) 
END
GO

 IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'EndYear' AND Object_ID = OBJECT_ID(N'[UserQualificationInfo]'))
BEGIN
ALTER TABLE [UserQualificationInfo] ADD  EndYear VARCHAR(7) 
END
GO
 
IF  EXISTS (SELECT * FROM sys.columns WHERE Name = N'YearOfPassing' AND Object_ID = OBJECT_ID(N'[UserQualificationInfo]'))
BEGIN
ALTER TABLE [UserQualificationInfo] Drop column  YearOfPassing
END
GO
 
IF  EXISTS (SELECT * FROM sys.columns WHERE Name = N'DocumentLocation' AND Object_ID = OBJECT_ID(N'[UserQualificationInfo]'))
BEGIN
ALTER TABLE [UserQualificationInfo] Drop column  DocumentLocation
END
GO
 
IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'FileName' AND Object_ID = OBJECT_ID(N'[UserQualificationInfo]'))
BEGIN
ALTER TABLE [UserQualificationInfo] ADD  [FileName] NVARCHAR(100) 
END
GO
IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'FileOriginalName' AND Object_ID = OBJECT_ID(N'[UserQualificationInfo]'))
BEGIN
ALTER TABLE [UserQualificationInfo] ADD  [FileOriginalName] NVARCHAR(100) 
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Relationship]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Relationship](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NOT NULL, 
	[CreatedBy] [nvarchar](250) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [nvarchar](250) NULL,
	[ModifiedOn] [datetime] NULL,
	[IsDeleted] [bit] NOT NULL,
CONSTRAINT [PK_Relationship] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] 
END
GO
GO

---------- 


GO
IF EXISTS (SELECT * FROM sys.columns WHERE Name = N'DepartmentId' AND Object_ID = OBJECT_ID(N'[EmployeementDetail]'))
BEGIN
ALTER TABLE [EmployeementDetail] ALTER COLUMN DepartmentId int 
END

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmployeementDocument]') AND type in (N'U'))
BEGIN
DROP TABLE [EmployeementDocument]  
END
GO

-- 
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmployerDocumentType]') AND type in (N'U'))
BEGIN
CREATE TABLE EmployerDocumentType
(
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DocumentName] [varchar](100) NOT NULL,
  	[CreatedBy] [nvarchar](250) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [nvarchar](250) NULL,
	[ModifiedOn] [datetime] NULL,
	[IsDeleted] [bit] NOT NULL
 CONSTRAINT [PK_EmployerDocumentType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] 
END
GO
---
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PreviousEmployer]') AND type in (N'U'))
BEGIN
CREATE TABLE [PreviousEmployer] 
(      [Id] [bigint] IDENTITY(1,1) NOT NULL
      ,[EmployeeId] [bigint] NOT NULL
      ,[EmployerName] [varchar](100) NOT NULL
      ,[StartDate] [datetime] NOT NULL
      ,[EndDate] [datetime] NOT NULL
      ,[CreatedBy] [nvarchar](250) NOT NULL
	  ,[CreatedOn] [datetime] NOT NULL
	  ,[ModifiedBy] [nvarchar](250) NULL
	  ,[ModifiedOn] [datetime] NULL
	  ,[IsDeleted] [bit] NOT NULL
 CONSTRAINT [PK_PreviousEmployer] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] 
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PreviousEmployer_EmployeeData_EmployeeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[PreviousEmployer]'))
ALTER TABLE [dbo].[PreviousEmployer]  WITH CHECK ADD  CONSTRAINT [FK_PreviousEmployer_EmployeeData_EmployeeId] FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[EmployeeData] ([Id])
GO
-----
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PreviousEmployerDocument]') AND type in (N'U'))
BEGIN
CREATE TABLE PreviousEmployerDocument
( 
	[Id] [bigint] IDENTITY(1,1) NOT NULL, 
	[PreviousEmployerId] [bigint] NOT NULL, 
	[EmployerDocumentTypeId] [int] NOT NULL, 
	[FileName] [varchar](100) NOT NULL,
	[FileOriginalName] [varchar](100) NOT NULL,
	[CreatedBy] [nvarchar](250) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [nvarchar](250) NULL,
	[ModifiedOn] [datetime] NULL,
	[IsDeleted] [bit] NOT NULL
 CONSTRAINT [PK_PreviousEmployerDocument] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] 
END
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmployeementDocument]') AND type in (N'U'))
BEGIN
 DROP TABLE EmployeementDocument
END
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmployeementDetail]') AND type in (N'U'))
BEGIN
  EXEC sp_rename 'EmployeementDetail','EmploymentDetail'
END
GO
IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'TeamName' AND Object_ID = OBJECT_ID(N'[EmploymentDetail]'))
BEGIN
ALTER TABLE [EmploymentDetail] ADD TeamName VARCHAR(191) 
END 

GO
IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'DepartmentName' AND Object_ID = OBJECT_ID(N'[EmploymentDetail]'))
BEGIN
ALTER TABLE [EmploymentDetail] ADD DepartmentName VARCHAR(50) 
END
GO
IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'Pincode' AND Object_ID = OBJECT_ID(N'[Address]'))
BEGIN
ALTER TABLE [Address] ADD  [Pincode] INTEGER 
END
GO
IF  EXISTS (SELECT * FROM sys.columns WHERE Name = N'Branch' AND Object_ID = OBJECT_ID(N'[EmploymentDetail]'))
BEGIN
   IF EXISTS(SELECT 1 FROM sys.foreign_keys WHERE name='FK_EmploymentDetail_Branch')
   BEGIN
      ALTER TABLE [EmploymentDetail]
      DROP CONSTRAINT FK_EmploymentDetail_Branch
   END

ALTER TABLE [EmploymentDetail] DROP COLUMN Branch  
ALTER TABLE [EmploymentDetail] ADD  BranchId BIGINT 

ALTER TABLE [EmploymentDetail]
ADD CONSTRAINT FK_EmploymentDetail_BranchId
FOREIGN KEY (BranchId) REFERENCES BRANCH(ID);
END

IF  EXISTS (SELECT * FROM sys.columns WHERE Name = N'ProfilePictureLocation' AND Object_ID = OBJECT_ID(N'[EmployeeData]'))
BEGIN
ALTER TABLE [EmployeeData] Drop column  ProfilePictureLocation
END
GO
 
IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'FileName' AND Object_ID = OBJECT_ID(N'[EmployeeData]'))
BEGIN
ALTER TABLE [EmployeeData] ADD  [FileName] NVARCHAR(100) 
END
GO
IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'FileOriginalName' AND Object_ID = OBJECT_ID(N'[EmployeeData]'))
BEGIN
ALTER TABLE [EmployeeData] ADD  [FileOriginalName] NVARCHAR(100) 
END
GO
IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'Status' AND Object_ID = OBJECT_ID(N'[EmployeeData]'))
BEGIN
ALTER TABLE [EmployeeData] ADD  [Status] tinyint
END

---------------

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserCompanyPolicyTrack]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[UserCompanyPolicyTrack](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[EmployeeId] [bigint] NOT NULL,
	[CompanyPolicyId] [bigint] NOT NULL,
	[ViewedOn] [datetime] NOT NULL,
	[ModifiedOn] [datetime] NULL,
 CONSTRAINT [PK_UserCompanyPolicyTrack] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_UserCompanyPolicyTrack_EmployeeData_EmployeeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[UserCompanyPolicyTrack]'))
ALTER TABLE [dbo].[UserCompanyPolicyTrack]  WITH CHECK ADD  CONSTRAINT [FK_UserCompanyPolicyTrack_EmployeeData_EmployeeId] FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[EmployeeData] ([Id])
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_UserCompanyPolicyTrack_CompanyPolicy_CompanyPolicyId]') AND parent_object_id = OBJECT_ID(N'[dbo].[UserCompanyPolicyTrack]'))
ALTER TABLE [dbo].[UserCompanyPolicyTrack]  WITH CHECK ADD  CONSTRAINT [FK_UserCompanyPolicyTrack_CompanyPolicy_CompanyPolicyId] FOREIGN KEY([CompanyPolicyId])
REFERENCES [dbo].[CompanyPolicy] ([Id])
GO


IF EXISTS (SELECT * FROM sys.columns WHERE Name = N'AggregatePercentage' AND Object_ID = OBJECT_ID(N'[UserQualificationInfo]'))
BEGIN
ALTER TABLE [UserQualificationInfo] 
ALTER COLUMN [AggregatePercentage] numeric(5,2) NOT NULL
END
GO 

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CompanyPolicy_Group_EmpGroupId]') AND parent_object_id = OBJECT_ID(N'[dbo].[CompanyPolicy]'))
ALTER TABLE CompanyPolicy DROP CONSTRAINT  [FK_CompanyPolicy_Group_EmpGroupId]  
GO

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CompanyPolicyHistory_Group_EmpGroupId]') AND parent_object_id = OBJECT_ID(N'[dbo].[CompanyPolicyHistory]'))
ALTER TABLE CompanyPolicyHistory DROP CONSTRAINT  [FK_CompanyPolicyHistory_Group_EmpGroupId]  
GO

IF  EXISTS (SELECT * FROM sys.columns WHERE Name = N'EmpGroupId' AND Object_ID = OBJECT_ID(N'[CompanyPolicy]'))
BEGIN
ALTER TABLE [CompanyPolicy] Drop column  EmpGroupId
END
GO
IF  EXISTS (SELECT * FROM sys.columns WHERE Name = N'EmpGroupId' AND Object_ID = OBJECT_ID(N'[CompanyPolicyHistory]'))
BEGIN
ALTER TABLE [CompanyPolicyHistory] Drop column  EmpGroupId
END
GO