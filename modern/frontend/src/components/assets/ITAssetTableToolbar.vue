<template>
  <div class="it-asset-toolbar">
    <!-- Action Buttons Row -->
    <div class="toolbar-actions">
      <v-btn color="primary" prepend-icon="mdi-plus" to="/IT-Assets/add" class="me-2">
        Add Asset
      </v-btn>

      <v-btn
        variant="outlined"
        prepend-icon="mdi-upload"
        class="me-2"
        @click="showImportDialog = true"
      >
        Import Excel
      </v-btn>

      <v-btn
        :variant="hasActiveFilters ? 'tonal' : 'outlined'"
        :prepend-icon="showFilters ? 'mdi-chevron-up' : 'mdi-chevron-down'"
        @click="showFilters = !showFilters"
      >
        {{ showFilters ? 'Hide Filters' : 'Show Filters' }}
      </v-btn>
    </div>

    <!-- Filters Section -->
    <v-expand-transition>
      <div v-show="showFilters" class="filters-section mt-4">
        <ITAssetTableFilter
          @search="handleSearch"
          @reset="handleReset"
          @update:has-filters="hasActiveFilters = $event"
        />
      </div>
    </v-expand-transition>

    <!-- Employee Filter Autocomplete -->
    <div class="employee-filter mt-4">
      <v-autocomplete
        v-model="localSelectedEmployees"
        :items="[]"
        label="Filter by Employee"
        multiple
        chips
        closable-chips
        clearable
        placeholder="Search employees..."
        density="comfortable"
      />
    </div>

    <!-- Import Dialog -->
    <ImportAssetDialog v-model="showImportDialog" @import-success="handleImportSuccess" />
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue';
import ITAssetTableFilter from '@/components/assets/ITAssetTableFilter.vue';
import ImportAssetDialog from '@/components/assets/ImportAssetDialog.vue';
import type { ITAssetSearchFilter } from '@/types/asset.types';

// Props
const props = defineProps<{
  showFilters: boolean;
  selectedEmployees: string[];
  hasActiveFilters: boolean;
}>();

// Emits
const emit = defineEmits<{
  (e: 'update:showFilters', value: boolean): void;
  (e: 'update:selectedEmployees', value: string[]): void;
  (e: 'search', filters: ITAssetSearchFilter): void;
  (e: 'reset'): void;
  (e: 'importSuccess'): void;
}>();

// Local state
const showImportDialog = ref(false);

// Two-way binding for show filters
const showFilters = computed({
  get: () => props.showFilters,
  set: (value) => emit('update:showFilters', value),
});

// Two-way binding for selected employees
const localSelectedEmployees = computed({
  get: () => props.selectedEmployees,
  set: (value) => emit('update:selectedEmployees', value),
});

// Handlers
const handleSearch = (filters: ITAssetSearchFilter) => {
  emit('search', filters);
};

const handleReset = () => {
  emit('reset');
};

const handleImportSuccess = () => {
  showImportDialog.value = false;
  emit('importSuccess');
};
</script>

<style scoped>
.it-asset-toolbar {
  margin-bottom: 16px;
}

.toolbar-actions {
  display: flex;
  align-items: center;
  gap: 8px;
}

.filters-section {
  padding: 16px;
  background-color: #f5f5f5;
  border-radius: 4px;
}

.employee-filter {
  max-width: 400px;
}
</style>
