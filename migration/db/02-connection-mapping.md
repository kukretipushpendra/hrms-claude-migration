# Connection String Mapping

> **Purpose**: Map legacy .NET connection configuration to Node.js environment variables
> **Scope**: Documentation only - NO code implementation

---

## Legacy Configuration (.NET)

### Source File
`appsettings.json` / `appsettings.{Environment}.json`

### Configuration Structure
```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=...;Database=HRMS;User Id=...;Password=...;MultipleActiveResultSets=true;TrustServerCertificate=True"
  }
}
```

### Access Pattern
```csharp
_configuration.GetConnectionString("DefaultConnection")
// or
_configuration.GetConnectionString(ConnectionStrings.DefaultConnection)
```

---

## Node.js Target Configuration

### Environment Variables

| .NET Config | Node.js Env Variable | Description |
|-------------|---------------------|-------------|
| ConnectionStrings:DefaultConnection | `DATABASE_URL` | Full connection string (optional) |
| Server component | `DB_HOST` | SQL Server host |
| Server instance | `DB_INSTANCE` | Named instance (e.g., SQLEXPRESS) |
| Port (if custom) | `DB_PORT` | Default: 1433 |
| Database | `DB_NAME` | Database name |
| User Id | `DB_USER` | SQL auth username |
| Password | `DB_PASSWORD` | SQL auth password |
| MultipleActiveResultSets | `DB_ENABLE_MARS` | true/false |
| TrustServerCertificate | `DB_TRUST_SERVER_CERT` | true/false (dev only) |
| Encrypt | `DB_ENCRYPT` | true/false |

### Derived/Computed Variables

| Variable | Value | Purpose |
|----------|-------|---------|
| `DB_DIALECT` | `mssql` | Driver type for Sequelize/mssql |
| `DB_POOL_MIN` | `0` | Minimum pool connections |
| `DB_POOL_MAX` | `10` | Maximum pool connections |
| `DB_POOL_IDLE` | `10000` | Idle timeout (ms) |
| `DB_REQUEST_TIMEOUT` | `30000` | Query timeout (ms) |

---

## Environment File Template

### `.env.example`
```bash
# Database Connection - SQL Server
DB_HOST=localhost
DB_INSTANCE=SQLEXPRESS
DB_PORT=1433
DB_NAME=HRMS
DB_USER=app_user
DB_PASSWORD=your_secure_password

# Connection Options
DB_ENABLE_MARS=true
DB_TRUST_SERVER_CERT=false
DB_ENCRYPT=true

# Connection Pool
DB_POOL_MIN=0
DB_POOL_MAX=10
DB_POOL_IDLE=10000
DB_REQUEST_TIMEOUT=30000

# Logging Database (if separate)
DB_LOGGING_ENABLED=true
```

### `.env.development`
```bash
# Development overrides
DB_HOST=localhost
DB_INSTANCE=SQLEXPRESS
DB_TRUST_SERVER_CERT=true
DB_ENCRYPT=false
```

### `.env.production`
```bash
# Production settings
DB_HOST=prod-sql-server.domain.com
DB_INSTANCE=
DB_TRUST_SERVER_CERT=false
DB_ENCRYPT=true
DB_POOL_MAX=25
```

---

## Connection String Parsing

### Legacy .NET String
```
Server=PIO-LAP-1083\SQLEXPRESS;Database=HRMS;User Id=sa;Password=admin;MultipleActiveResultSets=true;TrustServerCertificate=True
```

### Parsed Components

| Component | Extracted Value | Node.js Variable |
|-----------|-----------------|------------------|
| Server | `PIO-LAP-1083\SQLEXPRESS` | `DB_HOST=PIO-LAP-1083`, `DB_INSTANCE=SQLEXPRESS` |
| Database | `HRMS` | `DB_NAME=HRMS` |
| User Id | `sa` | `DB_USER=sa` |
| Password | `admin` | `DB_PASSWORD=admin` |
| MultipleActiveResultSets | `true` | `DB_ENABLE_MARS=true` |
| TrustServerCertificate | `True` | `DB_TRUST_SERVER_CERT=true` |

---

## Node.js mssql Configuration Object

### Configuration Builder Pattern (Documentation Only)
```typescript
// DOCUMENTATION: How to construct mssql config from env vars

interface SqlConfig {
  server: string;          // DB_HOST
  port?: number;           // DB_PORT (1433 default)
  database: string;        // DB_NAME
  user: string;            // DB_USER
  password: string;        // DB_PASSWORD
  options: {
    instanceName?: string;           // DB_INSTANCE
    encrypt: boolean;                // DB_ENCRYPT
    trustServerCertificate: boolean; // DB_TRUST_SERVER_CERT
    enableArithAbort: boolean;       // Required for MARS
  };
  pool: {
    min: number;           // DB_POOL_MIN
    max: number;           // DB_POOL_MAX
    idleTimeoutMillis: number; // DB_POOL_IDLE
  };
  requestTimeout: number;  // DB_REQUEST_TIMEOUT
}
```

---

## Serilog Connection Mapping

### Legacy Configuration
```json
{
  "Serilog": {
    "WriteTo": [{
      "Name": "MSSqlServer",
      "Args": {
        "connectionString": "DefaultConnection",
        "tableName": "Logging",
        "autoCreateSqlTable": true
      }
    }]
  }
}
```

### Node.js Equivalent Variables
```bash
# Logging Configuration
LOG_DB_ENABLED=true
LOG_DB_TABLE=Logging
LOG_DB_AUTO_CREATE=true
# Uses same DB_* connection variables
```

---

## Named Instance Handling

### SQL Server Named Instances
SQL Server Express uses named instances (e.g., `SQLEXPRESS`).

### Connection Patterns

| Pattern | .NET | Node.js (mssql) |
|---------|------|-----------------|
| Default Instance | `Server=hostname` | `server: hostname` |
| Named Instance | `Server=hostname\SQLEXPRESS` | `server: hostname, options.instanceName: 'SQLEXPRESS'` |
| Custom Port | `Server=hostname,1434` | `server: hostname, port: 1434` |

### Instance Name Extraction
```
Input: "PIO-LAP-1083\SQLEXPRESS"
Output:
  - DB_HOST = "PIO-LAP-1083"
  - DB_INSTANCE = "SQLEXPRESS"
```

---

## Security Considerations

### Credential Management

| Environment | Strategy | Tool |
|-------------|----------|------|
| Development | `.env` file (gitignored) | dotenv |
| CI/CD | Environment variables | GitHub Secrets / Azure DevOps |
| Production | Secret manager | Azure Key Vault / AWS Secrets Manager |

### Sensitive Variables (NEVER commit)
- `DB_PASSWORD`
- `DB_USER` (if not generic)
- Full connection strings

### Gitignore Entries
```gitignore
.env
.env.local
.env.*.local
*.env
!.env.example
```

---

## Validation Checklist

Before deploying to any environment:

- [ ] All DB_* variables are set
- [ ] DB_PASSWORD is not default/weak
- [ ] DB_TRUST_SERVER_CERT=false in production
- [ ] DB_ENCRYPT=true in production
- [ ] Connection pool sizes appropriate for load
- [ ] Request timeout suitable for longest query

---

## Migration Verification

### Test Connection (Documentation)
```bash
# Verify environment variables are loaded
echo $DB_HOST
echo $DB_NAME

# Test connection (once driver is implemented)
npm run db:test-connection
```

### Expected Output
```
Connecting to: {DB_HOST}\{DB_INSTANCE}
Database: {DB_NAME}
Connection: SUCCESS
Pool: min={DB_POOL_MIN}, max={DB_POOL_MAX}
```

---

## Comparison Table

| Aspect | .NET (Legacy) | Node.js (Target) |
|--------|---------------|------------------|
| Config File | `appsettings.json` | `.env` + `process.env` |
| Secrets | App secrets / Key Vault | Environment variables / Secret manager |
| Parsing | Built-in ConfigurationManager | `dotenv` package |
| Validation | Data annotations | Zod schema |
| Type Safety | Strongly typed classes | TypeScript interfaces |
| Environment Override | `appsettings.{env}.json` | `.env.{environment}` |
