-- Fix Dashboard Permission Issue: "Access denied. You do not have the required permission"
-- The GetEmployeesCount endpoint requires 'Read.EmploymentDetails' permission
-- Run this script on the HRMS database to grant permissions to roles

-- Step 1: Find the Permission IDs needed for Dashboard
SELECT Id, Name, Value FROM Permission WHERE Value IN (
    'Read.EmploymentDetails',  -- Required for GetEmployeesCount
    'Read.CompanyPolicy',      -- Required for GetPublishedCompanyPolicies
    'Read.Events'              -- Required for GetUpcomingEvents
);

-- Step 2: View current roles and their IDs
SELECT Id, Name FROM Role WHERE IsActive = 1;

-- Step 3: Check which roles already have the permission
SELECT r.Name AS RoleName, p.Value AS Permission, rp.IsActive
FROM RolePermission rp
JOIN Role r ON r.Id = rp.RoleId
JOIN Permission p ON p.Id = rp.PermissionId
WHERE p.Value = 'Read.EmploymentDetails';

-- Step 4: Grant Read.EmploymentDetails to SuperAdmin role (RoleId = 1, adjust if different)
-- First, get the permission ID
DECLARE @PermissionId INT;
SELECT @PermissionId = Id FROM Permission WHERE Value = 'Read.EmploymentDetails';

-- Check if it exists already for SuperAdmin (assuming RoleId = 1)
IF NOT EXISTS (SELECT 1 FROM RolePermission WHERE RoleId = 1 AND PermissionId = @PermissionId)
BEGIN
    INSERT INTO RolePermission (RoleId, PermissionId, IsActive, CreatedOn, IsDeleted)
    VALUES (1, @PermissionId, 1, GETUTCDATE(), 0);
    PRINT 'Permission added to SuperAdmin role';
END
ELSE
BEGIN
    -- Ensure it's active
    UPDATE RolePermission SET IsActive = 1 WHERE RoleId = 1 AND PermissionId = @PermissionId;
    PRINT 'Permission already exists, ensured IsActive = 1';
END

-- Step 5: Grant to HR role as well (RoleId = 2, adjust if different)
IF NOT EXISTS (SELECT 1 FROM RolePermission WHERE RoleId = 2 AND PermissionId = @PermissionId)
BEGIN
    INSERT INTO RolePermission (RoleId, PermissionId, IsActive, CreatedOn, IsDeleted)
    VALUES (2, @PermissionId, 1, GETUTCDATE(), 0);
    PRINT 'Permission added to HR role';
END
ELSE
BEGIN
    UPDATE RolePermission SET IsActive = 1 WHERE RoleId = 2 AND PermissionId = @PermissionId;
    PRINT 'Permission already exists for HR, ensured IsActive = 1';
END

-- Step 6: Verify the permissions are now assigned
SELECT r.Name AS RoleName, p.Name AS PermissionName, p.Value, rp.IsActive
FROM RolePermission rp
JOIN Role r ON r.Id = rp.RoleId
JOIN Permission p ON p.Id = rp.PermissionId
WHERE p.Value = 'Read.EmploymentDetails'
ORDER BY r.Name;

-- IMPORTANT: After running this script, the user must LOG OUT and LOG IN again
-- to get a new JWT token with the updated permissions!
