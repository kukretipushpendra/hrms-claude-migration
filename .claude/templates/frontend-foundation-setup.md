# Feature: frontend-setup

## Identity
MODULE: core
FEATURE: frontend-setup
TYPE: foundation
PRIORITY: 1 (highest - must be first frontend foundation feature)
CREATED: {date}

## Prerequisites
- Backend foundation complete (health endpoint at `/api/health` working)
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

Sets up the **working skeleton** of the Vue.js app:

1. **Vue Router** - Routing configured
2. **Reusable Axios Service** - Client, interceptors, typed methods
3. **Pinia Store** - State management setup
4. **Environment Config** - .env for API URL
5. **Base Types** - API response types
6. **Health Check on Home** - Immediate backend connection verification
7. **Error Handling** - Global error handling setup

## Implementation

### 1. Dependencies
```bash
cd modern/frontend
npm install vue-router@4 pinia axios
npm install vee-validate @vee-validate/zod zod
```

### 2. Environment
```env
# .env.development
VITE_API_URL=http://localhost:3000/api
```

### 3. Reusable Axios Service (CRITICAL)

```typescript
// src/services/api/axios-client.ts
import axios, { AxiosInstance, AxiosResponse, AxiosError, InternalAxiosRequestConfig } from 'axios';

const axiosClient: AxiosInstance = axios.create({
  baseURL: import.meta.env.VITE_API_URL,
  timeout: 15000,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Request interceptor - Add auth token
axiosClient.interceptors.request.use(
  (config: InternalAxiosRequestConfig) => {
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
import type { AxiosRequestConfig } from 'axios';

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
  statusCode: number;
  message: string;
  result: T;
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
    status: 'connected' | 'disconnected' | 'error';
  };
}

export interface PaginatedResponse<T> {
  data: T[];
  meta: {
    total: number;
    page: number;
    limit: number;
    totalPages: number;
  };
}
```

### 5. Pinia Store Setup

```typescript
// src/stores/index.ts
import { createPinia } from 'pinia';

export const pinia = createPinia();
```

```typescript
// src/stores/app.store.ts
import { defineStore } from 'pinia';

interface AppState {
  isLoading: boolean;
  error: string | null;
}

export const useAppStore = defineStore('app', {
  state: (): AppState => ({
    isLoading: false,
    error: null,
  }),

  actions: {
    setLoading(loading: boolean) {
      this.isLoading = loading;
    },
    setError(error: string | null) {
      this.error = error;
    },
    clearError() {
      this.error = null;
    },
  },
});
```

### 6. Vue Router Setup

```typescript
// src/router/index.ts
import { createRouter, createWebHistory, RouteRecordRaw } from 'vue-router';

const routes: RouteRecordRaw[] = [
  {
    path: '/',
    name: 'Home',
    component: () => import('@/views/HomeView.vue'),
  },
  {
    path: '/health',
    name: 'Health',
    component: () => import('@/views/HealthView.vue'),
  },
  {
    path: '/:pathMatch(.*)*',
    name: 'NotFound',
    component: () => import('@/views/NotFoundView.vue'),
  },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;
```

### 7. useHealthCheck Composable

```typescript
// src/composables/useHealthCheck.ts
import { ref, onMounted } from 'vue';
import { apiService } from '@/services/api';
import type { HealthResponse } from '@/types/api.types';

export function useHealthCheck() {
  const health = ref<HealthResponse | null>(null);
  const loading = ref(true);
  const error = ref<string | null>(null);

  const checkHealth = async () => {
    try {
      loading.value = true;
      error.value = null;
      health.value = await apiService.get<HealthResponse>('/health');
      console.log('[Health Check] Backend connected:', health.value);
    } catch (err) {
      error.value = err instanceof Error ? err.message : 'Health check failed';
      console.error('[Health Check] Backend error:', err);
    } finally {
      loading.value = false;
    }
  };

  onMounted(() => {
    checkHealth();
  });

  return { health, loading, error, checkHealth };
}
```

### 8. Home View

```vue
<!-- src/views/HomeView.vue -->
<script setup lang="ts">
import { useHealthCheck } from '@/composables/useHealthCheck';

const { health, loading, error } = useHealthCheck();
</script>

<template>
  <div class="home-container">
    <h1>Welcome to HRMS</h1>

    <div v-if="loading" class="status-card loading">
      Checking backend connection...
    </div>

    <div v-else-if="error" class="status-card error">
      <p>Backend connection failed</p>
      <p class="error-message">{{ error }}</p>
    </div>

    <div v-else-if="health" class="status-card success">
      <p>Backend: {{ health.status }}</p>
      <p>Database: {{ health.database.status }}</p>
    </div>
  </div>
</template>

<style scoped>
.home-container {
  padding: 2rem;
  max-width: 800px;
  margin: 0 auto;
}

.status-card {
  padding: 1rem;
  border-radius: 8px;
  margin-top: 1rem;
}

.status-card.loading {
  background-color: #f0f0f0;
}

.status-card.error {
  background-color: #fee2e2;
  color: #dc2626;
}

.status-card.success {
  background-color: #dcfce7;
  color: #16a34a;
}

.error-message {
  font-size: 0.875rem;
  margin-top: 0.5rem;
}
</style>
```

### 9. Health View

```vue
<!-- src/views/HealthView.vue -->
<script setup lang="ts">
import { useHealthCheck } from '@/composables/useHealthCheck';

const { health, loading, error, checkHealth } = useHealthCheck();
</script>

<template>
  <div class="health-container">
    <h1>System Health</h1>

    <div v-if="loading" class="loading">
      Checking health...
    </div>

    <div v-else-if="error" class="error">
      <p>Health check failed: {{ error }}</p>
      <button @click="checkHealth">Retry</button>
    </div>

    <div v-else-if="health" class="health-info">
      <table>
        <tr>
          <td>Status:</td>
          <td>{{ health.status }}</td>
        </tr>
        <tr>
          <td>Database:</td>
          <td :class="health.database.status">{{ health.database.status }}</td>
        </tr>
        <tr>
          <td>Timestamp:</td>
          <td>{{ health.timestamp }}</td>
        </tr>
      </table>
    </div>
  </div>
</template>

<style scoped>
.health-container {
  padding: 2rem;
  max-width: 600px;
  margin: 0 auto;
}

table {
  width: 100%;
  border-collapse: collapse;
}

td {
  padding: 0.5rem;
  border-bottom: 1px solid #eee;
}

.connected {
  color: #16a34a;
  font-weight: bold;
}

.disconnected,
.error {
  color: #dc2626;
  font-weight: bold;
}

button {
  margin-top: 1rem;
  padding: 0.5rem 1rem;
  background-color: #3b82f6;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

button:hover {
  background-color: #2563eb;
}
</style>
```

### 10. 404 Not Found View

```vue
<!-- src/views/NotFoundView.vue -->
<script setup lang="ts">
import { useRouter } from 'vue-router';

const router = useRouter();

const goHome = () => {
  router.push('/');
};
</script>

<template>
  <div class="not-found-container">
    <h1>404</h1>
    <p>Page not found</p>
    <button @click="goHome">Go Home</button>
  </div>
</template>

<style scoped>
.not-found-container {
  text-align: center;
  padding: 4rem 2rem;
}

h1 {
  font-size: 6rem;
  margin: 0;
  color: #6b7280;
}

p {
  font-size: 1.5rem;
  color: #9ca3af;
  margin: 1rem 0 2rem;
}

button {
  padding: 0.75rem 1.5rem;
  background-color: #3b82f6;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 1rem;
}

button:hover {
  background-color: #2563eb;
}
</style>
```

### 11. Main Entry Point

```typescript
// src/main.ts
import { createApp } from 'vue';
import App from './App.vue';
import router from './router';
import { pinia } from './stores';

const app = createApp(App);

app.use(pinia);
app.use(router);

app.mount('#app');
```

### 12. App.vue

```vue
<!-- src/App.vue -->
<script setup lang="ts">
import { RouterView } from 'vue-router';
</script>

<template>
  <RouterView />
</template>

<style>
/* Global styles can be added here or imported */
* {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}

body {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen,
    Ubuntu, Cantarell, 'Fira Sans', 'Droid Sans', 'Helvetica Neue', sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
</style>
```

### 13. Folder Structure
```
src/
├── assets/
├── components/
├── composables/
│   └── useHealthCheck.ts
├── router/
│   └── index.ts
├── services/
│   └── api/
│       ├── index.ts
│       ├── axios-client.ts
│       └── api.service.ts
├── stores/
│   ├── index.ts
│   └── app.store.ts
├── types/
│   └── api.types.ts
├── views/
│   ├── HomeView.vue
│   ├── HealthView.vue
│   └── NotFoundView.vue
├── App.vue
└── main.ts
```

### 14. Vite Path Alias Configuration

```typescript
// vite.config.ts
import { defineConfig } from 'vite';
import vue from '@vitejs/plugin-vue';
import { fileURLToPath, URL } from 'node:url';

export default defineConfig({
  plugins: [vue()],
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url)),
    },
  },
});
```

```json
// tsconfig.json - Add to compilerOptions
{
  "compilerOptions": {
    "baseUrl": ".",
    "paths": {
      "@/*": ["src/*"]
    }
  }
}
```

## Acceptance Criteria

### Setup
- [ ] Vue Router installed and configured
- [ ] Pinia installed and configured
- [ ] Axios installed
- [ ] Environment variable VITE_API_URL set
- [ ] Path alias `@` configured in Vite and TypeScript

### Reusable Axios Service
- [ ] `axios-client.ts` - Axios instance with baseURL, timeout, interceptors
- [ ] `api.service.ts` - Typed wrapper methods (get, post, put, patch, delete)
- [ ] Request interceptor adds auth token from localStorage
- [ ] Response interceptor handles 401 → redirect to /login

### Views
- [ ] HomeView.vue - Shows health check status
- [ ] HealthView.vue - Detailed health information
- [ ] NotFoundView.vue - 404 page

### Composables
- [ ] useHealthCheck.ts - Reusable health check logic

### Verification
```bash
# 1. Start backend (must have /api/health endpoint)
cd modern/backend && npm run dev

# 2. Start frontend
cd modern/frontend && npm run dev

# 3. Open http://localhost:5173
# Expected: See "Backend: ok" and "Database: connected"

# 4. Open http://localhost:5173/health
# Expected: See detailed health information

# 5. Open http://localhost:5173/random-page
# Expected: See 404 page

# 6. Check browser DevTools → Network tab
# Expected: See GET request to /api/health with 200 response
```

## Attempts
ATTEMPT_COUNT: 0
