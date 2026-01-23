# Feature: frontend-setup

## Identity
MODULE: core
FEATURE: frontend-setup
TYPE: foundation
PRIORITY: 1 (highest - must be first frontend foundation feature)
CREATED: {date}

## Prerequisites
- Backend foundation complete (health endpoint at `/health` working)
- `modern/frontend` scaffolded by migrate-init

## Status
CURRENT: ready-for-dev
BACKEND: not-applicable
FRONTEND: pending
FOUNDATION_QA: pending

## Dependencies
DEPENDS_ON: []
BLOCKS: [layout-and-styles, auth-pages, error-pages]

## Scope

Sets up the **working skeleton** of the React app:

1. **React Router** - Routing configured
2. **Reusable Axios Service** - Client, interceptors, typed methods
3. **Environment Config** - .env for API URL
4. **Base Types** - API response types
5. **Health Check on Home** - Immediate backend connection verification
6. **Error Boundary Setup** - Verify Error Boundary is setup

## Implementation

### 1. Dependencies
```bash
cd modern/frontend
npm install react-router-dom axios
```

### 2. Environment
```env
# .env.development
VITE_API_URL=http://localhost:3000/api
```

### 3. Reusable Axios Service (CRITICAL)

```typescript
// src/services/api/axios-client.ts
import axios, { AxiosInstance, AxiosRequestConfig, AxiosResponse, AxiosError } from 'axios';

const axiosClient: AxiosInstance = axios.create({
  baseURL: import.meta.env.VITE_API_URL,
  timeout: 15000,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Request interceptor - Add auth token
axiosClient.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('token');
    if (token && config.headers) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => Promise.reject(error)
);

// Response interceptor - Handle errors globally
axiosClient.interceptors.response.use(
  (response: AxiosResponse) => response,
  (error: AxiosError) => {
    if (error.response?.status === 401) {
      localStorage.removeItem('token');
      window.location.href = '/login';
    }
    return Promise.reject(error);
  }
);

export default axiosClient;
```

```typescript
// src/services/api/api.service.ts
import axiosClient from './axios-client';
import { AxiosRequestConfig } from 'axios';

export const apiService = {
  get: <T>(url: string, config?: AxiosRequestConfig) =>
    axiosClient.get<T>(url, config).then((res) => res.data),

  post: <T>(url: string, data?: unknown, config?: AxiosRequestConfig) =>
    axiosClient.post<T>(url, data, config).then((res) => res.data),

  put: <T>(url: string, data?: unknown, config?: AxiosRequestConfig) =>
    axiosClient.put<T>(url, data, config).then((res) => res.data),

  patch: <T>(url: string, data?: unknown, config?: AxiosRequestConfig) =>
    axiosClient.patch<T>(url, data, config).then((res) => res.data),

  delete: <T>(url: string, config?: AxiosRequestConfig) =>
    axiosClient.delete<T>(url, config).then((res) => res.data),
};

export default apiService;
```

```typescript
// src/services/api/index.ts
export { default as axiosClient } from './axios-client';
export { default as apiService } from './api.service';
```

### 4. Base Types

```typescript
// src/types/api.types.ts
export interface ApiResponse<T> {
  data: T;
  message?: string;
  success: boolean;
}

export interface ApiError {
  message: string;
  statusCode: number;
  error?: string;
}

export interface HealthResponse {
  status: string;
  timestamp: string;
  database: {
    status: string;
  };
}

export interface PaginatedResponse<T> {
  data: T[];
  meta: {
    total: number;
    page: number;
    pageSize: number;
    totalPages: number;
  };
}
```

### 5. useHealthCheck Hook

**Create a reusable hook for health checking. No UI needed - verify in Network tab.**

```typescript
// src/hooks/useHealthCheck.ts
import { useEffect } from 'react';
import { apiService } from '../services/api';
import type { HealthResponse } from '../types/api.types';

export function useHealthCheck() {
  useEffect(() => {
    apiService.get<HealthResponse>('/health')
      .then((data) => console.log('[Health Check] Backend connected:', data))
      .catch((err) => console.error('[Health Check] Backend error:', err));
  }, []);
}
```

### 6. App.tsx

```typescript
// src/App.tsx
import { BrowserRouter, Routes, Route } from 'react-router-dom';
import { useHealthCheck } from './hooks/useHealthCheck';

function App() {
  // Health check on app load - verify in Network tab
  useHealthCheck();

  return (
    <BrowserRouter>
      <Routes>
       // Routes
      </Routes>
    </BrowserRouter>
  );
}

export default App;
```

### 7. Folder Structure
```
src/
├── components/
│   └── ErrorBoundary.tsx
├── hooks/
│   └── useHealthCheck.ts
├── pages/
│   └── (future pages here)
├── services/
│   └── api/
│       ├── index.ts
│       ├── axios-client.ts
│       └── api.service.ts
├── types/
│   └── api.types.ts
├── utils/
├── context/
├── App.tsx
└── main.tsx
```

## Acceptance Criteria

### Setup
- [ ] React Router installed and configured
- [ ] Axios installed
- [ ] Environment variable VITE_API_URL set

### Reusable Axios Service
- [ ] `axios-client.ts` - Axios instance with baseURL, timeout, interceptors
- [ ] `api.service.ts` - Typed wrapper methods (get, post, put, patch, delete)
- [ ] Request interceptor adds auth token from localStorage
- [ ] Response interceptor handles 401 → redirect to /login

### Health Check (No UI - Network Tab Verification)
- [ ] App calls `/health` endpoint on load (in useEffect)
- [ ] Console logs success: `[Health Check] Backend connected: {...}`
- [ ] Console logs error: `[Health Check] Backend error: ...`

### Verification
```bash
# 1. Start backend (must have /api/health endpoint)
cd modern/backend && npm run start:dev

# 2. Start frontend
cd modern/frontend && npm run dev

# 3. Open http://localhost:5173
# 4. Open browser DevTools → Network tab
# Expected: See GET request to /api/health with 200 response

# 5. Check Console tab
# Expected: "[Health Check] Backend connected: {status: 'ok', ...}"
```

## Attempts
ATTEMPT_COUNT: 0
