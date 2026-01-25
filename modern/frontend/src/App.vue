<script setup lang="ts">
import { computed, onMounted } from 'vue';
import { useRoute } from 'vue-router';
import { useAuthStore } from '@/stores/auth.store';
import AppLayout from '@/components/layout/AppLayout.vue';

const route = useRoute();
const authStore = useAuthStore();

// Check if current route requires layout (authenticated routes)
const showLayout = computed(() => {
  return route.meta.requiresAuth === true;
});

// Load user on app mount if token exists
onMounted(async () => {
  if (authStore.accessToken && !authStore.user) {
    await authStore.loadUser();
  }
});
</script>

<template>
  <!-- Authenticated routes with layout -->
  <AppLayout v-if="showLayout">
    <router-view />
  </AppLayout>

  <!-- Public routes without layout (login, etc.) -->
  <router-view v-else />
</template>
