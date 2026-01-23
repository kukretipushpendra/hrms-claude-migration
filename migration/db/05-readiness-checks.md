# Database Migration Readiness Checks

> **Purpose**: Pre-execution gates and parity validation checklist
> **Scope**: Documentation only - NO code implementation

---

## Pre-Migration Checklist

### Infrastructure Readiness

| Check | Status | Notes |
|-------|--------|-------|
| [ ] SQL Server instance accessible from Node.js environment | ⬜ | Network/firewall rules |
| [ ] SQL Server port (1433) open | ⬜ | Or custom port |
| [ ] Named instance (SQLEXPRESS) accessible | ⬜ | Browser service running |
| [ ] Application database user created | ⬜ | Not using `sa` in production |
| [ ] User has required permissions | ⬜ | SELECT, INSERT, UPDATE, DELETE, EXECUTE |
| [ ] Connection string secrets secured | ⬜ | Not in source control |
| [ ] SSL/TLS configured (production) | ⬜ | `TrustServerCertificate=false` |

### Development Environment

| Check | Status | Notes |
|-------|--------|-------|
| [ ] Node.js 18+ installed | ⬜ | LTS version recommended |
| [ ] `mssql` package compatible version | ⬜ | Check peer dependencies |
| [ ] TypeScript configured | ⬜ | `@types/mssql` installed |
| [ ] Environment variables set | ⬜ | `.env` file configured |
| [ ] Connection test script works | ⬜ | Can connect and query |

### Database Schema Documentation

| Check | Status | Notes |
|-------|--------|-------|
| [ ] All tables documented | ⬜ | Schema + relationships |
| [ ] All views documented | ⬜ | Especially vw_* used in queries |
| [ ] All stored procedures documented | ⬜ | Parameters, result sets |
| [ ] Entity-to-table mapping complete | ⬜ | .NET entity → SQL table |
| [ ] Data type mapping documented | ⬜ | SQL types → TypeScript |

---

## Connection Verification Gates

### Gate 1: Basic Connectivity
```
✓ Connect to SQL Server
✓ Authenticate with configured credentials
✓ Select from system table (SELECT 1)
✓ Connection pool initializes
```

### Gate 2: Database Access
```
✓ Connect to HRMS database
✓ Query user tables (SELECT COUNT(*) FROM EmployeeData)
✓ Write test (INSERT into temp table)
✓ Transaction begin/commit/rollback
```

### Gate 3: Feature Verification
```
✓ MARS functionality (if required)
✓ Stored procedure execution
✓ Multiple result sets handling
✓ Large result set streaming
✓ FOR JSON PATH results
```

### Gate 4: Production Readiness
```
✓ SSL/TLS connection works
✓ Connection pooling under load
✓ Timeout handling
✓ Error recovery
✓ Monitoring/logging
```

---

## Parity Validation Checklist

### Response Shape Parity

For each API endpoint, verify:

| Endpoint | Legacy Shape | Node.js Shape | Match |
|----------|--------------|---------------|-------|
| GET /api/health | ✓ | ⬜ | ⬜ |
| POST /api/auth/login | ✓ | ⬜ | ⬜ |
| GET /api/employees | ✓ | ⬜ | ⬜ |
| GET /api/employees/:id | ✓ | ⬜ | ⬜ |
| ... | ... | ... | ... |

### Data Type Parity

| Data Type | .NET Handling | Node.js Handling | Verified |
|-----------|---------------|------------------|----------|
| BIGINT (long) | `long` | `number`/`bigint` | ⬜ |
| DATE | `DateOnly` | `Date`/`string` | ⬜ |
| TIME | `TimeOnly` | `Date`/`string` | ⬜ |
| DATETIME2 | `DateTime` | `Date` | ⬜ |
| DECIMAL | `decimal` | `number` | ⬜ |
| BIT | `bool` | `boolean` | ⬜ |
| NVARCHAR | `string` | `string` | ⬜ |
| UNIQUEIDENTIFIER | `Guid` | `string` | ⬜ |

### Query Result Parity

For critical queries, verify exact same results:

| Query | Expected Records | .NET Result | Node.js Result | Match |
|-------|------------------|-------------|----------------|-------|
| GetEmployeeById(1) | 1 | ✓ | ⬜ | ⬜ |
| GetActiveEmployees() | ~100 | ✓ | ⬜ | ⬜ |
| GetLeaveBalance(1, 2024) | 5 | ✓ | ⬜ | ⬜ |
| ... | ... | ... | ... | ... |

### Stored Procedure Parity

| Stored Procedure | Input Params | Result Sets | .NET | Node.js | Match |
|------------------|--------------|-------------|------|---------|-------|
| GetAttendanceConfigList | 6 | 2 | ✓ | ⬜ | ⬜ |
| GetEmployeeGrievances | 5 | 2 | ✓ | ⬜ | ⬜ |
| CreditMonthlyLeaveBalance | 2 | 0 | ✓ | ⬜ | ⬜ |
| ... | ... | ... | ... | ... | ... |

---

## Error Handling Parity

### SQL Error Code Mapping

| Error Scenario | SQL Error | .NET Handling | Node.js Required |
|----------------|-----------|---------------|------------------|
| Unique constraint | 2627 | Business exception | Map to 409 Conflict |
| Foreign key | 547 | Business exception | Map to 400 Bad Request |
| Null required field | 515 | Validation error | Map to 400 Bad Request |
| Deadlock | 1205 | Retry logic | Implement retry |
| Timeout | -2 | Timeout exception | Handle request timeout |

### Exception Response Shape
```typescript
// Must match legacy error response exactly
{
  "statusCode": 400,
  "message": "Validation failed",
  "errors": [
    { "field": "email", "message": "Email already exists" }
  ]
}
```

---

## Transaction Parity

### Transaction Boundaries

| Repository | Transaction Scope | Operations |
|------------|-------------------|------------|
| UserProfileRepository.CreateEmployee | Full | Insert Employee + Address + User |
| LeaveManagementRepository.ApplyLeave | Full | Insert Leave + Update Balance |
| AssetManagementRepository.AssignAsset | Full | Update Asset + Insert Assignment + History |

### Isolation Level Verification

| Operation | Required Level | Verified |
|-----------|----------------|----------|
| CreateEmployee | READ_COMMITTED | ⬜ |
| ApproveLeave | SERIALIZABLE | ⬜ |
| CreditMonthlyBalance | SERIALIZABLE | ⬜ |

---

## Performance Baseline

### Query Performance Benchmarks

| Query | .NET Avg (ms) | Node.js Target | Acceptable Variance |
|-------|---------------|----------------|---------------------|
| GetEmployeeById | TBD | ≤ .NET + 10% | ±20% |
| GetEmployeeList (100) | TBD | ≤ .NET + 10% | ±20% |
| GetAttendanceReport | TBD | ≤ .NET + 10% | ±20% |

### Connection Pool Metrics

| Metric | Target |
|--------|--------|
| Initial connection time | < 500ms |
| Pooled connection reuse | < 5ms |
| Pool exhaustion recovery | < 5s |

---

## Security Verification

### Authentication

| Check | Verified |
|-------|----------|
| [ ] Password not logged | ⬜ |
| [ ] Connection string not in logs | ⬜ |
| [ ] SQL injection prevented | ⬜ |
| [ ] Parameterized queries only | ⬜ |

### Authorization

| Check | Verified |
|-------|----------|
| [ ] App user has minimal permissions | ⬜ |
| [ ] No DDL permissions | ⬜ |
| [ ] No sa account in production | ⬜ |

---

## Rollback Plan

### If Node.js migration fails:

1. **Immediate**: Continue running .NET API
2. **Data**: No schema changes, same database
3. **Configuration**: Keep .NET connection strings
4. **Timeline**: Define rollback decision point

### No-Go Criteria

Migration should NOT proceed if:
- [ ] Connection fails in production environment
- [ ] >10% query result mismatch
- [ ] Response time >2x legacy
- [ ] Security audit fails
- [ ] Transaction behavior differs

---

## Sign-Off Checklist

### Technical Review

| Reviewer | Area | Approved | Date |
|----------|------|----------|------|
| DBA | Database access, permissions | ⬜ | |
| DevOps | Environment, secrets | ⬜ | |
| Security | Auth, encryption | ⬜ | |
| Tech Lead | Architecture, patterns | ⬜ | |

### Testing Milestones

| Milestone | Criteria | Status |
|-----------|----------|--------|
| Unit Tests | All queries covered | ⬜ |
| Integration Tests | E2E with SQL Server | ⬜ |
| Performance Tests | Within tolerance | ⬜ |
| Security Scan | No vulnerabilities | ⬜ |

---

## Monitoring Readiness

### Metrics to Track

| Metric | Tool | Threshold |
|--------|------|-----------|
| Connection errors | APM | < 0.1% |
| Query latency p95 | APM | < 500ms |
| Pool utilization | Custom | < 80% |
| Transaction failures | Logs | < 0.01% |

### Alerting Rules

| Alert | Condition | Severity |
|-------|-----------|----------|
| Connection failure | 3 consecutive | Critical |
| High latency | p95 > 1s | Warning |
| Pool exhaustion | Available = 0 | Critical |

---

## Final Go/No-Go Decision

### Requirements for Go:

- [ ] All infrastructure checks pass
- [ ] All connection gates verified
- [ ] Critical query parity confirmed
- [ ] Error handling matches legacy
- [ ] Performance within tolerance
- [ ] Security review passed
- [ ] Rollback plan documented
- [ ] Monitoring in place

**Decision**: ⬜ GO / ⬜ NO-GO

**Decision Date**: ____________

**Approved By**: ____________
