GO
SET IDENTITY_INSERT [dbo].[LeaveType] ON
INSERT INTO [dbo].[LeaveType] 
([Id], [Title], [ShortName], [CreatedBy], [CreatedOn], [ModifiedBy], [ModifiedOn], [IsDeleted]) 
VALUES 
(1, 'Casual Leave', 'CL', 'admin', GETDATE(), NULL, NULL, 0),
(2, 'Earned Leave', 'EL', 'admin', GETDATE(), NULL, NULL, 0),
(3, 'Bereavement Leave', 'BL', 'admin', GETDATE(), NULL, NULL, 0),
(4, 'Parental Leave', 'PL', 'admin', GETDATE(), NULL, NULL, 0),
(5, 'Advance Leave', 'AL', 'admin', GETDATE(), NULL, NULL, 0),
(6, 'Leave in Bucket', 'LB', 'admin', GETDATE(), NULL, NULL, 0),
(7, 'Loss Of Pay', 'LOP','admin',GETDATE(),NULL, NULL,0)
SET IDENTITY_INSERT [dbo].[LeaveType] OFF
GO


SET IDENTITY_INSERT [dbo].[Module] ON 
    INSERT INTO [dbo].[Module]([Id],[ModuleName],[IsActive],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn])VALUES(19,'Leave',1,'admin',GETDATE(),NULL,NULL)
SET IDENTITY_INSERT [dbo].[Module] OFF


 SET IDENTITY_INSERT [dbo].[Permission] ON
INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(92,'Read Leave',19,'admin',GETDATE(),NULL,NULL,0,'Read.Leave')
INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(93,'Create Leave',19,'admin',GETDATE(),NULL,NULL,0,'Create.Leave')
INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(94,'Edit Leave',19,'admin',GETDATE(),NULL,NULL,0,'Edit.Leave')
INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(95,'Delete Leave',19,'admin',GETDATE(),NULL,NULL,0,'Delete.Leave')
INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(96,'View Leave',19,'admin',GETDATE(),NULL,NULL,0,'View.Leave')
 
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
      (22,'Leave Approval','/api/',20,'admin,',GetDate(),0)

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
     (20,20,92,'admin',Getdate())

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

--Leave--
 SET IDENTITY_INSERT [dbo].[RolePermission] ON
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(281,1,92,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(282,1,93,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(283,1,94,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(284,1,95,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(285,1,96,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(286,2,92,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(287,2,93,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(288,2,94,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(289,3,92,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(290,3,93,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(291,4,92,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(292,4,93,'admin',GETDATE(),NULL,NULL,1)



   SET IDENTITY_INSERT [dbo].[RolePermission] OFF


IF NOT EXISTS (
    SELECT 1 FROM [dbo].[Menu] WHERE [Id] = 10
)
BEGIN
    SET IDENTITY_INSERT [dbo].[Menu] ON
    INSERT INTO [dbo].[Menu] (
        [Id], [Name], [ApiEndPoint], [ParentMenuId],
        [CreatedBy], [CreatedOn], [ModifiedBy], [ModifiedOn],
        [IsDeleted], [OrderNo]
    )
    VALUES (
        10, 'Email and Notification', '/api/', 3,
        'admin', GETDATE(), NULL, NULL,
        0, NULL
    )
    SET IDENTITY_INSERT [dbo].[Menu] OFF
END

IF NOT EXISTS (
    SELECT 1 FROM [dbo].[MenuPermission] WHERE [Id] = 10
)
BEGIN
    SET IDENTITY_INSERT [dbo].[MenuPermission] ON
    INSERT INTO [dbo].[MenuPermission] (
        [Id], [MenuId], [ReadPermissionId],
        [CreatedBy], [CreatedOn], [ModifiedBy], [ModifiedOn]
    )
    VALUES (
        10, 10, 31,
        'admin', GETDATE(), NULL, NULL
    )
    SET IDENTITY_INSERT [dbo].[MenuPermission] OFF
END

-- permission for attendance / leave submenus for superadmin

IF NOT EXISTS (SELECT Id FROM RolePermission RP WHERE RP.RoleId = 1 AND RP.PermissionId IN (98,99,100,101)) 
BEGIN
	INSERT INTO RolePermission(RoleId, PermissionId, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn, IsActive) VALUES 
	(1, 98, 'admin', GETDATE(), null, null, 1),
	(1, 99, 'admin', GETDATE(), null, null, 1),
	(1, 100, 'admin', GETDATE(), null, null, 1),
	(1, 101, 'admin', GETDATE(), null, null, 1)
END
IF NOT EXISTS (SELECT Id FROM MenuPermission MP WHERE MP.ReadPermissionId IN (98,99,100,101)) 
BEGIN
	INSERT INTO MenuPermission (MenuId, ReadPermissionId, CreatedBy, CreatedOn) values
	(16, 98, 'admin', getdate()),
	(17, 99, 'admin', getdate()),
	(22, 100, 'admin', getdate()),
	(23, 101, 'admin', getdate())
END
 GO
--Leave--
 SET IDENTITY_INSERT [dbo].[RolePermission] ON
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(293,1,97,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(294,1,98,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(295,1,99,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(296,1,100,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(297,1,101,'admin',GETDATE(),NULL,NULL,1)

  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(298,2,97,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(299,2,98,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(300,2,99,'admin',GETDATE(),NULL,NULL,1)

  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(301,3,97,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(302,3,98,'admin',GETDATE(),NULL,NULL,1)

  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(303,4,97,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(304,4,98,'admin',GETDATE(),NULL,NULL,1)
   
SET IDENTITY_INSERT [dbo].[RolePermission] OFF
SET IDENTITY_INSERT [dbo].Permission ON
insert into Permission (id, name, ModuleId, CreatedBy, createdon, value, IsDeleted) values 
(98, 'Read Attendance Configuration', 18, 'admin', getdate(), 'Read.AttendanceConfiguration', 1),
(99, 'Read Attendance Employee Report', 18, 'admin', getdate(), 'Read.AttendanceEmployeeReport', 1),
(100, 'Read Leave Approval', 19, 'admin', getdate(), 'Read.LeaveApproval', 1),
(101, 'Read Leave Calendar', 19, 'admin', getdate(), 'Read.LeaveCalendar', 1)
SET IDENTITY_INSERT [dbo].Permission OFF
insert into MenuPermission (MenuId, ReadPermissionId, CreatedBy, CreatedOn) values
(16, 98, 'admin', getdate()),
(17, 99, 'admin', getdate()),
(22, 100, 'admin', getdate()),
(23, 101, 'admin', getdate())
