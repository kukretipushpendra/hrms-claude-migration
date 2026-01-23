IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'RefreshToken' AND Object_ID = OBJECT_ID(N'[EmployeeData]'))
BEGIN
ALTER TABLE [EmployeeData] Add  RefreshToken VARCHAR(100) NULL
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'RefreshTokenExpiryDate' AND Object_ID = OBJECT_ID(N'[EmployeeData]'))
BEGIN
ALTER TABLE [EmployeeData] Add  RefreshTokenExpiryDate DATETIME NULL
END
GO

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfessionalReference_EmployeeData_EmployeeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfessionalReference]'))
BEGIN
ALTER TABLE [dbo].[ProfessionalReference] DROP CONSTRAINT IF EXISTS [FK_ProfessionalReference_EmployeeData_EmployeeId];
ALTER TABLE [dbo].[ProfessionalReference] Drop column EmployeeId;
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfessionalReference_PreviousEmployer_PreviousEmployerId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfessionalReference]'))
BEGIN
TRUNCATE TABLE ProfessionalReference;
ALTER TABLE [dbo].[ProfessionalReference] ADD PreviousEmployerId BIGINT NOT NULL; 
ALTER TABLE [dbo].[ProfessionalReference]  WITH CHECK ADD  CONSTRAINT [FK_ProfessionalReference_PreviousEmployer_PreviousEmployerId] FOREIGN KEY([PreviousEmployerId])
REFERENCES [dbo].[PreviousEmployer] ([Id])
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'Subject' AND Object_ID = OBJECT_ID(N'[NotificationTemplate]'))
BEGIN
ALTER TABLE [NotificationTemplate] ADD [Subject] VARCHAR(200)
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

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'Designation' AND Object_ID = OBJECT_ID(N'[PreviousEmployer]'))
BEGIN
ALTER TABLE [PreviousEmployer] Add Designation VARCHAR(100) NULL
END
GO

IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'DocumentExpiry' AND Object_ID = Object_ID(N'UserDocument'))
BEGIN
ALTER TABLE UserDocument ALTER COLUMN DocumentExpiry DATE NULL
END
GO


IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'SurveyJson' AND Object_ID = OBJECT_ID(N'[Surveys]'))
BEGIN
ALTER TABLE [Surveys] Add  SurveyJson text NULL
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'IsDeleted' AND Object_ID = OBJECT_ID(N'[EmploymentDetail]'))
BEGIN
ALTER TABLE [EmploymentDetail] Add  IsDeleted BIT NULL
END
GO
GO

IF  EXISTS (SELECT * FROM sys.columns WHERE Name = N'IsActive' AND Object_ID = OBJECT_ID(N'[Status]'))
BEGIN
ALTER TABLE [Status] Drop column  IsActive
END
GO
GO
GO

IF EXISTS (SELECT * FROM sys.columns WHERE Name = N'SecReportingManagerId' AND Object_ID = OBJECT_ID(N'[EmploymentDetail]'))
BEGIN
	 ALTER TABLE [EmploymentDetail] Drop column SecReportingManagerId
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'ReportingManagerName' AND Object_ID = OBJECT_ID(N'[EmploymentDetail]'))
BEGIN
ALTER TABLE [EmploymentDetail] Add  ReportingManagerName VARCHAR(250) NULL 
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'ReportingManagerEmail' AND Object_ID = OBJECT_ID(N'[EmploymentDetail]'))
BEGIN
ALTER TABLE [EmploymentDetail] Add  ReportingManagerEmail VARCHAR(100) NULL 
END
GO
GO


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SurveyResponse]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SurveyResponse](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,	
	[EmployeeId] [bigint] NOT NULL,
	[SurveyId] [bigint] NOT NULL,	
	[SurveyJsonResponse] [text] NULL,
	[CreatedBy] [nvarchar](250) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [nvarchar](250) NULL,
	[ModifiedOn] [datetime] NULL	
 CONSTRAINT [PK_SurveyResponse] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

GO
/* SurveyId add foreign key*/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SurveyResponse_Surveys_SurveyId]') AND parent_object_id = OBJECT_ID(N'[dbo].[SurveyResponse]'))
ALTER TABLE [dbo].[SurveyResponse]  WITH CHECK ADD  CONSTRAINT [FK_SurveyResponse_Surveys_SurveyId] FOREIGN KEY([SurveyId])
REFERENCES [dbo].[Surveys] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SurveyResponse_Surveys_SurveyId]') AND parent_object_id = OBJECT_ID(N'[dbo].[SurveyResponse]'))
ALTER TABLE [dbo].[SurveyResponse] CHECK CONSTRAINT [FK_SurveyResponse_Surveys_SurveyId]

Go
/* EmployeeId add foreign key */
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SurveyResponse_EmployeeData_EmployeeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[SurveyResponse]'))
ALTER TABLE [dbo].[SurveyResponse]  WITH CHECK ADD  CONSTRAINT [FK_SurveyResponse_EmployeeData_EmployeeId] FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[EmployeeData] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SurveyResponse_EmployeeData_EmployeeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[SurveyResponse]'))
ALTER TABLE [dbo].[SurveyResponse] CHECK CONSTRAINT [FK_SurveyResponse_EmployeeData_EmployeeId]
GO
IF EXISTS (SELECT * FROM sys.columns WHERE Name = N'EffectiveDate' AND Object_ID = OBJECT_ID(N'[CompanyPolicy]'))
BEGIN
ALTER TABLE [CompanyPolicy] ALTER COLUMN EffectiveDate datetime 
END
Go
IF EXISTS (SELECT * FROM sys.columns WHERE Name = N'EffectiveDate' AND Object_ID = OBJECT_ID(N'[CompanyPolicyHistory]'))
BEGIN
ALTER TABLE [CompanyPolicyHistory] ALTER COLUMN EffectiveDate datetime 
END
Go
IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'CertificateExpiry' AND Object_ID = OBJECT_ID(N'[UserCertificate]'))
BEGIN
ALTER TABLE [UserCertificate] ADD [CertificateExpiry] DATE NULL
END
GO

IF  EXISTS (SELECT * FROM sys.columns WHERE Name = N'EffectiveDate' AND Object_ID = OBJECT_ID(N'[CompanyPolicy]'))
BEGIN
ALTER TABLE [CompanyPolicy] Drop column EffectiveDate
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'EffectiveDate' AND Object_ID = OBJECT_ID(N'[CompanyPolicys]'))
BEGIN
ALTER TABLE [CompanyPolicy] ADD  EffectiveDate datetime
END
GO
