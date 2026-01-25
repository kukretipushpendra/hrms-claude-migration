/*
============================================
  HRMS Database Initialization Script
  For SQL Server Management Studio (SSMS)
============================================

IMPORTANT: Enable SQLCMD Mode before running!
  Menu: Query -> SQLCMD Mode

This script will:
1. Create the HRMS database if not exists
2. Execute all core scripts
3. Execute all sprint scripts
4. Verify the setup

Update the path below to match your repository location.
*/

-- ============================================
-- CONFIGURATION - UPDATE THIS PATH
-- ============================================
:setvar BasePath "D:\projects\HRMS-MIGRATION-CLAUDE\hrms-claude-migration\legacy\Backend\HRMSWebApi\DataBase"
:setvar DatabaseName "HRMS"

-- ============================================
-- Create Database
-- ============================================
PRINT '============================================';
PRINT '  Creating Database';
PRINT '============================================';

USE [master];
GO

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = '$(DatabaseName)')
BEGIN
    CREATE DATABASE [$(DatabaseName)];
    PRINT 'Database $(DatabaseName) created.';
END
ELSE
BEGIN
    PRINT 'Database $(DatabaseName) already exists.';
END
GO

USE [$(DatabaseName)];
GO

-- ============================================
-- PHASE 1: Core Scripts
-- ============================================
PRINT '';
PRINT '============================================';
PRINT '  PHASE 1: Core Database Scripts';
PRINT '============================================';

PRINT '';
PRINT '[1/4] Creating master tables...';
:r $(BasePath)\01_HRMS_MasterTable_Scripts.sql
PRINT '[OK] Master tables created.';
GO

PRINT '';
PRINT '[2/4] Creating application tables...';
:r $(BasePath)\02_HRMS_Table_Scripts.sql
PRINT '[OK] Application tables created.';
GO

PRINT '';
PRINT '[3/4] Inserting master data (this may take a while)...';
:r $(BasePath)\03_HRMS_MasterTable_Data.sql
PRINT '[OK] Master data inserted.';
GO

PRINT '';
PRINT '[4/4] Creating stored procedures...';
:r $(BasePath)\04_HRMS_StoreProcedure.sql
PRINT '[OK] Stored procedures created.';
GO

-- ============================================
-- PHASE 2: Sprint Scripts
-- ============================================
PRINT '';
PRINT '============================================';
PRINT '  PHASE 2: Sprint Incremental Scripts';
PRINT '============================================';

-- Sprint 01
PRINT '';
PRINT '--- Sprint 01 ---';
:r $(BasePath)\sprint01\01_incremental_script.sql
:r $(BasePath)\sprint01\02_incremental_insert.sql
:r $(BasePath)\sprint01\03_incremental_procedure.sql
GO

-- Sprint 02
PRINT '';
PRINT '--- Sprint 02 ---';
:r $(BasePath)\sprint02\01_incremental_script.sql
:r $(BasePath)\sprint02\02_incremental_insert.sql
:r $(BasePath)\sprint02\03_incremental_procedure.sql
GO

-- Sprint 03
PRINT '';
PRINT '--- Sprint 03 ---';
:r $(BasePath)\sprint03\01_incremental_script.sql
:r $(BasePath)\sprint03\02_incremental_insert.sql
:r $(BasePath)\sprint03\03_incremental_procedure.sql
GO

-- Sprint 04
PRINT '';
PRINT '--- Sprint 04 ---';
:r $(BasePath)\sprint04\01_incremental_script.sql
:r $(BasePath)\sprint04\02_incremental_insert.sql
:r $(BasePath)\sprint04\03_incremental_procedure.sql
GO

-- Sprint 05
PRINT '';
PRINT '--- Sprint 05 ---';
:r $(BasePath)\sprint05\01_incremental_script.sql
:r $(BasePath)\sprint05\02_incremental_insert.sql
:r $(BasePath)\sprint05\03_incremental_procedure.sql
GO

-- Sprint 06 - Does not exist, skipped

-- Sprint 07
PRINT '';
PRINT '--- Sprint 07 ---';
:r $(BasePath)\sprint07\01_incremental_script.sql
:r $(BasePath)\sprint07\02_incremental_insert.sql
:r $(BasePath)\sprint07\03_incremental_procedure.sql
GO

-- Sprint 08
PRINT '';
PRINT '--- Sprint 08 ---';
:r $(BasePath)\sprint08\01_incremental_script.sql
:r $(BasePath)\sprint08\02_incremental_insert.sql
:r $(BasePath)\sprint08\03_incremental_procedure.sql
GO

-- Sprint 09
PRINT '';
PRINT '--- Sprint 09 ---';
:r $(BasePath)\sprint09\01_incremental_script.sql
:r $(BasePath)\sprint09\02_incremental_insert.sql
:r $(BasePath)\sprint09\03_incremental_procedure.sql
GO

-- Sprint 10
PRINT '';
PRINT '--- Sprint 10 ---';
:r $(BasePath)\sprint10\01_incremental_script.sql
:r $(BasePath)\sprint10\02_incremental_insert.sql
:r $(BasePath)\sprint10\03_incremental_procedure.sql
GO

-- Sprint 11
PRINT '';
PRINT '--- Sprint 11 ---';
:r $(BasePath)\sprint11\01_incremental_script.sql
:r $(BasePath)\sprint11\02_incremental_insert.sql
:r $(BasePath)\sprint11\03_incremental_procedure.sql
GO

-- Sprint 12
PRINT '';
PRINT '--- Sprint 12 ---';
:r $(BasePath)\sprint12\01_incremental_script.sql
:r $(BasePath)\sprint12\02_incremental_insert.sql
:r $(BasePath)\sprint12\03_incremental_procedure.sql
GO

-- Sprint 13
PRINT '';
PRINT '--- Sprint 13 ---';
:r $(BasePath)\sprint13\01_incremental_script.sql
:r $(BasePath)\sprint13\02_incremental_insert.sql
:r $(BasePath)\sprint13\03_incremental_procedure.sql
GO

-- ============================================
-- PHASE 3: Verification
-- ============================================
PRINT '';
PRINT '============================================';
PRINT '  PHASE 3: Verification';
PRINT '============================================';

PRINT '';
PRINT 'Database Statistics:';
SELECT
    'Tables' as [Object Type],
    COUNT(*) as [Count]
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
UNION ALL
SELECT
    'Stored Procedures',
    COUNT(*)
FROM INFORMATION_SCHEMA.ROUTINES
WHERE ROUTINE_TYPE = 'PROCEDURE'
UNION ALL
SELECT
    'Views',
    COUNT(*)
FROM INFORMATION_SCHEMA.VIEWS;

PRINT '';
PRINT 'Employee Data:';
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'EmployeeData')
BEGIN
    SELECT 'Total Employees' as [Metric], COUNT(*) as [Count] FROM EmployeeData;
END

IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'EmploymentDetail')
BEGIN
    SELECT 'Employment Details' as [Metric], COUNT(*) as [Count] FROM EmploymentDetail;

    PRINT '';
    PRINT 'Programmers.io Users:';
    SELECT
        ed.Id,
        ed.FirstName + ' ' + ed.LastName as [Name],
        emp.Email,
        r.Name as [Role]
    FROM EmployeeData ed
    LEFT JOIN EmploymentDetail emp ON ed.Id = emp.EmployeeId
    LEFT JOIN [Role] r ON emp.RoleId = r.Id
    WHERE emp.Email LIKE '%@programmers.io'
    ORDER BY emp.Email;
END

PRINT '';
PRINT '============================================';
PRINT '  Database Initialization Complete!';
PRINT '============================================';
PRINT '';
PRINT 'Next Steps:';
PRINT '  1. Verify test users appear in the query above';
PRINT '  2. Get plain text passwords from your team';
PRINT '  3. Start .NET backend and Vue.js frontend';
PRINT '  4. Test login at http://localhost:5173/internal-login';
GO
