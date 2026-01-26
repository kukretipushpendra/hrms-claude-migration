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
  {
    path: '/KPI/:path(.*)?',
    name: 'kpi',
    component: () => import('@/views/placeholder/PlaceholderView.vue'),
    meta: { requiresAuth: true, title: 'KPI' },
  },
  {
    path: '/Grievance/:path(.*)?',
    name: 'grievance',
    component: () => import('@/views/placeholder/PlaceholderView.vue'),
    meta: { requiresAuth: true, title: 'Grievance' },
  },
  {
    path: '/Support/:path(.*)?',
    name: 'support',
    component: () => import('@/views/placeholder/PlaceholderView.vue'),
    meta: { requiresAuth: true, title: 'Support' },
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
