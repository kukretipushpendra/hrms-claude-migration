<template>
  <div class="add-it-asset-view">
    <v-breadcrumbs :items="breadcrumbs" class="px-0" />

    <v-card elevation="3">
      <v-card-title class="page-header">
        <div class="d-flex align-center">
          <v-btn icon="mdi-arrow-left" variant="text" size="small" @click="goBack" class="mr-2" />
          <h2>Add Asset</h2>
        </div>
      </v-card-title>

      <ITAssetForm mode="add" :is-editable="true" @success="handleSuccess" />
    </v-card>
  </div>
</template>

<script setup lang="ts">
import { useRouter } from 'vue-router';
import ITAssetForm from '@/components/assets/ITAssetForm.vue';

const router = useRouter();

const breadcrumbs = [
  { title: 'Dashboard', disabled: false, href: '/dashboard' },
  { title: 'IT Assets', disabled: false, href: '/IT-Assets' },
  { title: 'Add Asset', disabled: true },
];

function goBack() {
  router.push('/IT-Assets');
}

function handleSuccess() {
  // Form already shows success message and resets
  // Could navigate back if needed
}
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
