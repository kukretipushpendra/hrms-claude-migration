# Feature Template: database-setup

Use this template when creating the `database-setup` feature for any migration project.

## Feature File: `/migration/modules/core/features/database-setup.md`

```markdown
# Feature: database-setup

## Identity
MODULE: core
FEATURE: database-setup
CREATED: {date}

## Legacy References
FILES:
  - /legacy/Backend/*/appsettings.json (connection string)
  - /legacy/Backend/*/Repositories/*.cs (Dapper patterns)
  - /legacy/Backend/*/Entities/*.cs (entity definitions)

## Status
CURRENT: ready-for-dev
BACKEND: pending
FRONTEND: n/a
WORKTREE: (to be created)

## Dependencies
DEPENDS_ON:
  - none

## Behavior Spec
ENDPOINT: N/A (Database configuration)

DESCRIPTION:
Set up SQL Server database connection using mssql driver. Connect to existing database (no schema migration).

TASKS:
  1. Install mssql package and types
  2. Configure database module with environment variables
  3. Set up connection pooling
  4. Create health check endpoint that verifies DB connection
  5. Set up Winston or Pino logger for database operations
  6. Create base repository pattern for Dapper-style queries

CONFIGURATION:
  - Database: SQL Server (existing - no migration)
  - Driver: mssql (node-mssql)
  - Connection: Environment-based (individual vars, not URL)

## Implementation Checklist
- [ ] mssql package installed with @types/mssql
- [ ] Database config with connection pool
- [ ] Health check endpoint at /api/health
- [ ] Logger configured (not console.log)
- [ ] Environment variables documented
- [ ] Connection test on startup

## Attempts
ATTEMPT_COUNT: 0
```

## Key Points for Implementation

### 1. Install Dependencies
```bash
npm install mssql
npm install -D @types/mssql
```

### 2. Database Configuration Pattern
```typescript
// src/config/database.ts
import sql from 'mssql';

const config: sql.config = {
  server: process.env.DB_HOST!,
  database: process.env.DB_NAME!,
  user: process.env.DB_USER!,
  password: process.env.DB_PASSWORD!,
  port: Number(process.env.DB_PORT) || 1433,
  options: {
    instanceName: process.env.DB_INSTANCE,
    encrypt: process.env.DB_ENCRYPT === 'true',
    trustServerCertificate: process.env.DB_TRUST_SERVER_CERT === 'true',
    enableArithAbort: true, // Required for MARS
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
  try {
    const connection = await getPool();
    await connection.request().query('SELECT 1');
    console.log('Database connected successfully');
  } catch (error) {
    console.error('Database connection failed:', error);
    process.exit(1);
  }
};

export const closeDatabase = async (): Promise<void> => {
  if (pool) {
    await pool.close();
    pool = null;
  }
};
```

### 3. Health Check Endpoint
```typescript
// src/modules/health/health.routes.ts
import { Router } from 'express';
import { getPool } from '../../config/database';

const router = Router();

router.get('/', async (req, res) => {
  let dbStatus = 'disconnected';

  try {
    const pool = await getPool();
    await pool.request().query('SELECT 1');
    dbStatus = 'connected';
  } catch (error) {
    dbStatus = 'error';
  }

  res.json({
    status: 'ok',
    timestamp: new Date().toISOString(),
    database: {
      status: dbStatus,
    },
  });
});

export default router;
```

### 4. Environment Variables
```bash
# .env
DB_HOST=localhost
DB_INSTANCE=SQLEXPRESS
DB_PORT=1433
DB_NAME=HRMS
DB_USER=hrms_app
DB_PASSWORD=your_password
DB_ENCRYPT=false
DB_TRUST_SERVER_CERT=true
DB_POOL_MIN=0
DB_POOL_MAX=10
DB_POOL_IDLE=30000
```

### 5. Logger Setup
```typescript
// src/utils/logger.ts
import winston from 'winston';

export const logger = winston.createLogger({
  level: process.env.LOG_LEVEL || 'info',
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.json()
  ),
  transports: [
    new winston.transports.Console({
      format: winston.format.combine(
        winston.format.colorize(),
        winston.format.simple()
      ),
    }),
  ],
});
```

### 6. Common Mistakes to Avoid
- Using console.log instead of a proper logger
- Forgetting to handle named instances (SQLEXPRESS)
- Not setting `enableArithAbort: true` (required for MARS)
- Using PostgreSQL/Sequelize patterns (this is mssql with raw SQL)
- Creating new connections instead of using the pool
