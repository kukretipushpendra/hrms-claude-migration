# ADR-001: Database Connection Strategy

> **Status**: Proposed
> **Date**: 2024-XX-XX
> **Decision Makers**: [TBD]

---

## Context

The legacy HRMS application uses .NET with Dapper to connect to SQL Server. The modern Node.js/TypeScript backend must connect to the **same SQL Server database** to maintain data continuity during migration.

### Current State
- **Database**: Microsoft SQL Server Express
- **ORM**: Dapper (micro-ORM with raw SQL)
- **Connection Pattern**: ADO.NET with automatic pooling
- **Features Used**: MARS, Stored Procedures, Transactions

### Requirements
1. Connect to existing SQL Server database
2. Support all SQL Server features used by legacy
3. TypeScript type safety
4. Connection pooling for performance
5. Transaction support

---

## Decision

### Selected Driver: `mssql` (node-mssql)

**Package**: `mssql` (uses `tedious` driver internally)

### Rationale

| Criteria | mssql | tedious (direct) | Sequelize |
|----------|-------|------------------|-----------|
| SQL Server support | ✅ Full | ✅ Full | ✅ Full |
| TypeScript types | ✅ Excellent | ⚠️ Basic | ✅ Good |
| Connection pooling | ✅ Built-in | ❌ Manual | ✅ Built-in |
| Stored procedures | ✅ Native | ✅ Native | ⚠️ Raw query |
| Multiple result sets | ✅ Native | ✅ Native | ⚠️ Raw query |
| Learning curve | Low | Medium | Medium |
| Raw SQL support | ✅ Full | ✅ Full | ✅ Full |
| Community/Support | ✅ Active | ✅ Active | ✅ Very Active |

### Why `mssql` over alternatives:

1. **Best match for Dapper migration**: Both use raw SQL, minimal learning curve
2. **Built-in pooling**: No additional configuration needed
3. **Full feature support**: MARS, SPs, transactions all work out-of-box
4. **TypeScript-first**: Excellent type definitions
5. **Active maintenance**: Regular updates, good community

### Why NOT Sequelize (initially):

1. Legacy uses raw SQL via Dapper - maintaining parity is easier with raw SQL
2. 72 stored procedures would need raw query calls anyway
3. QueryHelper patterns translate better to parameterized raw SQL
4. ORM abstraction could introduce subtle behavior differences

> **Note**: Sequelize can be introduced later for new features or gradual migration of simple CRUD operations.

---

## Connection Configuration

### Configuration Structure (Documentation Only)

```typescript
// Type definition for configuration
interface DatabaseConfig {
  server: string;
  port?: number;
  database: string;
  user: string;
  password: string;
  options: {
    instanceName?: string;
    encrypt: boolean;
    trustServerCertificate: boolean;
    enableArithAbort: boolean;
    connectTimeout: number;
    requestTimeout: number;
  };
  pool: {
    min: number;
    max: number;
    idleTimeoutMillis: number;
    acquireTimeoutMillis: number;
  };
}
```

### Environment-Based Configuration

| Environment | Encryption | Trust Cert | Pool Max | Timeout |
|-------------|------------|------------|----------|---------|
| Development | false | true | 5 | 30s |
| Staging | true | false | 10 | 30s |
| Production | true | false | 25 | 30s |

---

## Connection Pooling Strategy

### Pool Configuration

| Setting | Value | Rationale |
|---------|-------|-----------|
| `min` | 0 | Allow pool to shrink when idle |
| `max` | 10-25 | Based on concurrent request volume |
| `idleTimeoutMillis` | 30000 | Release idle connections after 30s |
| `acquireTimeoutMillis` | 15000 | Fail fast if pool exhausted |

### Pool Sizing Guidelines

```
max_pool_size = (concurrent_requests × avg_queries_per_request) / query_duration_factor
```

For HRMS (estimated):
- Concurrent users: ~50
- Queries per request: ~3
- Query duration: ~50ms
- **Recommended max**: 15-20 connections

---

## Named Instance Handling

### SQL Server Express Configuration

Legacy connection uses named instance: `{SERVER}\SQLEXPRESS`

### Node.js Handling

```typescript
// Named instance configuration
{
  server: 'PIO-LAP-1083',  // Host only, no instance
  options: {
    instanceName: 'SQLEXPRESS'  // Instance specified here
  }
}
```

### Important Notes
- SQL Server Browser service must be running
- Dynamic port discovery happens automatically
- Do NOT specify port when using instanceName

---

## MARS Configuration

### Legacy Requirement
Connection string: `MultipleActiveResultSets=true`

### Node.js Equivalent
```typescript
{
  options: {
    enableArithAbort: true  // Enables MARS-like behavior
  }
}
```

### Usage Pattern
```typescript
// Multiple result sets from stored procedure
const result = await request.execute('GetEmployeeData');
const employees = result.recordsets[0];
const totalCount = result.recordsets[1][0].count;
```

---

## Connection Lifecycle

### Initialization
1. Create connection pool on application start
2. Verify connection with health check query
3. Log successful connection

### Request Handling
1. Acquire connection from pool
2. Execute query/transaction
3. Return connection to pool
4. Pool manages connection reuse

### Shutdown
1. Close all active connections
2. Drain connection pool
3. Clean up resources

---

## Error Handling Strategy

### Connection Errors
| Error Type | Action |
|------------|--------|
| Initial connection failure | Retry with backoff, fail startup after N attempts |
| Pool exhaustion | Queue request, fail after timeout |
| Network interruption | Connection invalidated, new one acquired |
| Authentication failure | Log, fail immediately (no retry) |

### Query Errors
| Error Type | Action |
|------------|--------|
| Syntax error | Log, return error to caller |
| Timeout | Log, return error to caller |
| Constraint violation | Map to business error |
| Deadlock | Retry (configurable attempts) |

---

## Monitoring & Observability

### Metrics to Expose

| Metric | Description |
|--------|-------------|
| `db_pool_size` | Current pool size |
| `db_pool_available` | Available connections |
| `db_pool_pending` | Queued requests |
| `db_query_duration_ms` | Query execution time |
| `db_connection_errors` | Connection error count |

### Logging

| Event | Log Level | Data |
|-------|-----------|------|
| Connection established | INFO | Server, database |
| Query execution | DEBUG | Query (truncated), duration |
| Query error | ERROR | Query, error message |
| Pool exhaustion | WARN | Pool stats |

---

## Alternatives Considered

### Option A: Direct tedious driver
- **Pro**: Lower level control
- **Con**: More boilerplate, manual pooling
- **Rejected**: Extra complexity without benefit

### Option B: Sequelize ORM
- **Pro**: Model abstraction, migrations
- **Con**: Harder parity with raw SQL patterns
- **Deferred**: Consider for new features

### Option C: Knex.js query builder
- **Pro**: SQL builder without full ORM
- **Con**: Another abstraction layer
- **Deferred**: Consider if query building becomes complex

---

## Consequences

### Positive
- Minimal change from Dapper patterns
- Full SQL Server feature support
- Easy transaction handling
- Good TypeScript support

### Negative
- Raw SQL maintenance (no ORM abstraction)
- Manual model/type definitions
- No automatic migrations (use SQL scripts)

### Risks
- Connection pool misconfiguration → exhaustion
- Missing TypeScript types for complex results
- Different null handling than .NET

---

## Action Items

1. [ ] Install mssql package and types
2. [ ] Create database configuration module
3. [ ] Implement connection health check
4. [ ] Set up connection pooling
5. [ ] Create base query helper
6. [ ] Add connection monitoring
7. [ ] Document SP calling patterns
