<script setup lang="ts">
/**
 * Dashboard Tile Component
 * Matches legacy React DashboardTile component
 * Card with colored background and content slot
 */

interface Props {
  title: string;
  backgroundClass?: string;
  icon?: string;
}

defineProps<Props>();
</script>

<template>
  <v-card flat :class="['dashboard-tile', backgroundClass]">
    <!-- Tile Header -->
    <div class="tile-header">
      <v-icon v-if="icon" size="20" color="grey-700" class="mr-2">
        {{ icon }}
      </v-icon>
      <span class="tile-title">{{ title }}</span>
    </div>

    <!-- Tile Content -->
    <div class="tile-content">
      <slot name="content" />
    </div>
  </v-card>
</template>

<style scoped lang="scss">
.dashboard-tile {
  border-radius: 12px;
  min-height: 280px;
  border: 1px solid #f0f0f0;

  // Background variants matching legacy
  &.background-0 {
    background-color: #fff5f5; // Light pink (work anniversary)
  }
  &.background-1 {
    background-color: #f0f9ff; // Light blue (holidays)
  }
  &.background-2 {
    background-color: #f0fdf4; // Light green (apply new)
  }
  &.background-3 {
    background-color: #fef3c7; // Light amber (birthdays)
  }
  &.background-4 {
    background-color: #faf5ff; // Light purple (company policy)
  }
  &.background-5 {
    background-color: #ecfeff; // Light cyan (events)
  }
  &.background-6 {
    background-color: #fff1f2; // Light rose (survey)
  }
}

.tile-header {
  display: flex;
  align-items: center;
  padding: 16px;
  border-bottom: 1px solid rgba(0, 0, 0, 0.06);
}

.tile-title {
  font-size: 0.9375rem; // 15px
  font-weight: 600;
  color: #262626;
}

.tile-content {
  padding: 16px;
  max-height: 220px;
  overflow-y: auto;

  // Custom scrollbar
  &::-webkit-scrollbar {
    width: 4px;
  }

  &::-webkit-scrollbar-track {
    background: transparent;
  }

  &::-webkit-scrollbar-thumb {
    background: #d9d9d9;
    border-radius: 2px;
  }
}
</style>
