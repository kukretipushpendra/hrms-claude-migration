# SQL Server Feature Compatibility for Node.js

> **Purpose**: Document SQL Server features used by legacy and their compatibility with Node.js
> **Scope**: Documentation only - NO code implementation

---

## Overview

The legacy .NET application uses various SQL Server features. This document maps each feature to its Node.js/mssql driver equivalent.

---

## Feature Compatibility Matrix

| SQL Server Feature | Legacy Usage | Node.js mssql Support | Notes |
|-------------------|--------------|----------------------|-------|
| **MARS** | Enabled | ✅ Full | `options.enableArithAbort: true` |
| **Stored Procedures** | 72 SPs | ✅ Full | `request.execute()` |
| **Output Parameters** | SP returns | ✅ Full | `request.output()` |
| **Multiple Result Sets** | SP returns | ✅ Full | `recordsets` array |
| **Transactions** | 13 repos | ✅ Full | `transaction.begin/commit/rollback` |
| **FOR JSON PATH** | 7 instances | ✅ Native SQL | Returns JSON string in result |
| **OFFSET/FETCH** | Pagination | ✅ Native SQL | No driver involvement |
| **Parameterized Queries** | All queries | ✅ Full | `request.input()` |
| **Connection Pooling** | ADO.NET default | ✅ Built-in | `pool` config options |
| **Named Instances** | SQLEXPRESS | ✅ Full | `options.instanceName` |
| **Windows Auth** | Not used | ✅ Supported | `options.trustedConnection` |
| **SQL Auth** | Used | ✅ Full | `user/password` config |
| **Bulk Insert** | Not observed | ✅ Available | `table.create()` + bulk |
| **TVPs** | Not observed | ✅ Available | Table-valued parameters |

---

## MARS (Multiple Active Result Sets)

### Legacy Usage
```csharp
// Connection string
"MultipleActiveResultSets=true"

// Used with stored procedures returning multiple datasets
using var result = await connection.QueryMultipleAsync(spName, params);
var data = result.Read<T>();
var count = result.ReadSingle<int>();
```

### Node.js Configuration
```typescript
// mssql config
{
  options: {
    enableArithAbort: true  // Required for MARS-like behavior
  }
}
```

### Compatibility Notes
- mssql driver handles multiple result sets automatically
- Access via `result.recordsets[0]`, `result.recordsets[1]`, etc.
- No special connection string option needed

---

## Stored Procedures

### Legacy Usage Count: 72 procedures

### Call Patterns

| Pattern | Legacy (.NET) | Node.js (mssql) |
|---------|---------------|-----------------|
| Simple call | `QueryAsync(spName, params, commandType: StoredProcedure)` | `request.execute(spName)` |
| With output | `output.Get<T>("param")` | `result.output.paramName` |
| Multiple results | `QueryMultipleAsync` | `result.recordsets[]` |
| Return value | `output.Get<int>("return_value")` | `result.returnValue` |

### Key Stored Procedures

| SP Name | Purpose | Result Sets | Node.js Approach |
|---------|---------|-------------|------------------|
| `GetAttendanceConfigList` | Paginated list | 2 (count + data) | `recordsets[0]` count, `[1]` data |
| `GetEmployeeAttendanceReport` | Report generation | 1+ | Map recordsets |
| `CreditMonthlyLeaveBalance` | Batch processing | 0 (action) | `result.rowsAffected` |

### Documentation: SP Input Parameters
```typescript
// Input parameter mapping
interface GetAttendanceConfigParams {
  EmployeeName: string | null;
  DepartmentId: number | null;
  SortColumn: string;
  SortDirection: string;
  StartIndex: number;
  PageSize: number;
}
```

---

## Transactions

### Legacy Patterns

#### 1. IDbConnection.BeginTransaction
```csharp
using (var transaction = connection.BeginTransaction())
{
    await connection.ExecuteAsync(sql1, params1, transaction);
    await connection.ExecuteAsync(sql2, params2, transaction);
    transaction.Commit();
}
```

#### 2. TransactionScope (Distributed)
```csharp
using (var scope = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
{
    // Operations
    scope.Complete();
}
```

### Node.js Equivalents

| .NET Pattern | mssql Equivalent | Notes |
|--------------|------------------|-------|
| `BeginTransaction` | `new sql.Transaction()` | Explicit transaction |
| `transaction.Commit()` | `transaction.commit()` | |
| `transaction.Rollback()` | `transaction.rollback()` | |
| `TransactionScope` | Not supported | Use explicit transactions |

### Transaction Isolation Levels
```typescript
// Available levels in mssql
sql.ISOLATION_LEVEL.READ_UNCOMMITTED
sql.ISOLATION_LEVEL.READ_COMMITTED
sql.ISOLATION_LEVEL.REPEATABLE_READ
sql.ISOLATION_LEVEL.SERIALIZABLE
sql.ISOLATION_LEVEL.SNAPSHOT
```

---

## JSON Functions

### Legacy Usage: FOR JSON PATH
```sql
SELECT
    ED.Id, ED.FirstName,
    (SELECT Ad.Id, Ad.Line1
     FROM Address AS Ad
     WHERE Ad.EmployeeId = ED.Id
     FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) AS AddressJson
FROM EmployeeData AS ED
```

### Node.js Handling
- Query returns JSON as string column
- Parse in application: `JSON.parse(row.AddressJson)`
- No special driver configuration needed

### Compatibility Notes
- `FOR JSON PATH` - ✅ Fully supported
- `FOR JSON AUTO` - ✅ Fully supported
- `OPENJSON` - ✅ Fully supported
- Returns `null` for empty results (handle accordingly)

---

## Data Types Mapping

### SQL Server → TypeScript

| SQL Server Type | TypeScript Type | mssql Type Constant |
|-----------------|-----------------|---------------------|
| `BIGINT` | `number` / `bigint` | `sql.BigInt` |
| `INT` | `number` | `sql.Int` |
| `SMALLINT` | `number` | `sql.SmallInt` |
| `TINYINT` | `number` | `sql.TinyInt` |
| `BIT` | `boolean` | `sql.Bit` |
| `DECIMAL(p,s)` | `number` | `sql.Decimal(p,s)` |
| `MONEY` | `number` | `sql.Money` |
| `FLOAT` | `number` | `sql.Float` |
| `REAL` | `number` | `sql.Real` |
| `DATE` | `Date` / `string` | `sql.Date` |
| `TIME` | `Date` / `string` | `sql.Time` |
| `DATETIME` | `Date` | `sql.DateTime` |
| `DATETIME2` | `Date` | `sql.DateTime2` |
| `VARCHAR(n)` | `string` | `sql.VarChar(n)` |
| `NVARCHAR(n)` | `string` | `sql.NVarChar(n)` |
| `NVARCHAR(MAX)` | `string` | `sql.NVarChar(sql.MAX)` |
| `TEXT` | `string` | `sql.Text` |
| `UNIQUEIDENTIFIER` | `string` | `sql.UniqueIdentifier` |
| `VARBINARY` | `Buffer` | `sql.VarBinary` |
| `XML` | `string` | `sql.Xml` |

### Special Type Handling

#### DateOnly (.NET 6+)
```typescript
// .NET DateOnly maps to SQL DATE
// In Node.js, receive as Date object or string
// Handle timezone carefully
const dateOnly = result.recordset[0].DOB; // Date object
const dateString = dateOnly.toISOString().split('T')[0]; // "2000-01-15"
```

#### TimeOnly (.NET 6+)
```typescript
// .NET TimeOnly maps to SQL TIME
// In Node.js, receive as Date object with time portion
const timeOnly = result.recordset[0].ShiftStart;
const timeString = timeOnly.toISOString().split('T')[1].substring(0, 8); // "09:00:00"
```

---

## Pagination

### Legacy Pattern: OFFSET/FETCH
```sql
SELECT * FROM Employees
ORDER BY CreatedOn DESC
OFFSET @StartIndex ROWS
FETCH NEXT @PageSize ROWS ONLY
```

### Node.js Implementation Notes
- Raw SQL works identically
- Sequelize: Use `limit` and `offset` options
- Always pair with `ORDER BY` clause

---

## Dynamic SQL

### Legacy Patterns

#### QueryHelper (Safe)
```csharp
var query = new QueryHelper("SELECT *")
    .FromTables("Employees")
    .Where(q => q.AndNullOrEqual("DeptId", deptId))
    .OrderByColumnOrOne(sortCol, sortDir);
```

#### String Building (Risky)
```csharp
var sql = "SELECT * FROM Employees WHERE 1=1";
if (name != null) sql += " AND Name LIKE @Name";
```

### Node.js Alternatives
1. **Query Builder**: Knex.js or Sequelize
2. **Raw SQL with Params**: Safe parameterization
3. **Dynamic WHERE**: Build conditions array

### Security Notes
- NEVER concatenate user input directly
- Always use parameterized queries
- Validate column names against whitelist

---

## Error Handling

### SQL Server Error Codes

| Error Code | Description | Node.js Detection |
|------------|-------------|-------------------|
| 2627 | Unique constraint violation | `err.number === 2627` |
| 547 | Foreign key violation | `err.number === 547` |
| 2601 | Duplicate key | `err.number === 2601` |
| 515 | Cannot insert NULL | `err.number === 515` |
| 8152 | String truncation | `err.number === 8152` |

### mssql Error Structure
```typescript
interface MSSQLError {
  message: string;
  code: string;
  number: number;    // SQL error number
  state: number;
  class: number;
  serverName: string;
  procName: string;  // SP name if in SP
  lineNumber: number;
}
```

---

## Connection Pooling

### Legacy: ADO.NET Default Pooling
- Automatic, transparent
- Default max: 100 connections
- Min: 0 connections

### Node.js mssql Pooling
```typescript
// Configuration options
{
  pool: {
    max: 10,           // Maximum connections
    min: 0,            // Minimum connections
    idleTimeoutMillis: 30000,  // Close idle after 30s
    acquireTimeoutMillis: 15000 // Acquisition timeout
  }
}
```

### Monitoring Pool Health
```typescript
// Access pool stats (documentation)
const pool = await sql.connect(config);
console.log('Pool size:', pool.pool.size);
console.log('Available:', pool.pool.available);
console.log('Pending:', pool.pool.pending);
```

---

## Unsupported/Limited Features

| Feature | Status | Alternative |
|---------|--------|-------------|
| Distributed Transactions (DTC) | ❌ Not supported | Application-level saga pattern |
| Always Encrypted | ⚠️ Limited | Configure driver options |
| Column Encryption | ⚠️ Limited | Use enclave-enabled driver |
| SQL CLR | N/A | Not used in legacy |
| FileStream | N/A | Not used in legacy |
| In-Memory OLTP | N/A | Not used in legacy |

---

## Performance Considerations

### Query Execution

| Aspect | Recommendation |
|--------|----------------|
| Connection reuse | Use pool (don't create new connections) |
| Batch operations | Use transactions for multiple writes |
| Large result sets | Stream or paginate |
| Long-running queries | Set appropriate `requestTimeout` |

### Indexing
- Ensure indexes exist for common WHERE clauses
- Node.js queries should use same patterns as .NET
- Monitor execution plans remain optimal

---

## Testing Strategy

### Connection Tests
- [ ] Connect to SQL Server instance
- [ ] Authenticate with SQL auth
- [ ] Execute simple query
- [ ] Call stored procedure
- [ ] Handle multiple result sets
- [ ] Transaction commit/rollback

### Data Type Tests
- [ ] All numeric types
- [ ] Date/Time types
- [ ] String types (VARCHAR, NVARCHAR)
- [ ] Binary types
- [ ] NULL handling

### Feature Tests
- [ ] Pagination with OFFSET/FETCH
- [ ] FOR JSON PATH results
- [ ] Dynamic SQL with parameters
- [ ] Error code detection
- [ ] Pool exhaustion behavior
