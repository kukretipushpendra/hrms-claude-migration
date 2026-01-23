---
description: Show differences between legacy and modern implementation
allowed-tools: Read, Bash, Glob, Grep
---

# Migrate Diff

Compare legacy implementation with modern implementation for a feature.

## Arguments

`$ARGUMENTS` - Feature name (module/feature) or "all" for summary

## Use Cases

1. **Before QA**: Verify implementation matches legacy
2. **After failure**: Understand what's different
3. **Human review**: Quick parity check
4. **Debugging**: Find specific discrepancies

## Process

### 1. Get Feature Files

```bash
# Read feature spec for file mappings
spec_file="migration/modules/{module}/features/{feature}.md"

# Extract legacy files
legacy_files=$(grep "LEGACY_FILES:" -A10 "$spec_file" | grep "^\s*-" | sed 's/^\s*-\s*//')

# Extract modern files
modern_backend=$(grep "BACKEND_FILES:" -A10 "$spec_file" | grep "^\s*-" | sed 's/^\s*-\s*//')
modern_frontend=$(grep "FRONTEND_FILES:" -A10 "$spec_file" | grep "^\s*-" | sed 's/^\s*-\s*//')
```

### 2. Generate Comparison Report

#### API Endpoints
```bash
# Legacy endpoints (from .cs files)
echo "=== LEGACY API ==="
grep -h "\[Http\(Get\|Post\|Put\|Delete\)\]" legacy/**/*.cs

# Modern endpoints (from .ts files)
echo "=== MODERN API ==="
grep -h "@\(Get\|Post\|Put\|Delete\)" modern/backend/**/*.ts
```

#### Validation Rules
```bash
# Legacy validation
echo "=== LEGACY VALIDATION ==="
grep -h "Required\|StringLength\|Range\|RegularExpression" legacy/**/*.cs

# Modern validation (Zod or class-validator)
echo "=== MODERN VALIDATION ==="
grep -h "z\.\|@Is\|@Min\|@Max\|@Length" modern/**/*.ts
```

#### Response Shapes
```bash
# Compare DTOs/ViewModels
echo "=== RESPONSE SHAPES ==="
# This requires semantic comparison - flag for manual review
```

### 3. Structural Diff (UI)

```bash
# Legacy HTML structure
echo "=== LEGACY UI STRUCTURE ==="
grep -h "<form\|<input\|<button\|<select" legacy/**/*.cshtml | head -50

# Modern JSX structure
echo "=== MODERN UI STRUCTURE ==="
grep -h "<form\|<input\|<button\|<select\|<Form\|<Input\|<Button\|<Select" modern/frontend/**/*.tsx | head -50
```

### 4. Generate Diff Summary

```
DIFF REPORT: {module}/{feature}
==============================

API Parity:
  ✓ GET /api/{endpoint} - matches
  ✓ POST /api/{endpoint} - matches
  ⚠ PUT /api/{endpoint} - response shape differs

Validation Parity:
  ✓ Required fields match
  ⚠ StringLength(50) vs z.string().max(100) - MISMATCH

UI Parity:
  ✓ Form fields match
  ✓ Button labels match
  ⚠ Field order differs

Files Compared:
  Legacy: {count} files
  Modern: {count} files

Discrepancies Found: {count}

Details:
  1. {specific discrepancy with file:line refs}
  2. {specific discrepancy with file:line refs}
```

## Output Modes

### Quick Summary (default)
```
{module}/{feature}: ✓ 12/15 checks passed, 3 discrepancies
```

### Detailed Report
```
Full diff report with file:line references for each discrepancy
```

### Export to File
```bash
# Save report to migration/diffs/{module}-{feature}.diff.md
```

## "All" Mode

When `$ARGUMENTS` is "all":

```
MIGRATION DIFF SUMMARY
======================

Module: auth
  ✓ login: 100% parity
  ⚠ register: 2 discrepancies
  ✗ password-reset: 5 discrepancies

Module: orders
  ✓ list: 100% parity
  ✓ create: 100% parity
  ⚠ delete: 1 discrepancy

Overall: 85% parity (17/20 features clean)
```

## Integration with QA

QA agent can call this command to generate detailed diff reports when QA fails:

```
Task (migrate-diff): "Generate diff report for {module}/{feature}"
```

Include diff output in QA feedback for more precise fixes.
