# ADR-003: Database Error Handling and Retry Strategy

> **Status**: Proposed
> **Date**: 2024-XX-XX
> **Decision Makers**: [TBD]

---

## Context

The legacy .NET application uses ADO.NET's default error handling. The modern Node.js backend needs explicit strategies for handling SQL Server errors, implementing retries for transient faults, and maintaining parity with legacy behavior.

### Current State (Legacy)
- Dapper throws exceptions on SQL errors
- Application catches and maps to HTTP responses
- No explicit retry logic for transient faults
- Transaction rollback on exception

### Requirements
1. Handle transient faults gracefully
2. Map SQL errors to appropriate HTTP status codes
3. Maintain response shape parity with legacy
4. Log errors for debugging without exposing sensitive data
5. Support transaction rollback

---

## Decision

### Error Classification

| Category | Description | Action |
|----------|-------------|--------|
| **Transient** | Temporary, may succeed on retry | Retry with backoff |
| **Recoverable** | Permanent but expected | Map to business error |
| **Fatal** | Unrecoverable | Log, alert, fail |

---

## Transient Fault Handling

### Transient Error Codes (SQL Server)

| Error Number | Description | Retry |
|--------------|-------------|-------|
| -2 | Timeout expired | ✅ Yes |
| 4060 | Cannot open database | ✅ Yes |
| 40197 | Service error processing request | ✅ Yes |
| 40501 | Service is busy | ✅ Yes |
| 40613 | Database unavailable | ✅ Yes |
| 49918 | Not enough resources | ✅ Yes |
| 49919 | Cannot process request | ✅ Yes |
| 49920 | Cannot process request | ✅ Yes |
| 1205 | Deadlock victim | ✅ Yes |
| 10928 | Resource limit reached | ✅ Yes |
| 10929 | Resource limit reached | ✅ Yes |
| 10053 | Network error | ✅ Yes |
| 10054 | Connection reset | ✅ Yes |
| 10060 | Network timeout | ✅ Yes |

### Retry Strategy

| Attempt | Delay | Notes |
|---------|-------|-------|
| 1 | 0ms | Immediate retry |
| 2 | 100ms | Short delay |
| 3 | 500ms | Medium delay |
| 4 | 2000ms | Longer delay |
| 5 | 5000ms | Final attempt |

### Exponential Backoff Formula
```
delay = min(baseDelay * 2^attempt + jitter, maxDelay)
```

Where:
- `baseDelay` = 100ms
- `maxDelay` = 30000ms (30s)
- `jitter` = random(0, 100)ms

---

## Recoverable Errors (Business Logic)

### Constraint Violation Mapping

| SQL Error | Code | HTTP Status | Response Message |
|-----------|------|-------------|------------------|
| 2627 | Unique constraint | 409 Conflict | "Resource already exists" |
| 2601 | Duplicate key | 409 Conflict | "Duplicate entry" |
| 547 | FK constraint | 400 Bad Request | "Referenced resource not found" |
| 515 | Cannot insert NULL | 400 Bad Request | "Required field missing" |
| 8152 | String truncation | 400 Bad Request | "Field value too long" |

### Error Response Shape (Parity Critical)

```typescript
// Must match legacy response exactly
interface ErrorResponse {
  statusCode: number;
  message: string;
  errors?: Array<{
    field?: string;
    message: string;
  }>;
}

// Examples
// Unique constraint violation
{
  "statusCode": 409,
  "message": "Employee code already exists",
  "errors": [
    { "field": "employeeCode", "message": "This employee code is already in use" }
  ]
}

// Foreign key violation
{
  "statusCode": 400,
  "message": "Invalid reference",
  "errors": [
    { "field": "departmentId", "message": "Department does not exist" }
  ]
}
```

---

## Fatal Errors

### Unrecoverable Errors

| Error Type | Action |
|------------|--------|
| Authentication failure | Log, fail, alert |
| Database not found | Log, fail, alert |
| Permission denied | Log, fail, alert |
| Network unreachable (persistent) | Log, fail, alert |

### Fatal Error Response

```typescript
{
  "statusCode": 500,
  "message": "Internal server error",
  "errors": [] // Never expose internal details
}
```

---

## Transaction Error Handling

### Transaction Rollback Pattern (Documentation)

```typescript
// Pseudo-code for transaction handling
async function executeInTransaction<T>(
  operation: (transaction: Transaction) => Promise<T>
): Promise<T> {
  const transaction = new Transaction();

  try {
    await transaction.begin();
    const result = await operation(transaction);
    await transaction.commit();
    return result;
  } catch (error) {
    await transaction.rollback();
    throw error; // Re-throw for upper layer handling
  }
}
```

### Nested Transaction Handling

SQL Server doesn't support true nested transactions. Use savepoints:

| Pattern | Behavior |
|---------|----------|
| Outer commit | Commits all changes |
| Inner rollback | Rolls back to savepoint |
| Outer rollback | Rolls back everything |

---

## Timeout Configuration

### Query Timeouts

| Query Type | Timeout | Rationale |
|------------|---------|-----------|
| Simple CRUD | 30s | Standard operations |
| Report query | 60s | Complex aggregations |
| Bulk operation | 120s | Large data processing |
| Health check | 5s | Fast fail required |

### Connection Timeouts

| Timeout Type | Value | Purpose |
|--------------|-------|---------|
| Connect timeout | 15s | Initial connection |
| Request timeout | 30s | Query execution |
| Pool acquire | 15s | Getting connection from pool |

---

## Error Logging Strategy

### What to Log

| Field | Log | Purpose |
|-------|-----|---------|
| Error code | ✅ | Classification |
| Error message | ✅ | Debugging |
| Query (truncated) | ✅ | Reproduction |
| Parameters | ⚠️ Redacted | Context (no PII) |
| Stack trace | ✅ | Source location |
| Timestamp | ✅ | Correlation |
| Request ID | ✅ | Tracing |

### What NOT to Log

| Field | Log | Reason |
|-------|-----|--------|
| Connection string | ❌ | Security |
| Passwords | ❌ | Security |
| Full query with values | ❌ | PII exposure |
| User data from params | ❌ | Privacy |

### Log Format

```json
{
  "timestamp": "2024-01-15T10:30:00.000Z",
  "level": "error",
  "message": "Database query failed",
  "error": {
    "code": 2627,
    "message": "Violation of UNIQUE KEY constraint",
    "query": "INSERT INTO Employees (Code, Name...) VALUES (@p0, @p1...)",
    "state": 1
  },
  "context": {
    "requestId": "abc123",
    "operation": "createEmployee",
    "duration_ms": 45
  }
}
```

---

## Alerting Thresholds

### Error Rate Alerts

| Condition | Severity | Action |
|-----------|----------|--------|
| Error rate > 1% | Warning | Investigate |
| Error rate > 5% | Critical | Immediate response |
| Connection failures > 3/min | Critical | Check database |
| Deadlocks > 10/hour | Warning | Review queries |

### Latency Alerts

| Condition | Severity | Action |
|-----------|----------|--------|
| p95 > 500ms | Warning | Monitor |
| p95 > 1000ms | Critical | Investigate |
| p99 > 5000ms | Critical | Scale/optimize |

---

## Parity with Legacy Error Handling

### Legacy .NET Pattern

```csharp
try
{
    await connection.ExecuteAsync(sql, params);
}
catch (SqlException ex) when (ex.Number == 2627)
{
    throw new ConflictException("Resource already exists");
}
catch (SqlException ex)
{
    _logger.LogError(ex, "Database error");
    throw new InternalException("An error occurred");
}
```

### Equivalent Node.js Pattern (Documentation)

```typescript
// Error handler middleware pattern
function handleDatabaseError(error: MssqlError): AppError {
  // Transient - should have been retried
  if (isTransientError(error)) {
    return new ServiceUnavailableError('Service temporarily unavailable');
  }

  // Business logic errors
  switch (error.number) {
    case 2627:
    case 2601:
      return new ConflictError('Resource already exists', error);
    case 547:
      return new BadRequestError('Referenced resource not found', error);
    case 515:
      return new BadRequestError('Required field missing', error);
    default:
      return new InternalError('An error occurred', error);
  }
}
```

---

## Circuit Breaker Pattern

### When to Use

| Scenario | Circuit Breaker |
|----------|-----------------|
| Database completely down | Yes - prevent cascade |
| High error rate | Yes - allow recovery |
| Single query failure | No - just retry |

### States

| State | Behavior |
|-------|----------|
| Closed | Normal operation, track failures |
| Open | Fail immediately, no DB calls |
| Half-Open | Allow limited requests to test |

### Thresholds

| Parameter | Value |
|-----------|-------|
| Failure threshold | 5 consecutive failures |
| Open duration | 30 seconds |
| Half-open requests | 3 |

---

## Testing Error Scenarios

### Unit Tests

| Scenario | Test Approach |
|----------|---------------|
| Unique constraint | Mock SQL error 2627 |
| FK violation | Mock SQL error 547 |
| Timeout | Mock SQL error -2 |
| Deadlock | Mock SQL error 1205 |

### Integration Tests

| Scenario | Test Approach |
|----------|---------------|
| Unique constraint | Insert duplicate data |
| FK violation | Reference non-existent ID |
| Transaction rollback | Force error mid-transaction |

### Chaos Testing

| Scenario | Approach |
|----------|----------|
| Database unavailable | Stop SQL Server container |
| Network latency | Add network delay |
| Connection exhaustion | Open max connections |

---

## Consequences

### Positive
- Graceful handling of transient faults
- Consistent error responses
- Secure logging (no credential leaks)
- Observability into database issues

### Negative
- Additional complexity
- Retry delays add latency
- May mask underlying issues

### Risks
- Over-aggressive retry → amplify load
- Circuit breaker too sensitive → false positives
- Incomplete error mapping → unexpected 500s

---

## Action Items

1. [ ] Define transient error detection function
2. [ ] Implement retry wrapper with backoff
3. [ ] Create error-to-HTTP mapper
4. [ ] Configure logging sanitization
5. [ ] Set up error rate alerting
6. [ ] Document all error codes and responses
7. [ ] Add integration tests for error scenarios
