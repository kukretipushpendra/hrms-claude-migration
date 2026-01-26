<script setup lang="ts">
/**
 * Analytics Card Component
 * Matches legacy React AnalyticEcommerce component
 * Gradient background cards with decorative circles
 */

interface Props {
  title: string;
  count: number | string;
  icon?: string;
}

defineProps<Props>();
</script>

<template>
  <div class="analytics-card">
    <!-- Decorative circles (absolute positioned) -->
    <div class="decorative-circle decorative-circle-1"></div>
    <div class="decorative-circle decorative-circle-2"></div>

    <!-- Card content -->
    <div class="analytics-card-content">
      <!-- Icon -->
      <div class="analytics-card-icon">
        <v-icon size="50" color="white">{{ icon || 'mdi-account-group' }}</v-icon>
      </div>

      <!-- Info -->
      <div class="analytics-card-info">
        <div class="analytics-card-title">{{ title }}</div>
        <div class="analytics-card-count">{{ count }}</div>
      </div>
    </div>
  </div>
</template>

<style scoped lang="scss">
.analytics-card {
  background: linear-gradient(149deg, #1e75bb 57%, #27a8e0 100%);
  border-radius: 15px;
  height: 100px;
  position: relative;
  overflow: hidden;
  color: #ffffff;
  box-shadow: 2.939px 4.045px 5px rgba(0, 0, 0, 0.08);
}

.decorative-circle {
  position: absolute;
  border-radius: 50%;

  &.decorative-circle-1 {
    width: 200px;
    height: 210px;
    right: -88px;
    top: -75px;
    background-color: rgba(255, 255, 255, 0.05);
  }

  &.decorative-circle-2 {
    width: 250px;
    height: 250px;
    right: -63px;
    bottom: -122px;
    background-color: rgba(255, 255, 255, 0.1);
  }
}

.analytics-card-content {
  position: relative;
  z-index: 1;
  padding: 16px 20px;
  display: flex;
  align-items: center;
  gap: 16px;
  height: 100%;
}

.analytics-card-icon {
  width: 50px;
  height: 50px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.analytics-card-info {
  flex: 1;
  min-width: 0;
}

.analytics-card-title {
  font-size: 16px;
  font-weight: 500;
  margin-bottom: 4px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;

  @media (min-width: 1024px) {
    font-size: 18px;
  }
}

.analytics-card-count {
  font-size: 28px;
  font-weight: 700;
  text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.1);

  @media (min-width: 1024px) {
    font-size: 32px;
  }
}
</style>
