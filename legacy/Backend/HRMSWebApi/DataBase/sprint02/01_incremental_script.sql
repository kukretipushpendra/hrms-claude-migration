
Go
IF EXISTS (SELECT * FROM sys.columns WHERE Name = N'Location' AND Object_ID = OBJECT_ID(N'[CompanyPolicy]'))
BEGIN
ALTER TABLE [CompanyPolicy] Drop Column [Location]  
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'FileOriginalName' AND Object_ID = OBJECT_ID(N'[CompanyPolicy]'))
BEGIN
ALTER TABLE [CompanyPolicy] ADD FileOriginalName VARCHAR(255) 
END
GO
IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'FileName' AND Object_ID = OBJECT_ID(N'[CompanyPolicy]'))
BEGIN
ALTER TABLE [CompanyPolicy] ADD  [FileName] VARCHAR(255) 
END
GO

IF EXISTS (SELECT * FROM sys.columns WHERE Name = N'Location' AND Object_ID = OBJECT_ID(N'[CompanyPolicyHistory]'))
BEGIN
ALTER TABLE [CompanyPolicyHistory] Drop COLUMN [Location]  
END
GO
IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'FileOriginalName' AND Object_ID = OBJECT_ID(N'[CompanyPolicyHistory]'))
BEGIN
ALTER TABLE [CompanyPolicyHistory] ADD FileOriginalName VARCHAR(255) 
END
GO
IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'FileName' AND Object_ID = OBJECT_ID(N'[CompanyPolicyHistory]'))
BEGIN
ALTER TABLE [CompanyPolicyHistory] ADD [FileName] VARCHAR(255) 
END
GO

IF EXISTS (SELECT * FROM sys.columns WHERE Name = N'District' AND Object_ID = OBJECT_ID(N'[Address]'))
BEGIN
ALTER TABLE [Address] Drop Column [District]  
END
GO

IF EXISTS (SELECT * FROM sys.columns WHERE Name = N'City' AND Object_ID = OBJECT_ID(N'[Address]'))
BEGIN
ALTER TABLE [Address] Drop COLUMN [City] 
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'CityId' AND Object_ID = OBJECT_ID(N'[Address]'))
BEGIN
ALTER TABLE [Address] ADD [CityId] bigint 
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Address_City_CityId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Address]'))
ALTER TABLE [dbo].[Address]  WITH CHECK ADD  CONSTRAINT [FK_Address_City_CityId] FOREIGN KEY([CityId])
REFERENCES [dbo].[City] ([Id])
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Address_City_CityId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Address]'))
ALTER TABLE [dbo].[Address] CHECK CONSTRAINT [FK_Address_City_CityId]

GO
 

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[City]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[City](
	[Id] [bigint]IDENTITY(1,1) NOT NULL,
	[StateId] [bigint] NOT NULL,
	[CityName] [varchar](200) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[CreatedBy] [varchar](250) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [varchar](250) NULL,
	[ModifiedOn] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
End
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_City_State_StateId]') AND parent_object_id = OBJECT_ID(N'[dbo].[City]'))
ALTER TABLE [dbo].[City]  WITH CHECK ADD  CONSTRAINT [FK_City_State_StateId] FOREIGN KEY([StateId]) REFERENCES [dbo].[State] ([Id]) 
GO
IF NOT EXISTS(SELECT * FROM sys.columns   WHERE Name = N'Status'   AND Object_ID = Object_ID(N'Group'))
BEGIN
ALTER TABLE [dbo].[Group]
ADD [STATUS] bit NULL
END 
GO

IF NOT EXISTS(SELECT * FROM sys.columns   WHERE Name = N'shortname'   AND Object_ID = Object_ID(N'Country'))
BEGIN
ALTER TABLE [Country] ADD  shortname varchar(10) NULL;
END
GO

IF EXISTS (SELECT * FROM sys.columns WHERE Name = N'CountryId' AND Object_ID = OBJECT_ID(N'[Address]'))
BEGIN

	IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Address_Country_CountryId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Address]'))
	BEGIN
	ALTER TABLE [dbo].[Address]  DROP CONSTRAINT [FK_Address_Country_CountryId]  
	END
	ALTER TABLE [Address] Drop COLUMN CountryId 
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'CountryId' AND Object_ID = OBJECT_ID(N'[Address]'))
BEGIN
ALTER TABLE [Address] ADD CountryId bigint 

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Address_Country_CountryId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Address]'))
ALTER TABLE [dbo].[Address]  WITH CHECK ADD  CONSTRAINT [FK_Address_Country_CountryId] FOREIGN KEY([CountryId])
REFERENCES [dbo].[Country] ([Id]) 

END 
GO

IF EXISTS (SELECT * FROM sys.columns WHERE Name = N'StateId' AND Object_ID = OBJECT_ID(N'[Address]'))
BEGIN

	IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Address_State_StateId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Address]'))
	BEGIN
	ALTER TABLE [dbo].[Address]  DROP CONSTRAINT [FK_Address_State_StateId]  
	END
	ALTER TABLE [Address] Drop COLUMN StateId 
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'StateId' AND Object_ID = OBJECT_ID(N'[Address]'))
BEGIN
	ALTER TABLE [Address] ADD StateId bigint
	
	IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Address_State_StateId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Address]'))
	ALTER TABLE [dbo].[Address]  WITH CHECK ADD  CONSTRAINT [FK_Address_State_StateId] FOREIGN KEY([StateId])
	REFERENCES [dbo].[State] ([Id]) 
END
GO
IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'Others' AND Object_ID = OBJECT_ID(N'[UserNomineeInfo]'))
BEGIN
   ALTER TABLE [dbo].[UserNomineeInfo] ADD  Others NVARCHAR(150) NULL
END
GO
IF EXISTS (SELECT * FROM sys.columns WHERE Name = N'Percentage' AND Object_ID = OBJECT_ID(N'[UserNomineeInfo]'))
BEGIN
   ALTER TABLE [dbo].[UserNomineeInfo] ALTER COLUMN  Percentage TINYINT NOT NULL
END
GO
IF EXISTS (SELECT * FROM sys.columns WHERE Name = N'CareOf' AND Object_ID = OBJECT_ID(N'[UserNomineeInfo]'))
BEGIN
   ALTER TABLE [dbo].[UserNomineeInfo] ALTER COLUMN  CareOf VARCHAR(150) NULL
END
GO

Go
IF EXISTS (SELECT * FROM sys.columns WHERE Name = N'DocumentContent' AND Object_ID = OBJECT_ID(N'[CompanyPolicy]'))
BEGIN
ALTER TABLE [CompanyPolicy] Drop Column [DocumentContent]  
END

GO

IF EXISTS (SELECT * FROM sys.columns WHERE Name = N'DocumentContent' AND Object_ID = OBJECT_ID(N'[CompanyPolicyHistory]'))
BEGIN
ALTER TABLE [CompanyPolicyHistory] Drop COLUMN [DocumentContent]  
END
GO
GO
IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'Description' AND Object_ID = OBJECT_ID(N'[CompanyPolicyHistory]'))
BEGIN
ALTER TABLE [CompanyPolicyHistory] ADD [Description] NVARCHAR(500) 
END
GO

GO
IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'Description' AND Object_ID = OBJECT_ID(N'[CompanyPolicy]'))
BEGIN
ALTER TABLE [CompanyPolicy] ADD [Description] NVARCHAR(500) 
END
GO

