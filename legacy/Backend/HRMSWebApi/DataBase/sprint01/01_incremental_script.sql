
IF EXISTS(SELECT * FROM sys.columns   WHERE Name = N'EffectiveDate'   AND Object_ID = Object_ID(N'CompanyPolicy'))
BEGIN
ALTER TABLE [CompanyPolicy] ALTER COLUMN EffectiveDate [Date]  NOT NULL;
END
GO

IF EXISTS(SELECT * FROM sys.columns   WHERE Name = N'EffectiveDate'   AND Object_ID = Object_ID(N'CompanyPolicyHistory'))
BEGIN
ALTER TABLE [CompanyPolicyHistory] ALTER COLUMN EffectiveDate [Date]  NOT NULL;
END
GO

IF EXISTS(SELECT * FROM sys.columns   WHERE Name = N'StartDate'   AND Object_ID = Object_ID(N'Events'))
BEGIN
ALTER TABLE [Events] ALTER COLUMN StartDate [Date]  NOT NULL;
END
GO


IF EXISTS(SELECT * FROM sys.columns   WHERE Name = N'EndDate'   AND Object_ID = Object_ID(N'Events'))
BEGIN
ALTER TABLE [Events] ALTER COLUMN EndDate [Date]  NOT NULL;
END
GO


IF EXISTS(SELECT * FROM sys.columns   WHERE Name = N'DOB'   AND Object_ID = Object_ID(N'UserNomineeInfo'))
BEGIN
ALTER TABLE [UserNomineeInfo] ALTER COLUMN DOB [Date]  NOT NULL;
END
GO


IF EXISTS(SELECT * FROM sys.columns   WHERE Name = N'DateOfJoining'   AND Object_ID = Object_ID(N'UserDocument'))
BEGIN
ALTER TABLE [UserDocument] ALTER COLUMN DocumentExpiry [Date] NULL;
END
GO

IF EXISTS(SELECT * FROM sys.columns   WHERE Name = N'YearOfPassing'   AND Object_ID = Object_ID(N'UserQualificationInfo'))
BEGIN
ALTER TABLE [UserQualificationInfo] ALTER COLUMN YearOfPassing [Date]  NOT NULL;
END
GO

IF EXISTS(SELECT * FROM sys.columns   WHERE Name = N'IsActive'   AND Object_ID = Object_ID(N'Group'))
BEGIN
ALTER TABLE [Group] DROP COLUMN IsActive;
END
GO

IF EXISTS(SELECT * FROM sys.columns   WHERE Name = N'Description'   AND Object_ID = Object_ID(N'Group'))
BEGIN
ALTER TABLE [Group] ALTER COLUMN Description [text] NULL;
END
GO