<template>
  <div>
    <v-breadcrumbs :items="breadcrumbs" />
    <v-card>
      <v-card-title class="bg-primary text-white d-flex justify-space-between align-center">
        <h3>All Grievances Report</h3>
        <v-btn
          color="white"
          variant="outlined"
          prepend-icon="mdi-download"
          :loading="exporting"
          @click="handleExport"
        >
          Export
        </v-btn>
      </v-card-title>
      <v-card-text class="pa-4">
        <!-- Filters -->
        <v-expansion-panels v-model="showFilters" variant="accordion">
          <v-expansion-panel>
            <v-expansion-panel-title>
              <v-icon class="mr-2">mdi-filter-variant</v-icon>
              Filters
              <v-chip v-if="hasActiveFilters" size="small" color="primary" class="ml-2">
                Active
              </v-chip>
            </v-expansion-panel-title>
            <v-expansion-panel-text>
              <AdminReportFilterForm
                ref="filterFormRef"
                v-model="filters"
                @search="handleSearch"
                @reset="handleFilterReset"
              />
            </v-expansion-panel-text>
          </v-expansion-panel>
        </v-expansion-panels>

        <!-- Data Table -->
        <v-data-table-server
          v-model:items-per-page="pagination.pageSize"
          v-model:page="pagination.pageNumber"
          v-model:sort-by="sortBy"
          :headers="headers"
          :items="grievances"
          :items-length="totalRecords"
          :loading="loading"
          class="mt-4"
          @update:options="loadGrievances"
        >
          <template #item.ticketNo="{ item }">
            <router-link :to="`/Grievance/tickets/${item.id}`" class="text-primary">
              {{ item.ticketNo }}
            </router-link>
          </template>
          <template #item.status="{ item }">
            <GrievanceStatusChip :status="item.status" :level="item.level" />
          </template>
          <template #item.level="{ item }">
            <v-chip size="small">{{ getLevelLabel(item.level) }}</v-chip>
          </template>
          <template #item.tatStatus="{ item }">
            <v-chip :color="item.tatStatus ? 'success' : 'error'" size="small">
              {{ item.tatStatus ? 'Within TAT' : 'Breached' }}
            </v-chip>
          </template>
          <template #item.createdDate="{ item }">
            {{ formatDate(item.createdDate) }}
          </template>
          <template #item.resolvedDate="{ item }">
            {{ item.resolvedDate ? formatDate(item.resolvedDate) : 'N/A' }}
          </template>
        </v-data-table-server>
      </v-card-text>
    </v-card>

    <v-snackbar v-model="showError" color="error" timeout="5000">
      {{ errorMessage }}
    </v-snackbar>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted, computed } from 'vue';
import AdminReportFilterForm from '@/components/grievance/AdminReportFilterForm.vue';
import GrievanceStatusChip from '@/components/grievance/GrievanceStatusChip.vue';
import {
  getAllEmployeeGrievances,
  exportGrievanceReport,
} from '@/services/grievance/grievance.service';
import { getGrievanceLevelLabel } from '@/utils/grievance.utils';
import type { EmployeeGrievance, AdminGrievanceFilter } from '@/types/grievance.types';

const breadcrumbs = [
  { title: 'Grievance', disabled: false, href: '/Grievance' },
  { title: 'All Grievances', disabled: true },
];

const headers = [
  { title: 'Ticket No', key: 'ticketNo', sortable: true },
  { title: 'Grievance Type', key: 'grievanceTypeName', sortable: true },
  { title: 'Employee', key: 'employeeName', sortable: true },
  { title: 'Title', key: 'title', sortable: true },
  { title: 'Status', key: 'status', sortable: false },
  { title: 'Level', key: 'level', sortable: true },
  { title: 'TAT Status', key: 'tatStatus', sortable: true },
  { title: 'Managed By', key: 'managedBy', sortable: false },
  { title: 'Created Date', key: 'createdDate', sortable: true },
  { title: 'Resolved Date', key: 'resolvedDate', sortable: true },
];

const grievances = ref<EmployeeGrievance[]>([]);
const totalRecords = ref(0);
const loading = ref(false);
const exporting = ref(false);
const showFilters = ref<number | undefined>(undefined);
const filterFormRef = ref<any>(null);
const showError = ref(false);
const errorMessage = ref('');

const pagination = reactive({
  pageNumber: 1,
  pageSize: 10,
});

const sortBy = ref<any[]>([{ key: 'createdDate', order: 'desc' }]);

const filters = ref<AdminGrievanceFilter>({
  grievanceTypeId: null,
  status: null,
  level: null,
  tatStatus: null,
  fromDate: null,
  toDate: null,
  createdById: null,
});

const hasActiveFilters = computed(() => {
  return (
    filters.value.grievanceTypeId !== null ||
    filters.value.status !== null ||
    filters.value.level !== null ||
    filters.value.tatStatus !== null ||
    filters.value.fromDate !== null ||
    filters.value.toDate !== null
  );
});

const getLevelLabel = getGrievanceLevelLabel;

const loadGrievances = async () => {
  loading.value = true;
  try {
    const sortColumn = sortBy.value.length > 0 ? sortBy.value[0].key : 'createdDate';
    const sortDirection = sortBy.value.length > 0 ? sortBy.value[0].order : 'desc';

    const result = await getAllEmployeeGrievances({
      pageNumber: pagination.pageNumber,
      pageSize: pagination.pageSize,
      sortColumn,
      sortDirection: sortDirection as 'asc' | 'desc',
      filter: filters.value,
    });

    grievances.value = result.items;
    totalRecords.value = result.totalCount;
  } catch (error) {
    const err = error as { response?: { data?: { message?: string } } };
    errorMessage.value = err.response?.data?.message || 'Failed to load grievances';
    showError.value = true;
  } finally {
    loading.value = false;
  }
};

const handleSearch = (searchFilters: AdminGrievanceFilter) => {
  filters.value = searchFilters;
  pagination.pageNumber = 1;
  loadGrievances();
};

const handleFilterReset = () => {
  filters.value = {
    grievanceTypeId: null,
    status: null,
    level: null,
    tatStatus: null,
    fromDate: null,
    toDate: null,
    createdById: null,
  };
  pagination.pageNumber = 1;
  loadGrievances();
};

const handleExport = async () => {
  exporting.value = true;
  try {
    const sortColumn = sortBy.value.length > 0 ? sortBy.value[0].key : 'createdDate';
    const sortDirection = sortBy.value.length > 0 ? sortBy.value[0].order : 'desc';

    const blob = await exportGrievanceReport({
      pageNumber: 1,
      pageSize: 99999, // Export all
      sortColumn,
      sortDirection: sortDirection as 'asc' | 'desc',
      filter: filters.value,
    });

    // Download file
    const url = window.URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `grievance-report-${new Date().toISOString().split('T')[0]}.xlsx`;
    document.body.appendChild(a);
    a.click();
    window.URL.revokeObjectURL(url);
    document.body.removeChild(a);
  } catch (error) {
    const err = error as { response?: { data?: { message?: string } } };
    errorMessage.value = err.response?.data?.message || 'Failed to export report';
    showError.value = true;
  } finally {
    exporting.value = false;
  }
};

const formatDate = (dateStr: string) => {
  const date = new Date(dateStr);
  return date.toLocaleString('en-US', {
    year: 'numeric',
    month: 'short',
    day: 'numeric',
  });
};

onMounted(() => {
  loadGrievances();
});
</script>

<style scoped>
.text-primary {
  color: rgb(var(--v-theme-primary));
  text-decoration: none;
}

.text-primary:hover {
  text-decoration: underline;
}
</style>
