<template>
  <div class="leave-requests-table">
    <!-- Filters -->
    <div v-if="showFilters" class="filters-section">
      <v-row>
        <v-col cols="12" md="3">
          <v-text-field
            v-model="filters.fromDate"
            type="date"
            label="From Date"
            variant="outlined"
            density="compact"
          />
        </v-col>
        <v-col cols="12" md="3">
          <v-text-field
            v-model="filters.toDate"
            type="date"
            label="To Date"
            variant="outlined"
            density="compact"
          />
        </v-col>
        <v-col cols="12" md="3">
          <v-select
            v-model="filters.status"
            :items="statusOptions"
            label="Status"
            variant="outlined"
            density="compact"
            clearable
          />
        </v-col>
        <v-col cols="12" md="3">
          <v-text-field
            v-model="filters.employeeId"
            type="number"
            label="Employee ID"
            variant="outlined"
            density="compact"
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
      :items="leaveRequests"
      :items-length="totalRecords"
      :loading="loading"
      class="elevation-1"
      item-value="appliedLeaveId"
    >
      <template #item.sno="{ index }">
        {{ (pagination.pageIndex - 1) * pagination.pageSize + index + 1 }}
      </template>
      <template #item.fromDate="{ item }">
        {{ formatDate(item.fromDate) }}
      </template>
      <template #item.toDate="{ item }">
        {{ formatDate(item.toDate) }}
      </template>
      <template #item.status="{ item }">
        <v-chip :color="getStatusColor(item.status)" size="small">
          {{ item.status }}
        </v-chip>
      </template>
      <template #item.actions="{ item }">
        <v-btn
          v-if="item.status === 'Pending'"
          color="success"
          size="small"
          @click="approveLeave(item)"
        >
          Approve
        </v-btn>
        <v-btn
          v-if="item.status === 'Pending'"
          color="error"
          size="small"
          class="ml-2"
          @click="openRejectDialog(item)"
        >
          Reject
        </v-btn>
      </template>
      <template #no-data>
        <div class="text-center py-4">No leave requests found</div>
      </template>
    </v-data-table-server>

    <!-- Reject Dialog -->
    <v-dialog v-model="rejectDialog" max-width="500px">
      <v-card>
        <v-card-title>Reject Leave Request</v-card-title>
        <v-card-text>
          <v-textarea
            v-model="rejectRemarks"
            label="Remarks (optional)"
            variant="outlined"
            rows="3"
          />
        </v-card-text>
        <v-card-actions>
          <v-spacer />
          <v-btn variant="text" @click="closeRejectDialog">Cancel</v-btn>
          <v-btn color="error" @click="confirmReject">Reject</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- Loading Overlay -->
    <v-overlay v-model="processing" class="align-center justify-center">
      <v-progress-circular indeterminate size="64" />
    </v-overlay>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, watch } from 'vue';
import { approveOrRejectLeave, getAppliedLeaves } from '@/services/leave/leave.service';
import type {
  AppliedLeaveItem,
  SearchRequestDto,
  AppliedLeaveSearchRequest,
  LeaveApprovalDto,
} from '@/types/leave.types';

// State
const leaveRequests = ref<AppliedLeaveItem[]>([]);
const loading = ref(false);
const processing = ref(false);
const totalRecords = ref(0);
const showFilters = ref(false);
const rejectDialog = ref(false);
const rejectRemarks = ref('');
const selectedLeave = ref<AppliedLeaveItem | null>(null);

// Pagination
const pagination = ref({
  pageIndex: 1,
  pageSize: 10,
});

// Filters
const filters = ref<{
  fromDate: string | null;
  toDate: string | null;
  status: string | null;
  employeeId: number | null;
}>({
  fromDate: null,
  toDate: null,
  status: 'Pending',
  employeeId: null,
});

const appliedFilters = ref<AppliedLeaveSearchRequest>({
  fromDate: null,
  toDate: null,
  status: 'Pending',
  employeeId: undefined,
});

const hasActiveFilters = computed(() => {
  return (
    appliedFilters.value.fromDate !== null ||
    appliedFilters.value.toDate !== null ||
    appliedFilters.value.status !== null ||
    appliedFilters.value.employeeId !== undefined
  );
});

// Status options
const statusOptions = [
  { title: 'Pending', value: 'Pending' },
  { title: 'Approved', value: 'Approved' },
  { title: 'Rejected', value: 'Rejected' },
];

// Table headers
const headers = [
  { title: 'S.No', key: 'sno', sortable: false },
  { title: 'Employee Name', key: 'employeeName', sortable: true },
  { title: 'Leave Type', key: 'leaveType', sortable: true },
  { title: 'From Date', key: 'fromDate', sortable: true },
  { title: 'To Date', key: 'toDate', sortable: true },
  { title: 'Total Days', key: 'totalDays', sortable: true },
  { title: 'Status', key: 'status', sortable: true },
  { title: 'Reason', key: 'reason', sortable: false },
  { title: 'Actions', key: 'actions', sortable: false },
];

// Methods
const fetchLeaveRequests = async () => {
  loading.value = true;
  try {
    const searchRequest: SearchRequestDto<AppliedLeaveSearchRequest> = {
      StartIndex: pagination.value.pageIndex,
      PageSize: pagination.value.pageSize,
      Filters: appliedFilters.value,
    };

    const response = await getAppliedLeaves(searchRequest);
    leaveRequests.value = response.data.appliedLeavesList || [];
    totalRecords.value = response.data.totalRecords || 0;
  } catch (err) {
    console.error('Error fetching leave requests:', err);
  } finally {
    loading.value = false;
  }
};

const toggleFilters = () => {
  showFilters.value = !showFilters.value;
};

const applyFilters = () => {
  appliedFilters.value = {
    fromDate: filters.value.fromDate,
    toDate: filters.value.toDate,
    status: filters.value.status,
    employeeId: filters.value.employeeId || undefined,
  };
  pagination.value.pageIndex = 1;
  fetchLeaveRequests();
};

const resetFilters = () => {
  filters.value = {
    fromDate: null,
    toDate: null,
    status: 'Pending',
    employeeId: null,
  };
  applyFilters();
};

const clearFilters = () => {
  resetFilters();
};

const approveLeave = async (leave: AppliedLeaveItem) => {
  processing.value = true;
  try {
    const payload: LeaveApprovalDto = {
      AppliedLeaveId: leave.appliedLeaveId,
      Status: 'Approved',
    };

    await approveOrRejectLeave(payload);
    alert('Leave request approved successfully');
    fetchLeaveRequests();
  } catch (err) {
    console.error('Error approving leave:', err);
    alert('Failed to approve leave request');
  } finally {
    processing.value = false;
  }
};

const openRejectDialog = (leave: AppliedLeaveItem) => {
  selectedLeave.value = leave;
  rejectRemarks.value = '';
  rejectDialog.value = true;
};

const closeRejectDialog = () => {
  rejectDialog.value = false;
  selectedLeave.value = null;
  rejectRemarks.value = '';
};

const confirmReject = async () => {
  if (!selectedLeave.value) return;

  processing.value = true;
  try {
    const payload: LeaveApprovalDto = {
      AppliedLeaveId: selectedLeave.value.appliedLeaveId,
      Status: 'Rejected',
      Remarks: rejectRemarks.value || undefined,
    };

    await approveOrRejectLeave(payload);
    alert('Leave request rejected successfully');
    closeRejectDialog();
    fetchLeaveRequests();
  } catch (err) {
    console.error('Error rejecting leave:', err);
    alert('Failed to reject leave request');
  } finally {
    processing.value = false;
  }
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
    fetchLeaveRequests();
  }
);

// Initial fetch
fetchLeaveRequests();
</script>

<style scoped>
.leave-requests-table {
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
