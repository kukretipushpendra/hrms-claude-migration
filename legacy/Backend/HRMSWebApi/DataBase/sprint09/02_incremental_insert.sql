-------------------------Run Single Time only----------
SET IDENTITY_INSERT [dbo].[Group] ON
INSERT INTO [dbo].[Group]
           ([Id],[GroupName]
           ,[Description]
           ,[CreatedBy]
           ,[CreatedOn] 
           ,[IsDeleted]
           ,[STATUS])
     VALUES
           (1,'Hyderabad Group'
           ,'Hyderabad group members only'
           ,'Admin'
           ,GETDATE() 
           ,0
           ,1),
		   (2,'Jaipur Group'
           ,'Jaipur group members only'
           ,'Admin'
           ,GETDATE() 
           ,0
           ,1), 
		   (3,'Pune Group'
           ,'Pune group members only'
           ,'Admin'
           ,GETDATE() 
           ,0
           ,1),
		   (4,'All Groups'
           ,'All group members'
           ,'Admin'
           ,GETDATE() 
           ,0
           ,1)
SET IDENTITY_INSERT [dbo].[Group] OFF
-------------------------Run Single Time only----------
INSERT INTO GroupUserMapping (groupId, EmployeeId,CreatedBy,CreatedOn,IsDeleted)
SELECT 1, employeeId,'Admin',GETDATE(),0
FROM EmploymentDetail
WHERE BranchId = 1;

INSERT INTO GroupUserMapping (groupId, EmployeeId,CreatedBy,CreatedOn,IsDeleted)
SELECT 2, employeeId,'Admin',GETDATE(),0
FROM EmploymentDetail
WHERE BranchId = 2;
 
 
INSERT INTO GroupUserMapping (groupId, EmployeeId,CreatedBy,CreatedOn,IsDeleted)
SELECT 3, employeeId,'Admin',GETDATE(),0
FROM EmploymentDetail
WHERE BranchId = 3;

INSERT INTO GroupUserMapping (groupId, EmployeeId,CreatedBy,CreatedOn,IsDeleted)
SELECT 4, employeeId,'Admin',GETDATE(),0
FROM EmploymentDetail


SET IDENTITY_INSERT [dbo].[Group] ON
INSERT INTO [dbo].[Group]
           ([Id],[GroupName]
           ,[Description]
           ,[CreatedBy]
           ,[CreatedOn] 
           ,[IsDeleted]
           ,[STATUS])
     VALUES
           (4,'All Groups'
           ,'All group members'
           ,'Admin'
           ,GETDATE() 
           ,0
           ,1)
SET IDENTITY_INSERT [dbo].[Group] OFF
------------------
--Add 1 more company policy category 

INSERT INTO [dbo].[CompanyPolicyDocCategory]
           ([CategoryName]
           ,[IsActive]
           ,[CreatedBy]
           ,[CreatedOn] 
           ,[IsDeleted])
     VALUES
           ('IT Policy'
           ,1
           ,'Admin'
           ,GETDATE() 
           ,0)
GO
---------------------------------

-------------------Added attendance module ----------------
  SET IDENTITY_INSERT [dbo].[Module] ON 
    INSERT INTO [dbo].[Module]([Id],[ModuleName],[IsActive],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn])VALUES(18,'Attendance',1,'admin',GETDATE(),NULL,NULL)
	 
  SET IDENTITY_INSERT [dbo].[Module] OFF
  ------------New permission added -----------	
 SET IDENTITY_INSERT [dbo].[Permission] ON
		INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(87,'Read Attendance',18,'admin',GETDATE(),NULL,NULL,0,'Read.Attendance')
		INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(88,'Create Attendance',18,'admin',GETDATE(),NULL,NULL,0,'Create.Attendance')
		INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(89,'Edit Attendance',18,'admin',GETDATE(),NULL,NULL,0,'Edit.Attendance')
		INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(90,'Delete Attendance',18,'admin',GETDATE(),NULL,NULL,0,'Delete.Attendance')
		INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(91,'View Attendance',18,'admin',GETDATE(),NULL,NULL,0,'View.Attendance')
 
 SET IDENTITY_INSERT [dbo].[Permission] OFF
 ---------------------------------

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
	  --(10,'Email and Notification','/api/',3,'admin',Getdate(),0),
	  (11,'Department','/api/',3,'admin',Getdate(),0),
	  (12,'Team','/api/',3,'admin',Getdate(),0),
	  (13,'Designation','/api/',3,'admin',Getdate(),0),
	  (14,'Attendance','null',null,'admin',Getdate(),0),
	  (15,'Attendance Report','/api/',14,'admin',Getdate(),0),
	  (16,'Attendance Configuration','/api/',14,'admin',Getdate(),0),
	  (17,'Employee Attendance Report ','/api/',14,'admin',Getdate(),0)

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
	   --(10,10,31,'admin',Getdate()),
	   (11,11,3,'admin',Getdate()),
	   (12,12,3,'admin',Getdate()),
	   (13,13,3,'admin',Getdate())
	   , (14,14,87,'admin',Getdate())
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

