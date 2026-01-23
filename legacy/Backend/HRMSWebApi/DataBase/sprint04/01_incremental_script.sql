USE [HRMS]
GO
IF  EXISTS (SELECT * FROM sys.columns WHERE Name = N'BannerName' AND Object_ID = OBJECT_ID(N'[Events]'))
BEGIN
ALTER TABLE [Events] Drop column BannerName
END
GO

IF  EXISTS (SELECT * FROM sys.columns WHERE Name = N'BannerLocation' AND Object_ID = OBJECT_ID(N'[Events]'))
BEGIN
ALTER TABLE [Events] Drop column BannerLocation
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'BannerFileName' AND Object_ID = OBJECT_ID(N'[Events]'))
BEGIN
ALTER TABLE [Events] ADD  BannerFileName VARCHAR(100) 
END
GO

IF  EXISTS (SELECT * FROM sys.columns WHERE Name = N'StartDate' AND Object_ID = OBJECT_ID(N'[Events]'))
BEGIN
ALTER TABLE [Events] Drop column StartDate
END
GO

IF  EXISTS (SELECT * FROM sys.columns WHERE Name = N'EndDate' AND Object_ID = OBJECT_ID(N'[Events]'))
BEGIN
ALTER TABLE [Events] Drop column EndDate
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'StartDate' AND Object_ID = OBJECT_ID(N'[Events]'))
BEGIN
ALTER TABLE [Events] ADD  StartDate datetime
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'EndDate' AND Object_ID = OBJECT_ID(N'[Events]'))
BEGIN
ALTER TABLE [Events] ADD  EndDate datetime
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserCertificate]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[UserCertificate](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[EmployeeId] [bigint] NOT NULL,
	[CertificateName] [varchar](100) NOT NULL,
	[OriginalFileName] [varchar](100) NULL,
	[FileName] [varchar](100) NULL,
	[CreatedBy] [nvarchar](250) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [nvarchar](250) NULL,
	[ModifiedOn] [datetime] NULL,
	[IsDeleted] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_UserCertificate_EmployeeData_EmployeeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[UserCertificate]'))
ALTER TABLE [dbo].[UserCertificate]  WITH CHECK ADD CONSTRAINT [FK_UserCertificate_EmployeeData_EmployeeId]FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[EmployeeData] ([Id])
End
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProfationalReference]') AND type in (N'U'))
Begin
Drop Table ProfationalReference
End
Go
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProfessionalReference]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ProfessionalReference](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[EmployeeId] [bigint] NOT NULL,
	[FullName] [varchar](250) NOT NULL,
	[Designation] [varchar](50) NOT NULL,
	[Email] [varchar](100) NOT NULL,
	[ContactNumber] [varchar](10) NOT NULL,
	[CreatedBy] [nvarchar](250) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [nvarchar](250) NULL,
	[ModifiedOn] [datetime] NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_ProfessionalReference] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON ) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfessionalReference_EmployeeData_EmployeeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfessionalReference]'))
ALTER TABLE [dbo].[ProfessionalReference]  WITH CHECK ADD  CONSTRAINT [FK_ProfessionalReference_EmployeeData_EmployeeId] FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[EmployeeData] ([Id])
GO
 

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'FatherName' AND Object_ID = OBJECT_ID(N'[EmployeeData]'))
BEGIN
ALTER TABLE [EmployeeData] ADD  [FatherName] VARCHAR(100)
END
GO
IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'TotalExperienceYear' AND Object_ID = OBJECT_ID(N'[EmploymentDetail]'))
BEGIN
ALTER TABLE [EmploymentDetail] ADD TotalExperienceYear tinyint 
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'TotalExperienceMonth' AND Object_ID = OBJECT_ID(N'[EmploymentDetail]'))
BEGIN
ALTER TABLE [EmploymentDetail] ADD TotalExperienceMonth tinyint 
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'RelevantExperienceYear' AND Object_ID = OBJECT_ID(N'[EmploymentDetail]'))
BEGIN
ALTER TABLE [EmploymentDetail] ADD RelevantExperienceYear tinyint 
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'RelevantExperienceMonth' AND Object_ID = OBJECT_ID(N'[EmploymentDetail]'))
BEGIN
ALTER TABLE [EmploymentDetail] ADD RelevantExperienceMonth tinyint 
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'JobType' AND Object_ID = OBJECT_ID(N'[EmploymentDetail]'))
BEGIN
ALTER TABLE [EmploymentDetail] ADD JobType tinyint 
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'ConfirmationDate' AND Object_ID = OBJECT_ID(N'[EmploymentDetail]'))
BEGIN
ALTER TABLE [EmploymentDetail] ADD ConfirmationDate Date 
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'ExtendedConfirmationDate' AND Object_ID = OBJECT_ID(N'[EmploymentDetail]'))
BEGIN
ALTER TABLE [EmploymentDetail] ADD ExtendedConfirmationDate Date 
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'isProbExtended' AND Object_ID = OBJECT_ID(N'[EmploymentDetail]'))
BEGIN
ALTER TABLE [EmploymentDetail] ADD isProbExtended Bit 
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'ProbExtendedWeeks' AND Object_ID = OBJECT_ID(N'[EmploymentDetail]'))
BEGIN
ALTER TABLE [EmploymentDetail] ADD ProbExtendedWeeks tinyint 
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'isConfirmed' AND Object_ID = OBJECT_ID(N'[EmploymentDetail]'))
BEGIN
ALTER TABLE [EmploymentDetail] ADD isConfirmed Bit 
END
GO

IF  EXISTS (SELECT * FROM sys.columns WHERE Name = N'ProfessionalReference1' AND Object_ID = OBJECT_ID(N'[EmployeeData]'))
BEGIN
ALTER TABLE [EmploymentDetail] Drop column  ProfessionalReference1
END
GO

IF  EXISTS (SELECT * FROM sys.columns WHERE Name = N'ProfessionalReference2' AND Object_ID = OBJECT_ID(N'[EmployeeData]'))
BEGIN
ALTER TABLE [EmploymentDetail] Drop column  ProfessionalReference2
END
GO

IF  EXISTS (SELECT * FROM sys.columns WHERE Name = N'DocumentName' AND Object_ID = OBJECT_ID(N'[EventDocument]'))
BEGIN
ALTER TABLE [EventDocument] Drop column DocumentName
END
GO

IF  EXISTS (SELECT * FROM sys.columns WHERE Name = N'DocumentLocation' AND Object_ID = OBJECT_ID(N'[EventDocument]'))
BEGIN
ALTER TABLE [EventDocument] Drop column DocumentLocation
END
GO

IF  EXISTS (SELECT * FROM sys.columns WHERE Name = N'IsDeleted' AND Object_ID = OBJECT_ID(N'[EventDocument]'))
BEGIN
ALTER TABLE [EventDocument] Drop column IsDeleted
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'FileName' AND Object_ID = OBJECT_ID(N'[EventDocument]'))
BEGIN
ALTER TABLE [EventDocument] ADD  [FileName] VARCHAR(100) 
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'OriginalFileName' AND Object_ID = OBJECT_ID(N'[EventDocument]'))
BEGIN
ALTER TABLE [EventDocument] ADD  [OriginalFileName] VARCHAR(100) 
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'EventFeedbackSurveyLink' AND Object_ID = OBJECT_ID(N'[Events]'))
BEGIN
ALTER TABLE [Events] ADD  [EventFeedbackSurveyLink] NVARCHAR(500) 
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Menu]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Menu](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Name] [NVARCHAR](100) NOT NULL, 
	[ApiEndPoint] NVARCHAR(255) NULL, 
	[ParentMenuId] bigint NULL,
	[CreatedBy] [nvarchar](250) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [nvarchar](250) NULL,
	[ModifiedOn] [datetime] NULL,
	[IsDeleted] [bit] NOT NULL,
	CONSTRAINT FK_Menu_Parent
	FOREIGN KEY(ParentMenuId) REFERENCES [Menu](Id),
CONSTRAINT [PK_Menu] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] 
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MenuPermission]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[MenuPermission](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,	
	[MenuId] bigint NOT NULL,
	[ReadPermissionId] bigint NOT NULL,
	[CreatedBy] [nvarchar](250) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [nvarchar](250) NULL,
	[ModifiedOn] [datetime] NULL	
	CONSTRAINT FK_MenuPermission_Menu
	FOREIGN KEY(MenuId) REFERENCES [Menu](Id),
	CONSTRAINT FK_MenuPermission_Permission
	FOREIGN KEY(ReadPermissionId) REFERENCES [Permission](Id),
CONSTRAINT [PK_MenuPermission] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] 
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'SecReportingManagerId' AND Object_ID = OBJECT_ID(N'[EmploymentDetail]'))
BEGIN
ALTER TABLE [EmploymentDetail] ADD SecReportingManagerId BigInt  NULL 
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'ProbationMonths' AND Object_ID = OBJECT_ID(N'[EmploymentDetail]'))
BEGIN
ALTER TABLE [EmploymentDetail] ADD ProbationMonths  Int  NULL 
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[University]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[University](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,	
	[UniversityName] [varchar](250) NOT NULL,	
	[CreatedBy] [nvarchar](250) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [nvarchar](250) NULL,
	[ModifiedOn] [datetime] NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_University] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON ) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'Value' AND Object_ID = OBJECT_ID(N'[dbo].[Permission]'))
BEGIN
ALTER TABLE [dbo].[Permission] ADD [Value] NVARCHAR(250) 
END
GO

IF EXISTS (SELECT * FROM sys.columns WHERE Name = N'EmployeeType' AND Object_ID = OBJECT_ID(N'[EmployerDocumentType]'))
BEGIN
    TRUNCATE TABLE EmployerDocumentType;
	IF EXISTS (SELECT * FROM sys.columns WHERE Name = N'DocumentFor' AND Object_ID = OBJECT_ID(N'[EmployerDocumentType]'))
	BEGIN
		ALTER TABLE [EmployerDocumentType] Drop column EmployeeType
	END
	ELSE
	BEGIN
		EXEC sp_RENAME 'EmployerDocumentType.EmployeeType', 'DocumentFor', 'COLUMN'
	END
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'NotificationTemplateTypeId' AND Object_ID = OBJECT_ID(N'[NotificationTemplate]'))
BEGIN
ALTER TABLE [NotificationTemplate] ADD NotificationTemplateTypeId Int NULL 
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[NotificationTemplateType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[NotificationTemplateType](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TemplateType] [varchar](50) NOT NULL,	
	[CreatedBy] [nvarchar](250) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [nvarchar](250) NULL,
	[ModifiedOn] [datetime] NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_NotificationTemplateType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'FileName' AND Object_ID = OBJECT_ID(N'[UserNomineeInfo]'))
BEGIN
ALTER TABLE [UserNomineeInfo] ADD  [FileName] VARCHAR(100)  NULL
END
GO
IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'FileOriginalName' AND Object_ID = OBJECT_ID(N'[UserNomineeInfo]'))
BEGIN
ALTER TABLE [UserNomineeInfo] ADD  [FileOriginalName] VARCHAR(100)  NULL
END
GO
IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'IsExpiryDateRequired' AND Object_ID = OBJECT_ID(N'[DocumentType]'))
BEGIN
ALTER TABLE [DocumentType] Add  IsExpiryDateRequired bit  
END
GO

IF  EXISTS (SELECT * FROM sys.columns WHERE Name = N'IsActive' AND Object_ID = OBJECT_ID(N'[DocumentType]'))
BEGIN
ALTER TABLE [DocumentType] Drop column  IsActive
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'IdProofFor' AND Object_ID = OBJECT_ID(N'[DocumentType]'))
BEGIN
ALTER TABLE [DocumentType] Add  IdProofFor int  
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'IdProofDocType' AND Object_ID = OBJECT_ID(N'[UserNomineeInfo]'))
BEGIN
ALTER TABLE [UserNomineeInfo] Add  IdProofDocType int  
END
GO

IF  EXISTS (SELECT * FROM sys.columns WHERE Name = N'IdProofDocName' AND Object_ID = OBJECT_ID(N'[UserNomineeInfo]'))
BEGIN
ALTER TABLE [UserNomineeInfo] Drop column IdProofDocName 
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CurrentEmployerDocument]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CurrentEmployerDocument](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[EmployeeId] [bigint] NOT NULL,
	[EmployeeDocumentTypeId] [int] NOT NULL,
	[FileName] [varchar](100) NOT NULL,
	[FileOriginalName] [varchar](100) NOT NULL,
	[CreatedBy] [nvarchar](250) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [nvarchar](250) NULL,
	[ModifiedOn] [datetime] NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_CurrentEmployerDocument] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CurrentEmployerDocument_EmployeeData_EmployeeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[CurrentEmployerDocument]'))
BEGIN
ALTER TABLE [dbo].[CurrentEmployerDocument]  WITH CHECK ADD  CONSTRAINT [FK_CurrentEmployerDocument_EmployeeData_EmployeeId] FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[EmployeeData] ([Id])
END
GO
USE [HRMS]
GO
IF  EXISTS (SELECT * FROM sys.columns WHERE Name = N'BannerName' AND Object_ID = OBJECT_ID(N'[Events]'))
BEGIN
ALTER TABLE [Events] Drop column BannerName
END
GO

IF  EXISTS (SELECT * FROM sys.columns WHERE Name = N'BannerLocation' AND Object_ID = OBJECT_ID(N'[Events]'))
BEGIN
ALTER TABLE [Events] Drop column BannerLocation
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'BannerFileName' AND Object_ID = OBJECT_ID(N'[Events]'))
BEGIN
ALTER TABLE [Events] ADD  BannerFileName VARCHAR(100) 
END
GO

IF  EXISTS (SELECT * FROM sys.columns WHERE Name = N'StartDate' AND Object_ID = OBJECT_ID(N'[Events]'))
BEGIN
ALTER TABLE [Events] Drop column StartDate
END
GO

IF  EXISTS (SELECT * FROM sys.columns WHERE Name = N'EndDate' AND Object_ID = OBJECT_ID(N'[Events]'))
BEGIN
ALTER TABLE [Events] Drop column EndDate
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'StartDate' AND Object_ID = OBJECT_ID(N'[Events]'))
BEGIN
ALTER TABLE [Events] ADD  StartDate datetime
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'EndDate' AND Object_ID = OBJECT_ID(N'[Events]'))
BEGIN
ALTER TABLE [Events] ADD  EndDate datetime
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserCertificate]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[UserCertificate](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[EmployeeId] [bigint] NOT NULL,
	[CertificateName] [varchar](100) NOT NULL,
	[OriginalFileName] [varchar](100) NULL,
	[FileName] [varchar](100) NULL,
	[CreatedBy] [nvarchar](250) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [nvarchar](250) NULL,
	[ModifiedOn] [datetime] NULL,
	[IsDeleted] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_UserCertificate_EmployeeData_EmployeeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[UserCertificate]'))
ALTER TABLE [dbo].[UserCertificate]  WITH CHECK ADD CONSTRAINT [FK_UserCertificate_EmployeeData_EmployeeId]FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[EmployeeData] ([Id])
End
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProfessionalReference]') AND type in (N'U'))
Begin
Drop Table ProfationalReference
End
Go
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProfessionalReference]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ProfessionalReference](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[EmployeeId] [bigint] NOT NULL,
	[FullName] [varchar](250) NOT NULL,
	[Designation] [varchar](50) NOT NULL,
	[Email] [varchar](100) NOT NULL,
	[ContactNumber] [varchar](10) NOT NULL,
	[CreatedBy] [nvarchar](250) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [nvarchar](250) NULL,
	[ModifiedOn] [datetime] NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_ProfessionalReference] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON ) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfessionalReference_EmployeeData_EmployeeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfessionalReference]'))
ALTER TABLE [dbo].[ProfessionalReference]  WITH CHECK ADD  CONSTRAINT [FK_ProfessionalReference_EmployeeData_EmployeeId] FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[EmployeeData] ([Id])
GO
 

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'FatherName' AND Object_ID = OBJECT_ID(N'[EmployeeData]'))
BEGIN
ALTER TABLE [EmployeeData] ADD  [FatherName] VARCHAR(100)
END
GO
IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'TotalExperienceYear' AND Object_ID = OBJECT_ID(N'[EmploymentDetail]'))
BEGIN
ALTER TABLE [EmploymentDetail] ADD TotalExperienceYear tinyint 
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'TotalExperienceMonth' AND Object_ID = OBJECT_ID(N'[EmploymentDetail]'))
BEGIN
ALTER TABLE [EmploymentDetail] ADD TotalExperienceMonth tinyint 
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'RelevantExperienceYear' AND Object_ID = OBJECT_ID(N'[EmploymentDetail]'))
BEGIN
ALTER TABLE [EmploymentDetail] ADD RelevantExperienceYear tinyint 
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'RelevantExperienceMonth' AND Object_ID = OBJECT_ID(N'[EmploymentDetail]'))
BEGIN
ALTER TABLE [EmploymentDetail] ADD RelevantExperienceMonth tinyint 
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'JobType' AND Object_ID = OBJECT_ID(N'[EmploymentDetail]'))
BEGIN
ALTER TABLE [EmploymentDetail] ADD JobType tinyint 
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'ConfirmationDate' AND Object_ID = OBJECT_ID(N'[EmploymentDetail]'))
BEGIN
ALTER TABLE [EmploymentDetail] ADD ConfirmationDate Date 
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'ExtendedConfirmationDate' AND Object_ID = OBJECT_ID(N'[EmploymentDetail]'))
BEGIN
ALTER TABLE [EmploymentDetail] ADD ExtendedConfirmationDate Date 
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'isProbExtended' AND Object_ID = OBJECT_ID(N'[EmploymentDetail]'))
BEGIN
ALTER TABLE [EmploymentDetail] ADD isProbExtended Bit 
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'ProbExtendedWeeks' AND Object_ID = OBJECT_ID(N'[EmploymentDetail]'))
BEGIN
ALTER TABLE [EmploymentDetail] ADD ProbExtendedWeeks tinyint 
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'isConfirmed' AND Object_ID = OBJECT_ID(N'[EmploymentDetail]'))
BEGIN
ALTER TABLE [EmploymentDetail] ADD isConfirmed Bit 
END
GO

IF  EXISTS (SELECT * FROM sys.columns WHERE Name = N'ProfessionalReference1' AND Object_ID = OBJECT_ID(N'[EmployeeData]'))
BEGIN
ALTER TABLE [EmploymentDetail] Drop column  ProfessionalReference1
END
GO

IF  EXISTS (SELECT * FROM sys.columns WHERE Name = N'ProfessionalReference2' AND Object_ID = OBJECT_ID(N'[EmployeeData]'))
BEGIN
ALTER TABLE [EmploymentDetail] Drop column  ProfessionalReference2
END
GO

IF  EXISTS (SELECT * FROM sys.columns WHERE Name = N'DocumentName' AND Object_ID = OBJECT_ID(N'[EventDocument]'))
BEGIN
ALTER TABLE [EventDocument] Drop column DocumentName
END
GO

IF  EXISTS (SELECT * FROM sys.columns WHERE Name = N'DocumentLocation' AND Object_ID = OBJECT_ID(N'[EventDocument]'))
BEGIN
ALTER TABLE [EventDocument] Drop column DocumentLocation
END
GO

IF  EXISTS (SELECT * FROM sys.columns WHERE Name = N'IsDeleted' AND Object_ID = OBJECT_ID(N'[EventDocument]'))
BEGIN
ALTER TABLE [EventDocument] Drop column IsDeleted
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'FileName' AND Object_ID = OBJECT_ID(N'[EventDocument]'))
BEGIN
ALTER TABLE [EventDocument] ADD  [FileName] VARCHAR(100) 
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'OriginalFileName' AND Object_ID = OBJECT_ID(N'[EventDocument]'))
BEGIN
ALTER TABLE [EventDocument] ADD  [OriginalFileName] VARCHAR(100) 
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'EventFeedbackSurveyLink' AND Object_ID = OBJECT_ID(N'[Events]'))
BEGIN
ALTER TABLE [Events] ADD  [EventFeedbackSurveyLink] NVARCHAR(500) 
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Menu]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Menu](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Name] [NVARCHAR](100) NOT NULL, 
	[ApiEndPoint] NVARCHAR(255) NULL, 
	[ParentMenuId] bigint NULL,
	[CreatedBy] [nvarchar](250) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [nvarchar](250) NULL,
	[ModifiedOn] [datetime] NULL,
	[IsDeleted] [bit] NOT NULL,
	CONSTRAINT FK_Menu_Parent
	FOREIGN KEY(ParentMenuId) REFERENCES [Menu](Id),
CONSTRAINT [PK_Menu] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] 
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MenuPermission]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[MenuPermission](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,	
	[MenuId] bigint NOT NULL,
	[ReadPermissionId] bigint NOT NULL,
	[CreatedBy] [nvarchar](250) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [nvarchar](250) NULL,
	[ModifiedOn] [datetime] NULL	
	CONSTRAINT FK_MenuPermission_Menu
	FOREIGN KEY(MenuId) REFERENCES [Menu](Id),
	CONSTRAINT FK_MenuPermission_Permission
	FOREIGN KEY(ReadPermissionId) REFERENCES [Permission](Id),
CONSTRAINT [PK_MenuPermission] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] 
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'SecReportingManagerId' AND Object_ID = OBJECT_ID(N'[EmploymentDetail]'))
BEGIN
ALTER TABLE [EmploymentDetail] ADD SecReportingManagerId BigInt  NULL 
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'ProbationMonths' AND Object_ID = OBJECT_ID(N'[EmploymentDetail]'))
BEGIN
ALTER TABLE [EmploymentDetail] ADD ProbationMonths  Int  NULL 
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[University]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[University](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,	
	[UniversityName] [varchar](250) NOT NULL,	
	[CreatedBy] [nvarchar](250) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [nvarchar](250) NULL,
	[ModifiedOn] [datetime] NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_University] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON ) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'Value' AND Object_ID = OBJECT_ID(N'[dbo].[Permission]'))
BEGIN
ALTER TABLE [dbo].[Permission] ADD [Value] NVARCHAR(250) 
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'DocumentFor' AND Object_ID = OBJECT_ID(N'[EmployerDocumentType]'))
BEGIN
ALTER TABLE [EmployerDocumentType] ADD DocumentFor INT NOT NULL DEFAULT 0
END
GO

IF EXISTS (SELECT * FROM sys.columns WHERE Name = N'EmployeeType' AND Object_ID = OBJECT_ID(N'[EmployerDocumentType]'))
BEGIN
ALTER TABLE [EmployerDocumentType] Drop column EmployeeType
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'NotificationTemplateTypeId' AND Object_ID = OBJECT_ID(N'[NotificationTemplate]'))
BEGIN
ALTER TABLE [NotificationTemplate] ADD NotificationTemplateTypeId Int NULL 
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[NotificationTemplateType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[NotificationTemplateType](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TemplateType] [varchar](50) NOT NULL,	
	[CreatedBy] [nvarchar](250) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [nvarchar](250) NULL,
	[ModifiedOn] [datetime] NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_NotificationTemplateType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'FileName' AND Object_ID = OBJECT_ID(N'[UserNomineeInfo]'))
BEGIN
ALTER TABLE [UserNomineeInfo] ADD  [FileName] VARCHAR(100)  NULL
END
GO
IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'FileOriginalName' AND Object_ID = OBJECT_ID(N'[UserNomineeInfo]'))
BEGIN
ALTER TABLE [UserNomineeInfo] ADD  [FileOriginalName] VARCHAR(100)  NULL
END
GO
IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'IsExpiryDateRequired' AND Object_ID = OBJECT_ID(N'[DocumentType]'))
BEGIN
ALTER TABLE [DocumentType] Add  IsExpiryDateRequired bit  
END
GO

IF  EXISTS (SELECT * FROM sys.columns WHERE Name = N'IsActive' AND Object_ID = OBJECT_ID(N'[DocumentType]'))
BEGIN
ALTER TABLE [DocumentType] Drop column  IsActive
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'IdProofFor' AND Object_ID = OBJECT_ID(N'[DocumentType]'))
BEGIN
ALTER TABLE [DocumentType] Add  IdProofFor int  
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'IdProofDocType' AND Object_ID = OBJECT_ID(N'[UserNomineeInfo]'))
BEGIN
ALTER TABLE [UserNomineeInfo] Add  IdProofDocType int  
END
GO

IF  EXISTS (SELECT * FROM sys.columns WHERE Name = N'IdProofDocName' AND Object_ID = OBJECT_ID(N'[UserNomineeInfo]'))
BEGIN
ALTER TABLE [UserNomineeInfo] Drop column IdProofDocName 
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CurrentEmployerDocument]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CurrentEmployerDocument](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[EmployeeId] [bigint] NOT NULL,
	[EmployeeDocumentTypeId] [int] NOT NULL,
	[FileName] [varchar](100) NOT NULL,
	[FileOriginalName] [varchar](100) NOT NULL,
	[CreatedBy] [nvarchar](250) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [nvarchar](250) NULL,
	[ModifiedOn] [datetime] NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_CurrentEmployerDocument] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CurrentEmployerDocument_EmployeeData_EmployeeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[CurrentEmployerDocument]'))
BEGIN
ALTER TABLE [dbo].[CurrentEmployerDocument]  WITH CHECK ADD  CONSTRAINT [FK_CurrentEmployerDocument_EmployeeData_EmployeeId] FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[EmployeeData] ([Id])
END
GO
