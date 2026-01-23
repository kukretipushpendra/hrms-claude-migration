----------Team Lead add in role------------
SET IDENTITY_INSERT [dbo].[Role] ON;
INSERT INTO [dbo].[Role] (
    [Id],
    [Name],
    [IsActive],
    [CreatedBy],
    [CreatedOn],
    [ModifiedBy],
    [ModifiedOn]
)
VALUES (
    8,                  -- Manual ID value
    'TeamLead',         -- Role Name
    1,                  -- IsActive (1 = Active)
    'admin',            -- CreatedBy
    GETDATE(),          -- CreatedOn
    NULL,            -- ModifiedBy
    NULL           -- ModifiedOn
);
SET IDENTITY_INSERT [dbo].[Role] OFF;

SET IDENTITY_INSERT [dbo].[LeaveType] ON
INSERT INTO [dbo].[LeaveType] 
([Id], [Title], [ShortName], [CreatedBy], [CreatedOn], [ModifiedBy], [ModifiedOn], [IsDeleted]) 
VALUES  
(10, 'Comp Off', 'CO', 'admin', GETDATE(), NULL, NULL, 0)
SET IDENTITY_INSERT [dbo].[LeaveType] OFF

GO

--------------Menu Permission------------------
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
	 (15,16,98,'admin',GetDate()),
	 (16,17,99,'admin',Getdate()),
   (18,18,1,'admin',Getdate()),
   (19,19,1,'admin',Getdate()),
  (20,20,92,'admin',Getdate()),
  (21,22,100,'admin',Getdate()),
   (22,23,101,'admin',Getdate()),
     (23,24,113,'admin',Getdate()),
     (24,25,106,'admin',Getdate()),
     (25,27,111,'admin',Getdate()),
     (26,28,112,'admin',Getdate()),
     (27,29,118,'admin',Getdate()),
     (28,32,119,'admin',Getdate()),
     (29,34,124,'admin',Getdate()),
     (30,35,125,'admin',Getdate())


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
  ALTER TABLE [dbo].[Permission]  WITH CHECK ADD  CONSTRAINT [FK_Permission_Module] FOREIGN KEY([ModuleId]) REFERENCES [dbo].[Module] ([Id])

  IF Not EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_RolePermission_Permission_PermissionId]') AND parent_object_id = OBJECT_ID(N'[dbo].[RolePermission]'))
  ALTER TABLE [dbo].[RolePermission]  WITH CHECK ADD  CONSTRAINT [FK_RolePermission_Permission_PermissionId] FOREIGN KEY([PermissionId]) REFERENCES [dbo].[Permission] ([Id])
Go
--------Grievance Email Resolved----------
INSERT INTO [dbo].[NotificationTemplate] (
    [TemplateName],
    [Subject],
    [Content],
    [CreatedBy],
    [CreatedOn],
    [ModifiedBy],
    [ModifiedOn],
    [IsDeleted],
    [IsDisabled],
    [Type],
    [Status],
    [SenderName],
    [SenderEmail],
    [CCEmails],
    [BCCEmails],
    [ToEmail]
)
VALUES (
    'Grievance Resolved Notification',
    'Your Grievance #{TicketNo} Has Been Resolved',
    '<p>Dear {FirstName} {LastName},<br><br>We are pleased to inform you that your grievance with Ticket No <strong>{TicketNo}</strong> has been successfully resolved.<br><br>Thank you for bringing this to our attention. We appreciate your patience and cooperation during the resolution process.<br><br>If you have any further concerns or feedback, please feel free to reach out to us.<br><br>Warm regards,<br><strong>{SenderName}</strong><br>HR Department<br>{SenderEmail}</p>',
    'system',
    '2025-09-03 13:54:40.807',
    'test.admin@programmers.io',
    '2025-09-03 15:09:34.010',
    0,
    0,
    4,
    1,
    'HR Team',
    'HRMS.Notification@programmers.io',
    'Priyanshu.Saraswat@programmers.io',
    NULL,
    NULL
);

IF NOT EXISTS (SELECT ID FROM Menu WHERE ID IN (36)) BEGIN
	SET IDENTITY_INSERT [dbo].Menu ON
	INSERT INTO Menu (Id, [Name], ApiEndPoint, ParentMenuId, CreatedBy, CreatedOn, IsDeleted) VALUES 
	(36, 'User Guides',null,3,'admin',GetDate(),0)
	
	SET IDENTITY_INSERT [dbo].Menu OFF
END


----------------------------Feedback Module Menu Permission----------------------

IF NOT EXISTS(SELECT 1 FROM [dbo].[Module] WHERE ID=24)
BEGIN
SET IDENTITY_INSERT [dbo].[Module] ON
 
  INSERT INTO [dbo].[Module]([Id],[ModuleName],[IsActive],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn])VALUES(24,'Support',1,'admin',GETDATE(),NULL,NULL)
  
SET IDENTITY_INSERT [dbo].[Module] OFF
END
Go
IF NOT EXISTS(SELECT 1 FROM [dbo].[Permission] WHERE ID IN(126,127,128,129,130,131))
BEGIN
SET IDENTITY_INSERT [dbo].[Permission] ON
 
INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(126,'Read Support',24,'admin',GETDATE(),NULL,NULL,0,'Read.Support')
INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(127,'Create Support ',24,'admin',GETDATE(),NULL,NULL,0,'Create.Support')
INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(128,'Edit Support',24,'admin',GETDATE(),NULL,NULL,0,'Edit.Support')
INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(129,'Delete Support',24,'admin',GETDATE(),NULL,NULL,0,'Delete.Support')
INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(130,'View Support',24,'admin',GETDATE(),NULL,NULL,0,'View.Support')
INSERT INTO [dbo].[Permission]([Id],[Name],[ModuleId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[Value])VALUES(131,'Read All Support',24,'admin',GETDATE(),NULL,NULL,0,'Read.AllSupport')

 SET IDENTITY_INSERT [dbo].[Permission] OFF
 END
 

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

 INSERT INTO [dbo].[Menu]([Id],[Name],[ApiEndPoint],[ParentMenuId],[CreatedBy],[CreatedOn],[IsDeleted])
Values
    (1,'Employees','/api/EmployeeGroup/GetAllEmployees',null,'admin',Getdate(),0),
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
    (26,'My KPI','/api/',null,'admin',GetDate(),0),
    (27,'Goals','/api/',null,'admin',GetDate(),0),
    (28,'KPI Management','/api/',null,'admin',GetDate(),0),
	  (29,'Developer', null, null, 'admin', GETDATE() ,0),
	  (30,'Logs', '/api/', 29, 'admin', GETDATE(),  0),
	  (31,'Cron Jobs', '/api/', 29, 'admin', GETDATE(), 0),
    (32,'Grievance',null,null,'admin',GetDate(),0),
    (33,'My Grievance','/api/',32,'admin',GetDate(),0),
    (34,'All Grievance','/api/',32,'admin',GetDate(),0),
    (35,'Grievance Configuration','/api/',32,'admin',GetDate(),0),
    (37,'Support','/api/',null,'admin',GetDate(),0),
    (38,'My Support','/api/',37,'admin',GetDate(),0),
    (39,'Support Queries','/api/',37,'admin',GetDate(),0)

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
	 (15,16,98,'admin',GetDate()),
	 (16,17,99,'admin',Getdate()),
   (18,18,1,'admin',Getdate()),
   (19,19,1,'admin',Getdate()),
  (20,20,92,'admin',Getdate()),
  (21,22,100,'admin',Getdate()),
   (22,23,101,'admin',Getdate()),
     (23,24,113,'admin',Getdate()),
     (24,25,106,'admin',Getdate()),
     (25,27,111,'admin',Getdate()),
     (26,28,112,'admin',Getdate()),
     (27,29,118,'admin',Getdate()),
     (28,32,119,'admin',Getdate()),
     (29,34,124,'admin',Getdate()),
     (30,35,125,'admin',Getdate()),
     (31,37,126,'admin',Getdate()),
     (32,38,126,'admin',Getdate()),
     (33,39,131,'admin',Getdate())


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
  ALTER TABLE [dbo].[Permission]  WITH CHECK ADD  CONSTRAINT [FK_Permission_Module] FOREIGN KEY([ModuleId]) REFERENCES [dbo].[Module] ([Id])

  IF Not EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_RolePermission_Permission_PermissionId]') AND parent_object_id = OBJECT_ID(N'[dbo].[RolePermission]'))
  ALTER TABLE [dbo].[RolePermission]  WITH CHECK ADD  CONSTRAINT [FK_RolePermission_Permission_PermissionId] FOREIGN KEY([PermissionId]) REFERENCES [dbo].[Permission] ([Id])
GO


-------------------------Feedback----------------------------
SET IDENTITY_INSERT [dbo].[RolePermission] ON

  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(449,1,126,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(450,1,127,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(451,1,128,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(452,1,129,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(453,1,130,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(454,1,131,'admin',GETDATE(),NULL,NULL,1)

  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(455,2,126,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(456,2,127,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(457,2,128,'admin',GETDATE(),NULL,NULL,1)

  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(458,3,126,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(459,3,127,'admin',GETDATE(),NULL,NULL,1)

  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(460,4,126,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(461,4,127,'admin',GETDATE(),NULL,NULL,1)

  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(462,5,126,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(463,5,127,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(464,5,128,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(465,5,129,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(466,5,130,'admin',GETDATE(),NULL,NULL,1)
  INSERT INTO [dbo].[RolePermission]([Id],[RoleId],[PermissionId],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsActive])VALUES(467,5,131,'admin',GETDATE(),NULL,NULL,1)
  
  SET IDENTITY_INSERT [dbo].[RolePermission] OFF
GO


--------------------Feedback Status Change Email Template-----------------------
INSERT INTO [HRMS].[dbo].[NotificationTemplate] (
    [TemplateName],
    [Subject],
    [Content],
    [CreatedBy],
    [CreatedOn],
    [ModifiedBy],
    [ModifiedOn],
    [IsDeleted],
    [IsDisabled],
    [Type],
    [Status],
    [SenderName],
    [SenderEmail],
    [CCEmails],
    [BCCEmails],
    [ToEmail]
)
VALUES (
    'FeedbackStatusChanged',
    'Support Ticket Status Updated',
    '<p>Dear {EmployeeName},</p>    <p>The status of your support ticket (ID: {TicketId}) has been updated on <strong>{ModifiedOn}</strong>. Below are the updated details of your ticket:</p>    <table border="1" cellpadding="6" cellspacing="0" style="border-collapse: collapse; font-family: Arial, sans-serif; font-size: 14px; width: 100%;">    <thead>      <tr style="background-color: #f2f2f2;">        <th align="left">Field</th>        <th align="left">Details</th>      </tr>    </thead>    <tbody>      <tr>        <td><strong>Ticket ID</strong></td>        <td>{TicketId}</td>      </tr>      <tr>        <td><strong>Feedback Type</strong></td>        <td>{FeedbackType}</td>      </tr>      <tr>        <td><strong>Subject</strong></td>        <td>{Subject}</td>      </tr>      <tr>        <td><strong>Description</strong></td>        <td>{Description}</td>      </tr>      <tr>        <td><strong>Status</strong></td>        <td>{TicketStatus}</td>      </tr>      <tr>        <td><strong>Admin Comment</strong></td>        <td>{AdminComment}</td>      </tr>      <tr>        <td><strong>Updated On</strong></td>        <td>{ModifiedOn}</td>      </tr>      <tr>        <td><strong>Submitted On</strong></td>        <td>{CreatedOn}</td>      </tr>    </tbody>  </table>    <p>If you have any further questions, please contact the support team.</p>    <p>Warm regards,<br>  {SenderName}<br>  <a href="mailto:{SenderEmail}">{SenderEmail}</a></p>',
    'System',                     -- CreatedBy
    GETUTCDATE(),                -- CreatedOn
    NULL,                        -- ModifiedBy
    NULL,                        -- ModifiedOn
    0,                           -- IsDeleted
    0,                           -- IsDisabled
    22,                          -- Type (FeedbackStatusChanged)
    1,                           -- Status (Active)
    'Support Team',              -- SenderName
    'HRMS.Notification@programmers.io',       -- SenderEmail
    'divyanshu.sharma@programmers.io;aaryan.pancholi@programmers.io', -- CCEmails
    'aaryan.pancholi@programmers.io', -- BCCEmails
    NULL                         -- ToEmail (will be replaced by employee email)
);




---------------Feedback submit notification template----------------
INSERT INTO [HRMS].[dbo].[NotificationTemplate] (
    [TemplateName],
    [Subject],
    [Content],
    [CreatedBy],
    [CreatedOn],
    [ModifiedBy],
    [ModifiedOn],
    [IsDeleted],
    [IsDisabled],
    [Type],
    [Status],
    [SenderName],
    [SenderEmail],
    [CCEmails],
    [BCCEmails],
    [ToEmail]
)
VALUES (
    'FeedbackSubmitted',
    'Support Ticket Submitted',
    '<p>Dear {EmployeeName},</p>    <p>Your support ticket submitted on <strong>{CreatedOn}</strong> has been successfully received. Below are the details of your ticket:</p>    <table border="1" cellpadding="6" cellspacing="0" style="border-collapse: collapse; font-family: Arial, sans-serif; font-size: 14px; width: 100%;">    <thead>      <tr style="background-color: #f2f2f2;">        <th align="left">Field</th>        <th align="left">Details</th>      </tr>    </thead>    <tbody>      <tr>        <td><strong>Ticket ID</strong></td>        <td>{TicketId}</td>      </tr>      <tr>        <td><strong>Feedback Type</strong></td>        <td>{FeedbackType}</td>      </tr>      <tr>        <td><strong>Subject</strong></td>        <td>{Subject}</td>      </tr>      <tr>        <td><strong>Description</strong></td>        <td>{Description}</td>      </tr>      <tr>        <td><strong>Status</strong></td>        <td>{TicketStatus}</td>      </tr>      <tr>        <td><strong>Submitted On</strong></td>        <td>{CreatedOn}</td>      </tr>    </tbody>  </table>    <p>We will review your query and get back to you soon. If you have any further questions, please contact the support team.</p>    <p>Warm regards,<br>  {SenderName}<br>  <a href="mailto:{SenderEmail}">{SenderEmail}</a></p>',
    'System',                     -- CreatedBy
    GETUTCDATE(),                    -- CreatedOn
    NULL,                         -- ModifiedBy
    NULL,                         -- ModifiedOn
    0,                            -- IsDeleted
    0,                            -- IsDisabled
    21,                            -- Type (FeedbackSubmitted, assuming 8 is the enum value)
    1,                            -- Status (Active)
    'Support Team',               -- SenderName
    'HRMS.Notification@programmers.io',        -- SenderEmail
    'divyanshu.sharma@programmers.io;aaryan.pancholi@programmers.io', -- CCEmails (e.g., support team emails)
    'aaryan.pancholi@programmers.io',                         -- BCCEmails
    NULL                   -- ToEmail (will be replaced by employee email)
);