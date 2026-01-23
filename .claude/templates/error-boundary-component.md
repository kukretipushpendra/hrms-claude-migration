# Vue.js Error Handling Component

Vue.js uses `errorHandler` and `onErrorCaptured` for error handling (not class-based ErrorBoundary like React).

## Global Error Handler (main.ts)

```typescript
// src/main.ts
import { createApp } from 'vue';
import App from './App.vue';
import router from './router';
import { pinia } from './stores';

const app = createApp(App);

// Global error handler
app.config.errorHandler = (err, instance, info) => {
  console.error('Global error:', err);
  console.error('Component:', instance);
  console.error('Info:', info);

  // In production, send to error tracking service
  if (import.meta.env.PROD) {
    // sendToErrorTracking(err, instance, info);
  }
};

// Global warning handler (development only)
app.config.warnHandler = (msg, instance, trace) => {
  console.warn('Vue warning:', msg);
  console.warn('Trace:', trace);
};

app.use(pinia);
app.use(router);
app.mount('#app');
```

## Error Boundary Component

```vue
<!-- src/components/ErrorBoundary.vue -->
<script setup lang="ts">
import { ref, onErrorCaptured } from 'vue';
import { useRouter } from 'vue-router';

const router = useRouter();
const hasError = ref(false);
const errorMessage = ref('');
const errorStack = ref('');
const requestId = ref('');

// Generate unique request ID for support tickets
const generateRequestId = () => {
  return `${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;
};

// Capture errors from child components
onErrorCaptured((err: Error, instance, info) => {
  hasError.value = true;
  errorMessage.value = err.message;
  errorStack.value = err.stack || '';
  requestId.value = generateRequestId();

  console.error('ErrorBoundary caught an error:', err);
  console.error('Component info:', info);

  // Return false to prevent error from propagating
  return false;
});

const handleRetry = () => {
  hasError.value = false;
  errorMessage.value = '';
  errorStack.value = '';
};

const goHome = () => {
  hasError.value = false;
  router.push('/');
};

const goToLogin = () => {
  hasError.value = false;
  router.push('/login');
};

const isDevelopment = import.meta.env.DEV;
</script>

<template>
  <div v-if="hasError" class="error-container">
    <h1 class="text-danger">Error.</h1>
    <h2 class="text-danger">An error occurred while processing your request.</h2>

    <!-- Development Mode Details -->
    <template v-if="isDevelopment && errorMessage">
      <h3 class="mt-4">Development Mode</h3>
      <p>
        <strong>Error:</strong> {{ errorMessage }}
      </p>
      <details v-if="errorStack" class="mt-3">
        <summary>Stack Trace</summary>
        <pre class="bg-light p-3 mt-2 stack-trace">{{ errorStack }}</pre>
      </details>
      <p class="mt-3 text-muted">
        <strong>The Development environment shouldn't be enabled for deployed applications.</strong>
        It can result in displaying sensitive information from exceptions to end users.
      </p>
    </template>

    <!-- Request ID (always shown) -->
    <p v-if="requestId" class="mt-3">
      <strong>Request ID:</strong> <code>{{ requestId }}</code>
    </p>

    <!-- Action Buttons -->
    <div class="mt-4">
      <button class="btn btn-primary me-2" @click="handleRetry">
        Try Again
      </button>
      <button class="btn btn-secondary me-2" @click="goHome">
        Go Home
      </button>
      <button class="btn btn-outline-secondary" @click="goToLogin">
        Go to Login
      </button>
    </div>
  </div>

  <!-- Render children when no error -->
  <slot v-else />
</template>

<style scoped>
.error-container {
  padding: 2rem;
  max-width: 800px;
  margin: 2rem auto;
}

.text-danger {
  color: #dc3545;
}

.text-muted {
  color: #6c757d;
}

.mt-3 {
  margin-top: 1rem;
}

.mt-4 {
  margin-top: 1.5rem;
}

.me-2 {
  margin-right: 0.5rem;
}

.bg-light {
  background-color: #f8f9fa;
}

.p-3 {
  padding: 1rem;
}

.stack-trace {
  white-space: pre-wrap;
  word-break: break-word;
  font-size: 0.875rem;
  max-height: 300px;
  overflow-y: auto;
}

.btn {
  padding: 0.5rem 1rem;
  border-radius: 0.25rem;
  cursor: pointer;
  font-size: 1rem;
}

.btn-primary {
  background-color: #0d6efd;
  color: white;
  border: none;
}

.btn-primary:hover {
  background-color: #0b5ed7;
}

.btn-secondary {
  background-color: #6c757d;
  color: white;
  border: none;
}

.btn-secondary:hover {
  background-color: #5c636a;
}

.btn-outline-secondary {
  background-color: transparent;
  color: #6c757d;
  border: 1px solid #6c757d;
}

.btn-outline-secondary:hover {
  background-color: #6c757d;
  color: white;
}

code {
  background-color: #f1f1f1;
  padding: 0.2rem 0.4rem;
  border-radius: 0.25rem;
  font-family: monospace;
}
</style>
```

## Usage in App.vue

```vue
<!-- src/App.vue -->
<script setup lang="ts">
import { RouterView } from 'vue-router';
import ErrorBoundary from '@/components/ErrorBoundary.vue';
</script>

<template>
  <ErrorBoundary>
    <RouterView />
  </ErrorBoundary>
</template>
```

## Key Differences from React ErrorBoundary

| React | Vue.js |
|-------|--------|
| Class component with `componentDidCatch` | `onErrorCaptured` composition API |
| `static getDerivedStateFromError` | Reactive `ref()` state |
| `this.props.children` | `<slot />` |
| `ErrorBoundary` wraps components | `ErrorBoundary` component with slot |
| Catches render errors only | Catches errors from descendant components |

## Notes

- Vue's `onErrorCaptured` only catches errors from **descendant** components
- Errors in the same component or async errors need separate handling
- For async errors (API calls), use try/catch in the component
- Global `app.config.errorHandler` catches errors that escape `onErrorCaptured`
