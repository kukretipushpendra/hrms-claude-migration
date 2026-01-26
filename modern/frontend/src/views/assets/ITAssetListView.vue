<template>
  <div class="it-asset-list-view">
    <v-breadcrumbs :items="breadcrumbs" class="px-0" />

    <v-card elevation="3">
      <v-card-title class="page-header">
        <h2>IT Assets</h2>
      </v-card-title>

      <v-card-text class="px-5 pb-5">
        <!-- Toolbar with filters and actions -->
        <ITAssetTableToolbar
          v-model:show-filters="showFilters"
          v-model:selected-employees="selectedEmployees"
          :has-active-filters="hasActiveFilters"
          @search="handleSearch"
          @reset="handleFilterReset"
          @import-success="handleImportSuccess"
        />

        <!-- Data Table -->
        <v-data-table-server
          v-model:items-per-page="pageSize"
          v-model:page="currentPage"
          v-model:sort-by="sortBy"
          :headers="headers"
          :items="assets"
          :items-length="totalRecords"
          :loading="loading"
          class="elevation-1 mt-4"
          item-value="id"
        >
          <!-- Device Name Column -->
          <template #item.deviceName="{ item }">
            <router-link :to="`/IT-Assets/${item.id}/general`" class="asset-link">
              {{ item.deviceName }}
            </router-link>
          </template>

          <!-- Device Code Column -->
          <template #item.deviceCode="{ item }">
            {{ item.deviceCode }}
          </template>

          <!-- Serial Number Column -->
          <template #item.serialNumber="{ item }">
            {{ item.serialNumber }}
          </template>

          <!-- Asset Type Column -->
          <template #item.assetType="{ item }">
            {{ getAssetTypeLabel(item.assetType) }}
          </template>

          <!-- Status Column -->
          <template #item.assetStatus="{ item }">
            <v-chip :color="getStatusColor(item.assetStatus)" size="small">
              {{ getAssetStatusLabel(item.assetStatus) }}
            </v-chip>
          </template>

          <!-- Condition Column -->
          <template #item.assetCondition="{ item }">
            {{ getAssetConditionLabel(item.assetCondition) }}
          </template>

          <!-- Branch Column -->
          <template #item.branch="{ item }">
            {{ getBranchLabel(item.branch) }}
          </template>

          <!-- Custodian Column -->
          <template #item.custodianFullName="{ item }">
            {{ item.custodianFullName || '-' }}
          </template>
        </v-data-table-server>
      </v-card-text>
    </v-card>

    <!-- Global Loading Overlay -->
    <v-overlay v-model="globalLoading" class="align-center justify-center" persistent>
      <v-progress-circular indeterminate size="64" color="primary" />
    </v-overlay>
  </div>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue';
import { getAssetList } from '@/services/assets/asset.service';
import ITAssetTableToolbar from '@/components/assets/ITAssetTableToolbar.vue';
import {
  type ITAsset,
  type ITAssetSearchFilter,
  ASSET_TYPE_OPTIONS,
  ASSET_STATUS_OPTIONS,
  ASSET_CONDITION_OPTIONS,
  BRANCH_LOCATION_OPTIONS,
  AssetStatus,
} from '@/types/asset.types';

// Breadcrumbs
const breadcrumbs = [
  { title: 'Dashboard', disabled: false, href: '/dashboard' },
  { title: 'IT Assets', disabled: true },
];

// State
const assets = ref<ITAsset[]>([]);
const totalRecords = ref(0);
const loading = ref(false);
const globalLoading = ref(false);
const showFilters = ref(false);
const hasActiveFilters = ref(false);
const selectedEmployees = ref<string[]>([]);

// Pagination
const currentPage = ref(1);
const pageSize = ref(10);

// Sorting
const sortBy = ref<Array<{ key: string; order: 'asc' | 'desc' }>>([]);

// Filters
const filters = ref<ITAssetSearchFilter>({
  deviceName: null,
  deviceCode: null,
  manufacturer: null,
  model: null,
  assetStatus: null,
  assetType: null,
  branch: null,
  employeeCodes: '',
});

// Table Headers
const headers = [
  { title: 'Device Name', key: 'deviceName', sortable: true },
  { title: 'Device Code', key: 'deviceCode', sortable: true },
  { title: 'Serial Number', key: 'serialNumber', sortable: true },
  { title: 'Type', key: 'assetType', sortable: true },
  { title: 'Status', key: 'assetStatus', sortable: true },
  { title: 'Condition', key: 'assetCondition', sortable: false },
  { title: 'Branch', key: 'branch', sortable: true },
  { title: 'Custodian', key: 'custodianFullName', sortable: true },
];

// Fetch Assets
const fetchAssets = async () => {
  loading.value = true;
  try {
    const employeeCodes = selectedEmployees.value.map((emp) => emp.split(' - ')[0]).join(',');

    const sortColumnName = sortBy.value[0]?.key || '';
    const sortDirection = sortBy.value[0]?.order === 'desc' ? 'desc' : 'asc';

    const response = await getAssetList({
      sortColumnName,
      sortDirection,
      startIndex: (currentPage.value - 1) * pageSize.value,
      pageSize: pageSize.value,
      filters: {
        ...filters.value,
        employeeCodes,
      },
    });

    if (response.statusCode === 200 && response.result) {
      assets.value = response.result.iTAssetList || [];
      totalRecords.value = response.result.totalRecords || 0;
    }
  } catch (error) {
    console.error('Error fetching assets:', error);
  } finally {
    loading.value = false;
  }
};

// Watch for changes
watch([currentPage, pageSize, sortBy, selectedEmployees], () => {
  fetchAssets();
});

// Handle search from filter
const handleSearch = (newFilters: ITAssetSearchFilter) => {
  filters.value = { ...newFilters };
  currentPage.value = 1;
  fetchAssets();
};

// Handle filter reset
const handleFilterReset = () => {
  filters.value = {
    deviceName: null,
    deviceCode: null,
    manufacturer: null,
    model: null,
    assetStatus: null,
    assetType: null,
    branch: null,
    employeeCodes: '',
  };
  currentPage.value = 1;
  hasActiveFilters.value = false;
  fetchAssets();
};

// Handle import success
const handleImportSuccess = () => {
  sortBy.value = [];
  fetchAssets();
};

// Helper functions for labels
const getAssetTypeLabel = (value: number) => {
  return ASSET_TYPE_OPTIONS.find((opt) => opt.value === value)?.label || '-';
};

const getAssetStatusLabel = (value: number) => {
  return ASSET_STATUS_OPTIONS.find((opt) => opt.value === value)?.label || '-';
};

const getAssetConditionLabel = (value: number) => {
  return ASSET_CONDITION_OPTIONS.find((opt) => opt.value === value)?.label || '-';
};

const getBranchLabel = (value: number) => {
  return BRANCH_LOCATION_OPTIONS.find((opt) => opt.value === value)?.label || '-';
};

const getStatusColor = (status: number) => {
  if (status === AssetStatus.Allocated) return 'success';
  if (status === AssetStatus.InInventory) return 'info';
  if (status === AssetStatus.Retired) return 'error';
  return 'default';
};

// Initial fetch
fetchAssets();
</script>

<style scoped>
.it-asset-list-view {
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

.asset-link {
  color: #1e75bb;
  text-decoration: none;
  font-weight: 500;
}

.asset-link:hover {
  text-decoration: underline;
}
</style>
