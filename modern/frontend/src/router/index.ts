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
  // Placeholder routes for navigation items (to be implemented)
  {
    path: '/roles',
    name: 'roles',
    component: () => import('@/views/placeholder/PlaceholderView.vue'),
    meta: { requiresAuth: true, title: 'Roles' },
  },
  {
    path: '/company-policy',
    name: 'company-policy',
    component: () => import('@/views/placeholder/PlaceholderView.vue'),
    meta: { requiresAuth: true, title: 'Company Policy' },
  },
  {
    path: '/employees/:path(.*)?',
    name: 'employees',
    component: () => import('@/views/placeholder/PlaceholderView.vue'),
    meta: { requiresAuth: true, title: 'Employees' },
  },
  {
    path: '/attendance/:path(.*)?',
    name: 'attendance',
    component: () => import('@/views/placeholder/PlaceholderView.vue'),
    meta: { requiresAuth: true, title: 'Attendance' },
  },
  {
    path: '/IT-Assets',
    name: 'it-assets',
    component: () => import('@/views/placeholder/PlaceholderView.vue'),
    meta: { requiresAuth: true, title: 'IT Assets' },
  },
  {
    path: '/leave/:path(.*)?',
    name: 'leave',
    component: () => import('@/views/placeholder/PlaceholderView.vue'),
    meta: { requiresAuth: true, title: 'Leave' },
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
  {
    path: '/events',
    name: 'events',
    component: () => import('@/views/placeholder/PlaceholderView.vue'),
    meta: { requiresAuth: true, title: 'Events' },
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
