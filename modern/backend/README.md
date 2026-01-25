# Node.js Backend (Phase 2)

This backend will be implemented **AFTER** frontend migration is complete.

## Current Status
- **Phase:** Not started
- **Waiting for:** Frontend migration completion

## During Phase 1 (Frontend Migration)
The Vue.js frontend connects to the existing .NET backend at:
```
http://localhost:5281
```

## Phase 2 (Backend Migration)
After frontend migration is complete:
1. Implement Node.js/Express API endpoints
2. Connect to same SQL Server database using `mssql` driver
3. Match exact response shapes from .NET backend
4. Gradually switch frontend to new backend

## Tech Stack (Planned)
- Node.js + Express
- TypeScript
- SQL Server (mssql driver)
- Zod for validation
- JWT authentication (same tokens as .NET)
