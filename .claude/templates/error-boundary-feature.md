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

2. **Create React ErrorBoundary**
   - Class component with componentDidCatch
   - Generate request ID (UUID)
   - Log errors appropriately

3. **Match Legacy Error UI**
   - Same HTML structure (converted to JSX)
   - Same CSS classes
   - Same conditional logic

### File Structure
```
modern/frontend/src/
├── components/
│   └── ErrorBoundary/
│       ├── ErrorBoundary.tsx     # Class component
│       └── ErrorFallback.tsx     # Error UI (matches Error.cshtml)
└── pages/
    └── Error/
        └── ErrorPage.tsx         # /error route
```

### Environment Detection
```typescript
const isDevelopment = import.meta.env.DEV;
// Show stack trace only in development
```

## Acceptance Criteria

### ErrorBoundary Component
- [ ] Class-based component with componentDidCatch
- [ ] Wraps entire app in App.tsx
- [ ] Generates unique request ID

### Error Display
- [ ] Fallback UI matches legacy Error.cshtml structure
- [ ] Development mode shows technical details
- [ ] Production mode shows user-friendly message
- [ ] Request ID displayed when applicable

### Navigation
- [ ] "Go Home" link works (uses React Router)
- [ ] Error route accessible at /error

### Logging
- [ ] Errors logged to console in development
- [ ] Error boundary catches component errors

## Attempts
ATTEMPT_COUNT: 0
