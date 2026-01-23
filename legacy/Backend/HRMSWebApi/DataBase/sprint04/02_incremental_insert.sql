USE [HRMS]

GO
 IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Permission_Module]') AND parent_object_id = OBJECT_ID(N'[dbo].[Permission]'))
 Begin
	ALTER TABLE [dbo].[Permission] DROP CONSTRAINT [FK_Permission_Module]  
	End
 GO
 IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_RolePermission_Permission_PermissionId]') AND parent_object_id = OBJECT_ID(N'[dbo].[RolePermission]'))
 Begin
	ALTER TABLE [dbo].[RolePermission] DROP CONSTRAINT [FK_RolePermission_Permission_PermissionId]  
	End
 GO 
 IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Menu_Parent]') AND parent_object_id = OBJECT_ID(N'[dbo].[Menu]'))
  BEGIN
   ALTER TABLE [dbo].[Menu] DROP CONSTRAINT FK_Menu_Parent;
  END
  IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_MenuPermission_Menu]') AND parent_object_id = OBJECT_ID(N'[dbo].[MenuPermission]'))
  BEGIN
  ALTER TABLE [dbo].[MenuPermission] DROP CONSTRAINT FK_MenuPermission_Menu;
  END
  IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_MenuPermission_Permission]') AND parent_object_id = OBJECT_ID(N'[dbo].[MenuPermission]'))
  BEGIN
  ALTER TABLE [dbo].[MenuPermission] DROP CONSTRAINT FK_MenuPermission_Permission;
  END

   Truncate Table [dbo].[Module]
  SET IDENTITY_INSERT [dbo].[Module] ON

  INSERT INTO [dbo].[Module]([Id],[ModuleName],[IsActive],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn])VALUES(1,'Employee Creation',1,'admin',GETDATE(),NULL,NULL)
  INSERT INTO [dbo].[Module]([Id],[ModuleName],[IsActive],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn])VALUES(2,'Personal Details',1,'admin',GETDATE(),NULL,NULL)
  INSERT INTO [dbo].[Module]([Id],[ModuleName],[IsActive],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn])VALUES(3,'Nominee Details',1,'admin',GETDATE(),NULL,NULL)
  INSERT INTO [dbo].[Module]([Id],[ModuleName],[IsActive],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn])VALUES(4,'Employment Details',1,'admin',GETDATE(),NULL,NULL)
  INSERT INTO [dbo].[Module]([Id],[ModuleName],[IsActive],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn])VALUES(5,'Educational Details',1,'admin',GETDATE(),NULL,NULL)
  INSERT INTO [dbo].[Module]([Id],[ModuleName],[IsActive],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn])VALUES(6,'Role',1,'admin',GETDATE(),NULL,NULL)
  INSERT INTO [dbo].[Module]([Id],[ModuleName],[IsActive],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn])VALUES(7,'Email Notification',1,'admin',GETDATE(),NULL,NULL)
  INSERT INTO [dbo].[Module]([Id],[ModuleName],[IsActive],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn])VALUES(8,'Employee Group',1,'admin',GETDATE(),NULL,NULL)
  INSERT INTO [dbo].[Module]([Id],[ModuleName],[IsActive],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn])VALUES(9,'Survey Report',1,'admin',GETDATE(),NULL,NULL)
  INSERT INTO [dbo].[Module]([Id],[ModuleName],[IsActive],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn])VALUES(10,'My Surveys',1,'admin',GETDATE(),NULL,NULL)
  INSERT INTO [dbo].[Module]([Id],[ModuleName],[IsActive],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn])VALUES(11,'Events',1,'admin',GETDATE(),NULL,NULL)
  INSERT INTO [dbo].[Module]([Id],[ModuleName],[IsActive],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn])VALUES(12,'Company Policy',1,'admin',GETDATE(),NULL,NULL)
  INSERT INTO [dbo].[Module]([Id],[ModuleName],[IsActive],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn])VALUES(13,'Survey',1,'admin',GETDATE(),NULL,NULL)

  SET IDENTITY_INSERT [dbo].[Module] OFF
 Go


  Truncate Table [dbo].[Permission] 
  SET IDENTITY_INSERT [dbo].[Permission] ON

 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(1,'Read Employee Creation',1,'admin',GETDATE(),NULL,NULL,0,'Read.EmployeeCreation')
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(2,'Create Employee Creation',1,'admin',GETDATE(),NULL,NULL,0,'Create.EmployeeCreation')
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(3,'Edit Employee Creation',1,'admin',GETDATE(),NULL,NULL,0,'Edit.EmployeeCreation')
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(4,'Delete Employee Creation',1,'admin',GETDATE(),NULL,NULL,0,'Delete.EmployeeCreation')
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(5,'View Employee Creation',1,'admin',GETDATE(),NULL,NULL,0,'View.EmployeeCreation')

 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(6,'Read Personal Details',2,'admin',GETDATE(),NULL,NULL,0,'Read.PersonalDetails')
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(7,'Create Personal Details',2,'admin',GETDATE(),NULL,NULL,0,'Create.PersonalDetails')
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(8,'Edit Personal Details',2,'admin',GETDATE(),NULL,NULL,0,'Edit.PersonalDetails')
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(9,'Delete Personal Details',2,'admin',GETDATE(),NULL,NULL,0,'Delete.PersonalDetails')
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(10,'View Personal Details',2,'admin',GETDATE(),NULL,NULL,0,'View.PersonalDetails')

 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(11,'Read Nominee Details',3,'admin',GETDATE(),NULL,NULL,0,'Read.NomineeDetails')
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(12,'Create Nominee Details',3,'admin',GETDATE(),NULL,NULL,0,'Create.NomineeDetails')
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(13,'Edit Nominee Details',3,'admin',GETDATE(),NULL,NULL,0,'Edit.NomineeDetails')
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(14,'Delete Nominee Details',3,'admin',GETDATE(),NULL,NULL,0,'Delete.NomineeDetails')
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(15,'View Nominee Details',3,'admin',GETDATE(),NULL,NULL,0,'View.NomineeDetails')

 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(16,'Read Employment Details',4,'admin',GETDATE(),NULL,NULL,0,'Read.EmploymentDetails')
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(17,'Create Employment Details',4,'admin',GETDATE(),NULL,NULL,0,'Create.EmploymentDetails')
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(18,'Edit Employment Details',4,'admin',GETDATE(),NULL,NULL,0,'Edit.EmploymentDetails')
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(19,'Delete Employment Details',4,'admin',GETDATE(),NULL,NULL,0,'Delete.EmploymentDetails')
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(20,'View Employment Details',4,'admin',GETDATE(),NULL,NULL,0,'View.EmploymentDetails')

 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(21,'Read Educational Details',5,'admin',GETDATE(),NULL,NULL,0,'Read.EducationalDetails')
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(22,'Create Educational Details',5,'admin',GETDATE(),NULL,NULL,0,'Create.EducationalDetails')
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(23,'Edit Educational Details',5,'admin',GETDATE(),NULL,NULL,0,'Edit.EducationalDetails')
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(24,'Delete Educational Details',5,'admin',GETDATE(),NULL,NULL,0,'Delete.EducationalDetails')
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(25,'View Educational Details',5,'admin',GETDATE(),NULL,NULL,0,'View.EducationalDetails')

 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(26,'Read Role',6,'admin',GETDATE(),NULL,NULL,0,'Read.Role')
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(27,'Create Role',6,'admin',GETDATE(),NULL,NULL,0,'Create.Role')
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(28,'Edit Role',6,'admin',GETDATE(),NULL,NULL,0,'Edit.Role')
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(29,'Delete Role',6,'admin',GETDATE(),NULL,NULL,0,'Delete.Role')
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(30,'View Role',6,'admin',GETDATE(),NULL,NULL,0,'View.Role')
 
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(31,'Read Email Notification',7,'admin',GETDATE(),NULL,NULL,0,'Read.EmailNotification')
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(32,'Create Email Notification',7,'admin',GETDATE(),NULL,NULL,0,'Create.EmailNotification')
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(33,'Edit Email Notification',7,'admin',GETDATE(),NULL,NULL,0,'Edit.EmailNotification')
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(34,'Delete Email Notification',7,'admin',GETDATE(),NULL,NULL,0,'Delete.EmailNotification')
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(35,'View Email Notification',7,'admin',GETDATE(),NULL,NULL,0,'View.EmailNotification')

 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(36,'Read Employee Group',8,'admin',GETDATE(),NULL,NULL,0,'Read.EmployeeGroup')
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(37,'Create Employee Group',8,'admin',GETDATE(),NULL,NULL,0,'Create.EmployeeGroup')
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(38,'Edit Employee Group',8,'admin',GETDATE(),NULL,NULL,0,'Edit.EmployeeGroup')
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(39,'Delete Employee Group',8,'admin',GETDATE(),NULL,NULL,0,'Delete.EmployeeGroup')
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(40,'View Employee Group',8,'admin',GETDATE(),NULL,NULL,0,'View.EmployeeGroup')


 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(41,'Read Survey Report',9,'admin',GETDATE(),NULL,NULL,0,'Read.SurveyReport')
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(42,'Create Survey Report',9,'admin',GETDATE(),NULL,NULL,0,'Create.SurveyReport')
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(43,'Edit Survey Report',9,'admin',GETDATE(),NULL,NULL,0,'Edit.SurveyReport')
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(44,'Delete Survey Report',9,'admin',GETDATE(),NULL,NULL,0,'Delete.SurveyReport')
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(45,'View Survey Report',9,'admin',GETDATE(),NULL,NULL,0,'View.SurveyReport')

 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(46,'Read My Surveys',10,'admin',GETDATE(),NULL,NULL,0,'Read.MySurveys')
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(47,'Create My Surveys',10,'admin',GETDATE(),NULL,NULL,0,'Create.MySurveys')
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(48,'Edit My Surveys',10,'admin',GETDATE(),NULL,NULL,0,'Edit.MySurveys')
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(49,'Delete My Surveys',10,'admin',GETDATE(),NULL,NULL,0,'Delete.MySurveys')
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(50,'View My Surveys',10,'admin',GETDATE(),NULL,NULL,0,'View.MySurveys')

 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(51,'Read Events',11,'admin',GETDATE(),NULL,NULL,0,'Read.Events')
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(52,'Create Events',11,'admin',GETDATE(),NULL,NULL,0,'Create.Events')
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(53,'Edit Events',11,'admin',GETDATE(),NULL,NULL,0,'Edit.Events')
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(54,'Delete Events',11,'admin',GETDATE(),NULL,NULL,0,'Delete.Events')
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(55,'View Events',11,'admin',GETDATE(),NULL,NULL,0,'View.Events')
 
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(56,'Read Company Policy',12,'admin',GETDATE(),NULL,NULL,0,'Read.CompanyPolicy')
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(57,'Create Company Policy',12,'admin',GETDATE(),NULL,NULL,0,'Create.CompanyPolicy')
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(58,'Edit Company Policy',12,'admin',GETDATE(),NULL,NULL,0,'Edit.CompanyPolicy')
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(59,'Delete Company Policy',12,'admin',GETDATE(),NULL,NULL,0,'Delete.CompanyPolicy')
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(60,'View Company Policy',12,'admin',GETDATE(),NULL,NULL,0,'View.CompanyPolicy')

 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(61,'Read Survey',13,'admin',GETDATE(),NULL,NULL,0,'Read.Survey')
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(62,'Create Survey',13,'admin',GETDATE(),NULL,NULL,0,'Create.Survey')
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(63,'Edit Survey',13,'admin',GETDATE(),NULL,NULL,0,'Edit.Survey')
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(64,'Delete Survey',13,'admin',GETDATE(),NULL,NULL,0,'Delete.Survey')
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(65,'View Survey',13,'admin',GETDATE(),NULL,NULL,0,'View.Survey')
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(66,'Publish Survey',13,'admin',GETDATE(),NULL,NULL,0,'Publish.Survey')

 
  SET IDENTITY_INSERT [dbo].[Permission] OFF
  Go


 Truncate Table [dbo].[RolePermission]
  SET IDENTITY_INSERT [dbo].[RolePermission] ON
  ----HR Role---
  --Employee
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(1,2,1,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(2,2,2,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(3,2,3,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(4,2,5,'admin',GETDATE(),NULL,NULL,1)
  --Personal Details
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(5,2,6,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(6,2,7,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(7,2,8,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(8,2,10,'admin',GETDATE(),NULL,NULL,1)
  --Nominee Details
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(9,2,15,'admin',GETDATE(),NULL,NULL,1)
  --Employment Details
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(10,2,16,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(11,2,17,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(12,2,20,'admin',GETDATE(),NULL,NULL,1)
  --Educational Details
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(13,2,21,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(14,2,22,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(15,2,25,'admin',GETDATE(),NULL,NULL,1)
  --Email Notification
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(16,2,31,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(17,2,32,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(18,2,33,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(19,2,34,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(20,2,35,'admin',GETDATE(),NULL,NULL,1)
  --Employee Group
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(21,2,36,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(22,2,37,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(23,2,38,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(24,2,39,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(25,2,40,'admin',GETDATE(),NULL,NULL,1)
  --Survey Report
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(26,2,41,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(27,2,42,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(28,2,43,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(29,2,44,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(30,2,45,'admin',GETDATE(),NULL,NULL,1)

  --My Surveys
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(31,2,46,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(32,2,47,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(33,2,48,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(34,2,49,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(35,2,50,'admin',GETDATE(),NULL,NULL,1)
  --Events
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(36,2,51,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(37,2,52,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(38,2,53,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(39,2,54,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(40,2,55,'admin',GETDATE(),NULL,NULL,1)
  --Company Policy
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(41,2,56,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(42,2,60,'admin',GETDATE(),NULL,NULL,1)

  --Survey
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(43,2,61,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(44,2,62,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(45,2,63,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(46,2,64,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(47,2,65,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(48,2,66,'admin',GETDATE(),NULL,NULL,1)

   ----Employee Role ----

   --Personal Details
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(49,3,6,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(50,3,7,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(51,3,8,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(52,3,9,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(53,3,10,'admin',GETDATE(),NULL,NULL,1)
  --Nominee Details
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(54,3,11,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(55,3,12,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(56,3,13,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(57,3,14,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(58,3,15,'admin',GETDATE(),NULL,NULL,1)
  --Employment Details
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(59,3,16,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(60,3,17,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(61,3,18,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(62,3,19,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(63,3,20,'admin',GETDATE(),NULL,NULL,1)
  --Educational Details
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(64,3,21,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(65,3,22,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(66,3,23,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(67,3,24,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(68,3,25,'admin',GETDATE(),NULL,NULL,1)
  --Employee Group  
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(69,3,36,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(70,3,40,'admin',GETDATE(),NULL,NULL,1)
  -- Survey
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(71,3,61,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(72,3,65,'admin',GETDATE(),NULL,NULL,1)
  --My Surveys
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(73,3,46,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(74,3,50,'admin',GETDATE(),NULL,NULL,1)
  --Events
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(75,3,51,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(76,3,55,'admin',GETDATE(),NULL,NULL,1)
  --Company Policy  
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(77,3,56,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(78,3,60,'admin',GETDATE(),NULL,NULL,1)
  --Survey
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(79,3,61,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(80,3,65,'admin',GETDATE(),NULL,NULL,1)

 ----Super Admin----
 
 --Employee Creation 
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(81,1,1,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(82,1,2,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(83,1,3,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(84,1,4,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(85,1,5,'admin',GETDATE(),NULL,NULL,1)
  --Personal Details
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(86,1,6,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(87,1,7,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(88,1,8,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(89,1,9,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(90,1,10,'admin',GETDATE(),NULL,NULL,1)
  --Nominee Details
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(91,1,11,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(92,1,12,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(93,1,13,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(94,1,14,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(95,1,15,'admin',GETDATE(),NULL,NULL,1)
  -- Employment Details
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(96,1,16,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(97,1,17,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(98,1,18,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(99,1,19,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(100,1,20,'admin',GETDATE(),NULL,NULL,1)
  --Educational Details
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(101,1,21,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(102,1,22,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(103,1,23,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(104,1,24,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(105,1,25,'admin',GETDATE(),NULL,NULL,1)
  --Role
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(106,1,26,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(107,1,27,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(108,1,28,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(109,1,29,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(110,1,30,'admin',GETDATE(),NULL,NULL,1)
  --Email Notification
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(111,1,31,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(112,1,32,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(113,1,33,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(114,1,34,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(115,1,35,'admin',GETDATE(),NULL,NULL,1)
  --Employee Group
   INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(116,1,36,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(117,1,37,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(118,1,38,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(119,1,39,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(120,1,40,'admin',GETDATE(),NULL,NULL,1)
  --Survey Report
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(121,1,41,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(122,1,42,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(123,1,43,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(124,1,44,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(125,1,45,'admin',GETDATE(),NULL,NULL,1)
  --My Surveys
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(126,1,46,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(127,1,47,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(128,1,48,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(129,1,49,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(130,1,50,'admin',GETDATE(),NULL,NULL,1)
  --Events
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(131,1,51,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(132,1,52,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(133,1,53,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(134,1,54,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(135,1,55,'admin',GETDATE(),NULL,NULL,1)
  --Company Policy
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(136,1,56,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(137,1,57,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(138,1,58,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(139,1,59,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(140,1,60,'admin',GETDATE(),NULL,NULL,1)
  
   --Survey
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(141,1,61,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(142,1,62,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(143,1,63,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(144,1,64,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(145,1,65,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(146,1,66,'admin',GETDATE(),NULL,NULL,1)

  SET IDENTITY_INSERT [dbo].[RolePermission] OFF
  Go  

 Truncate Table [dbo].[Menu]
 SET IDENTITY_INSERT [dbo].[Menu] ON

 INSERT INTO [dbo].[Menu]([Id],[Name],[ApiEndPoint],[ParentMenuId],[CreatedBy],[CreatedOn],[IsDeleted])
Values(1,'Employees','/api/EmployeeGroup/GetAllEmployees',null,'admin',Getdate(),0),
      (2,'Roles','/api/RolePermission/GetRoles',null,'admin',Getdate(),0),
	  (3,'Settings',null,null,'admin',Getdate(),0),
	  (4,'Employee Group','/api/EmployeeGroup/GetEmployeeGroupList',null,'admin',Getdate(),0),
	  (5,'Survey',null,null,'admin',Getdate(),0),
	  (6,'Events','/api/',null,'admin',Getdate(),0), 
	  (7,'Company Policy','/api/CompanyPolicy/GetCompanyPolicies',null,'admin',Getdate(),0),
	  (8,'Survey Report',null,5,'admin',Getdate(),0),
	  (9,'My surveys',null,5,'admin',Getdate(),0),
	  (10,'Email and Notification','/api/',3,'admin',Getdate(),0)
	 
  SET IDENTITY_INSERT [dbo].[Menu] OFF

   Truncate Table [dbo].[MenuPermission]
   SET IDENTITY_INSERT [dbo].[MenuPermission] ON
  INSERT INTO [dbo].[MenuPermission]([Id],[MenuId],[ReadPermissionId],[CreatedBy],[CreatedOn])
  Values (1,1,1,'admin',Getdate()),
       (2,2,26,'admin',Getdate()),
	   (3,3,31,'admin',Getdate()),
	   (4,4,36,'admin',Getdate()),
	   (5,5,61,'admin',Getdate()),
	   (6,6,51,'admin',Getdate()),
	   (7,7,56,'admin',Getdate()),
	   (8,8,61,'admin',Getdate()),
	   (9,9,61,'admin',Getdate()),
	   (10,10,31,'admin',Getdate()),
	   (11,1,6,'admin',Getdate()),
	   (12,1,11,'admin',Getdate()),
	   (13,1,16,'admin',Getdate()),
	   (14,1,21,'admin',Getdate())
  SET IDENTITY_INSERT [dbo].[MenuPermission] OFF

    IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Menu_Parent]') AND parent_object_id = OBJECT_ID(N'[dbo].[Menu]'))
  BEGIN
   ALTER TABLE [dbo].[Menu]  WITH CHECK ADD  CONSTRAINT [FK_Menu_Parent] FOREIGN KEY(ParentMenuId) REFERENCES [Menu](Id)
  END
  IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_MenuPermission_Menu]') AND parent_object_id = OBJECT_ID(N'[dbo].[MenuPermission]'))
  BEGIN
   ALTER TABLE [dbo].[MenuPermission]  WITH CHECK ADD  CONSTRAINT [FK_MenuPermission_Menu]FOREIGN KEY(MenuId) REFERENCES [Menu](Id)
  END
   IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_MenuPermission_Permission]') AND parent_object_id = OBJECT_ID(N'[dbo].[MenuPermission]'))
  BEGIN
   ALTER TABLE [dbo].[MenuPermission]  WITH CHECK ADD  CONSTRAINT [FK_MenuPermission_Permission]FOREIGN KEY(ReadPermissionId) REFERENCES [Permission](Id)
  END
  IF Not EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Permission_Module]') AND parent_object_id = OBJECT_ID(N'[dbo].[Permission]'))
  ALTER TABLE [dbo].[Permission]  WITH CHECK ADD  CONSTRAINT [FK_Permission_Module] FOREIGN KEY([ModuleId])	REFERENCES [dbo].[Module] ([Id])

  IF Not EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_RolePermission_Permission_PermissionId]') AND parent_object_id = OBJECT_ID(N'[dbo].[RolePermission]'))
  ALTER TABLE [dbo].[RolePermission]  WITH CHECK ADD  CONSTRAINT [FK_RolePermission_Permission_PermissionId] FOREIGN KEY([PermissionId])	REFERENCES [dbo].[Permission] ([Id])
  
Go

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


SET IDENTITY_INSERT [dbo].[University] ON
TRUNCATE TABLE [dbo].[University]
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (1,'Indian Institute of Science (IISc)' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (2,'Jawaharlal Nehru University (JNU)' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (3,'Jamia Millia Islamia (JMI)' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (4,'Jadavpur University (JU)' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (5,'Banaras Hindu University (BHU)' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (6,'Manipal Academy of Higher Education-Manipal (MAHEM)' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (7,'Amrita Vishwa Vidyapeetham (AVV)' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (8,'Vellore Institute of Technology (VIT)' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (9,'Aligarh Muslim University (AMU)' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (10,'University of Hyderabad' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (11,'University of Delhi' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (12,'Calcutta University' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (13,'Saveetha Institute of Medical and Technical Sciences' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (14,'Anna University' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (15,'Siksha `O` Anusandhan' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (16,'Kalinga Institute of Industrial Technology' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (17,'Homi Bhabha National Institute' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (18,'S.R.M. Institute of Science and Technology' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (19,'Savitribai Phule Pune University' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (20,'Birla Institute of Technology & Science -Pilani' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (21,'Bharathiar University' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (22,'Thapar Institute of Engineering and Technology (Deemed-to-be-university)' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (23,'Institute of Chemical Technology' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (24,'Kerala University' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (25,'Panjab University' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (26,'Shanmugha Arts Science Technology & Research Academy' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (27,'Chandigarh University' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (28,'Koneru Lakshmaiah Education Foundation University (K L College of Engineering)' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (29,'Kalasalingam Academy of Research and Education' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (30,'Alagappa University' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (31,'Mahatma Gandhi University, Kottayam' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (32,'Symbiosis International' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (33,'University of Kashmir' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (34,'JSS Academy of Higher Education and Research' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (35,'Amity University' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (36,'Osmania University' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (37,'Cochin University of Science and Technology' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (38,'Lovely Professional University' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (39,'Datta Meghe Institute of Higher Education and Research' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (40,'Delhi Technological University' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (41,'Bharathidasan University' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (42,'Babasheb Bhimrao Ambedkar University' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (43,'Andhra University, Visakhapatnam' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (44,'Mysore University' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (45,'King George`s Medical University' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (46,'Dr. D. Y. Patil Vidyapeeth' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (47,'SVKM`s Narsee Monjee Institute of Management Studies' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (48,'Guru Nanak Dev University' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (49,'Jamia Hamdard' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (50,'University of Madras' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (51,'Sathyabama Institute of Science and Technology' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (52,'UPES' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (53,'Madurai Kamaraj University' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (54,'Punjab Agricultural University, Ludhiana' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (55,'Graphic Era University' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (56,'Mumbai University' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (57,'Sri Ramachandra Institute of Higher Education and Research' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (58,'Banasthali Vidyapith' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (59,'Periyar University' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (60,'Sri Venkateswara University' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (61,'Gujarat University' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (62,'Shiv Nadar University' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (63,'University of Jammu' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (64,'Visvesvaraya Technological University' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (65,'NITTE' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (66,'Bharath Institute of Higher Education & Research' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (67,'Christ University' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (68,'Jain university,Bangalore' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (69,'Tezpur University' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (70,'Calicut University, Thenhipalem, Malapuram' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[University] ([Id],[UniversityName] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) 
VALUES (71,'Birla Institute of Technology' ,'admin',GETDATE(),NULL,NULL,0 )
SET IDENTITY_INSERT [dbo].[University] OFF
GO

SET IDENTITY_INSERT [dbo].[DocumentType] ON
INSERT INTO [dbo].[DocumentType]([Id],[Name],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[IdProofFor],[ISExpiryDateRequired])VALUES(6,'Birth Certificate ','admin',GETDATE(),NULL,NULL,0,2,0)
SET IDENTITY_INSERT [dbo].[DocumentType] OFF
GO

IF EXISTS (SELECT * FROM sys.columns WHERE Name = N'IdProofFor' AND Object_ID = OBJECT_ID(N'[DocumentType]'))
BEGIN
UPDATE [DocumentType] SET IdProofFor = 3 WHERE id IN (1,2);
UPDATE [DocumentType] SET IdProofFor = 1 WHERE id IN (3,4,5);
UPDATE [DocumentType] SET IdProofFor = 2 WHERE id IN (6);
End
GO

IF EXISTS (SELECT * FROM sys.columns WHERE Name = N'ISExpiryDateRequired' AND Object_ID = OBJECT_ID(N'[DocumentType]'))
BEGIN
UPDATE [DocumentType] SET ISExpiryDateRequired = 1 WHERE id IN (3,5);
UPDATE [DocumentType] SET ISExpiryDateRequired = 0 WHERE id IN (1,2,4,6);
End
GO

SET IDENTITY_INSERT [dbo].[NotificationTemplateType] ON
TRUNCATE TABLE [dbo].[NotificationTemplateType]
INSERT INTO  [dbo].[NotificationTemplateType] ([Id],[TemplateType] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) VALUES (1,'Welcome' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[NotificationTemplateType] ([Id],[TemplateType] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) VALUES (2,'Anniversary' ,'admin',GETDATE(),NULL,NULL,0 )
INSERT INTO  [dbo].[NotificationTemplateType] ([Id],[TemplateType] ,[CreatedBy] ,[CreatedOn] ,[ModifiedBy] ,[ModifiedOn] ,[IsDeleted]) VALUES (3,'Birthday' ,'admin',GETDATE(),NULL,NULL,0 )
SET IDENTITY_INSERT [dbo].[NotificationTemplateType] OFF
GO
