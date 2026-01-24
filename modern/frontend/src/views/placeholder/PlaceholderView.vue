<script setup lang="ts">
import { computed } from 'vue';
import { useRoute } from 'vue-router';

const route = useRoute();

// Get page title from route meta
const pageTitle = computed(() => {
  return (route.meta.title as string) || 'Page';
});

// Get current path for display
const currentPath = computed(() => {
  return route.path;
});
</script>

<template>
  <div class="placeholder-page">
    <!-- Page Header -->
    <div class="page-header mb-6">
      <h2 class="page-title">{{ pageTitle }}</h2>
    </div>

    <!-- Placeholder Content -->
    <v-card class="placeholder-card">
      <v-card-text class="text-center pa-12">
        <v-icon size="80" color="grey-400" class="mb-4">
          mdi-hammer-wrench
        </v-icon>

        <h3 class="text-h5 font-weight-medium mb-2 text-grey-700">
          Under Construction
        </h3>

        <p class="text-body-2 text-grey-500 mb-4">
          This page is being migrated from the legacy application.
        </p>

        <v-chip color="primary" variant="outlined" size="small">
          {{ currentPath }}
        </v-chip>
      </v-card-text>
    </v-card>
  </div>
</template>

<style scoped lang="scss">
.placeholder-page {
  padding: 8px;
}

.page-title {
  font-size: 1.75rem;
  font-weight: 600;
  color: #273a50;
}

.placeholder-card {
  border-radius: 12px;
  border: 1px solid #f0f0f0;
  max-width: 600px;
  margin: 0 auto;
}
</style>
