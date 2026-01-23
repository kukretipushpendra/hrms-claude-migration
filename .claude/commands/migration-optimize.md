---
description: Optimize migrated application - bundle analysis, performance tuning, production configs
allowed-tools: Read, Glob, Grep, Bash, Write, Edit
---

# Migration Optimize

Apply production optimizations after all features are migrated and tested.

**Run this ONLY after:**
- All features are migrated and QA-approved
- `/migration-finalize` has been executed
- Application is working correctly in dev mode

## What This Command Does

1. **Analyzes bundle size** - Identifies large dependencies and optimization opportunities
2. **Applies Vite optimizations** - Adds manual chunking, minification, compression
3. **Configures TypeScript strictly** - Enables additional type safety checks
4. **Sets up bundle visualization** - Adds tools to monitor bundle size over time

## Process

### Phase 1: Pre-Optimization Baseline

```bash
cd modern/frontend

# Build current version
npm run build

# Record baseline metrics
BUILD_SIZE=$(du -sh dist | cut -f1)
echo "BASELINE_BUILD_SIZE: $BUILD_SIZE" >> ../../migration/optimization-log.md
echo "OPTIMIZATION_DATE: $(date -u +%Y-%m-%d)" >> ../../migration/optimization-log.md
```

### Phase 2: Bundle Analysis

```bash
# Install bundle analyzer if not present
npm list rollup-plugin-visualizer || npm install -D rollup-plugin-visualizer

# Analyze current bundle
npm run build
```

Review `dist/stats.html` (if visualizer is configured) or manually check:
```bash
ls -lh dist/assets/*.js | awk '{print $5, $9}'
```

**Look for:**
- JavaScript files > 500KB (candidates for splitting)
- Duplicate dependencies (check for multiple versions)
- Large libraries that could be lazy-loaded
- Unused exports from large libraries

### Phase 3: Apply Vite Optimizations

Create or update `vite.config.ts` with optimizations:

```typescript
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import { visualizer } from 'rollup-plugin-visualizer';

export default defineConfig({
  plugins: [
    react(),
    visualizer({
      filename: 'dist/stats.html',
      open: false,
      gzipSize: true,
      brotliSize: true,
    }),
  ],
  
  build: {
    // Target modern browsers for smaller output
    target: 'es2015',
    
    // Minification
    minify: 'terser',
    terserOptions: {
      compress: {
        drop_console: true, // Remove console.log in production
        drop_debugger: true,
      },
    },
    
    // Source maps (disable for production if size is critical)
    sourcemap: false,
    
    // Chunk size warnings
    chunkSizeWarningLimit: 1000,
    
    // Manual chunk splitting for better caching
    rollupOptions: {
      output: {
        manualChunks: {
          // Vendor chunk for React and related libraries
          'vendor-react': ['react', 'react-dom', 'react-router-dom'],
          
          // Separate chunk for large dependencies
          // Adjust based on your actual dependencies
          'vendor-utils': ['axios'], // Add other utility libs here
          
          // Add more chunks based on bundle analysis
          // Example: 'vendor-ui': ['@radix-ui/...', ...]
        },
      },
    },
  },
  
  // Optimize dependencies
  optimizeDeps: {
    include: ['react', 'react-dom', 'react-router-dom'],
  },
});
```

**Customization based on bundle analysis:**
- If you see large modules (e.g., chart libraries, date libraries), add them to `manualChunks`
- Example: `'vendor-charts': ['recharts', 'd3']`
- Example: `'vendor-forms': ['react-hook-form', 'zod']`

### Phase 4: TypeScript Strict Mode (Optional)

If not already strict, gradually enable stricter TypeScript checks.

Update `tsconfig.json`:
```json
{
  "compilerOptions": {
    "strict": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noImplicitReturns": true,
    "noFallthroughCasesInSwitch": true,
    "noUncheckedIndexedAccess": true
  }
}
```

**Note:** This may introduce type errors. Fix them incrementally:
```bash
npm run type-check
# Fix errors one by one
```

### Phase 5: Code Splitting Strategy

Apply lazy loading to routes and heavy components:

```typescript
// router.tsx
import { lazy, Suspense } from 'react';
import { Routes, Route } from 'react-router-dom';

// Lazy load pages
const HomePage = lazy(() => import('@/pages/HomePage'));
const DashboardPage = lazy(() => import('@/pages/DashboardPage'));
const OrdersPage = lazy(() => import('@/pages/OrdersPage'));

export const Router = () => (
  <Suspense fallback={<LoadingSpinner />}>
    <Routes>
      <Route path="/" element={<HomePage />} />
      <Route path="/dashboard" element={<DashboardPage />} />
      <Route path="/orders" element={<OrdersPage />} />
    </Routes>
  </Suspense>
);
```

### Phase 6: Rebuild and Compare

```bash
# Build with optimizations
npm run build

# Record optimized metrics
BUILD_SIZE_OPT=$(du -sh dist | cut -f1)
echo "OPTIMIZED_BUILD_SIZE: $BUILD_SIZE_OPT" >> ../../migration/optimization-log.md

# Compare
echo "
## Results

Before: $BUILD_SIZE
After: $BUILD_SIZE_OPT
" >> ../../migration/optimization-log.md
```

### Phase 7: Production Testing

**CRITICAL:** Test the optimized build before deploying:

```bash
# Preview production build locally
npm run preview

# Test in browser at http://localhost:4173
# Verify:
# - All routes load correctly
# - No console errors
# - Functionality works as expected
# - Network tab shows chunked JavaScript files
```

### Phase 8: Update Documentation

Write to `migration/optimization-log.md`:

```markdown
# Optimization Report

## Date
{current_date}

## Bundle Size
- Before: {size}
- After: {size}
- Reduction: {percentage}

## Optimizations Applied
- [x] Manual chunk splitting (vendor-react, vendor-utils)
- [x] Terser minification with console removal
- [x] Route-based code splitting
- [x] Bundle visualization setup
- [ ] TypeScript strict mode (deferred)
- [ ] Additional optimizations: {list any}

## Bundle Analysis Findings
{key findings from stats.html or manual analysis}

## Recommendations for Future
- Monitor bundle size on each deployment
- Review new dependencies before adding (check bundle impact)
- Consider lazy loading for {specific heavy components}
- {any other recommendations}

## Production Testing
- [x] Preview build tested locally
- [x] All routes functional
- [x] No console errors
- [x] Network requests optimized

## Next Steps
- Deploy to staging
- Run performance tests
- Monitor Web Vitals in production
```

### Phase 9: Commit Changes

```bash
cd modern/

git add frontend/vite.config.ts frontend/tsconfig.json
git add ../../migration/optimization-log.md
git commit -m "chore: apply production optimizations

- Configure manual chunk splitting
- Enable terser minification
- Add bundle visualization
- Document optimization results"
```

## Output

```
OPTIMIZATION COMPLETE

Baseline: {size}
Optimized: {size}
Reduction: {percentage}%

Chunks created:
- vendor-react.js: {size}
- vendor-utils.js: {size}
- {feature}.js: {size}
...

Next: Deploy to staging and monitor performance
```

## Troubleshooting

### Build Fails After Optimization

1. **Revert vite.config.ts changes** temporarily
2. **Test build**: `npm run build`
3. **Apply changes incrementally** (one optimization at a time)
4. **Check for import errors** in chunked dependencies

### Bundle Size Increased

1. **Check stats.html** to see what grew
2. **Review recent dependency additions**: `git diff HEAD~1 package.json`
3. **Look for duplicate dependencies**: `npm ls {package-name}`
4. **Consider tree-shaking imports**: `import { specific } from 'library'` instead of `import * as lib from 'library'`

### Type Errors After Strict Mode

1. **Disable strict TypeScript temporarily**
2. **Fix errors incrementally** (one file at a time)
3. **Use type assertions carefully**: `as unknown as Type` (last resort)
4. **Consider deferring strict mode** until post-launch

### Preview Build Doesn't Work

1. **Check console errors** in browser DevTools
2. **Verify base path** in vite.config.ts: `base: '/'`
3. **Check for hardcoded absolute paths** (should be relative)
4. **Test with clean dist**: `rm -rf dist && npm run build && npm run preview`

## Best Practices

1. **Optimize AFTER migration is complete** - Don't prematurely optimize
2. **Test thoroughly** - Preview build before deploying
3. **Monitor metrics** - Track bundle size over time
4. **Document changes** - Record what was optimized and why
5. **Incremental approach** - Apply one optimization at a time
6. **Keep it reversible** - Commit optimizations separately so they can be reverted

## When NOT to Run This

- During active feature migration
- Before QA approval
- When build is already failing
- If bundle size is already optimal (< 200KB gzipped for typical app)

## Related Commands

- `/migration-status` - Check if all features are complete
- `/migration-finalize` - Finalize migration before optimization
- `/migrate-next` - Continue migration if features remain
