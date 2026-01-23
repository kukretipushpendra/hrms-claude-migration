IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_EmploymentDetail_BranchId]') AND parent_object_id = OBJECT_ID(N'[dbo].[EmploymentDetail]'))
ALTER TABLE [dbo].[EmploymentDetail]   DROP CONSTRAINT [FK_EmploymentDetail_BranchId] 
GO

SET IDENTITY_INSERT [dbo].[Branch] ON
truncate table [dbo].[Branch]
INSERT INTO [dbo].[Branch]([Id],[Name],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted]) VALUES(1,'Hyderabad','admin',getdate(),null,null,0)
INSERT INTO [dbo].[Branch]([Id],[Name],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted]) VALUES(2,'Jaipur','admin',getdate(),null,null,0)
INSERT INTO [dbo].[Branch]([Id],[Name],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted]) VALUES(3,'Pune','admin',getdate(),null,null,0)
SET IDENTITY_INSERT [dbo].[Branch] OFF
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_EmploymentDetail_BranchId]') AND parent_object_id = OBJECT_ID(N'[dbo].[EmploymentDetail]'))
ALTER TABLE [dbo].[EmploymentDetail]  WITH CHECK ADD  CONSTRAINT [FK_EmploymentDetail_BranchId] FOREIGN KEY([BranchId])
REFERENCES [dbo].[Branch] ([Id])
GO


SET IDENTITY_INSERT [dbo].[Relationship] ON
truncate table [dbo].[Relationship]
INSERT INTO [dbo].[Relationship]([Id],[Name],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted]) VALUES(1,'Daughter','admin',getdate(),null,null,0)
INSERT INTO [dbo].[Relationship]([Id],[Name],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted]) VALUES(2,'Father','admin',getdate(),null,null,0)
INSERT INTO [dbo].[Relationship]([Id],[Name],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted]) VALUES(3,'Mother','admin',getdate(),null,null,0)
INSERT INTO [dbo].[Relationship]([Id],[Name],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted]) VALUES(4,'Son','admin',getdate(),null,null,0)
INSERT INTO [dbo].[Relationship]([Id],[Name],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted]) VALUES(5,'Spouse','admin',getdate(),null,null,0)
INSERT INTO [dbo].[Relationship]([Id],[Name],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted]) VALUES(6,'Others','admin',getdate(),null,null,0)
SET IDENTITY_INSERT [dbo].[Relationship] OFF
SET IDENTITY_INSERT [dbo].[Branch] OFF

SET IDENTITY_INSERT [dbo].[EmployerDocumentType] ON
TRUNCATE TABLE [dbo].[EmployerDocumentType]
INSERT INTO  [dbo].[EmployerDocumentType] ([Id],[DocumentName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) VALUES (1,'Offer Letter' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[EmployerDocumentType] ([Id],[DocumentName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) VALUES (2,'Appointment Letter' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[EmployerDocumentType] ([Id],[DocumentName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) VALUES (3,'Experience Letter' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[EmployerDocumentType] ([Id],[DocumentName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) VALUES (4,'Increment Letter','admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[EmployerDocumentType] ([Id],[DocumentName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) VALUES (5,'Bank Statements' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[EmployerDocumentType] ([Id],[DocumentName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) VALUES (6,'Cancelled Cheque' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[EmployerDocumentType] ([Id],[DocumentName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) VALUES (7,'Past Salary Slips' ,'admin',GETDATE(),NULL,NULL,0 )
SET IDENTITY_INSERT [dbo].[EmployerDocumentType] OFF
GO
 