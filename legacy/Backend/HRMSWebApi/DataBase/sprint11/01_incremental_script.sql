GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LeaveType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[LeaveType](
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [Title] [varchar](50) NOT NULL,
	[ShortName] [varchar](10) NOT NULL,
    [CreatedBy]  [varchar](100) NOT NULL,
    [CreatedOn] [datetime] NOT NULL,
    [ModifiedBy]  [varchar](100) NULL,
    [ModifiedOn] [datetime] NULL,
    [IsDeleted] [bit] NULL,
	 
    CONSTRAINT [PK_LeaveType] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [UQ_LeaveType_ShortName] UNIQUE ([ShortName])
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeLeave]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[EmployeeLeave](
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [EmployeeId] [Bigint] NOT NULL,
    [LeaveId] [int] NOT NULL,
    [OpeningBalance] [decimal](18,2) NOT NULL,
    [LeaveDate] [date] NOT NULL,
    [IsActive] [bit] NULL,
    [ModifiedOn] [datetime] NULL,
    [ModifiedBy]  [varchar](100) NULL,
    [CreatedOn] [datetime] NOT NULL,
    [CreatedBy]  [varchar](100) NOT NULL,
	 
CONSTRAINT [PK_EmployeeLeave] PRIMARY KEY CLUSTERED 
(   [Id] ASC 
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_EmployeeLeave_EmployeeData_EmployeeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[EmployeeLeave]'))
ALTER TABLE [dbo].[EmployeeLeave] WITH CHECK ADD CONSTRAINT [FK_EmployeeLeave_EmployeeData_EmployeeId] FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[EmployeeData] (Id)
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_EmployeeLeave_LeaveType_LeaveId]') AND parent_object_id = OBJECT_ID(N'[dbo].[EmployeeLeave]'))
ALTER TABLE [dbo].[EmployeeLeave] WITH CHECK ADD CONSTRAINT [FK_EmployeeLeave_LeaveType_LeaveId] FOREIGN KEY([LeaveId])
REFERENCES [dbo].[LeaveType] (Id)
 
 
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AppliedLeaves]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AppliedLeaves](
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [EmployeeId] [bigint] NOT NULL,
    [LeaveId] [int] NOT NULL,
    [ReportingManagerId] [bigint]  NULL,
    [Status] [tinyInt] NOT NULL,
    [Reason] [varchar](500) NOT NULL,
    [RejectReason] [varchar](500) NULL,
    [StartDate] [date] NOT NULL,
    [StartDateSlot] [tinyInt] NOT NULL,
    [EndDate] [date] NOT NULL,
    [EndDateSlot] [tinyInt] NOT NULL,
    [AttachmentPath] [Nvarchar](100)  NULL,
    [CreatedOn] [datetime] NOT NULL,
    [CreatedBy][varchar](100) NOT NULL,
    [ModifiedOn][datetime] NULL,
    [ModifiedBy][varchar](50)NULL,	 
CONSTRAINT [PK_AppliedLeaves] PRIMARY KEY CLUSTERED 
(   [Id] ASC 
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] 
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_AppliedLeaves_EmployeeData_EmployeeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[AppliedLeaves]'))
ALTER TABLE [dbo].[AppliedLeaves] WITH CHECK ADD CONSTRAINT [FK_AppliedLeaves_EmployeeData_EmployeeId] FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[EmployeeData] (Id)
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_AppliedLeaves_LeaveType_LeaveId]') AND parent_object_id = OBJECT_ID(N'[dbo].[AppliedLeaves]'))
ALTER TABLE [dbo].[AppliedLeaves] WITH CHECK ADD CONSTRAINT [FK_AppliedLeaves_LeaveType_LeaveId] FOREIGN KEY([LeaveId])
REFERENCES [dbo].[LeaveType] (Id)
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_AppliedLeaves_EmploymentDetail_ReportingMangerId]') AND parent_object_id = OBJECT_ID(N'[dbo].[AppliedLeaves]'))
ALTER TABLE [dbo].[AppliedLeaves] WITH CHECK ADD CONSTRAINT [FK_AppliedLeaves_EmploymentDetail_ReportingMangerId] FOREIGN KEY([ReportingManagerId])
REFERENCES [dbo].[EmploymentDetail] (Id)
---------------------------------------------------------------------------------------------------
IF NOT EXISTS ( SELECT * FROM sys.columns WHERE Name = N'RejectReason' AND Object_ID = OBJECT_ID(N'[dbo].[AppliedLeaves]'))
BEGIN
    ALTER TABLE [dbo].[AppliedLeaves] 
    ADD [RejectReason] VARCHAR(500) NULL;
END
GO

Go
IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'FileOriginalName' AND Object_ID = OBJECT_ID(N'[AccountClearance]'))
BEGIN
ALTER TABLE [AccountClearance] ADD FileOriginalName VARCHAR(255) 
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'FileOriginalName' AND Object_ID = OBJECT_ID(N'[DepartmentClearance]'))
BEGIN
ALTER TABLE [DepartmentClearance] ADD FileOriginalName VARCHAR(255) 
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'FileOriginalName' AND Object_ID = OBJECT_ID(N'[ITClearance]'))
BEGIN
ALTER TABLE [ITClearance] ADD FileOriginalName VARCHAR(255) 
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'FileOriginalName' AND Object_ID = OBJECT_ID(N'[HRClearance]'))
BEGIN
ALTER TABLE [HRClearance] ADD FileOriginalName VARCHAR(255) 
END
GO
Go

------------------------AccrualUtilizedLeave------------------------
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AccrualUtilizedLeave]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AccrualUtilizedLeave](
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [EmployeeId] [bigint] NOT NULL, 
    [LeaveId] [int] NOT NULL,
    [Date] [datetime] NOT NULL,
    [Description] [nvarchar](500) NULL,
    [Accrued] [decimal](18, 2) NULL,
    [UtilizedOrRejected] [decimal](18, 2) NULL,
    [ClosingBalance] [decimal](18, 2) NOT NULL,
    [CreatedOn] [datetime] NOT NULL DEFAULT GETDATE(),
    [CreatedBy] [nvarchar](100)  NULL,
CONSTRAINT [PK_AccrualUtilizedLeave] PRIMARY KEY CLUSTERED 
(   [Id] ASC 
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_AccrualUtilizedLeave_EmployeeData_EmployeeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[AccrualUtilizedLeave]'))
ALTER TABLE [dbo].[AccrualUtilizedLeave] WITH CHECK ADD CONSTRAINT [FK_AccrualUtilizedLeave_EmployeeData_EmployeeId] FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[EmployeeData] (Id)
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_AccrualUtilizedLeave_LeaveType_LeaveId]') AND parent_object_id = OBJECT_ID(N'[dbo].[AccrualUtilizedLeave]'))
ALTER TABLE [dbo].[AccrualUtilizedLeave] WITH CHECK ADD CONSTRAINT [FK_AccrualUtilizedLeave_LeaveType_LeaveId] FOREIGN KEY([LeaveId])
REFERENCES [dbo].[LeaveType] (Id)
GO

IF EXISTS (
    SELECT 1
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'EmployeeLeave'
      AND COLUMN_NAME = 'OpeningBalance'
      AND (
          DATA_TYPE != 'decimal' OR
          NUMERIC_PRECISION != 18 OR
          NUMERIC_SCALE != 2 OR
          IS_NULLABLE = 'YES'
      )
)
BEGIN
    ALTER TABLE EmployeeLeave
    ALTER COLUMN OpeningBalance DECIMAL(18,2) NOT NULL;
END

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_EmploymentDetail_BranchId]') AND parent_object_id = OBJECT_ID(N'[dbo].[EmploymentDetail]'))
ALTER TABLE [dbo].[EmploymentDetail]   DROP CONSTRAINT [FK_EmploymentDetail_BranchId] 
GO

DROP TABLE IF EXISTS [DBO].[Branch];
DROP TABLE IF EXISTS [DBO].[EmploymentStatus];
DROP TABLE IF EXISTS [DBO].[EmployeeStatus];

IF EXISTS (SELECT * FROM sys.columns WHERE Name = N'NotificationTemplateTypeId' AND Object_ID = OBJECT_ID(N'[NotificationTemplate]'))
BEGIN
ALTER TABLE NotificationTemplate DROP COLUMN [NotificationTemplateTypeId]
END
GO
IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'IsDisabled' AND Object_ID = OBJECT_ID(N'[NotificationTemplate]'))
BEGIN
ALTER TABLE NotificationTemplate ADD IsDisabled BIT NOT NULL DEFAULT 0
END

--------------------------NotificationTemplate--------------------
GO
ALTER TABLE NotificationTemplate ADD [Type] INT NULL
ALTER TABLE NotificationTemplate ADD [Status] INT NULL DEFAULT 0 -- null is default, 0 is inactive, 1 is active
ALTER TABLE NotificationTemplate ADD [SenderName] NVARCHAR(MAX)
ALTER TABLE NotificationTemplate ADD [SenderEmail] NVARCHAR(MAX)
ALTER TABLE NotificationTemplate ADD [CCEmails] NVARCHAR(MAX)
ALTER TABLE NotificationTemplate ADD [BCCEmails] NVARCHAR(MAX)
ALTER TABLE NotificationTemplate ADD [ToEmail] NVARCHAR(MAX)
ALTER TABLE NotificationTemplate DROP COLUMN Description

GO
CREATE UNIQUE INDEX UQ_NotificationTemplate_Type_Status
ON NotificationTemplate ([Type], [Status])
WHERE [Status] != 0;

GO
CREATE OR ALTER VIEW vw_EmployeeData AS 
SELECT  
E.Id AS EmployeeId, 
E.PersonalEmail AS PersonalEmail, 
ED.EmploymentStatus,  
ED.EmployeeStatus, 
E.EmployeeCode AS EmployeeCode, 
E.FirstName AS FirstName, 
E.MiddleName AS MiddleName, 
E.LastName AS LastName, 
CONCAT(E.FirstName, ' ', E.MiddleName, ' ', E.LastName) AS EmployeeFullname, 
CONCAT(RepManagerE.FirstName, ' ', RepManagerE.MiddleName, ' ', RepManagerE.LastName) AS ReportingManagerName, 
ED.ReportingMangerId as ReportingManagerId,ED.ImmediateManager,
E.FatherName, 
E.Gender, 
E.DOB, 
E.EmergencyContactNo, 
E.BloodGroup, 
E.MaritalStatus, 
E.Phone, 
E.AlternatePhone, 
ED.TimeDoctorUserId AS TimeDoctorUserId, 
ED.Email AS OfficeEmail, 
ED.IsManualAttendance AS IsManualAttendance, 
ED.JoiningDate AS JoiningDate,ED.ConfirmationDate,ED.JobType, 
T.TeamName AS Team, 
D.Department AS Department, 
D.Id AS DepartmentId, 
DE.Designation AS Designation, 
DE.Id AS DesignationId, 
ED.BranchId AS BranchId, 
R.Name as RoleName, R.Id as RoleId,
C.CountryName AS Country,
C.Id AS CountryId
FROM EmployeeData E 
INNER JOIN EmploymentDetail ED ON E.Id = ED.EmployeeId 
LEFT JOIN Department D ON D.Id = Ed.DepartmentId 
LEFT JOIN Team T ON T.Id = ED.TeamId 
LEFT JOIN EmployeeData RepManagerE ON RepManagerE.Id = ED.ReportingMangerId 
LEFT JOIN Designation DE ON DE.Id = ED.DesignationId 
LEFT JOIN UserRoleMapping Ur ON Ur.EmployeeId = ED.EmployeeId 
LEFT JOIN [Address] AD ON AD.EmployeeId = E.Id
LEFT JOIN Country C ON C.Id = AD.CountryId
LEFT JOIN Role R ON R.Id = Ur.RoleId 
GO

------View for resignation ------
 CREATE OR ALTER VIEW vw_ResignationDetail AS
    SELECT  
	   r.EmployeeId as EmployeeId,
            d.Department AS DepartmentName,
            r.LastWorkingDay,
            r.CreatedOn As ResignationDate,
            r.EarlyReleaseDate,
            r.EarlyReleaseStatus,
            r.Status as ResignationStatus,
            r.Reason,
            dc.KTStatus,
            hr.ExitInterviewStatus,
            it.ITClearanceCertification AS ITNoDue,
            ac.IssueNoDueCertificate as AccountsNoDue,
            ac.FnFStatus, 
			r.Id As ResignationId 
        FROM 
            dbo.Resignation r 
        LEFT JOIN 
            dbo.HRClearance hr ON r.Id = hr.ResignationId
        LEFT JOIN 
            dbo.DepartmentClearance dc ON r.Id = dc.ResignationId
        LEFT JOIN 
            dbo.ITClearance it ON r.Id = it.ResignationId
        LEFT JOIN 
            dbo.AccountClearance ac ON r.Id = ac.ResignationId
        LEFT JOIN 
            dbo.Department d ON r.DepartmentID = d.Id 
-------SP for exit employee list and detail
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'RequestId' AND Object_ID = OBJECT_ID(N'[Logging]'))
BEGIN
ALTER TABLE [dbo].[Logging] ADD RequestId VARCHAR(64);
CREATE INDEX IX_Logging_RequestId ON Logging (RequestId);
END

IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'Logging' 
      AND COLUMN_NAME = 'Properties'
)
BEGIN
    ALTER TABLE Logging DROP COLUMN Properties;
END
IF NOT EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'Logging' 
      AND COLUMN_NAME = 'LogEvent'
)
BEGIN
    ALTER TABLE LOGGING ADD LogEvent NVARCHAR(MAX) NULL
END
-----AppliedLeaves Column Added--------
ALTER TABLE [dbo].[AppliedLeaves]
ADD [TotalLeaveDays] [decimal](5,2) NULL;




update LeaveType set ShortName='PTL' where id=4
SET IDENTITY_INSERT [dbo].[LeaveType] ON
INSERT INTO LeaveType (id, title, ShortName, CreatedBy, CreatedOn, IsDeleted) values (8, 'Paternity Leave', 'PL', 'admin', GETDATE(), 0)
INSERT INTO LeaveType (id, title, ShortName, CreatedBy, CreatedOn, IsDeleted) values (9, 'Maternity Leave', 'ML', 'admin', GETDATE(), 0)
SET IDENTITY_INSERT [dbo].[LeaveType] OFF

