IF NOT EXISTS(SELECT 1 FROM [dbo].[Module] WHERE ID=14)
BEGIN
SET IDENTITY_INSERT [dbo].[Module] ON

  INSERT INTO [dbo].[Module]([Id],[ModuleName],[IsActive],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn])VALUES(14,'Certificate',1,'admin',GETDATE(),NULL,NULL)

SET IDENTITY_INSERT [dbo].[Module] OFF
END
Go
IF NOT EXISTS(SELECT 1 FROM [dbo].[Permission] WHERE ID IN(67,68,69,70,71))
BEGIN
SET IDENTITY_INSERT [dbo].[Permission] ON

 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(67,'Read Certificate',14,'admin',GETDATE(),NULL,NULL,0,'Read.Certificate')
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(68,'Create Certificate',14,'admin',GETDATE(),NULL,NULL,0,'Create.Certificate')
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(69,'Edit Certificate',14,'admin',GETDATE(),NULL,NULL,0,'Edit.Certificate')
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(70,'Delete Certificate',14,'admin',GETDATE(),NULL,NULL,0,'Delete.Certificate')
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(71,'View Certificate',14,'admin',GETDATE(),NULL,NULL,0,'View.Certificate')

 SET IDENTITY_INSERT [dbo].[Permission] OFF
 END
GO
IF NOT EXISTS(SELECT 1 FROM [dbo].[Module] WHERE ID =15)
BEGIN
   SET IDENTITY_INSERT [dbo].[Module] ON
   INSERT INTO [dbo].[Module]([Id],[ModuleName],[IsActive],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn])VALUES(15,'Professional Reference',1,'admin',GETDATE(),NULL,NULL)
   SET IDENTITY_INSERT [dbo].[Module] OFF
END
GO
   IF NOT EXISTS(SELECT 1 FROM [dbo].[Permission] WHERE ID IN(72,73,74,75,76))
BEGIN
SET IDENTITY_INSERT [dbo].[Permission] ON
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(72,'Read ProfessionalReference',15,'admin',GETDATE(),NULL,NULL,0,'Read.ProfessionalReference')
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(73,'Create ProfessionalReference',15,'admin',GETDATE(),NULL,NULL,0,'Create.ProfessionalReference')
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(74,'Edit ProfessionalReference',15,'admin',GETDATE(),NULL,NULL,0,'Edit.ProfessionalReference')
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(75,'Delete ProfessionalReference',15,'admin',GETDATE(),NULL,NULL,0,'Delete.ProfessionalReference')
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(76,'View ProfessionalReference',15,'admin',GETDATE(),NULL,NULL,0,'View.ProfessionalReference')
SET IDENTITY_INSERT [dbo].[Permission] OFF
END
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
  GO 
 Truncate Table [dbo].[Menu]
 SET IDENTITY_INSERT [dbo].[Menu] ON 
 INSERT INTO [dbo].[Menu]([Id],[Name],[ApiEndPoint],[ParentMenuId],[CreatedBy],[CreatedOn],[IsDeleted],[OrderNo])
Values(1,'Employees','/api/EmployeeGroup/GetAllEmployees',null,'admin',Getdate(),0,4),
      (2,'Roles','/api/RolePermission/GetRoles',null,'admin',Getdate(),0,2),
	  (3,'Settings',null,null,'admin',Getdate(),0,11),
	  (4,'Employee Group','/api/EmployeeGroup/GetEmployeeGroupList',null,'admin',Getdate(),0,6),
	  (5,'Survey',null,null,'admin',Getdate(),0,7),
	  (6,'Events','/api/',null,'admin',Getdate(),0,5), 
	  (7,'Company Policy','/api/CompanyPolicy/GetCompanyPolicies',null,'admin',Getdate(),0,3),
	  (8,'Survey Report',null,5,'admin',Getdate(),0,8),
	  (9,'My surveys',null,5,'admin',Getdate(),0,9),
	  (10,'Email and Notification','/api/',3,'admin',Getdate(),0,10),
	  (11,'Dashboard','/api/',null,'admin',Getdate(),0,1)
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
	   (11,11,6,'admin',Getdate()),
	   (12,11,56,'admin',Getdate()),
	   (13,11,51,'admin',Getdate())  
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
  GO
GO

   IF NOT EXISTS(SELECT 1 FROM [dbo].[Module] WHERE ID =16)
   BEGIN
   SET IDENTITY_INSERT [dbo].[Module] ON
   INSERT INTO [dbo].[Module]([Id],[ModuleName],[IsActive],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn])VALUES(16,'Previous Employer',1,'admin',GETDATE(),NULL,NULL)
   SET IDENTITY_INSERT [dbo].[Module] OFF
   END
GO
  IF NOT EXISTS(SELECT 1 FROM [dbo].[Permission] WHERE ID IN(77,78,79,80,81))
  BEGIN
SET IDENTITY_INSERT [dbo].[Permission] ON
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(77,'Read PreviousEmployer',16,'admin',GETDATE(),NULL,NULL,0,'Read.PreviousEmployer')
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(78,'Create PreviousEmployer',16,'admin',GETDATE(),NULL,NULL,0,'Create.PreviousEmployer')
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(79,'Edit PreviousEmployer',16,'admin',GETDATE(),NULL,NULL,0,'Edit.PreviousEmployer')
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(80,'Delete PreviousEmployer',16,'admin',GETDATE(),NULL,NULL,0,'Delete.PreviousEmployer')
 INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(81,'View PreviousEmployer',16,'admin',GETDATE(),NULL,NULL,0,'View.PreviousEmployer')
SET IDENTITY_INSERT [dbo].[Permission] OFF
END
GO


  GO
 IF EXISTS(SELECT * FROM Module WHERE ModuleName='Employee Creation')
 BEGIN
 update Module set ModuleName='Employees' Where ModuleName='Employee Creation'
 END

 GO
 IF EXISTS(SELECT * FROM Permission WHERE Name='Read Employee Creation')
 BEGIN
Update Permission set Name ='Read Employees' , Value='Read.Employees' where Name='Read Employee Creation'
End
GO
IF EXISTS(SELECT * FROM Permission WHERE Name='Create Employee Creation')
 BEGIN
Update Permission set Name ='Create Employees',Value='Create.Employees' where Name='Create Employee Creation'
End
GO
IF EXISTS(SELECT * FROM Permission WHERE Name='Edit Employee Creation')
 BEGIN
Update Permission set Name ='Edit Employees',Value='Edit.Employees' where Name='Edit Employee Creation'
End
GO
IF EXISTS(SELECT * FROM Permission WHERE Name='Delete Employee Creation')
 BEGIN
Update Permission set Name ='Delete Employees',Value='Delete.Employees' where Name='Delete Employee Creation'
End
GO
IF EXISTS(SELECT * FROM Permission WHERE Name='View Employee Creation')
 BEGIN
Update Permission set Name ='View Employees',Value='View.Employees' where Name='View Employee Creation'
End
Go
IF EXISTS(SELECT 1 FROM MenuPermission WHERE MenuId =1 AND ReadPermissionId IN(6,11,16,21))
 BEGIN
DELETE [dbo].[MenuPermission]
WHERE MenuId =1 AND ReadPermissionId IN(6,11,16,21)
End
Go

--------------------------------------------

Truncate Table [dbo].[EmployeeStatus]
SET IDENTITY_INSERT [dbo].[EmployeeStatus] ON
INSERT INTO [dbo].[EmployeeStatus]([Id],[Status],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted])VALUES(1,'Active','admin',GETDATE(),NULL,NULL,0)
INSERT INTO [dbo].[EmployeeStatus]([Id],[Status],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted])VALUES(2,'Inactive','admin',GETDATE(),NULL,NULL,0)
INSERT INTO [dbo].[EmployeeStatus]([Id],[Status],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted])VALUES(3,'OnNotice','admin',GETDATE(),NULL,NULL,0)
INSERT INTO [dbo].[EmployeeStatus]([Id],[Status],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted])VALUES(4,'ExEmployee','admin',GETDATE(),NULL,NULL,0)
SET IDENTITY_INSERT [dbo].[EmployeeStatus] OFF

GO

Truncate Table [dbo].[Department]
SET IDENTITY_INSERT [dbo].[Department] ON
INSERT INTO [dbo].[Department]([Id],[Department],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted])VALUES(1,'Development','admin',GETDATE(),NULL,NULL,0)
INSERT INTO [dbo].[Department]([Id],[Department],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted])VALUES(2,'Sales','admin',GETDATE(),NULL,NULL,0)
INSERT INTO [dbo].[Department]([Id],[Department],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted])VALUES(3,'Project Administrator','admin',GETDATE(),NULL,NULL,0)
INSERT INTO [dbo].[Department]([Id],[Department],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted])VALUES(4,'HR','admin',GETDATE(),NULL,NULL,0)
INSERT INTO [dbo].[Department]([Id],[Department],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted])VALUES(5,'Management','admin',GETDATE(),NULL,NULL,0)
INSERT INTO [dbo].[Department]([Id],[Department],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted])VALUES(6,'Reporting Management','admin',GETDATE(),NULL,NULL,0)
SET IDENTITY_INSERT [dbo].[Department] OFF

GO

Truncate Table [dbo].[Team]
SET IDENTITY_INSERT [dbo].[Team] ON
INSERT INTO [dbo].[Team]([Id],[TeamName],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted])VALUES(1,'PHP Team','admin',GETDATE(),NULL,NULL,0)
INSERT INTO [dbo].[Team]([Id],[TeamName],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted])VALUES(2,'React JS Team','admin',GETDATE(),NULL,NULL,0)
INSERT INTO [dbo].[Team]([Id],[TeamName],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted])VALUES(3,'VueJs','admin',GETDATE(),NULL,NULL,0)
INSERT INTO [dbo].[Team]([Id],[TeamName],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted])VALUES(4,'IBMi Team','admin',GETDATE(),NULL,NULL,0)
INSERT INTO [dbo].[Team]([Id],[TeamName],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted])VALUES(5,'COBOL Team','admin',GETDATE(),NULL,NULL,0)
INSERT INTO [dbo].[Team]([Id],[TeamName],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted])VALUES(6,'EDI Team','admin',GETDATE(),NULL,NULL,0)
INSERT INTO [dbo].[Team]([Id],[TeamName],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted])VALUES(7,'.Net Team','admin',GETDATE(),NULL,NULL,0)
SET IDENTITY_INSERT [dbo].[Team] OFF

GO

Truncate Table [dbo].[EmploymentStatus]
SET IDENTITY_INSERT [dbo].[EmploymentStatus] ON
INSERT INTO [dbo].[EmploymentStatus]([Id],[Status],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted])VALUES(1,'FullTime','admin',GETDATE(),NULL,NULL,0)
INSERT INTO [dbo].[EmploymentStatus]([Id],[Status],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted])VALUES(2,'PartTime','admin',GETDATE(),NULL,NULL,0)
INSERT INTO [dbo].[EmploymentStatus]([Id],[Status],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted])VALUES(3,'Probation','admin',GETDATE(),NULL,NULL,0)
INSERT INTO [dbo].[EmploymentStatus]([Id],[Status],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted])VALUES(4,'Internship','admin',GETDATE(),NULL,NULL,0)
SET IDENTITY_INSERT [dbo].[EmploymentStatus] OFF

GO
Go

 IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_EmailNotification_NotificationTemplate_TemplateId]') AND parent_object_id = OBJECT_ID(N'[dbo].[EmailNotification]'))
 Begin
	ALTER TABLE [dbo].[EmailNotification] DROP CONSTRAINT [FK_EmailNotification_NotificationTemplate_TemplateId]  
	End
 GO 
SET IDENTITY_INSERT [dbo].[NotificationTemplate] ON
TRUNCATE TABLE [dbo].[NotificationTemplate]
INSERT INTO [NotificationTemplate](ID,TemplateName, Description,Content,CreatedBy,CreatedOn,IsDeleted)
VALUES(1,'Birthday', 'Birthday template','<!DOCTYPE html><html lang="en" xmlns="http://www.w3.org/1999/xhtml" xmlns:o="urn:schemas-microsoft-com:office:office"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><meta name="x-apple-disable-message-reformatting"><!--[if mso]> <style> table {border-collapse:collapse;border-spacing:0;border:none;margin:0;box-sizing: border-box;} div, td {box-sizing: border-box;}table, tr, td,p{border:0;word-wrap: inherit;white-space: normal !important;} div {margin:0 !important;padding:30px;} ul{margin-top:0;margin-bottom: 0;} img{display: block;} a{color: #ffffff;text-decoration:none;} p {margin: 5px 0;font-size: 14px;line-height:24px;} </style> <noscript> <xml> <o:OfficeDocumentSettings> <o:PixelsPerInch>96</o:PixelsPerInch> </o:OfficeDocumentSettings> </xml> </noscript> <![endif]--> <title>Happy Birthday</title> </head><body style="margin: 0;"> <table align="center" border="0" cellspacing="0" cellpadding="0" width="100%"> <tr> <td align="center"> <table cellspacing="0" cellpadding="0" width="100%" style="margin: 0 auto; max-width: 600px; width: 100%; font-family: Times New Roman, Times, serif; border: 1px solid #005294;"> <tr> <td valign="center" style="background: #273a50;height: 100px;padding: 0 20px 0 20px;"> <img src="https://pixprod1.s3.us-east-1.amazonaws.com/Testing_File/Logo.png" alt="Programmers.io"> </td> </tr> <tr> <td valign="center" style="background: #ffffff;"> <img src="https://pixprod1.s3.us-east-1.amazonaws.com/Testing_File/hb_top-banner.jpg" alt="Banner"> </td> </tr> <tr> <td style="height: 50px;">&nbsp;</td> </tr> <tr> <td> <table border="0" cellspacing="0" cellpadding="0" width="100%" style="margin: auto;max-width: 650px;width: 100%;font-family: Times New Roman, Times, serif;"> <tr> <td align="center"> <table border="5" cellspacing="0" cellpadding="0" style="width: 200px; height: 200px; margin-left: auto; border-color:#005294;border-style:solid;" > <tr style="border:0;"> <td style="border: 0; padding: 0; border: 5px solid #005294; "> <img src="{ProfilePhoto}" alt="User Img" width="200" height="200" style=" max-width: 100%;"> </td> </tr> </table> </td> <td> <div style="padding-left: 20px;"> <h1 style="color: #273a50;font-size: 24px; font-family:Monotype Corsiva">{FirstName} {LastName}</h1> <h2 style="color: #1e75bb; font-size: 24px; font-family: Monotype Corsiva">{Designation}</h2> </div> </td> </tr> <tr> <td colspan="2" style="height: 50px;">&nbsp;</td> </tr> <tr> <td colspan="2"> <p style="text-align: center; font-size: 20px; line-height: 30px;">Wishing you a very Happy Birthday! May your special day be filled with laughter, good times, and wonderful memories. Enjoy your day! </p> </td> </tr> </table> </td> </tr> <tr> <td style="height: 30px;">&nbsp;</td> </tr> <tr> <td> <img src="https://pixprod1.s3.us-east-1.amazonaws.com/Testing_File/hb_footer-bg.jpg" alt="Banner"> </td> </tr> </table> </td> </tr> </table></body></html>',
'admin',Getdate(),0),
(2,'Anniversary','Anniversary template','<!DOCTYPE html><html lang="en" xmlns="http://www.w3.org/1999/xhtml" xmlns:o="urn:schemas-microsoft-com:office:office"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><meta name="x-apple-disable-message-reformatting"><!--[if mso]> <style> table {border-collapse:collapse;border-spacing:0;border:none;margin:0;box-sizing: border-box;} div, td {box-sizing: border-box;}table, tr, td,p{border:0;word-wrap: inherit;white-space: normal !important;} div {margin:0 !important;padding:30px;} ul{margin-top:0;margin-bottom: 0;} img{display: block;} a{color: #ffffff;text-decoration:none;} p {margin: 5px 0;font-size: 14px;line-height:24px;} </style> <noscript> <xml> <o:OfficeDocumentSettings> <o:PixelsPerInch>96</o:PixelsPerInch> </o:OfficeDocumentSettings> </xml> </noscript> <![endif]--> <title>Happy Work Anniversary</title> </head><body style="margin: 0;"> <table align="center" border="0" cellspacing="0" cellpadding="0" width="650" style="max-width: 650px; width: 100%; margin: auto; font-family: Times New Roman, Times, serif; border: 1px solid #005294; "> <tr> <td valign="center" style="background: #273a50;height: 100px;padding: 0 20px 0 20px;"> <img src="https://pixprod1.s3.us-east-1.amazonaws.com/Testing_File/Logo.png" alt="Programmers.io" style="max-width: 100%;"> </td> </tr> <tr> <td valign="center" style="background: #ffffff;"> <img src="https://pixprod1.s3.us-east-1.amazonaws.com/Testing_File/wa_top-banner.jpg" alt="Banner" style="max-width: 100%;"> </td> </tr> <tr> <td valign="center" style="background: #1e75bb;padding: 20px;"> <p style="font-size: 45px; color: #ffffff;margin: 0;font-weight: 600;text-align: center;">{YearsOfService}<sup>{OrdinalSuffix}</sup> WORK ANNIVERSARY</p> </td> </tr> <tr> <td style="height: 50px;">&nbsp;</td> </tr> <tr> <td> <table border="0" cellspacing="0" cellpadding="0" width="100%" style="margin: auto; font-family: Times New Roman, Times, serif;"> <tr> <td align="center"> <table border="0" cellspacing="0" cellpadding="0" style="width: 200px; height: 200px; margin-left: auto; border-color:#005294;border-style:solid;" > <tr style="border:0;"> <td style="border: 0; padding: 0; border: 5px solid #005294;"> <img src="{ProfilePhoto}" alt="User Img" width="200" height="200" style=" max-width: 100%;"> </td> </tr> </table> </td> <td > <div style="padding-left: 20px;"> <h1 style="color: #273a50;font-size: 24px;font-family:Monotype Corsiva;">{FirstName} {LastName}</h1> <h2 style="color: #1e75bb;font-size: 20px;font-family:Monotype Corsiva;">{Designation}</h2> </div> </td> </tr> <tr> <td colspan="2" style="height: 50px;">&nbsp;</td> </tr> <tr> <td colspan="2"> <p style="text-align: center; font-size: 20px; line-height: 30px;padding: 0px 40px; margin: 0;"> Happy work anniversary! Your contributions to Programmers .io over the past {YearsOfService} years have been invaluable. We appreciate your professionalism and dedication. Here"s to many more years of success and collaboration. </p> </td> </tr> </table> </td> </tr> <tr> <td style="height: 30px;">&nbsp;</td> </tr> <tr> <td align="center"> <img src="https://pixprod1.s3.us-east-1.amazonaws.com/Testing_File/wa_footer-bg.jpg" alt="Banner" style="max-width: 100%;"> </td> </tr> </table></body></html>',
'admin',Getdate(),0),
(3,'Welcome', 'Welcome template','<!DOCTYPE html><html lang="en" xmlns="http://www.w3.org/1999/xhtml" xmlns:o="urn:schemas-microsoft-com:office:office"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><meta name="x-apple-disable-message-reformatting"><!--[if mso]> <style> table {border-collapse:collapse;border-spacing:0;border:none;margin:0;box-sizing: border-box;} div, td {box-sizing: border-box;}table, tr, td,p{border:0;word-wrap: inherit;white-space: normal !important;} div {margin:0 !important;padding:30px;} ul{margin-top:0;margin-bottom: 0;} img{display: block;} a{color: #ffffff;text-decoration:none;} p {margin: 5px 0;font-size: 14px;line-height:24px;} </style> <noscript> <xml> <o:OfficeDocumentSettings> <o:PixelsPerInch>96</o:PixelsPerInch> </o:OfficeDocumentSettings> </xml> </noscript> <![endif]--> <title>Welcome Email</title> </head><body style="margin: 0;"> <table align="center" border="0" cellspacing="0" cellpadding="0" width="650" style="max-width: 650px; width: 100%; margin: auto; font-family: Times New Roman, Times, serif; border: 1px solid #005294;"> <tr> <td valign="center" style="background: #ffffff;"> <img src="https://pixprod1.s3.us-east-1.amazonaws.com/Testing_File/wel-top-banner.jpg" alt="Banner" style="max-width: 100%;"> </td> </tr> <tr> <td style="height: 50px;">&nbsp;</td> </tr> <tr> <td> <table border="0" cellspacing="0" cellpadding="0" width="100%" style="margin: auto; font-family: Times New Roman, Times, serif;"> <tr> <td align="center"> <table border="0" cellspacing="0" cellpadding="0" style="width: 200px; height: 200px; margin-left: auto; border-color:#005294;border-style:solid;" > <tr style="border:0;"> <td style="border: 0; padding: 0; border: 5px solid #005294;"> <img src="{ProfilePhoto}" alt="User Img" width="200" height="200" style=" max-width: 100%;"> </td> </tr> </table> </td> <td> <div style="padding-left: 20px;"> <h1 style="color: #273a50; font-size: 24px; font-family: Monotype Corsiva;">{FirstName} {LastName}</h1> <h2 style="color: #1e75bb; font-size: 20px; font-family: Monotype Corsiva;">{Designation}</h2> </div> </td> </tr> <tr> <td colspan="2" style="height: 50px;">&nbsp;</td> </tr> <tr> <td colspan="2"> <p style="text-align: center; font-size: 20px; line-height: 30px;padding: 0px 40px; margin: 0;">We are delighted to have you among us. On behalf of Programmers.io, we would like to extend our warmest welcome and good wishes. </p> <p style="text-align: center; font-size: 20px; line-height: 30px;padding: 0px 40px; margin: 0;">You are going to be an asset to our company, and we can’t wait to see all that you accomplish. </p> </td> </tr> </table> </td> </tr> <tr> <td style="height: 30px;">&nbsp;</td> </tr> <tr> <td valign="center" style="padding: 20px;"> <p style="font-size: 24px; color: #1e75bb;margin: 0;font-weight: 600;text-align: center;">WELCOME ABOARD!!!</p> </td> </tr> <tr> <td style="height: 30px;">&nbsp;</td> </tr> <tr> <td align="center"> <img src="https://pixprod1.s3.us-east-1.amazonaws.com/Testing_File/wel-footer-banner.png" alt="Banner" style="max-width: 100%;"> </td> </tr> </table></body></html>',
'admin',Getdate(),0)
SET IDENTITY_INSERT [dbo].[NotificationTemplate] OFF
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_EmailNotification_NotificationTemplate_TemplateId]') AND parent_object_id = OBJECT_ID(N'[dbo].[EmailNotification]'))
BEGIN
   ALTER TABLE [dbo].[EmailNotification]  WITH CHECK ADD  CONSTRAINT [FK_EmailNotification_NotificationTemplate_TemplateId] FOREIGN KEY(TemplateId) REFERENCES [dbo].[NotificationTemplate] ([Id])
END
GO
Truncate Table [dbo].[EmployeeStatus]
SET IDENTITY_INSERT [dbo].[EmployeeStatus] ON
INSERT INTO [dbo].[EmployeeStatus]([Id],[Status],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted])VALUES(1,'Active','admin',GETDATE(),NULL,NULL,0)
INSERT INTO [dbo].[EmployeeStatus]([Id],[Status],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted])VALUES(2,'F&FPending','admin',GETDATE(),NULL,NULL,0)
INSERT INTO [dbo].[EmployeeStatus]([Id],[Status],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted])VALUES(3,'On Notice','admin',GETDATE(),NULL,NULL,0)
INSERT INTO [dbo].[EmployeeStatus]([Id],[Status],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted])VALUES(4,'Ex Employee','admin',GETDATE(),NULL,NULL,0)
SET IDENTITY_INSERT [dbo].[EmployeeStatus] OFF
GO
Truncate Table [dbo].[Role]
SET IDENTITY_INSERT [dbo].[Role] ON
INSERT INTO [dbo].[Role]([Id],[Name],[IsActive],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn])VALUES(1,'SuperAdmin',1,'admin',GETDATE(),NULL,NULL)
INSERT INTO [dbo].[Role]([Id],[Name],[IsActive],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn])VALUES(2,'HR',1,'admin',GETDATE(),NULL,NULL)
INSERT INTO [dbo].[Role]([Id],[Name],[IsActive],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn])VALUES(3,'Employee',1,'admin',GETDATE(),NULL,NULL)
INSERT INTO [dbo].[Role]([Id],[Name],[IsActive],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn])VALUES(4,'Accounts',1,'admin',GETDATE(),NULL,NULL)
SET IDENTITY_INSERT [dbo].[Role] OFF
GO
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

  ----Accounts Role-------------
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(147,4,1,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(148,4,2,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(149,4,3,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(150,4,5,'admin',GETDATE(),NULL,NULL,1)
  --Personal Details
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(151,4,6,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(152,4,7,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(153,4,8,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(154,4,10,'admin',GETDATE(),NULL,NULL,1)
  --Nominee Details
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(155,4,15,'admin',GETDATE(),NULL,NULL,1)
  --Employment Details
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(156,4,16,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(157,4,17,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(158,4,20,'admin',GETDATE(),NULL,NULL,1)
  --Educational Details
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(159,4,21,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(160,4,22,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(161,4,25,'admin',GETDATE(),NULL,NULL,1)
  --Email Notification
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(162,4,31,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(163,4,32,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(164,4,33,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(165,4,34,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(166,4,35,'admin',GETDATE(),NULL,NULL,1)
  --Employee Group
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(167,4,36,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(168,4,37,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(169,4,38,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(170,4,39,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(171,4,40,'admin',GETDATE(),NULL,NULL,1)
  --Survey Report
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(172,4,41,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(173,4,42,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(174,4,43,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(175,4,44,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(176,4,45,'admin',GETDATE(),NULL,NULL,1)
  --My Surveys
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(177,4,46,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(178,4,47,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(179,4,48,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(180,4,49,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(181,4,50,'admin',GETDATE(),NULL,NULL,1)
  --Events
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(182,4,51,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(183,4,52,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(184,4,53,'admin',GETDATE(),NULL,NULL,1)
 INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(185,4,54,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(186,4,55,'admin',GETDATE(),NULL,NULL,1)
  --Company Policy
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(187,4,56,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(188,4,60,'admin',GETDATE(),NULL,NULL,1)

  --Survey
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(189,4,61,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(190,4,62,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(191,4,63,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(192,4,64,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(193,4,65,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(194,4,66,'admin',GETDATE(),NULL,NULL,1)

   SET IDENTITY_INSERT [dbo].[RolePermission] OFF
   Go

   Update Status SET StatusValue = 'WIP / Pending Approval' Where StatusValue = 'Draft'
   Update Status SET StatusValue = 'Upcoming' Where StatusValue = 'Published'
   Update Status SET StatusValue = 'Completed' Where StatusValue = 'Completed'
   
    Truncate Table Designation
    INSERT INTO [dbo].[Designation]
           ([Designation]
           ,[CreatedBy]
           ,[CreatedOn]
           ,[ModifiedBy]
           ,[ModifiedOn]
           ,[IsDeleted])
     VALUES
           ('Account Executive', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Accounts Manager', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Assistant Account Manager', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Assistant Content Writer', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Assistant Manager- Business Development', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Assistant Manager, IT', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Assistant Vice President', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Associate Cloud Engineer', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Associate Project Manager', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Associate Software Engineer', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Associate Technical Architect', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Asst. admin executive', 'Admin', GETDATE(), NULL, NULL, 0),
           ('AVP of Sales Operations and Strategy', 'Admin', GETDATE(), NULL, NULL, 0),
           ('AVP of Tech Services', 'Admin', GETDATE(), NULL, NULL, 0),
           ('AWS Data Engineer', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Business Analyst', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Business Development - Trainee', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Business Development Associate', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Business Development Executive', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Business Development Manager', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Business Development Specialist', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Center Manager - Hyderabad and Pune', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Chief Information Security Officer', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Chief Solution Architect', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Client Partner', 'Admin', GETDATE(), NULL, NULL, 0),
           ('COBOL Developer', 'Admin', GETDATE(), NULL, NULL, 0),
           ('COBOL Trainee', 'Admin', GETDATE(), NULL, NULL, 0),
           ('CTO', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Delivery Manager', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Deputy Manager Talent Acquisition', 'Admin', GETDATE(), NULL, NULL, 0),
           ('DevOps Engineer', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Digital Marketing Executive', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Digital Marketing Specialist', 'Admin', GETDATE(), NULL, NULL, 0),
           ('EDI Developer', 'Admin', GETDATE(), NULL, NULL, 0),
           ('EDI Project Manager', 'Admin', GETDATE(), NULL, NULL, 0),
           ('EDI Trainee', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Executive- TA', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Finance & Accounts Manager', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Head of HR- India', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Head of QA', 'Admin', GETDATE(), NULL, NULL, 0),
           ('HR - Trainee', 'Admin', GETDATE(), NULL, NULL, 0),
           ('HR Coordinator', 'Admin', GETDATE(), NULL, NULL, 0),
           ('HR Executive', 'Admin', GETDATE(), NULL, NULL, 0),
           ('IBMi Developer', 'Admin', GETDATE(), NULL, NULL, 0),
           ('IBMi Professional- 1', 'Admin', GETDATE(), NULL, NULL, 0),
           ('iBMI Specialist', 'Admin', GETDATE(), NULL, NULL, 0),
           ('IBMI Support Engineer', 'Admin', GETDATE(), NULL, NULL, 0),
           ('IBMi Trainee', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Java Developer', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Java Trainee', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Jr. Web Designer', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Junior COBOL Developer', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Junior EDI Developer', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Junior IBMI Developer', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Junior Java Developer', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Junior Market Research Executive', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Junior System Admin', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Lead BPCS Consultant', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Lead Business Analyst', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Lead Data Engineer', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Lead Developer - COBOL', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Lead EDI Consultant', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Lead EDI Developer', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Lead IBMi Developer', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Lead Infor XA Consultant', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Lead Java Developer', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Lead JDE Developer', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Lead Power BI Engineer', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Lead Software Engineer', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Lead Support Engineer', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Lead Synon Developer', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Lead Talent Acquisition', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Mainframe Professional - 1', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Manager - QA', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Manager – Talent Acquisition', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Manager -SEO', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Market Research Executive', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Market Research Trainee', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Principal Data Engineer', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Principal QA Engineer', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Principal Software Engineer Testing', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Principle Software Engineer', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Product Owner', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Project Coordinator', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Project Manager', 'Admin', GETDATE(), NULL, NULL, 0),
           ('QA Automation Engineer', 'Admin', GETDATE(), NULL, NULL, 0),
           ('QA Lead', 'Admin', GETDATE(), NULL, NULL, 0),
           ('QA- Test Engineer', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Quality', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Security Analyst', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Security Guard', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Senior Accounts Executive', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Senior Business Analyst', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Senior Business Development Executive', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Senior Cloud IT Engineer', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Senior Data Engineer', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Senior Delivery Manager', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Senior Digital Marketing Expert', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Senior EDI Developer', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Senior Executive- Talent Acquisition', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Senior HR', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Senior Java Developer', 'Admin', GETDATE(), NULL, NULL,0),
		   ('Senior Java Developer', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Senior JDE Developer', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Senior Manager- Business Development', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Senior Manager-Application Development and Maintenance', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Senior Production Support Engineer', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Senior Project Manager', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Senior QA', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Senior QA Automation Engineer', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Senior SAP BI Developer', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Senior Software Developer', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Senior Software Engineer', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Senior Software Engineer- Testing', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Senior Software Engineer-QA', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Senior Software Test Engineer', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Senior Specialist', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Senior SQL Support Engineer', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Senior Synon Developer', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Senior Team Lead', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Senior Tech Lead', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Senior Technical Content Writer', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Senior Test Engineer- QA', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Senior UI/UX Frontend Developer', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Software Developer', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Software Engineer', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Software Engineer - QA', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Software Engineer Testing', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Software Engineer Trainee', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Solution Architect', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Sr IBMi Developer', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Sr. Business Development Executive', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Sr. COBOL Developer', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Sr. DevOps Engineer', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Sr. Exe - SEO', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Sr. Executive – HR and Admin', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Sr. Executive HR', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Sr. IBMi Developer', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Sr. Solution Architect – IBMi and Integration', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Sr. System Admin', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Sr. UI Designer', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Sr.Web Designer', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Support Engineer', 'Admin', GETDATE(), NULL, NULL, 0),
           ('System Administrator', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Teach Lead - ETL', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Team Lead', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Team Lead - QA', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Team Lead- COBOL', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Team Lead- Market Research', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Team Lead- Power Bi', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Team Lead, Azure DevOps', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Team Lead, IT', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Technical Architect', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Technical Architect (IBMI)', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Technical Architect-Java', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Technical Lead', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Technical Project Manager', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Technology Specialist', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Technology Specialist -IBMi', 'Admin', GETDATE(), NULL, NULL, 0),
           ('UI Developer', 'Admin', GETDATE(), NULL, NULL, 0),
           ('US Technical Recruiter', 'Admin', GETDATE(), NULL, NULL, 0),
           ('UX/UI Designer', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Vice President of Technology', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Web Content Writer', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Web Designer', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Website Project Manager', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Senior UI/UX Designer', 'Admin', GETDATE(), NULL, NULL, 0);

---------------Department-----------------------------

           Truncate Table Department
		    INSERT INTO [dbo].[Department]
           ([Department]
           ,[CreatedBy]
           ,[CreatedOn]
           ,[ModifiedBy]
           ,[ModifiedOn]
           ,[IsDeleted])
     VALUES
           ('Accounts', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Admin', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Angular Trainee', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Ascellerate', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Azure Devops', 'Admin', GETDATE(), NULL, NULL, 0),
           ('BD', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Business Analyst', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Cloud Application', 'Admin', GETDATE(), NULL, NULL, 0),
           ('COBOL', 'Admin', GETDATE(), NULL, NULL, 0),
           ('CRM', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Delphi', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Designing', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Devops Engineer', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Digital Marketing', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Dot Net', 'Admin', GETDATE(), NULL, NULL, 0),
           ('EDI', 'Admin', GETDATE(), NULL, NULL, 0),
           ('ETL', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Finance & Accounts', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Frontend', 'Admin', GETDATE(), NULL, NULL, 0),
           ('HR', 'Admin', GETDATE(), NULL, NULL, 0),
           ('IBMI', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Integration', 'Admin', GETDATE(), NULL, NULL, 0),
           ('IT', 'Admin', GETDATE(), NULL, NULL, 0),
           ('IT (Azure DevOps)', 'Admin', GETDATE(), NULL, NULL, 0),
           ('JAVA', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Management', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Market Research', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Matillion', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Mern Stack', 'Admin', GETDATE(), NULL, NULL, 0),
           ('MULESOFT', 'Admin', GETDATE(), NULL, NULL, 0),
           ('PHP', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Powel BI', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Python', 'Admin', GETDATE(), NULL, NULL, 0),
           ('QA', 'Admin', GETDATE(), NULL, NULL, 0),
           ('QA - Software Testing', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Quality', 'Admin', GETDATE(), NULL, NULL, 0),
           ('React Js', 'Admin', GETDATE(), NULL, NULL, 0),
           ('RPG', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Ruby On Rails', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Sales', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Salesforce', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Security', 'Admin', GETDATE(), NULL, NULL, 0),
           ('SEO', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Snowflake', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Softwar Engineer - M1', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Software', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Software Engineer', 'Admin', GETDATE(), NULL, NULL, 0),
           ('SQL', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Tableau', 'Admin', GETDATE(), NULL, NULL, 0),
           ('UX/UI', 'Admin', GETDATE(), NULL, NULL, 0),
           ('VueJs', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Web Design', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Wordpress', 'Admin', GETDATE(), NULL, NULL, 0);

-----------Team----------------------------
 Truncate Table Team
INSERT INTO [dbo].[Team]
           ([TeamName]
           ,[CreatedBy]
           ,[CreatedOn]
           ,[ModifiedBy]
           ,[ModifiedOn]
           ,[IsDeleted])
     VALUES
           ('Accounts', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Admin', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Angular Trainee', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Ascellerate', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Azure Devops', 'Admin', GETDATE(), NULL, NULL, 0),
           ('BD', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Business Analyst', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Cloud Application', 'Admin', GETDATE(), NULL, NULL, 0),
           ('COBOL', 'Admin', GETDATE(), NULL, NULL, 0),
           ('CRM', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Delphi', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Designing', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Devops Engineer', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Digital Marketing', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Dot Net', 'Admin', GETDATE(), NULL, NULL, 0),
           ('EDI', 'Admin', GETDATE(), NULL, NULL, 0),
           ('ETL', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Finance & Accounts', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Frontend', 'Admin', GETDATE(), NULL, NULL, 0),
           ('HR', 'Admin', GETDATE(), NULL, NULL, 0),
           ('IBMI', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Integration', 'Admin', GETDATE(), NULL, NULL, 0),
           ('IT', 'Admin', GETDATE(), NULL, NULL, 0),
           ('IT (Azure DevOps)', 'Admin', GETDATE(), NULL, NULL, 0),
           ('JAVA', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Management', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Market Research', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Matillion', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Mern Stack', 'Admin', GETDATE(), NULL, NULL, 0),
           ('MULESOFT', 'Admin', GETDATE(), NULL, NULL, 0),
           ('PHP', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Powel BI', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Python', 'Admin', GETDATE(), NULL, NULL, 0),
           ('QA', 'Admin', GETDATE(), NULL, NULL, 0),
           ('QA - Software Testing', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Quality', 'Admin', GETDATE(), NULL, NULL, 0),
           ('React Js', 'Admin', GETDATE(), NULL, NULL, 0),
           ('RPG', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Ruby On Rails', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Sales', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Salesforce', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Security', 'Admin', GETDATE(), NULL, NULL, 0),
           ('SEO', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Snowflake', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Softwar Engineer - M1', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Software', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Software Engineer', 'Admin', GETDATE(), NULL, NULL, 0),
           ('SQL', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Tableau', 'Admin', GETDATE(), NULL, NULL, 0),
           ('UX/UI', 'Admin', GETDATE(), NULL, NULL, 0),
           ('VueJs', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Web Design', 'Admin', GETDATE(), NULL, NULL, 0),
           ('Wordpress', 'Admin', GETDATE(), NULL, NULL, 0);
GO


