# ADR-002: Database Authentication and Secrets Management

> **Status**: Proposed
> **Date**: 2024-XX-XX
> **Decision Makers**: [TBD]

---

## Context

The legacy .NET application stores database credentials in `appsettings.json` files. The modern Node.js backend needs a secure approach to manage database credentials across environments.

### Current State (Legacy)
- Credentials stored in `appsettings.json`
- Environment-specific files: `appsettings.Development.json`, `appsettings.Production.json`
- Uses SQL Server Authentication (user/password)
- Development uses `sa` account (security risk)

### Security Requirements
1. Credentials must not be in source control
2. Production secrets must be in secure vault
3. Development must be easy to configure
4. Support for credential rotation
5. Audit trail for secret access

---

## Decision

### Multi-Tier Secrets Strategy

| Environment | Secret Storage | Retrieval Method |
|-------------|----------------|------------------|
| Development | `.env` file (local, gitignored) | `dotenv` package |
| CI/CD | Pipeline secrets | Environment variables |
| Staging | Cloud secret manager | SDK at runtime |
| Production | Cloud secret manager | SDK at runtime |

---

## Development Environment

### Configuration File: `.env`

```bash
# .env (NEVER commit this file)
DB_HOST=localhost
DB_INSTANCE=SQLEXPRESS
DB_NAME=HRMS
DB_USER=hrms_app
DB_PASSWORD=your_local_password
```

### Loading Pattern (Documentation)
```typescript
// Early in application startup
import 'dotenv/config';

// Access via process.env
const dbUser = process.env.DB_USER;
```

### Security Measures
- `.env` in `.gitignore`
- `.env.example` committed with placeholder values
- Pre-commit hook to prevent `.env` commits

---

## Production Environment

### Recommended: Azure Key Vault

For Azure-hosted applications:

| Secret Name | Description |
|-------------|-------------|
| `hrms-db-host` | SQL Server hostname |
| `hrms-db-name` | Database name |
| `hrms-db-user` | Application user |
| `hrms-db-password` | Application password |

### Alternative: AWS Secrets Manager

For AWS-hosted applications:

| Secret Path | Description |
|-------------|-------------|
| `/hrms/production/db/host` | SQL Server hostname |
| `/hrms/production/db/credentials` | JSON with user/password |

### Alternative: HashiCorp Vault

For on-premises or multi-cloud:

| Secret Path | Description |
|-------------|-------------|
| `secret/hrms/database` | All DB credentials as JSON |

---

## SQL Server Authentication

### Decision: SQL Server Authentication (Initially)

**Rationale**:
- Matches legacy configuration
- Works across environments (dev, staging, prod)
- Simpler initial setup

### Future Consideration: Azure AD Authentication

For Azure SQL or AAD-joined environments:
- No password management
- Managed identity support
- Better audit trail

---

## Application Database User

### Principle of Least Privilege

**DO NOT** use `sa` account in any environment.

### Recommended User Setup

```sql
-- Create application user (run by DBA)
CREATE LOGIN hrms_app WITH PASSWORD = 'SecurePassword123!';
USE HRMS;
CREATE USER hrms_app FOR LOGIN hrms_app;

-- Grant minimal permissions
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo TO hrms_app;
GRANT EXECUTE ON SCHEMA::dbo TO hrms_app;

-- Deny dangerous permissions
DENY ALTER TO hrms_app;
DENY CREATE TABLE TO hrms_app;
DENY DROP TO hrms_app;
```

### Permission Matrix

| Permission | Development | Staging | Production |
|------------|-------------|---------|------------|
| SELECT | ✅ | ✅ | ✅ |
| INSERT | ✅ | ✅ | ✅ |
| UPDATE | ✅ | ✅ | ✅ |
| DELETE | ✅ | ✅ | ✅ |
| EXECUTE (SPs) | ✅ | ✅ | ✅ |
| CREATE/ALTER | ❌ | ❌ | ❌ |
| DROP | ❌ | ❌ | ❌ |
| BACKUP | ❌ | ❌ | ❌ |

---

## Credential Rotation

### Strategy: Zero-Downtime Rotation

1. **Dual-Password Support**: Database accepts both old and new password
2. **Gradual Rollout**: Update application instances one by one
3. **Verification**: Confirm all instances using new password
4. **Cleanup**: Disable old password

### Rotation Steps

```
1. DBA adds new password to DB user (ALTER LOGIN)
2. New password added to secret manager
3. Application redeployed with new secret
4. Monitor for connection errors
5. DBA removes old password after grace period
```

### Rotation Frequency

| Environment | Frequency | Trigger |
|-------------|-----------|---------|
| Development | Never | Manual only |
| Staging | Quarterly | Scheduled |
| Production | Monthly | Automated |
| On Incident | Immediate | Security event |

---

## Connection String Security

### Never Log Full Connection String

```typescript
// BAD - logs password
console.log(`Connecting to: ${connectionString}`);

// GOOD - redact sensitive parts
console.log(`Connecting to: ${dbHost}/${dbName} as ${dbUser}`);
```

### Sanitization for Errors

```typescript
// Strip credentials from error messages before logging
function sanitizeError(error: Error): Error {
  error.message = error.message.replace(/Password=[^;]+/gi, 'Password=***');
  return error;
}
```

---

## Environment Variable Validation

### Required Variables

| Variable | Required | Default |
|----------|----------|---------|
| `DB_HOST` | Yes | - |
| `DB_NAME` | Yes | - |
| `DB_USER` | Yes | - |
| `DB_PASSWORD` | Yes | - |
| `DB_PORT` | No | 1433 |
| `DB_INSTANCE` | No | - |

### Validation Pattern (Documentation)

```typescript
// Zod schema for environment validation
const envSchema = z.object({
  DB_HOST: z.string().min(1),
  DB_NAME: z.string().min(1),
  DB_USER: z.string().min(1),
  DB_PASSWORD: z.string().min(1),
  DB_PORT: z.coerce.number().default(1433),
  DB_INSTANCE: z.string().optional(),
});

// Fail fast if missing
const env = envSchema.parse(process.env);
```

---

## Encryption in Transit

### TLS Configuration

| Environment | Encrypt | Trust Server Cert |
|-------------|---------|-------------------|
| Development | false | true |
| Staging | true | false |
| Production | true | false |

### Certificate Requirements (Production)

- SQL Server must have valid SSL certificate
- Certificate must be trusted by Node.js runtime
- Or add CA certificate to Node.js

```bash
# Environment variable to add CA cert
NODE_EXTRA_CA_CERTS=/path/to/ca-cert.pem
```

---

## Audit Trail

### Secret Access Logging

| Event | Log |
|-------|-----|
| Secret retrieved | INFO: Retrieved DB credentials for {env} |
| Secret not found | ERROR: Missing secret {name} |
| Authentication failed | ERROR: DB authentication failed (no password in log) |

### Azure Key Vault Audit

Enable diagnostic settings to log:
- Secret reads
- Access denials
- Permission changes

---

## Disaster Recovery

### Secret Backup

| Secret Manager | Backup Strategy |
|----------------|-----------------|
| Azure Key Vault | Soft-delete + Purge protection enabled |
| AWS Secrets Manager | Automatic versioning |
| HashiCorp Vault | Integrated backup/snapshot |

### Recovery Procedure

1. Identify compromised credentials
2. Rotate secrets in vault immediately
3. Redeploy applications
4. Audit access logs
5. Investigate breach

---

## Migration Path from Legacy

### Current (.NET)
```json
// appsettings.json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=...;User Id=sa;Password=admin;..."
  }
}
```

### Target (Node.js)
```bash
# .env or secret manager
DB_HOST=server
DB_USER=hrms_app  # Not sa!
DB_PASSWORD=***   # From secret manager
```

### Migration Steps

1. [ ] Create dedicated `hrms_app` database user
2. [ ] Test application with new user in dev
3. [ ] Add secrets to secret manager
4. [ ] Update deployment to use secrets
5. [ ] Remove `sa` access after verification
6. [ ] Audit and document new setup

---

## Consequences

### Positive
- Credentials not in source control
- Environment-appropriate security levels
- Support for credential rotation
- Audit trail in production

### Negative
- Additional complexity for secret management
- Dependency on secret manager availability
- Initial setup overhead

### Risks
- Secret manager outage → application can't start
- Misconfigured permissions → access denied
- Secret not rotated → stale credentials

---

## Action Items

1. [ ] Create `.env.example` template
2. [ ] Add `.env` to `.gitignore`
3. [ ] Create `hrms_app` database user
4. [ ] Implement environment validation
5. [ ] Set up secret manager (staging/prod)
6. [ ] Document rotation procedure
7. [ ] Configure audit logging
