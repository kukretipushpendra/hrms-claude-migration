---
description: Initialize migration - discover legacy, scaffold projects
allowed-tools: Read, Glob, Grep, Bash, Write, Edit, AskUserQuestion, Task
---

# Initialize Migration

## Thin Context: Main agent NEVER reads legacy/discovery/spec contents

## Phase 1: Prerequisites

```bash
ls -la legacy/ 2>/dev/null || echo "NO_LEGACY_FOLDER"
docker ps 2>/dev/null || echo "DOCKER_NOT_AVAILABLE"
```

## Phase 2: Start Database

```bash
docker compose up -d && docker compose ps
```

## Phase 3: Discovery (Sub-Agent)

```
Task (explorer): "Analyze legacy at /legacy.
Create discovery files. Return ONLY paths and counts."
```

Wait for: `DISCOVERY_COMPLETE` with stats.

## Phase 4: Create Specs (Parallel Sub-Agents)

```bash
cat migration/discovery/modules.json | jq -r '.modules[].name'
```

For each module IN PARALLEL:
```
Task (spec-writer): "Create specs for module '{module}'.
DISCOVERY: /migration/discovery/modules.json
Return ONLY paths."
```

## Phase 5: Tech Stack (User Discussion)

AskUserQuestion:
- State Management: TanStack Query | Zustand | None
- Form Handling: React Hook Form + Zod | Formik | Native
- Ready to scaffold?
- Any Other Requirements - Type

Write to `/migration/tech-stack.md`.

## Phase 6: Scaffold Projects

```bash
# Backend
mkdir -p modern/backend && cd modern/backend
npx @nestjs/cli new . --skip-git --package-manager npm

# Frontend
mkdir -p modern/frontend && cd modern/frontend
npm create vite@latest . -- --template react-ts && npm install

# CSS framework (from discovery)
CSS_VER=$(cat migration/discovery/ui-framework.json | jq -r '.cssFramework.version')
npm install bootstrap@$CSS_VER
```

## Phase 7: Create Manifest

Write `/migration/manifest.md` with stats from discovery.

## Phase 8: Setup Backend and Frontend Properly.
- **Critical** Make sure to use Sub Agents to do this work and make sure Sub Agent use appropriate skills - (nestjs-expert for backend and react-expert)

### 8.1 Backend: Use nestjs-expert skill

#### Setup Logger, Create NestJS DB Module and Import in App.module.ts.
- Path: `modern/backend/**`
- Required NPM Packages: @nestjs/swagger, "@nestjs/sequelize", "pg", sequelize, sequelize-typescript, pg-hstore and related @types dev dependencies.
```typescript
// modern/backend/src/main.ts
import { NestFactory } from '@nestjs/core';
import { ValidationPipe } from '@nestjs/common';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

   const config = new DocumentBuilder()
    .setTitle('Cats example')
    .setDescription('The Project_Name API description')
    .setVersion('1.0')
    .addTag('cats')
    .build();
  const documentFactory = () => SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api', app, documentFactory);

  app.enableCors({
    origin: ['http://localhost:5173', 'http://127.0.0.1:5173'],
    credentials: true,
  });

  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
    }),
  );

  await app.listen(process.env.PORT ?? 3000);
}
void bootstrap();
```
```typescript
// src/database/database.module.ts
import { Module } from '@nestjs/common';
import { SequelizeModule } from '@nestjs/sequelize';
import { ConfigModule, ConfigService } from '@nestjs/config';

@Module({
  imports: [
    SequelizeModule.forRootAsync({
      imports: [ConfigModule],
      useFactory: (configService: ConfigService) => ({
        dialect: 'postgres',
        host: configService.get('DB_HOST'),
        port: configService.get('DB_PORT'),
        username: configService.get('DB_USERNAME'),
        password: configService.get('DB_PASSWORD'),
        database: configService.get('DB_DATABASE'),
        autoLoadModels: true,
        synchronize: true, // Don't auto-sync schema in production, use migration in PROD
        logging: false,
      }),
      inject: [ConfigService],
    }),
  ],
})
export class DatabaseModule {}

// src/App.module.ts
@Module({
  imports: [
    // Must imported before any module to make sure it is available globally
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: '.env',
    }),
    DatabaseModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
``` 
#### Create Health Check API Endpoint (CRITICAL)

**Backend MUST have `/api/health` endpoint before frontend setup.**

```typescript
// src/health/health.controller.ts
import { Controller, Get } from '@nestjs/common';
import { HealthService } from './health.service';

@Controller('health')
export class HealthController {
  constructor(private readonly healthService: HealthService) {}

  @Get()
  async check() {
    return this.healthService.check();
  }
}

// src/health/health.service.ts
import { Injectable } from '@nestjs/common';
import { Sequelize } from 'sequelize-typescript';

@Injectable()
export class HealthService {
  constructor(private sequelize: Sequelize) {}

  async check() {
    let dbStatus = 'disconnected';
    try {
      await this.sequelize.authenticate();
      dbStatus = 'connected';
    } catch (error) {
      dbStatus = 'error';
    }

    return {
      status: 'ok',
      timestamp: new Date().toISOString(),
      database: {
        status: dbStatus,
      },
    };
  }
}

// src/health/health.module.ts
import { Module } from '@nestjs/common';
import { HealthController } from './health.controller';
import { HealthService } from './health.service';

@Module({
  controllers: [HealthController],
  providers: [HealthService],
})
export class HealthModule {}

// Add to app.module.ts imports: HealthModule
```

**Verify backend health:**
```bash
curl http://localhost:3000/api/health
# Expected: { "status": "ok", "timestamp": "...", "database": { "status": "connected" } }
```

#### Create Health API Contract (CRITICAL)

**Backend MUST create API contract for health endpoint so frontend knows the response shape.**

Write to `migration/api-contracts/core/health.api.md`: check `migration/api-contracts/readme.md` to know contract standard.

### TypeScript Types (Frontend)
```typescript
interface HealthResponse {
  status: string;
  timestamp: string;
  database: {
    status: 'connected' | 'disconnected' | 'error';
  };
}
```

### Usage Example
```typescript
const response = await apiService.get<HealthResponse>('/health');
console.log(response.database.status); // "connected"
```

### 8.2 Frontend Foundation Setup (use react-migration-expert skill)

**CRITICAL**: Frontend foundation must be complete before ANY feature frontend work begins.

Use Sub-Agent with react-migration-expert skill:

```
Task (react-migration-expert): "Setup frontend foundation for modern/frontend.
Read and implement ALL requirements from .claude/templates/frontend-foundation-setup.md.
Install linting and formatting tools.
Configure package.json scripts for type-check, lint, and format.
Verify health check works by starting both backend and frontend.
Return ONLY: paths created + verification result."
```

**Sub-agent MUST:**
1. Read `.claude/templates/frontend-foundation-setup.md` completely
2. Follow ALL implementation steps in the template
3. Install dependencies listed in template (including ESLint, Prettier)
4. **Install linting/formatting tools:**
   ```bash
   npm install -D eslint prettier
   npm install -D @typescript-eslint/eslint-plugin @typescript-eslint/parser
   npm install -D eslint-plugin-react-hooks eslint-plugin-react-refresh
   ```
5. **Configure package.json scripts:**
   ```json
   {
     "scripts": {
       "dev": "vite",
       "build": "tsc && vite build",
       "preview": "vite preview",
       "lint": "eslint . --ext ts,tsx --report-unused-disable-directives --max-warnings 0",
       "lint:fix": "eslint . --ext ts,tsx --fix",
       "format": "prettier --write \"src/**/*.{ts,tsx,json,css,scss,md}\"",
       "format:check": "prettier --check \"src/**/*.{ts,tsx,json,css,scss,md}\"",
       "type-check": "tsc --noEmit",
       "test": "vitest",
       "test:coverage": "vitest run --coverage"
     }
   }
   ```
6. **Create .eslintrc.cjs:**
   ```javascript
   module.exports = {
     root: true,
     env: { browser: true, es2020: true },
     extends: [
       'eslint:recommended',
       'plugin:@typescript-eslint/recommended',
       'plugin:react-hooks/recommended',
     ],
     ignorePatterns: ['dist', '.eslintrc.cjs'],
     parser: '@typescript-eslint/parser',
     plugins: ['react-refresh'],
     rules: {
       'react-refresh/only-export-components': [
         'warn',
         { allowConstantExport: true },
       ],
       '@typescript-eslint/no-unused-vars': [
         'error',
         { argsIgnorePattern: '^_' },
       ],
     },
   };
   ```
7. **Create .prettierrc:**
   ```json
   {
     "semi": true,
     "singleQuote": true,
     "tabWidth": 2,
     "trailingComma": "es5",
     "printWidth": 100,
     "arrowParens": "always"
   }
   ```
8. Create all files/folders specified in foundation template
9. **Verify linting works:**
   ```bash
   cd modern/frontend
   npm run type-check  # Should pass with no errors
   npm run lint        # Should pass with no errors
   ```
10. Verify acceptance criteria from template
11. Return confirmation with file paths created

## Phase 9: Update Manifest with Foundation Status

```markdown
# In migration/manifest.md
BACKEND_FOUNDATION_COMPLETE: true
FRONTEND_FOUNDATION_COMPLETE: true
```

**Foundation is complete when:**
- Backend: Health endpoint returns `{ status: "ok", database: "connected" }`
- Frontend: /health page shows "connected" to backend

## Phase 10: Commit

```bash
git add migration/ modern/ docker-compose.yml
git commit -m "chore: initialize migration framework"
```

## Output

```
MIGRATION INITIALIZED
Modules: N | Features: N
Next: /migrate-status or /migrate-next
```
