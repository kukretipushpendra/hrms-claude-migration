<template>
  <div class="employee-it-assets-view">
    <v-breadcrumbs :items="breadcrumbs" class="px-0" />

    <v-card elevation="3">
      <v-card-title class="page-header">
        <h2>My IT Assets</h2>
      </v-card-title>

      <v-card-text class="px-5 pb-5">
        <div v-if="loading" class="text-center py-8">
          <v-progress-circular indeterminate color="primary" />
        </div>

        <div v-else-if="error" class="text-center py-8 text-error">
          {{ error }}
        </div>

        <div v-else-if="assets.length === 0" class="text-center py-8">
          <p>No assets assigned to you.</p>
        </div>

        <v-data-table
          v-else
          :headers="headers"
          :items="assets"
          :items-per-page="10"
          class="elevation-1"
        >
          <template #item.assetType="{ item }">
            {{ getAssetTypeLabel(item.assetType) }}
          </template>

          <template #item.assetStatus="{ item }">
            <v-chip :color="getStatusColor(item.assetStatus)" size="small">
              {{ getAssetStatusLabel(item.assetStatus) }}
            </v-chip>
          </template>

          <template #item.assetCondition="{ item }">
            {{ getAssetConditionLabel(item.assetCondition) }}
          </template>

          <template #item.branch="{ item }">
            {{ getBranchLabel(item.branch) }}
          </template>
        </v-data-table>
      </v-card-text>
    </v-card>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { useRoute } from 'vue-router';
import { useAuthStore } from '@/stores/auth.store';
import { getEmployeeAsset } from '@/services/assets/asset.service';
import {
  type EmployeeAsset,
  ASSET_TYPE_OPTIONS,
  ASSET_STATUS_OPTIONS,
  ASSET_CONDITION_OPTIONS,
  BRANCH_LOCATION_OPTIONS,
  AssetStatus,
} from '@/types/asset.types';

const route = useRoute();
const authStore = useAuthStore();

const breadcrumbs = [
  { title: 'Dashboard', disabled: false, href: '/dashboard' },
  { title: 'My IT Assets', disabled: true },
];

const assets = ref<EmployeeAsset[]>([]);
const loading = ref(false);
const error = ref('');

const headers = [
  { title: 'Device Code', key: 'deviceCode' },
  { title: 'Device Name', key: 'deviceName' },
  { title: 'Serial Number', key: 'serialNumber' },
  { title: 'Manufacturer', key: 'manufacturer' },
  { title: 'Model', key: 'model' },
  { title: 'Type', key: 'assetType' },
  { title: 'Branch', key: 'branch' },
  { title: 'Status', key: 'assetStatus' },
  { title: 'Condition', key: 'assetCondition' },
  { title: 'Assigned On', key: 'assignedOn' },
];

const fetchEmployeeAssets = async () => {
  loading.value = true;
  error.value = '';

  try {
    // Get employee ID from query param or auth store
    const employeeId = route.query.employeeId
      ? Number(route.query.employeeId)
      : Number(authStore.user?.id);

    const response = await getEmployeeAsset(employeeId);

    if (response.statusCode === 200 && response.result) {
      assets.value = response.result;
    } else {
      error.value = response.message || 'Failed to fetch assets';
    }
  } catch (err: unknown) {
    const e = err as { response?: { data?: { message?: string } } };
    error.value = e.response?.data?.message || 'An error occurred';
  } finally {
    loading.value = false;
  }
};

const getAssetTypeLabel = (value: number) => {
  return ASSET_TYPE_OPTIONS.find((opt) => opt.value === value)?.label || '-';
};

const getAssetStatusLabel = (value: number) => {
  return ASSET_STATUS_OPTIONS.find((opt) => opt.value === value)?.label || '-';
};

const getAssetConditionLabel = (value: number) => {
  return ASSET_CONDITION_OPTIONS.find((opt) => opt.value === value)?.label || '-';
};

const getBranchLabel = (value: number | null) => {
  if (value === null) return '-';
  return BRANCH_LOCATION_OPTIONS.find((opt) => opt.value === value)?.label || '-';
};

const getStatusColor = (status: number) => {
  if (status === AssetStatus.Allocated) return 'success';
  if (status === AssetStatus.InInventory) return 'info';
  if (status === AssetStatus.Retired) return 'error';
  return 'default';
};

onMounted(() => {
  fetchEmployeeAssets();
});
</script>

<style scoped>
.employee-it-assets-view {
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
