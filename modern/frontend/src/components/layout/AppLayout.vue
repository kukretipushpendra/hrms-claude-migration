<script setup lang="ts">
import { ref, computed, watch } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import { useDisplay } from 'vuetify';
import { useAuthStore } from '@/stores/auth.store';
import { navigationItems, filterNavigation } from '@/config/navigation';
import type { NavItem } from '@/types/navigation';
import SubmitSupportButton from '@/components/support/SubmitSupportButton.vue';

const router = useRouter();
const route = useRoute();
const authStore = useAuthStore();
const { lgAndUp, mdAndDown } = useDisplay();

// Layout constants matching legacy
const DRAWER_WIDTH = 260;
const DRAWER_WIDTH_MINI = 64;
const HEADER_HEIGHT = 60;

// Drawer state
const drawer = ref(true);
const drawerMini = ref(false);
const drawerHover = ref(false);
const expandedItems = ref<string[]>([]);

// Profile menu state
const profileMenu = ref(false);

// Computed drawer width
const currentDrawerWidth = computed(() => {
  if (mdAndDown.value) {
    return DRAWER_WIDTH;
  }
  if (drawerMini.value && !drawerHover.value) {
    return DRAWER_WIDTH_MINI;
  }
  return DRAWER_WIDTH;
});

// Computed drawer rail mode
const isRail = computed(() => {
  return lgAndUp.value && drawerMini.value && !drawerHover.value;
});

// Filtered navigation based on user's permitted menus (matching legacy)
const filteredNavigation = computed(() => {
  const menus = authStore.user?.menus || [];
  const role = authStore.user?.roleName || '';
  return filterNavigation(navigationItems, menus, role);
});

// User initials for avatar
const userInitials = computed(() => {
  const name = authStore.userFullName || 'User';
  return name
    .split(' ')
    .map((n) => n.charAt(0))
    .join('')
    .substring(0, 2)
    .toUpperCase();
});

// Truncate name for display (max 35 chars like legacy)
const truncatedName = computed(() => {
  const name = authStore.userFullName || 'User';
  return name.length > 35 ? name.substring(0, 35) + '...' : name;
});

// Toggle drawer state
function toggleDrawer() {
  if (lgAndUp.value) {
    drawerMini.value = !drawerMini.value;
  } else {
    drawer.value = !drawer.value;
  }
}

// Handle drawer mouse enter (hover expand)
function handleDrawerMouseEnter() {
  if (drawerMini.value) {
    drawerHover.value = true;
  }
}

// Handle drawer mouse leave
function handleDrawerMouseLeave() {
  drawerHover.value = false;
}

// Toggle submenu expansion
function toggleExpand(itemId: string) {
  const index = expandedItems.value.indexOf(itemId);
  if (index >= 0) {
    expandedItems.value.splice(index, 1);
  } else {
    expandedItems.value.push(itemId);
  }
}

// Check if item is expanded
function isExpanded(itemId: string): boolean {
  return expandedItems.value.includes(itemId);
}

// Check if item or children are active
function isItemActive(item: NavItem): boolean {
  if (item.url && route.path === item.url) {
    return true;
  }
  if (item.children) {
    return item.children.some((child) => child.url && route.path === child.url);
  }
  return false;
}

// Handle navigation
function handleNavigation(item: NavItem) {
  if (item.type === 'collapse') {
    toggleExpand(item.id);
  } else if (item.url) {
    router.push(item.url);
    if (mdAndDown.value) {
      drawer.value = false;
    }
  }
}

// Logout
async function handleLogout() {
  profileMenu.value = false;
  await authStore.logout();
  router.push('/login');
}

// Auto-expand active parent on mount
watch(
  () => route.path,
  () => {
    filteredNavigation.value.forEach((item) => {
      if (item.children && item.children.some((child) => child.url === route.path)) {
        if (!expandedItems.value.includes(item.id)) {
          expandedItems.value.push(item.id);
        }
      }
    });
  },
  { immediate: true }
);
</script>

<template>
  <v-app>
    <!-- App Bar - 60px height matching legacy -->
    <v-app-bar :height="HEADER_HEIGHT" flat class="app-header" color="white" :border="true">
      <!-- Logo (shown when drawer is mini/closed) -->
      <div v-if="isRail" class="header-logo mx-2">
        <img src="/pio-logo-dark.svg" alt="Logo" height="36" width="36" />
      </div>

      <!-- Menu toggle button -->
      <v-btn
        icon
        variant="flat"
        :color="drawerMini ? 'grey-100' : 'grey-200'"
        class="menu-toggle ml-2"
        @click="toggleDrawer"
      >
        <v-icon>
          {{ drawerMini ? 'mdi-menu-open' : 'mdi-menu' }}
        </v-icon>
      </v-btn>

      <v-spacer />

      <!-- Support button -->
      <SubmitSupportButton />

      <!-- Profile Menu -->
      <v-menu
        v-model="profileMenu"
        :close-on-content-click="false"
        location="bottom end"
        transition="slide-y-transition"
      >
        <template #activator="{ props }">
          <v-btn v-bind="props" variant="text" class="profile-btn text-none" height="48">
            <v-avatar color="primary" size="38" class="mr-2">
              <span class="text-subtitle-2 text-white">{{ userInitials }}</span>
            </v-avatar>
            <div v-if="lgAndUp" class="text-left">
              <div class="profile-name">{{ truncatedName }}</div>
              <div class="profile-role">{{ authStore.user?.roleName || 'User' }}</div>
            </div>
            <v-icon v-if="lgAndUp" class="ml-1">mdi-chevron-down</v-icon>
          </v-btn>
        </template>

        <v-card class="profile-menu" min-width="240" max-width="290">
          <div class="profile-menu-header pa-4">
            <div class="profile-name font-weight-medium">{{ truncatedName }}</div>
            <div class="profile-role text-caption text-grey-500">
              {{ authStore.user?.roleName }}
            </div>
          </div>

          <v-divider />

          <v-list density="compact">
            <v-list-item to="/profile" @click="profileMenu = false">
              <template #prepend>
                <v-icon size="20">mdi-account</v-icon>
              </template>
              <v-list-item-title>My Profile</v-list-item-title>
            </v-list-item>

            <v-divider class="my-1" />

            <v-list-item @click="handleLogout" class="text-error">
              <template #prepend>
                <v-icon size="20" color="error">mdi-logout</v-icon>
              </template>
              <v-list-item-title>Logout</v-list-item-title>
            </v-list-item>
          </v-list>
        </v-card>
      </v-menu>
    </v-app-bar>

    <!-- Navigation Drawer - 260px width matching legacy -->
    <v-navigation-drawer
      v-model="drawer"
      :width="currentDrawerWidth"
      :rail="isRail"
      :permanent="lgAndUp"
      :temporary="mdAndDown"
      class="nav-drawer"
      @mouseenter="handleDrawerMouseEnter"
      @mouseleave="handleDrawerMouseLeave"
    >
      <!-- Drawer Header with Logo -->
      <div class="drawer-header pa-4">
        <div class="d-flex align-center">
          <img
            src="/pio-logo-dark.svg"
            alt="HRMS"
            :width="isRail ? 35 : 40"
            :height="isRail ? 35 : 40"
          />
          <span v-if="!isRail" class="ml-3 text-h6 font-weight-bold text-dark"> HRMS </span>
        </div>
      </div>

      <v-divider />

      <!-- Navigation List -->
      <v-list nav density="compact" class="pt-4">
        <template v-for="item in filteredNavigation" :key="item.id">
          <!-- Collapsible item with children -->
          <template v-if="item.type === 'collapse' && item.children?.length">
            <v-list-item
              :class="['nav-item', { 'v-list-item--active': isItemActive(item) }]"
              @click="handleNavigation(item)"
            >
              <template #prepend>
                <v-icon>{{ item.icon }}</v-icon>
              </template>
              <v-list-item-title>{{ item.title }}</v-list-item-title>
              <template #append>
                <v-icon v-if="!isRail" size="18">
                  {{ isExpanded(item.id) ? 'mdi-chevron-up' : 'mdi-chevron-down' }}
                </v-icon>
              </template>
            </v-list-item>

            <!-- Children -->
            <v-expand-transition>
              <div v-show="isExpanded(item.id) && !isRail">
                <v-list-item
                  v-for="child in item.children"
                  :key="child.id"
                  :to="child.url"
                  :active="route.path === child.url"
                  class="nav-item nav-child"
                >
                  <template #prepend>
                    <v-icon size="16">{{ child.icon }}</v-icon>
                  </template>
                  <v-list-item-title class="text-body-2">
                    {{ child.title }}
                  </v-list-item-title>
                </v-list-item>
              </div>
            </v-expand-transition>
          </template>

          <!-- Simple item -->
          <v-list-item v-else :to="item.url" :active="route.path === item.url" class="nav-item">
            <template #prepend>
              <v-icon>{{ item.icon }}</v-icon>
            </template>
            <v-list-item-title>{{ item.title }}</v-list-item-title>
          </v-list-item>
        </template>
      </v-list>
    </v-navigation-drawer>

    <!-- Main Content Area -->
    <v-main class="main-content" :style="{ backgroundColor: '#fafafb' }">
      <v-container fluid class="pa-4 pa-sm-6">
        <slot />
      </v-container>
    </v-main>
  </v-app>
</template>

<style scoped lang="scss">
.app-header {
  border-bottom: 1px solid #f0f0f0 !important;
  box-shadow: 0px 2px 8px rgba(0, 0, 0, 0.08) !important;
}

.header-logo {
  display: flex;
  align-items: center;
}

.menu-toggle {
  border-radius: 8px;
}

.profile-btn {
  .profile-name {
    font-size: 0.875rem;
    font-weight: 500;
    color: #262626;
    max-width: 150px;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }

  .profile-role {
    font-size: 0.75rem;
    color: #8c8c8c;
  }
}

.nav-drawer {
  border-right: 1px solid #f0f0f0;
}

.drawer-header {
  min-height: 60px;
  display: flex;
  align-items: center;
}

.text-dark {
  color: #283a50;
}

.nav-item {
  border-radius: 8px;
  margin: 2px 8px;
  min-height: 44px;

  &.v-list-item--active {
    background-color: rgba(30, 117, 187, 0.1) !important;
    color: #1e75bb !important;

    :deep(.v-icon) {
      color: #1e75bb !important;
    }
  }

  &:hover:not(.v-list-item--active) {
    background-color: #f5f5f5;
  }
}

.nav-child {
  padding-left: 56px !important;
  min-height: 40px;
}

.main-content {
  min-height: 100vh;
}
</style>
