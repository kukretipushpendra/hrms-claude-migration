<template>
  <div class="add-it-asset-view">
    <v-breadcrumbs :items="breadcrumbs" class="px-0" />

    <v-card elevation="3">
      <v-card-title class="page-header">
        <h2>Add IT Asset</h2>
      </v-card-title>

      <v-card-text class="px-5 pb-5">
        <p class="text-subtitle-1 mb-4">
          This view is under construction. Full asset form coming soon.
        </p>

        <v-btn color="primary" :to="/IT-Assets"> Back to Assets List </v-btn>
      </v-card-text>
    </v-card>
  </div>
</template>

<script setup lang="ts">
const breadcrumbs = [
  { title: 'Dashboard', disabled: false, href: '/dashboard' },
  { title: 'IT Assets', disabled: false, href: '/IT-Assets' },
  { title: 'Add Asset', disabled: true },
];
</script>

<style scoped>
.add-it-asset-view {
  padding: 20px;
}

.page-header {
  border-bottom: 1px solid #e0e0e0;
  padding: 16px 20px;
}

.page-header h2 {
  font-size: 1.5rem;
  font-weight: 600;
  color: #1e75bb;
  margin: 0;
}
</style>
