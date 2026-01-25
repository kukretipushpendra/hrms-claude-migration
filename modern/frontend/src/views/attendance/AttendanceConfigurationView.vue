<script setup lang="ts">
import { ref, onMounted, watch } from 'vue';
import {
  getAllAttendanceConfig,
  updateAttendanceConfig,
} from '@/services/attendance/attendance.service';
import type { AttendanceConfigResponse, AttendanceConfigFilter } from '@/types/attendance.types';

/**
 * Attendance Configuration View
 * Matches legacy: /legacy/Frontend/HRMS-Frontend/source/src/pages/Attendance/AttendanceConfiguration/index.tsx
 */

// State
const employees = ref<AttendanceConfigResponse[]>([]);
const totalRecords = ref(0);
const loading = ref(false);
const error = ref<string | null>(null);

// Pagination
const pageIndex = ref(0);
const pageSize = ref(10);

// Filters
const filters = ref<AttendanceConfigFilter>({
  employeeName: '',
  employeeCode: '',
});
const showFilters = ref(false);

// Fetch attendance config
async function fetchConfig() {
  loading.value = true;
  error.value = null;

  try {
    const response = await getAllAttendanceConfig(
      pageIndex.value + 1, // .NET uses 1-based pagination
      pageSize.value,
      filters.value
    );

    if (response.result) {
      employees.value = response.result.attendanceConfigList || [];
      totalRecords.value = response.result.totalRecords || 0;
    }
  } catch (err) {
    error.value = err instanceof Error ? err.message : 'Failed to fetch configuration';
    console.error('Failed to fetch config:', err);
  } finally {
    loading.value = false;
  }
}

// Handle manual toggle
async function handleManualToggle(employeeId: number) {
  try {
    await updateAttendanceConfig(employeeId);

    // Update local state
    employees.value = employees.value.map((row) =>
      row.employeeId === employeeId ? { ...row, isManualAttendance: !row.isManualAttendance } : row
    );
  } catch (err) {
    error.value = err instanceof Error ? err.message : 'Failed to update configuration';
    console.error('Failed to update config:', err);
  }
}

// Handle filter change
function handleFilterChange() {
  pageIndex.value = 0;
  fetchConfig();
}

// Handle pagination change
function handlePaginationChange(newPageIndex: number, newPageSize: number) {
  pageIndex.value = newPageIndex;
  pageSize.value = newPageSize;
  fetchConfig();
}

// Watch for changes
watch([pageIndex, pageSize], () => {
  fetchConfig();
});

// Load data on mount
onMounted(() => {
  fetchConfig();
});
</script>

<template>
  <div class="config-page">
    <!-- Breadcrumbs -->
    <nav class="breadcrumbs">
      <span class="breadcrumb-item">Dashboard</span>
      <span class="breadcrumb-separator">/</span>
      <span class="breadcrumb-item">Attendance</span>
      <span class="breadcrumb-separator">/</span>
      <span class="breadcrumb-item active">Attendance Configuration</span>
    </nav>

    <!-- Main Paper Container -->
    <div class="paper-container">
      <!-- Page Header -->
      <div class="page-header">
        <h2>Attendance Configuration</h2>
      </div>

      <div class="config-content">
        <!-- Toolbar -->
        <div class="table-toolbar">
          <button class="filter-toggle-button" @click="showFilters = !showFilters">
            {{ showFilters ? 'Hide' : 'Show' }} Filters
          </button>
        </div>

        <!-- Filters -->
        <div v-if="showFilters" class="filters-section">
          <div class="filter-group">
            <label>Employee Code:</label>
            <input
              v-model="filters.employeeCode"
              type="text"
              placeholder="Enter employee code"
              class="filter-input"
              @keyup.enter="handleFilterChange"
            />
          </div>

          <div class="filter-group">
            <label>Employee Name:</label>
            <input
              v-model="filters.employeeName"
              type="text"
              placeholder="Enter employee name"
              class="filter-input"
              @keyup.enter="handleFilterChange"
            />
          </div>

          <div class="filter-actions">
            <button class="search-button" @click="handleFilterChange">Search</button>
            <button
              class="reset-button"
              @click="
                filters = { employeeName: '', employeeCode: '' };
                handleFilterChange();
              "
            >
              Reset
            </button>
          </div>
        </div>

        <!-- Loading State -->
        <div v-if="loading" class="loading-state">
          <div class="spinner"></div>
          <p>Loading configuration...</p>
        </div>

        <!-- Error State -->
        <div v-else-if="error" class="error-state">
          <p class="error-message">{{ error }}</p>
          <button class="retry-button" @click="fetchConfig">Retry</button>
        </div>

        <!-- Table -->
        <div v-else class="table-container">
          <div class="table-wrapper">
            <table class="config-table">
              <thead>
                <tr>
                  <th>#</th>
                  <th>Employee Code</th>
                  <th>Employee Name</th>
                  <th>Department</th>
                  <th>Designation</th>
                  <th>Branch</th>
                  <th>Country</th>
                  <th>Manual Attendance</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(emp, index) in employees" :key="emp.employeeId">
                  <td>{{ pageIndex * pageSize + index + 1 }}</td>
                  <td>{{ emp.employeeCode }}</td>
                  <td>{{ emp.employeeName }}</td>
                  <td>{{ emp.department }}</td>
                  <td>{{ emp.designation }}</td>
                  <td>{{ emp.branch }}</td>
                  <td>{{ emp.country }}</td>
                  <td>
                    <label class="switch">
                      <input
                        type="checkbox"
                        :checked="emp.isManualAttendance"
                        @change="handleManualToggle(emp.employeeId)"
                      />
                      <span class="slider"></span>
                    </label>
                  </td>
                </tr>
                <tr v-if="employees.length === 0">
                  <td colspan="8" class="no-data">No employees found</td>
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
              <option :value="10">10</option>
              <option :value="25">25</option>
              <option :value="50">50</option>
              <option :value="100">100</option>
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
  </div>
</template>

<style scoped>
.config-page {
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

.config-content {
  padding: 20px;
}

.table-toolbar {
  margin-bottom: 20px;
}

.filter-toggle-button {
  padding: 8px 16px;
  background: #1e75bb;
  color: white;
  border: none;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
}

.filter-toggle-button:hover {
  background: #155a8a;
}

.filters-section {
  display: flex;
  flex-wrap: wrap;
  gap: 16px;
  padding: 16px;
  background: #f5f5f5;
  border-radius: 4px;
  margin-bottom: 20px;
}

.filter-group {
  display: flex;
  flex-direction: column;
  gap: 4px;
  min-width: 200px;
}

.filter-group label {
  font-size: 12px;
  font-weight: 600;
  color: #666;
}

.filter-input {
  padding: 8px;
  border: 1px solid #ccc;
  border-radius: 4px;
  font-size: 14px;
}

.filter-actions {
  display: flex;
  align-items: flex-end;
  gap: 8px;
}

.search-button {
  padding: 8px 16px;
  background: #1e75bb;
  color: white;
  border: none;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
}

.search-button:hover {
  background: #155a8a;
}

.reset-button {
  padding: 8px 16px;
  background: white;
  color: #666;
  border: 1px solid #ccc;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
}

.reset-button:hover {
  background: #f5f5f5;
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

.table-container {
  margin-top: 20px;
}

.table-wrapper {
  overflow-x: auto;
}

.config-table {
  width: 100%;
  border-collapse: collapse;
}

.config-table th,
.config-table td {
  padding: 12px;
  text-align: left;
  border-bottom: 1px solid #e0e0e0;
}

.config-table th {
  background: #f5f5f5;
  font-weight: 600;
  color: #333;
  font-size: 14px;
}

.config-table td {
  font-size: 14px;
  color: #666;
}

.config-table tbody tr:hover {
  background: #f9f9f9;
}

.no-data {
  text-align: center;
  padding: 40px;
  color: #999;
}

/* Toggle Switch */
.switch {
  position: relative;
  display: inline-block;
  width: 48px;
  height: 24px;
}

.switch input {
  opacity: 0;
  width: 0;
  height: 0;
}

.slider {
  position: absolute;
  cursor: pointer;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: #ccc;
  transition: 0.4s;
  border-radius: 24px;
}

.slider:before {
  position: absolute;
  content: '';
  height: 18px;
  width: 18px;
  left: 3px;
  bottom: 3px;
  background-color: white;
  transition: 0.4s;
  border-radius: 50%;
}

input:checked + .slider {
  background-color: #1e75bb;
}

input:checked + .slider:before {
  transform: translateX(24px);
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
