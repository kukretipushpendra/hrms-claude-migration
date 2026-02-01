/**
 * Navigation Configuration - Matches Legacy React Navigation Exactly
 * From: /layout/Dashboard/Drawer/DrawerContent/Navigation/menu-items/dashboard.tsx
 *
 * IMPORTANT: Navigation filtering uses the `menus` array from login response,
 * NOT permission strings. See KNOWN_ISSUES_AND_PATTERNS.md for details.
 */

import type { NavItem } from '@/types/navigation';
import type { Menu } from '@/stores/auth.store';
import type { FeatureFlagMap } from '@/stores/featureFlag.store';
import { FEATURE_FLAG_TO_MENU_ID } from '@/constants/featureFlags';

// Main navigation items matching legacy menu structure
export const navigationItems: NavItem[] = [
  {
    id: 'dashboard',
    title: 'Dashboard',
    type: 'item',
    url: '/dashboard',
    icon: 'mdi-view-dashboard',
  },
  {
    id: 'roles',
    title: 'Roles',
    type: 'item',
    url: '/roles',
    icon: 'mdi-shield-account',
  },
  {
    id: 'company-policy',
    title: 'Company Policy',
    type: 'item',
    url: '/company-policy',
    icon: 'mdi-file-document',
  },
  {
    id: 'employees',
    title: 'Employees',
    type: 'collapse',
    url: '/employees',
    icon: 'mdi-account-group',
    children: [
      {
        id: 'employees-list',
        title: 'Employees List',
        type: 'item',
        url: '/employees/employee-list',
        icon: 'mdi-chevron-right',
      },
      {
        id: 'employee-exit',
        title: 'Employee Exit',
        type: 'item',
        url: '/employees/employee-exit',
        icon: 'mdi-chevron-right',
      },
    ],
  },
  {
    id: 'attendance',
    title: 'Attendance',
    type: 'collapse',
    url: '/attendance',
    icon: 'mdi-calendar-month',
    children: [
      {
        id: 'my-attendance',
        title: 'My Attendance',
        type: 'item',
        url: '/attendance/my-attendance',
        icon: 'mdi-chevron-right',
      },
      {
        id: 'attendance-configuration',
        title: 'Attendance Configuration',
        type: 'item',
        url: '/attendance/attendance-configuration',
        icon: 'mdi-chevron-right',
        roles: ['SUPER_ADMIN'],
      },
      {
        id: 'employee-report',
        title: 'Employee Report',
        type: 'item',
        url: '/attendance/employee-report',
        icon: 'mdi-chevron-right',
      },
    ],
  },
  {
    id: 'it-assets',
    title: 'IT Assets',
    type: 'item',
    url: '/IT-Assets',
    icon: 'mdi-devices',
  },
  {
    id: 'leave',
    title: 'Leave',
    type: 'collapse',
    url: '/leave',
    icon: 'mdi-calendar-check',
    children: [
      {
        id: 'apply-leave',
        title: 'Apply Leave',
        type: 'item',
        url: '/leave/apply-leave',
        icon: 'mdi-chevron-right',
      },
      {
        id: 'leave-approval',
        title: 'Leave Approval',
        type: 'item',
        url: '/leave/leave-approval',
        icon: 'mdi-chevron-right',
      },
      {
        id: 'leave-calendar',
        title: 'Leave Calendar',
        type: 'item',
        url: '/leave/leave-calendar',
        icon: 'mdi-chevron-right',
      },
    ],
  },
  {
    id: 'kpi',
    title: 'KPI',
    type: 'collapse',
    url: '/Kpi',
    icon: 'mdi-chart-box',
    children: [
      {
        id: 'my-kpi',
        title: 'My KPI',
        type: 'item',
        url: '/KPI/My-KPI',
        icon: 'mdi-chevron-right',
      },
      {
        id: 'kpi-management',
        title: 'KPI Management',
        type: 'item',
        url: '/KPI/KPI-Management',
        icon: 'mdi-chevron-right',
      },
      {
        id: 'goals',
        title: 'Goals',
        type: 'item',
        url: '/KPI/Goals',
        icon: 'mdi-chevron-right',
      },
    ],
  },
  {
    id: 'grievance',
    title: 'Grievance',
    type: 'collapse',
    url: '/Grievance',
    icon: 'mdi-message-alert',
    children: [
      {
        id: 'my-grievance',
        title: 'My Grievance',
        type: 'item',
        url: '/Grievance/My-Grievance',
        icon: 'mdi-chevron-right',
      },
      {
        id: 'all-grievance',
        title: 'All Grievance',
        type: 'item',
        url: '/Grievance/All-Grievance',
        icon: 'mdi-chevron-right',
      },
      {
        id: 'grievance-configuration',
        title: 'Grievance Configuration',
        type: 'item',
        url: '/Grievance/Grievance-Configuration',
        icon: 'mdi-chevron-right',
        roles: ['SUPER_ADMIN'],
      },
    ],
  },
  {
    id: 'support',
    title: 'Support',
    type: 'collapse',
    url: '/Support',
    icon: 'mdi-face-agent',
    children: [
      {
        id: 'my-support',
        title: 'My Support',
        type: 'item',
        url: '/Support/My-Support',
        icon: 'mdi-chevron-right',
      },
      {
        id: 'support-queries',
        title: 'Support Queries',
        type: 'item',
        url: '/Support/Support-Queries',
        icon: 'mdi-chevron-right',
      },
    ],
  },
  {
    id: 'events',
    title: 'Events',
    type: 'item',
    url: '/events',
    icon: 'mdi-calendar-star',
  },
  {
    id: 'settings',
    title: 'Settings',
    type: 'collapse',
    url: '/settings',
    icon: 'mdi-cog',
    roles: ['SUPER_ADMIN'],
    children: [
      {
        id: 'email-notification',
        title: 'Email and Notification',
        type: 'item',
        url: '/settings/email-and-notification',
        icon: 'mdi-chevron-right',
      },
      {
        id: 'department',
        title: 'Department',
        type: 'item',
        url: '/settings/department',
        icon: 'mdi-chevron-right',
      },
      {
        id: 'designation',
        title: 'Designation',
        type: 'item',
        url: '/settings/designation',
        icon: 'mdi-chevron-right',
      },
      {
        id: 'team',
        title: 'Team',
        type: 'item',
        url: '/settings/team',
        icon: 'mdi-chevron-right',
      },
    ],
  },
  {
    id: 'developer',
    title: 'Developer',
    type: 'collapse',
    url: '/developer',
    icon: 'mdi-developer-board',
    roles: ['SUPER_ADMIN'],
    children: [
      {
        id: 'logs',
        title: 'Logs',
        type: 'item',
        url: '/developer/logs',
        icon: 'mdi-chevron-right',
      },
      {
        id: 'cron-jobs',
        title: 'Cron Jobs',
        type: 'item',
        url: '/developer/cron-jobs',
        icon: 'mdi-chevron-right',
      },
    ],
  },
];

/**
 * Filter navigation items based on user's permitted menus and role
 * This matches the legacy React implementation exactly.
 *
 * The backend sends a `menus` array in the login response that contains
 * the user's permitted navigation items. We filter the nav config against
 * this array to show only what the user is allowed to see.
 */
export function filterNavigation(
  items: NavItem[],
  userMenus: Menu[],
  userRole: string,
  featureFlags?: FeatureFlagMap
): NavItem[] {
  // First filter by permissions and role
  let filteredItems = filterByPermissions(items, userMenus, userRole);

  // Then filter by feature flags if provided
  if (featureFlags) {
    filteredItems = filterByFeatureFlags(filteredItems, featureFlags);
  }

  return filteredItems;
}

/**
 * Filter navigation by permissions and role
 */
function filterByPermissions(items: NavItem[], userMenus: Menu[], userRole: string): NavItem[] {
  return items
    .filter((item) => {
      // Dashboard always shows
      if (item.id === 'dashboard') {
        return true;
      }

      // Check role restrictions first
      if (item.roles && item.roles.length > 0 && !item.roles.includes(userRole)) {
        return false;
      }

      // Find matching menu in user's permitted menus
      // Compare by title (case-insensitive)
      const permittedMenu = userMenus.find(
        (menu) => menu.mainMenu.toLowerCase() === item.title.toLowerCase()
      );

      // If this is a role-only item (Settings, Developer), allow if role matches
      if (item.roles && item.roles.includes(userRole)) {
        return true;
      }

      // Must have permission in menus array
      return !!permittedMenu;
    })
    .map((item) => {
      // Filter children based on subMenus
      if (item.children && item.children.length > 0) {
        // Find the parent menu to get subMenus
        const permittedMenu = userMenus.find(
          (menu) => menu.mainMenu.toLowerCase() === item.title.toLowerCase()
        );

        const filteredChildren = item.children.filter((child) => {
          // Check role restrictions
          if (child.roles && child.roles.length > 0 && !child.roles.includes(userRole)) {
            return false;
          }

          // If parent has subMenus, filter by them
          if (permittedMenu && permittedMenu.subMenus && permittedMenu.subMenus.length > 0) {
            const hasSubMenuPermission = permittedMenu.subMenus.some(
              (sub) => sub.subMenu.toLowerCase() === child.title.toLowerCase()
            );
            return hasSubMenuPermission;
          }

          // If no subMenus specified, show all children (parent permission grants access)
          return true;
        });

        return {
          ...item,
          children: filteredChildren,
        };
      }
      return item;
    })
    .filter((item) => {
      // Remove collapse items with no children
      if (item.type === 'collapse' && (!item.children || item.children.length === 0)) {
        return false;
      }
      return true;
    });
}

/**
 * Filter navigation by feature flags
 * Matches legacy filterMenusByFeatureFlags function
 * From: /layout/Dashboard/Drawer/DrawerContent/Navigation/index.tsx
 */
function filterByFeatureFlags(items: NavItem[], flags: FeatureFlagMap): NavItem[] {
  // Create reverse mapping: menuId -> flagKey
  const menuIdToFlag: Record<string, string> = {};
  Object.entries(FEATURE_FLAG_TO_MENU_ID).forEach(([flagKey, menuIds]) => {
    menuIds.forEach((id) => {
      menuIdToFlag[id] = flagKey;
    });
  });

  /**
   * Filter a single item
   */
  function filterItem(item: NavItem): NavItem | null {
    const flagKey = menuIdToFlag[item.id];
    if (flagKey) {
      return flags[flagKey] ? item : null;
    }
    return item;
  }

  /**
   * Filter a collapse item with children
   */
  function filterCollapse(item: NavItem): NavItem | null {
    // Check if parent is disabled
    const itemFlag = menuIdToFlag[item.id];
    if (itemFlag && !flags[itemFlag]) {
      return null;
    }

    // Filter children
    if (item.children && item.children.length > 0) {
      const filteredChildren = item.children
        .map((child) => {
          const childFlag = menuIdToFlag[child.id];
          return childFlag ? (flags[childFlag] ? child : null) : child;
        })
        .filter((child): child is NavItem => child !== null);

      // If no children remain, hide parent
      if (filteredChildren.length === 0) {
        return null;
      }

      return { ...item, children: filteredChildren };
    }

    return item;
  }

  // Filter all items
  return items
    .map((item) => {
      if (item.type === 'collapse' && item.children) {
        return filterCollapse(item);
      } else {
        return filterItem(item);
      }
    })
    .filter((item): item is NavItem => item !== null);
}
