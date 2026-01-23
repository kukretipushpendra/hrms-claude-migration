
  SET IDENTITY_INSERT [dbo].[Module] ON
  INSERT INTO [dbo].[Module]([Id],[ModuleName],[IsActive],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn])VALUES(21,'KPI',1,'admin',GETDATE(),NULL,NULL)
  SET IDENTITY_INSERT [dbo].[Module] OFF

   SET IDENTITY_INSERT [dbo].[Permission] ON
    INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(106,'Read KPI',21,'admin',GETDATE(),NULL,NULL,0,'Read.KPI')
    INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(107,'Create KPI',21,'admin',GETDATE(),NULL,NULL,0,'Create.KPI')
    INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(108,'Edit KPI',21,'admin',GETDATE(),NULL,NULL,0,'Edit.KPI')
    INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(109,'Delete KPI',21,'admin',GETDATE(),NULL,NULL,0,'Delete.KPI')
    INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(110,'View KPI',21,'admin',GETDATE(),NULL,NULL,0,'View.KPI')
    INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(111,'Read KPI Goals',21,'admin',GETDATE(),NULL,NULL,0,'Read.KPIGoals')
    INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(112,'Read KPI DashBoard',21,'admin',GETDATE(),NULL,NULL,0,'Read.KPIDashboard')
    

 
 SET IDENTITY_INSERT [dbo].[Permission] OFF

 SET IDENTITY_INSERT [dbo].[RolePermission] ON
   --KPI Permission

  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(406,1,106,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(407,1,107,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(408,1,108,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(409,1,109,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(410,1,110,'admin',GETDATE(),NULL,NULL,1)

  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(411,2,106,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(412,2,107,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(413,2,108,'admin',GETDATE(),NULL,NULL,1)

  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(414,3,106,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(415,3,107,'admin',GETDATE(),NULL,NULL,1)

  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(416,4,106,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(417,4,107,'admin',GETDATE(),NULL,NULL,1)

  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(418,5,106,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(419,5,107,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(420,5,108,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(421,5,109,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(422,5,110,'admin',GETDATE(),NULL,NULL,1)
  
  
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(423,1,111,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(424,1,112,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(425,5,111,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(426,5,112,'admin',GETDATE(),NULL,NULL,1)
   SET IDENTITY_INSERT [dbo].[RolePermission] OFF

 Truncate Table [dbo].[Menu]
 SET IDENTITY_INSERT [dbo].[Menu] ON

 INSERT INTO [dbo].[Menu]([Id],[Name],[ApiEndPoint],[ParentMenuId],[CreatedBy],[CreatedOn],[IsDeleted])
Values
    (1,'Employees','/api/EmployeeGroup/GetAllEmployees',null,'admin',Getdate(),0),
    (2,'Roles','/api/RolePermission/GetRoles',null,'admin',Getdate(),0)
-- dev role
GO
IF NOT EXISTS (SELECT ID FROM [Role] WHERE ID = 7) BEGIN
	SET IDENTITY_INSERT [dbo].[Role] ON
	INSERT INTO [dbo].[Role]([Id],[Name],[IsActive],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn])VALUES
	(7,'Developer',1,'admin',GETDATE(),NULL,NULL)
	SET IDENTITY_INSERT [dbo].[Role] OFF
END
IF NOT EXISTS (SELECT ID FROM Module WHERE ID  = 21) BEGIN
	SET IDENTITY_INSERT [dbo].MODULE ON
	INSERT INTO MODULE (Id, ModuleName, IsActive, CreatedBy, CreatedOn) VALUES 
	(21, 'Developer', 1, 'admin', GETDATE())
	SET IDENTITY_INSERT [dbo].MODULE OFF
END
IF NOT EXISTS (SELECT ID FROM Permission WHERE ID IN (102)) BEGIN
	SET IDENTITY_INSERT [dbo].Permission ON
	INSERT INTO Permission (id, [Name], ModuleId, CreatedBy, createdon, value, IsDeleted) VALUES 
	(102, 'Read Logs', 21, 'admin', getdate(), 'Read.Logs', 0)
	SET IDENTITY_INSERT [dbo].Permission OFF
END
IF NOT EXISTS (SELECT ID FROM Menu WHERE ID IN (25,26)) BEGIN
	SET IDENTITY_INSERT [dbo].Menu ON
	INSERT INTO Menu (Id, [Name], ApiEndPoint, ParentMenuId, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn, IsDeleted, OrderNo) VALUES 
	(25, 'Developer', NULL, NULL, 'admin', GETDATE(), NULL, NULL, 0, NULL)
	INSERT INTO Menu (Id, [Name], ApiEndPoint, ParentMenuId, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn, IsDeleted, OrderNo) VALUES 
	(26, 'Logs', '/api/', 25, 'admin', GETDATE(), NULL, NULL, 0, NULL)
	SET IDENTITY_INSERT [dbo].Menu OFF
END
IF NOT EXISTS (SELECT Id FROM MenuPermission MP WHERE MP.MenuId IN (25)) 
BEGIN
	INSERT INTO MenuPermission (MenuId, ReadPermissionId, CreatedBy, CreatedOn) values
	(25, 102, 'admin', getdate())
END
IF NOT EXISTS (SELECT Id FROM RolePermission RP WHERE RP.RoleId = 7 AND RP.PermissionId IN (102)) BEGIN
	INSERT INTO RolePermission(RoleId, PermissionId, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn, IsActive) VALUES 
	(7, 102, 'admin', GETDATE(), null, null, 1)
END
-------------IT ASSET-------------------------
SET IDENTITY_INSERT [dbo].[Module] ON 
    INSERT INTO [dbo].[Module]([Id],[ModuleName],[IsActive],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn])VALUES(20,'IT Assets',1,'admin',GETDATE(),NULL,NULL)
SET IDENTITY_INSERT [dbo].[Module] OFF


 SET IDENTITY_INSERT [dbo].[Permission] ON
INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(113,'Read Asset',20,'admin',GETDATE(),NULL,NULL,0,'Read.Asset')
INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(114,'Create Asset',20,'admin',GETDATE(),NULL,NULL,0,'Create.Asset')
INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(115,'Edit Asset',20,'admin',GETDATE(),NULL,NULL,0,'Edit.Asset')
INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(116,'Delete Asset',20,'admin',GETDATE(),NULL,NULL,0,'Delete.Asset')
INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(117,'View Asset',20,'admin',GETDATE(),NULL,NULL,0,'View.Asset')
 
  SET IDENTITY_INSERT [dbo].[Permission] OFF

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
	  (10,'Email and Notification','/api/',3,'admin',Getdate(),0),
	  (11,'Department','/api/',3,'admin',Getdate(),0),
	  (12,'Team','/api/',3,'admin',Getdate(),0),
	  (13,'Designation','/api/',3,'admin',Getdate(),0),
	  (14,'Attendance','null',null,'admin',Getdate(),0),
	  (15,'My Attendance','/api/',14,'admin',Getdate(),0),
	  (16,'Attendance Configuration','/api/',14,'admin',Getdate(),0),
	  (17,'Employee Report','/api/',14,'admin',Getdate(),0),
	  (18,'Employees List','/api/',1,'admin',Getdate(),0),
	  (19,'Employee Exit','/api/',1,'admin',Getdate(),0),
    (20,'Leave',null,null,'admin',GetDate(),0),
    (21,'Apply Leave','/api/',20,'admin,',GetDate(),0),
    (22,'Leave Approval','/api/',20,'admin,',GetDate(),0),
    (23,'Leave Calendar','/api/',20,'admin,',GetDate(),0),
    (24,'IT Assets',null,null,'admin,',GetDate(),0),
    (25,'KPI',null,null,'admin',GetDate(),0),
    (26,'My KPI','/api/',25,'admin',GetDate(),0),
    (27,'Goals','/api/',25,'admin',GetDate(),0),
    (28,'KPI Management','/api/',25,'admin',GetDate(),0)
    

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
	   (11,11,3,'admin',Getdate()),
	   (12,12,3,'admin',Getdate()),
	   (13,13,3,'admin',Getdate()),
	   (14,14,87,'admin',Getdate()),
	   (15,16,98,'admin',Getdate()),
	   (16,17,99,'admin',Getdate()), 
	   (17,18,1,'admin',Getdate()),
	   (18,19,1,'admin',Getdate()),
       (19,20,92,'admin',Getdate()), 
	   (20,22,100,'admin',Getdate()),
	   (21,23,101,'admin',Getdate()), 
     (22,24,113,'admin',Getdate()),
     (23,25,106,'admin',Getdate()),
     (24,27,111,'admin',Getdate()),
     (25,28,112,'admin',Getdate())
	 
	 

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

-----------Roles-----------------

SET IDENTITY_INSERT [dbo].[Role] ON
INSERT INTO [dbo].[Role]([Id],[Name],[IsActive],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn])VALUES(5,'Manager',1,'admin',GETDATE(),NULL,NULL)
INSERT INTO [dbo].[Role]([Id],[Name],[IsActive],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn])VALUES(6,'IT',1,'admin',GETDATE(),NULL,NULL)
INSERT INTO [dbo].[Role]([Id],[Name],[IsActive],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn])VALUES(7,'Developer',1,'admin',GETDATE(),NULL,NULL)
SET IDENTITY_INSERT [dbo].[Role] OFF


--------------------Grievance Menu-------------------------------------
SET IDENTITY_INSERT [dbo].[Module] ON 
    INSERT INTO [dbo].[Module]([Id],[ModuleName],[IsActive],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn])VALUES(23,'Grievances',1,'admin',GETDATE(),NULL,NULL)
SET IDENTITY_INSERT [dbo].[Module] OFF


 SET IDENTITY_INSERT [dbo].[Permission] ON
INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(119,'Read Grievances',23,'admin',GETDATE(),NULL,NULL,0,'Read.Grievances')
INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(120,'Create Grievances',23,'admin',GETDATE(),NULL,NULL,0,'Create.Grievances')
INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(121,'Edit Grievances',23,'admin',GETDATE(),NULL,NULL,0,'Edit.Grievances')
INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(122,'Delete Grievances',23,'admin',GETDATE(),NULL,NULL,0,'Delete.Grievances')
INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(123,'View Grievances',23,'admin',GETDATE(),NULL,NULL,0,'View.Grievances')

INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(124,'Read All Grievances',23,'admin',GETDATE(),NULL,NULL,0,'Read.AllGrievances')
INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(125,'Read Grievances Configuration',23,'admin',GETDATE(),NULL,NULL,0,'Read.GrievancesConfiguration')
 
  SET IDENTITY_INSERT [dbo].[Permission] OFF

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
	  (10,'Email and Notification','/api/',3,'admin',Getdate(),0),
	  (11,'Department','/api/',3,'admin',Getdate(),0),
	  (12,'Team','/api/',3,'admin',Getdate(),0),
	  (13,'Designation','/api/',3,'admin',Getdate(),0),
	  (14,'Attendance','null',null,'admin',Getdate(),0),
	  (15,'My Attendance','/api/',14,'admin',Getdate(),0),
	  (16,'Attendance Configuration','/api/',14,'admin',Getdate(),0),
	  (17,'Employee Report','/api/',14,'admin',Getdate(),0),
	  (18,'Employees List','/api/',1,'admin',Getdate(),0),
	  (19,'Employee Exit','/api/',1,'admin',Getdate(),0),
    (20,'Leave',null,null,'admin',GetDate(),0),
    (21,'Apply Leave','/api/',20,'admin,',GetDate(),0),
    (22,'Leave Approval','/api/',20,'admin,',GetDate(),0),
    (23,'Leave Calendar','/api/',20,'admin,',GetDate(),0),
    (24,'IT Assets',null,null,'admin,',GetDate(),0),
    (25,'KPI',null,null,'admin',GetDate(),0),
    (26,'My KPI','/api/',25,'admin',GetDate(),0),
    (27,'Goals','/api/',25,'admin',GetDate(),0),
    (28,'KPI Management','/api/',25,'admin',GetDate(),0),
    (29,'Developer', null, null, 'admin', GETDATE(), 0),
	  (30,'Logs', '/api/', 29, 'admin', GETDATE(), 0),
	  (31,'Cron Jobs', '/api/', 29, 'admin', GETDATE(),0),
    (32,'Grievance',null,null,'admin',GetDate(),0),
    (33,'My Grievance','/api/',32,'admin',GetDate(),0),
    (34,'All Grievance','/api/',32,'admin',GetDate(),0),
    (35,'Grievance Configuration','/api/',32,'admin',GetDate(),0)
    

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
	   (11,11,3,'admin',Getdate()),
	   (12,12,3,'admin',Getdate()),
	   (13,13,3,'admin',Getdate()),
	   (14,14,87,'admin',Getdate()),
	   (18,18,1,'admin',Getdate()),
	   (19,19,1,'admin',Getdate()),
     (20,20,92,'admin',Getdate()),
     (21,24,97,'admin',Getdate()),
     (22,25,106,'admin',Getdate()),
     (23,27,111,'admin',Getdate()),
     (24,28,112,'admin',Getdate()),
     (25,32,119,'admin',Getdate()),
     (26,34,124,'admin',Getdate()),
     (27,35,125,'admin',Getdate())


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

 SET IDENTITY_INSERT [dbo].[Permission] OFF

 SET IDENTITY_INSERT [dbo].[RolePermission] ON
   --Grievance Permission

  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(427,1,119,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(428,1,120,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(429,1,121,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(430,1,122,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(431,1,123,'admin',GETDATE(),NULL,NULL,1)

  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(432,2,119,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(433,2,120,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(434,2,121,'admin',GETDATE(),NULL,NULL,1)

  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(435,3,119,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(436,3,120,'admin',GETDATE(),NULL,NULL,1)

  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(437,4,119,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(438,4,120,'admin',GETDATE(),NULL,NULL,1)

  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(439,5,119,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(440,5,120,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(441,5,121,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(442,5,122,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(443,5,123,'admin',GETDATE(),NULL,NULL,1)
  
  
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(444,1,124,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(445,1,125,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(446,5,124,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(447,5,125,'admin',GETDATE(),NULL,NULL,1)
   SET IDENTITY_INSERT [dbo].[RolePermission] OFF