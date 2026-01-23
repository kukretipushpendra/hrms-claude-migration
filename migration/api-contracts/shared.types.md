# Shared API Types

Common response shapes used across all modules.

---

## Standard Response Wrapper

```typescript
// If legacy uses a wrapper pattern, document it here
// Otherwise use NestJS default:

// Success response
{
  "data": T
}

// Error response (NestJS default)
{
  "statusCode": number,
  "message": string | string[],
  "error": string
}
```

## Pagination Response

```typescript
interface PaginatedResponse<T> {
  items: T[];
  meta: {
    page: number;
    limit: number;
    total: number;
    totalPages: number;
  };
}

// Query: GET /api/resource?page=1&limit=10
```

## Error Response Codes

| Code | HTTP | Description |
|------|------|-------------|
| VALIDATION_ERROR | 400 | Request validation failed |
| UNAUTHORIZED | 401 | Authentication required |
| FORBIDDEN | 403 | Permission denied |
| NOT_FOUND | 404 | Resource not found |
| CONFLICT | 409 | Resource already exists |
| INTERNAL_ERROR | 500 | Server error |

## Common Query Parameters

```typescript
// Pagination
?page=1&limit=10

// Sorting
?sortBy=createdAt&sortOrder=desc

// Search
?search=keyword

// Filtering (varies per module)
?status=active
```

---

## Module-Specific API Contracts

Created after each module's backend is complete:

| File | Created When |
|------|--------------|
| `auth.api.md` | After auth module backend complete |
| `users.api.md` | After users module backend complete |
| `products.api.md` | After products module backend complete |
| `orders.api.md` | After orders module backend complete |

Each module contract documents:
- All endpoints with methods
- Request body shapes
- Response shapes
- Module-specific error codes

Frontend coder reads these before implementing UI.
