<template>
  <div class="asset-details-layout">
    <v-breadcrumbs :items="breadcrumbs" class="px-0" />

    <v-card elevation="3">
      <v-card-title class="page-header">
        <div class="d-flex align-center justify-space-between w-100">
          <h2 :class="{ 'text-grey': !pageTitle, 'font-italic': !pageTitle }">
            {{ pageTitle || 'Unnamed Device' }}
          </h2>
          <v-btn
            v-if="isGeneralTab"
            :icon="isEditable ? 'mdi-close' : 'mdi-pencil'"
            :color="isEditable ? 'error' : 'primary'"
            size="small"
            variant="text"
            @click="toggleEdit"
          >
            <v-icon />
            <v-tooltip activator="parent" location="bottom">
              {{ isEditable ? 'Cancel' : 'Edit Asset Details' }}
            </v-tooltip>
          </v-btn>
        </div>
      </v-card-title>

      <v-tabs v-model="currentTab" bg-color="transparent">
        <v-tab value="general" to="general">General</v-tab>
        <v-tab value="history" to="history">History</v-tab>
      </v-tabs>

      <router-view v-slot="{ Component }">
        <component
          :is="Component"
          :asset-data="assetData"
          :loading="loading"
          :is-editable="isEditable"
          @refresh="fetchAsset"
        />
      </router-view>
    </v-card>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, watch, onMounted } from 'vue';
import { useRoute } from 'vue-router';
import { toast } from 'vue3-toastify';
import type { AssetData } from '@/types/asset.types';
import { getAssetById } from '@/services/assets/asset.service';

const route = useRoute();

const assetData = ref<AssetData | null>(null);
const loading = ref(false);
const isEditable = ref(false);
const currentTab = ref('general');

const assetId = computed(() => Number(route.params.assetId));

const breadcrumbs = computed(() => [
  { title: 'Dashboard', disabled: false, href: '/dashboard' },
  { title: 'IT Assets', disabled: false, href: '/IT-Assets' },
  { title: pageTitle.value || 'Asset Details', disabled: true },
]);

const pageTitle = computed(() => {
  if (!assetData.value) return null;
  const deviceName = assetData.value.deviceName ?? '';
  const deviceCode = assetData.value.deviceCode ?? '';

  if (deviceName) {
    return deviceCode ? `${deviceName} (${deviceCode})` : deviceName;
  }
  return null;
});

const isGeneralTab = computed(() => {
  return currentTab.value === 'general' || route.name === 'asset-general';
});

// Watch route to update current tab
watch(
  () => route.name,
  (newName) => {
    if (newName === 'asset-general') {
      currentTab.value = 'general';
    } else if (newName === 'asset-history') {
      currentTab.value = 'history';
    }
  },
  { immediate: true }
);

// Reset edit mode when tab changes
watch(currentTab, () => {
  isEditable.value = false;
});

onMounted(() => {
  fetchAsset();
});

async function fetchAsset() {
  try {
    loading.value = true;
    const response = await getAssetById(assetId.value);

    if (response.statusCode === 200 && response.result) {
      assetData.value = response.result;
    } else {
      toast.error('Failed to load asset details');
    }
  } catch (error: unknown) {
    const message = error instanceof Error ? error.message : 'Failed to load asset details';
    toast.error(message);
  } finally {
    loading.value = false;
  }
}

function toggleEdit() {
  isEditable.value = !isEditable.value;
}
</script>

<style scoped>
.asset-details-layout {
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
