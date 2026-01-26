<template>
  <div class="leave-history-table">
    <!-- Filters (collapsible) -->
    <div v-if="showFilters" class="filters-section">
      <v-row>
        <v-col cols="12" md="4">
          <v-text-field
            v-model="filters.startDate"
            type="date"
            label="Start Date"
            variant="outlined"
            density="compact"
          />
        </v-col>
        <v-col cols="12" md="4">
          <v-text-field
            v-model="filters.endDate"
            type="date"
            label="End Date"
            variant="outlined"
            density="compact"
          />
        </v-col>
        <v-col cols="12" md="4">
          <v-select
            v-model="filters.leaveType"
            :items="leaveTypeOptions"
            label="Leave Type"
            variant="outlined"
            density="compact"
            clearable
          />
        </v-col>
      </v-row>
      <v-row>
        <v-col cols="12" class="d-flex justify-end">
          <v-btn color="primary" @click="applyFilters">Apply Filters</v-btn>
          <v-btn variant="text" @click="resetFilters" class="ml-2">Reset</v-btn>
        </v-col>
      </v-row>
    </div>

    <!-- Toolbar -->
    <div class="table-toolbar">
      <v-btn variant="text" @click="toggleFilters">
        <v-icon>{{ showFilters ? 'mdi-filter-off' : 'mdi-filter' }}</v-icon>
        {{ showFilters ? 'Hide Filters' : 'Show Filters' }}
      </v-btn>
      <v-btn v-if="hasActiveFilters" variant="text" color="error" @click="clearFilters">
        <v-icon>mdi-close</v-icon>
        Clear Filters
      </v-btn>
    </div>

    <!-- Table -->
    <v-data-table-server
      v-model:items-per-page="pagination.pageSize"
      v-model:page="pagination.pageIndex"
      :headers="headers"
      :items="leaveHistory"
      :items-length="totalRecords"
      :loading="loading"
      class="elevation-1"
      item-value="appliedLeaveId"
    >
      <template #item.fromDate="{ item }">
        {{ formatDate(item.fromDate) }}
      </template>
      <template #item.toDate="{ item }">
        {{ formatDate(item.toDate) }}
      </template>
      <template #item.appliedDate="{ item }">
        {{ formatDate(item.appliedDate) }}
      </template>
      <template #item.status="{ item }">
        <v-chip :color="getStatusColor(item.status)" size="small">
          {{ item.status }}
        </v-chip>
      </template>
      <template #no-data>
        <div class="text-center py-4">No leave history found</div>
      </template>
    </v-data-table-server>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, watch } from 'vue';
import { useAuthStore } from '@/stores/auth.store';
import { getLeaveHistory } from '@/services/leave/leave.service';
import type { LeaveHistoryItem, SearchRequestDto, LeaveHistoryFilter } from '@/types/leave.types';

const authStore = useAuthStore();

// State
const leaveHistory = ref<LeaveHistoryItem[]>([]);
const loading = ref(false);
const totalRecords = ref(0);
const showFilters = ref(false);

// Pagination
const pagination = ref({
  pageIndex: 1,
  pageSize: 10,
});

// Filters
const filters = ref<{
  startDate: string | null;
  endDate: string | null;
  leaveType: number | null;
}>({
  startDate: null,
  endDate: null,
  leaveType: null,
});

const appliedFilters = ref<LeaveHistoryFilter>({
  startDate: null,
  endDate: null,
  leaveType: null,
});

const hasActiveFilters = computed(() => {
  return (
    appliedFilters.value.startDate !== null ||
    appliedFilters.value.endDate !== null ||
    appliedFilters.value.leaveType !== null
  );
});

// Leave type options (hardcoded for now - should match backend leave types)
const leaveTypeOptions = [
  { title: 'Casual Leave', value: 1 },
  { title: 'Sick Leave', value: 2 },
  { title: 'Earned Leave', value: 3 },
  { title: 'Comp Off', value: 4 },
];

// Table headers
const headers = [
  { title: 'S.No', key: 'sno', sortable: false },
  { title: 'Leave Type', key: 'leaveType', sortable: true },
  { title: 'From Date', key: 'fromDate', sortable: true },
  { title: 'To Date', key: 'toDate', sortable: true },
  { title: 'Total Days', key: 'totalDays', sortable: true },
  { title: 'Applied Date', key: 'appliedDate', sortable: true },
  { title: 'Status', key: 'status', sortable: true },
  { title: 'Reason', key: 'reason', sortable: false },
];

// Methods
const fetchLeaveHistory = async () => {
  loading.value = true;
  try {
    const searchRequest: SearchRequestDto<LeaveHistoryFilter> = {
      StartIndex: pagination.value.pageIndex,
      PageSize: pagination.value.pageSize,
      Filters: appliedFilters.value,
    };

    const response = await getLeaveHistory(Number(authStore.userData?.userId), searchRequest);
    leaveHistory.value = response.result.leaveHistory || [];
    totalRecords.value = response.result.totalRecords || 0;
  } catch (err) {
    console.error('Error fetching leave history:', err);
  } finally {
    loading.value = false;
  }
};

const toggleFilters = () => {
  showFilters.value = !showFilters.value;
};

const applyFilters = () => {
  appliedFilters.value = { ...filters.value };
  pagination.value.pageIndex = 1;
  fetchLeaveHistory();
};

const resetFilters = () => {
  filters.value = {
    startDate: null,
    endDate: null,
    leaveType: null,
  };
  applyFilters();
};

const clearFilters = () => {
  resetFilters();
};

const formatDate = (dateString: string) => {
  if (!dateString) return '';
  const date = new Date(dateString);
  return date.toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: 'numeric' });
};

const getStatusColor = (status: string) => {
  switch (status.toLowerCase()) {
    case 'approved':
      return 'success';
    case 'rejected':
      return 'error';
    case 'pending':
      return 'warning';
    default:
      return 'default';
  }
};

// Watch pagination changes
watch(
  () => [pagination.value.pageIndex, pagination.value.pageSize],
  () => {
    fetchLeaveHistory();
  }
);

// Initial fetch
fetchLeaveHistory();
</script>

<style scoped>
.leave-history-table {
  padding: 20px;
}

.filters-section {
  background: #f5f5f5;
  padding: 16px;
  border-radius: 8px;
  margin-bottom: 16px;
}

.table-toolbar {
  display: flex;
  gap: 8px;
  margin-bottom: 16px;
}
</style>
