SET IDENTITY_INSERT [dbo].[EmployerDocumentType] ON
TRUNCATE TABLE [dbo].[EmployerDocumentType]
INSERT INTO  [dbo].[EmployerDocumentType] ([Id], [DocumentName], [DocumentFor], [CreatedBy], [CreatedOn], [ModifiedBy], [ModifiedOn], [IsDeleted]) VALUES (1,'Offer Letter', 3,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[EmployerDocumentType] ([Id], [DocumentName], [DocumentFor], [CreatedBy], [CreatedOn], [ModifiedBy], [ModifiedOn], [IsDeleted]) VALUES (2,'Appointment Letter', 3,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[EmployerDocumentType] ([Id], [DocumentName], [DocumentFor], [CreatedBy], [CreatedOn], [ModifiedBy], [ModifiedOn], [IsDeleted]) VALUES (3,'Experience Letter', 1,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[EmployerDocumentType] ([Id], [DocumentName], [DocumentFor], [CreatedBy], [CreatedOn], [ModifiedBy], [ModifiedOn], [IsDeleted]) VALUES (4,'Increment Letter',3,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[EmployerDocumentType] ([Id], [DocumentName], [DocumentFor], [CreatedBy], [CreatedOn], [ModifiedBy], [ModifiedOn], [IsDeleted]) VALUES (5,'Bank Statements', 1,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[EmployerDocumentType] ([Id], [DocumentName], [DocumentFor], [CreatedBy], [CreatedOn], [ModifiedBy], [ModifiedOn], [IsDeleted]) VALUES (6,'Cancelled Cheque', 1,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[EmployerDocumentType] ([Id], [DocumentName], [DocumentFor], [CreatedBy], [CreatedOn], [ModifiedBy], [ModifiedOn], [IsDeleted]) VALUES (7,'Past Salary Slips', 1,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[EmployerDocumentType] ([Id], [DocumentName], [DocumentFor], [CreatedBy], [CreatedOn], [ModifiedBy], [ModifiedOn], [IsDeleted]) VALUES (8,'Confirmation Letter', 2,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[EmployerDocumentType] ([Id], [DocumentName], [DocumentFor], [CreatedBy], [CreatedOn], [ModifiedBy], [ModifiedOn], [IsDeleted]) VALUES (9,'Promotion Letter', 2,'admin',GETDATE(),NULL,NULL,0 )
SET IDENTITY_INSERT [dbo].[EmployerDocumentType] OFF
GO
