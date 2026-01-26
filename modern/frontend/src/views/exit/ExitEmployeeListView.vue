<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import dayjs from 'dayjs';
import { useAuthStore } from '@/stores/auth.store';
import { useSnackbar } from '@/composables/useSnackbar';
import { getResignationList } from '@/services/exit/exit.service';
import {
  RESIGNATION_STATUS_LABELS,
  KT_STATUS_LABELS,
  type ExitEmployeeListItem,
  type GetResignationListRequest,
  type ExitEmployeeSearchFilter,
} from '@/types/exit.types';
import ExitEmployeeFilterForm from '@/components/exit/ExitEmployeeFilterForm.vue';

const router = useRouter();
const authStore = useAuthStore();
const { showError } = useSnackbar();

// State
const loading = ref(false);
const items = ref<ExitEmployeeListItem[]>([]);
const totalItems = ref(0);
const itemsPerPage = ref(10);
const page = ref(1);
const sortBy = ref<{ key: string; order: 'asc' | 'desc' }[]>([
  { key: 'resignationDate', order: 'desc' },
]);
const showFilters = ref(false);
const filters = ref<ExitEmployeeSearchFilter>({});

// Table headers
const headers = [
  { title: 'Employee Code', key: 'employeeCode', sortable: true },
  { title: 'Employee Name', key: 'employeeName', sortable: true },
  { title: 'Department', key: 'departmentName', sortable: true },
  { title: 'Resignation Date', key: 'resignationDate', sortable: true },
  { title: 'Last Working Day', key: 'lastWorkingDay', sortable: true },
  { title: 'Early Release', key: 'earlyReleaseDate', sortable: false },
  { title: 'Status', key: 'resignationStatus', sortable: true },
  { title: 'KT Status', key: 'ktStatus', sortable: true },
  { title: 'Exit Interview', key: 'exitInterviewStatus', sortable: false },
  { title: 'IT No-Due', key: 'itNoDue', sortable: false },
  { title: 'Accounts No-Due', key: 'accountsNoDue', sortable: false },
];

// Fetch data
const fetchEmployees = async () => {
  try {
    loading.value = true;

    const sortColumn = sortBy.value[0]?.key || 'resignationDate';
    const sortDirection = sortBy.value[0]?.order === 'desc' ? 'desc' : 'asc';

    const request: GetResignationListRequest = {
      sortColumnName: sortColumn,
      sortDirection,
      startIndex: (page.value - 1) * itemsPerPage.value,
      pageSize: itemsPerPage.value,
      filters: filters.value,
    };

    const response = await getResignationList(request);

    if (response.result) {
      items.value = response.result.exitEmployeeList;
      totalItems.value = response.result.totalRecords;
    }
  } catch (error) {
    const err = error as { response?: { data?: { message?: string } } };
    showError(err.response?.data?.message || 'Failed to fetch resignation list');
  } finally {
    loading.value = false;
  }
};

// Handle row click
const handleRowClick = (_event: Event, row: { item: ExitEmployeeListItem }) => {
  router.push({
    name: 'exit-employee-details',
    params: { resignationId: row.item.resignationId },
  });
};

// Handle filter apply
const handleFilterApply = (newFilters: ExitEmployeeSearchFilter) => {
  filters.value = newFilters;
  page.value = 1; // Reset to first page
  fetchEmployees();
};

// Handle filter reset
const handleFilterReset = () => {
  filters.value = {};
  page.value = 1;
  fetchEmployees();
};

// Watch for pagination and sorting changes
const handleUpdate = () => {
  fetchEmployees();
};

// Permission check
onMounted(() => {
  const hasPermission = authStore.hasPermission('Read.Employees');
  if (!hasPermission) {
    router.replace('/unauthorized');
    return;
  }
  fetchEmployees();
});
</script>

<template>
  <v-container fluid>
    <!-- Breadcrumbs -->
    <v-breadcrumbs
      :items="[
        { title: 'Home', disabled: false, href: '/' },
        { title: 'Employees', disabled: false, href: '/employees' },
        { title: 'Employee Exit', disabled: true },
      ]"
    />

    <!-- Page Header -->
    <v-card elevation="3" class="mb-4">
      <v-card-title class="text-h5 pa-4">
        Employee Exit Management
        <v-spacer />
        <v-btn color="primary" variant="outlined" @click="showFilters = !showFilters">
          {{ showFilters ? 'Hide' : 'Show' }} Filters
        </v-btn>
      </v-card-title>
    </v-card>

    <!-- Filters -->
    <v-expand-transition>
      <ExitEmployeeFilterForm
        v-if="showFilters"
        class="mb-4"
        :initial-filters="filters"
        @apply="handleFilterApply"
        @reset="handleFilterReset"
      />
    </v-expand-transition>

    <!-- Data Table -->
    <v-card elevation="3">
      <v-data-table-server
        v-model:items-per-page="itemsPerPage"
        v-model:page="page"
        v-model:sort-by="sortBy"
        :headers="headers"
        :items="items"
        :items-length="totalItems"
        :loading="loading"
        item-value="resignationId"
        class="elevation-1"
        @update:options="handleUpdate"
        @click:row="handleRowClick"
      >
        <!-- Employee Code -->
        <template #item.employeeCode="{ item }">
          <span class="text-primary font-weight-medium cursor-pointer">
            {{ item.employeeCode }}
          </span>
        </template>

        <!-- Resignation Date -->
        <template #item.resignationDate="{ item }">
          {{ dayjs(item.resignationDate).format('MMM DD, YYYY') }}
        </template>

        <!-- Last Working Day -->
        <template #item.lastWorkingDay="{ item }">
          {{ dayjs(item.lastWorkingDay).format('MMM DD, YYYY') }}
        </template>

        <!-- Early Release -->
        <template #item.earlyReleaseDate="{ item }">
          {{ item.earlyReleaseDate ? dayjs(item.earlyReleaseDate).format('MMM DD, YYYY') : 'N/A' }}
        </template>

        <!-- Status -->
        <template #item.resignationStatus="{ item }">
          <v-chip
            :color="
              item.resignationStatus === 3
                ? 'success'
                : item.resignationStatus === 1
                  ? 'warning'
                  : 'error'
            "
            size="small"
          >
            {{
              RESIGNATION_STATUS_LABELS[
                item.resignationStatus as keyof typeof RESIGNATION_STATUS_LABELS
              ] || 'Unknown'
            }}
          </v-chip>
        </template>

        <!-- KT Status -->
        <template #item.ktStatus="{ item }">
          <v-chip
            :color="item.ktStatus === 3 ? 'success' : item.ktStatus === 2 ? 'info' : 'warning'"
            size="small"
          >
            {{ KT_STATUS_LABELS[item.ktStatus as keyof typeof KT_STATUS_LABELS] || 'Unknown' }}
          </v-chip>
        </template>

        <!-- Exit Interview -->
        <template #item.exitInterviewStatus="{ item }">
          <v-icon :color="item.exitInterviewStatus ? 'success' : 'error'">
            {{ item.exitInterviewStatus ? 'mdi-check-circle' : 'mdi-close-circle' }}
          </v-icon>
        </template>

        <!-- IT No-Due -->
        <template #item.itNoDue="{ item }">
          <v-icon :color="item.itNoDue ? 'success' : 'error'">
            {{ item.itNoDue ? 'mdi-check-circle' : 'mdi-close-circle' }}
          </v-icon>
        </template>

        <!-- Accounts No-Due -->
        <template #item.accountsNoDue="{ item }">
          <v-icon :color="item.accountsNoDue ? 'success' : 'error'">
            {{ item.accountsNoDue ? 'mdi-check-circle' : 'mdi-close-circle' }}
          </v-icon>
        </template>

        <!-- No data -->
        <template #no-data>
          <div class="text-center pa-4">
            <v-icon size="64" color="grey">mdi-database-off</v-icon>
            <p class="text-h6 mt-2">No resignation records found</p>
          </div>
        </template>
      </v-data-table-server>
    </v-card>
  </v-container>
</template>

<style scoped>
.v-breadcrumbs {
  padding-left: 0;
}

.cursor-pointer {
  cursor: pointer;
}

:deep(.v-data-table tbody tr) {
  cursor: pointer;
}

:deep(.v-data-table tbody tr:hover) {
  background-color: rgba(0, 0, 0, 0.04);
}
</style>
