# Frontend UI Analysis - HRMS Legacy Application

## Technology Stack

### Core Framework
- **Framework**: React 18.3.1
- **Build Tool**: Vite 5.3.1
- **Language**: TypeScript 5.2.2
- **UI Library**: Material-UI (MUI) v6.5.0
- **State Management**: Zustand 4.5.4
- **Routing**: React Router DOM 6.24.1

### Key Dependencies
- **Forms**: React Hook Form 7.52.2 + Formik 2.4.6 + Yup 1.4.0
- **Date Handling**: Moment.js 2.30.1 + @mui/x-date-pickers 7.18.0
- **Data Tables**: material-react-table 3.2.1
- **Icons**: @mui/icons-material 6.5.0 + @ant-design/icons 5.4.0
- **Authentication**: @azure/msal-browser 3.20.0 + @azure/msal-react 2.0.22
- **HTTP Client**: Axios 1.7.2
- **Rich Text**: @ckeditor/ckeditor5-react 9.4.0
- **Notifications**: react-toastify 10.0.5
- **Animations**: framer-motion 11.3.20

---

## Theme Configuration

### Color Palette (Ant Design Colors + Custom)

**Primary Colors** (Blue):
- Primary Main: `blue[5]` (from Ant Design colors)
- Primary Light: `blue[3]`
- Primary Dark: `blue[6]`
- Primary Lighter: `blue[0]`
- Primary Darker: `blue[8]`

**Secondary Colors** (Grey Scale):
- Grey 0: `#ffffff`
- Grey 50: `#fafafa`
- Grey 100: `#f5f5f5`
- Grey 200: `#f0f0f0`
- Grey 300: `#d9d9d9`
- Grey 400: `#bfbfbf`
- Grey 500: `#8c8c8c`
- Grey 600: `#595959`
- Grey 700: `#262626`
- Grey 800: `#141414`
- Grey 900: `#000000`

**Status Colors** (Custom):
- WIP/Pending Approval: `#FF9800` (Orange)
- Upcoming: `#2196F3` (Blue)
- Completed: `#4CAF50` (Green)

**Semantic Colors**:
- Error: Red (from Ant Design `red` palette)
- Warning: Gold (from Ant Design `gold` palette)
- Info: Cyan (from Ant Design `cyan` palette)
- Success: Green (from Ant Design `green` palette)

**Text Colors**:
- Primary Text: `grey[700]` (#262626)
- Secondary Text: `grey[500]` (#8c8c8c)
- Disabled Text: `grey[400]` (#bfbfbf)

**Background Colors**:
- Paper: `grey[0]` (#ffffff)
- Default: `grey.A50` (#fafafb)
- Divider: `grey[200]` (#f0f0f0)

**Custom Brand Colors**:
- Primary Blue: `#1e75bb`
- Dark Color: `#283a50` (used for text and branding)
- Secondary Dark: `#273A50` (page headings)

---

## Typography

### Font Configuration
- **Primary Font**: 'Roboto', sans-serif
- **Available Fonts** (via @fontsource):
  - Roboto (primary)
  - Inter
  - Poppins
  - Public Sans

### Font Weights
- Light: 300
- Regular: 400
- Medium: 500
- Bold: 600

### Typography Scale
```typescript
h1: {
  fontWeight: 600,
  fontSize: '2.375rem',    // 38px
  lineHeight: 1.21
}

h2: {
  fontWeight: 600,
  fontSize: '1.75rem',     // 28px
  lineHeight: 1.27
}

h3: {
  fontWeight: 600,
  fontSize: '1.5rem',      // 24px
  lineHeight: 1.33
}

h4: {
  fontWeight: 600,
  fontSize: '1.25rem',     // 20px
  lineHeight: 1.4
}

h5: {
  fontWeight: 600,
  fontSize: '1rem',        // 16px
  lineHeight: 1.5
}

h6: {
  fontWeight: 400,
  fontSize: '0.875rem',    // 14px
  lineHeight: 1.57
}

body1: {
  fontSize: '0.875rem',    // 14px
  lineHeight: 1.57
}

body2: {
  fontSize: '0.75rem',     // 12px
  lineHeight: 1.66
}

subtitle1: {
  fontSize: '0.875rem',    // 14px
  fontWeight: 600,
  lineHeight: 1.57
}

subtitle2: {
  fontSize: '0.75rem',     // 12px
  fontWeight: 500,
  lineHeight: 1.66
}

caption: {
  fontWeight: 400,
  fontSize: '0.75rem',     // 12px
  lineHeight: 1.66
}

button: {
  textTransform: 'capitalize'  // Not uppercase
}
```

---

## Layout Structure

### App Shell Architecture

**Main Layout Components**:
1. **DashboardLayout** (`/layout/Dashboard/index.tsx`)
   - Contains: Header + Drawer + Main Content Area + Chat Widget
   - Layout: Flexbox container with fixed sidebar

2. **MinimalLayout** (`/layout/MinimalLayout/index.tsx`)
   - Used for: Login and auth pages
   - No sidebar/header

### Layout Hierarchy
```
App.tsx
└── isLoggedIn ? DashboardLayout : MinimalLayout
    ├── Header (Fixed AppBar)
    ├── Drawer (Collapsible Sidebar)
    └── Main Content (Outlet)
        └── Page Components
```

---

## Header Component

**File**: `/layout/Dashboard/Header/index.tsx`

### Header Structure
- **Position**: Fixed at top
- **Height**: 60px (toolbar minHeight)
- **Border**: Bottom border 1px solid divider color
- **Box Shadow**: Custom shadow `theme.customShadows.z1`
- **Background**: White (inherit)

### Header Elements (Left to Right)

1. **Logo Icon** (when drawer closed)
   - File: `pio-logo-dark.svg`
   - Size: 36x36px
   - Shows only when drawer is collapsed

2. **Menu Toggle Button**
   - Icon: MenuUnfoldOutlined / MenuFoldOutlined (Ant Design icons)
   - Background Color: `grey.100` (closed) / `grey.200` (open)
   - Toggles sidebar collapse state
   - Hover on closed drawer auto-expands

3. **Search Component** (HeaderContent/Search.tsx)
   - Positioned in center-right area

4. **Support Feedback Button** (SubmitSupportPage)
   - Visible based on permission: `SUPPORT.READ`
   - Opens support dialog

5. **Profile Menu** (HeaderContent/Profile)
   - User avatar (ProfilePicture component)
   - Display: Avatar + Name + Role (on desktop)
   - Avatar size: 38px
   - Dropdown menu on click
   - Name truncates at 35 characters
   - Role displayed as subtitle

6. **Chatbot Launcher** (conditional)
   - Feature flag controlled: `enableChatbot`
   - Custom web component: `<web-chatlauncher>`
   - Positioned at far right

### Profile Dropdown Menu
- Width: 290px (240px min, 250px mobile max)
- Contains:
  - User name (capitalized, truncated)
  - User role
  - ProfileTab component with menu items
- Background: White with custom shadow

---

## Sidebar (Drawer) Component

**File**: `/layout/Dashboard/Drawer/index.tsx`

### Drawer Configuration
- **Width**: 260px (constant `drawerWidth`)
- **Type**: Permanent (desktop) / Temporary (mobile)
- **Breakpoint**: lg (1266px)
- **Behavior**:
  - Desktop: Mini drawer (collapsible to icon-only)
  - Mobile: Temporary overlay drawer
  - Hover on collapsed drawer: Auto-expands temporarily

### Drawer Structure

1. **Drawer Header** (`DrawerHeader/index.tsx`)
   - Logo component
   - Logo size: 35x35px (collapsed) / auto (expanded)
   - Component: `<Logo />` from `/components/logo`

2. **Drawer Content** (`DrawerContent/index.tsx`)
   - Wrapped in SimpleBar for custom scrolling
   - Contains: Navigation component

3. **Navigation Component** (`DrawerContent/Navigation/index.tsx`)
   - Padding top: 16px (pt: 2)
   - Dynamic menu based on:
     - User permissions (`userData.menus`)
     - User role (`userData.roleName`)
     - Feature flags (`featureFlagStore`)
   - Menu items filtered by permissions and roles

### Navigation Menu Structure

**Navigation Components**:
- `NavGroup`: Menu section wrapper
- `NavItem`: Single menu item (link)
- `NavSubMenu`: Collapsible submenu

**Menu Configuration** (`menu-items/dashboard.tsx`):

#### Main Menu Items (in order):

1. **Dashboard**
   - Icon: DashboardIcon
   - URL: `/dashboard`
   - Type: item

2. **Roles**
   - Icon: AdminPanelSettingsIcon
   - URL: `/roles`
   - Type: item

3. **Company Policy**
   - Icon: ArticleIcon
   - URL: `/company-policy`
   - Type: item

4. **Employees** (submenu)
   - Icon: GroupsIcon
   - URL: `/employees`
   - Children:
     - Employees List → `/employees/employee-list`
     - Employee Exit → `/employees/employee-exit` (SUPER_ADMIN only)

5. **Attendance** (submenu)
   - Icon: CalendarMonthIcon
   - URL: `/attendance`
   - Children:
     - My Attendance → `/attendance/my-attendance`
     - Attendance Configuration → `/attendance/attendance-configuration`
     - Employee Report → `/attendance/employee-report`

6. **IT Assets**
   - Icon: DevicesIcon
   - URL: `/IT-Assets`
   - Type: item

7. **Leave** (submenu)
   - Icon: EventAvailableIcon
   - URL: `/leave`
   - Children:
     - Apply Leave → `/leave/apply-leave`
     - Leave Approval → `/leave/leave-approval`
     - Leave Calendar → `/leave/leave-calendar`

8. **KPI** (submenu)
   - Icon: AssessmentIcon
   - URL: `/Kpi`
   - Children:
     - My KPI → `/KPI/My-KPI`
     - KPI Management → `/KPI/KPI-Management`
     - Goals → `/KPI/Goals`

9. **Grievance** (submenu)
   - Icon: FeedbackIcon
   - URL: `/Grievance`
   - Children:
     - My Grievance → `/Grievance/My-Grievance`
     - All Grievance → `/Grievance/All-Grievance`
     - Grievance Configuration → `/Grievance/Grievance-Configuration`

10. **Support** (submenu)
    - Icon: SupportAgentIcon
    - URL: `/Support`
    - Children:
      - My Support → `/Support/My-Support`
      - Support Queries → `/Support/Support-Queries`

11. **Events**
    - Icon: EventIcon
    - URL: `/events`
    - Type: item

12. **Settings** (submenu - SUPER_ADMIN only)
    - Icon: SettingsIcon
    - URL: `/settings`
    - Children:
      - Email and Notification → `/settings/email-and-notification`
      - Department → `/settings/department`
      - Designation → `/settings/designation`
      - Team → `/settings/team`

13. **Developer** (submenu)
    - Icon: DeveloperBoardIcon
    - URL: `/developer`
    - Children:
      - Logs → `/developer/logs`
      - Cron Jobs → `/developer/cron-jobs`

**Submenu Arrow Icon**: ArrowForwardIcon (used for all submenu children)

### Menu Behavior
- Permission-based visibility
- Role-based filtering (SUPER_ADMIN, EMPLOYEE, etc.)
- Feature flag filtering (via `FEATURE_FLAG_TO_MENU_ID`)
- Nested submenu collapse/expand
- Active state highlighting

---

## Main Content Area

**File**: `/layout/Dashboard/index.tsx`

### Content Container
- **Width**: `calc(100% - 260px)` (when drawer open)
- **Padding**:
  - xs: 16px (2 * 8px)
  - sm+: 24px (3 * 8px)
- **Background**: Default background color (#fafafb)
- **Top Spacing**: Toolbar height (60px) for fixed header

### Page Structure
```jsx
<Box component="main">
  <Toolbar /> {/* Spacer for fixed header */}
  <Outlet /> {/* React Router content */}
</Box>
```

### Additional Elements
- **Chat Drawer**: Custom web component `<web-chatdrawer>`
  - Position: Fixed at right
  - Top: 62px (below header)
  - Height: `calc(100% - 62px)`
  - z-index: 1100

---

## Login Page Layout

**File**: `/pages/Login/LoginLayout.tsx`

### Login Layout Structure

**Container**: `<AuthWrapper>` component with centered grid layout

**Grid Layout** (3 columns):

1. **Left Column** (4/12 width - hidden on mobile)
   - Image: `login-left-img.jpg`
   - Size: 228x50px
   - Centered alignment

2. **Divider** (1/12 width - hidden on mobile)
   - Vertical divider
   - Border width: 2px
   - Full height

3. **Right Column** (7/12 width)
   - **Top Section**: Logo + Brand
     - Circular logo container:
       - Background: #283a50 (dark color)
       - Size: 70x70px
       - Border radius: 50%
       - Box shadow: 0px 1px 8px 0px
       - Logo: `pio-logo.svg` (height: 40px)
     - Vertical divider (2px)
     - Brand text: "HRMS"
       - Color: #283a50 (dark-color)
       - Font weight: 700
       - Variant: h3

   - **Title Section**:
     - Centered text
     - Color: #1e75bb (blueColor)
     - Font weight: 700
     - Variant: h3
     - Dynamic title prop

   - **Form Section**: Children content (login forms)

### Login Form Components

**File**: `/pages/Login/auth-forms/SSOLogin.tsx`

**SSO Login Button**:
- Variant: outlined
- Color: secondary
- Border color: #1e75bb
- Text color: #1e75bb
- Hover state:
  - Background: #1e75bb
  - Text color: white
- Start icon: Microsoft 365 logo (`microsoft365.svg`, height: 30px)
- Button text: "Sign In with Microsoft" (bold)
- Padding: 50px horizontal
- Loading state: CircularProgress overlay

### Mobile Responsiveness
- Below 768px:
  - Left image hidden
  - Divider hidden
  - Login form centered
  - Full-width layout

---

## Dashboard Page Layout

**File**: `/pages/Dashboard/index.tsx`

### Dashboard Grid Structure

**Container**: Grid with spacing
- Row spacing: 4.5 (36px)
- Column spacing: 2.75 (22px)

### Dashboard Header Row
- Grid item xs={6}: "Dashboard" heading (h2, color: #273A50)
- Grid item xs={6}: Day dropdown filter (right-aligned)

### Analytics Section (Non-Employee roles only)

**Component**: `AnalyticsSection`
**Cards**: 3 gradient cards (AnalyticEcommerce component)

1. **Total Active Employees**
   - Background: Linear gradient (149deg, #1E75BB 57%, #27A8E0 100%)
   - Icon: Employee icon SVG (50x50px)
   - Height: 100px
   - Border radius: 15px
   - Drop shadow: 2.939px 4.045px 5px rgba(0,0,0,0.08)
   - Title font: 20px, weight 500
   - Count font: 32px, weight 700, drop shadow
   - Decorative circles: Semi-transparent white circles (opacity 0.05 and 0.1)

2. **New Employees Enrolled**
   - Same styling
   - Icon: PostAdd MUI icon

3. **Employee Exit Organization**
   - Same styling
   - Icon: GroupRemove MUI icon

### Dashboard Tiles (3x4 Grid)

**Grid**: 3 columns on md/lg (4 columns each)
**Tiles** (displayed based on permissions):

1. **Work Anniversary**
   - Background: Custom background-0
   - Shows employees with work anniversaries

2. **Upcoming Holidays**
   - Background: Custom background-1
   - Holiday calendar view toggle

3. **Apply New** (conditional)
   - Background: Custom background-2
   - Shows if attendance OR leave enabled
   - Quick apply actions

4. **Birthdays**
   - Background: Custom background-3
   - Employee birthdays list

5. **Company Policy Document** (permission: COMPANY_POLICY.READ)
   - Background: Custom background-4
   - Recent policy documents

6. **Upcoming Events** (permission: EVENTS.READ)
   - Background: Custom background-5
   - Events calendar/list

7. **Employee Survey** (disabled)
   - Background: Custom background-6
   - Survey list (currently not shown)

**Tile Components**:
- Component: `DashboardTile`
- Content: Dynamic via `componentMap`
- Custom CSS classes for styling
- Loading states per tile

---

## Common UI Components

### 1. Data Table Component

**File**: `/components/DataTable/DataTable.tsx`

**Features**:
- Sortable columns (asc/desc)
- Pagination (10, 25, 50 rows per page)
- Custom column rendering
- Truncated text with tooltips
- Empty state: "No Data Found"
- Styled table rows with hover effect
- Cell padding: 5px 10px
- Min width: 750px
- White space: nowrap

**Table Structure**:
- TableContainer → Table → TableHeader + TableBody
- Custom header: `DataTableHeader` component
- Styled rows: `StyledTableRow`
- Pagination component at bottom

### 2. Form Components

**Available Form Components**:
- `FormTextField`: Text input wrapper
- `FormAutocomplete`: Autocomplete/select with search
- `FormDatePicker`: Date selection
- `FormDateTimePicker`: Date + time selection
- `FormSelectField`: Dropdown select
- `FormCheckbox`: Checkbox wrapper
- `FormPhoneField`: Phone number input
- `FormUrlField`: URL input
- `FormBlocker`: Unsaved changes warning

**Form Libraries**:
- React Hook Form (primary)
- Formik (legacy, still in use)
- Yup validation

### 3. Button Components

**Button Variants** (MUI overrides):
- `contained`: Solid background
- `outlined`: Border only
- `text`: No background
- `dashed`: Dashed border (custom)
- `shadow`: With shadow effect (custom)

**Button Sizes**:
- extraSmall: minWidth 56px, fontSize 0.625rem, padding 2px 8px
- Standard sizes via MUI

**Common Button Components**:
- `SubmitButton`: Form submit with loading
- `SubmitButtonSimple`: Simple submit
- `ResetButton`: Form reset
- `ActionIconButton`: Icon button for actions
- `RoundActionIconButton`: Circular icon button

### 4. Card Components

**DashboardCard** (`/components/DashboardCard`):
- Standard card wrapper for dashboard items

**MainCard** (`/components/MainCard`):
- Main content card with configurable border, shadow, content padding
- Used throughout application

**AnalyticEcommerce** (`/components/cards/statistics/AnalyticEcommerce.tsx`):
- Gradient background cards for analytics
- Icon + title + count display
- Decorative background circles

### 5. Modal/Dialog Components

**ConfirmationDialog** (`/components/ConfirmationDialog`):
- Standard confirmation popup
- Configurable title, message, buttons

**AppUpdateDialog** (`/components/AppUpdateDialog`):
- App version update notification
- Shows when build version changes

### 6. Other Common Components

- **Loader** (`/components/Loader`): Full-page loading spinner
- **NoDataFound** (`/components/NoDataFound`): Empty state component
- **PageHeader** (`/components/PageHeader`): Standard page title header
- **TruncatedText** (`/components/TruncatedText`): Text with tooltip on overflow
- **EventDateTime** (`/components/EventDateTime`): Date/time display
- **EmployeeSearch** (`/components/EmployeeSearch`): Employee search widget
- **FilePreview** (`/components/FilePreview`): File preview modal
- **RichTextEditor** (`/components/RichTextEditor`): CKEditor wrapper
- **SanitizedHtml** (`/components/SanitizedHtml`): Safe HTML rendering with DOMPurify

---

## Responsive Breakpoints

**MUI Custom Breakpoints**:
```typescript
breakpoints: {
  values: {
    xs: 0,        // Mobile portrait
    sm: 768,      // Mobile landscape / Tablet portrait
    md: 1024,     // Tablet landscape
    lg: 1266,     // Desktop (drawer breakpoint)
    xl: 1440      // Large desktop
  }
}
```

**Key Responsive Behaviors**:
- **< 768px (sm)**:
  - Login sidebar hidden
  - Temporary drawer overlay
  - Reduced padding
  - Profile name hidden in header

- **< 1266px (lg)**:
  - Drawer switches to temporary mode
  - Menu toggle always visible

- **≥ 1266px (lg)**:
  - Permanent mini drawer
  - Auto-expand on hover
  - Full layout visible

---

## Custom Styling Patterns

### CSS Classes (index.css)

**Login Page**:
- `.blueColor`: #1e75bb, font-weight 600
- `.dark-color`: #283a50
- `.font-width-700`: font-weight 40px (likely typo, should be 700)
- `.login-center-icon-container`: Flex center with gap 20px
- `.login-center-icon`: Circular dark background (70x70px)
- `.login-button`: Blue outlined button with hover effect
- `.login-sidebar-image`, `.login-divider`, `.login-main-container-card`: Layout classes

**Dashboard**:
- `.dashboard-upcoming`: Custom styles for upcoming events tables
  - Smaller font size (0.75rem)
  - Reduced padding (6px header, 10px body)

### MUI Theme Overrides

**Component Overrides** (in `/themes/overrides/`):
- Badge
- Button (extensive custom variants)
- CardContent
- Checkbox
- Chip
- IconButton
- InputLabel
- LinearProgress
- Link
- ListItemIcon
- OutlinedInput
- Tab
- TableCell
- Tabs
- Typography

---

## UI Patterns and Conventions

### 1. Page Layout Pattern
```tsx
<Grid container rowSpacing={4.5} columnSpacing={2.75}>
  <Grid item xs={12}>
    <Typography variant="h2">Page Title</Typography>
  </Grid>
  <Grid item xs={12}>
    {/* Page content */}
  </Grid>
</Grid>
```

### 2. Card Pattern
```tsx
<MainCardContainer>
  <CardContent>
    {/* Card content */}
  </CardContent>
</MainCardContainer>
```

### 3. Data Display Pattern
- Use DataTable for tabular data
- Use MaterialReactTable for advanced features
- Custom cards for dashboard widgets
- TruncatedText for long strings

### 4. Form Pattern
```tsx
<form onSubmit={handleSubmit}>
  <Grid container spacing={2}>
    <Grid item xs={12} sm={6}>
      <FormTextField name="field" control={control} />
    </Grid>
    {/* More fields */}
  </Grid>
  <SubmitButton loading={isLoading} />
</form>
```

### 5. Permission-Based Rendering
```tsx
{hasPermission(PERMISSION.READ) && (
  <Component />
)}
```

### 6. Loading States
- Skeleton loaders for cards
- CircularProgress for buttons
- Full-page Loader component for initial loads

---

## Icons

**Icon Libraries**:
1. **@mui/icons-material** (primary)
   - Most UI icons
   - Consistent Material Design style

2. **@ant-design/icons**
   - Menu fold/unfold icons
   - Some specific icons

**Custom Icons/Images**:
- `pio-logo.svg`: Main app logo
- `pio-logo-dark.svg`: Header logo (dark variant)
- `microsoft365.svg`: Microsoft login button
- `employeeIcon.svg`: Employee dashboard icon
- `login-left-img.jpg`: Login page illustration

**Icon Usage Pattern**:
- MUI icons imported individually
- Icon components passed as React components (not elements)
- Size controlled via `sx` prop or `fontSize` prop

---

## Animations

**Library**: framer-motion 11.3.20

**Custom Transitions** (`/components/@extended/Transitions`):
- Type: 'grow' (most common)
- Position: 'top-right', 'top-left', etc.
- Used for dropdowns, popovers

**Animation Patterns**:
- Button hover effects (via MUI overrides)
- Drawer slide in/out
- Menu expand/collapse
- Modal fade in/out
- Tooltip/popper transitions

---

## Error Handling UI

**Error Boundary** (`react-error-boundary` 4.0.13):
- Component: `FallbackRender`
- Full-page error display
- Error details shown in development

**Toast Notifications** (`react-toastify` 10.0.5):
- Success messages
- Error messages
- Warning messages
- Info messages
- Auto-dismiss configuration

**Not Found Page** (`/pages/NotFoundPage`):
- 404 error display
- Navigation back to dashboard

**Unauthorized Page** (`/pages/Unauthorized`):
- 403 error display
- Permission denied message

---

## Special Features

### 1. SimpleBar Custom Scrollbar
**Library**: simplebar-react 3.2.6
- Used in drawer content
- Custom styled scrollbar
- Better UX than native scrollbar

### 2. Profile Picture Component
- Avatar fallback with initials
- Image preview support
- Consistent sizing (38px in header)

### 3. Feature Flags
- Dynamic UI based on feature toggles
- Stored in Zustand store
- Controls menu visibility, features

### 4. Chat Integration
- Custom web components: `<web-chatlauncher>`, `<web-chatdrawer>`
- Feature flag controlled
- Fixed positioning

### 5. Rich Text Editor
- CKEditor 5 integration
- Custom configuration
- Sanitized HTML output (DOMPurify)

---

## Summary Statistics

**Total Pages**: 20+ distinct page types
**Navigation Items**: 13 main menu items, 8 submenus
**Form Components**: 10+ reusable form wrappers
**Common Components**: 40+ reusable UI components
**Icon Libraries**: 2 (MUI + Ant Design)
**Color Palette**: 9 grey shades + 6 semantic colors + custom brand colors
**Typography Variants**: 11 defined styles
**Breakpoints**: 5 responsive breakpoints

---

## Key Design Decisions

1. **MUI as Primary UI Framework**: Comprehensive component library with theming
2. **Ant Design Colors**: Proven color system with semantic naming
3. **Roboto Font**: Clean, professional, web-safe
4. **Mini Drawer Pattern**: Space-efficient navigation
5. **Permission-Based UI**: Security-first approach
6. **Feature Flags**: Gradual rollout capability
7. **TypeScript**: Type safety throughout
8. **Zustand State**: Lightweight, simple state management
9. **Custom Theme System**: Centralized styling with overrides
10. **Responsive-First**: Mobile support built-in

---

## Migration Considerations

### Must Preserve
- Exact color values (brand colors: #1e75bb, #283a50)
- Layout dimensions (drawer: 260px, header: 60px)
- Navigation structure and hierarchy
- Permission-based rendering logic
- Responsive breakpoints
- Typography scale
- Form validation patterns

### Can Modernize
- State management (Zustand → React Query + Context)
- Form handling (consolidate Formik + React Hook Form)
- Icon library (single source)
- CSS approach (CSS modules or styled-components)
- Animation library (if needed)

### Critical UX Features
- Mini drawer with hover expand
- Profile dropdown with user info
- Permission-filtered navigation
- SSO login flow
- Gradient analytics cards
- Dashboard tile system
- Data table with sorting/pagination
- Rich text editing capability
- File preview functionality
