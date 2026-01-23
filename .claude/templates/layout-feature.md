# Feature: layout-and-styles

## Identity
MODULE: core
FEATURE: layout-and-styles
TYPE: foundation
CREATED: {date}

## Legacy References
FILES:
  - /legacy/*/Pages/Shared/_Layout.cshtml (master layout)
  - /legacy/*/Pages/Shared/_Layout.cshtml.css (layout-specific styles)
  - /legacy/*/wwwroot/css/site.css (site-wide custom styles)
  - /legacy/*/wwwroot/lib/bootstrap/ (CSS framework)

CRITICAL_SECTIONS:
  - _Layout.cshtml: lines X-Y (navbar structure)
  - _Layout.cshtml: lines X-Y (footer structure)
  - _Layout.cshtml.css: all (custom layout styles)
  - site.css/[ANY_OTHER_CSS_USED_IN_LAYOUT]: all (site-wide custom styles)

## Status
CURRENT: ready-for-dev
BACKEND: not-applicable
FRONTEND: pending
FOUNDATION_QA: pending

## Dependencies
DEPENDS_ON: [frontend-setup]

## Behavior Spec

### CSS Framework (from Phase 3 discovery)
FRAMEWORK: {Bootstrap/Foundation/MUI/Tailwind/etc}
VERSION: {exact version, e.g., 5.3.3}
SOURCE: {CDN/npm/libman}
RESET_CSS: {yes/no - if legacy uses reset.css, use it}

### Legacy Analysis Notes

Sub-agent MUST read these files and extract:

1. **From _Layout.cshtml:**
   - Navbar structure and classes
   - Footer structure and classes
   - Container/wrapper classes
   - Navigation links (exact order)

2. **From _Layout.cshtml.css:**
   - Link colors (exact hex values)
   - Button styles
   - Footer positioning
   - Box shadows
   - Custom overrides

3. **From site.css:**
   - Whole css copied and used in modern app as it is

## Implementation Instructions

### For Sub-Agent

1. **Read All Legacy Files Listed Above**
   - Extract exact CSS values (colors, spacing, shadows)
   - Note exact class names used
   - Note responsive breakpoints

2. **Copy CSS Exactly**
   - Create App.css with _Layout.cshtml.css content
   - Create index.css with site.css content
   - If legacy uses reset.css → include reset.css

3. **Build Layout Component**
   - Match HTML structure from _Layout.cshtml
   - Use Vue Router `<RouterLink>` for navigation (NOT `<a>` tags)
   - Match Bootstrap classes exactly

### File Structure
```
modern/frontend/src/
├── main.ts           # Import: bootstrap.css, index.css, App.css
├── assets/
│   ├── index.css     # From site.css
│   └── App.css       # From _Layout.cshtml.css
├── components/
│   └── layout/
│       ├── AppHeader.vue   # Navbar component
│       ├── AppFooter.vue   # Footer component
│       └── AppLayout.vue   # Main layout wrapper
└── App.vue           # Uses AppLayout
```

### Import Order (main.ts)
1. Bootstrap/framework CSS (FIRST)
2. index.css (site-wide)
3. App.css (layout-specific)

## Vue.js Layout Pattern

### AppLayout.vue
```vue
<script setup lang="ts">
import AppHeader from './AppHeader.vue';
import AppFooter from './AppFooter.vue';
</script>

<template>
  <div class="app-layout">
    <AppHeader />
    <main class="container">
      <slot />
    </main>
    <AppFooter />
  </div>
</template>
```

### AppHeader.vue (Navbar)
```vue
<script setup lang="ts">
import { RouterLink } from 'vue-router';
</script>

<template>
  <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
    <div class="container">
      <RouterLink class="navbar-brand" to="/">HRMS</RouterLink>
      <div class="navbar-nav">
        <RouterLink class="nav-link" to="/dashboard">Dashboard</RouterLink>
        <RouterLink class="nav-link" to="/employees">Employees</RouterLink>
      </div>
    </div>
  </nav>
</template>
```

### App.vue Usage
```vue
<script setup lang="ts">
import { RouterView } from 'vue-router';
import AppLayout from '@/components/layout/AppLayout.vue';
</script>

<template>
  <AppLayout>
    <RouterView />
  </AppLayout>
</template>
```

## Acceptance Criteria

### CSS Framework
- [ ] Bootstrap (or legacy framework) installed at exact version
- [ ] CSS imported in correct order in main.ts
- [ ] No react-bootstrap or MUI component libraries (unless legacy uses them)
- [ ] Reset.css included (if legacy uses it)

### Layout Structure
- [ ] Navbar matches legacy structure exactly
- [ ] Navbar links in correct order
- [ ] Container wraps main content
- [ ] Footer matches legacy structure
- [ ] Footer positioned correctly (fixed/static)

### Styling Parity
- [ ] Link colors match legacy (extract exact hex)
- [ ] Button colors match legacy
- [ ] Footer line-height matches legacy
- [ ] Box shadows match legacy
- [ ] Font sizes match responsive breakpoints

### Navigation
- [ ] All links use Vue Router `<RouterLink>` (NOT `<a>` tags)
- [ ] Navigation works without page reload
- [ ] Active link highlighting works

### Vue.js Specifics
- [ ] Layout uses `<slot />` for content projection
- [ ] Components properly structured in /components/layout/
- [ ] `<RouterLink>` used instead of React's `<Link>`

## Key Differences from React

| React | Vue.js |
|-------|--------|
| `<Link to="/">` | `<RouterLink to="/">` |
| `{children}` / `props.children` | `<slot />` |
| `className` | `class` |
| `main.tsx` | `main.ts` |
| JSX syntax | Vue template syntax |
| `onClick={fn}` | `@click="fn"` |

## Attempts
ATTEMPT_COUNT: 0
