# Tech Stack Mappings Reference

This file contains concept mappings for various framework combinations used by `/migrate-adapt`.

---

## Backend Framework Mappings

### Laravel (PHP) → NestJS

| Laravel | NestJS |
|---------|--------|
| Controller | Controller |
| Model (Eloquent) | Entity (Sequelize) |
| Form Request | DTO + ValidationPipe |
| Middleware | Guard/Interceptor |
| Service Provider | Module |
| Facade | Injectable Service |
| Route::get() | @Get() |
| Route::post() | @Post() |
| $request->validate() | class-validator decorators |
| Auth::user() | @CurrentUser() decorator |
| Policy | Guard |
| Event/Listener | EventEmitter2 |
| Queue Job | Bull Queue |
| Artisan Command | NestJS CLI Command |

### Django (Python) → NestJS

| Django | NestJS |
|--------|--------|
| View/ViewSet | Controller |
| Model | Entity |
| Serializer | DTO |
| URLConf | Route decorators |
| Middleware | Middleware/Interceptor |
| @login_required | @UseGuards(AuthGuard) |
| Form | DTO + class-validator |
| Manager | Repository |
| Signal | Event |
| Celery Task | Bull Queue |
| management command | CLI Command |

### Rails (Ruby) → NestJS

| Rails | NestJS |
|-------|--------|
| Controller | Controller |
| Model (ActiveRecord) | Entity |
| Strong Parameters | DTO + ValidationPipe |
| before_action | Guard/Interceptor |
| Concerns | Mixin/Trait |
| Service Object | Service |
| ActiveJob | Bull Queue |
| ActionCable | WebSocket Gateway |
| Rake Task | CLI Command |

### Spring (Java) → NestJS

| Spring | NestJS |
|--------|--------|
| @RestController | @Controller |
| @Service | @Injectable |
| @Repository | Repository Pattern |
| @Entity | @Entity (Sequelize) |
| @RequestBody | @Body() |
| @PathVariable | @Param() |
| @RequestParam | @Query() |
| @Autowired | Constructor Injection |
| @PreAuthorize | @UseGuards() |
| @Transactional | Sequelize transactions |

### .NET MVC → NestJS

| .NET MVC | NestJS |
|----------|--------|
| Controller | Controller |
| Action | Route Handler |
| Model | Entity |
| ViewModel | DTO |
| Data Annotations | class-validator |
| [Authorize] | @UseGuards() |
| [HttpGet] | @Get() |
| DbContext | Repository |
| Middleware | Middleware |
| Dependency Injection | NestJS DI |

---

## Frontend Framework Mappings

### Vue.js → React

| Vue.js | React |
|--------|-------|
| `<template>` | JSX return |
| `data()` | useState |
| `computed` | useMemo |
| `watch` | useEffect |
| `methods` | Functions |
| `props` | Props |
| `$emit` | Callback props |
| `v-if` | `{condition && ...}` |
| `v-for` | `.map()` |
| `v-model` | value + onChange |
| `v-bind:class` | className={...} |
| `<slot>` | children prop |
| `provide/inject` | Context API |
| Vuex | Zustand/Redux |
| Vue Router | React Router |
| `@click` | onClick |
| `ref()` | useRef |
| `onMounted` | useEffect(..., []) |
| `onUnmounted` | useEffect cleanup |

### Angular → React

| Angular | React |
|---------|-------|
| Component | Function Component |
| @Input() | Props |
| @Output() | Callback props |
| *ngIf | Conditional render |
| *ngFor | .map() |
| [(ngModel)] | Controlled input |
| Service | Custom hook / Context |
| NgModule | Just imports |
| Pipe | Utility function |
| Directive | Custom hook |
| RxJS Observable | TanStack Query / useState |
| HttpClient | fetch / axios |
| Router | React Router |
| Guards | Route protection HOC |
| Resolvers | Loader pattern |

### Blade (Laravel) → React

| Blade | React |
|-------|-------|
| `{{ $var }}` | `{var}` |
| `@if/@else` | Ternary / && |
| `@foreach` | `.map()` |
| `@include` | Component import |
| `@extends/@section` | Layout component |
| `@component` | React component |
| `@slot` | children / named slots |
| `@auth/@guest` | Auth context check |
| `@csrf` | Not needed (API) |
| `@method` | Not needed (API) |

### Razor (.NET) → React

| Razor | React |
|-------|-------|
| `@Model.Property` | `{props.property}` |
| `@if` | Conditional render |
| `@foreach` | `.map()` |
| `@Html.Partial` | Component import |
| `@section` | Layout slots |
| `@Html.ActionLink` | `<Link>` |
| `@Html.BeginForm` | `<form>` with handlers |
| `ViewBag/ViewData` | Props / Context |
| `@Html.DisplayFor` | Direct render |
| `@Html.EditorFor` | Form input component |

### Django Templates → React

| Django | React |
|--------|-------|
| `{{ var }}` | `{var}` |
| `{% if %}` | Conditional render |
| `{% for %}` | `.map()` |
| `{% include %}` | Component import |
| `{% extends %}` | Layout component |
| `{% block %}` | children / slots |
| `{{ var\|filter }}` | Utility function |
| `{% url %}` | React Router Link |
| `{% csrf_token %}` | Not needed (API) |

### ERB (Rails) → React

| ERB | React |
|-----|-------|
| `<%= var %>` | `{var}` |
| `<% if %>` | Conditional render |
| `<% @items.each %>` | `.map()` |
| `<%= render partial %>` | Component import |
| `<%= yield %>` | children |
| `<%= link_to %>` | `<Link>` |
| `<%= form_with %>` | `<form>` |
| `helper methods` | Utility functions |

---

## Database Type Mappings

### SQL Server → PostgreSQL

| SQL Server | PostgreSQL |
|------------|------------|
| NVARCHAR(n) | VARCHAR(n) |
| NVARCHAR(MAX) | TEXT |
| DATETIME2 | TIMESTAMP |
| BIT | BOOLEAN |
| UNIQUEIDENTIFIER | UUID |
| IDENTITY | SERIAL |
| MONEY | DECIMAL(19,4) |
| VARBINARY(MAX) | BYTEA |
| GETDATE() | NOW() |
| TOP n | LIMIT n |
| ISNULL() | COALESCE() |

### MySQL → PostgreSQL

| MySQL | PostgreSQL |
|-------|------------|
| TINYINT(1) | BOOLEAN |
| INT AUTO_INCREMENT | SERIAL |
| DATETIME | TIMESTAMP |
| TEXT | TEXT |
| ENUM('a','b') | VARCHAR + CHECK |
| JSON | JSONB |
| UNSIGNED | CHECK >= 0 |
| ON UPDATE CURRENT_TIMESTAMP | Trigger |

### MongoDB → PostgreSQL

| MongoDB | PostgreSQL |
|---------|------------|
| _id (ObjectId) | id (UUID/SERIAL) |
| Embedded document | JSONB or related table |
| Array field | ARRAY or junction table |
| $lookup | JOIN |
| find() | SELECT |
| insertOne() | INSERT |
| updateOne() | UPDATE |
| deleteOne() | DELETE |

---

## ORM Mappings

### Eloquent (Laravel) → Sequelize

| Eloquent | Sequelize |
|----------|-----------|
| Model | @Table class |
| $fillable | allowNull config |
| $casts | DataTypes |
| hasMany() | @HasMany |
| belongsTo() | @BelongsTo |
| belongsToMany() | @BelongsToMany |
| scope | Static method |
| $timestamps | timestamps: true |
| softDeletes | paranoid: true |
| with() | include: [] |

### Django ORM → Sequelize

| Django ORM | Sequelize |
|------------|-----------|
| Model | @Table class |
| CharField | DataTypes.STRING |
| IntegerField | DataTypes.INTEGER |
| ForeignKey | @ForeignKey |
| ManyToManyField | @BelongsToMany |
| objects.filter() | findAll({ where }) |
| objects.get() | findOne() |
| objects.create() | create() |
| select_related() | include: [] |
| prefetch_related() | include: [] |

### ActiveRecord (Rails) → Sequelize

| ActiveRecord | Sequelize |
|--------------|-----------|
| Model | @Table class |
| has_many | @HasMany |
| belongs_to | @BelongsTo |
| has_and_belongs_to_many | @BelongsToMany |
| validates | class-validator |
| scope | Static method |
| where() | findAll({ where }) |
| find() | findByPk() |
| includes() | include: [] |

### Entity Framework → Sequelize

| Entity Framework | Sequelize |
|------------------|-----------|
| DbSet<T> | Model |
| DbContext | Sequelize instance |
| [Key] | primaryKey: true |
| [Required] | allowNull: false |
| [MaxLength] | DataTypes.STRING(n) |
| Navigation property | Association |
| Include() | include: [] |
| FirstOrDefault() | findOne() |
| ToList() | findAll() |
| Add() | create() |
| SaveChanges() | save() |

---

## Directory Structure Templates

### NestJS Backend Structure
```
src/
├── modules/
│   └── {module}/
│       ├── {module}.module.ts
│       ├── {module}.controller.ts
│       ├── {module}.service.ts
│       ├── dto/
│       └── entities/
├── common/
│   ├── guards/
│   ├── interceptors/
│   └── filters/
└── database/
    └── database.module.ts
```

### React Frontend Structure
```
src/
├── pages/
├── components/
├── hooks/
├── services/
├── types/
├── utils/
└── context/
```

### Vue Frontend Structure
```
src/
├── views/
├── components/
├── composables/
├── services/
├── types/
├── utils/
└── stores/
```

### Angular Frontend Structure
```
src/app/
├── pages/
├── components/
├── services/
├── models/
├── guards/
└── modules/
```
