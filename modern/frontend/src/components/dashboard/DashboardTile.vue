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
  border: 1px solid #c7d9eb;
  border-radius: 15px;
  height: 250px;
  padding: 10px 15px;
  background-color: #f4fafd;
  display: flex;
  flex-direction: column;
  filter: drop-shadow(2.939px 4.045px 5px rgba(0, 0, 0, 0.08));
  transition: transform 0.2s;

  &:hover {
    transform: scale(1.01);
  }
}

.tile-header {
  display: flex;
  align-items: center;
  padding: 0;
  margin-bottom: 12px;
  border-bottom: none;
}

.tile-title {
  font-size: 0.9375rem;
  font-weight: 600;
  color: #1e75bb;
}

.tile-content {
  flex: 1;
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
