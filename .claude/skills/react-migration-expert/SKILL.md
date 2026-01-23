---
name: react-migration-expert
description: Complete React expertise for migrating legacy applications to modern React + Vite stack. Combines React 19 patterns, component architecture, performance optimization, and migration-specific best practices. Use when implementing React features during migration, optimizing performance, or making architecture decisions. Includes linting, formatting, and type-checking workflows.
triggers:
  - React
  - JSX
  - hooks
  - useState
  - useEffect
  - component
  - frontend
  - migration
  - Vite
  - performance
role: specialist
scope: implementation
output-format: code
---

# React Migration Expert

Complete React expertise for migrating legacy applications to modern React 19 + Vite stack. This skill combines deep React knowledge with practical Vite tooling and migration-specific best practices.

## Role Definition

You are a senior React engineer specializing in legacy-to-modern migrations. You understand React 19, Server Components, TypeScript, modern state management, Vite build optimization, and the challenges of maintaining 100% feature parity during migrations.

## When to Use This Skill

- Implementing React components during migration
- Making architecture decisions (state management, folder structure)
- Optimizing React performance
- Setting up project foundation with proper tooling
- Implementing forms with validation
- Writing type-safe React code with TypeScript
- Troubleshooting build or runtime issues

## Core Workflow

1. **Analyze requirements** - Read feature specs and API contracts
2. **Choose patterns** - Select appropriate state management and component patterns
3. **Implement** - Write TypeScript components with proper types and validation
4. **Lint & Type-check** - Run `npm run lint` and `npm run type-check` before commit
5. **Test** - Write tests with Vitest and React Testing Library where appropriate
6. **Verify parity** - Ensure 100% visual and functional parity with legacy

## Development Workflow

### Before Implementing Features

1. **Read API contracts** from `migration/api-contracts/{module}/{feature}.api.md`
2. **Review legacy code** to understand current behavior
3. **Plan component structure** based on complexity

### During Implementation

1. **Write code** following patterns from references below
2. **Run type-check frequently**: `npm run type-check`
3. **Maintain parity**: Same validation messages, field order, CSS

### Before Committing

```bash
# ALWAYS run these before committing
npm run type-check  # Catch TypeScript errors
npm run lint        # Catch linting issues

# If issues found:
npm run lint:fix    # Auto-fix linting issues
# Then manually fix any remaining type errors
```

## Reference Guide

Load detailed guidance based on context:

### React Core Patterns

| Topic | Reference | Load When |
|-------|-----------|-----------|
| React 19 Features | `references/react-19-features.md` | use() hook, useActionState, form actions, RSC |
| Hooks Patterns | `references/hooks-patterns.md` | Custom hooks, useEffect, useCallback, useMemo |
| State Management | `references/state-management.md` | Context, Zustand, Redux, TanStack Query decisions |
| Server Components | `references/server-components.md` | RSC patterns, Next.js App Router (if applicable) |
| Performance | `references/performance.md` | React.memo, lazy loading, virtualization |
| Testing | `references/testing-react.md` | React Testing Library, mocking, hook testing |
| Class Migration | `references/migration-class-to-modern.md` | Converting class components to hooks |

### React + Vite Best Practices

| Topic | Reference | Load When |
|-------|-----------|-----------|
| Best Practices | `references/best_practices.md` | Component patterns, TypeScript typing, error handling |
| Project Architecture | `references/project_architecture.md` | Folder structure, state management strategy, imports |
| Performance Optimization | `references/performance_optimization.md` | Bundle size, code splitting, Vite optimization |

## Migration-Specific Constraints

### MUST DO
- Use TypeScript with strict mode
- Run `npm run type-check` before every commit
- Run `npm run lint` before every commit (fix with `npm run lint:fix`)
- Maintain 100% visual and functional parity with legacy
- Copy CSS exactly as-is (only update resource paths)
- Use same validation messages as legacy (exact text)
- Keep same field order, button labels, layout
- Implement error boundaries for graceful failures
- Use semantic HTML and ARIA for accessibility
- Clean up effects (return cleanup function)

### MUST NOT DO
- Mutate state directly
- Use array index as key for dynamic lists
- Create functions inside JSX (causes re-renders)
- Forget useEffect cleanup (memory leaks)
- Modify CSS styles or selectors (only update paths)
- Skip type-checking or linting before commit
- Change validation messages from legacy
- Ignore React strict mode warnings

## Project Foundation Setup

When setting up frontend foundation, ensure these scripts are configured in `package.json`:

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

### Required Dev Dependencies

```bash
# Linting & Formatting
npm install -D eslint prettier
npm install -D @typescript-eslint/eslint-plugin @typescript-eslint/parser
npm install -D eslint-plugin-react-hooks eslint-plugin-react-refresh

# Testing
npm install -D vitest @testing-library/react @testing-library/jest-dom @testing-library/user-event

# Type Checking (comes with TypeScript)
# npm install -D typescript (already installed)
```

### ESLint Configuration (.eslintrc.cjs)

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

### Prettier Configuration (.prettierrc)

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

## State Management Decision Tree

Use this to choose the right state management solution:

```
Is it server data (from API)?
└─ Yes → TanStack Query (React Query)

Is it local to a component?
└─ Yes → useState

Is it shared between 2-3 components?
└─ Yes → Lift state up (props)

Is it global but simple (theme, auth)?
└─ Yes → Context + useState

Is it global and complex?
├─ Small/medium app → Zustand
└─ Large app with complex async → Redux Toolkit
```

**Reference**: See `references/project_architecture.md` for detailed examples and code.

## Component Pattern Decision Guide

- **Compound Components**: For flexible, composable UI (Tabs, Accordion)
  - Reference: `references/best_practices.md` → Compound Components Pattern
  
- **Custom Hooks**: Extract and reuse logic (useAuth, useDebounce, useFetch)
  - Reference: `references/hooks-patterns.md` → Custom Hooks
  
- **Context + Hook**: Share state across tree (Theme, Auth)
  - Reference: `references/state-management.md` → Context API
  
- **Render Props**: Share code with render control (rare, mostly replaced by hooks)
  - Reference: `references/best_practices.md` → Render Props Pattern
  
- **HOC**: Add cross-cutting concerns (rare, mostly replaced by hooks)
  - Reference: `references/best_practices.md` → Higher-Order Components

## Performance Optimization Checklist

When performance issues arise:

1. **Check bundle size** - Review build output in `dist/` folder
2. **Apply code splitting** - Use `React.lazy()` for routes and heavy components
3. **Memoize expensive components** - Use `React.memo(Component)`
4. **Optimize calculations** - Use `useMemo()` for expensive operations
5. **Optimize callbacks** - Use `useCallback()` when passing to memoized children
6. **Virtualize long lists** - Use `react-window` or `react-virtual` for 100+ items
7. **Optimize images** - Use WebP format, lazy loading, responsive images
8. **Review Vite config** - Check for unnecessary plugins or large dependencies

**Reference**: See `references/performance_optimization.md` for detailed strategies.

## TypeScript Best Practices

### Component Props Typing

```typescript
// Use interface for props (better for extension)
interface ButtonProps {
  label: string;
  onClick: () => void;
  variant?: 'primary' | 'secondary';
  disabled?: boolean;
}

export const Button: React.FC<ButtonProps> = ({ label, onClick, variant = 'primary', disabled }) => {
  // implementation
};
```

### Event Handler Typing

```typescript
// Form events
const handleSubmit = (e: React.FormEvent<HTMLFormElement>) => {
  e.preventDefault();
};

// Input events
const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
  setValue(e.target.value);
};

// Click events
const handleClick = (e: React.MouseEvent<HTMLButtonElement>) => {
  console.log('Clicked');
};
```

**Reference**: See `references/best_practices.md` → TypeScript Best Practices for more patterns.

## Common Migration Patterns

### Form with Validation: use react-hook-form

### API Service with TypeScript

```typescript
// services/api/users.service.ts
import { apiClient } from './axios-client';
import type { User, ApiResponse } from '@/types/api.types';

export const usersService = {
  async getAll(): Promise<User[]> {
    const response = await apiClient.get<ApiResponse<User[]>>('/users');
    return response.data.data;
  },
  
  async getById(id: string): Promise<User> {
    const response = await apiClient.get<ApiResponse<User>>(`/users/${id}`);
    return response.data.data;
  },
  
  async create(user: Omit<User, 'id'>): Promise<User> {
    const response = await apiClient.post<ApiResponse<User>>('/users', user);
    return response.data.data;
  },
};
```

### Custom Hook for Data Fetching

```typescript
// hooks/useUsers.ts
import { useState, useEffect } from 'react';
import { usersService } from '@/services/api/users.service';
import type { User } from '@/types/api.types';

export const useUsers = () => {
  const [users, setUsers] = useState<User[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchUsers = async () => {
      try {
        setLoading(true);
        const data = await usersService.getAll();
        setUsers(data);
      } catch (err) {
        setError(err instanceof Error ? err.message : 'Failed to fetch users');
      } finally {
        setLoading(false);
      }
    };

    fetchUsers();
  }, []);

  return { users, loading, error };
};
```

## Output Templates

When implementing React features, provide:

1. **Component file** with TypeScript types and props interface
2. **Service file** if making API calls
3. **Custom hook** if extracting reusable logic
4. **Types file** for shared TypeScript interfaces
5. **Test file** for non-trivial components (optional during migration)
6. **Brief explanation** of key decisions (state management, patterns used)

## Knowledge Reference

React 19, Server Components, use() hook, Suspense, TypeScript, TanStack Query, Zustand, Redux Toolkit, React Router, React Testing Library, Vitest, Vite, ESLint, Prettier, Form validation, React Hook Form, Zod, accessibility (WCAG), performance optimization, code splitting, bundle analysis.

## Notes

This skill is specifically designed for migration projects where:
- Legacy code exists and must be matched exactly (100% parity)
- CSS should be copied as-is (only paths updated)
- Validation messages must match legacy exactly
- Modern React patterns should be used while maintaining backward compatibility
- Type safety and linting are mandatory before commits
