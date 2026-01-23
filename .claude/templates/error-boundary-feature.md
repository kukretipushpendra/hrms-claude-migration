# Feature: error-boundary

## Identity
MODULE: core
FEATURE: error-boundary
TYPE: error-handling
CREATED: {date}

## Legacy References
FILES:
  - /legacy/*/Pages/Error.cshtml (error page template)
  - /legacy/*/Pages/Error.cshtml.cs (error page model)
  - /legacy/*/Program.cs (error middleware configuration)

## Status
CURRENT: ready-for-dev
BACKEND: not-applicable
FRONTEND: pending
FRONTEND_QA: pending

## Dependencies
DEPENDS_ON: [layout-and-styles]

## Behavior Spec

### Error Display Modes

#### Development Mode (from legacy Program.cs)
SUB-AGENT: Read Program.cs to find dev error handling
- Show error message
- Show stack trace (if available)
- Show request ID
- Show component stack

#### Production Mode (from legacy Error.cshtml)
SUB-AGENT: Read Error.cshtml for user-facing UI
- Show user-friendly message
- Show request ID (for support tickets)
- Provide navigation back home
- Hide technical details

### Legacy Analysis Notes

Sub-agent MUST read these files and extract:

1. **From Error.cshtml:**
   - HTML structure of error page
   - CSS classes used
   - Conditional display logic (ShowRequestId)
   - User-facing messages

2. **From Error.cshtml.cs:**
   - RequestId property logic
   - ShowRequestId logic
   - Any additional error properties

3. **From Program.cs:**
   - Development error handler (UseDeveloperExceptionPage)
   - Production error handler (UseExceptionHandler)
   - Error route configuration

## Implementation Instructions

### For Sub-Agent

1. **Read All Legacy Files Listed Above**
   - Extract error page HTML structure
   - Note RequestId display logic
   - Note development vs production differences

2. **Create Vue.js Error Handling**
   - Use `onErrorCaptured` composition API hook
   - Generate request ID (UUID)
   - Log errors appropriately

3. **Match Legacy Error UI**
   - Same HTML structure (converted to Vue template)
   - Same CSS classes
   - Same conditional logic

### File Structure
```
modern/frontend/src/
├── components/
│   └── ErrorBoundary.vue      # Error boundary component with onErrorCaptured
└── views/
    └── ErrorView.vue          # /error route page
```

### Environment Detection
```typescript
const isDevelopment = import.meta.env.DEV;
// Show stack trace only in development
```

## Vue.js Error Handling Pattern

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

const generateRequestId = () => {
  return `${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;
};

onErrorCaptured((err: Error, instance, info) => {
  hasError.value = true;
  errorMessage.value = err.message;
  errorStack.value = err.stack || '';
  requestId.value = generateRequestId();

  console.error('ErrorBoundary caught an error:', err);
  return false; // Prevent propagation
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
</script>

<template>
  <div v-if="hasError" class="error-container">
    <!-- Error UI matching legacy -->
  </div>
  <slot v-else />
</template>
```

### Global Error Handler (main.ts)

```typescript
// src/main.ts
app.config.errorHandler = (err, instance, info) => {
  console.error('Global error:', err);
  // Send to error tracking in production
};
```

## Acceptance Criteria

### ErrorBoundary Component
- [ ] Uses `onErrorCaptured` composition API
- [ ] Wraps entire app in App.vue using `<slot />`
- [ ] Generates unique request ID

### Error Display
- [ ] Fallback UI matches legacy Error.cshtml structure
- [ ] Development mode shows technical details (via `import.meta.env.DEV`)
- [ ] Production mode shows user-friendly message
- [ ] Request ID displayed when applicable

### Navigation
- [ ] "Go Home" link works (uses Vue Router)
- [ ] Error route accessible at /error

### Logging
- [ ] Errors logged to console in development
- [ ] Global error handler configured in main.ts

## Key Differences from React

| React | Vue.js |
|-------|--------|
| Class component with `componentDidCatch` | `onErrorCaptured` composition API |
| `this.props.children` | `<slot />` |
| `static getDerivedStateFromError` | Reactive `ref()` state |
| Wraps in JSX | Wraps in template |

## Attempts
ATTEMPT_COUNT: 0
