# Database Inventory

> **Purpose**: Comprehensive catalog of the existing SQL Server database used by the legacy .NET WebAPI.
> **Scope**: Documentation only - NO code implementation

---

## Server Information

| Property | Value |
|----------|-------|
| **Server Type** | Microsoft SQL Server Express |
| **Server Instance** | `{SERVER_NAME}\SQLEXPRESS` |
| **Database Name** | `HRMS` |
| **Authentication** | SQL Server Authentication |
| **Protocol** | TCP/IP (default port 1433) |

### Connection String (Redacted)
```
Server={SERVER_NAME}\SQLEXPRESS;Database=HRMS;User Id={USERNAME};Password={PASSWORD};MultipleActiveResultSets=true;TrustServerCertificate=True
```

---

## Feature Usage Summary

### SQL Server Features in Use

| Feature | Usage | Impact on Node.js |
|---------|-------|-------------------|
| **MARS** (Multiple Active Result Sets) | Enabled | Supported by `mssql` driver |
| **Stored Procedures** | 72 procedures | Call via `mssql` request.execute() |
| **FOR JSON PATH** | 7 instances | Supported natively |
| **OFFSET/FETCH** | Pagination | Supported natively |
| **DateOnly/TimeOnly** | Entity types | Map to DATE/TIME SQL types |
| **Transactions** | 13 repositories | `mssql` transaction API |
| **Cursors** | Batch operations | Supported in SPs |
| **Dynamic SQL** | Filter building | Supported in SPs |

### Database Objects Count

| Object Type | Count | Notes |
|-------------|-------|-------|
| **Tables** | ~50+ | Core business tables |
| **Views** | ~10+ | Reporting views (vw_*) |
| **Stored Procedures** | 72 | Complex queries, reporting |
| **Functions** | TBD | Scalar and table-valued |
| **Indexes** | TBD | Primary + secondary |

---

## Schema Overview by Module

### Core Module
- `EmployeeData` - Central employee table
- `Address` - Employee addresses
- `User` - Authentication/login
- `Role`, `Permission`, `RolePermission` - RBAC

### Leave Management
- `AppliedLeave` - Leave applications
- `LeaveType` - Leave categories
- `LeaveBalance` - Employee balances
- `LeaveAudit` - Approval history

### Attendance
- `Attendance` - Daily records
- `AttendanceConfig` - Settings
- `AttendanceAudit` - Changes log

### Asset Management
- `Asset` - Company assets
- `AssetAssignment` - Assignments
- `AssetHistory` - Tracking

### Other Modules
- `Certificate` - Employee certifications
- `Grievance` - Employee grievances
- `Survey`, `SurveyResponse` - Surveys
- `Event` - Company events
- `CompanyPolicy` - Policy documents
- `Feedback` - Performance feedback
- `KPI` - Key performance indicators
- `Notification`, `NotificationTemplate` - Messaging

---

## Connection String Components

### Legacy .NET Configuration

**File**: `appsettings.json`
```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=...;Database=HRMS;..."
  }
}
```

### Connection String Parameters

| Parameter | Value | Purpose |
|-----------|-------|---------|
| `Server` | `{SERVER}\SQLEXPRESS` | SQL Server instance |
| `Database` | `HRMS` | Database name |
| `User Id` | `{sa_or_app_user}` | SQL authentication user |
| `Password` | `{password}` | SQL authentication password |
| `MultipleActiveResultSets` | `true` | Enable MARS |
| `TrustServerCertificate` | `True` | Skip certificate validation (dev) |

### Additional Connections

| Connection | Purpose | Config Location |
|------------|---------|-----------------|
| **Serilog** | Logging to `Logging` table | `Serilog.WriteTo` section |
| **Quartz** | Job scheduler (if persisted) | `Quartz` section |

---

## Data Access Patterns Inventory

### Repository Count: 26

| Repository | Primary Table(s) | Complexity |
|------------|------------------|------------|
| AuthRepository | User, Role | Medium |
| UserProfileRepository | EmployeeData, Address | High |
| AttendanceRepository | Attendance, AttendanceConfig | High |
| LeaveManagementRepository | AppliedLeave, LeaveBalance | High |
| AssetManagementRepository | Asset, AssetAssignment | Medium |
| GrievanceRepository | Grievance | Medium |
| SurveyRepository | Survey, SurveyResponse | Medium |
| EventRepository | Event | Low |
| CertificateRepository | Certificate | Low |
| CompanyPolicyRepository | CompanyPolicy | Low |
| DashboardRepository | Multiple (aggregations) | High |
| RolePermissionRepository | Role, Permission | Medium |
| ... | ... | ... |

### Query Patterns Distribution

| Pattern | Count | Description |
|---------|-------|-------------|
| **Simple CRUD** | ~200 | Basic SELECT/INSERT/UPDATE/DELETE |
| **Complex Joins** | ~100 | Multi-table queries |
| **Stored Procedures** | ~50 | SP calls via CommandType |
| **QueryHelper** | ~30 | Fluent builder pattern |
| **JSON Subqueries** | 7 | FOR JSON PATH |
| **Aggregations** | ~20 | COUNT, SUM, GROUP BY |

---

## Environment-Specific Configurations

### Development
- **Server**: Local SQL Express instance
- **Trust Certificate**: Yes (self-signed)
- **Connection Pooling**: Default ADO.NET pooling

### Production (Expected)
- **Server**: Dedicated SQL Server instance
- **Trust Certificate**: No (valid SSL cert)
- **Connection Pooling**: Configured pool size
- **Failover**: Consider Always On or mirroring

---

## Data Volume Estimates

| Table | Estimated Rows | Growth Rate |
|-------|----------------|-------------|
| EmployeeData | 500-5000 | Low |
| Attendance | 100,000+ | High (daily) |
| AppliedLeave | 10,000+ | Medium |
| Audit Tables | 50,000+ | High |
| Logging | 100,000+ | High |

---

## Security Inventory

### Current Authentication
- **Type**: SQL Server Authentication
- **Service Account**: `sa` (development) - **CHANGE FOR PRODUCTION**
- **App-specific User**: Recommended for Node.js

### Current Permissions
- Application requires: SELECT, INSERT, UPDATE, DELETE
- Stored procedures: EXECUTE permission
- No DDL permissions expected at runtime

### Encryption
- **TLS**: `TrustServerCertificate=True` bypasses (dev only)
- **Column Encryption**: Not observed
- **Transparent Data Encryption**: TBD

---

## Dependencies and Integrations

### Internal Dependencies
- All repositories depend on `IConfiguration` for connection string
- `ConnectionStrings.DefaultConnection` constant used throughout

### External Integrations
- **Email**: SMTP settings (separate from DB)
- **Scheduled Jobs**: Quartz.NET (may have persistence table)

---

## Known Issues / Technical Debt

1. **SA Account Usage**: Development uses `sa` - security risk
2. **Trust Certificate**: Bypasses SSL validation - not for production
3. **No Connection Pool Config**: Relies on ADO.NET defaults
4. **Hardcoded Connection Name**: `DefaultConnection` referenced by constant

---

## Migration Notes for Node.js

### Driver Selection
- **Recommended**: `mssql` package (uses `tedious` under the hood)
- **Alternative**: `tedious` directly for lower-level control

### MARS Support
- `mssql` supports MARS via `options.enableArithAbort: true`
- Connection string: `multipleActiveResultSets=true` → driver option

### Connection Pooling
- `mssql` has built-in connection pooling
- Configure: `pool.max`, `pool.min`, `pool.idleTimeoutMillis`

### TypeScript Support
- Full TypeScript types available: `@types/mssql`
- Strong typing for query results

---

## Checklist Before Migration

- [ ] Document all table schemas
- [ ] Export stored procedure definitions
- [ ] Identify views and their dependencies
- [ ] Map entity types to TypeScript interfaces
- [ ] Create test dataset for validation
- [ ] Identify production connection requirements
- [ ] Plan connection string secrets management
