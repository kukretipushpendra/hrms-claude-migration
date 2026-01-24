# HRMS Database Initialization Script
# Executes all SQL scripts in the correct order
#
# Prerequisites:
#   - SQL Server instance running (PIO-LAP-1083\SQLEXPRESS)
#   - sqlcmd utility installed (comes with SQL Server)
#   - Run as administrator if needed
#
# Usage:
#   .\init-database.ps1
#   .\init-database.ps1 -Server "YOUR_SERVER" -Database "HRMS"

param(
    [string]$Server = "PIO-LAP-1083\SQLEXPRESS",
    [string]$Database = "HRMS",
    [string]$User = "sa",
    [string]$Password = "admin",
    [switch]$SkipSprints = $false,
    [switch]$DryRun = $false
)

$ErrorActionPreference = "Stop"

# Colors for output
function Write-Step { param($msg) Write-Host "`n[$([char]0x2192)] $msg" -ForegroundColor Cyan }
function Write-Success { param($msg) Write-Host "[OK] $msg" -ForegroundColor Green }
function Write-Fail { param($msg) Write-Host "[FAIL] $msg" -ForegroundColor Red }
function Write-Info { param($msg) Write-Host "    $msg" -ForegroundColor Gray }

# Get script directory and database path
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = (Get-Item $ScriptDir).Parent.Parent.FullName
$DbPath = Join-Path $RepoRoot "legacy\Backend\HRMSWebApi\DataBase"

Write-Host "============================================" -ForegroundColor Yellow
Write-Host "  HRMS Database Initialization Script" -ForegroundColor Yellow
Write-Host "============================================" -ForegroundColor Yellow
Write-Host ""
Write-Host "Server:   $Server"
Write-Host "Database: $Database"
Write-Host "DB Path:  $DbPath"
Write-Host ""

# Verify sqlcmd is available
try {
    $null = Get-Command sqlcmd -ErrorAction Stop
    Write-Success "sqlcmd found"
} catch {
    Write-Fail "sqlcmd not found. Please install SQL Server command line utilities."
    Write-Info "Download from: https://docs.microsoft.com/en-us/sql/tools/sqlcmd-utility"
    exit 1
}

# Verify database path exists
if (-not (Test-Path $DbPath)) {
    Write-Fail "Database scripts path not found: $DbPath"
    exit 1
}

# Function to execute a SQL file
function Invoke-SqlFile {
    param(
        [string]$FilePath,
        [string]$Description
    )

    if (-not (Test-Path $FilePath)) {
        Write-Info "Skipped (file not found): $FilePath"
        return $true
    }

    $fileName = Split-Path -Leaf $FilePath
    Write-Step "$Description"
    Write-Info "File: $fileName"

    if ($DryRun) {
        Write-Info "(Dry run - skipped)"
        return $true
    }

    try {
        # Execute with sqlcmd
        # -b: Exit on error
        # -e: Echo input
        # -I: Enable quoted identifiers
        $result = sqlcmd -S $Server -d $Database -U $User -P $Password -i $FilePath -b -I 2>&1

        if ($LASTEXITCODE -ne 0) {
            Write-Fail "Error executing $fileName"
            Write-Host $result -ForegroundColor Red
            return $false
        }

        Write-Success "Completed: $fileName"
        return $true
    } catch {
        Write-Fail "Exception: $_"
        return $false
    }
}

# Create database if it doesn't exist
Write-Step "Creating database if not exists..."
if (-not $DryRun) {
    $createDbSql = @"
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = '$Database')
BEGIN
    CREATE DATABASE [$Database];
    PRINT 'Database $Database created.';
END
ELSE
BEGIN
    PRINT 'Database $Database already exists.';
END
"@

    try {
        $result = $createDbSql | sqlcmd -S $Server -U $User -P $Password -b 2>&1
        if ($LASTEXITCODE -ne 0) {
            Write-Fail "Failed to create database"
            Write-Host $result -ForegroundColor Red
            exit 1
        }
        Write-Success "Database ready"
    } catch {
        Write-Fail "Failed to connect to SQL Server: $_"
        Write-Info "Please verify:"
        Write-Info "  - SQL Server is running"
        Write-Info "  - Server name is correct: $Server"
        Write-Info "  - Credentials are correct"
        exit 1
    }
}

# Track results
$results = @()
$failed = $false

# ============================================
# PHASE 1: Core Scripts
# ============================================
Write-Host "`n" -NoNewline
Write-Host "============================================" -ForegroundColor Magenta
Write-Host "  PHASE 1: Core Database Scripts" -ForegroundColor Magenta
Write-Host "============================================" -ForegroundColor Magenta

$coreScripts = @(
    @{ Path = "01_HRMS_MasterTable_Scripts.sql"; Desc = "Creating master tables" },
    @{ Path = "02_HRMS_Table_Scripts.sql"; Desc = "Creating application tables" },
    @{ Path = "03_HRMS_MasterTable_Data.sql"; Desc = "Inserting master data (this may take a while...)" },
    @{ Path = "04_HRMS_StoreProcedure.sql"; Desc = "Creating stored procedures" }
)

foreach ($script in $coreScripts) {
    $filePath = Join-Path $DbPath $script.Path
    $success = Invoke-SqlFile -FilePath $filePath -Description $script.Desc
    $results += @{ File = $script.Path; Success = $success }
    if (-not $success) { $failed = $true }
}

# ============================================
# PHASE 2: Sprint Scripts
# ============================================
if (-not $SkipSprints -and -not $failed) {
    Write-Host "`n" -NoNewline
    Write-Host "============================================" -ForegroundColor Magenta
    Write-Host "  PHASE 2: Sprint Incremental Scripts" -ForegroundColor Magenta
    Write-Host "============================================" -ForegroundColor Magenta

    # Sprints 1-13 (note: sprint06 doesn't exist)
    $sprints = @(1, 2, 3, 4, 5, 7, 8, 9, 10, 11, 12, 13)

    foreach ($sprint in $sprints) {
        $sprintDir = Join-Path $DbPath ("sprint{0:D2}" -f $sprint)

        if (Test-Path $sprintDir) {
            Write-Host "`n--- Sprint $sprint ---" -ForegroundColor DarkCyan

            $sprintScripts = @(
                "01_incremental_script.sql",
                "02_incremental_insert.sql",
                "03_incremental_procedure.sql"
            )

            foreach ($scriptName in $sprintScripts) {
                $filePath = Join-Path $sprintDir $scriptName
                if (Test-Path $filePath) {
                    $success = Invoke-SqlFile -FilePath $filePath -Description "Sprint $sprint - $scriptName"
                    $results += @{ File = "sprint$sprint/$scriptName"; Success = $success }
                    if (-not $success) {
                        $failed = $true
                        Write-Info "Continuing despite error..."
                    }
                }
            }
        }
    }
}

# ============================================
# PHASE 3: Verification
# ============================================
Write-Host "`n" -NoNewline
Write-Host "============================================" -ForegroundColor Magenta
Write-Host "  PHASE 3: Verification" -ForegroundColor Magenta
Write-Host "============================================" -ForegroundColor Magenta

if (-not $DryRun) {
    Write-Step "Verifying database setup..."

    $verifySql = @"
SELECT
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE') as TableCount,
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = 'PROCEDURE') as ProcCount;

-- Check for employees
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'EmployeeData')
BEGIN
    SELECT 'EmployeeData count: ' + CAST(COUNT(*) AS VARCHAR) FROM EmployeeData;
END

IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'EmploymentDetail')
BEGIN
    SELECT 'EmploymentDetail count: ' + CAST(COUNT(*) AS VARCHAR) FROM EmploymentDetail;

    -- Check for test users
    SELECT 'Test users found: ' + CAST(COUNT(*) AS VARCHAR)
    FROM EmploymentDetail
    WHERE Email LIKE '%@programmers.io';
END
"@

    try {
        $verifyResult = $verifySql | sqlcmd -S $Server -d $Database -U $User -P $Password -h -1 -W 2>&1
        Write-Host $verifyResult -ForegroundColor Gray
    } catch {
        Write-Info "Verification query failed (tables may not exist yet)"
    }
}

# ============================================
# Summary
# ============================================
Write-Host "`n" -NoNewline
Write-Host "============================================" -ForegroundColor Yellow
Write-Host "  Summary" -ForegroundColor Yellow
Write-Host "============================================" -ForegroundColor Yellow

$successCount = ($results | Where-Object { $_.Success }).Count
$failCount = ($results | Where-Object { -not $_.Success }).Count

Write-Host "Total scripts: $($results.Count)"
Write-Host "Successful:    $successCount" -ForegroundColor Green
if ($failCount -gt 0) {
    Write-Host "Failed:        $failCount" -ForegroundColor Red
    Write-Host "`nFailed scripts:"
    $results | Where-Object { -not $_.Success } | ForEach-Object {
        Write-Host "  - $($_.File)" -ForegroundColor Red
    }
}

if ($failed) {
    Write-Host "`n[!] Some scripts failed. Please review errors above." -ForegroundColor Red
    exit 1
} else {
    Write-Host "`n[OK] Database initialization complete!" -ForegroundColor Green
    Write-Host "`nNext steps:" -ForegroundColor Cyan
    Write-Host "  1. Verify test users exist in the database"
    Write-Host "  2. Get plain text passwords for test users"
    Write-Host "  3. Start .NET backend: cd legacy/Backend/HRMSWebApi/HRMS.API && dotnet run"
    Write-Host "  4. Start Vue.js frontend: cd modern/frontend && npm run dev"
    Write-Host "  5. Test login at http://localhost:5173/internal-login"
    exit 0
}
