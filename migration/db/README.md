# Database Migration Documentation

> **Scope**: Planning and documentation only - NO code implementation

This directory contains all database-related planning documentation for migrating from .NET/Dapper to Node.js/mssql while **keeping the same SQL Server database**.

---

## Document Index

| Document | Purpose |
|----------|---------|
| [01-db-inventory.md](./01-db-inventory.md) | Catalog of database objects, connections, and usage |
| [02-connection-mapping.md](./02-connection-mapping.md) | Legacy to Node.js configuration mapping |
| [03-sqlserver-feature-compat.md](./03-sqlserver-feature-compat.md) | SQL Server feature compatibility with Node.js |
| [04-data-access-contracts.md](./04-data-access-contracts.md) | Core queries/commands by module |
| [05-readiness-checks.md](./05-readiness-checks.md) | Pre-execution gates and validation |

---

## Analysis Directory

| Document | Purpose |
|----------|---------|
| [analysis/legacy-db-patterns.md](./analysis/legacy-db-patterns.md) | Detailed analysis of legacy Dapper patterns |

---

## Architecture Decision Records

See [../adr/](../adr/) for database-related decisions:

| ADR | Topic |
|-----|-------|
| [001-db-connection-strategy.md](../adr/001-db-connection-strategy.md) | Driver selection, pooling |
| [002-db-auth-and-secrets.md](../adr/002-db-auth-and-secrets.md) | Authentication, secrets management |
| [003-db-error-handling-and-retries.md](../adr/003-db-error-handling-and-retries.md) | Error handling, retry logic |

---

## Key Decisions

### Database Strategy: Same Database
- **Decision**: Keep existing SQL Server database
- **Rationale**: Zero data migration, immediate parity
- **Trade-off**: Must support all legacy SQL patterns

### Driver: mssql (node-mssql)
- **Package**: `mssql` (wraps `tedious`)
- **Rationale**: Best match for raw SQL patterns from Dapper
- **Alternative considered**: Sequelize (deferred for new features)

---

## Quick Stats

| Metric | Count |
|--------|-------|
| Repositories | 26 |
| Dapper Queries | 383 |
| Stored Procedures | 72 |
| Entity Classes | 72 |
| Tables (estimated) | 50+ |

---

## Environment Variables Required

```bash
# Core connection
DB_HOST=localhost
DB_INSTANCE=SQLEXPRESS
DB_PORT=1433
DB_NAME=HRMS
DB_USER=hrms_app
DB_PASSWORD=***

# Options
DB_ENCRYPT=true
DB_TRUST_SERVER_CERT=false
DB_POOL_MAX=10
```

---

## Validation Checklist

Before implementation:
- [ ] All tables documented
- [ ] All stored procedures documented
- [ ] Connection string secrets configured
- [ ] Test connection verified
- [ ] ADR decisions approved

---

## Next Steps

1. Review and approve ADRs
2. Set up development environment variables
3. Create database test connection script
4. Begin repository-by-repository migration
5. Validate parity with legacy responses
