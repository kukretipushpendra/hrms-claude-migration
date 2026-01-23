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
  - /legacy/{path}/DbContext.cs (lines X-Y)
  - /legacy/{path}/DbInitializer.cs (lines X-Y) # IF EXISTS
  - /legacy/{path}/Program.cs (lines X-Y) # Startup init block
  - /legacy/Migrations/{InitialCreate}.cs (lines X-Y)

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
Set up PostgreSQL database connection, Sequelize ORM, and database initialization.

TASKS:
  1. Install Sequelize and PostgreSQL packages
  2. Configure database module with environment variables
  3. Set up database connection pooling
  4. **Create tables on startup** (Sequelize sync or migrations)
  5. **Implement seeder service** (if legacy has seeding)
  6. **Run seeder on app bootstrap** (OnModuleInit)
  7. **Skip seeding if data exists** (match legacy skip logic)
  8. **Setup NestJS Logger** for all database operations

SEEDING REQUIREMENTS (from discovery):
  - Legacy Seeder File: {seederFile}
  - Skip Condition: {e.g., "if Students.Any() return"}
  - Entities to Seed: {list from discovery}
  - Seed on Startup: YES/NO

CONFIGURATION:
  - Database: PostgreSQL
  - ORM: Sequelize with sequelize-typescript
  - Connection: Environment-based (DATABASE_URL or individual vars)

## Implementation Checklist
- [ ] Database module with connection config
- [ ] All models with EXACT table names from legacy migration
- [ ] All models with EXACT column names from legacy migration
- [ ] Seeder service matching legacy DbInitializer
- [ ] Seeder runs on OnModuleInit
- [ ] Seeder skips if data already exists
- [ ] NestJS Logger configured (not console.log)
- [ ] Logs for: connection, table sync, seeding status

## Attempts
ATTEMPT_COUNT: 0
```

## Key Points for Implementation

### 1. Table Names Must Match Legacy EXACTLY
Read the legacy migration file to get exact table names:
- `Student` not `Students`
- `Course` not `Courses`
- Check singular vs plural
- Check PascalCase vs snake_case

### 2. Seeder Service Pattern
```typescript
@Injectable()
export class DbInitializerService implements OnModuleInit {
  private readonly logger = new Logger(DbInitializerService.name);

  async onModuleInit() {
    this.logger.log('Initializing database...');
    await this.createTables();
    await this.seedData();
  }

  async seedData() {
    // Match legacy skip condition exactly
    const count = await this.studentModel.count();
    if (count > 0) {
      this.logger.log('Database already seeded, skipping...');
      return;
    }

    // Seed data matching legacy exactly
    this.logger.log('Seeding database...');
    // ... create entities matching legacy DbInitializer
    this.logger.log('Database seeding completed');
  }
}
```

### 3. Logger Setup in main.ts
```typescript
const app = await NestFactory.create(AppModule, {
  logger: ['error', 'warn', 'log', 'debug', 'verbose'],
});
```

### 3. Create NestJS DB Module and Import in App.module.ts
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

### 4. Common Mistakes to Avoid
- Using wrong table names (plural vs singular)
- Forgetting to run seeder on bootstrap
- Not matching skip condition from legacy
- Using console.log instead of NestJS Logger
- Not logging seeding operations
- Not creating NestJS DB Module
