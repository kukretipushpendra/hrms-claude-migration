
IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'DesignationId' AND Object_ID = OBJECT_ID(N'[EmploymentDetail]'))
BEGIN
    ALTER TABLE [EmploymentDetail] ADD DesignationId BIGINT NULL; 
END

-------------------Attendance-----------------------
GO 
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Attendance]') AND type = 'U')
BEGIN
    CREATE TABLE Attendance (
        Id BIGINT PRIMARY KEY IDENTITY(1,1),
        EmployeeId BIGINT,
        [Date] DATE,
        StartTime TIME,
        EndTime TIME,
        [Day] VARCHAR(50),
        AttendanceType VARCHAR(100),
        TotalHours VARCHAR(50),
        [Location] VARCHAR(255),
        CreatedOn DATETIME,
        CreatedBy NVARCHAR(255),
        ModifiedBy NVARCHAR(255),
        ModifiedOn DATETIME
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys  WHERE object_id = OBJECT_ID(N'[dbo].[FK_Attendance_EmployeeData_EmployeeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Attendance]'))
BEGIN
  ALTER TABLE [dbo].[Attendance] WITH NOCHECK ADD CONSTRAINT [FK_Attendance_EmployeeData_EmployeeId]FOREIGN KEY (EmployeeId)
  REFERENCES [dbo].[EmployeeData] (Id);
END
-------------------------AttendanceAudit--------------
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AttendanceAudit]') AND type in (N'U'))
BEGIN
CREATE TABLE AttendanceAudit (
  Id BIGINT PRIMARY KEY IDENTITY(1,1),
  AttendanceId BIGINT,
  [Action] VARCHAR(255),
  [Time] VARCHAR(255),
  Comment TEXT,
  Reason TEXT,
  
);

End
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_AttendanceAudit_Attendance_AttendanceId]') AND parent_object_id = OBJECT_ID(N'[dbo].[AttendanceAudit]'))
ALTER TABLE [dbo].[AttendanceAudit]  WITH NOCHECK ADD  CONSTRAINT [FK_AttendanceAudit_Attendance_AttendanceId] FOREIGN KEY([AttendanceId])
REFERENCES [dbo].[Attendance] ([Id])
GO
------------------------------------------------------------------------------------------
GO
IF  EXISTS (SELECT * FROM sys.columns WHERE Name = N'EmployeeCode' AND Object_ID = OBJECT_ID(N'[EmployeeData]'))
BEGIN
    ALTER TABLE [EmployeeData] ALTER COLUMN EmployeeCode VARCHAR(20) NULL; 
END
GO
IF  EXISTS (SELECT * FROM sys.columns WHERE Name = N'Designation' AND Object_ID = OBJECT_ID(N'[EmploymentDetail]'))
BEGIN
    ALTER TABLE [EmploymentDetail] DROP COLUMN Designation ; 
END
GO
IF  EXISTS (SELECT * FROM sys.columns WHERE Name = N'DepartmentName' AND Object_ID = OBJECT_ID(N'[EmploymentDetail]'))
BEGIN
    ALTER TABLE [EmploymentDetail] DROP COLUMN DepartmentName ; 
END
GO
IF  EXISTS (SELECT * FROM sys.columns WHERE Name = N'TeamName' AND Object_ID = OBJECT_ID(N'[EmploymentDetail]'))
BEGIN
    ALTER TABLE [EmploymentDetail] DROP COLUMN TeamName ; 
END
GO
IF  EXISTS (SELECT * FROM sys.columns WHERE Name = N'RoleId' AND Object_ID = OBJECT_ID(N'[EmploymentDetail]'))
BEGIN
    ALTER TABLE [EmploymentDetail] DROP COLUMN RoleId ; 
END
GO
IF  EXISTS (SELECT * FROM sys.columns WHERE Name = N'ReportingManagerEmail' AND Object_ID = OBJECT_ID(N'[EmploymentDetail]'))
BEGIN
    ALTER TABLE [EmploymentDetail] DROP COLUMN ReportingManagerEmail ; 
END
GO 