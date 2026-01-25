<script setup lang="ts">
import { ref, computed, onMounted } from 'vue';
import { useAuthStore } from '@/stores/auth.store';
import { getAttendanceReport } from '@/services/attendance/attendance.service';
import type { AttendanceRow, EditDetails } from '@/types/attendance.types';

/**
 * My Attendance View
 * Matches legacy: /legacy/Frontend/HRMS-Frontend/source/src/pages/Attendance/Employee/index.tsx
 */

const authStore = useAuthStore();

// State
const rows = ref<AttendanceRow[]>([]);
const totalRecords = ref(0);
const isManualAttendance = ref(false);
const isTimedIn = ref(false);
const filledDates = ref<string[]>([]);
const loading = ref(false);
const error = ref<string | null>(null);

// Pagination
const pageIndex = ref(0);
const pageSize = ref(7);

// Filters
const filterStartDate = ref<string>('');
const filterEndDate = ref<string>('');

// Dialogs
const openTimeIn = ref(false);
// const openTimeOut = ref(false); // TODO: Implement Time Out dialog
const editDetails = ref<EditDetails>({
  id: 0,
  date: '',
  startTime: '',
  endTime: '',
  location: '',
  note: '',
  reason: '',
  totalHours: null,
});

// Computed
const showTimeInButton = computed(() => {
  return isManualAttendance.value && !isTimedIn.value;
});

// Fetch attendance data
async function fetchAttendance() {
  if (!authStore.user?.id) return;

  loading.value = true;
  error.value = null;

  try {
    const response = await getAttendanceReport(authStore.user.id, {
      dateFrom: filterStartDate.value || undefined,
      dateTo: filterEndDate.value || undefined,
      pageIndex: pageIndex.value,
      pageSize: pageSize.value,
    });

    if (response.result) {
      rows.value = response.result.attendaceReport || [];
      totalRecords.value = response.result.totalRecords || 0;
      isManualAttendance.value = response.result.isManualAttendance || false;
      isTimedIn.value = response.result.isTimedIn || false;
      filledDates.value = response.result.dates || [];
    }
  } catch (err) {
    error.value = err instanceof Error ? err.message : 'Failed to fetch attendance';
    console.error('Failed to fetch attendance:', err);
  } finally {
    loading.value = false;
  }
}

// Handle Time In button click
function handleTimeInButton() {
  editDetails.value = {
    id: 0,
    date: '',
    startTime: '',
    endTime: '',
    location: '',
    note: '',
    reason: '',
    totalHours: null,
  };
  openTimeIn.value = true;
}

// Handle edit click
function handleEditClick(row: AttendanceRow) {
  editDetails.value = {
    id: row.id,
    date: row.date,
    startTime: row.startTime,
    endTime: row.endTime ?? undefined,
    location: row.location,
    reason: row.audit[0]?.reason || '',
    totalHours: row.totalHours || null,
  };
  openTimeIn.value = true;
}

// Handle filter change
function handleFilterChange(startDate: string, endDate: string) {
  filterStartDate.value = startDate;
  filterEndDate.value = endDate;
  pageIndex.value = 0;
  fetchAttendance();
}

// Handle pagination change
function handlePaginationChange(newPageIndex: number, newPageSize: number) {
  pageIndex.value = newPageIndex;
  pageSize.value = newPageSize;
  fetchAttendance();
}

// Load data on mount
onMounted(() => {
  fetchAttendance();
});
</script>

<template>
  <div class="attendance-page">
    <!-- Breadcrumbs -->
    <nav class="breadcrumbs">
      <span class="breadcrumb-item">Dashboard</span>
      <span class="breadcrumb-separator">/</span>
      <span class="breadcrumb-item active">My Attendance</span>
    </nav>

    <!-- Main Paper Container -->
    <div class="paper-container">
      <!-- Page Header -->
      <div class="page-header">
        <h2>My Attendance</h2>
      </div>

      <!-- Attendance Table Placeholder -->
      <div class="attendance-content">
        <div v-if="loading" class="loading-state">
          <div class="spinner"></div>
          <p>Loading attendance records...</p>
        </div>

        <div v-else-if="error" class="error-state">
          <p class="error-message">{{ error }}</p>
          <button class="retry-button" @click="fetchAttendance">Retry</button>
        </div>

        <div v-else class="attendance-table-container">
          <!-- Toolbar -->
          <div class="table-toolbar">
            <!-- Date Filter -->
            <div class="filter-section">
              <label>Date From:</label>
              <input
                v-model="filterStartDate"
                type="date"
                class="date-input"
                @change="handleFilterChange(filterStartDate, filterEndDate)"
              />

              <label>Date To:</label>
              <input
                v-model="filterEndDate"
                type="date"
                class="date-input"
                @change="handleFilterChange(filterStartDate, filterEndDate)"
              />
            </div>

            <!-- Time In Button -->
            <button v-if="showTimeInButton" class="time-in-button" @click="handleTimeInButton">
              Time In
            </button>
          </div>

          <!-- Attendance Table -->
          <div class="table-wrapper">
            <table class="attendance-table">
              <thead>
                <tr>
                  <th>#</th>
                  <th>Date</th>
                  <th>Day</th>
                  <th>Start Time</th>
                  <th>End Time</th>
                  <th>Location</th>
                  <th>Total Hours</th>
                  <th>Type</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(row, index) in rows" :key="row.id">
                  <td>{{ pageIndex * pageSize + index + 1 }}</td>
                  <td>{{ row.date }}</td>
                  <td>{{ row.day }}</td>
                  <td>{{ row.startTime }}</td>
                  <td>{{ row.endTime || '-' }}</td>
                  <td>{{ row.location }}</td>
                  <td>{{ row.totalHours }}</td>
                  <td>{{ row.attendanceType }}</td>
                  <td>
                    <button
                      v-if="isManualAttendance"
                      class="edit-button"
                      @click="handleEditClick(row)"
                    >
                      Edit
                    </button>
                  </td>
                </tr>
                <tr v-if="rows.length === 0">
                  <td colspan="9" class="no-data">No attendance records found</td>
                </tr>
              </tbody>
            </table>
          </div>

          <!-- Pagination -->
          <div class="pagination">
            <span>Rows per page:</span>
            <select
              v-model="pageSize"
              class="page-size-select"
              @change="handlePaginationChange(pageIndex, pageSize)"
            >
              <option :value="7">7</option>
              <option :value="10">10</option>
              <option :value="25">25</option>
              <option :value="50">50</option>
            </select>

            <span class="pagination-info">
              {{ pageIndex * pageSize + 1 }}-{{
                Math.min((pageIndex + 1) * pageSize, totalRecords)
              }}
              of {{ totalRecords }}
            </span>

            <div class="pagination-controls">
              <button
                class="pagination-button"
                :disabled="pageIndex === 0"
                @click="handlePaginationChange(pageIndex - 1, pageSize)"
              >
                Previous
              </button>
              <button
                class="pagination-button"
                :disabled="(pageIndex + 1) * pageSize >= totalRecords"
                @click="handlePaginationChange(pageIndex + 1, pageSize)"
              >
                Next
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- TODO: Time In Dialog -->
    <!-- TODO: Time Out Dialog -->
  </div>
</template>

<style scoped>
.attendance-page {
  padding: 20px;
}

.breadcrumbs {
  margin-bottom: 20px;
  font-size: 14px;
  color: #666;
}

.breadcrumb-item {
  color: #1e75bb;
}

.breadcrumb-item.active {
  color: #666;
}

.breadcrumb-separator {
  margin: 0 8px;
}

.paper-container {
  background: white;
  border-radius: 4px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  overflow: hidden;
}

.page-header {
  padding: 20px;
  border-bottom: 1px solid #e0e0e0;
}

.page-header h2 {
  margin: 0;
  font-size: 24px;
  font-weight: 500;
  color: #333;
}

.attendance-content {
  padding: 20px;
}

.loading-state,
.error-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 40px;
}

.spinner {
  width: 40px;
  height: 40px;
  border: 4px solid #f3f3f3;
  border-top: 4px solid #1e75bb;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(360deg);
  }
}

.error-message {
  color: #d32f2f;
  margin-bottom: 16px;
}

.retry-button {
  padding: 8px 16px;
  background: #1e75bb;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.retry-button:hover {
  background: #155a8a;
}

.table-toolbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.filter-section {
  display: flex;
  align-items: center;
  gap: 12px;
}

.filter-section label {
  font-size: 14px;
  color: #666;
}

.date-input {
  padding: 8px;
  border: 1px solid #ccc;
  border-radius: 4px;
  font-size: 14px;
}

.time-in-button {
  padding: 8px 24px;
  background: #1e75bb;
  color: white;
  border: none;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
}

.time-in-button:hover {
  background: #155a8a;
}

.table-wrapper {
  overflow-x: auto;
}

.attendance-table {
  width: 100%;
  border-collapse: collapse;
}

.attendance-table th,
.attendance-table td {
  padding: 12px;
  text-align: left;
  border-bottom: 1px solid #e0e0e0;
}

.attendance-table th {
  background: #f5f5f5;
  font-weight: 600;
  color: #333;
  font-size: 14px;
}

.attendance-table td {
  font-size: 14px;
  color: #666;
}

.attendance-table tbody tr:hover {
  background: #f9f9f9;
}

.no-data {
  text-align: center;
  padding: 40px;
  color: #999;
}

.edit-button {
  padding: 4px 12px;
  background: transparent;
  color: #1e75bb;
  border: 1px solid #1e75bb;
  border-radius: 4px;
  font-size: 12px;
  cursor: pointer;
}

.edit-button:hover {
  background: #1e75bb;
  color: white;
}

.pagination {
  display: flex;
  align-items: center;
  justify-content: flex-end;
  gap: 16px;
  margin-top: 20px;
  font-size: 14px;
  color: #666;
}

.page-size-select {
  padding: 4px 8px;
  border: 1px solid #ccc;
  border-radius: 4px;
}

.pagination-controls {
  display: flex;
  gap: 8px;
}

.pagination-button {
  padding: 6px 12px;
  background: white;
  color: #1e75bb;
  border: 1px solid #1e75bb;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
}

.pagination-button:hover:not(:disabled) {
  background: #1e75bb;
  color: white;
}

.pagination-button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}
</style>
