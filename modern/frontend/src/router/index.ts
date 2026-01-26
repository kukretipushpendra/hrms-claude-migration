import { createRouter, createWebHistory, type RouteRecordRaw } from 'vue-router';
import { useAuthStore } from '@/stores/auth.store';

// Lazy-loaded views
const LoginView = () => import('@/views/auth/LoginView.vue');
const InternalLoginView = () => import('@/views/auth/InternalLoginView.vue');
const DashboardView = () => import('@/views/dashboard/DashboardView.vue');
const ProfileView = () => import('@/views/profile/ProfileView.vue');
const NotFoundView = () => import('@/views/error/NotFoundView.vue');

const routes: RouteRecordRaw[] = [
  {
    path: '/',
    redirect: '/dashboard',
  },
  {
    path: '/login',
    name: 'login',
    component: LoginView,
    meta: { requiresAuth: false, title: 'Login' },
  },
  {
    path: '/internal-login',
    name: 'internal-login',
    component: InternalLoginView,
    meta: { requiresAuth: false, title: 'User Login' },
  },
  {
    path: '/dashboard',
    name: 'dashboard',
    component: DashboardView,
    meta: { requiresAuth: true, title: 'Dashboard' },
  },
  {
    path: '/profile',
    name: 'profile',
    component: ProfileView,
    meta: { requiresAuth: true, title: 'My Profile' },
  },
  // Roles routes
  {
    path: '/roles',
    name: 'roles',
    component: () => import('@/views/roles/RolesListView.vue'),
    meta: { requiresAuth: true, title: 'Roles' },
  },
  {
    path: '/roles/add',
    name: 'role-add',
    component: () => import('@/views/roles/RolePermissionsView.vue'),
    meta: { requiresAuth: true, title: 'Create Role' },
  },
  {
    path: '/roles/edit/:id',
    name: 'role-edit',
    component: () => import('@/views/roles/RolePermissionsView.vue'),
    meta: { requiresAuth: true, title: 'Edit Role' },
  },
  // Company Policy routes
  {
    path: '/company-policy',
    name: 'company-policy',
    component: () => import('@/views/policy/PolicyListView.vue'),
    meta: { requiresAuth: true, title: 'Company Policy' },
  },
  {
    path: '/company-policy/create',
    name: 'policy-create',
    component: () => import('@/views/policy/PolicyCreateView.vue'),
    meta: { requiresAuth: true, title: 'Create Policy' },
  },
  {
    path: '/company-policy/view/:id',
    name: 'policy-detail',
    component: () => import('@/views/policy/PolicyDetailView.vue'),
    meta: { requiresAuth: true, title: 'Policy Details' },
  },
  {
    path: '/company-policy/edit/:id',
    name: 'policy-edit',
    component: () => import('@/views/policy/PolicyCreateView.vue'),
    meta: { requiresAuth: true, title: 'Edit Policy' },
  },
  // Employee routes
  {
    path: '/employees',
    name: 'employees',
    component: () => import('@/views/employees/EmployeeListView.vue'),
    meta: { requiresAuth: true, title: 'Employees' },
  },
  {
    path: '/employees/create',
    name: 'employee-create',
    component: () => import('@/views/employees/EmployeeCreateView.vue'),
    meta: { requiresAuth: true, title: 'Add Employee' },
  },
  {
    path: '/employees/view/:id',
    name: 'employee-detail',
    component: () => import('@/views/employees/EmployeeDetailView.vue'),
    meta: { requiresAuth: true, title: 'Employee Details' },
  },
  {
    path: '/employees/edit/:id',
    name: 'employee-edit',
    component: () => import('@/views/employees/EmployeeCreateView.vue'),
    meta: { requiresAuth: true, title: 'Edit Employee' },
  },
  // Attendance routes
  {
    path: '/attendance/my-attendance',
    name: 'my-attendance',
    component: () => import('@/views/attendance/MyAttendanceView.vue'),
    meta: { requiresAuth: true, title: 'My Attendance' },
  },
  {
    path: '/attendance/attendance-configuration',
    name: 'attendance-configuration',
    component: () => import('@/views/attendance/AttendanceConfigurationView.vue'),
    meta: { requiresAuth: true, title: 'Attendance Configuration' },
  },
  {
    path: '/attendance/employee-report',
    name: 'attendance-employee-report',
    component: () => import('@/views/attendance/EmployeeReportView.vue'),
    meta: { requiresAuth: true, title: 'Employee Report' },
  },
  // IT Assets routes
  {
    path: '/IT-Assets',
    name: 'it-assets',
    component: () => import('@/views/assets/ITAssetListView.vue'),
    meta: { requiresAuth: true, title: 'IT Assets' },
  },
  {
    path: '/IT-Assets/add',
    name: 'it-asset-add',
    component: () => import('@/views/assets/AddITAssetView.vue'),
    meta: { requiresAuth: true, title: 'Add IT Asset' },
  },
  {
    path: '/IT-Assets/:assetId',
    component: () => import('@/views/assets/AssetDetailsLayout.vue'),
    meta: { requiresAuth: true },
    children: [
      {
        path: '',
        redirect: 'general',
      },
      {
        path: 'general',
        name: 'asset-general',
        component: () => import('@/views/assets/AssetGeneralView.vue'),
        meta: { requiresAuth: true, title: 'Asset Details' },
      },
      {
        path: 'history',
        name: 'asset-history',
        component: () => import('@/views/assets/AssetHistoryView.vue'),
        meta: { requiresAuth: true, title: 'Asset History' },
      },
    ],
  },
  {
    path: '/profile/it-assets',
    name: 'employee-it-assets',
    component: () => import('@/views/assets/EmployeeITAssetsView.vue'),
    meta: { requiresAuth: true, title: 'My IT Assets' },
  },
  // Leave routes
  {
    path: '/leave/apply-leave',
    name: 'apply-leave',
    component: () => import('@/views/leave/ApplyLeaveView.vue'),
    meta: { requiresAuth: true, title: 'Apply Leave' },
  },
  {
    path: '/leave/apply-leave/add/:id',
    name: 'leave-application-form',
    component: () => import('@/views/leave/LeaveApplicationFormView.vue'),
    meta: { requiresAuth: true, title: 'Apply for Leave' },
  },
  {
    path: '/leave/leave-approval',
    name: 'leave-approval',
    component: () => import('@/views/leave/LeaveApprovalView.vue'),
    meta: { requiresAuth: true, title: 'Leave Approval' },
  },
  {
    path: '/leave/leave-calendar',
    name: 'leave-calendar',
    component: () => import('@/views/leave/LeaveCalendarView.vue'),
    meta: { requiresAuth: true, title: 'Leave Calendar' },
  },
  // KPI routes
  {
    path: '/KPI/my-KPI',
    name: 'my-kpi',
    component: () => import('@/views/kpi/EmployeeKPIView.vue'),
    meta: { requiresAuth: true, title: 'My KPI' },
  },
  {
    path: '/KPI/Kpi-Details/:employeeId',
    name: 'kpi-details',
    component: () => import('@/views/placeholder/PlaceholderView.vue'),
    meta: { requiresAuth: true, title: 'KPI Details' },
  },
  {
    path: '/KPI/Goals',
    name: 'kpi-goals',
    component: () => import('@/views/kpi/GoalListView.vue'),
    meta: { requiresAuth: true, title: 'Goals' },
  },
  {
    path: '/KPI/Goals/Add-Goal',
    name: 'kpi-goal-add',
    component: () => import('@/views/kpi/UpsertGoalView.vue'),
    meta: { requiresAuth: true, title: 'Add Goal' },
  },
  {
    path: '/KPI/Goals/Edit-Goal/:id',
    name: 'kpi-goal-edit',
    component: () => import('@/views/kpi/UpsertGoalView.vue'),
    meta: { requiresAuth: true, title: 'Edit Goal' },
  },
  {
    path: '/KPI/KPI-Management',
    name: 'kpi-management',
    component: () => import('@/views/placeholder/PlaceholderView.vue'),
    meta: { requiresAuth: true, title: 'KPI Management' },
  },
  // Grievance routes
  {
    path: '/Grievance/configuration',
    name: 'grievance-configuration',
    component: () => import('@/views/grievance/GrievanceConfigurationView.vue'),
    meta: { requiresAuth: true, title: 'Grievance Configuration' },
  },
  {
    path: '/Grievance/configuration/add',
    name: 'grievance-type-add',
    component: () => import('@/views/grievance/GrievanceTypeFormView.vue'),
    meta: { requiresAuth: true, title: 'Add Grievance Type' },
  },
  {
    path: '/Grievance/configuration/edit/:id',
    name: 'grievance-type-edit',
    component: () => import('@/views/grievance/GrievanceTypeFormView.vue'),
    meta: { requiresAuth: true, title: 'Edit Grievance Type' },
  },
  {
    path: '/Grievance/My-Grievance',
    name: 'my-grievances',
    component: () => import('@/views/grievance/MyGrievanceListView.vue'),
    meta: { requiresAuth: true, title: 'My Grievances' },
  },
  {
    path: '/Grievance/My-Grievance/add',
    name: 'add-grievance',
    component: () => import('@/views/grievance/AddGrievanceView.vue'),
    meta: { requiresAuth: true, title: 'Add Grievance' },
  },
  {
    path: '/Grievance/My-Grievance/detail/:id',
    name: 'grievance-detail',
    component: () => import('@/views/grievance/GrievanceDetailsView.vue'),
    meta: { requiresAuth: true, title: 'Grievance Details' },
  },
  {
    path: '/Grievance/all-grievances',
    name: 'all-grievances',
    component: () => import('@/views/grievance/GrievanceAdminReportView.vue'),
    meta: { requiresAuth: true, title: 'All Grievances' },
  },
  {
    path: '/Grievance/tickets/:ticketId',
    name: 'grievance-ticket',
    component: () => import('@/views/grievance/GrievanceTicketView.vue'),
    meta: { requiresAuth: true, title: 'Grievance Ticket' },
  },
  // Support routes
  {
    path: '/Support/My-Support',
    name: 'my-support',
    component: () => import('@/views/support/MySupportView.vue'),
    meta: { requiresAuth: true, title: 'My Support' },
  },
  {
    path: '/Support/Support-Queries',
    name: 'support-queries',
    component: () => import('@/views/support/SupportAdminView.vue'),
    meta: { requiresAuth: true, title: 'Support Queries' },
  },
  {
    path: '/Support/Support-Details/:id',
    name: 'support-details',
    component: () => import('@/views/support/SupportDetailView.vue'),
    meta: { requiresAuth: true, title: 'Support Details' },
  },
  // Events routes
  {
    path: '/events',
    name: 'events',
    component: () => import('@/views/events/EventsListView.vue'),
    meta: { requiresAuth: true, title: 'Events' },
  },
  {
    path: '/events/create',
    name: 'event-create',
    component: () => import('@/views/events/EventCreateView.vue'),
    meta: { requiresAuth: true, title: 'Create Event' },
  },
  {
    path: '/events/view/:id',
    name: 'event-detail',
    component: () => import('@/views/events/EventDetailView.vue'),
    meta: { requiresAuth: true, title: 'Event Details' },
  },
  {
    path: '/events/edit/:id',
    name: 'event-edit',
    component: () => import('@/views/events/EventCreateView.vue'),
    meta: { requiresAuth: true, title: 'Edit Event' },
  },
  // Employment Details routes
  {
    path: '/employment-details',
    name: 'employment-details',
    component: () => import('@/views/employment/EmploymentDetailView.vue'),
    meta: { requiresAuth: true, title: 'Employment Details' },
  },
  {
    path: '/employment-details/edit',
    name: 'employment-edit',
    component: () => import('@/views/employment/EmploymentEditView.vue'),
    meta: { requiresAuth: true, title: 'Edit Employment Details' },
  },
  // Nominee routes
  {
    path: '/nominees',
    name: 'nominees',
    component: () => import('@/views/nominees/NomineeListView.vue'),
    meta: { requiresAuth: true, title: 'Nominee Details' },
  },
  // Certificate routes
  {
    path: '/certificates',
    name: 'certificates',
    component: () => import('@/views/certificates/CertificatesListView.vue'),
    meta: { requiresAuth: true, title: 'Certificate Details' },
  },
  // Exit Management routes
  {
    path: '/resignation-form/:userId?',
    name: 'resignation-form',
    component: () => import('@/views/exit/ResignationFormView.vue'),
    meta: { requiresAuth: true, title: 'Resignation Form' },
  },
  {
    path: '/profile/exit-details',
    name: 'exit-details',
    component: () => import('@/views/exit/ExitDetailsView.vue'),
    meta: { requiresAuth: true, title: 'Exit Details' },
  },
  {
    path: '/employees/employee-exit',
    name: 'exit-employee-list',
    component: () => import('@/views/exit/ExitEmployeeListView.vue'),
    meta: { requiresAuth: true, permission: 'Read.Employees', title: 'Employee Exit' },
  },
  {
    path: '/employees/employee-exit/:resignationId',
    name: 'exit-employee-details',
    component: () => import('@/views/exit/ExitDetailsPageView.vue'),
    meta: { requiresAuth: true, permission: 'Read.Employees', title: 'Exit Details' },
  },
  // Email Template routes
  {
    path: '/settings/email-and-notification',
    name: 'email-templates',
    component: () => import('@/views/email/EmailTemplateListView.vue'),
    meta: { requiresAuth: true, title: 'Email and Notification' },
  },
  {
    path: '/settings/email-and-notification/add',
    name: 'email-template-add',
    component: () => import('@/views/email/EmailTemplateFormView.vue'),
    meta: { requiresAuth: true, title: 'Add Email Template' },
  },
  {
    path: '/settings/email-and-notification/edit/:id',
    name: 'email-template-edit',
    component: () => import('@/views/email/EmailTemplateFormView.vue'),
    meta: { requiresAuth: true, title: 'Edit Email Template' },
  },
  {
    path: '/settings/:path(.*)?',
    name: 'settings',
    component: () => import('@/views/placeholder/PlaceholderView.vue'),
    meta: { requiresAuth: true, title: 'Settings' },
  },
  {
    path: '/developer/:path(.*)?',
    name: 'developer',
    component: () => import('@/views/placeholder/PlaceholderView.vue'),
    meta: { requiresAuth: true, title: 'Developer' },
  },
  {
    path: '/:pathMatch(.*)*',
    name: 'not-found',
    component: NotFoundView,
    meta: { requiresAuth: false, title: 'Page Not Found' },
  },
];

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes,
});

// Navigation guard for authentication
router.beforeEach(async (to, _from, next) => {
  const authStore = useAuthStore();

  // Update document title
  document.title = `${to.meta.title || 'HRMS'} | HRMS`;

  // Check if route requires authentication
  if (to.meta.requiresAuth) {
    if (!authStore.isAuthenticated) {
      // Try to load user from stored token
      if (authStore.accessToken) {
        try {
          await authStore.loadUser();
          if (authStore.isAuthenticated) {
            next();
            return;
          }
        } catch {
          // Token invalid, redirect to login
        }
      }
      next({ name: 'login', query: { redirect: to.fullPath } });
      return;
    }
  }

  // If already authenticated and trying to access login pages, redirect to dashboard
  if ((to.name === 'login' || to.name === 'internal-login') && authStore.isAuthenticated) {
    next({ name: 'dashboard' });
    return;
  }

  next();
});

export default router;
