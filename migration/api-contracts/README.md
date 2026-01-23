# API Contracts

This folder contains API response shapes for all features.

## Structure

```
api-contracts/
├── shared.types.md                    # Common types (pagination, errors, wrappers)
├── core/
│   ├── health.api.md                 # Health check endpoint
│   └── frontend-setup.api.md         # Frontend foundation types
├── auth/
│   ├── login.api.md                  # Login feature endpoints
│   ├── logout.api.md                 # Logout feature endpoints
│   └── session.api.md                # Session feature endpoints
├── orders/
│   ├── create.api.md                 # Create order feature
│   ├── list.api.md                   # List orders feature
│   └── delete.api.md                 # Delete order feature
└── {module}/
    └── {feature}.api.md              # Created per feature by backend-coder
```

## Feature API Contract Format

Each `{module}/{feature}.api.md` follows this structure:

```markdown
# {Module}/{Feature} API Contract

## Feature: {feature-name}

**Feature File:** `migration/modules/{module}/features/{feature}.md`

## Endpoints

### {METHOD} /api/{endpoint}

**Description:** {what this endpoint does}

**Request:**
- Method: {GET|POST|PUT|PATCH|DELETE}
- Auth: {None|Bearer token|Required}
- Headers: {if any special headers}
- Query Params: {params or None}
- Body: {request shape or None}

**Response {status}:** {description}

```json
{
  "field": "type",
  "field2": "type"
}
```

### Error Responses
```json
{
  "statusCode": 400,
  "message": "Error description",
  "error": "Bad Request"
}
```

## Types

### {Entity}
```typescript
interface {Entity} {
  id: number;
  field: type;
  // ...
}
```

### Create{Entity}Dto
```typescript
interface Create{Entity}Dto {
  field: type;
  // ...
}
```

## Error Codes (Feature-Specific)
- `{FEATURE}_NOT_FOUND`
- `{FEATURE}_VALIDATION_ERROR`
- `{FEATURE}_UNAUTHORIZED`
```

## When Created

- `shared.types.md` - Created during framework setup
- Feature contracts - Created by backend-coder after implementing each **feature**
- Frontend reads feature contract before implementing feature UI
- Each feature gets its own contract file in `{module}/{feature}.api.md`
