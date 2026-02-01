<template>
  <v-container fluid>
    <v-breadcrumbs :items="breadcrumbs" divider=">" class="px-0"></v-breadcrumbs>

    <v-card elevation="3">
      <v-card-title class="d-flex align-center pa-4 border-b">
        <v-btn
          v-if="fromRolesPage"
          icon
          variant="text"
          size="small"
          @click="router.back()"
          class="mr-2"
        >
          <v-icon>mdi-arrow-left</v-icon>
        </v-btn>
        <h2 class="text-h5">Employees List</h2>
      </v-card-title>

      <v-card-text class="pa-5">
        <!-- Top Toolbar -->
        <div class="d-flex align-center mb-4">
          <div class="d-flex gap-2">
            <v-tooltip text="Add Employee" location="bottom">
              <template #activator="{ props }">
                <v-btn v-bind="props" icon variant="text" :to="'/employees/create'">
                  <v-icon>mdi-plus</v-icon>
                </v-btn>
              </template>
            </v-tooltip>

            <v-tooltip text="Export" location="bottom">
              <template #activator="{ props }">
                <v-btn
                  v-bind="props"
                  icon
                  variant="text"
                  :loading="isExporting"
                  @click="handleExport"
                >
                  <v-icon>mdi-download</v-icon>
                </v-btn>
              </template>
            </v-tooltip>

            <v-tooltip text="Import" location="bottom">
              <template #activator="{ props }">
                <v-btn v-bind="props" icon variant="text" @click="importDialogVisible = true">
                  <v-icon>mdi-upload</v-icon>
                </v-btn>
              </template>
            </v-tooltip>
          </div>

          <v-spacer></v-spacer>

          <div class="d-flex gap-2 align-center">
            <!-- Employee Search Autocomplete -->
            <v-autocomplete
              v-model="selectedEmployees"
              :items="searchedEmployees"
              item-title="label"
              item-value="value"
              label="Search Employee"
              multiple
              chips
              closable-chips
              clearable
              density="compact"
              hide-details
              style="min-width: 250px"
            ></v-autocomplete>

            <v-tooltip text="Filters" location="bottom">
              <template #activator="{ props }">
                <v-btn
                  v-bind="props"
                  icon
                  variant="text"
                  :color="hasActiveFilters ? 'primary' : undefined"
                  @click="showFilters = !showFilters"
                >
                  <v-badge :model-value="hasActiveFilters" color="primary" dot>
                    <v-icon>mdi-filter-variant</v-icon>
                  </v-badge>
                </v-btn>
              </template>
            </v-tooltip>

            <v-tooltip v-if="hasActiveFilters" text="Remove Filters" location="bottom">
              <template #activator="{ props }">
                <v-btn v-bind="props" icon variant="text" color="error" @click="handleResetFilters">
                  <v-icon>mdi-filter-variant-remove</v-icon>
                </v-btn>
              </template>
            </v-tooltip>
          </div>
        </div>

        <!-- Filter Form -->
        <v-expand-transition>
          <div v-show="showFilters" class="mb-4">
            <EmployeeFilterForm
              ref="filterFormRef"
              :role-id="initialRoleId"
              @search="handleSearch"
              @has-active-filters="hasActiveFilters = $event"
            />
          </div>
        </v-expand-transition>

        <!-- Data Table -->
        <v-data-table-server
          v-model:items-per-page="itemsPerPage"
          v-model:page="page"
          v-model:sort-by="sortBy"
          :headers="headers"
          :items="employees"
          :items-length="totalRecords"
          :loading="loading"
          class="elevation-1"
          item-value="id"
        >
          <template #item.joiningDate="{ item }">
            {{ formatDate(item.joiningDate) }}
          </template>

          <template #item.branch="{ item }">
            {{ getBranchLabel(item.branch) }}
          </template>

          <template #item.employeeStatus="{ item }">
            {{ getStatusLabel(item.employeeStatus) }}
          </template>

          <template #item.actions="{ item }">
            <div class="d-flex gap-2">
              <v-tooltip text="View Employee Details" location="bottom">
                <template #activator="{ props }">
                  <v-btn
                    v-bind="props"
                    icon
                    size="small"
                    variant="text"
                    color="primary"
                    @click="openEmployeeProfile(item.id)"
                  >
                    <v-icon size="20">mdi-eye</v-icon>
                  </v-btn>
                </template>
              </v-tooltip>

              <v-tooltip text="Edit Employee" location="bottom">
                <template #activator="{ props }">
                  <v-btn
                    v-bind="props"
                    icon
                    size="small"
                    variant="text"
                    color="primary"
                    :to="`/employees/edit/${item.id}`"
                  >
                    <v-icon size="20">mdi-pencil</v-icon>
                  </v-btn>
                </template>
              </v-tooltip>
            </div>
          </template>
        </v-data-table-server>
      </v-card-text>
    </v-card>

    <!-- Import Dialog -->
    <v-dialog v-model="importDialogVisible" max-width="500">
      <v-card>
        <v-card-title>Import Employees</v-card-title>
        <v-card-text>
          <v-file-input
            v-model="importFile"
            label="Select Excel File"
            accept=".xlsx,.xls"
            prepend-icon="mdi-file-excel"
            show-size
          ></v-file-input>

          <v-alert v-if="importMessage" :type="importMessageType" class="mt-3">
            {{ importMessage }}
          </v-alert>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn text @click="importDialogVisible = false">Cancel</v-btn>
          <v-btn
            color="primary"
            :loading="isImporting"
            :disabled="!importFile || importFile.length === 0"
            @click="handleImport"
          >
            Import
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- Loading Overlay -->
    <v-overlay v-model="globalLoading" class="align-center justify-center">
      <v-progress-circular indeterminate size="64"></v-progress-circular>
    </v-overlay>
  </v-container>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import { useSnackbar } from '@/composables/useSnackbar';
import {
  getEmployeeList,
  exportEmployeesData,
  importEmployeesData,
  transformFiltersToRequest,
  type EmployeeType,
  type EmployeeSearchFilter,
} from '@/services/employees';
import EmployeeFilterForm from './components/EmployeeFilterForm.vue';
import moment from 'moment';

const router = useRouter();
const route = useRoute();
const { showSuccess, showError } = useSnackbar();

// Data
const employees = ref<EmployeeType[]>([]);
const totalRecords = ref(0);
const loading = ref(false);
const globalLoading = ref(false);
const page = ref(1);
const itemsPerPage = ref(10);
const sortBy = ref<Array<{ key: string; order: 'asc' | 'desc' }>>([]);

// Filters
const showFilters = ref(false);
const hasActiveFilters = ref(false);
const filterFormRef = ref<InstanceType<typeof EmployeeFilterForm> | null>(null);
const initialRoleId = computed(() => (route.query.roleId ? Number(route.query.roleId) : 0));
const fromRolesPage = computed(() => route.query.fromRolesPage === 'true');

const DEFAULT_FILTERS: EmployeeSearchFilter = {
  departmentId: 0,
  designationId: 0,
  roleId: initialRoleId.value,
  employeeStatus: 0,
  employmentStatus: 0,
  branchId: 0,
  dojFrom: null,
  dojTo: null,
  countryId: 0,
};

const employeeFilters = ref<EmployeeSearchFilter>({ ...DEFAULT_FILTERS });

// Employee Search
const selectedEmployees = ref<string[]>([]);
const searchedEmployees = ref<Array<{ label: string; value: string }>>([]);

// Import/Export
const importDialogVisible = ref(false);
const importFile = ref<File[]>([]);
const isImporting = ref(false);
const isExporting = ref(false);
const importMessage = ref('');
const importMessageType = ref<'success' | 'error' | 'info'>('info');

// Table headers
const headers = computed(() => [
  { title: 'Employee Code', key: 'employeeCode', sortable: true },
  { title: 'Employee Name', key: 'employeeName', sortable: true },
  { title: 'DOJ', key: 'joiningDate', sortable: true },
  { title: 'Branch', key: 'branch', sortable: true },
  { title: 'Department', key: 'departmentName', sortable: true },
  { title: 'Designation', key: 'designation', sortable: true },
  { title: 'Mobile No', key: 'phone', sortable: false },
  { title: 'Employee Status', key: 'employeeStatus', sortable: true },
  { title: 'Actions', key: 'actions', sortable: false, width: 120 },
]);

const breadcrumbs = [
  { title: 'Dashboard', to: '/dashboard' },
  { title: 'Employees List', to: '/employees/employee-list', disabled: true },
];

// Branch labels (from legacy constants)
const BRANCH_LOCATION_LABEL: Record<number, string> = {
  1: 'Noida',
  2: 'Jaipur',
  3: 'US',
  4: 'Remote',
};

// Status labels (from legacy constants)
const EMPLOYEE_STATUS_LABEL: Record<number, string> = {
  1: 'Active',
  2: 'Inactive',
  3: 'Exited',
};

// Methods
const formatDate = (dateString: string) => {
  return moment(dateString, 'YYYY-MM-DD').format('MMM Do, YYYY');
};

const getBranchLabel = (branch: number) => {
  return BRANCH_LOCATION_LABEL[branch] || 'Unknown';
};

const getStatusLabel = (status: number) => {
  return EMPLOYEE_STATUS_LABEL[status] || 'Unknown';
};

const mapSortingToApiParams = () => {
  if (sortBy.value.length === 0) {
    return { SortColumnName: 'FirstName', SortDirection: 'asc' };
  }
  const sort = sortBy.value[0];
  return {
    SortColumnName: sort.key === 'employeeName' ? 'FirstName' : sort.key,
    SortDirection: sort.order,
  };
};

const fetchEmployees = async () => {
  loading.value = true;
  try {
    const employeeCodes = selectedEmployees.value.join(',');
    const filters: EmployeeSearchFilter = {
      ...employeeFilters.value,
      employeeCode: employeeCodes,
    };

    const response = await getEmployeeList({
      ...mapSortingToApiParams(),
      StartIndex: (page.value - 1) * itemsPerPage.value + 1,
      PageSize: itemsPerPage.value,
      Filters: transformFiltersToRequest(filters),
    });

    employees.value = response.result?.employeeList || [];
    totalRecords.value = response.result?.totalRecords || 0;
  } catch (error) {
    const axiosError = error as { response?: { data?: { message?: string } } };
    showError(axiosError.response?.data?.message || 'Failed to fetch employees');
  } finally {
    loading.value = false;
  }
};

const handleSearch = (filters: EmployeeSearchFilter) => {
  employeeFilters.value = filters;
  page.value = 1;
};

const handleResetFilters = () => {
  filterFormRef.value?.resetForm();
  employeeFilters.value = { ...DEFAULT_FILTERS };
  hasActiveFilters.value = false;
};

const handleExport = async () => {
  isExporting.value = true;
  try {
    const employeeCodes = selectedEmployees.value.join(',');
    const filters: EmployeeSearchFilter = {
      ...employeeFilters.value,
      employeeCode: employeeCodes,
    };

    const blob = await exportEmployeesData({
      ...mapSortingToApiParams(),
      StartIndex: 0,
      PageSize: 0,
      Filters: transformFiltersToRequest(filters),
    });

    const fileName = 'EmployeeMasterFile.xlsx';
    const blobUrl = URL.createObjectURL(blob);
    const link = document.createElement('a');
    link.href = blobUrl;
    link.setAttribute('download', fileName);
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    URL.revokeObjectURL(blobUrl);

    showSuccess('Export successful');
  } catch (error) {
    const axiosError = error as { response?: { data?: { message?: string } } };
    showError(axiosError.response?.data?.message || 'Failed to export employees');
  } finally {
    isExporting.value = false;
  }
};

const openEmployeeProfile = (employeeId: number) => {
  const profileUrl = `/profile/personal-details?employeeId=${employeeId}`;
  window.open(profileUrl, '_blank');
};

const handleImport = async () => {
  if (!importFile.value || importFile.value.length === 0) return;

  isImporting.value = true;
  importMessage.value = '';
  try {
    const response = await importEmployeesData(importFile.value[0], false);
    importMessage.value = response.message || 'Import successful';
    importMessageType.value = 'success';

    // Refresh the list
    await fetchEmployees();

    setTimeout(() => {
      importDialogVisible.value = false;
      importFile.value = [];
      importMessage.value = '';
    }, 2000);
  } catch (error) {
    const axiosError = error as { response?: { data?: { message?: string } } };
    importMessage.value = axiosError.response?.data?.message || 'Failed to import employees';
    importMessageType.value = 'error';
  } finally {
    isImporting.value = false;
  }
};

// Watchers
watch([page, itemsPerPage, sortBy], () => {
  fetchEmployees();
});

watch(
  () => selectedEmployees.value.length,
  () => {
    fetchEmployees();
  }
);

watch(employeeFilters, () => {
  fetchEmployees();
});

// Lifecycle
onMounted(() => {
  fetchEmployees();
});
</script>

<style scoped>
.border-b {
  border-bottom: 1px solid rgba(0, 0, 0, 0.12);
}
</style>
