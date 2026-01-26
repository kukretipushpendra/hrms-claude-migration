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
  height: 250px;
  border-radius: 15px;
  border: 1px solid #c7d9eb;
  filter: drop-shadow(2.939px 4.045px 5px rgba(0, 0, 0, 0.08));
  background-color: #f4fafd;
  padding: 10px 15px;
}

.tile-header {
  display: flex;
  align-items: center;
  padding: 0;
  margin-bottom: 12px;
}

.tile-title {
  font-size: 1.25rem; // 20px
  font-weight: 600;
  color: #1e75bb;
}

.tile-content {
  max-height: 180px;
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
