# Tech Stack Configuration

## Migration Approach
APPROACH: Frontend First
PHASE: 1 - Frontend Migration
CONFIGURED_DATE: 2026-01-23

## Legacy Stack (Source)

| Layer | Technology | Details |
|-------|------------|---------|
| Frontend | React 18 + TypeScript | Vite, SWR, Axios |
| UI Framework | Material-UI v6 | Emotion CSS-in-JS |
| State Management | Zustand | localStorage persistence |
| Forms | React Hook Form + Yup | Schema validation |
| Routing | React Router v6 | Lazy loading |
| Backend | .NET 8.0 WebAPI | Dapper, JWT, Quartz.NET |
| Database | SQL Server | 72 tables |
| Auth | JWT + Azure MSAL SSO | Refresh tokens |

## Modern Stack (Target)

| Layer | Technology | Details |
|-------|------------|---------|
| Frontend | Vue.js 3 + TypeScript | Vite build tool |
| UI Framework | Vuetify 3 | Material Design for Vue |
| State Management | Pinia | Official Vue store |
| Forms | VeeValidate + Zod | TypeScript-first validation |
| Routing | Vue Router 4 | Composition API support |
| Backend | Node.js + Express | Phase 2 - after frontend |
| Database | SQL Server (same) | No migration needed |

## Frontend First Strategy

```
┌─────────────────────────────────────────────────────────────────────────┐
│ PHASE 1: FRONTEND MIGRATION (Current)                                   │
│ Vue.js frontend connects to EXISTING .NET backend                       │
│ API URL: http://localhost:5281                                          │
└─────────────────────────────────────────────────────────────────────────┘
                                    ↓
┌─────────────────────────────────────────────────────────────────────────┐
│ PHASE 2: BACKEND MIGRATION (Later)                                      │
│ Migrate .NET APIs to Node.js/Express                                    │
│ Same SQL Server database (no DB migration)                              │
└─────────────────────────────────────────────────────────────────────────┘
```

## Frontend Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| STATE_MANAGEMENT | Pinia | Official Vue store, TypeScript native |
| FORM_HANDLING | VeeValidate + Zod | Vue-native, TypeScript-first |
| UI_FRAMEWORK | Vuetify 3 | MUI equivalent for Vue |
| BUILD_TOOL | Vite | Fast HMR, modern bundling |
| TESTING | Vitest + Vue Test Utils | Vite-native testing |

## Package Dependencies

### Core
```json
{
  "vue": "^3.4",
  "vue-router": "^4",
  "pinia": "^2",
  "axios": "^1"
}
```

### UI & Forms
```json
{
  "vuetify": "^3",
  "@mdi/font": "^7",
  "vee-validate": "^4",
  "@vee-validate/zod": "^4",
  "zod": "^3"
}
```

### Dev Dependencies
```json
{
  "vitest": "^1",
  "@vue/test-utils": "^2",
  "eslint": "^8",
  "eslint-plugin-vue": "^9",
  "prettier": "^3",
  "@typescript-eslint/eslint-plugin": "^7"
}
```

## React → Vue.js Migration Mappings

| React | Vue 3 |
|-------|-------|
| `useState` | `ref()` |
| `useEffect(() => {}, [])` | `onMounted()` |
| `useEffect(() => {}, [dep])` | `watch(dep, () => {})` |
| `useMemo` | `computed()` |
| Custom Hook | Composable |
| `props.children` | `<slot />` |
| `onClick={fn}` | `@click="fn"` |
| `{condition && <div>}` | `<div v-if="condition">` |
| `.map(item => <X />)` | `<X v-for="item in items" />` |
| Zustand | Pinia |
| React Router | Vue Router |
| React Hook Form | VeeValidate |
| MUI | Vuetify |
