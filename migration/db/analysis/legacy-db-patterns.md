# Legacy Database Access Patterns Analysis

## Overview

The legacy .NET backend uses **Dapper** as the primary ORM for database access with **Microsoft SQL Server**. The architecture follows a repository pattern with manual SQL query construction.

## Database Technology Stack

- **Database**: Microsoft SQL Server
- **ORM/Data Access**: Dapper (micro-ORM)
- **Connection Library**: Microsoft.Data.SqlClient
- **Connection String Feature**: MultipleActiveResultSets (MARS) enabled
- **Trust Configuration**: TrustServerCertificate=True

## Connection Management

### Connection String Configuration
- Location: `appsettings.json` → `ConnectionStrings.DefaultConnection`
- Pattern: SQL Server authentication (User Id/Password)
- MARS: Enabled (`MultipleActiveResultSets=true`)
- Example: `Server=PIO-LAP-1083\\SQLEXPRESS;Database=HRMS;User Id=sa;Password=admin;MultipleActiveResultSets=true;TrustServerCertificate=True`

### Connection Pattern
```csharp
// Standard pattern across all repositories
using (IDbConnection connection = new SqlConnection(_configuration.GetConnectionString(ConnectionStrings.DefaultConnection)))
{
    connection.Open();
    // Execute queries
}
```

**Key Characteristics:**
- Manual connection creation and disposal (using statements)
- Configuration injected via `IConfiguration`
- Constant reference: `HRMS.Domain.Contants.ConnectionStrings.DefaultConnection`
- No connection pooling management (relies on default ADO.NET pooling)

## Repository Architecture

### Repository Count & Structure
- **Total Repositories**: 26 concrete implementations
- **Interface Repositories**: 28 interfaces
- **Total Code Lines**: ~10,755 lines across all repositories
- **Location**: `HRMS.Infrastructure/Repositories/`

### Repository List
1. AdminExitEmployeeRepository
2. AssetManagementRepository
3. AttendanceRepository
4. AuthRepository
5. CertificateRepository
6. CompanyPolicyRepository
7. DashboardRepository
8. DevToolRepository
9. DowntownDataSyncRepository
10. EducationalDetailRepository
11. EmailNotificationRepository
12. EmployeeGroupRepository
13. EmploymentDetailRepository
14. EventRepository
15. ExitEmployeeRepository
16. FeedbackRepository
17. GrievanceRepository
18. KPIRepository
19. LeaveManagementRepository
20. NomineeRepository
21. NotificationTemplateRepository
22. PreviousEmployerRepository
23. ProfessionalReferenceRepository
24. RolePermissionRepository
25. SurveyRepository
26. UserGuideRepository
27. UserProfileRepository

### Generic Repository Interface
- Interface: `IGenericRepository<T>`
- Provides: Basic CRUD operations
- Most repositories implement specific interfaces, not generic

## Dapper Query Patterns

### Query Method Distribution
Total Dapper operations across repositories: **383 occurrences**

**Common Methods Used:**
1. `QueryAsync<T>` - Select queries returning collections
2. `QuerySingleOrDefaultAsync<T>` - Single record queries
3. `QueryFirstOrDefaultAsync<T>` - First record queries
4. `ExecuteAsync` - INSERT/UPDATE/DELETE operations
5. `ExecuteScalarAsync<T>` - Scalar value queries (COUNT, SUM, etc.)
6. `QueryMultipleAsync` - Multiple result sets (used with stored procedures)

### Query Construction Patterns

#### 1. Inline SQL Queries (Most Common)
```csharp
var sql = "SELECT * FROM EmployeeData WHERE Id = @Id";
var result = await connection.QuerySingleOrDefaultAsync<EmployeeData>(sql, new { Id = id });
```

#### 2. QueryHelper Pattern (Custom Fluent Builder)
Location: `HRMS.Domain.Utility.QueryHelper`

Features:
- Fluent API for query building
- Parameterized queries via Dapper `DynamicParameters`
- Conditional WHERE clauses
- Sorting with column whitelisting
- Pagination support (OFFSET/FETCH)
- Prevents SQL injection

Example Usage:
```csharp
var query = new QueryHelper(@"SELECT EmployeeId, EmployeeCode, EmployeeFullName, OfficeEmail")
    .FromTables("vw_EmployeeData ED")
    .Where(q => q
        .AndNullOrLike("ED.[EmployeeFullname]", requestDto.Filters.EmployeeName)
        .AndNullOrEqual("EmployeeCode", requestDto.Filters.EmployeeCode)
        .AndNullOrEqual("IsManualAttendance", requestDto.Filters.IsManualAttendance)
    )
    .AllowSortingForTypeFields<AttendancConfigDto>()
    .OrderByColumnOrOne(requestDto.SortColumnName, requestDto.SortDirection)
    .PagingOrNull(requestDto.StartIndex, requestDto.PageSize);
```

#### 3. JSON Subqueries (FOR JSON PATH)
Used in complex queries to return nested data structures

Occurrences: **7 instances** across 4 repositories

Example:
```sql
SELECT
    ED.Id, ED.FirstName,
    (SELECT Ad.Id, Ad.Line1, C.CountryName
     FROM Address AS Ad
     WHERE Ad.EmployeeId = ED.Id
     FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) AS AddressJson
FROM EmployeeData AS ED
```

Pattern: Deserialize JSON strings in C# using `JsonConvert.DeserializeObject`

#### 4. Dynamic SQL Building
Used for complex filtering scenarios

Example from CompanyPolicyRepository:
```csharp
var conditions = "";
if (!string.IsNullOrEmpty(policyName))
    conditions += " AND Name LIKE '%' + @PolicyName + '%'";
if (statusId != 0)
    conditions += " AND StatusId = @StatusId";
```

## Transaction Management

### Transaction Repositories: 13 repositories use transactions

**Transaction Patterns:**

#### 1. Standard IDbConnection.BeginTransaction
```csharp
using (IDbConnection connection = new SqlConnection(connectionString))
{
    connection.Open();
    using (var transaction = connection.BeginTransaction())
    {
        try
        {
            // Multiple operations
            await connection.ExecuteAsync(sql1, params1, transaction);
            await connection.ExecuteAsync(sql2, params2, transaction);
            transaction.Commit();
        }
        catch
        {
            transaction.Rollback();
            throw;
        }
    }
}
```

#### 2. TransactionScope (Distributed Transactions)
Found in: LeaveManagementRepository

```csharp
using (var scope = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
{
    // Operations
    scope.Complete();
}
```

**Common Transaction Use Cases:**
- Multi-table inserts (Employee + Address + Employment details)
- Parent-child records (Attendance + AttendanceAudit)
- Leave applications with balance updates
- Asset assignments with history tracking

## Stored Procedures

### Stored Procedure Statistics
- **Total Stored Procedures**: 72 procedures across database scripts
- **SQL Script Files**: 40 files
- **Primary File**: `04_HRMS_StoreProcedure.sql` (26 procedures)
- **Sprint Incremental Procedures**: Distributed across sprint folders

### Stored Procedure Usage Pattern
Called via Dapper with `CommandType.StoredProcedure`:

```csharp
using var result = await connection.QueryMultipleAsync(
    "[dbo].[GetAttendanceConfigList]",
    new {
        EmployeeName = filters.EmployeeName,
        DepartmentId = filters.DepartmentId,
        SortColumn = sortColumnName,
        StartIndex = startIndex,
        PageSize = pageSize
    },
    commandType: CommandType.StoredProcedure
);
```

### Key Stored Procedures Identified

1. **GetAttendanceConfigList** - Attendance configuration with filtering/sorting/paging
2. **GetEmployeeAttendanceReport** - Employee attendance report generation
3. **GetEmployeeGrievances** - Grievance listing with filters
4. **GetCompanyPolicyDocuments** - Policy document search
5. **GetRoleListWithUserCount** - Role management
6. **CreditMonthlyLeaveBalance** - Leave balance accrual (uses cursor)
7. Various search/filter procedures with dynamic sorting and pagination

### Stored Procedure Characteristics
- **Multiple Result Sets**: Return count + data (uses `QueryMultipleAsync`)
- **Dynamic SQL**: Build queries based on parameters
- **Pagination**: OFFSET/FETCH NEXT pattern
- **Sorting**: Dynamic ORDER BY with column names
- **Cursors**: Used in batch operations (leave accrual)

## Entity/Model Structure

### Entity Count
- **Total Entities**: 72 entity classes
- **Location**: `HRMS.Domain/Entities/`
- **Base Class**: `BaseEntity` (provides Id, audit fields, soft delete)

### BaseEntity Pattern
```csharp
public class BaseEntity
{
    public long Id { get; set; }
    public string CreatedBy { get; set; }
    public DateTime CreatedOn { get; set; }
    public string? ModifiedBy { get; set; }
    public DateTime? ModifiedOn { get; set; }
    public bool IsDeleted { get; set; }
}
```

**Key Characteristics:**
- Long integer primary keys
- Audit trail (Created/Modified By/On)
- Soft delete support (`IsDeleted`)
- UTC timestamps preferred

### Sample Entities

#### EmployeeData (Core Entity)
```csharp
public class EmployeeData : BaseEntity
{
    public string FirstName { get; set; }
    public string LastName { get; set; }
    public Gender Gender { get; set; }
    public DateOnly? DOB { get; set; }
    public string Phone { get; set; }
    public string PersonalEmail { get; set; }
    public MaritalStatus MaritalStatus { get; set; }
    public string PANNumber { get; set; }
    public string EmployeeCode { get; set; }
    // ... 30+ properties
}
```

#### AppliedLeave
```csharp
public class AppliedLeave : BaseEntity
{
    public long EmployeeId { get; set; }
    public int LeaveId { get; set; }
    public long? ReportingManagerId { get; set; }
    public LeaveStatus Status { get; set; }
    public DateOnly StartDate { get; set; }
    public DateOnly EndDate { get; set; }
    public decimal TotalLeaveDays { get; set; }
}
```

#### Address
```csharp
public class Address
{
    public long Id { get; set; }
    public long EmployeeId { get; set; }
    public string Line1 { get; set; }
    public long CityId { get; set; }
    public int CountryId { get; set; }
    public int StateId { get; set; }
    public AddressType AddressType { get; set; }
    public DateTime CreatedOn { get; set; }
    // Does NOT extend BaseEntity
}
```

### Entity Patterns
- **DateOnly/TimeOnly**: .NET 6+ date/time types used
- **Enums**: Strongly typed (Gender, LeaveStatus, MaritalStatus, etc.)
- **Foreign Keys**: Numeric IDs (not navigation properties)
- **Nullable Types**: Used for optional fields
- **Relationships**: Not mapped (manual joins in queries)

### Custom Type Handlers
```csharp
SqlMapper.AddTypeHandler(new SqlDateOnlyTypeHandler());
SqlMapper.AddTypeHandler(new SqlTimeOnlyTypeHandler());
```
Required for mapping SQL Server date/time to .NET DateOnly/TimeOnly types

## SQL-Specific Features

### 1. Multiple Active Result Sets (MARS)
- **Enabled**: Yes (`MultipleActiveResultSets=true`)
- **Usage**: Allows multiple result sets on single connection
- **Impact**: Used with stored procedures returning multiple datasets

### 2. Pagination Pattern
SQL Server 2012+ OFFSET/FETCH syntax:
```sql
ORDER BY CreatedOn DESC
OFFSET @StartIndex ROWS
FETCH NEXT @PageSize ROWS ONLY
```

Occurrences: **7+ instances** across repositories

### 3. JSON Functions
- `FOR JSON PATH` - Convert query results to JSON
- `FOR JSON AUTO` - Automatic JSON structure
- Used for nested/hierarchical data structures

### 4. Window Functions & CTEs
- Subqueries with TOP 1 ORDER BY DESC (latest record pattern)
- Scalar subqueries for computed columns
- COALESCE for default values

### 5. Date/Time Functions
- `GETUTCDATE()` - UTC timestamp
- Date formatting: `CONVERT(varchar, [Time], 120)`
- Date part extraction: `YEAR()`, `MONTH()`, `DAY()`

### 6. Dynamic SQL in Stored Procedures
```sql
DECLARE @Query VARCHAR(MAX) = 'SELECT ...'
SET @Query += ' WHERE ...'
EXEC(@Query)
```

### 7. Cursors
Used in `CreditMonthlyLeaveBalance` for batch processing employee leave balances

## Data Type Mapping

### Common Mappings
- `BIGINT` → `long` (primary keys, foreign keys)
- `INT` → `int`
- `VARCHAR/NVARCHAR` → `string`
- `DATE` → `DateOnly` (with custom type handler)
- `TIME` → `TimeOnly` (with custom type handler)
- `DATETIME/DATETIME2` → `DateTime`
- `DECIMAL(18,2)` → `decimal`
- `BIT` → `bool`

## Query Complexity Analysis

### Simple CRUD Queries
- Direct SELECT/INSERT/UPDATE/DELETE
- Single table operations
- Parameterized with anonymous objects

### Complex Queries
- **Multi-table JOINs**: 3-5 tables common
- **Subqueries**: Nested SELECT for computed columns
- **Conditional Filtering**: QueryHelper pattern
- **Dynamic Sorting**: Column name validation
- **JSON Serialization**: Nested data structures
- **Aggregate Functions**: COUNT, SUM with GROUP BY

### Performance Patterns
- **Pagination**: Server-side (OFFSET/FETCH)
- **Projection**: Select specific columns (not SELECT *)
- **Indexing hints**: None observed (relies on database indexes)
- **Query caching**: Not implemented (Dapper doesn't cache)

## Security Patterns

### SQL Injection Prevention
- **Parameterized Queries**: All queries use `@Parameter` syntax
- **Dapper Parameters**: Anonymous objects or `DynamicParameters`
- **QueryHelper**: Automatically parameterizes values
- **No String Concatenation**: User input never concatenated into SQL

### Validation
- **Column Whitelisting**: QueryHelper validates sortable columns
- **Enum Validation**: Strongly typed enums prevent invalid values
- **Null Checks**: Conditional query building

## Migration Considerations

### Challenges for PostgreSQL/Sequelize Migration

1. **DateOnly/TimeOnly Types**
   - PostgreSQL: Use `DATE` and `TIME` types
   - Sequelize: Map to `DataTypes.DATEONLY` and `DataTypes.TIME`

2. **MARS (Multiple Active Result Sets)**
   - Not needed in PostgreSQL
   - Remove from connection strings

3. **FOR JSON PATH**
   - PostgreSQL: Use `json_agg()` and `row_to_json()`
   - Sequelize: Use separate queries + JavaScript composition

4. **OFFSET/FETCH**
   - PostgreSQL: `LIMIT/OFFSET` syntax
   - Sequelize: `limit` and `offset` options

5. **Stored Procedures**
   - Rewrite as PostgreSQL functions
   - Or convert to application-level queries (Sequelize)
   - Cursor-based procedures → Application loops

6. **GETUTCDATE()**
   - PostgreSQL: `NOW() AT TIME ZONE 'UTC'`
   - Sequelize: `sequelize.fn('NOW')`

7. **Dynamic SQL in SPs**
   - Convert to Sequelize query builder
   - Use dynamic where conditions

8. **String Concatenation**
   - SQL Server: `+` operator
   - PostgreSQL: `||` operator or `CONCAT()`

9. **CONVERT/CAST Functions**
   - PostgreSQL: Different syntax (`::type` or `CAST()`)

10. **Transaction Scope**
    - Sequelize: Use `sequelize.transaction()`
    - Distributed transactions not supported

### Recommended Migration Strategy

1. **Phase 1**: Convert simple repositories (CRUD only)
2. **Phase 2**: Convert QueryHelper to Sequelize query builder
3. **Phase 3**: Rewrite stored procedures as queries or functions
4. **Phase 4**: Handle complex JSON serialization patterns
5. **Phase 5**: Migrate transaction-heavy repositories

### Sequelize Equivalent Patterns

**Connection Management:**
```javascript
// Sequelize handles connection pooling automatically
const sequelize = new Sequelize(DATABASE_URL, {
  dialect: 'postgres',
  pool: { max: 10, min: 0, idle: 10000 }
});
```

**Simple Query:**
```javascript
// Dapper: QuerySingleOrDefaultAsync
const user = await User.findByPk(id);

// Dapper: QueryAsync
const users = await User.findAll({ where: { isDeleted: false } });
```

**Transaction:**
```javascript
await sequelize.transaction(async (t) => {
  await User.create({ name: 'John' }, { transaction: t });
  await Address.create({ userId: 1, line1: 'Street' }, { transaction: t });
});
```

**Pagination:**
```javascript
const { count, rows } = await User.findAndCountAll({
  limit: pageSize,
  offset: startIndex,
  order: [[sortColumn, sortDirection]]
});
```

**Complex Query (Raw SQL when needed):**
```javascript
const [results] = await sequelize.query(
  'SELECT * FROM users WHERE name = :name',
  { replacements: { name: 'John' }, type: QueryTypes.SELECT }
);
```

## Summary Statistics

| Category | Count | Notes |
|----------|-------|-------|
| **Repositories** | 26 | Concrete implementations |
| **Repository Interfaces** | 28 | Including generic |
| **Total Repository Lines** | 10,755 | All .cs files combined |
| **Entity Classes** | 72 | Domain entities |
| **Dapper Query Operations** | 383 | Across all repositories |
| **Stored Procedures** | 72 | Across sprint scripts |
| **SQL Script Files** | 40 | Database schema/procedures |
| **Repositories Using Transactions** | 13 | Manual transaction management |
| **Repositories Using SPs** | 10+ | CommandType.StoredProcedure |
| **JSON Subquery Usage** | 7 | FOR JSON PATH pattern |
| **Pagination Implementations** | 7+ | OFFSET/FETCH pattern |

## Key Findings

1. **Pure Dapper**: No EF Core, Entity Framework, or other ORMs
2. **Manual SQL**: Most queries are hand-written SQL strings
3. **Repository Pattern**: Consistent across all modules
4. **No Navigation Properties**: Entities don't have relationship mappings
5. **QueryHelper Utility**: Custom fluent builder for safe dynamic queries
6. **Stored Procedures**: Significant use for complex reporting/filtering
7. **Transaction Management**: Manual with `BeginTransaction()`
8. **Audit Trail**: Consistent CreatedBy/ModifiedBy pattern
9. **Soft Delete**: `IsDeleted` flag pattern throughout
10. **UTC Timestamps**: `GETUTCDATE()` used consistently

## Recommendations for Modern Stack

1. **Sequelize Models**: Map each entity to a Sequelize model
2. **Associations**: Define relationships (hasMany, belongsTo, etc.)
3. **Query Builder**: Replace QueryHelper with Sequelize query builder
4. **Hooks**: Use Sequelize hooks for audit trail (beforeCreate, beforeUpdate)
5. **Paranoid Mode**: Enable `paranoid: true` for soft deletes
6. **Migrations**: Create Sequelize migrations from SQL scripts
7. **Raw Queries**: Use for complex reporting that doesn't fit ORM pattern
8. **Transactions**: Leverage Sequelize transaction API
9. **Validation**: Add model-level validation (Sequelize validators)
10. **Seeders**: Convert SQL seed data to Sequelize seeders
