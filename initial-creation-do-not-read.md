I have a legacy .net project using .net6 MVC. Now the need is to migrate it to the react.js and node.js(nest.js) and postgresql. What should be the
approach, how it should be planned, what major role subagents can play, what type of agents to create and use. You are an expert super experienced
engineer at migrating codebases from .net to JS. Now I want to learn this as well and be an expert but I do not have idea right now. I have 7 year of
experience as Javascript full stack engineer. React, node, nexst, express and postgres. I want to become the god of code migration using Claude code
clic AI. Instead of months I want to do it in weeks, consider like medium to large projects. Like an ecommerce store, a personal portfolio with custom
blog etc etc features, a SaaS, a supply chain mgmt like seaboardfoods.

● This is an excellent learning goal! Let me create a comprehensive migration methodology guide for you. Since this is about learning the approach rather than migrating a specific codebase, I'll create a detailed framework you can apply to any .NET to JS migration project.

● Updated plan
  ⎿  /plan to preview

● I've created a comprehensive migration methodology guide for you. This covers the complete framework for migrating .NET MVC to React/NestJS/PostgreSQL.

  Key highlights of the approach:

  1. 5-Phase Framework: Discovery → Design → Database → Backend → Frontend
  2. Claude Code Agent Strategy:
    - Explore agents for understanding existing code
    - Plan agents for architecture decisions
    - general-purpose agents for complex multi-step migrations
  3. Acceleration Techniques:
    - Batch similar components (migrate 5 CRUD controllers at once)
    - Generate from contracts (DTOs/interfaces first)
    - Parallel workstreams (DB, backend, frontend simultaneously)
    - Test-driven migration
  4. Project-Specific Timelines:
    - Portfolio + Blog: 1-2 weeks
    - E-commerce: 3-4 weeks
    - SaaS: 4-6 weeks
    - Supply Chain: 5-8 weeks

● User answered Claude's questions:
  ⎿  · Do you have a specific .NET project you want to start migrating, or are you looking for this methodology to study first? → Studying methodology
     · Which project type would you like me to deep-dive on with more specific examples? → E-commerce store

● Let me expand the guide with a deep-dive on e-commerce migration specifically.

● Updated plan
  ⎿  /plan to preview

● I've created a comprehensive migration mastery guide. Here's what's covered:

  Plan Summary

  Part 1-2: 5-Phase Migration Framework
  - Discovery & Analysis → Design & Planning → Database → Backend → Frontend

  Part 3: Claude Code Subagent Strategy
  - When to use Explore vs Plan vs general-purpose agents
  - Parallel agent workflows for efficiency
  - Template prompts for discovery and migration agents

  Part 4: Project-Specific Timelines
  - Portfolio/Blog: 1-2 weeks
  - E-commerce: 3-4 weeks
  - SaaS: 4-6 weeks
  - Supply Chain: 5-8 weeks

  Part 5: Acceleration Techniques
  - Batch similar components
  - Generate from contracts first
  - Parallel workstreams
  - Test-driven migration

  Part 6-7: Quality Checklist & Common Pitfalls

  Part 8: E-commerce Deep Dive
  - Complete week-by-week breakdown (21 days)
  - Day-by-day tasks with specific agent prompts
  - Critical code translations (C# → TypeScript)
  - Session cart → JWT + DB pattern
  - Common e-commerce pitfalls

  The guide is at /home/rajeshroyal/.claude/plans/clever-knitting-wigderson.md - you can reference it anytime during your migrations.

● User answered Claude's questions:
  ⎿  · Would you like me to add anything else to this migration guide? → Add testing strategies

● Updated plan
  ⎿  /plan to preview

● I've added a comprehensive testing strategies section. Here's what's included:

  Added Testing Strategies (Part 8)

  Testing Philosophy:
  - Test incrementally as you migrate, not all at once
  - Testing pyramid: 50-60% unit, 30-35% integration, 10-15% E2E

  6 Testing Phases:
  1. Pre-Migration Test Extraction - Document all test cases from .NET
  2. Test-First Migration Pattern - Write tests before migrating each module
  3. Backend Testing Setup - NestJS unit tests, integration tests with supertest
  4. Frontend Testing Setup - React Testing Library + MSW for API mocking
  5. E2E Testing with Playwright - Full user flow testing
  6. Behavior Parity Testing - Compare .NET vs NestJS responses

  Includes:
  - Complete code examples for each test type
  - MSW (Mock Service Worker) setup for frontend
  - Playwright checkout flow tests
  - Parity testing to verify identical behavior
  - Per-module testing checklist
  - Agent prompts specifically for test generation

  The full guide is now ~1200 lines covering everything you need to master .NET to JS migrations.
  ⎿  User rejected Claude's plan:
     ╭──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
     │ .NET to JavaScript Migration Mastery Guide                                                                                                   │
     │                                                                                                                                              │
     │ Goal                                                                                                                                         │
     │                                                                                                                                              │
     │ Transform from a JS full-stack engineer to a code migration expert using Claude Code CLI, reducing migration timelines from months to weeks. │
     │                                                                                                                                              │
     │ ---                                                                                                                                          │
     │ Part 1: Migration Methodology Overview                                                                                                       │
     │                                                                                                                                              │
     │ The 5-Phase Migration Framework                                                                                                              │
     │                                                                                                                                              │
     │ ┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐                                                  │
     │ │  Discovery  │ -> │   Design    │ -> │  Database   │ -> │   Backend   │ -> │  Frontend   │                                                  │
     │ │  & Analysis │    │  & Planning │    │  Migration  │    │  Migration  │    │  Migration  │                                                  │
     │ └─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘                                                  │
     │                                                                                                                                              │
     │ ---                                                                                                                                          │
     │ Part 2: Phase-by-Phase Breakdown                                                                                                             │
     │                                                                                                                                              │
     │ Phase 1: Discovery & Analysis (Days 1-3)                                                                                                     │
     │                                                                                                                                              │
     │ Objective: Understand the legacy system completely before writing any code.                                                                  │
     │                                                                                                                                              │
     │ Key Activities:                                                                                                                              │
     │ 1. Inventory Creation                                                                                                                        │
     │   - Count controllers, models, views, services                                                                                               │
     │   - Identify external integrations (APIs, payment gateways, auth providers)                                                                  │
     │   - Map database schema (tables, relationships, stored procedures)                                                                           │
     │   - Document business logic in services/repositories                                                                                         │
     │ 2. Dependency Analysis                                                                                                                       │
     │   - NuGet packages → npm equivalents mapping                                                                                                 │
     │   - .NET-specific libraries that need alternatives                                                                                           │
     │   - Third-party integrations documentation                                                                                                   │
     │ 3. Complexity Assessment                                                                                                                     │
     │   - Rate each module: Simple / Medium / Complex                                                                                              │
     │   - Identify technical debt and legacy patterns                                                                                              │
     │   - Flag areas needing refactoring vs direct translation                                                                                     │
     │                                                                                                                                              │
     │ Claude Code Agent Usage:                                                                                                                     │
     │ # Use Explore agents to analyze the .NET codebase                                                                                            │
     │ Task (Explore): "Analyze all Controllers in /Controllers folder.                                                                             │
     │ List each controller, its actions, HTTP methods, and route patterns.                                                                         │
     │ Identify authentication/authorization attributes."                                                                                           │
     │                                                                                                                                              │
     │ Task (Explore): "Map the Entity Framework models in /Models.                                                                                 │
     │ Document table relationships, data annotations, and business rules."                                                                         │
     │                                                                                                                                              │
     │ Task (Explore): "Find all external service integrations - API calls,                                                                         │
     │ payment gateways, email services, file storage. Document endpoints and authentication."                                                      │
     │                                                                                                                                              │
     │ ---                                                                                                                                          │
     │ Phase 2: Design & Planning (Days 3-5)                                                                                                        │
     │                                                                                                                                              │
     │ Objective: Create the architecture blueprint for the new system.                                                                             │
     │                                                                                                                                              │
     │ Key Decisions:                                                                                                                               │
     │                                                                                                                                              │
     │ | .NET Concept     | NestJS Equivalent          |                                                                                            │
     │ |------------------|----------------------------|                                                                                            │
     │ | Controller       | Controller (same pattern!) |                                                                                            │
     │ | Service          | Injectable Service         |                                                                                            │
     │ | Repository       | TypeORM Repository         |                                                                                            │
     │ | Entity Framework | TypeORM / Prisma           |                                                                                            │
     │ | Middleware       | NestJS Middleware/Guards   |                                                                                            │
     │ | Filters          | Exception Filters          |                                                                                            │
     │ | AutoMapper       | class-transformer          |                                                                                            │
     │ | FluentValidation | class-validator            |                                                                                            │
     │ | Identity         | Passport.js + JWT          |                                                                                            │
     │                                                                                                                                              │
     │ Architecture Template:                                                                                                                       │
     │ /backend (NestJS)                                                                                                                            │
     │ ├── src/                                                                                                                                     │
     │ │   ├── modules/           # Feature modules (1:1 with .NET areas)                                                                           │
     │ │   │   ├── auth/                                                                                                                            │
     │ │   │   ├── users/                                                                                                                           │
     │ │   │   ├── products/                                                                                                                        │
     │ │   │   └── orders/                                                                                                                          │
     │ │   ├── common/            # Shared utilities                                                                                                │
     │ │   │   ├── guards/                                                                                                                          │
     │ │   │   ├── filters/                                                                                                                         │
     │ │   │   ├── interceptors/                                                                                                                    │
     │ │   │   └── decorators/                                                                                                                      │
     │ │   ├── database/          # TypeORM entities & migrations                                                                                   │
     │ │   └── config/            # Environment configuration                                                                                       │
     │                                                                                                                                              │
     │ /frontend (React)                                                                                                                            │
     │ ├── src/                                                                                                                                     │
     │ │   ├── components/        # Reusable UI components                                                                                          │
     │ │   ├── pages/             # Route-based pages (map from Views)                                                                              │
     │ │   ├── hooks/             # Custom React hooks                                                                                              │
     │ │   ├── services/          # API client layer                                                                                                │
     │ │   ├── store/             # State management (Redux/Zustand)                                                                                │
     │ │   └── types/             # TypeScript interfaces                                                                                           │
     │                                                                                                                                              │
     │ Claude Code Agent Usage:                                                                                                                     │
     │ Task (Plan): "Given this .NET MVC structure [paste tree], design                                                                             │
     │ a NestJS module structure. Map each controller to a module,                                                                                  │
     │ identify shared services, and plan the dependency injection hierarchy."                                                                      │
     │                                                                                                                                              │
     │ ---                                                                                                                                          │
     │ Phase 3: Database Migration (Days 5-10)                                                                                                      │
     │                                                                                                                                              │
     │ Objective: Migrate from SQL Server/SQLite to PostgreSQL.                                                                                     │
     │                                                                                                                                              │
     │ Step-by-Step Process:                                                                                                                        │
     │                                                                                                                                              │
     │ 1. Schema Export                                                                                                                             │
     │ # Export existing schema                                                                                                                     │
     │ dotnet ef dbcontext script -o schema.sql                                                                                                     │
     │ 2. Schema Translation                                                                                                                        │
     │   - SQL Server types → PostgreSQL types                                                                                                      │
     │   - Identity columns → SERIAL/BIGSERIAL                                                                                                      │
     │   - DateTime → TIMESTAMP WITH TIME ZONE                                                                                                      │
     │   - NVARCHAR → VARCHAR/TEXT                                                                                                                  │
     │   - BIT → BOOLEAN                                                                                                                            │
     │ 3. TypeORM Entity Creation                                                                                                                   │
     │ // From C# Entity:                                                                                                                           │
     │ // public class Product {                                                                                                                    │
     │ //   public int Id { get; set; }                                                                                                             │
     │ //   public string Name { get; set; }                                                                                                        │
     │ //   public decimal Price { get; set; }                                                                                                      │
     │ // }                                                                                                                                         │
     │                                                                                                                                              │
     │ // To TypeORM Entity:                                                                                                                        │
     │ @Entity('products')                                                                                                                          │
     │ export class Product {                                                                                                                       │
     │   @PrimaryGeneratedColumn()                                                                                                                  │
     │   id: number;                                                                                                                                │
     │                                                                                                                                              │
     │   @Column({ type: 'varchar', length: 255 })                                                                                                  │
     │   name: string;                                                                                                                              │
     │                                                                                                                                              │
     │   @Column({ type: 'decimal', precision: 10, scale: 2 })                                                                                      │
     │   price: number;                                                                                                                             │
     │ }                                                                                                                                            │
     │ 4. Data Migration                                                                                                                            │
     │   - Export data as JSON/CSV                                                                                                                  │
     │   - Transform data formats                                                                                                                   │
     │   - Import into PostgreSQL                                                                                                                   │
     │   - Verify referential integrity                                                                                                             │
     │                                                                                                                                              │
     │ Claude Code Agent Usage:                                                                                                                     │
     │ Task (general-purpose): "Convert these Entity Framework models                                                                               │
     │ [paste C# files] to TypeORM entities. Maintain all relationships,                                                                            │
     │ indexes, and constraints. Use PostgreSQL-compatible types."                                                                                  │
     │                                                                                                                                              │
     │ Task (Explore): "Analyze stored procedures in the database.                                                                                  │
     │ Document their logic so we can recreate as TypeORM queries or                                                                                │
     │ NestJS service methods."                                                                                                                     │
     │                                                                                                                                              │
     │ ---                                                                                                                                          │
     │ Phase 4: Backend Migration (Days 10-20)                                                                                                      │
     │                                                                                                                                              │
     │ Objective: Recreate all server-side logic in NestJS.                                                                                         │
     │                                                                                                                                              │
     │ Migration Order (Critical!):                                                                                                                 │
     │ 1. Authentication & Authorization (first - others depend on it)                                                                              │
     │ 2. Core domain models and services                                                                                                           │
     │ 3. API endpoints (controller by controller)                                                                                                  │
     │ 4. Background jobs/scheduled tasks                                                                                                           │
     │ 5. External integrations                                                                                                                     │
     │                                                                                                                                              │
     │ Pattern Translation Guide:                                                                                                                   │
     │                                                                                                                                              │
     │ Controllers:                                                                                                                                 │
     │ // .NET                                                                                                                                      │
     │ [ApiController]                                                                                                                              │
     │ [Route("api/[controller]")]                                                                                                                  │
     │ public class ProductsController : ControllerBase                                                                                             │
     │ {                                                                                                                                            │
     │     [HttpGet]                                                                                                                                │
     │     public async Task<ActionResult<IEnumerable<Product>>> GetAll()                                                                           │
     │     {                                                                                                                                        │
     │         return Ok(await _productService.GetAllAsync());                                                                                      │
     │     }                                                                                                                                        │
     │                                                                                                                                              │
     │     [HttpGet("{id}")]                                                                                                                        │
     │     public async Task<ActionResult<Product>> GetById(int id)                                                                                 │
     │     {                                                                                                                                        │
     │         var product = await _productService.GetByIdAsync(id);                                                                                │
     │         if (product == null) return NotFound();                                                                                              │
     │         return Ok(product);                                                                                                                  │
     │     }                                                                                                                                        │
     │ }                                                                                                                                            │
     │                                                                                                                                              │
     │ // NestJS                                                                                                                                    │
     │ @Controller('api/products')                                                                                                                  │
     │ export class ProductsController {                                                                                                            │
     │   constructor(private readonly productService: ProductsService) {}                                                                           │
     │                                                                                                                                              │
     │   @Get()                                                                                                                                     │
     │   async findAll(): Promise<Product[]> {                                                                                                      │
     │     return this.productService.findAll();                                                                                                    │
     │   }                                                                                                                                          │
     │                                                                                                                                              │
     │   @Get(':id')                                                                                                                                │
     │   async findOne(@Param('id', ParseIntPipe) id: number): Promise<Product> {                                                                   │
     │     const product = await this.productService.findOne(id);                                                                                   │
     │     if (!product) throw new NotFoundException();                                                                                             │
     │     return product;                                                                                                                          │
     │   }                                                                                                                                          │
     │ }                                                                                                                                            │
     │                                                                                                                                              │
     │ Services:                                                                                                                                    │
     │ // .NET                                                                                                                                      │
     │ public class ProductService : IProductService                                                                                                │
     │ {                                                                                                                                            │
     │     private readonly AppDbContext _context;                                                                                                  │
     │                                                                                                                                              │
     │     public async Task<Product> CreateAsync(CreateProductDto dto)                                                                             │
     │     {                                                                                                                                        │
     │         var product = new Product { Name = dto.Name, Price = dto.Price };                                                                    │
     │         _context.Products.Add(product);                                                                                                      │
     │         await _context.SaveChangesAsync();                                                                                                   │
     │         return product;                                                                                                                      │
     │     }                                                                                                                                        │
     │ }                                                                                                                                            │
     │                                                                                                                                              │
     │ // NestJS                                                                                                                                    │
     │ @Injectable()                                                                                                                                │
     │ export class ProductsService {                                                                                                               │
     │   constructor(                                                                                                                               │
     │     @InjectRepository(Product)                                                                                                               │
     │     private readonly productRepository: Repository<Product>,                                                                                 │
     │   ) {}                                                                                                                                       │
     │                                                                                                                                              │
     │   async create(dto: CreateProductDto): Promise<Product> {                                                                                    │
     │     const product = this.productRepository.create(dto);                                                                                      │
     │     return this.productRepository.save(product);                                                                                             │
     │   }                                                                                                                                          │
     │ }                                                                                                                                            │
     │                                                                                                                                              │
     │ Claude Code Agent Usage:                                                                                                                     │
     │ Task (general-purpose): "Convert this .NET controller [paste code]                                                                           │
     │ to a NestJS controller. Include:                                                                                                             │
     │ - All route decorators                                                                                                                       │
     │ - Request/Response DTOs with validation                                                                                                      │
     │ - Exception handling                                                                                                                         │
     │ - Swagger decorators for documentation"                                                                                                      │
     │                                                                                                                                              │
     │ Task (Plan): "Analyze authentication in this .NET project                                                                                    │
     │ [describe/paste]. Design a NestJS auth module using Passport.js                                                                              │
     │ that replicates the same behavior with JWT tokens."                                                                                          │
     │                                                                                                                                              │
     │ ---                                                                                                                                          │
     │ Phase 5: Frontend Migration (Days 15-25)                                                                                                     │
     │                                                                                                                                              │
     │ Objective: Convert Razor Views to React components.                                                                                          │
     │                                                                                                                                              │
     │ View → Component Mapping:                                                                                                                    │
     │                                                                                                                                              │
     │ | Razor Concept      | React Equivalent           |                                                                                          │
     │ |--------------------|----------------------------|                                                                                          │
     │ | _Layout.cshtml     | App.tsx / Layout component |                                                                                          │
     │ | @section           | Children props / Slots     |                                                                                          │
     │ | @Html.Partial      | Component import           |                                                                                          │
     │ | @ViewBag/@ViewData | Props / Context            |                                                                                          │
     │ | @foreach loops     | .map()                     |                                                                                          │
     │ | @if conditionals   | Ternary / && operator      |                                                                                          │
     │ | @Html.ActionLink   | React Router Link          |                                                                                          │
     │ | Form helpers       | React Hook Form            |                                                                                          │
     │ | Validation         | Yup / Zod schemas          |                                                                                          │
     │                                                                                                                                              │
     │ Example Conversion:                                                                                                                          │
     │ <!-- Razor -->                                                                                                                               │
     │ @model ProductViewModel                                                                                                                      │
     │ <div class="product-card">                                                                                                                   │
     │     <h2>@Model.Name</h2>                                                                                                                     │
     │     <p class="price">$@Model.Price.ToString("F2")</p>                                                                                        │
     │     @if (Model.InStock)                                                                                                                      │
     │     {                                                                                                                                        │
     │         <button asp-action="AddToCart" asp-route-id="@Model.Id">                                                                             │
     │             Add to Cart                                                                                                                      │
     │         </button>                                                                                                                            │
     │     }                                                                                                                                        │
     │     else                                                                                                                                     │
     │     {                                                                                                                                        │
     │         <span class="out-of-stock">Out of Stock</span>                                                                                       │
     │     }                                                                                                                                        │
     │ </div>                                                                                                                                       │
     │                                                                                                                                              │
     │ // React                                                                                                                                     │
     │ interface ProductCardProps {                                                                                                                 │
     │   product: Product;                                                                                                                          │
     │   onAddToCart: (id: number) => void;                                                                                                         │
     │ }                                                                                                                                            │
     │                                                                                                                                              │
     │ export const ProductCard: React.FC<ProductCardProps> = ({ product, onAddToCart }) => {                                                       │
     │   return (                                                                                                                                   │
     │     <div className="product-card">                                                                                                           │
     │       <h2>{product.name}</h2>                                                                                                                │
     │       <p className="price">${product.price.toFixed(2)}</p>                                                                                   │
     │       {product.inStock ? (                                                                                                                   │
     │         <button onClick={() => onAddToCart(product.id)}>                                                                                     │
     │           Add to Cart                                                                                                                        │
     │         </button>                                                                                                                            │
     │       ) : (                                                                                                                                  │
     │         <span className="out-of-stock">Out of Stock</span>                                                                                   │
     │       )}                                                                                                                                     │
     │     </div>                                                                                                                                   │
     │   );                                                                                                                                         │
     │ };                                                                                                                                           │
     │                                                                                                                                              │
     │ Claude Code Agent Usage:                                                                                                                     │
     │ Task (general-purpose): "Convert these Razor views [paste] to React                                                                          │
     │ components using TypeScript. Use React Hook Form for forms,                                                                                  │
     │ React Query for data fetching, and Tailwind CSS for styling."                                                                                │
     │                                                                                                                                              │
     │ Task (Explore): "Find all JavaScript files in the .NET project.                                                                              │
     │ Identify jQuery code, AJAX calls, and client-side validation                                                                                 │
     │ that needs to be converted to modern React patterns."                                                                                        │
     │                                                                                                                                              │
     │ ---                                                                                                                                          │
     │ Part 3: Claude Code Subagent Strategy                                                                                                        │
     │                                                                                                                                              │
     │ Agent Types & When to Use Them                                                                                                               │
     │                                                                                                                                              │
     │ | Agent Type      | Use Case                                      | Example Prompt                                             |             │
     │ |-----------------|-----------------------------------------------|------------------------------------------------------------|             │
     │ | Explore         | Understanding existing code, finding patterns | "Find all API endpoints and their request/response shapes" |             │
     │ | Plan            | Designing architecture, making decisions      | "Design the authentication flow for the new system"        |             │
     │ | general-purpose | Complex multi-step implementations            | "Migrate the OrderService including all dependencies"      |             │
     │                                                                                                                                              │
     │ Parallel Agent Workflow                                                                                                                      │
     │                                                                                                                                              │
     │ For maximum efficiency, launch agents in parallel:                                                                                           │
     │                                                                                                                                              │
     │ # Example: Migrating an e-commerce product module                                                                                            │
     │                                                                                                                                              │
     │ # Agent 1: Backend                                                                                                                           │
     │ Task (general-purpose): "Migrate ProductController and ProductService                                                                        │
     │ from .NET to NestJS. Include DTOs, validation, and error handling."                                                                          │
     │                                                                                                                                              │
     │ # Agent 2: Database                                                                                                                          │
     │ Task (general-purpose): "Create TypeORM entities for Product,                                                                                │
     │ Category, and ProductImage with all relationships."                                                                                          │
     │                                                                                                                                              │
     │ # Agent 3: Frontend                                                                                                                          │
     │ Task (general-purpose): "Create React components for product listing,                                                                        │
     │ product detail, and product search based on these Razor views [paste]."                                                                      │
     │                                                                                                                                              │
     │ Agent Prompt Templates                                                                                                                       │
     │                                                                                                                                              │
     │ Discovery Agent:                                                                                                                             │
     │ Analyze the [MODULE_NAME] module in this .NET project.                                                                                       │
     │                                                                                                                                              │
     │ Document:                                                                                                                                    │
     │ 1. All classes and their responsibilities                                                                                                    │
     │ 2. Dependencies and injected services                                                                                                        │
     │ 3. Database operations performed                                                                                                             │
     │ 4. External API calls made                                                                                                                   │
     │ 5. Business rules and validations                                                                                                            │
     │ 6. Edge cases and error handling                                                                                                             │
     │                                                                                                                                              │
     │ Output as structured markdown for migration planning.                                                                                        │
     │                                                                                                                                              │
     │ Migration Agent:                                                                                                                             │
     │ Convert [.NET_CODE] to [TARGET_FRAMEWORK].                                                                                                   │
     │                                                                                                                                              │
     │ Requirements:                                                                                                                                │
     │ - Maintain exact same business logic                                                                                                         │
     │ - Use idiomatic patterns for the target framework                                                                                            │
     │ - Include comprehensive error handling                                                                                                       │
     │ - Add TypeScript types for all data structures                                                                                               │
     │ - Include unit test skeletons                                                                                                                │
     │                                                                                                                                              │
     │ Constraints:                                                                                                                                 │
     │ - No external libraries beyond [ALLOWED_LIBS]                                                                                                │
     │ - Must be compatible with [VERSION]                                                                                                          │
     │                                                                                                                                              │
     │ ---                                                                                                                                          │
     │ Part 4: Project-Specific Strategies                                                                                                          │
     │                                                                                                                                              │
     │ E-commerce Store                                                                                                                             │
     │                                                                                                                                              │
     │ Complexity: High                                                                                                                             │
     │ Timeline: 3-4 weeks                                                                                                                          │
     │                                                                                                                                              │
     │ Priority Order:                                                                                                                              │
     │ 1. Product catalog (core functionality)                                                                                                      │
     │ 2. User authentication                                                                                                                       │
     │ 3. Shopping cart (session/local storage first)                                                                                               │
     │ 4. Checkout flow                                                                                                                             │
     │ 5. Order management                                                                                                                          │
     │ 6. Admin panel                                                                                                                               │
     │ 7. Payment integration (last - needs careful testing)                                                                                        │
     │                                                                                                                                              │
     │ Key Challenges:                                                                                                                              │
     │ - Payment gateway integration                                                                                                                │
     │ - Inventory management                                                                                                                       │
     │ - Order state machine                                                                                                                        │
     │ - Email notifications                                                                                                                        │
     │                                                                                                                                              │
     │ ---                                                                                                                                          │
     │ Portfolio with Blog                                                                                                                          │
     │                                                                                                                                              │
     │ Complexity: Low-Medium                                                                                                                       │
     │ Timeline: 1-2 weeks                                                                                                                          │
     │                                                                                                                                              │
     │ Priority Order:                                                                                                                              │
     │ 1. Static pages (About, Contact)                                                                                                             │
     │ 2. Blog post listing/detail                                                                                                                  │
     │ 3. Admin for blog CRUD                                                                                                                       │
     │ 4. Image upload handling                                                                                                                     │
     │ 5. SEO optimization                                                                                                                          │
     │                                                                                                                                              │
     │ Key Challenges:                                                                                                                              │
     │ - Rich text editor migration                                                                                                                 │
     │ - Image optimization                                                                                                                         │
     │ - SEO meta tags                                                                                                                              │
     │                                                                                                                                              │
     │ ---                                                                                                                                          │
     │ SaaS Application                                                                                                                             │
     │                                                                                                                                              │
     │ Complexity: Very High                                                                                                                        │
     │ Timeline: 4-6 weeks                                                                                                                          │
     │                                                                                                                                              │
     │ Priority Order:                                                                                                                              │
     │ 1. Multi-tenancy architecture                                                                                                                │
     │ 2. Authentication & team management                                                                                                          │
     │ 3. Subscription/billing                                                                                                                      │
     │ 4. Core feature modules                                                                                                                      │
     │ 5. Admin dashboard                                                                                                                           │
     │ 6. Reporting/analytics                                                                                                                       │
     │                                                                                                                                              │
     │ Key Challenges:                                                                                                                              │
     │ - Tenant isolation                                                                                                                           │
     │ - Subscription state management                                                                                                              │
     │ - Feature flags per plan                                                                                                                     │
     │                                                                                                                                              │
     │ ---                                                                                                                                          │
     │ Supply Chain Management                                                                                                                      │
     │                                                                                                                                              │
     │ Complexity: Very High                                                                                                                        │
     │ Timeline: 5-8 weeks                                                                                                                          │
     │                                                                                                                                              │
     │ Priority Order:                                                                                                                              │
     │ 1. Core data models (Products, Suppliers, Warehouses)                                                                                        │
     │ 2. Inventory tracking                                                                                                                        │
     │ 3. Order management                                                                                                                          │
     │ 4. Reporting engine                                                                                                                          │
     │ 5. Integration APIs                                                                                                                          │
     │ 6. Real-time dashboards                                                                                                                      │
     │                                                                                                                                              │
     │ Key Challenges:                                                                                                                              │
     │ - Complex business logic                                                                                                                     │
     │ - Real-time updates (WebSockets)                                                                                                             │
     │ - Report generation                                                                                                                          │
     │ - Audit logging                                                                                                                              │
     │                                                                                                                                              │
     │ ---                                                                                                                                          │
     │ Part 5: Acceleration Techniques                                                                                                              │
     │                                                                                                                                              │
     │ 1. Batch Similar Components                                                                                                                  │
     │                                                                                                                                              │
     │ Don't migrate one controller at a time. Group similar ones:                                                                                  │
     │ # Migrate all CRUD controllers at once                                                                                                       │
     │ Task (general-purpose): "Here are 5 .NET controllers that follow                                                                             │
     │ the same CRUD pattern [paste]. Generate NestJS equivalents for all,                                                                          │
     │ using a shared base service pattern."                                                                                                        │
     │                                                                                                                                              │
     │ 2. Generate from Contracts                                                                                                                   │
     │                                                                                                                                              │
     │ Extract interfaces/contracts first, then generate implementations:                                                                           │
     │ Task (general-purpose): "Extract all DTOs and interfaces from                                                                                │
     │ these .NET files. Generate TypeScript equivalents, then create                                                                               │
     │ NestJS services that implement these contracts."                                                                                             │
     │                                                                                                                                              │
     │ 3. Parallel Workstreams                                                                                                                      │
     │                                                                                                                                              │
     │ Work on database, backend, and frontend simultaneously:                                                                                      │
     │ - Day 1-3: All workstreams in discovery                                                                                                      │
     │ - Day 4+: Each workstream progresses independently                                                                                           │
     │ - Sync points: When APIs are defined, frontend can mock and build                                                                            │
     │                                                                                                                                              │
     │ 4. Scaffold, Then Customize                                                                                                                  │
     │                                                                                                                                              │
     │ Generate boilerplate aggressively:                                                                                                           │
     │ # NestJS                                                                                                                                     │
     │ nest g resource products                                                                                                                     │
     │ nest g resource orders                                                                                                                       │
     │ nest g resource users                                                                                                                        │
     │                                                                                                                                              │
     │ # Then use Claude Code to fill in the logic                                                                                                  │
     │                                                                                                                                              │
     │ 5. Test-Driven Migration                                                                                                                     │
     │                                                                                                                                              │
     │ Write tests for new code before migrating:                                                                                                   │
     │ Task (general-purpose): "Given this .NET service [paste], write                                                                              │
     │ Jest tests for a NestJS equivalent. Then implement the service                                                                               │
     │ to pass those tests."                                                                                                                        │
     │                                                                                                                                              │
     │ ---                                                                                                                                          │
     │ Part 6: Quality Checklist                                                                                                                    │
     │                                                                                                                                              │
     │ Before marking any module as "migrated":                                                                                                     │
     │                                                                                                                                              │
     │ - All API endpoints return same response shapes                                                                                              │
     │ - Error codes match or are mapped                                                                                                            │
     │ - Validation rules are equivalent                                                                                                            │
     │ - Authentication/authorization works                                                                                                         │
     │ - Database queries are optimized (check N+1)                                                                                                 │
     │ - Logging is implemented                                                                                                                     │
     │ - Unit tests cover critical paths                                                                                                            │
     │ - Integration tests for API endpoints                                                                                                        │
     │ - Manual testing against original behavior                                                                                                   │
     │                                                                                                                                              │
     │ ---                                                                                                                                          │
     │ Part 7: Common Pitfalls to Avoid                                                                                                             │
     │                                                                                                                                              │
     │ 1. Migrating everything at once - Do module by module                                                                                        │
     │ 2. Ignoring stored procedures - They contain business logic!                                                                                 │
     │ 3. 1:1 translation without improvement - Take opportunity to fix technical debt                                                              │
     │ 4. Skipping the discovery phase - You'll miss hidden dependencies                                                                            │
     │ 5. Not testing incrementally - Bugs compound when left unchecked                                                                             │
     │ 6. Underestimating auth complexity - .NET Identity is feature-rich                                                                           │
     │                                                                                                                                              │
     │ ---                                                                                                                                          │
     │ ---                                                                                                                                          │
     │ Part 8: Testing Strategies During Migration                                                                                                  │
     │                                                                                                                                              │
     │ The Testing Philosophy                                                                                                                       │
     │                                                                                                                                              │
     │ Key Principle: Don't migrate all code then test. Test incrementally as you migrate each module.                                              │
     │                                                                                                                                              │
     │ ┌─────────────────────────────────────────────────────────────────┐                                                                          │
     │ │                    Testing Pyramid for Migration                │                                                                          │
     │ ├─────────────────────────────────────────────────────────────────┤                                                                          │
     │ │                         E2E Tests                               │                                                                          │
     │ │                    (Critical User Flows)                        │                                                                          │
     │ │                          10-15%                                 │                                                                          │
     │ ├─────────────────────────────────────────────────────────────────┤                                                                          │
     │ │                    Integration Tests                            │                                                                          │
     │ │              (API endpoints, DB queries)                        │                                                                          │
     │ │                          30-35%                                 │                                                                          │
     │ ├─────────────────────────────────────────────────────────────────┤                                                                          │
     │ │                       Unit Tests                                │                                                                          │
     │ │              (Services, Utils, Validators)                      │                                                                          │
     │ │                          50-60%                                 │                                                                          │
     │ └─────────────────────────────────────────────────────────────────┘                                                                          │
     │                                                                                                                                              │
     │ ---                                                                                                                                          │
     │ Phase 1: Pre-Migration Test Extraction                                                                                                       │
     │                                                                                                                                              │
     │ Before migrating, extract test cases from the .NET project:                                                                                  │
     │                                                                                                                                              │
     │ Task (Explore): "Analyze all test files in the .NET project.                                                                                 │
     │ For each test:                                                                                                                               │
     │ - Document what it's testing (controller, service, etc.)                                                                                     │
     │ - Extract the test scenario (input → expected output)                                                                                        │
     │ - Note any mocked dependencies                                                                                                               │
     │ - Identify edge cases being tested                                                                                                           │
     │                                                                                                                                              │
     │ Output as a test specification document."                                                                                                    │
     │                                                                                                                                              │
     │ Test Specification Format:                                                                                                                   │
     │ ## ProductService Tests                                                                                                                      │
     │                                                                                                                                              │
     │ ### GetProductById                                                                                                                           │
     │ - Input: valid productId (1)                                                                                                                 │
     │ - Expected: Returns Product object with matching id                                                                                          │
     │ - Edge case: productId = 0 → throws ArgumentException                                                                                        │
     │ - Edge case: productId not found → throws NotFoundException                                                                                  │
     │                                                                                                                                              │
     │ ### CreateProduct                                                                                                                            │
     │ - Input: valid CreateProductDto                                                                                                              │
     │ - Expected: Returns created Product with generated Id                                                                                        │
     │ - Edge case: Name > 200 chars → validation error                                                                                             │
     │ - Edge case: Price < 0 → validation error                                                                                                    │
     │ - Edge case: CategoryId not exists → foreign key error                                                                                       │
     │                                                                                                                                              │
     │ ---                                                                                                                                          │
     │ Phase 2: Test-First Migration Pattern                                                                                                        │
     │                                                                                                                                              │
     │ For each module, write tests BEFORE migrating:                                                                                               │
     │                                                                                                                                              │
     │ # Step 1: Write NestJS service tests based on .NET behavior                                                                                  │
     │ Task (general-purpose): "Given these test specifications [paste],                                                                            │
     │ write Jest tests for a NestJS ProductService.                                                                                                │
     │ Use TypeORM repository mocks. Include all edge cases."                                                                                       │
     │                                                                                                                                              │
     │ # Step 2: Run tests (they fail)                                                                                                              │
     │ npm test -- --watch                                                                                                                          │
     │                                                                                                                                              │
     │ # Step 3: Migrate the service                                                                                                                │
     │ Task (general-purpose): "Migrate ProductService.cs to NestJS.                                                                                │
     │ Must pass all these existing tests [paste test file]."                                                                                       │
     │                                                                                                                                              │
     │ # Step 4: Tests pass → move to next module                                                                                                   │
     │                                                                                                                                              │
     │ ---                                                                                                                                          │
     │ Phase 3: Backend Testing Setup                                                                                                               │
     │                                                                                                                                              │
     │ NestJS Testing Configuration:                                                                                                                │
     │ // test/setup.ts                                                                                                                             │
     │ import { Test, TestingModule } from '@nestjs/testing';                                                                                       │
     │ import { TypeOrmModule } from '@nestjs/typeorm';                                                                                             │
     │ import { ConfigModule } from '@nestjs/config';                                                                                               │
     │                                                                                                                                              │
     │ export const createTestingModule = async (imports: any[], providers: any[]) => {                                                             │
     │   const module: TestingModule = await Test.createTestingModule({                                                                             │
     │     imports: [                                                                                                                               │
     │       ConfigModule.forRoot({ envFilePath: '.env.test' }),                                                                                    │
     │       TypeOrmModule.forRoot({                                                                                                                │
     │         type: 'postgres',                                                                                                                    │
     │         host: 'localhost',                                                                                                                   │
     │         port: 5433, // Different port for test DB                                                                                            │
     │         username: 'test',                                                                                                                    │
     │         password: 'test',                                                                                                                    │
     │         database: 'ecommerce_test',                                                                                                          │
     │         entities: [__dirname + '/../**/*.entity{.ts,.js}'],                                                                                  │
     │         synchronize: true, // OK for tests                                                                                                   │
     │         dropSchema: true,  // Fresh DB each run                                                                                              │
     │       }),                                                                                                                                    │
     │       ...imports,                                                                                                                            │
     │     ],                                                                                                                                       │
     │     providers,                                                                                                                               │
     │   }).compile();                                                                                                                              │
     │                                                                                                                                              │
     │   return module;                                                                                                                             │
     │ };                                                                                                                                           │
     │                                                                                                                                              │
     │ Unit Test Example (Service):                                                                                                                 │
     │ // products/products.service.spec.ts                                                                                                         │
     │ import { Test, TestingModule } from '@nestjs/testing';                                                                                       │
     │ import { getRepositoryToken } from '@nestjs/typeorm';                                                                                        │
     │ import { Repository } from 'typeorm';                                                                                                        │
     │ import { ProductsService } from './products.service';                                                                                        │
     │ import { Product } from './entities/product.entity';                                                                                         │
     │ import { NotFoundException, BadRequestException } from '@nestjs/common';                                                                     │
     │                                                                                                                                              │
     │ describe('ProductsService', () => {                                                                                                          │
     │   let service: ProductsService;                                                                                                              │
     │   let repository: jest.Mocked<Repository<Product>>;                                                                                          │
     │                                                                                                                                              │
     │   const mockProduct: Product = {                                                                                                             │
     │     id: 1,                                                                                                                                   │
     │     name: 'Test Product',                                                                                                                    │
     │     price: 99.99,                                                                                                                            │
     │     stock: 10,                                                                                                                               │
     │     categoryId: 1,                                                                                                                           │
     │     createdAt: new Date(),                                                                                                                   │
     │     updatedAt: new Date(),                                                                                                                   │
     │   };                                                                                                                                         │
     │                                                                                                                                              │
     │   beforeEach(async () => {                                                                                                                   │
     │     const module: TestingModule = await Test.createTestingModule({                                                                           │
     │       providers: [                                                                                                                           │
     │         ProductsService,                                                                                                                     │
     │         {                                                                                                                                    │
     │           provide: getRepositoryToken(Product),                                                                                              │
     │           useValue: {                                                                                                                        │
     │             findOne: jest.fn(),                                                                                                              │
     │             find: jest.fn(),                                                                                                                 │
     │             create: jest.fn(),                                                                                                               │
     │             save: jest.fn(),                                                                                                                 │
     │             delete: jest.fn(),                                                                                                               │
     │           },                                                                                                                                 │
     │         },                                                                                                                                   │
     │       ],                                                                                                                                     │
     │     }).compile();                                                                                                                            │
     │                                                                                                                                              │
     │     service = module.get<ProductsService>(ProductsService);                                                                                  │
     │     repository = module.get(getRepositoryToken(Product));                                                                                    │
     │   });                                                                                                                                        │
     │                                                                                                                                              │
     │   describe('findOne', () => {                                                                                                                │
     │     it('should return a product when found', async () => {                                                                                   │
     │       repository.findOne.mockResolvedValue(mockProduct);                                                                                     │
     │                                                                                                                                              │
     │       const result = await service.findOne(1);                                                                                               │
     │                                                                                                                                              │
     │       expect(result).toEqual(mockProduct);                                                                                                   │
     │       expect(repository.findOne).toHaveBeenCalledWith({ where: { id: 1 } });                                                                 │
     │     });                                                                                                                                      │
     │                                                                                                                                              │
     │     it('should throw NotFoundException when product not found', async () => {                                                                │
     │       repository.findOne.mockResolvedValue(null);                                                                                            │
     │                                                                                                                                              │
     │       await expect(service.findOne(999)).rejects.toThrow(NotFoundException);                                                                 │
     │     });                                                                                                                                      │
     │   });                                                                                                                                        │
     │                                                                                                                                              │
     │   describe('create', () => {                                                                                                                 │
     │     it('should create and return a product', async () => {                                                                                   │
     │       const createDto = { name: 'New Product', price: 49.99, categoryId: 1 };                                                                │
     │       repository.create.mockReturnValue({ ...createDto, id: 2 } as Product);                                                                 │
     │       repository.save.mockResolvedValue({ ...createDto, id: 2 } as Product);                                                                 │
     │                                                                                                                                              │
     │       const result = await service.create(createDto);                                                                                        │
     │                                                                                                                                              │
     │       expect(result.id).toBe(2);                                                                                                             │
     │       expect(result.name).toBe('New Product');                                                                                               │
     │     });                                                                                                                                      │
     │                                                                                                                                              │
     │     it('should throw BadRequestException for negative price', async () => {                                                                  │
     │       const createDto = { name: 'Bad Product', price: -10, categoryId: 1 };                                                                  │
     │                                                                                                                                              │
     │       await expect(service.create(createDto)).rejects.toThrow(BadRequestException);                                                          │
     │     });                                                                                                                                      │
     │   });                                                                                                                                        │
     │ });                                                                                                                                          │
     │                                                                                                                                              │
     │ Integration Test Example (Controller):                                                                                                       │
     │ // products/products.controller.spec.ts                                                                                                      │
     │ import { INestApplication, ValidationPipe } from '@nestjs/common';                                                                           │
     │ import { Test } from '@nestjs/testing';                                                                                                      │
     │ import * as request from 'supertest';                                                                                                        │
     │ import { AppModule } from '../app.module';                                                                                                   │
     │ import { getConnection } from 'typeorm';                                                                                                     │
     │                                                                                                                                              │
     │ describe('Products (e2e)', () => {                                                                                                           │
     │   let app: INestApplication;                                                                                                                 │
     │                                                                                                                                              │
     │   beforeAll(async () => {                                                                                                                    │
     │     const moduleRef = await Test.createTestingModule({                                                                                       │
     │       imports: [AppModule],                                                                                                                  │
     │     }).compile();                                                                                                                            │
     │                                                                                                                                              │
     │     app = moduleRef.createNestApplication();                                                                                                 │
     │     app.useGlobalPipes(new ValidationPipe());                                                                                                │
     │     await app.init();                                                                                                                        │
     │   });                                                                                                                                        │
     │                                                                                                                                              │
     │   afterAll(async () => {                                                                                                                     │
     │     await getConnection().close();                                                                                                           │
     │     await app.close();                                                                                                                       │
     │   });                                                                                                                                        │
     │                                                                                                                                              │
     │   beforeEach(async () => {                                                                                                                   │
     │     // Clean database before each test                                                                                                       │
     │     const connection = getConnection();                                                                                                      │
     │     await connection.synchronize(true);                                                                                                      │
     │   });                                                                                                                                        │
     │                                                                                                                                              │
     │   describe('GET /products', () => {                                                                                                          │
     │     it('should return empty array when no products', async () => {                                                                           │
     │       const response = await request(app.getHttpServer())                                                                                    │
     │         .get('/products')                                                                                                                    │
     │         .expect(200);                                                                                                                        │
     │                                                                                                                                              │
     │       expect(response.body).toEqual([]);                                                                                                     │
     │     });                                                                                                                                      │
     │                                                                                                                                              │
     │     it('should return paginated products', async () => {                                                                                     │
     │       // Seed data first                                                                                                                     │
     │       await request(app.getHttpServer())                                                                                                     │
     │         .post('/products')                                                                                                                   │
     │         .send({ name: 'Product 1', price: 10, categoryId: 1 });                                                                              │
     │                                                                                                                                              │
     │       const response = await request(app.getHttpServer())                                                                                    │
     │         .get('/products?page=1&limit=10')                                                                                                    │
     │         .expect(200);                                                                                                                        │
     │                                                                                                                                              │
     │       expect(response.body.data.length).toBe(1);                                                                                             │
     │       expect(response.body.meta.total).toBe(1);                                                                                              │
     │     });                                                                                                                                      │
     │   });                                                                                                                                        │
     │                                                                                                                                              │
     │   describe('POST /products', () => {                                                                                                         │
     │     it('should create a product', async () => {                                                                                              │
     │       const response = await request(app.getHttpServer())                                                                                    │
     │         .post('/products')                                                                                                                   │
     │         .send({ name: 'New Product', price: 99.99, categoryId: 1 })                                                                          │
     │         .expect(201);                                                                                                                        │
     │                                                                                                                                              │
     │       expect(response.body.name).toBe('New Product');                                                                                        │
     │       expect(response.body.id).toBeDefined();                                                                                                │
     │     });                                                                                                                                      │
     │                                                                                                                                              │
     │     it('should reject invalid product data', async () => {                                                                                   │
     │       await request(app.getHttpServer())                                                                                                     │
     │         .post('/products')                                                                                                                   │
     │         .send({ name: '', price: -1 }) // Invalid                                                                                            │
     │         .expect(400);                                                                                                                        │
     │     });                                                                                                                                      │
     │   });                                                                                                                                        │
     │ });                                                                                                                                          │
     │                                                                                                                                              │
     │ ---                                                                                                                                          │
     │ Phase 4: Frontend Testing Setup                                                                                                              │
     │                                                                                                                                              │
     │ React Testing Configuration:                                                                                                                 │
     │ // src/setupTests.ts                                                                                                                         │
     │ import '@testing-library/jest-dom';                                                                                                          │
     │ import { server } from './mocks/server';                                                                                                     │
     │                                                                                                                                              │
     │ beforeAll(() => server.listen());                                                                                                            │
     │ afterEach(() => server.resetHandlers());                                                                                                     │
     │ afterAll(() => server.close());                                                                                                              │
     │                                                                                                                                              │
     │ MSW (Mock Service Worker) Setup:                                                                                                             │
     │ // src/mocks/handlers.ts                                                                                                                     │
     │ import { rest } from 'msw';                                                                                                                  │
     │                                                                                                                                              │
     │ export const handlers = [                                                                                                                    │
     │   rest.get('/api/products', (req, res, ctx) => {                                                                                             │
     │     return res(                                                                                                                              │
     │       ctx.json([                                                                                                                             │
     │         { id: 1, name: 'Product 1', price: 99.99 },                                                                                          │
     │         { id: 2, name: 'Product 2', price: 149.99 },                                                                                         │
     │       ])                                                                                                                                     │
     │     );                                                                                                                                       │
     │   }),                                                                                                                                        │
     │                                                                                                                                              │
     │   rest.post('/api/cart', (req, res, ctx) => {                                                                                                │
     │     return res(ctx.json({ success: true }));                                                                                                 │
     │   }),                                                                                                                                        │
     │ ];                                                                                                                                           │
     │                                                                                                                                              │
     │ // src/mocks/server.ts                                                                                                                       │
     │ import { setupServer } from 'msw/node';                                                                                                      │
     │ import { handlers } from './handlers';                                                                                                       │
     │                                                                                                                                              │
     │ export const server = setupServer(...handlers);                                                                                              │
     │                                                                                                                                              │
     │ Component Test Example:                                                                                                                      │
     │ // components/ProductCard.test.tsx                                                                                                           │
     │ import { render, screen, fireEvent } from '@testing-library/react';                                                                          │
     │ import { ProductCard } from './ProductCard';                                                                                                 │
     │ import { CartProvider } from '../context/CartContext';                                                                                       │
     │                                                                                                                                              │
     │ const mockProduct = {                                                                                                                        │
     │   id: 1,                                                                                                                                     │
     │   name: 'Test Product',                                                                                                                      │
     │   price: 99.99,                                                                                                                              │
     │   image: '/test.jpg',                                                                                                                        │
     │   inStock: true,                                                                                                                             │
     │ };                                                                                                                                           │
     │                                                                                                                                              │
     │ const renderWithCart = (component: React.ReactNode) => {                                                                                     │
     │   return render(<CartProvider>{component}</CartProvider>);                                                                                   │
     │ };                                                                                                                                           │
     │                                                                                                                                              │
     │ describe('ProductCard', () => {                                                                                                              │
     │   it('displays product information', () => {                                                                                                 │
     │     renderWithCart(<ProductCard product={mockProduct} />);                                                                                   │
     │                                                                                                                                              │
     │     expect(screen.getByText('Test Product')).toBeInTheDocument();                                                                            │
     │     expect(screen.getByText('$99.99')).toBeInTheDocument();                                                                                  │
     │   });                                                                                                                                        │
     │                                                                                                                                              │
     │   it('shows add to cart button when in stock', () => {                                                                                       │
     │     renderWithCart(<ProductCard product={mockProduct} />);                                                                                   │
     │                                                                                                                                              │
     │     expect(screen.getByRole('button', { name: /add to cart/i })).toBeEnabled();                                                              │
     │   });                                                                                                                                        │
     │                                                                                                                                              │
     │   it('shows out of stock when not in stock', () => {                                                                                         │
     │     renderWithCart(<ProductCard product={{ ...mockProduct, inStock: false }} />);                                                            │
     │                                                                                                                                              │
     │     expect(screen.getByText(/out of stock/i)).toBeInTheDocument();                                                                           │
     │     expect(screen.queryByRole('button', { name: /add to cart/i })).not.toBeInTheDocument();                                                  │
     │   });                                                                                                                                        │
     │                                                                                                                                              │
     │   it('calls addToCart when button clicked', () => {                                                                                          │
     │     const onAddToCart = jest.fn();                                                                                                           │
     │     render(<ProductCard product={mockProduct} onAddToCart={onAddToCart} />);                                                                 │
     │                                                                                                                                              │
     │     fireEvent.click(screen.getByRole('button', { name: /add to cart/i }));                                                                   │
     │                                                                                                                                              │
     │     expect(onAddToCart).toHaveBeenCalledWith(mockProduct.id);                                                                                │
     │   });                                                                                                                                        │
     │ });                                                                                                                                          │
     │                                                                                                                                              │
     │ Hook Test Example:                                                                                                                           │
     │ // hooks/useCart.test.ts                                                                                                                     │
     │ import { renderHook, act } from '@testing-library/react-hooks';                                                                              │
     │ import { useCart } from './useCart';                                                                                                         │
     │ import { CartProvider } from '../context/CartContext';                                                                                       │
     │                                                                                                                                              │
     │ describe('useCart', () => {                                                                                                                  │
     │   const wrapper = ({ children }) => <CartProvider>{children}</CartProvider>;                                                                 │
     │                                                                                                                                              │
     │   it('starts with empty cart', () => {                                                                                                       │
     │     const { result } = renderHook(() => useCart(), { wrapper });                                                                             │
     │                                                                                                                                              │
     │     expect(result.current.items).toEqual([]);                                                                                                │
     │     expect(result.current.total).toBe(0);                                                                                                    │
     │   });                                                                                                                                        │
     │                                                                                                                                              │
     │   it('adds item to cart', async () => {                                                                                                      │
     │     const { result } = renderHook(() => useCart(), { wrapper });                                                                             │
     │                                                                                                                                              │
     │     await act(async () => {                                                                                                                  │
     │       await result.current.addToCart(1, 2);                                                                                                  │
     │     });                                                                                                                                      │
     │                                                                                                                                              │
     │     expect(result.current.items).toHaveLength(1);                                                                                            │
     │     expect(result.current.items[0].productId).toBe(1);                                                                                       │
     │     expect(result.current.items[0].quantity).toBe(2);                                                                                        │
     │   });                                                                                                                                        │
     │                                                                                                                                              │
     │   it('updates quantity for existing item', async () => {                                                                                     │
     │     const { result } = renderHook(() => useCart(), { wrapper });                                                                             │
     │                                                                                                                                              │
     │     await act(async () => {                                                                                                                  │
     │       await result.current.addToCart(1, 2);                                                                                                  │
     │       await result.current.addToCart(1, 3);                                                                                                  │
     │     });                                                                                                                                      │
     │                                                                                                                                              │
     │     expect(result.current.items).toHaveLength(1);                                                                                            │
     │     expect(result.current.items[0].quantity).toBe(5);                                                                                        │
     │   });                                                                                                                                        │
     │ });                                                                                                                                          │
     │                                                                                                                                              │
     │ ---                                                                                                                                          │
     │ Phase 5: E2E Testing with Playwright                                                                                                         │
     │                                                                                                                                              │
     │ Setup:                                                                                                                                       │
     │ npm install -D @playwright/test                                                                                                              │
     │ npx playwright install                                                                                                                       │
     │                                                                                                                                              │
     │ E2E Test Example:                                                                                                                            │
     │ // e2e/checkout.spec.ts                                                                                                                      │
     │ import { test, expect } from '@playwright/test';                                                                                             │
     │                                                                                                                                              │
     │ test.describe('Checkout Flow', () => {                                                                                                       │
     │   test.beforeEach(async ({ page }) => {                                                                                                      │
     │     // Login as test user                                                                                                                    │
     │     await page.goto('/login');                                                                                                               │
     │     await page.fill('[name="email"]', 'test@example.com');                                                                                   │
     │     await page.fill('[name="password"]', 'password123');                                                                                     │
     │     await page.click('button[type="submit"]');                                                                                               │
     │     await page.waitForURL('/');                                                                                                              │
     │   });                                                                                                                                        │
     │                                                                                                                                              │
     │   test('complete checkout flow', async ({ page }) => {                                                                                       │
     │     // Add product to cart                                                                                                                   │
     │     await page.goto('/products/1');                                                                                                          │
     │     await page.click('button:has-text("Add to Cart")');                                                                                      │
     │                                                                                                                                              │
     │     // Verify cart                                                                                                                           │
     │     await page.click('[data-testid="cart-icon"]');                                                                                           │
     │     await expect(page.locator('[data-testid="cart-item"]')).toHaveCount(1);                                                                  │
     │                                                                                                                                              │
     │     // Go to checkout                                                                                                                        │
     │     await page.click('button:has-text("Checkout")');                                                                                         │
     │                                                                                                                                              │
     │     // Fill address                                                                                                                          │
     │     await page.fill('[name="address.street"]', '123 Test St');                                                                               │
     │     await page.fill('[name="address.city"]', 'Test City');                                                                                   │
     │     await page.fill('[name="address.zip"]', '12345');                                                                                        │
     │     await page.click('button:has-text("Continue")');                                                                                         │
     │                                                                                                                                              │
     │     // Select shipping                                                                                                                       │
     │     await page.click('[data-testid="shipping-standard"]');                                                                                   │
     │     await page.click('button:has-text("Continue")');                                                                                         │
     │                                                                                                                                              │
     │     // Fill payment (Stripe test card)                                                                                                       │
     │     const stripeFrame = page.frameLocator('iframe[name^="__privateStripeFrame"]');                                                           │
     │     await stripeFrame.locator('[name="cardnumber"]').fill('4242424242424242');                                                               │
     │     await stripeFrame.locator('[name="exp-date"]').fill('12/25');                                                                            │
     │     await stripeFrame.locator('[name="cvc"]').fill('123');                                                                                   │
     │                                                                                                                                              │
     │     // Complete order                                                                                                                        │
     │     await page.click('button:has-text("Place Order")');                                                                                      │
     │                                                                                                                                              │
     │     // Verify success                                                                                                                        │
     │     await expect(page.locator('h1')).toContainText('Order Confirmed');                                                                       │
     │     await expect(page.locator('[data-testid="order-number"]')).toBeVisible();                                                                │
     │   });                                                                                                                                        │
     │                                                                                                                                              │
     │   test('shows error for out of stock item', async ({ page }) => {                                                                            │
     │     // Attempt to add out-of-stock item                                                                                                      │
     │     await page.goto('/products/999'); // Out of stock product                                                                                │
     │                                                                                                                                              │
     │     await expect(page.locator('button:has-text("Add to Cart")')).toBeDisabled();                                                             │
     │     await expect(page.locator('text=Out of Stock')).toBeVisible();                                                                           │
     │   });                                                                                                                                        │
     │ });                                                                                                                                          │
     │                                                                                                                                              │
     │ ---                                                                                                                                          │
     │ Phase 6: Behavior Parity Testing                                                                                                             │
     │                                                                                                                                              │
     │ Goal: Ensure migrated system behaves identically to original.                                                                                │
     │                                                                                                                                              │
     │ Task (general-purpose): "Create a behavior parity test suite.                                                                                │
     │ For each .NET API endpoint, create a test that:                                                                                              │
     │ 1. Calls the original .NET endpoint (if running in parallel)                                                                                 │
     │ 2. Calls the new NestJS endpoint                                                                                                             │
     │ 3. Compares responses for structural equality                                                                                                │
     │ 4. Logs any differences                                                                                                                      │
     │                                                                                                                                              │
     │ This validates the migration maintains exact behavior."                                                                                      │
     │                                                                                                                                              │
     │ Parity Test Example:                                                                                                                         │
     │ // parity/products.parity.test.ts                                                                                                            │
     │ import axios from 'axios';                                                                                                                   │
     │                                                                                                                                              │
     │ const DOTNET_BASE = 'http://localhost:5000';                                                                                                 │
     │ const NESTJS_BASE = 'http://localhost:3000';                                                                                                 │
     │                                                                                                                                              │
     │ describe('Products API Parity', () => {                                                                                                      │
     │   it('GET /products returns same structure', async () => {                                                                                   │
     │     const [dotnetResponse, nestjsResponse] = await Promise.all([                                                                             │
     │       axios.get(`${DOTNET_BASE}/api/products`),                                                                                              │
     │       axios.get(`${NESTJS_BASE}/api/products`),                                                                                              │
     │     ]);                                                                                                                                      │
     │                                                                                                                                              │
     │     // Compare structure, not exact values (IDs may differ)                                                                                  │
     │     expect(nestjsResponse.data.length).toBe(dotnetResponse.data.length);                                                                     │
     │                                                                                                                                              │
     │     // Compare first item structure                                                                                                          │
     │     const dotnetKeys = Object.keys(dotnetResponse.data[0]).sort();                                                                           │
     │     const nestjsKeys = Object.keys(nestjsResponse.data[0]).sort();                                                                           │
     │     expect(nestjsKeys).toEqual(dotnetKeys);                                                                                                  │
     │   });                                                                                                                                        │
     │                                                                                                                                              │
     │   it('POST /products creates with same response shape', async () => {                                                                        │
     │     const productData = {                                                                                                                    │
     │       name: 'Parity Test Product',                                                                                                           │
     │       price: 99.99,                                                                                                                          │
     │       categoryId: 1,                                                                                                                         │
     │     };                                                                                                                                       │
     │                                                                                                                                              │
     │     const [dotnetResponse, nestjsResponse] = await Promise.all([                                                                             │
     │       axios.post(`${DOTNET_BASE}/api/products`, productData),                                                                                │
     │       axios.post(`${NESTJS_BASE}/api/products`, productData),                                                                                │
     │     ]);                                                                                                                                      │
     │                                                                                                                                              │
     │     // Same status code                                                                                                                      │
     │     expect(nestjsResponse.status).toBe(dotnetResponse.status);                                                                               │
     │                                                                                                                                              │
     │     // Same response shape                                                                                                                   │
     │     expect(Object.keys(nestjsResponse.data).sort())                                                                                          │
     │       .toEqual(Object.keys(dotnetResponse.data).sort());                                                                                     │
     │   });                                                                                                                                        │
     │ });                                                                                                                                          │
     │                                                                                                                                              │
     │ ---                                                                                                                                          │
     │ Testing Checklist Per Module                                                                                                                 │
     │                                                                                                                                              │
     │ Before marking any module as "migrated":                                                                                                     │
     │                                                                                                                                              │
     │ - Unit tests for all service methods                                                                                                         │
     │ - Unit tests for edge cases and error paths                                                                                                  │
     │ - Controller integration tests                                                                                                               │
     │ - Database query tests (verify SQL is correct)                                                                                               │
     │ - Validation tests (DTOs reject invalid input)                                                                                               │
     │ - Auth tests (protected routes require auth)                                                                                                 │
     │ - Parity tests against original .NET (if running parallel)                                                                                   │
     │ - E2E test for critical user flow                                                                                                            │
     │ - Performance test (response times acceptable)                                                                                               │
     │                                                                                                                                              │
     │ ---                                                                                                                                          │
     │ Claude Code Agent Prompts for Testing                                                                                                        │
     │                                                                                                                                              │
     │ Generate Unit Tests:                                                                                                                         │
     │ Task (general-purpose): "Given this NestJS service [paste],                                                                                  │
     │ write comprehensive Jest unit tests. Include:                                                                                                │
     │ - Happy path for each method                                                                                                                 │
     │ - Error cases (not found, validation, etc.)                                                                                                  │
     │ - Edge cases (empty input, null, boundaries)                                                                                                 │
     │ - Mock all dependencies                                                                                                                      │
     │                                                                                                                                              │
     │ Use AAA pattern (Arrange, Act, Assert)."                                                                                                     │
     │                                                                                                                                              │
     │ Generate Integration Tests:                                                                                                                  │
     │ Task (general-purpose): "Given this NestJS controller [paste],                                                                               │
     │ write supertest integration tests. Include:                                                                                                  │
     │ - All HTTP methods (GET, POST, PUT, DELETE)                                                                                                  │
     │ - Authentication scenarios (no auth, valid auth, admin only)                                                                                 │
     │ - Pagination and filtering                                                                                                                   │
     │ - Error response formats                                                                                                                     │
     │                                                                                                                                              │
     │ Test against a real test database."                                                                                                          │
     │                                                                                                                                              │
     │ Generate E2E Tests:                                                                                                                          │
     │ Task (general-purpose): "Write Playwright E2E tests for the                                                                                  │
     │ checkout flow. Cover:                                                                                                                        │
     │ - Guest checkout                                                                                                                             │
     │ - Logged-in user checkout                                                                                                                    │
     │ - Address validation errors                                                                                                                  │
     │ - Payment failure handling                                                                                                                   │
     │ - Stock depletion during checkout                                                                                                            │
     │ - Order confirmation page"                                                                                                                   │
     │                                                                                                                                              │
     │ ---                                                                                                                                          │
     │ Part 9: E-commerce Deep Dive                                                                                                                 │
     │                                                                                                                                              │
     │ Typical .NET E-commerce Structure                                                                                                            │
     │                                                                                                                                              │
     │ /EcommerceApp                                                                                                                                │
     │ ├── Controllers/                                                                                                                             │
     │ │   ├── AccountController.cs        # Auth, profile                                                                                          │
     │ │   ├── CartController.cs           # Shopping cart                                                                                          │
     │ │   ├── CheckoutController.cs       # Payment flow                                                                                           │
     │ │   ├── HomeController.cs           # Landing pages                                                                                          │
     │ │   ├── OrderController.cs          # Order history                                                                                          │
     │ │   ├── ProductController.cs        # Catalog, search                                                                                        │
     │ │   └── AdminController.cs          # Back-office                                                                                            │
     │ ├── Models/                                                                                                                                  │
     │ │   ├── ApplicationUser.cs          # Extended Identity user                                                                                 │
     │ │   ├── Product.cs                                                                                                                           │
     │ │   ├── Category.cs                                                                                                                          │
     │ │   ├── Cart.cs                                                                                                                              │
     │ │   ├── CartItem.cs                                                                                                                          │
     │ │   ├── Order.cs                                                                                                                             │
     │ │   ├── OrderItem.cs                                                                                                                         │
     │ │   ├── Address.cs                                                                                                                           │
     │ │   └── Payment.cs                                                                                                                           │
     │ ├── Services/                                                                                                                                │
     │ │   ├── IProductService.cs                                                                                                                   │
     │ │   ├── ProductService.cs                                                                                                                    │
     │ │   ├── ICartService.cs                                                                                                                      │
     │ │   ├── CartService.cs                                                                                                                       │
     │ │   ├── IOrderService.cs                                                                                                                     │
     │ │   ├── OrderService.cs                                                                                                                      │
     │ │   ├── IPaymentService.cs                                                                                                                   │
     │ │   └── PaymentService.cs                                                                                                                    │
     │ ├── Views/                                                                                                                                   │
     │ │   ├── Home/                                                                                                                                │
     │ │   ├── Product/                                                                                                                             │
     │ │   ├── Cart/                                                                                                                                │
     │ │   ├── Checkout/                                                                                                                            │
     │ │   └── Shared/                                                                                                                              │
     │ └── Data/                                                                                                                                    │
     │     ├── ApplicationDbContext.cs                                                                                                              │
     │     └── Migrations/                                                                                                                          │
     │                                                                                                                                              │
     │ Target NestJS + React Structure                                                                                                              │
     │                                                                                                                                              │
     │ /ecommerce-backend (NestJS)                                                                                                                  │
     │ ├── src/                                                                                                                                     │
     │ │   ├── modules/                                                                                                                             │
     │ │   │   ├── auth/                                                                                                                            │
     │ │   │   │   ├── auth.module.ts                                                                                                               │
     │ │   │   │   ├── auth.controller.ts                                                                                                           │
     │ │   │   │   ├── auth.service.ts                                                                                                              │
     │ │   │   │   ├── jwt.strategy.ts                                                                                                              │
     │ │   │   │   ├── local.strategy.ts                                                                                                            │
     │ │   │   │   └── dto/                                                                                                                         │
     │ │   │   ├── users/                                                                                                                           │
     │ │   │   │   ├── users.module.ts                                                                                                              │
     │ │   │   │   ├── users.service.ts                                                                                                             │
     │ │   │   │   ├── entities/user.entity.ts                                                                                                      │
     │ │   │   │   └── dto/                                                                                                                         │
     │ │   │   ├── products/                                                                                                                        │
     │ │   │   │   ├── products.module.ts                                                                                                           │
     │ │   │   │   ├── products.controller.ts                                                                                                       │
     │ │   │   │   ├── products.service.ts                                                                                                          │
     │ │   │   │   ├── entities/                                                                                                                    │
     │ │   │   │   │   ├── product.entity.ts                                                                                                        │
     │ │   │   │   │   └── category.entity.ts                                                                                                       │
     │ │   │   │   └── dto/                                                                                                                         │
     │ │   │   ├── cart/                                                                                                                            │
     │ │   │   │   ├── cart.module.ts                                                                                                               │
     │ │   │   │   ├── cart.controller.ts                                                                                                           │
     │ │   │   │   ├── cart.service.ts                                                                                                              │
     │ │   │   │   ├── entities/                                                                                                                    │
     │ │   │   │   │   ├── cart.entity.ts                                                                                                           │
     │ │   │   │   │   └── cart-item.entity.ts                                                                                                      │
     │ │   │   │   └── dto/                                                                                                                         │
     │ │   │   ├── orders/                                                                                                                          │
     │ │   │   │   ├── orders.module.ts                                                                                                             │
     │ │   │   │   ├── orders.controller.ts                                                                                                         │
     │ │   │   │   ├── orders.service.ts                                                                                                            │
     │ │   │   │   ├── entities/                                                                                                                    │
     │ │   │   │   │   ├── order.entity.ts                                                                                                          │
     │ │   │   │   │   └── order-item.entity.ts                                                                                                     │
     │ │   │   │   └── dto/                                                                                                                         │
     │ │   │   └── payments/                                                                                                                        │
     │ │   │       ├── payments.module.ts                                                                                                           │
     │ │   │       ├── payments.controller.ts                                                                                                       │
     │ │   │       ├── payments.service.ts                                                                                                          │
     │ │   │       └── stripe.service.ts                                                                                                            │
     │ │   ├── common/                                                                                                                              │
     │ │   │   ├── guards/                                                                                                                          │
     │ │   │   │   ├── jwt-auth.guard.ts                                                                                                            │
     │ │   │   │   └── roles.guard.ts                                                                                                               │
     │ │   │   ├── decorators/                                                                                                                      │
     │ │   │   │   ├── current-user.decorator.ts                                                                                                    │
     │ │   │   │   └── roles.decorator.ts                                                                                                           │
     │ │   │   └── interceptors/                                                                                                                    │
     │ │   │       └── transform.interceptor.ts                                                                                                     │
     │ │   └── database/                                                                                                                            │
     │ │       ├── database.module.ts                                                                                                               │
     │ │       └── migrations/                                                                                                                      │
     │                                                                                                                                              │
     │ /ecommerce-frontend (React)                                                                                                                  │
     │ ├── src/                                                                                                                                     │
     │ │   ├── components/                                                                                                                          │
     │ │   │   ├── layout/                                                                                                                          │
     │ │   │   │   ├── Header.tsx                                                                                                                   │
     │ │   │   │   ├── Footer.tsx                                                                                                                   │
     │ │   │   │   └── Sidebar.tsx                                                                                                                  │
     │ │   │   ├── product/                                                                                                                         │
     │ │   │   │   ├── ProductCard.tsx                                                                                                              │
     │ │   │   │   ├── ProductGrid.tsx                                                                                                              │
     │ │   │   │   ├── ProductDetail.tsx                                                                                                            │
     │ │   │   │   └── ProductSearch.tsx                                                                                                            │
     │ │   │   ├── cart/                                                                                                                            │
     │ │   │   │   ├── CartDrawer.tsx                                                                                                               │
     │ │   │   │   ├── CartItem.tsx                                                                                                                 │
     │ │   │   │   └── CartSummary.tsx                                                                                                              │
     │ │   │   └── checkout/                                                                                                                        │
     │ │   │       ├── CheckoutForm.tsx                                                                                                             │
     │ │   │       ├── AddressForm.tsx                                                                                                              │
     │ │   │       └── PaymentForm.tsx                                                                                                              │
     │ │   ├── pages/                                                                                                                               │
     │ │   │   ├── Home.tsx                                                                                                                         │
     │ │   │   ├── ProductList.tsx                                                                                                                  │
     │ │   │   ├── ProductDetail.tsx                                                                                                                │
     │ │   │   ├── Cart.tsx                                                                                                                         │
     │ │   │   ├── Checkout.tsx                                                                                                                     │
     │ │   │   ├── OrderHistory.tsx                                                                                                                 │
     │ │   │   └── admin/                                                                                                                           │
     │ │   ├── hooks/                                                                                                                               │
     │ │   │   ├── useAuth.ts                                                                                                                       │
     │ │   │   ├── useCart.ts                                                                                                                       │
     │ │   │   ├── useProducts.ts                                                                                                                   │
     │ │   │   └── useOrders.ts                                                                                                                     │
     │ │   ├── services/                                                                                                                            │
     │ │   │   ├── api.ts              # Axios instance                                                                                             │
     │ │   │   ├── auth.service.ts                                                                                                                  │
     │ │   │   ├── product.service.ts                                                                                                               │
     │ │   │   ├── cart.service.ts                                                                                                                  │
     │ │   │   └── order.service.ts                                                                                                                 │
     │ │   ├── store/                                                                                                                               │
     │ │   │   ├── cartSlice.ts                                                                                                                     │
     │ │   │   ├── authSlice.ts                                                                                                                     │
     │ │   │   └── store.ts                                                                                                                         │
     │ │   └── types/                                                                                                                               │
     │ │       ├── product.ts                                                                                                                       │
     │ │       ├── cart.ts                                                                                                                          │
     │ │       ├── order.ts                                                                                                                         │
     │ │       └── user.ts                                                                                                                          │
     │                                                                                                                                              │
     │ ---                                                                                                                                          │
     │ E-commerce Migration: Week-by-Week Plan                                                                                                      │
     │                                                                                                                                              │
     │ Week 1: Foundation & Core Catalog                                                                                                            │
     │                                                                                                                                              │
     │ Day 1-2: Project Setup & Database                                                                                                            │
     │ # Backend setup                                                                                                                              │
     │ nest new ecommerce-backend                                                                                                                   │
     │ cd ecommerce-backend                                                                                                                         │
     │ npm install @nestjs/typeorm typeorm pg                                                                                                       │
     │ npm install @nestjs/passport passport passport-jwt passport-local                                                                            │
     │ npm install @nestjs/config class-validator class-transformer                                                                                 │
     │ npm install bcrypt                                                                                                                           │
     │                                                                                                                                              │
     │ # Frontend setup                                                                                                                             │
     │ npx create-react-app ecommerce-frontend --template typescript                                                                                │
     │ cd ecommerce-frontend                                                                                                                        │
     │ npm install axios react-router-dom @tanstack/react-query                                                                                     │
     │ npm install zustand # or redux toolkit                                                                                                       │
     │ npm install react-hook-form zod @hookform/resolvers                                                                                          │
     │ npm install tailwindcss postcss autoprefixer                                                                                                 │
     │                                                                                                                                              │
     │ Day 2-3: Database Migration                                                                                                                  │
     │                                                                                                                                              │
     │ Claude Code Agent Prompts:                                                                                                                   │
     │ Task (Explore): "Analyze the ApplicationDbContext.cs file.                                                                                   │
     │ List all DbSet properties, their relationships (1:1, 1:N, N:N),                                                                              │
     │ and any custom configurations in OnModelCreating."                                                                                           │
     │                                                                                                                                              │
     │ Task (general-purpose): "Convert these Entity Framework models                                                                               │
     │ to TypeORM entities:                                                                                                                         │
     │ - Product (with Category relationship)                                                                                                       │
     │ - Category (hierarchical - parent/child)                                                                                                     │
     │ - ProductImage (1:N with Product)                                                                                                            │
     │ Include all indexes, constraints, and cascades."                                                                                             │
     │                                                                                                                                              │
     │ Day 3-4: Product Module (Backend)                                                                                                            │
     │ Task (general-purpose): "Migrate ProductController.cs to NestJS.                                                                             │
     │ Include these endpoints:                                                                                                                     │
     │ - GET /products (with pagination, filtering, sorting)                                                                                        │
     │ - GET /products/:id                                                                                                                          │
     │ - GET /products/category/:categoryId                                                                                                         │
     │ - GET /products/search?q=keyword                                                                                                             │
     │ - POST /products (admin only)                                                                                                                │
     │ - PUT /products/:id (admin only)                                                                                                             │
     │ - DELETE /products/:id (admin only)                                                                                                          │
     │                                                                                                                                              │
     │ Include validation DTOs and Swagger documentation."                                                                                          │
     │                                                                                                                                              │
     │ Day 4-5: Product Module (Frontend)                                                                                                           │
     │ Task (general-purpose): "Create React components for product catalog:                                                                        │
     │ 1. ProductCard - displays single product                                                                                                     │
     │ 2. ProductGrid - responsive grid of ProductCards                                                                                             │
     │ 3. ProductFilters - category, price range, sorting                                                                                           │
     │ 4. ProductSearch - search input with debounce                                                                                                │
     │ 5. ProductDetail - full product page with images                                                                                             │
     │                                                                                                                                              │
     │ Use React Query for data fetching and Tailwind for styling."                                                                                 │
     │                                                                                                                                              │
     │ ---                                                                                                                                          │
     │ Week 2: Authentication & Cart                                                                                                                │
     │                                                                                                                                              │
     │ Day 6-7: Auth Module                                                                                                                         │
     │                                                                                                                                              │
     │ .NET Identity to NestJS translation:                                                                                                         │
     │ Task (Plan): "Design authentication migration from .NET Identity to NestJS.                                                                  │
     │ The .NET project uses:                                                                                                                       │
     │ - Cookie-based session auth for MVC views                                                                                                    │
     │ - JWT for API endpoints                                                                                                                      │
     │ - Role-based authorization (Admin, Customer)                                                                                                 │
     │ - Remember me functionality                                                                                                                  │
     │ - Password reset via email                                                                                                                   │
     │                                                                                                                                              │
     │ Design a Passport.js + JWT implementation that handles all these cases."                                                                     │
     │                                                                                                                                              │
     │ Task (general-purpose): "Implement the auth module:                                                                                          │
     │ - Local strategy for login                                                                                                                   │
     │ - JWT strategy for protected routes                                                                                                          │
     │ - Refresh token mechanism                                                                                                                    │
     │ - Guards for role-based access                                                                                                               │
     │ - Password hashing with bcrypt                                                                                                               │
     │                                                                                                                                              │
     │ Include these endpoints:                                                                                                                     │
     │ POST /auth/register                                                                                                                          │
     │ POST /auth/login                                                                                                                             │
     │ POST /auth/refresh                                                                                                                           │
     │ POST /auth/logout                                                                                                                            │
     │ POST /auth/forgot-password                                                                                                                   │
     │ POST /auth/reset-password"                                                                                                                   │
     │                                                                                                                                              │
     │ Day 8-9: Cart Module                                                                                                                         │
     │                                                                                                                                              │
     │ Key complexity: .NET often stores cart in session or DB, React needs different approach.                                                     │
     │                                                                                                                                              │
     │ Task (Plan): "The .NET app stores shopping cart in server session                                                                            │
     │ with fallback to database for logged-in users. Design a React                                                                                │
     │ cart implementation that:                                                                                                                    │
     │ - Uses localStorage for guest users                                                                                                          │
     │ - Syncs to server for authenticated users                                                                                                    │
     │ - Merges guest cart with user cart on login                                                                                                  │
     │ - Handles stock validation in real-time"                                                                                                     │
     │                                                                                                                                              │
     │ Task (general-purpose): "Implement cart module for NestJS:                                                                                   │
     │ - Cart entity with CartItems                                                                                                                 │
     │ - Add to cart (with quantity, validate stock)                                                                                                │
     │ - Update quantity                                                                                                                            │
     │ - Remove item                                                                                                                                │
     │ - Clear cart                                                                                                                                 │
     │ - Get cart total (with any active discounts)                                                                                                 │
     │ - Cart merging logic for guest→user conversion"                                                                                              │
     │                                                                                                                                              │
     │ Day 9-10: Cart Frontend                                                                                                                      │
     │ Task (general-purpose): "Create cart React components:                                                                                       │
     │ 1. CartProvider - context for cart state                                                                                                     │
     │ 2. useCart hook - add, remove, update, clear                                                                                                 │
     │ 3. CartDrawer - slide-out cart preview                                                                                                       │
     │ 4. CartPage - full cart with checkout button                                                                                                 │
     │ 5. CartItem - editable quantity, remove button                                                                                               │
     │                                                                                                                                              │
     │ Implement optimistic updates and error recovery."                                                                                            │
     │                                                                                                                                              │
     │ ---                                                                                                                                          │
     │ Week 3: Checkout & Orders                                                                                                                    │
     │                                                                                                                                              │
     │ Day 11-13: Checkout Flow                                                                                                                     │
     │                                                                                                                                              │
     │ This is the most complex part - handle carefully:                                                                                            │
     │                                                                                                                                              │
     │ Task (Explore): "Analyze the CheckoutController.cs flow.                                                                                     │
     │ Document each step:                                                                                                                          │
     │ 1. Address validation                                                                                                                        │
     │ 2. Shipping method selection                                                                                                                 │
     │ 3. Payment processing                                                                                                                        │
     │ 4. Order creation                                                                                                                            │
     │ 5. Inventory deduction                                                                                                                       │
     │ 6. Email confirmation                                                                                                                        │
     │ Identify error handling at each step."                                                                                                       │
     │                                                                                                                                              │
     │ Task (Plan): "Design checkout flow for NestJS + React.                                                                                       │
     │ Key requirements:                                                                                                                            │
     │ - Multi-step form (address → shipping → payment → confirm)                                                                                   │
     │ - Payment via Stripe (migrating from whatever .NET used)                                                                                     │
     │ - Transaction handling (rollback if payment fails)                                                                                           │
     │ - Stock reservation during checkout                                                                                                          │
     │ - Race condition handling for limited inventory"                                                                                             │
     │                                                                                                                                              │
     │ Task (general-purpose): "Implement order placement flow:                                                                                     │
     │ 1. Checkout initiation - validate cart, reserve stock                                                                                        │
     │ 2. Create Stripe PaymentIntent                                                                                                               │
     │ 3. On payment success webhook:                                                                                                               │
     │    - Create Order with OrderItems                                                                                                            │
     │    - Decrement inventory                                                                                                                     │
     │    - Clear cart                                                                                                                              │
     │    - Send confirmation email                                                                                                                 │
     │ 4. Handle payment failures gracefully"                                                                                                       │
     │                                                                                                                                              │
     │ Day 13-14: Order Management                                                                                                                  │
     │ Task (general-purpose): "Create orders module:                                                                                               │
     │ - Order entity with OrderItem, Address, Payment reference                                                                                    │
     │ - Order status enum (Pending, Paid, Shipped, Delivered, Cancelled)                                                                           │
     │ - GET /orders (user's orders with pagination)                                                                                                │
     │ - GET /orders/:id (with items and status history)                                                                                            │
     │ - Admin endpoints for status updates                                                                                                         │
     │ - Order cancellation logic (refund + inventory restore)"                                                                                     │
     │                                                                                                                                              │
     │ Day 14-15: Checkout Frontend                                                                                                                 │
     │ Task (general-purpose): "Implement multi-step checkout:                                                                                      │
     │ 1. AddressForm with validation (react-hook-form + zod)                                                                                       │
     │ 2. ShippingOptions radio selection                                                                                                           │
     │ 3. PaymentForm with Stripe Elements                                                                                                          │
     │ 4. OrderConfirmation summary                                                                                                                 │
     │ 5. CheckoutStepper for progress indication                                                                                                   │
     │                                                                                                                                              │
     │ Include loading states, error handling, and order success page."                                                                             │
     │                                                                                                                                              │
     │ ---                                                                                                                                          │
     │ Week 4: Admin Panel & Polish                                                                                                                 │
     │                                                                                                                                              │
     │ Day 16-18: Admin Dashboard                                                                                                                   │
     │ Task (Explore): "Analyze AdminController in .NET project.                                                                                    │
     │ List all admin functionality:                                                                                                                │
     │ - Product CRUD                                                                                                                               │
     │ - Order management                                                                                                                           │
     │ - User management                                                                                                                            │
     │ - Reports/analytics                                                                                                                          │
     │ - Inventory management"                                                                                                                      │
     │                                                                                                                                              │
     │ Task (general-purpose): "Create admin module with:                                                                                           │
     │ - Dashboard with sales metrics                                                                                                               │
     │ - Product management (CRUD + bulk operations)                                                                                                │
     │ - Order list with filtering and status updates                                                                                               │
     │ - Customer list with order history                                                                                                           │
     │ - Low stock alerts                                                                                                                           │
     │                                                                                                                                              │
     │ Use a table library like TanStack Table for data grids."                                                                                     │
     │                                                                                                                                              │
     │ Day 18-20: Testing & Fixes                                                                                                                   │
     │ Task (general-purpose): "Write comprehensive tests:                                                                                          │
     │                                                                                                                                              │
     │ Backend (Jest):                                                                                                                              │
     │ - Unit tests for services                                                                                                                    │
     │ - Integration tests for controllers                                                                                                          │
     │ - E2E tests for critical flows (checkout, auth)                                                                                              │
     │                                                                                                                                              │
     │ Frontend (React Testing Library):                                                                                                            │
     │ - Component tests                                                                                                                            │
     │ - Hook tests                                                                                                                                 │
     │ - Integration tests for user flows"                                                                                                          │
     │                                                                                                                                              │
     │ Day 20-21: Deployment Prep                                                                                                                   │
     │ - Environment configuration                                                                                                                  │
     │ - Docker setup                                                                                                                               │
     │ - CI/CD pipeline                                                                                                                             │
     │ - Database migrations for production                                                                                                         │
     │                                                                                                                                              │
     │ ---                                                                                                                                          │
     │ E-commerce: Critical Code Translations                                                                                                       │
     │                                                                                                                                              │
     │ Shopping Cart Session → JWT + Database                                                                                                       │
     │                                                                                                                                              │
     │ .NET (Session-based):                                                                                                                        │
     │ public class CartService : ICartService                                                                                                      │
     │ {                                                                                                                                            │
     │     private readonly IHttpContextAccessor _httpContext;                                                                                      │
     │     private readonly ApplicationDbContext _context;                                                                                          │
     │                                                                                                                                              │
     │     private Cart GetCartFromSession()                                                                                                        │
     │     {                                                                                                                                        │
     │         var session = _httpContext.HttpContext.Session;                                                                                      │
     │         var cartJson = session.GetString("Cart");                                                                                            │
     │         if (cartJson == null) return new Cart();                                                                                             │
     │         return JsonSerializer.Deserialize<Cart>(cartJson);                                                                                   │
     │     }                                                                                                                                        │
     │                                                                                                                                              │
     │     public void AddToCart(int productId, int quantity)                                                                                       │
     │     {                                                                                                                                        │
     │         var cart = GetCartFromSession();                                                                                                     │
     │         var existingItem = cart.Items.FirstOrDefault(i => i.ProductId == productId);                                                         │
     │                                                                                                                                              │
     │         if (existingItem != null)                                                                                                            │
     │             existingItem.Quantity += quantity;                                                                                               │
     │         else                                                                                                                                 │
     │             cart.Items.Add(new CartItem { ProductId = productId, Quantity = quantity });                                                     │
     │                                                                                                                                              │
     │         SaveCartToSession(cart);                                                                                                             │
     │     }                                                                                                                                        │
     │ }                                                                                                                                            │
     │                                                                                                                                              │
     │ NestJS (JWT + Database):                                                                                                                     │
     │ @Injectable()                                                                                                                                │
     │ export class CartService {                                                                                                                   │
     │   constructor(                                                                                                                               │
     │     @InjectRepository(Cart)                                                                                                                  │
     │     private cartRepository: Repository<Cart>,                                                                                                │
     │     @InjectRepository(CartItem)                                                                                                              │
     │     private cartItemRepository: Repository<CartItem>,                                                                                        │
     │     @InjectRepository(Product)                                                                                                               │
     │     private productRepository: Repository<Product>,                                                                                          │
     │   ) {}                                                                                                                                       │
     │                                                                                                                                              │
     │   async getOrCreateCart(userId: number): Promise<Cart> {                                                                                     │
     │     let cart = await this.cartRepository.findOne({                                                                                           │
     │       where: { user: { id: userId } },                                                                                                       │
     │       relations: ['items', 'items.product'],                                                                                                 │
     │     });                                                                                                                                      │
     │                                                                                                                                              │
     │     if (!cart) {                                                                                                                             │
     │       cart = this.cartRepository.create({ user: { id: userId } });                                                                           │
     │       await this.cartRepository.save(cart);                                                                                                  │
     │     }                                                                                                                                        │
     │                                                                                                                                              │
     │     return cart;                                                                                                                             │
     │   }                                                                                                                                          │
     │                                                                                                                                              │
     │   async addToCart(userId: number, productId: number, quantity: number): Promise<Cart> {                                                      │
     │     const cart = await this.getOrCreateCart(userId);                                                                                         │
     │     const product = await this.productRepository.findOne({ where: { id: productId } });                                                      │
     │                                                                                                                                              │
     │     if (!product) {                                                                                                                          │
     │       throw new NotFoundException('Product not found');                                                                                      │
     │     }                                                                                                                                        │
     │                                                                                                                                              │
     │     if (product.stock < quantity) {                                                                                                          │
     │       throw new BadRequestException('Insufficient stock');                                                                                   │
     │     }                                                                                                                                        │
     │                                                                                                                                              │
     │     const existingItem = cart.items.find(item => item.product.id === productId);                                                             │
     │                                                                                                                                              │
     │     if (existingItem) {                                                                                                                      │
     │       existingItem.quantity += quantity;                                                                                                     │
     │       await this.cartItemRepository.save(existingItem);                                                                                      │
     │     } else {                                                                                                                                 │
     │       const newItem = this.cartItemRepository.create({                                                                                       │
     │         cart,                                                                                                                                │
     │         product,                                                                                                                             │
     │         quantity,                                                                                                                            │
     │         priceAtTime: product.price, // Capture price at add time                                                                             │
     │       });                                                                                                                                    │
     │       await this.cartItemRepository.save(newItem);                                                                                           │
     │     }                                                                                                                                        │
     │                                                                                                                                              │
     │     return this.getOrCreateCart(userId);                                                                                                     │
     │   }                                                                                                                                          │
     │ }                                                                                                                                            │
     │                                                                                                                                              │
     │ React (Zustand Store + API):                                                                                                                 │
     │ // store/cartStore.ts                                                                                                                        │
     │ interface CartStore {                                                                                                                        │
     │   items: CartItem[];                                                                                                                         │
     │   isLoading: boolean;                                                                                                                        │
     │   addToCart: (productId: number, quantity: number) => Promise<void>;                                                                         │
     │   removeFromCart: (itemId: number) => Promise<void>;                                                                                         │
     │   updateQuantity: (itemId: number, quantity: number) => Promise<void>;                                                                       │
     │   syncCart: () => Promise<void>;                                                                                                             │
     │   total: number;                                                                                                                             │
     │ }                                                                                                                                            │
     │                                                                                                                                              │
     │ export const useCartStore = create<CartStore>((set, get) => ({                                                                               │
     │   items: [],                                                                                                                                 │
     │   isLoading: false,                                                                                                                          │
     │                                                                                                                                              │
     │   get total() {                                                                                                                              │
     │     return get().items.reduce(                                                                                                               │
     │       (sum, item) => sum + item.product.price * item.quantity,                                                                               │
     │       0                                                                                                                                      │
     │     );                                                                                                                                       │
     │   },                                                                                                                                         │
     │                                                                                                                                              │
     │   addToCart: async (productId, quantity) => {                                                                                                │
     │     set({ isLoading: true });                                                                                                                │
     │     try {                                                                                                                                    │
     │       const cart = await cartService.addToCart(productId, quantity);                                                                         │
     │       set({ items: cart.items });                                                                                                            │
     │     } catch (error) {                                                                                                                        │
     │       // Handle error - show toast, etc.                                                                                                     │
     │     } finally {                                                                                                                              │
     │       set({ isLoading: false });                                                                                                             │
     │     }                                                                                                                                        │
     │   },                                                                                                                                         │
     │                                                                                                                                              │
     │   syncCart: async () => {                                                                                                                    │
     │     const cart = await cartService.getCart();                                                                                                │
     │     set({ items: cart.items });                                                                                                              │
     │   },                                                                                                                                         │
     │ }));                                                                                                                                         │
     │                                                                                                                                              │
     │ // hooks/useCart.ts                                                                                                                          │
     │ export const useCart = () => {                                                                                                               │
     │   const store = useCartStore();                                                                                                              │
     │   const { isAuthenticated } = useAuth();                                                                                                     │
     │                                                                                                                                              │
     │   // Sync cart from server when user logs in                                                                                                 │
     │   useEffect(() => {                                                                                                                          │
     │     if (isAuthenticated) {                                                                                                                   │
     │       store.syncCart();                                                                                                                      │
     │     }                                                                                                                                        │
     │   }, [isAuthenticated]);                                                                                                                     │
     │                                                                                                                                              │
     │   return store;                                                                                                                              │
     │ };                                                                                                                                           │
     │                                                                                                                                              │
     │ ---                                                                                                                                          │
     │ E-commerce: Common Pitfalls                                                                                                                  │
     │                                                                                                                                              │
     │ 1. Cart price inconsistency - Capture price at add-time, not checkout-time                                                                   │
     │ 2. Race conditions on stock - Use database transactions                                                                                      │
     │ 3. Payment webhook reliability - Implement idempotency keys                                                                                  │
     │ 4. Guest cart merging - Handle duplicate products gracefully                                                                                 │
     │ 5. Address validation - Use a service like Google Places or custom validation                                                                │
     │                                                                                                                                              │
     │ ---                                                                                                                                          │
     │ Next Steps                                                                                                                                   │
     │                                                                                                                                              │
     │ To start your first migration:                                                                                                               │
     │                                                                                                                                              │
     │ 1. Share the .NET project structure (tree output)                                                                                            │
     │ 2. Share key files: Program.cs, Startup.cs, any DbContext                                                                                    │
     │ 3. Identify the first module to migrate                                                                                                      │
     │ 4. I'll create a detailed task breakdown using Claude Code agents                                                                            │
     │                                                                                                                                              │
     │ Ready to become a migration expert!                                                                                                          │
     ╰──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯

> I do not want any code, just brainstorming. Do not write/produce any code. Simple brainstorming.

● Got it! Let's brainstorm the migration strategy conceptually - no code, just ideas and thinking.

  Key Questions to Brainstorm

  1. Migration Strategy: Big Bang vs Strangler Fig

  - Big Bang: Build entire new system, switch over in one go
    - Risk: Higher, but cleaner cut
    - Good for: Smaller apps, complete rewrites wanted
  - Strangler Fig: Gradually replace pieces while old system runs
    - Risk: Lower, but more complex to manage two systems
    - Good for: Large apps, can't afford downtime

  Which approach resonates more with your situation?

  2. What Makes Migrations Slow?

  From my understanding, the bottlenecks are usually:
  - Discovery paralysis - not fully understanding the legacy system
  - Hidden business logic - buried in stored procedures, event handlers
  - Authentication complexity - .NET Identity is deeply integrated
  - Testing gaps - migrating without confidence
  - Decision fatigue - too many choices in the JS ecosystem

  3. Where Claude Code Agents Add Most Value

  Thinking about your goal to go from months to weeks:
  - Pattern recognition - agents can scan entire codebases fast
  - Repetitive translations - CRUD controllers, DTOs, entities
  - Documentation extraction - pulling logic out of legacy code
  - Parallel workstreams - multiple agents working simultaneously

● User declined to answer questions

> feature parity and speed both. I want 100% parity for UI and backend/db. We do big bang. The problem with current migration approach is the context
window, when I do migration even with multiple agents the main thread/agent context goes out, plus the sub agents context also fills (example: a backend
 sub agent of node.js which creates backend code) I know we can divide work in more smaller and make sure sub agent do not face context issue. But how
to solve main agent problem which orchestrate this. For example other day I used 10 agents - researcher, explorer, architect, reviewere, coder and QA
agent and tried to migrate a project small .net legacy in one go. The main thread context becomes 199%. How this problem can be solved. Do we need an
approach where we explore individual module > divide it more chunks > use more coder agent > finish or create multiple orchastration like for Module 1
one orchastration and if it is big then it can have its own orchastrations. But again when we start fresh claude session how do we make sure that our
agent knows we are doing migration and we are done this much and has to start from here while taking care of these things and things learnet from
previous sessions.

● This is the REAL problem. You've hit the fundamental limitation. Let me brainstorm solutions:

  The Core Issue

  Main Orchestrator (199% context)
  ├── Researcher Agent (fills up)
  ├── Explorer Agent (fills up)
  ├── Architect Agent (fills up)
  ├── Coder Agent (fills up)
  ├── Reviewer Agent (fills up)
  └── QA Agent (fills up)

  Everything lives in memory. When session ends, knowledge dies.

  ---
  Brainstorm: Externalized Memory Architecture

  Idea 1: The Migration Manifest

  Instead of keeping state in context, externalize it to files:

  /migration/
  ├── manifest.md          ← Overall progress, what's done, what's next
  ├── decisions.md         ← "We chose Zustand over Redux because..."
  ├── patterns.md          ← "In this codebase, services follow X pattern"
  ├── modules/
  │   ├── auth/
  │   │   ├── status.md    ← "Auth module: 80% complete, pending: refresh tokens"
  │   │   ├── mapping.md   ← ".NET file → JS file mapping"
  │   │   └── issues.md    ← "Found edge case: guest users with expired tokens"
  │   ├── products/
  │   │   ├── status.md
  │   │   └── ...
  │   └── orders/

  When new session starts, orchestrator reads manifest.md first → knows exactly where to resume.

  ---
  Idea 2: Thin Orchestrator Pattern

  The main orchestrator should be DUMB and THIN:
  - It doesn't hold business logic context
  - It only reads state files and dispatches work
  - Each module has its OWN orchestrator that holds module-specific context

  Session 1:
    Main Orchestrator reads manifest → "Auth module next"
    → Spawns Auth Module Orchestrator
    → Auth Orchestrator does the work, writes to auth/status.md
    → Session ends

  Session 2:
    Main Orchestrator reads manifest → "Auth done, Products next"
    → Spawns Products Module Orchestrator
    → Continues...

  The main thread stays thin because it's just a dispatcher reading files.

  ---
  Idea 3: Hierarchical Orchestration

  For BIG modules that need their own orchestration:

  Migration Orchestrator (thin)
  │
  ├── Module: Auth (small) → Single Agent handles it
  │
  ├── Module: Orders (HUGE)
  │   └── Orders Sub-Orchestrator
  │       ├── Feature: Order Creation
  │       ├── Feature: Order Status
  │       ├── Feature: Order History
  │       └── Feature: Refunds
  │
  └── Module: Products (medium) → 2-3 agents

  Each sub-orchestrator is a fresh session with its own context budget.

  ---
  Idea 4: Session Handoff Protocol

  At END of every session:
  1. Write current state to status files
  2. Write "next steps" explicitly
  3. Write any learned patterns/decisions
  4. Write blockers or questions

  At START of new session:
  1. Read CLAUDE.md (project-level)
  2. Read manifest.md (migration-level)
  3. Read relevant module status.md
  4. Resume from "next steps"

  ---
  Idea 5: The "Migration Brain" File

  One file that serves as the persistent memory:

  # Migration Brain

  ## Current State
  - Phase: Backend Migration
  - Current Module: Orders
  - Current Task: OrderService.CreateOrder method
  - Blockers: None

  ## Completed
  - [x] Database schema migrated
  - [x] Auth module (100%)
  - [x] Products module (100%)
  - [ ] Orders module (40%)
    - [x] Order entity
    - [x] OrderItem entity
    - [ ] OrderService ← IN PROGRESS
    - [ ] OrderController

  ## Decisions Made
  - Using TypeORM (not Prisma) because existing team knows it
  - Cart stored in DB, not session
  - Stripe for payments (was PayPal in .NET)

  ## Patterns Discovered
  - .NET project uses Repository pattern → map to TypeORM repositories
  - All controllers inherit from BaseController with auth
  - DateTime stored as UTC everywhere

  ## Next Session Should
  1. Complete OrderService.CreateOrder
  2. Handle the inventory deduction logic
  3. Write tests for order creation

  New session reads this → instant context recovery.

  ---
  The Key Insight

  You can't solve context limits by being smarter in context. You solve it by moving intelligence OUTSIDE of context into persistent files.

  Think of it like:
  - Human memory (context window) = limited, temporary
  - Written notes (files) = unlimited, permanent

  The orchestrator becomes a "reader of notes" not a "holder of knowledge."

  ---
  Questions to Think About

  1. Granularity: How small should each work unit be? Per file? Per function? Per module?
  2. Handoff format: What does the status file need to contain for seamless resume?
  3. Decision preservation: How do we capture "why" not just "what"?
  4. Validation: When resuming, how do we verify previous work is still valid?
  5. Rollback: If sub-agent makes a mistake, how does orchestrator know to redo?

  What's your reaction to this direction? Does externalizing state to files resonate with how you'd want to work?

> 1. Each work has to be per feature small - like implement order delete backend API, or implement delete order frontend.\ 2. The status file you say
from experience what has to contain? \ 3. We capture it in document, the human gives input why and waht decision made like why choose nest.js over
express or zustand over redux. \ 4. We validate by reading the manifest file about the status of that work, each module has status file, and in that
status file it has feature progress, everytime an agent complete the feature it update that module status file. we can have 4 status - not started,
in-progress, ready for review and complete. \ 5. If sub agent make mistake I'm not sure you tell me we need a mechanism to rollback its work and make
sure it is atomic like db transations.

● Great refinements. Let me dig into #2 and #5 since you asked for my input:

  ---
  Status File Contents (What I'd Include)

  Based on what makes sessions resumable:

  Module Status File Structure:

  MODULE: Orders
  OVERALL: 60% complete

  FEATURES:
  ┌─────────────────────────┬───────────────┬─────────────────────┐
  │ Feature                 │ Status        │ Last Updated        │
  ├─────────────────────────┼───────────────┼─────────────────────┤
  │ Order Entity            │ complete      │ 2024-01-15          │
  │ OrderItem Entity        │ complete      │ 2024-01-15          │
  │ Create Order API        │ complete      │ 2024-01-16          │
  │ Get Order API           │ complete      │ 2024-01-16          │
  │ Delete Order API        │ in-progress   │ 2024-01-17          │
  │ Order List Frontend     │ not-started   │ -                   │
  │ Order Detail Frontend   │ not-started   │ -                   │
  └─────────────────────────┴───────────────┴─────────────────────┘

  CURRENT WORK:
  - Feature: Delete Order API
  - Agent: backend-coder
  - Branch: feature/orders-delete-api
  - Started: 2024-01-17 10:30

  BLOCKERS:
  - None currently

  DEPENDENCIES DISCOVERED:
  - Delete order needs to restore inventory (calls InventoryService)
  - Delete order needs to refund payment (calls PaymentService)
  - Soft delete vs hard delete? (DECISION NEEDED)

  FILES MAPPED:
  - OrderController.cs → src/modules/orders/orders.controller.ts
  - OrderService.cs → src/modules/orders/orders.service.ts
  - Order.cs → src/modules/orders/entities/order.entity.ts

  EDGE CASES FOUND:
  - Orders with partial shipments cannot be deleted
  - Orders older than 90 days archived, different delete logic

  QUESTIONS FOR HUMAN:
  - Soft delete or hard delete for orders?
  - Keep audit trail of deleted orders?

  NEXT UP (QUEUE):
  1. Delete Order API (current)
  2. Order List Frontend
  3. Order Detail Frontend

  Why These Sections:

  | Section       | Purpose                           |
  |---------------|-----------------------------------|
  | Feature table | Quick scan of progress            |
  | Current work  | Exactly where we stopped          |
  | Blockers      | Why we might be stuck             |
  | Dependencies  | What we learned about connections |
  | Files mapped  | Don't re-discover this            |
  | Edge cases    | Critical knowledge not to lose    |
  | Questions     | Human input needed                |
  | Next up       | Clear queue for orchestrator      |

  ---
  Rollback Mechanism - Making Agent Work Atomic

  This is the hard problem. Here's my thinking:

  Approach: Git Branch per Feature

  main (stable, migrated code)
  │
  ├── feature/orders-delete-api      ← Agent works here
  ├── feature/orders-list-frontend   ← Next agent works here
  └── feature/orders-detail-frontend ← Queued

  The Transaction Flow:

  1. BEFORE agent starts:
     - Create branch from main
     - Record branch name in status file
     - Status: in-progress

  2. AGENT works:
     - All changes on feature branch
     - Can make multiple commits
     - Updates status file with progress

  3. AFTER agent finishes:
     - Status: ready-for-review
     - QA agent or human reviews

  4. IF REVIEW PASSES:
     - Merge branch to main
     - Delete feature branch
     - Status: complete

  5. IF REVIEW FAILS:
     - Delete branch (rollback)
     - Status: not-started (or "failed-needs-retry")
     - Log what went wrong
     - Queue for retry with learnings

  Why This Works:
  - Git gives us free rollback (just delete branch)
  - Main branch is always in working state
  - Each feature is isolated
  - Can review before "committing" to main
  - History preserved for debugging

  ---
  The Retry Problem

  When a feature fails review, we need to capture WHY so next attempt doesn't repeat:

  FAILED ATTEMPTS:
  ┌─────────────────┬─────────────────────────────────────────────┐
  │ Feature         │ Delete Order API                            │
  │ Attempt         │ 1                                           │
  │ Date            │ 2024-01-17                                  │
  │ Branch          │ feature/orders-delete-api-v1 (deleted)      │
  │ Failure Reason  │ Didn't handle partial shipment case         │
  │ Learnings       │ Must check shipment status before delete    │
  │ Next Attempt    │ Include shipment validation first           │
  └─────────────────┴─────────────────────────────────────────────┘

  Next agent reads this → doesn't make same mistake.

  ---
  Orchestrator Decision Tree

  When orchestrator starts a session:

  Read manifest.md
      │
      ├── Any "in-progress" features?
      │   └── YES → Resume that feature (same agent type)
      │
      ├── Any "ready-for-review" features?
      │   └── YES → Spawn QA agent to review
      │
      ├── Any "failed-needs-retry" features?
      │   └── YES → Read failure learnings, respawn with context
      │
      └── All clear?
          └── Pick next "not-started" feature from queue

  ---
  The Atomic Guarantee

  To truly be atomic:

  1. No partial merges - Feature either fully merges or not at all
  2. Tests must pass - Part of review, branch won't merge with failing tests
  3. Dependencies explicit - If feature A needs feature B, B must be complete first
  4. Checkpoint before start - Know exactly what state to return to

  Edge Case: What if agent dies mid-work?

  - Branch exists but incomplete
  - Status says "in-progress" but agent gone
  - Solution: Orchestrator sees stale "in-progress" (no update in X time)
  - Action: Delete branch, reset to "not-started", retry fresh

  ---
  Open Questions for You

  1. Review gate: Human review every feature? Or automated QA agent sufficient for most?
  2. Batch vs Individual: Merge features one by one, or batch several then merge?
  3. Dependency handling: If Delete Order depends on Inventory Service (not yet migrated), do we:
    - Mock it and continue?
    - Block until dependency done?
    - Flag and let human decide?
  4. Retry limit: How many failed attempts before escalating to human?

  What's your instinct on these?

> 1. First QA agent review work "verify with legacy" then human does the review.\ 2. Features merge one by one.\ 3. if it depends on another then in
status we mention it depends on this feature, every time a feature complete it check if dependent feature can be started, then it change its status to
ready for development from dependent, description say dependent on x feature. so basically block until dependency done. \ 4. 2 failed attempts

● Solid decisions. Let me synthesize and push further:

  ---
  The Complete Feature Lifecycle

  ┌─────────────────────────────────────────────────────────────────┐
  │                        FEATURE STATES                           │
  ├─────────────────────────────────────────────────────────────────┤
  │                                                                 │
  │  dependent ──→ ready-for-dev ──→ in-progress ──→ ready-for-qa  │
  │       │              │                               │          │
  │       │              │                               ▼          │
  │       │              │                          QA-review       │
  │       │              │                               │          │
  │       │              │              ┌────────────────┼────────┐ │
  │       │              │              ▼                ▼        │ │
  │       │              │         QA-passed        QA-failed     │ │
  │       │              │              │                │        │ │
  │       │              │              ▼                ▼        │ │
  │       │              │        human-review     retry (max 2)  │ │
  │       │              │              │                │        │ │
  │       │              │       ┌──────┴──────┐         │        │ │
  │       │              │       ▼             ▼         │        │ │
  │       │              │   complete    needs-rework    │        │ │
  │       │              │       │             │         │        │ │
  │       │              │       │             └─────────┘        │ │
  │       │              │       │                                │ │
  │       │              │       ▼                                │ │
  │       │              │   [triggers dependent features         │ │
  │       │              │    to become ready-for-dev]            │ │
  │       │              │                                        │ │
  └──────────────────────┴────────────────────────────────────────┘

  ---
  Status Values (Final List)

  | Status        | Meaning                      | Next Action                                   |
  |---------------|------------------------------|-----------------------------------------------|
  | dependent     | Blocked on another feature   | Wait, auto-unblocks when dependency completes |
  | ready-for-dev | Can be picked up             | Orchestrator assigns to coder agent           |
  | in-progress   | Agent working on it          | Wait for agent to finish                      |
  | ready-for-qa  | Code done, needs QA          | Orchestrator assigns to QA agent              |
  | qa-passed     | QA verified against legacy   | Human reviews                                 |
  | qa-failed     | QA found issues              | Retry (up to 2x) or escalate                  |
  | human-review  | Waiting for human            | Human approves or requests changes            |
  | needs-rework  | Human requested changes      | Goes back to ready-for-dev with feedback      |
  | complete      | Done, merged to main         | Triggers dependents                           |
  | escalated     | 2 failures, needs human help | Human intervention required                   |

  ---
  Dependency Graph Thinking

  Each feature declares its dependencies upfront:

  FEATURE: Delete Order API
  DEPENDS_ON:
    - Inventory Service (restore stock on delete)
    - Payment Service (refund on delete)
  STATUS: dependent
  BLOCKED_BY: Inventory Service (in-progress), Payment Service (not-started)

  When Inventory Service completes:
  BLOCKED_BY: Payment Service (in-progress)  ← auto-updated

  When Payment Service completes:
  STATUS: ready-for-dev  ← auto-promoted
  BLOCKED_BY: (none)

  Who Updates This?

  The orchestrator, after each feature completes:
  1. Feature X marked complete
  2. Orchestrator scans all features with dependent status
  3. For each, checks if all dependencies now complete
  4. If yes → promote to ready-for-dev

  ---
  QA Agent: "Verify Against Legacy"

  This is interesting. How does QA agent verify?

  Option A: Side-by-side API calls
  - QA agent calls legacy .NET endpoint
  - QA agent calls new NestJS endpoint
  - Compares response structure, status codes, behavior
  - Reports differences

  Option B: Behavior checklist
  - During discovery phase, we documented expected behaviors
  - QA agent runs through checklist
  - Checks each behavior exists in new code

  Option C: Test parity
  - If .NET had tests, we extracted test cases
  - QA runs equivalent tests against new code
  - Must pass same scenarios

  Option D: Combination
  - Critical paths: Side-by-side comparison
  - Edge cases: Behavior checklist
  - Regression: Test parity

  Which resonates? Or all combined?

  ---
  Retry Logic

  ATTEMPT 1:
    Agent: backend-coder
    Result: qa-failed
    Reason: "Missing inventory restoration logic"
    Learning: "Must call inventoryService.restore() before delete"

  ATTEMPT 2:
    Agent: backend-coder
    Context: Includes learning from attempt 1
    Result: qa-failed
    Reason: "Inventory restored but payment not refunded"
    Learning: "Must also call paymentService.refund()"

  ATTEMPT 3:
    Status: escalated
    Human notified with:
      - Both failure reasons
      - Both learnings
      - Agent's attempted solutions
      - Suggestion: "This feature has complex dependencies,
                     may need architecture review"

  Key Insight: Each retry gets MORE context (previous learnings), so it should theoretically get closer. If 2 attempts with accumulated learning still fail, it's likely a fundamental issue needing human judgment.

  ---
  The Orchestrator's Job (Super Thin)

  Every session, orchestrator does:

  1. READ state files (manifest, module statuses)

  2. FIND next action:
     - Any escalated? → Alert human, wait
     - Any human-review? → Wait for human
     - Any ready-for-qa? → Spawn QA agent
     - Any qa-passed? → Notify human for review
     - Any in-progress but stale? → Reset, retry
     - Any ready-for-dev? → Spawn coder agent
     - Any newly unblocked? → Update to ready-for-dev
     - Nothing to do? → Migration complete or fully blocked

  3. DISPATCH one task (keep orchestrator thin)

  4. WAIT for agent to complete

  5. UPDATE state files based on result

  6. LOOP or END session

  Orchestrator holds minimal context - just reads files, makes one decision, dispatches.

  ---
  Open Threads to Explore

  1. Discovery phase output: Before any coding, we need a complete map. What does that look like? Feature list with dependencies?
  2. Parallelization: Can multiple features be in-progress simultaneously if no dependencies? Multiple coder agents?
  3. Human review interface: How does human review? Just looks at PR? Runs the app? Checklist?
  4. Cross-module dependencies: Feature in Orders depends on feature in Payments (different module). How tracked?
  5. The "legacy running" requirement: For QA to compare, legacy must be running. Always? Or we capture responses during discovery?

  Which thread do you want to pull?

> 1. You tell me which is best in our scenario. \ 2. Yes, we can use git worktree to not pollute single branch for multiple feature change, yes multi
coder agents. make sure they do not be so big to make main agent context large.\3. Yes human looks at PR, runs the app. \ 4. You tell me? \ 5. we always
 check legacy code when comparing, instead of running legacy always we can look at its code and take decision.

● Let me give you my recommendations:

  ---
  1. QA Verification Method (My Recommendation)

  Given:
  - 100% parity goal
  - Not running legacy constantly
  - Looking at legacy code instead

  Best approach: Behavior Documentation + Code Comparison

  DISCOVERY PHASE:
    └── Extract from legacy code:
        - Function purpose
        - Input validation rules
        - Business logic steps
        - Edge cases handled
        - Error responses
        - Database operations
        └── Save as "behavior spec" per feature

  QA PHASE:
    └── QA Agent:
        1. Reads behavior spec (from discovery)
        2. Reads new code
        3. Verifies each behavior exists in new code
        4. Checks edge cases covered
        5. Compares error handling
        └── Reports: MATCH / MISMATCH with specifics

  Why this works:
  - No need to run legacy
  - Behavior spec is the "contract"
  - QA is comparing implementation against spec
  - Deterministic - same spec, same judgment

  Behavior Spec Example:

  FEATURE: Delete Order API
  ENDPOINT: DELETE /api/orders/{id}

  VALIDATION:
    - Order must exist (404 if not)
    - Order must belong to user (403 if not) OR user is admin
    - Order status must be "pending" or "confirmed" (400 if shipped/delivered)
    - Order must not be older than 30 days (400 if older)

  BUSINESS LOGIC:
    1. Check order has no partial shipments
    2. If order has payment:
       - Call PaymentService.Refund(orderId)
       - Wait for refund confirmation
    3. Restore inventory:
       - For each OrderItem, call InventoryService.Restore(productId, quantity)
    4. Soft delete order (set DeletedAt = now)
    5. Send cancellation email to customer

  ERROR CASES:
    - Refund fails → Rollback, return 500 with "Refund failed"
    - Inventory restore fails → Log warning, continue (non-blocking)

  RESPONSE:
    - Success: 204 No Content
    - With body option: { "refundId": "xxx", "refundAmount": 99.99 }

  QA agent reads this, reads new code, checks each point.

  ---
  4. Cross-Module Dependencies (My Recommendation)

  The Problem:
  - Orders module's "Delete Order" needs Payments module's "Refund" feature
  - Different modules, different status files
  - How to track and unblock?

  My Recommendation: Layered Migration Order + Global Dependency File

  Layer 1: Shared Services (migrate first)
  shared/
  ├── payment/     ← Used by Orders, Subscriptions
  ├── inventory/   ← Used by Orders, Products
  ├── email/       ← Used by everything
  ├── auth/        ← Used by everything
  └── storage/     ← Used by Products, Users

  Layer 2: Core Modules (after shared)
  modules/
  ├── users/       ← Depends on: auth, email, storage
  ├── products/    ← Depends on: inventory, storage
  ├── orders/      ← Depends on: payment, inventory, email
  └── ...

  Layer 3: Secondary Modules (after core)
  modules/
  ├── analytics/   ← Depends on: orders, products, users
  ├── reports/     ← Depends on: everything
  └── admin/       ← Depends on: everything

  Global Dependency Manifest:

  /migration/dependencies.md

  MIGRATION ORDER:
    Layer 1 (Shared) → Layer 2 (Core) → Layer 3 (Secondary)

  CROSS-MODULE DEPENDENCIES:

  ┌─────────────────┬────────────────────────────────────────┐
  │ Feature         │ Depends On                             │
  ├─────────────────┼────────────────────────────────────────┤
  │ orders/delete   │ shared/payment/refund                  │
  │                 │ shared/inventory/restore               │
  ├─────────────────┼────────────────────────────────────────┤
  │ orders/create   │ shared/payment/charge                  │
  │                 │ shared/inventory/reserve               │
  ├─────────────────┼────────────────────────────────────────┤
  │ products/delete │ shared/inventory/clear                 │
  │                 │ shared/storage/cleanup                 │
  └─────────────────┴────────────────────────────────────────┘

  SHARED SERVICE STATUS:

  ┌─────────────────────────┬───────────────┐
  │ Shared Service          │ Status        │
  ├─────────────────────────┼───────────────┤
  │ shared/auth             │ complete      │
  │ shared/email            │ complete      │
  │ shared/payment/charge   │ complete      │
  │ shared/payment/refund   │ in-progress   │  ← Orders waiting on this
  │ shared/inventory        │ ready-for-dev │
  │ shared/storage          │ not-started   │
  └─────────────────────────┴───────────────┘

  How Orchestrator Uses This:

  1. Before migrating any module feature, check dependencies.md
  2. If shared dependency not complete → feature stays dependent
  3. When shared service completes → scan all features, unblock those waiting

  Why Layered:
  - Shared services have NO cross-dependencies (or minimal)
  - They can be migrated first, in parallel
  - Once shared layer done, modules can proceed freely
  - Reduces cross-module waiting

  ---
  5. Legacy Code as Source of Truth

  Since we're not running legacy, the discovery phase becomes CRITICAL.

  Discovery Output per Feature:

  FEATURE: Delete Order

  SOURCE FILES (Legacy):
    - OrderController.cs:DeleteOrder (lines 145-189)
    - OrderService.cs:DeleteAsync (lines 234-298)
    - OrderRepository.cs:SoftDelete (lines 67-78)

  BEHAVIOR SPEC:
    [detailed spec as shown above]

  CODE NOTES:
    - Uses soft delete pattern (DeletedAt timestamp)
    - Refund is synchronous (waits for gateway response)
    - Inventory restore is fire-and-forget (async, logged)
    - Email sent via background job queue

  EDGE CASES FROM CODE:
    - Line 256: Special handling for guest orders (no user ID)
    - Line 271: Archived orders (>90 days) throw different error
    - Line 285: Partial refunds for partial shipments

  QUESTIONS FOUND:
    - Why is inventory restore async but refund sync?
    - What happens if email job fails?

  QA Agent's Comparison Process:

  1. Read behavior spec
  2. Read new code
  3. For each spec item:
     - Find corresponding code in new implementation
     - Verify logic matches
     - Mark: ✓ Match / ✗ Mismatch / ? Unclear

  4. For each edge case:
     - Verify handled in new code
     - Check same error messages/codes

  5. Generate report:
     - Matches: 12/15
     - Mismatches: 2 (list details)
     - Unclear: 1 (needs human judgment)

  ---
  Updated Flow with All Decisions

  PHASE 1: DISCOVERY
  ├── Explorer agents analyze legacy codebase
  ├── Extract module structure
  ├── Extract feature list per module
  ├── Build dependency graph
  ├── Create behavior specs per feature
  └── Human reviews and adds decisions (tech choices)

  PHASE 2: SHARED SERVICES MIGRATION
  ├── Migrate auth, email, payment, inventory, storage
  ├── Each as independent workstream (parallel possible)
  ├── Each feature: coder → QA → human review → complete
  └── No blockers (no dependencies)

  PHASE 3: MODULE MIGRATION
  ├── Orchestrator picks next ready-for-dev feature
  ├── Coder agent implements (on git worktree branch)
  ├── QA agent verifies against behavior spec
  ├── Human reviews PR, runs app
  ├── Merge on approval
  ├── Update status, unblock dependents
  └── Loop until all complete

  PHASE 4: INTEGRATION & FINAL QA
  ├── Full system integration test
  ├── Compare complete workflows against legacy
  ├── Performance testing
  └── Human sign-off

  ---
  Parallelization Model

  Orchestrator (thin, reads state)
       │
       ├── Worktree: feature/shared-payment-refund
       │   └── Coder Agent A
       │
       ├── Worktree: feature/shared-inventory-restore
       │   └── Coder Agent B
       │
       └── Worktree: feature/shared-email-send
           └── Coder Agent C

  [All working in parallel, no conflicts, isolated worktrees]

  Rules for Parallel Work:
  - Maximum 3 coder agents at once (keeps orchestrator context small)
  - Each reports back with minimal summary
  - Orchestrator doesn't hold their full context
  - State lives in files, not orchestrator memory

  ---
  What's your reaction? Should we go deeper on any of these, or move to thinking about how this becomes a reusable framework for any migration project?

> Great lets make it a reusable framework for any migration project. Below are some more details to take care.- legacy is the single source of truth if
we are uncertain always check legacy code and then implement.
- before implementation frontend feature make sure we have enough API details, the correct details about API response, frontend follow best practice
like reusable responses, paginated responses, error responses shared.
- we do 100% parity with legacy even if it has a bug or missing an edge case. Applies to UI/UX, feature, database, API's, UI frameworks like if legacy
use bootstrap then we use same bootstrap, no alter, no creativity. Just mention the bug, edge case not handled by legacy in that feature status file.
- The modern frontend and backend server always runs so QA can query anytime for testing. At the setup of each migration project the AI will provide
high level overview of the legacy like what framework, payment with stripe/paypal, authentication, email, google, ms etc, how many modules, each module
has how many cruds, which module dependent on what module, feature. What is database used. Then human decide and brainstorm about what new tech stack
they are going to use, React,formik,zod and Node.js/nest.js/postgresql is the permanent. in brainstorming tell the human to go with redux/zustand or any
 other things for backend as per your recommendation and he will take decision and give you answer after that you can update the document for
frontend-tech-stack and backend-tech-stack to have single source of truth.

- As you said lets make it reusable framework for any migration project. We design this process like a wizard so if a user /init the claude in a
directory and claude find out there is a legacy folder it ask user after initing the claude that do he want to proceed with migration brainstorming to
finalizing a plan and from there the things start. User wil manually copy the files created by you like agents, skills, /commands etc when setting up
claude for a migration project (you can tell me how to make this process more smoother, later we can create a separate folder with .sh to setup it in
one command)

● Let me design this as a complete reusable framework:

  ---
  Migration Framework: "Migrate with Claude"

  Core Philosophy

  1. LEGACY IS TRUTH     → When uncertain, check legacy code
  2. 100% PARITY         → Even bugs get replicated (documented)
  3. NO CREATIVITY       → Same UI/UX, same frameworks, same behavior
  4. EXTERNALIZED STATE  → Everything in files, nothing in context
  5. WIZARD-DRIVEN       → Guided process from start to finish

  ---
  Framework Directory Structure

  When user runs /init in a project with legacy folder:

  /project-root/
  ├── legacy/                      ← User's legacy .NET project
  │   └── ... (existing code)
  │
  ├── .claude/
  │   ├── migration/               ← Migration framework files
  │   │   │
  │   │   ├── manifest.md          ← Overall migration state
  │   │   ├── decisions.md         ← Tech choices made by human
  │   │   ├── dependencies.md      ← Cross-module dependency graph
  │   │   ├── tech-stack.md        ← Final tech stack (frontend + backend)
  │   │   │
  │   │   ├── discovery/           ← Discovery phase outputs
  │   │   │   ├── overview.md      ← High-level legacy analysis
  │   │   │   ├── modules.md       ← Module breakdown
  │   │   │   ├── shared-services.md
  │   │   │   └── database-schema.md
  │   │   │
  │   │   ├── specs/               ← Behavior specs per feature
  │   │   │   ├── shared/
  │   │   │   │   ├── auth-login.spec.md
  │   │   │   │   ├── auth-register.spec.md
  │   │   │   │   └── payment-refund.spec.md
  │   │   │   ├── orders/
  │   │   │   │   ├── create-order.spec.md
  │   │   │   │   ├── delete-order.spec.md
  │   │   │   │   └── list-orders.spec.md
  │   │   │   └── products/
  │   │   │       └── ...
  │   │   │
  │   │   ├── modules/             ← Per-module status tracking
  │   │   │   ├── shared/
  │   │   │   │   └── status.md
  │   │   │   ├── orders/
  │   │   │   │   └── status.md
  │   │   │   └── products/
  │   │   │       └── status.md
  │   │   │
  │   │   ├── api-contracts/       ← API specs for frontend
  │   │   │   ├── shared.types.md  ← Pagination, errors, common responses
  │   │   │   ├── orders.api.md
  │   │   │   └── products.api.md
  │   │   │
  │   │   └── logs/                ← Attempt history, failures
  │   │       ├── attempts.md
  │   │       └── escalations.md
  │   │
  │   ├── agents/                  ← Agent definitions
  │   │   ├── orchestrator.md
  │   │   ├── explorer.md
  │   │   ├── backend-coder.md
  │   │   ├── frontend-coder.md
  │   │   ├── qa-agent.md
  │   │   └── spec-writer.md
  │   │
  │   ├── skills/                  ← Slash command skills
  │   │   ├── init-migration.md
  │   │   ├── discover.md
  │   │   ├── next-feature.md
  │   │   ├── review-feature.md
  │   │   └── status.md
  │   │
  │   └── commands/                ← Custom commands
  │       ├── migrate-init
  │       ├── migrate-discover
  │       ├── migrate-next
  │       ├── migrate-status
  │       └── migrate-qa
  │
  ├── backend/                     ← New NestJS project (created during setup)
  │   └── ...
  │
  └── frontend/                    ← New React project (created during setup)
      └── ...

  ---
  The Wizard Flow

  Step 1: Detection & Initialization

  User runs /init or starts Claude in project folder:

  Claude detects: /legacy folder exists

  ┌─────────────────────────────────────────────────────────────┐
  │  Legacy codebase detected!                                  │
  │                                                             │
  │  I found a .NET project in /legacy with:                    │
  │  - 47 .cs files                                             │
  │  - Controllers/, Models/, Services/ folders                 │
  │  - Entity Framework configuration                           │
  │                                                             │
  │  Would you like to start a migration project?               │
  │                                                             │
  │  [Yes, start migration wizard]  [No, regular Claude mode]   │
  └─────────────────────────────────────────────────────────────┘

  Step 2: Discovery Overview

  If user selects "Yes":

  ┌─────────────────────────────────────────────────────────────┐
  │  PHASE 1: DISCOVERY                                         │
  │                                                             │
  │  Analyzing legacy codebase...                               │
  │                                                             │
  │  ══════════════════════════════════════════════════════════ │
  │                                                             │
  │  LEGACY OVERVIEW:                                           │
  │                                                             │
  │  Framework:        .NET 6 MVC                               │
  │  Database:         SQL Server (Entity Framework)            │
  │  Authentication:   ASP.NET Identity + JWT                   │
  │  Payment:          Stripe (v3.2)                            │
  │  Email:            SendGrid                                 │
  │  Storage:          Azure Blob Storage                       │
  │  UI Framework:     Bootstrap 5 + jQuery                     │
  │                                                             │
  │  MODULES FOUND:                                             │
  │  ┌────────────┬────────┬─────────────────────────────────┐  │
  │  │ Module     │ CRUDs  │ Depends On                      │  │
  │  ├────────────┼────────┼─────────────────────────────────┤  │
  │  │ Auth       │ 5      │ Email                           │  │
  │  │ Users      │ 4      │ Auth, Storage                   │  │
  │  │ Products   │ 6      │ Storage, Inventory              │  │
  │  │ Orders     │ 7      │ Payment, Inventory, Email       │  │
  │  │ Inventory  │ 3      │ -                               │  │
  │  │ Reports    │ 4      │ Orders, Products, Users         │  │
  │  └────────────┴────────┴─────────────────────────────────┘  │
  │                                                             │
  │  TOTAL FEATURES: 29                                         │
  │                                                             │
  │  DATABASE:                                                  │
  │  - 15 tables                                                │
  │  - 8 stored procedures                                      │
  │  - 3 views                                                  │
  │                                                             │
  │  [Continue to Tech Stack Discussion]                        │
  └─────────────────────────────────────────────────────────────┘

  Step 3: Tech Stack Brainstorming

  ┌─────────────────────────────────────────────────────────────┐
  │  PHASE 2: TECH STACK DECISIONS                              │
  │                                                             │
  │  PERMANENT (Non-negotiable):                                │
  │  ✓ React + TypeScript                                       │
  │  ✓ Formik + Zod (forms & validation)                        │
  │  ✓ NestJS                                                   │
  │  ✓ PostgreSQL                                               │
  │                                                             │
  │  ══════════════════════════════════════════════════════════ │
  │                                                             │
  │  FRONTEND DECISIONS NEEDED:                                 │
  │                                                             │
  │  1. State Management:                                       │
  │     Legacy uses: Server-side session + some localStorage    │
  │                                                             │
  │     My recommendation: Zustand                              │
  │     - Simpler than Redux for this project size              │
  │     - 29 features doesn't need Redux complexity             │
  │     - Better TypeScript inference                           │
  │                                                             │
  │     Options: [Zustand (recommended)] [Redux Toolkit] [Other]│
  │                                                             │
  │  2. Data Fetching:                                          │
  │     My recommendation: TanStack Query (React Query)         │
  │     - Handles caching, pagination, refetching               │
  │     - Pairs well with REST APIs                             │
  │                                                             │
  │     Options: [TanStack Query (recommended)] [SWR] [Other]   │
  │                                                             │
  │  3. UI Components:                                          │
  │     Legacy uses: Bootstrap 5                                │
  │     For 100% parity: Must use Bootstrap 5                   │
  │                                                             │
  │     Options: [React-Bootstrap] [Reactstrap] [Other]         │
  │                                                             │
  │  ══════════════════════════════════════════════════════════ │
  │                                                             │
  │  BACKEND DECISIONS NEEDED:                                  │
  │                                                             │
  │  1. ORM:                                                    │
  │     My recommendation: TypeORM                              │
  │     - Closest to Entity Framework patterns                  │
  │     - Repository pattern support                            │
  │     - Migration support                                     │
  │                                                             │
  │     Options: [TypeORM (recommended)] [Prisma] [Other]       │
  │                                                             │
  │  2. Authentication:                                         │
  │     Legacy uses: ASP.NET Identity + JWT                     │
  │     My recommendation: Passport.js + JWT                    │
  │                                                             │
  │  3. Email:                                                  │
  │     Legacy uses: SendGrid                                   │
  │     Recommendation: Keep SendGrid (same provider)           │
  │                                                             │
  │  4. Storage:                                                │
  │     Legacy uses: Azure Blob                                 │
  │     Recommendation: Keep Azure Blob (same provider)         │
  │                                                             │
  └─────────────────────────────────────────────────────────────┘

  Human provides decisions → saved to tech-stack.md

  Step 4: Migration Plan Generation

  ┌─────────────────────────────────────────────────────────────┐
  │  PHASE 3: MIGRATION PLAN                                    │
  │                                                             │
  │  Based on your decisions, here's the migration order:       │
  │                                                             │
  │  LAYER 1 - SHARED SERVICES (Week 1):                        │
  │  ┌────────────────────────────────────────────────────────┐ │
  │  │ 1. Database setup + schema migration                   │ │
  │  │ 2. Auth service (5 features)                           │ │
  │  │ 3. Email service (1 feature)                           │ │
  │  │ 4. Storage service (2 features)                        │ │
  │  │ 5. Inventory service (3 features)                      │ │
  │  │ 6. Payment service (2 features)                        │ │
  │  └────────────────────────────────────────────────────────┘ │
  │                                                             │
  │  LAYER 2 - CORE MODULES (Week 2-3):                         │
  │  ┌────────────────────────────────────────────────────────┐ │
  │  │ 7. Users module (4 features)                           │ │
  │  │ 8. Products module (6 features)                        │ │
  │  │ 9. Orders module (7 features)                          │ │
  │  └────────────────────────────────────────────────────────┘ │
  │                                                             │
  │  LAYER 3 - SECONDARY (Week 3-4):                            │
  │  ┌────────────────────────────────────────────────────────┐ │
  │  │ 10. Reports module (4 features)                        │ │
  │  └────────────────────────────────────────────────────────┘ │
  │                                                             │
  │  ESTIMATED: 29 features over ~4 weeks                       │
  │                                                             │
  │  [Approve and Start Migration]  [Modify Plan]               │
  └─────────────────────────────────────────────────────────────┘

  Step 5: Project Scaffolding

  ┌─────────────────────────────────────────────────────────────┐
  │  PHASE 4: PROJECT SETUP                                     │
  │                                                             │
  │  Creating project structure...                              │
  │                                                             │
  │  ✓ Created /backend (NestJS)                                │
  │  ✓ Created /frontend (React + Vite)                         │
  │  ✓ Installed dependencies                                   │
  │  ✓ Configured TypeORM for PostgreSQL                        │
  │  ✓ Set up Zustand store structure                           │
  │  ✓ Configured Bootstrap 5                                   │
  │  ✓ Created .claude/migration/ framework files               │
  │  ✓ Generated behavior specs for all 29 features             │
  │                                                             │
  │  SERVERS:                                                   │
  │  - Backend running at: http://localhost:3000                │
  │  - Frontend running at: http://localhost:5173               │
  │                                                             │
  │  Ready to start migration!                                  │
  │                                                             │
  │  AVAILABLE COMMANDS:                                        │
  │  /migrate-status    → View current progress                 │
  │  /migrate-next      → Start next feature                    │
  │  /migrate-qa        → Run QA on ready features              │
  │  /migrate-review    → See features awaiting human review    │
  │                                                             │
  └─────────────────────────────────────────────────────────────┘

  ---
  Agent Definitions

  1. Orchestrator Agent

  PURPOSE: Thin dispatcher that reads state and assigns work

  BEHAVIOR:
  - Reads manifest.md on every session start
  - Never holds feature implementation context
  - Makes ONE decision per cycle
  - Updates state files after each action

  CONTEXT LIMIT: Minimal - only reads state files

  TRIGGERS:
  - /migrate-next
  - /migrate-status
  - Session start

  2. Explorer Agent

  PURPOSE: Analyze legacy code during discovery

  BEHAVIOR:
  - Reads legacy .NET files
  - Extracts structure, patterns, dependencies
  - Generates overview.md, modules.md
  - Identifies shared services

  CONTEXT LIMIT: Scoped to discovery phase only

  OUTPUT:
  - /discovery/overview.md
  - /discovery/modules.md
  - /dependencies.md

  3. Spec Writer Agent

  PURPOSE: Create behavior specs from legacy code

  BEHAVIOR:
  - Reads specific legacy feature code
  - Extracts all behavior, edge cases, validations
  - Documents even bugs and missing cases
  - Generates feature.spec.md

  CONTEXT LIMIT: One feature at a time

  OUTPUT:
  - /specs/{module}/{feature}.spec.md

  CRITICAL RULES:
  - Document bugs found: "BUG: Legacy does X which seems incorrect"
  - Document missing cases: "MISSING: No handling for null input"
  - No interpretation - just document what code does

  4. Backend Coder Agent

  PURPOSE: Implement NestJS features matching specs

  BEHAVIOR:
  - Reads ONE feature spec
  - Reads API contract (response shapes)
  - Implements controller, service, entities
  - Follows 100% parity - even bugs
  - Works on git worktree branch

  CONTEXT LIMIT: One feature at a time

  INPUT:
  - /specs/{module}/{feature}.spec.md
  - /api-contracts/{module}.api.md
  - /tech-stack.md (for patterns)

  OUTPUT:
  - Code in /backend on feature branch
  - Updates /modules/{module}/status.md

  5. Frontend Coder Agent

  PURPOSE: Implement React features matching specs

  BEHAVIOR:
  - Reads ONE feature spec
  - Reads API contract (knows response shapes)
  - Implements components, hooks, pages
  - Uses SAME UI framework as legacy (Bootstrap)
  - Works on git worktree branch

  PREREQUISITES:
  - Backend API for this feature must be COMPLETE
  - API contract must be documented

  CONTEXT LIMIT: One feature at a time

  INPUT:
  - /specs/{module}/{feature}.spec.md
  - /api-contracts/{module}.api.md
  - /api-contracts/shared.types.md (pagination, errors)

  OUTPUT:
  - Code in /frontend on feature branch
  - Updates /modules/{module}/status.md

  6. QA Agent

  PURPOSE: Verify implementation matches legacy behavior

  BEHAVIOR:
  - Reads feature spec (source of truth)
  - Reads new implementation code
  - Compares point-by-point
  - Can query running servers to test
  - Reports MATCH / MISMATCH / UNCLEAR

  CONTEXT LIMIT: One feature at a time

  INPUT:
  - /specs/{module}/{feature}.spec.md
  - New code (backend or frontend)
  - Running server URLs

  OUTPUT:
  - QA report in /modules/{module}/status.md
  - Updates feature status to qa-passed or qa-failed
  - Lists specific mismatches if any

  ---
  API Contract Format

  Before frontend starts, backend must document API:

  # Orders API Contract

  ## Common Response Wrapper
  All responses follow:
  {
    "success": boolean,
    "data": T | null,
    "error": { "code": string, "message": string } | null
  }

  ## Pagination Response
  {
    "items": T[],
    "meta": {
      "page": number,
      "limit": number,
      "total": number,
      "totalPages": number
    }
  }

  ## Error Codes
  - ORDER_NOT_FOUND
  - ORDER_ALREADY_SHIPPED
  - INSUFFICIENT_STOCK
  - PAYMENT_FAILED

  ---

  ## GET /api/orders

  Response: Paginated<Order>

  Order shape:
  {
    "id": number,
    "userId": number,
    "status": "pending" | "confirmed" | "shipped" | "delivered" | "cancelled",
    "items": OrderItem[],
    "total": number,
    "createdAt": string (ISO),
    "updatedAt": string (ISO)
  }

  ---

  ## DELETE /api/orders/:id

  Success Response (204): No body

  Error Responses:
  - 404: ORDER_NOT_FOUND
  - 400: ORDER_ALREADY_SHIPPED
  - 500: REFUND_FAILED

  Frontend coder reads this → knows exact shapes before coding.

  ---
  Slash Commands

  /migrate-init

  - Detects legacy folder
  - Runs discovery
  - Shows overview
  - Starts tech stack brainstorming
  - Creates framework files

  /migrate-status

  - Shows current progress
  - Features by status
  - Blockers
  - Next up queue

  /migrate-next

  - Orchestrator picks next ready-for-dev
  - Spawns appropriate coder agent
  - Starts work on git worktree

  /migrate-qa

  - Lists features ready-for-qa
  - Spawns QA agent
  - Reports results

  /migrate-review

  - Lists features awaiting human review
  - Shows PR links
  - Human can approve/reject

  /migrate-escalated

  - Shows features that failed 2x
  - Needs human intervention

  ---
  Making Setup Smooth

  Option A: Template Repository

  github.com/your-org/claude-migration-framework/

  When starting new migration:
  1. Clone template into .claude/ folder
  2. Run /migrate-init
  3. Framework detects legacy, starts wizard

  Option B: Single Setup Script

  #!/bin/bash
  # setup-migration.sh

  # Create .claude directory structure
  mkdir -p .claude/{migration/{discovery,specs,modules,api-contracts,logs},agents,skills,commands}

  # Download agent definitions
  curl -o .claude/agents/orchestrator.md https://raw.githubusercontent.com/.../orchestrator.md
  curl -o .claude/agents/explorer.md https://raw.githubusercontent.com/.../explorer.md
  # ... etc

  # Download skills
  curl -o .claude/skills/init-migration.md https://raw.githubusercontent.com/.../init-migration.md
  # ... etc

  # Initialize manifest
  cat > .claude/migration/manifest.md << 'EOF'
  # Migration Manifest

  STATUS: not-started
  PHASE: discovery
  LEGACY_PATH: ./legacy
  BACKEND_PATH: ./backend
  FRONTEND_PATH: ./frontend

  ## Progress
  - [ ] Discovery
  - [ ] Tech Stack Decisions
  - [ ] Project Setup
  - [ ] Layer 1: Shared Services
  - [ ] Layer 2: Core Modules
  - [ ] Layer 3: Secondary Modules
  - [ ] Final QA
  EOF

  echo "Migration framework installed!"
  echo "Run Claude and type /migrate-init to start"

  Option C: Claude Code Extension/Plugin

  If Claude Code supports plugins in future:
  - One-click install of migration framework
  - Auto-detects legacy projects
  - Manages everything

  ---
  Session Continuity Protocol

  When starting a new Claude session:

  Claude reads: .claude/migration/manifest.md

  If STATUS = "in-progress":

    ┌─────────────────────────────────────────────────────────────┐
    │  Migration in Progress                                      │
    │                                                             │
    │  CURRENT PHASE: Layer 2 - Core Modules                      │
    │  PROGRESS: 18/29 features complete                          │
    │                                                             │
    │  LAST SESSION:                                              │
    │  - Completed: orders/create-order (backend + frontend)      │
    │  - In Progress: orders/delete-order (backend - qa-failed)   │
    │                                                             │
    │  ACTIONS NEEDED:                                            │
    │  - 1 feature needs retry (delete-order)                     │
    │  - 2 features ready for human review                        │
    │                                                             │
    │  [Continue Migration]  [View Full Status]                   │
    └─────────────────────────────────────────────────────────────┘

  No context lost - everything in files.

  ---
  Key Files That Preserve State

  | File               | Purpose                        | When Updated               |
  |--------------------|--------------------------------|----------------------------|
  | manifest.md        | Overall progress, phase, paths | Every status change        |
  | decisions.md       | Human's tech/design choices    | During brainstorming       |
  | tech-stack.md      | Final stack details            | After brainstorming        |
  | dependencies.md    | Feature dependency graph       | After discovery            |
  | {module}/status.md | Per-module feature status      | After every feature action |
  | {feature}.spec.md  | Behavior spec                  | After spec writing         |
  | {module}.api.md    | API contracts                  | After backend complete     |
  | attempts.md        | Retry history                  | After failures             |
  | escalations.md     | Human intervention needed      | After 2 failures           |

  ---
  What aspects should we refine further? I'm thinking:
  1. The exact agent prompt templates
  2. The status file format in more detail
  3. The QA verification checklist
  4. How human review flow works in practice

> 1. you can make them, use \ 2. use the best fit. \ 3. Create yours best. \ 4. Human will run / command and review human review pending features and
mark them manually in markdown as done/complete. If he find any discrepency he will make it in rework and put humanReview: xyz description which then in
 next iteration AI pick and start work we can have a /command for it like /migrate-human-review-fix.\ Below are more points to take in consideration: -
We track status on feature level and not just module level, as tracking on module level can become very big files and hamper the context
- For QA agent source of truth is feature spec and legacy related files both, as feature spec can be wrong sometime. each feature spec should mention
the relative path to files of legacy for that feature so QA agent can always refer to it.
- The API responses follow the legacy with 100% match, if it is an legacy where api contract cannot be created then we follow best practice.
- Lets say we are in root folder so the. legacy code will be inside /legacy, modern codebase will be inside /modern/frontend\backend. Instead of putting
 /migration document in .claude we can put then in root as /migration
- For migration setup as you mention we have git repository, then we put initial files and folder structure (can be made via .sh script or manually).
Then user copy the legacy code to legacy folder manually and commit from there the user can start / slash commands to start migration.
- should I mention bug or should we just go with 100% parity? mentioning bug might make agent find bug and it may try to be creative which we do not
want, and also hamper context.

● Let me synthesize everything into the final framework:

  ---
  Final Directory Structure

  /project-root/
  │
  ├── legacy/                          ← User copies legacy .NET code here
  │   └── ... (existing .NET code)
  │
  ├── modern/
  │   ├── backend/                     ← NestJS project
  │   └── frontend/                    ← React project
  │
  ├── migration/                       ← Migration framework (in root)
  │   │
  │   ├── manifest.md                  ← Overall state
  │   ├── decisions.md                 ← Human's choices
  │   ├── tech-stack.md                ← Final tech stack
  │   ├── dependencies.md              ← Dependency graph
  │   │
  │   ├── discovery/
  │   │   ├── overview.md
  │   │   ├── modules.md
  │   │   └── database-schema.md
  │   │
  │   ├── features/                    ← Feature-level tracking (NOT module)
  │   │   ├── shared-auth-login.md
  │   │   ├── shared-auth-register.md
  │   │   ├── shared-auth-logout.md
  │   │   ├── shared-payment-charge.md
  │   │   ├── orders-create.md
  │   │   ├── orders-delete.md
  │   │   ├── orders-list.md
  │   │   └── ... (one file per feature)
  │   │
  │   ├── api-contracts/
  │   │   ├── shared.types.md          ← Common response shapes
  │   │   ├── auth.api.md
  │   │   ├── orders.api.md
  │   │   └── products.api.md
  │   │
  │   └── logs/
  │       ├── attempts.md
  │       └── escalations.md
  │
  ├── .claude/
  │   ├── agents/                      ← Agent definitions
  │   │   ├── orchestrator.md
  │   │   ├── explorer.md
  │   │   ├── spec-writer.md
  │   │   ├── backend-coder.md
  │   │   ├── frontend-coder.md
  │   │   └── qa-agent.md
  │   │
  │   └── skills/                      ← Slash commands
  │       ├── migrate-init.md
  │       ├── migrate-status.md
  │       ├── migrate-next.md
  │       ├── migrate-qa.md
  │       ├── migrate-human-review.md
  │       └── migrate-human-review-fix.md
  │
  └── setup-migration.sh               ← One-time setup script

  ---
  Feature Status File Format

  One file per feature (keeps context small):

  # Feature: orders-delete

  ## Identity
  MODULE: orders
  FEATURE: delete-order
  CREATED: 2024-01-15

  ## Legacy References
  FILES:
    - /legacy/Controllers/OrderController.cs (lines 145-189)
    - /legacy/Services/OrderService.cs (lines 234-298)
    - /legacy/Repositories/OrderRepository.cs (lines 67-78)

  ## Status
  CURRENT: human-review
  BACKEND: complete
  FRONTEND: complete
  BRANCH: feature/orders-delete

  ## Dependencies
  DEPENDS_ON:
    - shared-payment-refund (complete)
    - shared-inventory-restore (complete)

  ## Behavior Spec
  ENDPOINT: DELETE /api/orders/{id}

  VALIDATION:
    - Order must exist → 404
    - Order must belong to user OR user is admin → 403
    - Order status must be pending/confirmed → 400
    - Order must not be older than 30 days → 400

  LOGIC:
    1. Check no partial shipments
    2. Call PaymentService.Refund(orderId)
    3. Call InventoryService.Restore(productId, qty) for each item
    4. Soft delete (set DeletedAt)
    5. Send cancellation email

  RESPONSE:
    - Success: 204 No Content
    - Errors: 400, 403, 404, 500

  ## Attempts
  ATTEMPT_COUNT: 1

  ### Attempt 1
  DATE: 2024-01-17
  AGENT: backend-coder
  RESULT: qa-passed
  QA_NOTES: All behaviors verified against legacy

  ## Human Review
  STATUS: pending
  REVIEWER: (awaiting)
  FEEDBACK: (none yet)

  If human finds issue:

  ## Human Review
  STATUS: rework
  REVIEWER: rajesh
  FEEDBACK: The refund email template uses wrong subject line. Check legacy EmailService.cs line 45 for correct template.

  ---
  Agent Prompt Templates

  1. Orchestrator Agent

  # Orchestrator Agent

  ## Role
  You are the migration orchestrator. You are THIN - you do not hold implementation context. You only read state files and dispatch work.

  ## On Session Start
  1. Read /migration/manifest.md
  2. Scan /migration/features/*.md for status
  3. Determine next action

  ## Decision Priority
  1. Any ESCALATED features? → Alert human, stop
  2. Any REWORK features? → Use /migrate-human-review-fix
  3. Any HUMAN-REVIEW features? → Inform human to review
  4. Any READY-FOR-QA features? → Dispatch QA agent
  5. Any IN-PROGRESS but stale (>2 hours)? → Reset to ready-for-dev
  6. Any READY-FOR-DEV features? → Dispatch coder agent
  7. Any DEPENDENT features now unblocked? → Update to ready-for-dev
  8. Nothing to do? → Report status, wait

  ## Rules
  - NEVER hold feature implementation details in your context
  - ALWAYS read fresh state from files
  - Dispatch ONE task at a time
  - Update manifest.md after each action
  - Keep your responses short - just status and next action

  2. Explorer Agent

  # Explorer Agent

  ## Role
  You analyze legacy .NET codebases during discovery phase.

  ## Task
  Analyze the legacy codebase at /legacy and produce:
  1. /migration/discovery/overview.md - Framework, database, auth, integrations
  2. /migration/discovery/modules.md - List of modules with feature counts
  3. /migration/dependencies.md - What depends on what

  ## Output Format for overview.md
  FRAMEWORK: [.NET version]
  DATABASE: [SQL Server/SQLite/etc] via [EF Core/Dapper/etc]
  AUTHENTICATION: [Identity/JWT/OAuth/etc]
  PAYMENT: [Stripe/PayPal/etc] (version if found)
  EMAIL: [SendGrid/SMTP/etc]
  STORAGE: [Azure/AWS S3/Local/etc]
  UI_FRAMEWORK: [Bootstrap/Tailwind/Custom/etc]
  JAVASCRIPT: [jQuery/Vanilla/etc]

  ## Output Format for modules.md
  | Module | Controllers | Features | Shared Services Used |
  |--------|-------------|----------|---------------------|
  | Auth   | 1           | 5        | Email               |
  | Orders | 1           | 7        | Payment, Inventory  |

  ## Rules
  - Report what you find, no interpretation
  - If uncertain about something, note it as UNCLEAR
  - Include file paths for everything you reference

  3. Spec Writer Agent

  # Spec Writer Agent

  ## Role
  You create behavior specifications from legacy code. You document EXACTLY what the code does.

  ## Input
  - Feature name (e.g., orders-delete)
  - Legacy file paths to analyze

  ## Output
  Create /migration/features/{feature-name}.md with complete behavior spec.

  ## Rules
  - Document EXACTLY what legacy code does
  - Include ALL validation rules found in code
  - Include ALL business logic steps
  - Include ALL response formats
  - Include line numbers for reference
  - Do NOT interpret or improve
  - Do NOT mention if something looks like a bug
  - Do NOT suggest better approaches
  - If code does X, spec says "does X" - even if X seems wrong
  - 100% PARITY is the goal

  ## Spec Structure
  1. Legacy file references (with line numbers)
  2. Endpoint/function signature
  3. Validation rules (in order they appear in code)
  4. Business logic steps (in order they execute)
  5. Response formats (success and all error cases)
  6. Dependencies called (other services/repos)

  ## Example
  If legacy code checks user.Role == "Admin" before allowing delete:
  WRITE: "User must have Admin role → 403 if not"
  DO NOT WRITE: "Should probably also allow Manager role"

  4. Backend Coder Agent

  # Backend Coder Agent

  ## Role
  You implement NestJS backend features that match legacy behavior exactly.

  ## Input
  - Feature status file: /migration/features/{feature}.md
  - Tech stack: /migration/tech-stack.md
  - API contracts: /migration/api-contracts/shared.types.md

  ## Process
  1. Read the feature spec completely
  2. Read the legacy files referenced in spec
  3. Create git worktree branch: feature/{feature-name}
  4. Implement controller, service, DTOs
  5. Match EVERY behavior in spec
  6. Update feature status to ready-for-qa

  ## Rules
  - 100% PARITY with legacy - no improvements
  - If spec says legacy returns { error: "bad" }, return exactly that
  - If spec says legacy uses status code 400, use 400
  - If spec says legacy validates X before Y, validate X before Y
  - Do NOT add validation legacy doesn't have
  - Do NOT improve error messages
  - Do NOT add edge case handling legacy doesn't have
  - Follow /migration/api-contracts/ for response shapes
  - When legacy has no clear contract, follow shared.types.md patterns

  ## Output
  - Code in /modern/backend on feature branch
  - Update /migration/features/{feature}.md:
    - BACKEND: complete
    - CURRENT: ready-for-qa

  5. Frontend Coder Agent

  # Frontend Coder Agent

  ## Role
  You implement React frontend features that match legacy UI/UX exactly.

  ## Prerequisites
  - Backend for this feature must be COMPLETE
  - API contract must exist in /migration/api-contracts/

  ## Input
  - Feature status file: /migration/features/{feature}.md
  - API contract: /migration/api-contracts/{module}.api.md
  - Tech stack: /migration/tech-stack.md

  ## Process
  1. Read the feature spec completely
  2. Read the legacy VIEW files referenced
  3. Create git worktree branch: feature/{feature-name}-frontend
  4. Implement components, pages, hooks
  5. Match EVERY UI element and behavior
  6. Update feature status

  ## Rules
  - 100% PARITY with legacy UI/UX
  - Same Bootstrap components legacy uses
  - Same layout, spacing, colors
  - Same form fields in same order
  - Same validation messages (exact text)
  - Same button labels
  - Same loading states (or lack thereof)
  - Do NOT improve UI/UX
  - Do NOT add loading spinners legacy doesn't have
  - Do NOT add confirmation dialogs legacy doesn't have

  ## Output
  - Code in /modern/frontend on feature branch
  - Update /migration/features/{feature}.md:
    - FRONTEND: complete
    - CURRENT: ready-for-qa (if backend also complete)

  6. QA Agent

  # QA Agent

  ## Role
  You verify new implementation matches legacy behavior exactly.

  ## Sources of Truth (in order)
  1. Legacy code files (ULTIMATE truth)
  2. Feature spec (may have errors)

  If spec and legacy code conflict → LEGACY CODE WINS

  ## Input
  - Feature status file: /migration/features/{feature}.md
  - Legacy files (paths in feature file)
  - New implementation (backend/frontend)
  - Running servers (backend: localhost:3000, frontend: localhost:5173)

  ## Verification Process

  ### Backend Verification
  For each behavior in spec:
  1. Find corresponding legacy code
  2. Find corresponding new code
  3. Compare logic step-by-step
  4. Test endpoint if needed
  5. Mark: MATCH or MISMATCH

  ### Frontend Verification
  1. Compare UI elements with legacy views
  2. Compare form behavior
  3. Compare validation messages
  4. Compare navigation flow
  5. Mark: MATCH or MISMATCH

  ## Output Format
  Update feature status file:

  QA_RESULT: passed | failed
  QA_DATE: [date]
  QA_DETAILS:
    - Validation rules: MATCH (5/5)
    - Business logic: MATCH (3/3)
    - Response format: MATCH
    - Error handling: MATCH
    - UI elements: MATCH (if frontend)

  Or if failed:
  QA_RESULT: failed
  QA_DATE: [date]
  QA_DETAILS:
    MISMATCHES:
    - Legacy returns 400 for invalid ID, new returns 404
    - Legacy email template has "Order Cancelled", new has "Order Canceled"

  ## Rules
  - ALWAYS check legacy code, not just spec
  - Spec may have missed something - legacy code is truth
  - Report EXACTLY what differs
  - Do NOT suggest fixes, just report mismatches

  ---
  QA Verification Checklist

  # QA Checklist for Feature: {feature-name}

  ## Pre-Check
  - [ ] Read legacy files completely
  - [ ] Read feature spec
  - [ ] New code is on correct branch
  - [ ] Servers are running

  ## Backend Checks
  - [ ] Endpoint path matches legacy
  - [ ] HTTP method matches legacy
  - [ ] Request body shape matches legacy
  - [ ] Query parameters match legacy
  - [ ] Authentication requirement matches legacy
  - [ ] Authorization logic matches legacy
  - [ ] Validation order matches legacy
  - [ ] Validation rules match legacy (each one)
  - [ ] Business logic order matches legacy
  - [ ] Business logic behavior matches legacy
  - [ ] Success response shape matches legacy
  - [ ] Success status code matches legacy
  - [ ] Error response shapes match legacy
  - [ ] Error status codes match legacy
  - [ ] Database operations match legacy

  ## Frontend Checks (if applicable)
  - [ ] Component structure matches legacy view
  - [ ] All UI elements present
  - [ ] Element order matches legacy
  - [ ] Form fields match legacy (names, types, order)
  - [ ] Validation messages match legacy (exact text)
  - [ ] Button labels match legacy
  - [ ] Navigation behavior matches legacy
  - [ ] Loading states match legacy (or absence)
  - [ ] Error display matches legacy

  ## Integration Checks
  - [ ] API calls use correct endpoints
  - [ ] Request/response handling matches legacy behavior
  - [ ] Error handling matches legacy behavior

  ## Result
  QA_RESULT: [ ] passed  [ ] failed
  MISMATCHES: (list if any)

  ---
  Slash Commands

  /migrate-init

  # Skill: migrate-init

  ## Trigger
  User runs /migrate-init in project root

  ## Prerequisites
  - /legacy folder exists with .NET code

  ## Actions
  1. Spawn Explorer agent to analyze legacy
  2. Generate discovery documents
  3. Present overview to human
  4. Start tech stack brainstorming
  5. Save decisions to /migration/decisions.md
  6. Generate feature list from modules
  7. Create feature status files (all as "not-started" or "dependent")
  8. Scaffold /modern/backend and /modern/frontend
  9. Update manifest.md

  ## Output
  Migration framework initialized, ready for /migrate-next

  /migrate-status

  # Skill: migrate-status

  ## Trigger
  User runs /migrate-status

  ## Actions
  1. Read manifest.md
  2. Count features by status
  3. List any blockers
  4. Show next up queue

  ## Output Format
  MIGRATION STATUS
  ===============
  Phase: Layer 2 - Core Modules
  Progress: 18/29 features (62%)

  By Status:
    complete: 15
    human-review: 2
    ready-for-qa: 1
    in-progress: 1
    ready-for-dev: 3
    dependent: 5
    rework: 1
    escalated: 1

  Needs Attention:
    - orders-delete: rework (human feedback pending)
    - reports-sales: escalated (2 failures)

  Next Up:
    1. orders-list (ready-for-dev)
    2. orders-detail (ready-for-dev)
    3. products-search (ready-for-dev)

  /migrate-next

  # Skill: migrate-next

  ## Trigger
  User runs /migrate-next

  ## Actions
  1. Orchestrator reads state
  2. Finds next ready-for-dev feature
  3. Determines if backend or frontend needed
  4. Spawns appropriate coder agent
  5. Agent works on git worktree
  6. Updates feature status when done

  ## Output
  Starting: orders-list
  Type: backend
  Branch: feature/orders-list
  Agent: backend-coder

  [Agent works...]

  Completed: orders-list backend
  Status: ready-for-qa
  Next: Run /migrate-qa or /migrate-next

  /migrate-qa

  # Skill: migrate-qa

  ## Trigger
  User runs /migrate-qa

  ## Actions
  1. Find features with status ready-for-qa
  2. Spawn QA agent for first one
  3. QA agent verifies against legacy
  4. Update status to qa-passed or qa-failed

  ## Output
  Running QA: orders-list

  Checking against legacy:
    - OrderController.cs ✓
    - OrderService.cs ✓
    - Order.cshtml ✓

  Result: PASSED
  Status updated: human-review

  Features awaiting human review: 3
  Run /migrate-human-review to see them

  /migrate-human-review

  # Skill: migrate-human-review

  ## Trigger
  User runs /migrate-human-review

  ## Actions
  1. List all features with status human-review
  2. Show branch names for PR review
  3. Human reviews and updates status file manually

  ## Output
  FEATURES AWAITING HUMAN REVIEW
  ==============================

  1. orders-list
     Branch: feature/orders-list
     Backend: complete
     Frontend: complete
     QA: passed

     To approve: Edit /migration/features/orders-list.md
     Set: CURRENT: complete

  2. orders-create
     Branch: feature/orders-create
     Backend: complete
     Frontend: complete
     QA: passed

  To mark as rework:
    Set: CURRENT: rework
    Add: HUMAN_FEEDBACK: [your feedback here]

  /migrate-human-review-fix

  # Skill: migrate-human-review-fix

  ## Trigger
  User runs /migrate-human-review-fix

  ## Actions
  1. Find features with status rework
  2. Read HUMAN_FEEDBACK from feature file
  3. Spawn appropriate coder agent with feedback context
  4. Agent fixes the issue
  5. Update status to ready-for-qa

  ## Output
  Found rework needed: orders-delete

  Human Feedback:
  "The refund email template uses wrong subject line.
  Check legacy EmailService.cs line 45 for correct template."

  Dispatching backend-coder with feedback context...

  [Agent works...]

  Fixed: orders-delete
  Status: ready-for-qa
  Run /migrate-qa to verify fix

  ---
  Setup Script

  #!/bin/bash
  # setup-migration.sh
  # Run this in your project root

  echo "Setting up Migration Framework..."

  # Create directory structure
  mkdir -p legacy
  mkdir -p modern/{backend,frontend}
  mkdir -p migration/{discovery,features,api-contracts,logs}
  mkdir -p .claude/{agents,skills}

  # Create manifest
  cat > migration/manifest.md << 'EOF'
  # Migration Manifest

  ## State
  STATUS: not-started
  PHASE: initialization
  CREATED: $(date +%Y-%m-%d)

  ## Paths
  LEGACY: /legacy
  BACKEND: /modern/backend
  FRONTEND: /modern/frontend

  ## Progress
  TOTAL_FEATURES: 0
  COMPLETED: 0
  PERCENT: 0%

  ## Phase Checklist
  - [ ] Discovery complete
  - [ ] Tech stack decided
  - [ ] Projects scaffolded
  - [ ] Layer 1: Shared services
  - [ ] Layer 2: Core modules
  - [ ] Layer 3: Secondary modules
  - [ ] Final integration
  EOF

  # Create tech stack template
  cat > migration/tech-stack.md << 'EOF'
  # Tech Stack

  ## Permanent (Non-negotiable)
  - React + TypeScript
  - Formik + Zod
  - NestJS
  - PostgreSQL

  ## Frontend Decisions
  STATE_MANAGEMENT: (pending)
  DATA_FETCHING: (pending)
  UI_FRAMEWORK: (pending - must match legacy)
  STYLING: (pending)

  ## Backend Decisions
  ORM: (pending)
  AUTH: (pending)
  EMAIL_PROVIDER: (pending)
  STORAGE_PROVIDER: (pending)
  PAYMENT_PROVIDER: (pending)
  EOF

  # Create shared types template
  cat > migration/api-contracts/shared.types.md << 'EOF'
  # Shared API Types

  ## Standard Response Wrapper
  (To be defined based on legacy patterns)

  ## Pagination Response
  (To be defined based on legacy patterns)

  ## Error Response
  (To be defined based on legacy patterns)

  ## Common Error Codes
  (To be extracted from legacy)
  EOF

  # Create agent files
  cat > .claude/agents/orchestrator.md << 'EOF'
  [Orchestrator agent prompt - as defined above]
  EOF

  cat > .claude/agents/explorer.md << 'EOF'
  [Explorer agent prompt - as defined above]
  EOF

  cat > .claude/agents/spec-writer.md << 'EOF'
  [Spec writer agent prompt - as defined above]
  EOF

  cat > .claude/agents/backend-coder.md << 'EOF'
  [Backend coder agent prompt - as defined above]
  EOF

  cat > .claude/agents/frontend-coder.md << 'EOF'
  [Frontend coder agent prompt - as defined above]
  EOF

  cat > .claude/agents/qa-agent.md << 'EOF'
  [QA agent agent prompt - as defined above]
  EOF

  # Create skill files
  cat > .claude/skills/migrate-init.md << 'EOF'
  [migrate-init skill - as defined above]
  EOF

  cat > .claude/skills/migrate-status.md << 'EOF'
  [migrate-status skill - as defined above]
  EOF

  cat > .claude/skills/migrate-next.md << 'EOF'
  [migrate-next skill - as defined above]
  EOF

  cat > .claude/skills/migrate-qa.md << 'EOF'
  [migrate-qa skill - as defined above]
  EOF

  cat > .claude/skills/migrate-human-review.md << 'EOF'
  [migrate-human-review skill - as defined above]
  EOF

  cat > .claude/skills/migrate-human-review-fix.md << 'EOF'
  [migrate-human-review-fix skill - as defined above]
  EOF

  # Create .gitignore
  cat > .gitignore << 'EOF'
  node_modules/
  .env
  .env.local
  dist/
  build/
  *.log
  EOF

  echo ""
  echo "✓ Migration framework installed!"
  echo ""
  echo "Next steps:"
  echo "1. Copy your legacy .NET code into /legacy folder"
  echo "2. Run: git init && git add . && git commit -m 'Initial migration setup'"
  echo "3. Start Claude and run /migrate-init"
  echo ""

  ---
  Summary of Key Decisions

  | Decision        | Choice                                            |
  |-----------------|---------------------------------------------------|
  | Status tracking | Per-feature files (not module level)              |
  | Source of truth | Legacy code > Feature spec                        |
  | Parity          | 100%, no mention of bugs, just replicate          |
  | API contracts   | Match legacy exactly, or best practice if none    |
  | Directory       | /migration in root, /modern for new code          |
  | Setup           | Git repo → setup.sh → copy legacy → /commands     |
  | Human review    | /migrate-human-review shows list, human edits .md |
  | Human feedback  | HUMAN_FEEDBACK field in feature file              |
  | Rework flow     | /migrate-human-review-fix picks up feedback       |
  | QA truth        | Legacy files first, spec second                   |

  ---
  This is the complete framework. Want me to refine any specific part, or should we think about how to test this with a real migration project?

> Nice just one change to make we have modules/auth/features, modules/orders/features like this folder and not just features/ folder. Do not give back
any output just acknowledge it and make change in plan.
