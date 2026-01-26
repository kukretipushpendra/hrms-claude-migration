<template>
  <v-form @submit.prevent="handleSubmit">
    <v-row>
      <v-col cols="12" md="4">
        <v-text-field
          v-model="localFilters.deviceName"
          label="Device Name"
          density="comfortable"
          clearable
        />
      </v-col>
      <v-col cols="12" md="4">
        <v-text-field
          v-model="localFilters.deviceCode"
          label="Device Code"
          density="comfortable"
          clearable
        />
      </v-col>
      <v-col cols="12" md="4">
        <v-text-field
          v-model="localFilters.manufacturer"
          label="Manufacturer"
          density="comfortable"
          clearable
        />
      </v-col>
      <v-col cols="12" md="4">
        <v-text-field v-model="localFilters.model" label="Model" density="comfortable" clearable />
      </v-col>
      <v-col cols="12" md="4">
        <v-select
          v-model="localFilters.assetType"
          :items="assetTypeOptions"
          label="Asset Type"
          density="comfortable"
          clearable
        />
      </v-col>
      <v-col cols="12" md="4">
        <v-select
          v-model="localFilters.assetStatus"
          :items="assetStatusOptions"
          label="Status"
          density="comfortable"
          clearable
        />
      </v-col>
      <v-col cols="12" md="4">
        <v-select
          v-model="localFilters.branch"
          :items="branchOptions"
          label="Branch"
          density="comfortable"
          clearable
        />
      </v-col>
    </v-row>

    <v-row>
      <v-col cols="12" class="d-flex justify-end gap-2">
        <v-btn variant="outlined" @click="handleReset">Reset</v-btn>
        <v-btn color="primary" type="submit">Apply Filters</v-btn>
      </v-col>
    </v-row>
  </v-form>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue';
import {
  type ITAssetSearchFilter,
  ASSET_TYPE_OPTIONS,
  ASSET_STATUS_OPTIONS,
  BRANCH_LOCATION_OPTIONS,
} from '@/types/asset.types';

// Emits
const emit = defineEmits<{
  (e: 'search', filters: ITAssetSearchFilter): void;
  (e: 'reset'): void;
  (e: 'update:hasFilters', value: boolean): void;
}>();

// Local filter state
const localFilters = ref<ITAssetSearchFilter>({
  deviceName: null,
  deviceCode: null,
  manufacturer: null,
  model: null,
  assetStatus: null,
  assetType: null,
  branch: null,
});

// Dropdown options
const assetTypeOptions = ASSET_TYPE_OPTIONS.map((opt) => ({
  title: opt.label,
  value: opt.value,
}));

const assetStatusOptions = ASSET_STATUS_OPTIONS.map((opt) => ({
  title: opt.label,
  value: opt.value,
}));

const branchOptions = BRANCH_LOCATION_OPTIONS.map((opt) => ({
  title: opt.label,
  value: opt.value,
}));

// Check if any filters are active
const checkHasFilters = () => {
  const hasFilters =
    !!localFilters.value.deviceName ||
    !!localFilters.value.deviceCode ||
    !!localFilters.value.manufacturer ||
    !!localFilters.value.model ||
    localFilters.value.assetStatus !== null ||
    localFilters.value.assetType !== null ||
    localFilters.value.branch !== null;

  emit('update:hasFilters', hasFilters);
};

// Watch for filter changes
watch(
  localFilters,
  () => {
    checkHasFilters();
  },
  { deep: true }
);

// Handlers
const handleSubmit = () => {
  emit('search', { ...localFilters.value });
};

const handleReset = () => {
  localFilters.value = {
    deviceName: null,
    deviceCode: null,
    manufacturer: null,
    model: null,
    assetStatus: null,
    assetType: null,
    branch: null,
  };
  emit('reset');
};

// Expose reset method
defineExpose({
  handleReset,
});
</script>

<style scoped>
.gap-2 {
  gap: 8px;
}
</style>
