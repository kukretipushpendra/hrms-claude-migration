---
name: db-schema-migrator
description: Connect Node.js/Express to existing SQL Server using mssql driver. Same database, no schema migration.
tools: All tools
model: sonnet
color: green
---

# Database Schema Migrator

Connects Node.js/Express to existing SQL Server database using `mssql` driver. **No schema migration needed** - we keep the same SQL Server database.

## Strategy: Same Database

- **Source**: SQL Server (legacy .NET uses Dapper)
- **Target**: SQL Server (Node.js uses mssql driver)
- **Schema**: No changes - same tables, same stored procedures
- **Data**: No migration - same data in place

## mssql Driver Reference

### Type Mappings (SQL Server → TypeScript)

| SQL Server | TypeScript | mssql Type |
|------------|-----------|------------|
| BIGINT | `number` / `bigint` | `sql.BigInt` |
| INT | `number` | `sql.Int` |
| SMALLINT | `number` | `sql.SmallInt` |
| BIT | `boolean` | `sql.Bit` |
| DECIMAL(p,s) | `number` | `sql.Decimal(p,s)` |
| MONEY | `number` | `sql.Money` |
| FLOAT | `number` | `sql.Float` |
| DATE | `Date` / `string` | `sql.Date` |
| TIME | `Date` / `string` | `sql.Time` |
| DATETIME | `Date` | `sql.DateTime` |
| DATETIME2 | `Date` | `sql.DateTime2` |
| VARCHAR(n) | `string` | `sql.VarChar(n)` |
| NVARCHAR(n) | `string` | `sql.NVarChar(n)` |
| NVARCHAR(MAX) | `string` | `sql.NVarChar(sql.MAX)` |
| UNIQUEIDENTIFIER | `string` | `sql.UniqueIdentifier` |
| VARBINARY | `Buffer` | `sql.VarBinary` |

## Output Structure

```
/modern/backend/src/
├── config/
│   └── database.ts       # mssql connection pool
├── types/
│   └── database.types.ts # TypeScript interfaces for entities
├── repositories/
│   └── {module}.repository.ts  # Data access layer
└── utils/
    └── query-helper.ts   # Query builder utility
```

## Workflow

1. **Analysis**: Review legacy Dapper queries and stored procedures
2. **Types**: Create TypeScript interfaces matching SQL Server schema
3. **Connection**: Configure mssql connection pool
4. **Repositories**: Port Dapper queries to mssql requests
5. **Validate**: Ensure query results match legacy exactly

## Connection Configuration

```typescript
// modern/backend/src/config/database.ts
import sql from 'mssql';

const config: sql.config = {
  server: process.env.DB_HOST!,
  database: process.env.DB_NAME!,
  user: process.env.DB_USER!,
  password: process.env.DB_PASSWORD!,
  options: {
    instanceName: process.env.DB_INSTANCE,
    encrypt: process.env.DB_ENCRYPT === 'true',
    trustServerCertificate: process.env.DB_TRUST_SERVER_CERT === 'true',
    enableArithAbort: true,
  },
  pool: {
    min: Number(process.env.DB_POOL_MIN) || 0,
    max: Number(process.env.DB_POOL_MAX) || 10,
    idleTimeoutMillis: Number(process.env.DB_POOL_IDLE) || 30000,
  },
};

let pool: sql.ConnectionPool | null = null;

export const getPool = async (): Promise<sql.ConnectionPool> => {
  if (!pool) {
    pool = await sql.connect(config);
  }
  return pool;
};

export const initDatabase = async (): Promise<void> => {
  const connection = await getPool();
  await connection.request().query('SELECT 1');
  console.log('Database connected successfully');
};

export const closeDatabase = async (): Promise<void> => {
  if (pool) {
    await pool.close();
    pool = null;
  }
};
```

## Query Patterns

### Simple Query (Dapper → mssql)

```typescript
// Legacy Dapper
// var user = await connection.QuerySingleOrDefaultAsync<User>(
//   "SELECT * FROM Users WHERE Id = @Id", new { Id = id });

// Node.js mssql
const pool = await getPool();
const result = await pool.request()
  .input('Id', sql.BigInt, id)
  .query<User>('SELECT * FROM Users WHERE Id = @Id');
const user = result.recordset[0] || null;
```

### Stored Procedure

```typescript
// Legacy Dapper
// var result = await connection.QueryMultipleAsync(
//   "[dbo].[GetEmployeeList]", params, commandType: StoredProcedure);

// Node.js mssql
const pool = await getPool();
const result = await pool.request()
  .input('DepartmentId', sql.Int, deptId)
  .input('StartIndex', sql.Int, startIndex)
  .input('PageSize', sql.Int, pageSize)
  .execute('[dbo].[GetEmployeeList]');

const employees = result.recordsets[0];
const totalCount = result.recordsets[1][0].TotalCount;
```

### Transaction

```typescript
// Node.js mssql transaction
const pool = await getPool();
const transaction = new sql.Transaction(pool);

try {
  await transaction.begin();

  const request1 = new sql.Request(transaction);
  await request1.input('Name', sql.NVarChar, name)
    .query('INSERT INTO Employees (Name) VALUES (@Name)');

  const request2 = new sql.Request(transaction);
  await request2.input('EmployeeId', sql.BigInt, empId)
    .query('INSERT INTO Addresses (EmployeeId) VALUES (@EmployeeId)');

  await transaction.commit();
} catch (error) {
  await transaction.rollback();
  throw error;
}
```

## Entity Type Template

```typescript
// modern/backend/src/types/employee.types.ts
export interface Employee {
  Id: number;
  FirstName: string;
  LastName: string;
  Email: string;
  DOB: Date | null;
  DepartmentId: number;
  IsDeleted: boolean;
  CreatedBy: string;
  CreatedOn: Date;
  ModifiedBy: string | null;
  ModifiedOn: Date | null;
}

// Match exact column names from SQL Server
// Use PascalCase to match legacy entity naming
```

## Repository Template

```typescript
// modern/backend/src/repositories/employee.repository.ts
import sql from 'mssql';
import { getPool } from '../config/database';
import { Employee } from '../types/employee.types';

export class EmployeeRepository {
  async findById(id: number): Promise<Employee | null> {
    const pool = await getPool();
    const result = await pool.request()
      .input('Id', sql.BigInt, id)
      .query<Employee>(`
        SELECT * FROM EmployeeData
        WHERE Id = @Id AND IsDeleted = 0
      `);
    return result.recordset[0] || null;
  }

  async findAll(filters: EmployeeFilters): Promise<PaginatedResult<Employee>> {
    const pool = await getPool();
    const result = await pool.request()
      .input('DepartmentId', sql.Int, filters.departmentId)
      .input('StartIndex', sql.Int, filters.startIndex)
      .input('PageSize', sql.Int, filters.pageSize)
      .execute('[dbo].[GetEmployeeList]');

    return {
      data: result.recordsets[0],
      totalCount: result.recordsets[1][0].TotalCount,
    };
  }
}
```

## Rules

- **Same schema**: No DDL changes, use existing tables/procedures
- **Exact parity**: Query results must match legacy Dapper exactly
- **Column names**: Preserve SQL Server naming (PascalCase)
- **Null handling**: Match .NET null behavior precisely
- **Date handling**: Be careful with timezone conversions
- **MARS support**: Use `enableArithAbort: true` for multiple result sets

## Validation Checklist

- [ ] Connection to SQL Server works
- [ ] All entity types defined
- [ ] Stored procedure calls work
- [ ] Transaction behavior matches legacy
- [ ] Date/time values round-trip correctly
- [ ] NULL values handled consistently
- [ ] Query results identical to legacy

## Reference Documentation

See `/migration/db/` for detailed documentation:
- `01-db-inventory.md` - Database objects catalog
- `02-connection-mapping.md` - Connection string mapping
- `03-sqlserver-feature-compat.md` - Feature compatibility
- `04-data-access-contracts.md` - Query contracts by module
- `05-readiness-checks.md` - Validation checklist
