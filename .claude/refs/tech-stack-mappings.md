# Tech Stack Mappings Reference

This file contains concept mappings for the current migration (React.js + .NET → Vue.js + Node.js) and other framework combinations used by `/migrate-adapt`.

---

## Current Migration: React.js → Vue.js

### Component Patterns

| React.js | Vue.js 3 |
|----------|----------|
| Function Component | `<script setup>` SFC |
| `useState(initial)` | `ref(initial)` |
| `setState(newValue)` | `value.value = newValue` |
| `useMemo(() => ..., [deps])` | `computed(() => ...)` |
| `useCallback(fn, [deps])` | Regular function (auto-optimized) |
| `useEffect(() => {}, [])` | `onMounted(() => {})` |
| `useEffect(() => {}, [dep])` | `watch(dep, () => {})` |
| `useEffect cleanup` | `onUnmounted(() => {})` |
| `useRef(null)` | `ref(null)` for DOM |
| `useContext` | `inject()` / Pinia store |
| Custom Hook | Composable (`use{Name}.ts`) |

### Props & Events

| React.js | Vue.js 3 |
|----------|----------|
| `interface Props { ... }` | `defineProps<{ ... }>()` |
| `props.children` | `<slot />` |
| `onClick={handler}` | `@click="handler"` |
| `onChange={handler}` | `@change="handler"` or `v-model` |
| Callback prop pattern | `defineEmits(['event'])` |
| `props.onSubmit(data)` | `emit('submit', data)` |

### Conditional & Lists

| React.js | Vue.js 3 |
|----------|----------|
| `{condition && <div>}` | `<div v-if="condition">` |
| `{condition ? <A/> : <B/>}` | `<A v-if /> <B v-else />` |
| `{items.map(i => <Item key={i.id} />)}` | `<Item v-for="i in items" :key="i.id" />` |
| `className={styles}` | `:class="styles"` |
| `style={{ color: 'red' }}` | `:style="{ color: 'red' }"` |

### State Management

| React (Zustand) | Vue (Pinia) |
|-----------------|-------------|
| `create((set) => ...)` | `defineStore('id', { ... })` |
| `set((state) => ...)` | Direct mutation `this.property = value` |
| `useStore()` | `useStore()` |
| Selector `useStore(s => s.value)` | Direct access `store.value` |
| `persist` middleware | `pinia-plugin-persistedstate` |

### Form Handling

| React Hook Form | VeeValidate |
|-----------------|-------------|
| `useForm()` | `useForm()` |
| `register('field')` | `useField('field')` or `defineField('field')` |
| `handleSubmit(onSubmit)` | `handleSubmit(onSubmit)` |
| `formState.errors` | `errors` |
| `zodResolver(schema)` | `toTypedSchema(schema)` |
| `watch('field')` | `watch(field, callback)` |

### Routing

| React Router | Vue Router |
|--------------|------------|
| `<BrowserRouter>` | `createRouter()` |
| `<Routes>` | `<RouterView />` |
| `<Route path="/" element={<Home />} />` | `{ path: '/', component: Home }` |
| `<Link to="/about">` | `<RouterLink to="/about">` |
| `useNavigate()` | `useRouter()` |
| `useParams()` | `useRoute().params` |
| `useSearchParams()` | `useRoute().query` |
| `useLocation()` | `useRoute()` |
| `<Outlet />` | `<RouterView />` (nested) |

### Data Fetching

| React (SWR/TanStack) | Vue (VueQuery/Composable) |
|----------------------|---------------------------|
| `useSWR(key, fetcher)` | `useQuery({ queryKey, queryFn })` |
| `mutate()` | `invalidateQueries()` |
| Custom `useAsync` hook | Custom composable |

---

## Current Migration: .NET WebAPI → Node.js/Express

### Architecture

| .NET WebAPI | Node.js/Express |
|-------------|-----------------|
| Controller | Controller class + Router |
| Action method | Route handler function |
| Service | Service class |
| Repository + DbContext | Service with mssql |
| Entity | TypeScript interface |
| DTO | Zod schema + TypeScript interface |
| Data Annotations | Zod validators |
| AutoMapper | Manual mapping / spread |

### HTTP & Routing

| .NET WebAPI | Node.js/Express |
|-------------|-----------------|
| `[Route("api/[controller]")]` | `router = Router()` |
| `[HttpGet]` | `router.get('/', handler)` |
| `[HttpPost]` | `router.post('/', handler)` |
| `[HttpPut("{id}")]` | `router.put('/:id', handler)` |
| `[HttpDelete("{id}")]` | `router.delete('/:id', handler)` |
| `[FromBody]` | `req.body` |
| `[FromQuery]` | `req.query` |
| `[FromRoute]` | `req.params` |
| `IActionResult` | `res.json()` / `res.status()` |

### Middleware & Auth

| .NET WebAPI | Node.js/Express |
|-------------|-----------------|
| Middleware class | `(req, res, next) => {}` |
| `[Authorize]` | `authMiddleware` |
| `[AllowAnonymous]` | No middleware on route |
| JWT Bearer | `jsonwebtoken` + passport-jwt |
| `User.Claims` | `req.user` (from middleware) |
| `HasPermission` attribute | Custom permission middleware |

### Validation

| .NET Data Annotations | Zod |
|-----------------------|-----|
| `[Required]` | `z.string().min(1)` |
| `[MaxLength(100)]` | `z.string().max(100)` |
| `[EmailAddress]` | `z.string().email()` |
| `[Range(1, 100)]` | `z.number().min(1).max(100)` |
| `[RegularExpression]` | `z.string().regex()` |
| ModelState validation | Zod parse in middleware |

### Database (Dapper → mssql)

| Dapper/.NET | mssql (node-mssql) |
|-------------|-----------|
| Raw SQL queries | `pool.request().query()` |
| `connection.Query<T>()` | `pool.request().query<T>()` |
| `connection.QueryFirst<T>()` | `result.recordset[0]` |
| `connection.Execute()` | `pool.request().query()` for INSERT/UPDATE |
| Stored procedures | `pool.request().execute('sp_name')` |
| `@param` | `.input('param', sql.Int, value)` |

### Response Pattern

```csharp
// .NET ApiResponseModel
{
  "statusCode": 200,
  "message": "Success",
  "result": { ... }
}
```

```typescript
// Express equivalent - MUST MATCH EXACTLY
res.json({
  statusCode: 200,
  message: 'Success',
  result: data,
});
```

---

## Database Type Mappings (SQL Server → mssql driver)

### SQL Server Types in Node.js (mssql)

| SQL Server | mssql Type |
|------------|------------|
| NVARCHAR(n) | `sql.NVarChar(n)` |
| NVARCHAR(MAX) | `sql.NVarChar(sql.MAX)` |
| VARCHAR(n) | `sql.VarChar(n)` |
| INT | `sql.Int` |
| BIGINT | `sql.BigInt` |
| BIT | `sql.Bit` |
| DATETIME | `sql.DateTime` |
| DATETIME2 | `sql.DateTime2` |
| DATE | `sql.Date` |
| DECIMAL(p,s) | `sql.Decimal(p,s)` |
| MONEY | `sql.Money` |
| UNIQUEIDENTIFIER | `sql.UniqueIdentifier` |
| VARBINARY(MAX) | `sql.VarBinary(sql.MAX)` |

### Common mssql Patterns
```typescript
// Parameterized queries (prevent SQL injection)
const result = await pool.request()
  .input('id', sql.Int, userId)
  .input('name', sql.NVarChar(100), userName)
  .query('SELECT * FROM Users WHERE Id = @id AND Name = @name');

// Stored procedures
const result = await pool.request()
  .input('userId', sql.Int, userId)
  .output('totalCount', sql.Int)
  .execute('sp_GetUserOrders');
```

---

## Directory Structure Templates

### Node.js/Express Backend Structure
```
src/
├── app.ts                    # Express app setup
├── server.ts                 # Entry point
├── config/
│   ├── database.ts           # mssql connection pool
│   └── env.ts                # Environment
├── middleware/
│   ├── auth.middleware.ts
│   ├── validation.middleware.ts
│   └── error.middleware.ts
├── modules/
│   └── {module}/
│       ├── {module}.routes.ts
│       ├── {module}.controller.ts
│       ├── {module}.service.ts    # Uses mssql queries
│       ├── dto/
│       │   ├── create-{entity}.dto.ts
│       │   └── update-{entity}.dto.ts
│       └── types/
│           └── {entity}.types.ts
├── types/
│   └── express.d.ts
└── utils/
    ├── errors.ts
    └── helpers.ts
```

### Vue.js Frontend Structure
```
src/
├── views/                    # Page components
│   └── {module}/
│       └── {Feature}View.vue
├── components/               # Reusable components
│   └── {module}/
│       └── {Component}.vue
├── composables/              # Reusable logic (like hooks)
│   └── use{Feature}.ts
├── services/                 # API calls
│   └── api/
│       ├── axios-client.ts
│       └── {module}.service.ts
├── stores/                   # Pinia stores
│   └── {module}.store.ts
├── types/                    # TypeScript types
│   └── {module}.types.ts
├── router/
│   └── index.ts
├── assets/
├── styles/
├── App.vue
└── main.ts
```

---

## Other Framework Mappings (for /migrate-adapt)

### Laravel (PHP) → Node.js/Express

| Laravel | Node.js/Express |
|---------|-----------------|
| Controller | Controller + Router |
| Model (Eloquent) | Service with mssql |
| Form Request | Zod schema + middleware |
| Middleware | Express middleware |
| Service Provider | Module pattern |
| Facade | Imported service |
| Route::get() | router.get() |
| $request->validate() | Zod validation |
| Auth::user() | req.user |

### Angular → Vue.js

| Angular | Vue.js 3 |
|---------|----------|
| Component | SFC with `<script setup>` |
| @Input() | `defineProps<{}>()` |
| @Output() | `defineEmits([])` |
| *ngIf | v-if |
| *ngFor | v-for |
| [(ngModel)] | v-model |
| Service | Composable or Pinia store |
| NgModule | Just imports |
| Pipe | Utility function |
| RxJS Observable | ref() + watch() |
| HttpClient | Axios |

### Django (Python) → Node.js/Express

| Django | Node.js/Express |
|--------|-----------------|
| View/ViewSet | Controller |
| Model | Service with mssql |
| Serializer | Zod DTO |
| URLConf | Express Router |
| Middleware | Express middleware |
| @login_required | authMiddleware |
| Form | Zod schema |
| Manager | Service methods |
| Celery Task | Bull Queue / node-cron |

### Spring (Java) → Node.js/Express

| Spring | Node.js/Express |
|--------|-----------------|
| @RestController | Controller + Router |
| @Service | Service class |
| @Repository | Service with mssql |
| @Entity | TypeScript interface |
| @RequestBody | req.body |
| @PathVariable | req.params |
| @RequestParam | req.query |
| @Autowired | Constructor / import |
| @PreAuthorize | authMiddleware |
| @Transactional | mssql transactions |
