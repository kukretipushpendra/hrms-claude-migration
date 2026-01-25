/**
 * Navigation Types - Matches Legacy React Navigation
 */

export interface NavItem {
  id: string;
  title: string;
  type: 'item' | 'group' | 'collapse';
  url?: string;
  icon?: string;
  children?: NavItem[];
  permission?: string;
  roles?: string[];
  featureFlag?: string;
  external?: boolean;
  disabled?: boolean;
}

export interface NavGroup {
  id: string;
  title: string;
  type: 'group';
  children: NavItem[];
}

export type NavigationItem = NavItem | NavGroup;
